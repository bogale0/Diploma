<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Method not allowed"]);
$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["task_id"], $data["text"]))
    api_exit(400, ["error" => "Missing fields"]);
$task_id = $data["task_id"];
$text = $data["text"];
if (trim($text) === "") {
    api_exit(400, ["error" => "Text is empty"]);
}

$pdo = db_init();
$user = get_auth_user($pdo);

$tempDir = sys_get_temp_dir() . "/diploma_check_" . bin2hex(random_bytes(8));
if (!mkdir($tempDir, 0700, true)) {
    api_exit(500, ["error" => "Failed to create temp dir"]);
}
$sourceFile = $tempDir . "/main.cpp";
$binaryFile = $tempDir . "/main";
file_put_contents($sourceFile, $text);

$compileCommand = sprintf(
    'PATH=/usr/bin:/bin:$PATH g++ -std=c++17 -O2 -Wall -Wextra -o %s %s 2>&1',
    escapeshellarg($binaryFile),
    escapeshellarg($sourceFile)
);
$compileOutput = shell_exec($compileCommand);
if (!is_file($binaryFile)) {
    rrmdir($tempDir);
    api_exit(200, ["result" => "Ошибка компиляции", "passed_tests" => 0, "total_tests" => 0]);
}

$stmt = $pdo->prepare("select `input`, `output` from `task_tests` where `task_id` = ?");
$stmt->execute([$task_id]);
$tests = $stmt->fetchAll();
$passed = 0;
$total = count($tests);
foreach ($tests as $index => $test) {
    $runCommand = sprintf(
        'printf %s | timeout 2s %s 2>&1',
        escapeshellarg($test["input"]),
        escapeshellarg($binaryFile)
    );

    $programOutput = shell_exec($runCommand);
    if ($programOutput === null || normalize_output($programOutput) !== normalize_output($test["output"])) {
        rrmdir($tempDir);
        api_exit(200, ["result" => "Неправильный ответ", "passed_tests" => $passed, "total_tests" => $total]);
    }
    $passed++;
}

rrmdir($tempDir);

// Mark task as solved, then (if all tasks of the theme solved) complete theme progress.
$task_id_int = (int)$task_id;
$user_id = (int)$user["id"];
$stmt = $pdo->prepare("insert ignore into `user_task_solved` (`user_id`, `task_id`) values (?, ?)");
$stmt->execute([$user_id, $task_id_int]);

$stmt = $pdo->prepare("select `theme_id` from `tasks` where `id` = ?");
$stmt->execute([$task_id_int]);
$taskRow = $stmt->fetch();
if ($taskRow !== false) {
    $theme_id = (int)$taskRow["theme_id"];
    $stmt = $pdo->prepare("select count(*) as `cnt` from `tasks` where `theme_id` = ?");
    $stmt->execute([$theme_id]);
    $totalTasks = (int)($stmt->fetch()["cnt"] ?? 0);

    $stmt = $pdo->prepare(
        "select count(*) as `cnt`
         from `user_task_solved` uts
         join `tasks` t on t.id = uts.task_id
         where uts.user_id = ? and t.theme_id = ?"
    );
    $stmt->execute([$user_id, $theme_id]);
    $solvedTasks = (int)($stmt->fetch()["cnt"] ?? 0);

    if ($totalTasks > 0 && $solvedTasks >= $totalTasks) {
        $stmt = $pdo->prepare(
            "insert into `user_theme_progress` (`user_id`, `theme_id`, `progress_percent`)
             values (?, ?, 100)
             on duplicate key update `progress_percent` = greatest(`progress_percent`, 100)"
        );
        $stmt->execute([$user_id, $theme_id]);
    }
}

api_exit(200, ["result" => "Верное решение", "passed_tests" => $passed, "total_tests" => $total]);

function normalize_output(string $value) : string {
    $value = str_replace(["\r\n", "\r", "\n"], "\n", trim($value));
    return $value;
}

function rrmdir(string $dir) : void {
    if (!is_dir($dir)) {
        return;
    }

    $items = scandir($dir);
    if ($items === false) {
        return;
    }

    foreach ($items as $item) {
        if ($item === "." || $item === "..") {
            continue;
        }

        $path = $dir . DIRECTORY_SEPARATOR . $item;
        if (is_dir($path)) {
            rrmdir($path);
        } else {
            @unlink($path);
        }
    }

    @rmdir($dir);
}
?>

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

$stmt = $pdo->prepare(
    "select l.id as lang_id, l.name as lang_name
     from tasks t
     join themes th on th.id = t.theme_id
     join languages l on l.id = th.lang_id
     where t.id = ?
     limit 1"
);
$stmt->execute([(int)$task_id]);
$langRow = $stmt->fetch();
if ($langRow === false) {
    api_exit(404, ["error" => "Task not found"]);
}
$lang_id = (int)$langRow["lang_id"];

$tempDir = sys_get_temp_dir() . "/diploma_check_" . bin2hex(random_bytes(8));
if (!mkdir($tempDir, 0700, true)) {
    api_exit(500, ["error" => "Failed to create temp dir"]);
}
$build = build_user_code($tempDir, $lang_id, $text);
if ($build["ok"] !== true) {
    rrmdir($tempDir);
    api_exit(200, ["result" => $build["result"], "passed_tests" => 0, "total_tests" => 0]);
}
$runCommandTemplate = $build["runCommandTemplate"];

$stmt = $pdo->prepare("select `input`, `output` from `task_tests` where `task_id` = ?");
$stmt->execute([$task_id]);
$tests = $stmt->fetchAll();
$passed = 0;
$total = count($tests);
foreach ($tests as $index => $test) {
    $runCommand = sprintf($runCommandTemplate, escapeshellarg($test["input"]));

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

function build_user_code(string $tempDir, int $lang_id, string $text) : array {
    $tempDirArg = escapeshellarg($tempDir);
    $pathPrefix = "PATH=/usr/bin:/bin:/usr/local/bin:\$PATH";

    switch ($lang_id) {
    case 1: { // C++
        $sourceFile = $tempDir . "/main.cpp";
        $binaryFile = $tempDir . "/main";
        file_put_contents($sourceFile, $text);
        $compileCommand = sprintf(
            '%s timeout 12s g++ -std=c++17 -O2 -Wall -Wextra -o %s %s 2>&1',
            $pathPrefix,
            escapeshellarg($binaryFile),
            escapeshellarg($sourceFile)
        );
        shell_exec($compileCommand);
        if (!is_file($binaryFile)) {
            return ["ok" => false, "result" => "Ошибка компиляции"];
        }
        return [
            "ok" => true,
            "runCommandTemplate" => 'cd ' . $tempDirArg . ' && printf %s | timeout 2s ./main 2>&1'
        ];
    }
    case 2: { // Python
        $sourceFile = $tempDir . "/main.py";
        file_put_contents($sourceFile, $text);
        $pythonPath = trim((string)shell_exec($pathPrefix . " command -v python3 2>/dev/null"));
        if ($pythonPath === "") {
            return ["ok" => false, "result" => "Python не установлен на сервере"];
        }
        return [
            "ok" => true,
            "runCommandTemplate" => 'cd ' . $tempDirArg . ' && printf %s | timeout 2s python3 -I -S main.py 2>&1'
        ];
    }
    case 3: { // C#
        $sourceFile = $tempDir . "/Program.cs";
        $exeFile = $tempDir . "/main.exe";
        file_put_contents($sourceFile, $text);

        $monoPath = trim((string)shell_exec($pathPrefix . " command -v mono 2>/dev/null"));
        if ($monoPath === "") {
            return ["ok" => false, "result" => "Mono (C# runtime) не установлен на сервере"];
        }

        $compileCommands = [
            sprintf('%s timeout 12s mcs -optimize+ -out:%s %s 2>&1', $pathPrefix, escapeshellarg($exeFile), escapeshellarg($sourceFile)),
            sprintf('%s timeout 12s csc -nologo -optimize+ -out:%s %s 2>&1', $pathPrefix, escapeshellarg($exeFile), escapeshellarg($sourceFile)),
        ];
        foreach ($compileCommands as $cmd) {
            shell_exec($cmd);
            if (is_file($exeFile)) {
                break;
            }
        }
        if (!is_file($exeFile)) {
            return ["ok" => false, "result" => "Ошибка компиляции"];
        }
        return [
            "ok" => true,
            "runCommandTemplate" => 'cd ' . $tempDirArg . ' && printf %s | timeout 2s mono ./main.exe 2>&1'
        ];
    }
    case 4: { // Go
        $sourceFile = $tempDir . "/main.go";
        $binaryFile = $tempDir . "/main";
        file_put_contents($sourceFile, $text);

        $goPath = trim((string)shell_exec($pathPrefix . " command -v go 2>/dev/null"));
        if ($goPath === "") {
            return ["ok" => false, "result" => "Go не установлен на сервере"];
        }

        $compileCommand = sprintf(
            '%s timeout 12s sh -lc %s 2>&1',
            $pathPrefix,
            escapeshellarg('cd ' . $tempDir . ' && go build -o main main.go')
        );
        shell_exec($compileCommand);
        if (!is_file($binaryFile)) {
            return ["ok" => false, "result" => "Ошибка компиляции"];
        }
        return [
            "ok" => true,
            "runCommandTemplate" => 'cd ' . $tempDirArg . ' && printf %s | timeout 2s ./main 2>&1'
        ];
    }
    default:
        return ["ok" => false, "result" => "Неизвестный язык"];
    }
}

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

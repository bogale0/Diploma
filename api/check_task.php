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
    api_exit(200, ["result" => "Ошибка компиляции"]);
}

$pdo = db_init();
$stmt = $pdo->prepare("select `input`, `output` from `task_tests` where `task_id` = ?");
$stmt->execute([$task_id]);
$tests = $stmt->fetchAll();
foreach ($tests as $index => $test) {
    $runCommand = sprintf(
        'printf %s | timeout 2s %s 2>&1',
        escapeshellarg($test["input"]),
        escapeshellarg($binaryFile)
    );

    $programOutput = shell_exec($runCommand);
    if ($programOutput === null || normalize_output($programOutput) !== normalize_output($test["output"])) {
        rrmdir($tempDir);
        api_exit(200, ["result" => "Неправильный ответ"]);
    }
}

rrmdir($tempDir);
api_exit(200, ["result" => "Верное решение"]);

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

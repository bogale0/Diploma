<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Method not allowed"]);

$pdo = db_init();
// Any code execution is allowed only for authenticated users (bearer token stored in sessions).
get_auth_user($pdo);

$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["text"], $data["input"]))
    api_exit(400, ["error" => "Missing fields"]);
$text = $data["text"];
$input = $data["input"];
$task_id = isset($data["task_id"]) ? (int)$data["task_id"] : 0;
$language_id = isset($data["language_id"]) ? (int)$data["language_id"] : 0;
if (trim($text) === "")
    api_exit(400, ["error" => "Text is empty"]);

$tempDir = sys_get_temp_dir() . "/diploma_run_" . bin2hex(random_bytes(8));
if (!mkdir($tempDir, 0700, true))
    api_exit(500, ["error" => "Failed to create temp dir"]);
$lang_id = 1;
if ($task_id > 0) {
    $stmt = $pdo->prepare(
        "select l.id as lang_id
         from tasks t
         join themes th on th.id = t.theme_id
         join languages l on l.id = th.lang_id
         where t.id = ?
         limit 1"
    );
    $stmt->execute([$task_id]);
    $row = $stmt->fetch();
    if ($row !== false) {
        $lang_id = (int)$row["lang_id"];
    }
} else if ($language_id > 0) {
    $lang_id = $language_id;
}

$build = build_user_code($tempDir, $lang_id, $text);
if ($build["ok"] !== true) {
    rrmdir($tempDir);
    api_exit(200, ["result" => $build["result"]]);
}
$runCommandTemplate = $build["runCommandTemplate"];

$runCommand = sprintf($runCommandTemplate, escapeshellarg($input));
$programOutput = shell_exec($runCommand);
rrmdir($tempDir);

if ($programOutput === null) {
    api_exit(200, ["result" => "Ошибка выполнения"]);
}

api_exit(200, ["result" => "Успешно", "output" => $programOutput]);

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

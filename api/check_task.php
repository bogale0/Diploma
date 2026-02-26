<?php
require_once "functions.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    api_exit(405, ["error" => "Method not allowed"]);
}

$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["code"]) || !is_string($data["code"])) {
    api_exit(400, ["error" => "Missing or invalid code"]);
}
if (!isset($data["user_id"], $data["theme_id"]) || !is_int($data["user_id"]) || !is_int($data["theme_id"]) || $data["user_id"] <= 0 || $data["theme_id"] <= 0) {
    api_exit(400, ["error" => "Missing or invalid user_id/theme_id"]);
}

$userId = $data["user_id"];
$themeId = $data["theme_id"];
$code = $data["code"];
if (trim($code) === "") {
    api_exit(400, ["error" => "Code is empty"]);
}

$tests = [
    [
        "input" => "2 3\n",
        "expected" => "5\n"
    ],
    [
        "input" => "10 -5\n",
        "expected" => "5\n"
    ]
];

$tempDir = sys_get_temp_dir() . "/diploma_check_" . bin2hex(random_bytes(8));
if (!mkdir($tempDir, 0700, true)) {
    api_exit(500, ["error" => "Failed to create temp dir"]);
}

$sourceFile = $tempDir . "/main.cpp";
$binaryFile = $tempDir . "/main";
file_put_contents($sourceFile, $code);

$compileCommand = sprintf(
    'g++ -std=c++17 -O2 -Wall -Wextra -o %s %s 2>&1',
    escapeshellarg($binaryFile),
    escapeshellarg($sourceFile)
);
$compileOutput = shell_exec($compileCommand);
if (!is_file($binaryFile)) {
    $pdo = db_init();
    ensure_progress_table($pdo);
    set_progress($pdo, $userId, $themeId, 0);

    rrmdir($tempDir);
    api_exit(422, [
        "status" => "compile_error",
        "error" => trim((string)$compileOutput)
    ]);
}

foreach ($tests as $index => $test) {
    $runCommand = sprintf(
        'printf %s | timeout 2s %s 2>&1',
        escapeshellarg($test["input"]),
        escapeshellarg($binaryFile)
    );
    $programOutput = shell_exec($runCommand);
    if ($programOutput === null) {
        $pdo = db_init();
        ensure_progress_table($pdo);
        set_progress($pdo, $userId, $themeId, 0);

        rrmdir($tempDir);
        api_exit(422, [
            "status" => "runtime_error",
            "error" => "Program runtime error on test " . ($index + 1)
        ]);
    }

    if (normalize_output($programOutput) !== normalize_output($test["expected"])) {
        $pdo = db_init();
        ensure_progress_table($pdo);
        set_progress($pdo, $userId, $themeId, 0);

        rrmdir($tempDir);
        api_exit(200, [
            "status" => "wrong_answer",
            "message" => "Неверно"
        ]);
    }
}

$pdo = db_init();
ensure_progress_table($pdo);
set_progress($pdo, $userId, $themeId, 33);

rrmdir($tempDir);
api_exit(200, [
    "status" => "ok",
    "message" => "Успех"
]);

function normalize_output(string $value) : string {
    $value = str_replace(["\r\n", "\r"], "\n", trim($value));
    return $value;
}

function set_progress(PDO $pdo, int $userId, int $themeId, int $percent) : void {
    $stmt = $pdo->prepare("insert into user_theme_progress (user_id, theme_id, progress_percent) values (?, ?, ?) on duplicate key update progress_percent = values(progress_percent)");
    $stmt->execute([$userId, $themeId, $percent]);
}

function ensure_progress_table(PDO $pdo) : void {
    $pdo->exec(
        "create table if not exists user_theme_progress (
            user_id int not null,
            theme_id int not null,
            progress_percent tinyint unsigned not null default 0,
            updated_at timestamp not null default current_timestamp on update current_timestamp,
            primary key (user_id, theme_id)
        )"
    );
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

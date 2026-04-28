<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Method not allowed"]);

$pdo = db_init();
require_teacher($pdo);

$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["theme_id"], $data["task"], $data["public_input"], $data["public_output"]))
    api_exit(400, ["error" => "Missing fields"]);

$theme_id = (int)$data["theme_id"];
$task = trim((string)$data["task"]);
$public_input = (string)$data["public_input"];
$public_output = (string)$data["public_output"];

if ($theme_id <= 0 || $task === "")
    api_exit(400, ["error" => "Invalid fields"]);

$stmt = $pdo->prepare("select `id` from `themes` where `id` = ?");
$stmt->execute([$theme_id]);
if ($stmt->fetch() === false)
    api_exit(404, ["error" => "Theme not found"]);

$stmt = $pdo->prepare("insert into `tasks` (`theme_id`, `task`) values (?, ?)");
$stmt->execute([$theme_id, $task]);
$task_id = (int)$pdo->lastInsertId();

$stmt = $pdo->prepare("insert into `task_tests` (`task_id`, `input`, `output`) values (?, ?, ?)");
$stmt->execute([$task_id, $public_input, $public_output]);

api_exit(200, ["task_id" => $task_id]);
?>

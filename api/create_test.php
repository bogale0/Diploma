<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Method not allowed"]);

$pdo = db_init();
require_teacher($pdo);

$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["task_id"], $data["input"], $data["output"]))
    api_exit(400, ["error" => "Missing fields"]);

$task_id = (int)$data["task_id"];
$input = (string)$data["input"];
$output = (string)$data["output"];

if ($task_id <= 0 || trim($input) === "" || trim($output) === "")
    api_exit(400, ["error" => "Invalid fields"]);

$stmt = $pdo->prepare("select `id` from `tasks` where `id` = ?");
$stmt->execute([$task_id]);
if ($stmt->fetch() === false)
    api_exit(404, ["error" => "Task not found"]);

$stmt = $pdo->prepare("insert into `task_tests` (`task_id`, `input`, `output`) values (?, ?, ?)");
$stmt->execute([$task_id, $input, $output]);

api_exit(200, ["test_id" => (int)$pdo->lastInsertId()]);
?>

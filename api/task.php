<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "GET")
    api_exit(405, ["error" => "Метод не поддерживается"]);
if (!isset($_GET["task_id"]))
    api_exit(400, ["error" => "Не заполнены обязательные поля"]);
$task_id = $_GET["task_id"];
$pdo = db_init();

$stmt = $pdo->prepare("select `task` from `tasks` where `id` = ?");
$stmt->execute([$task_id]);
$task = $stmt->fetch();
if ($task === false) {
    api_exit(404, ["error" => "Задача не найдена"]);
}

$stmt = $pdo->prepare("select `input`, `output` from `task_tests` where `task_id` = ? order by `id` asc limit 1");
$stmt->execute([$task_id]);
$public_test = $stmt->fetch();

api_exit(200, [
    "task" => $task["task"],
    "public_input" => $public_test !== false ? $public_test["input"] : "",
    "public_output" => $public_test !== false ? $public_test["output"] : ""
]);
?>

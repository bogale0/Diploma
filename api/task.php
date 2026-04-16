<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "GET")
    api_exit(405, ["error" => "Method not allowed"]);
if (!isset($_GET["task_id"]))
    api_exit(400, ["error" => "Missing fields"]);
$stmt = db_init()->prepare("select `task` from `tasks` where `id` = ?");
$stmt->execute([$_GET["task_id"]]);
api_exit(200, $stmt->fetch());
?>

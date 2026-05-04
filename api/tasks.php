<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "GET")
    api_exit(405, ["error" => "Method not allowed"]);
if (!isset($_GET["theme_id"]))
    api_exit(400, ["error" => "Missing fields"]);

$theme_id = (int)$_GET["theme_id"];
if ($theme_id <= 0)
    api_exit(400, ["error" => "Invalid fields"]);

$pdo = db_init();
$stmt = $pdo->prepare("select `id`, concat('Задание #', `id`) as `text` from `tasks` where `theme_id` = ? order by `id` asc");
$stmt->execute([$theme_id]);
api_exit(200, ["tasks" => $stmt->fetchAll()]);
?>

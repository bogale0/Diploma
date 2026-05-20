<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "GET")
    api_exit(405, ["error" => "Метод не поддерживается"]);
if (!isset($_GET["theme_id"]))
    api_exit(400, ["error" => "Не заполнены обязательные поля"]);
$theme_id = $_GET["theme_id"];

$pdo = db_init();
$stmt = $pdo->prepare("select `theory` from `themes` where `id` = ?");
$stmt->execute([$theme_id]);
$result = $stmt->fetch();
$stmt = $pdo->prepare("select `id` from `tasks` where `theme_id` = ?");
$stmt->execute([$theme_id]);
$result["tasks"] = $stmt->fetchAll();
api_exit(200, $result);
?>

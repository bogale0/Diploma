<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Метод не поддерживается"]);

$pdo = db_init();
require_teacher($pdo);

$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["name"], $data["short_description"], $data["photo_url"]))
    api_exit(400, ["error" => "Не заполнены обязательные поля"]);

$name = trim((string)$data["name"]);
$short = trim((string)$data["short_description"]);
$photo = trim((string)$data["photo_url"]);

if ($name === "")
    api_exit(400, ["error" => "Некорректные поля"]);

$stmt = $pdo->prepare("insert into `languages` (`name`, `short_description`, `photo_url`) values (?, ?, ?)");
$stmt->execute([$name, $short !== "" ? $short : null, $photo !== "" ? $photo : null]);

api_exit(200, ["language_id" => (int)$pdo->lastInsertId()]);
?>

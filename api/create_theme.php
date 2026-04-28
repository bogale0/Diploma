<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Method not allowed"]);

$pdo = db_init();
require_teacher($pdo);

$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["lang_id"], $data["topic"], $data["theory"]))
    api_exit(400, ["error" => "Missing fields"]);

$lang_id = (int)$data["lang_id"];
$topic = trim((string)$data["topic"]);
$theory = trim((string)$data["theory"]);

if ($lang_id <= 0 || $topic === "" || $theory === "")
    api_exit(400, ["error" => "Invalid fields"]);

$stmt = $pdo->prepare("select `id` from `languages` where `id` = ?");
$stmt->execute([$lang_id]);
if ($stmt->fetch() === false)
    api_exit(404, ["error" => "Course not found"]);

$stmt = $pdo->prepare("insert into `themes` (`lang_id`, `topic`, `theory`) values (?, ?, ?)");
$stmt->execute([$lang_id, $topic, $theory]);

api_exit(200, ["theme_id" => (int)$pdo->lastInsertId()]);
?>

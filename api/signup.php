<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Method not allowed"]);
$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["name"]) || !isset($data["password"]))
    api_exit(400, ["error" => "Missing fields"]);
$name = $data["name"];
$password = $data["password"];
if (strlen($name) < 3 || !preg_match("/^[a-zA-Z0-9_-]+$/", $name) || strlen($password) < 4)
    api_exit(400, ["error" => "Invalid input"]);

$pdo = db_init();
$stmt = $pdo->prepare("select 1 from users where name = ?");
$stmt->execute([$name]);
if ($stmt->fetch() !== false)
    api_exit(409, ["error" => "User already exists"]);
$hash = password_hash($password, PASSWORD_DEFAULT);
$stmt = $pdo->prepare("insert into users (name, password) values (?, ?)");
$stmt->execute([$name, $hash]);
api_exit(201, ["user_id" => $pdo->lastInsertId()]);
?>
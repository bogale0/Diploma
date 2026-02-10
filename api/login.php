<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Method not allowed"]);
$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["name"], $data["password"]))
    api_exit(400, ["error" => "Missing fields"]);
$name = $data["name"];
$password = $data["password"];

$pdo = db_init();
$stmt = $pdo->prepare("select id, password from users where name = ?");
$stmt->execute([$name]);
$user = $stmt->fetch();
if ($user === false || !password_verify($password, $user["password"]))
    api_exit(401, ["error" => "Invalid credentials"]);
api_exit(200, ["user_id" => $user["id"]]);
?>
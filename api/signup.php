<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Method not allowed"]);
$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["name"], $data["password"]))
    api_exit(400, ["error" => "Missing fields"]);
$name = $data["name"];
$password = $data["password"];
if (!preg_match("/^[a-zA-Z0-9_-]+$/", $name))
    api_exit(400, ["error" => "Invalid symbols"]);

$hash = password_hash($password, PASSWORD_DEFAULT);
$token = random_bytes(15);
try {
    $pdo = db_init();
    $stmt = $pdo->prepare("insert into `users` (`name`, `password_hash`) values (?, ?)");
    $stmt->execute([$name, $hash]);
    $user_id = $pdo->lastInsertId();
    $stmt = $pdo->prepare("insert into `sessions` (`bearer_token`, `user_id`) values (?, ?)");
    $stmt->execute([$token, $user_id]);
} catch (PDOException $e) {
    if ($e->getCode() == 23000)
        api_exit(409, ["error" => "User already exists"]);
    throw $e;
}
api_exit(200, ["bearer_token" => strtr(base64_encode($token), '+/', '-_')]);
?>
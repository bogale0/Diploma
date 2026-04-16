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
$stmt = $pdo->prepare("select id, password_hash from users where name = ?");
$stmt->execute([$name]);
$user = $stmt->fetch();
if ($user === false || !password_verify($password, $user["password_hash"]))
    api_exit(401, ["error" => "Invalid credentials"]);

$pdo->exec("delete from sessions where created_at < (now() - interval 4 hour)");
$token = random_bytes(15);
$stmt = $pdo->prepare("insert into sessions (bearer_token, user_id) values (?, ?)");
$stmt->execute([$token, $user["id"]]);
api_exit(200, ["bearer_token" => strtr(base64_encode($token), '+/', '-_')]);
?>

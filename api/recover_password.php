<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Method not allowed"]);

$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["name"], $data["recovery"], $data["new_password"]))
    api_exit(400, ["error" => "Missing fields"]);

$name = (string)$data["name"];
$recovery = (string)$data["recovery"];
$new_password = (string)$data["new_password"];
if (trim($name) === "" || trim($recovery) === "" || trim($new_password) === "")
    api_exit(400, ["error" => "Invalid fields"]);

$pdo = db_init();
$stmt = $pdo->prepare("select `id`, `recovery_hash` from `users` where `name` = ? limit 1");
$stmt->execute([$name]);
$user = $stmt->fetch();
if ($user === false || !isset($user["recovery_hash"]) || $user["recovery_hash"] === null)
    api_exit(404, ["error" => "User not found"]);

if (!password_verify($recovery, $user["recovery_hash"]))
    api_exit(401, ["error" => "Invalid recovery field"]);

$new_hash = password_hash($new_password, PASSWORD_DEFAULT);
$stmt = $pdo->prepare("update `users` set `password_hash` = ? where `id` = ?");
$stmt->execute([$new_hash, (int)$user["id"]]);

$stmt = $pdo->prepare("delete from `sessions` where `user_id` = ?");
$stmt->execute([(int)$user["id"]]);

api_exit(200, ["result" => "ok"]);
?>

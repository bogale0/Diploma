<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "POST")
    api_exit(405, ["error" => "Метод не поддерживается"]);
$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data["name"], $data["password"], $data["recovery"]))
    api_exit(400, ["error" => "Не заполнены обязательные поля"]);
$name = $data["name"];
$password = $data["password"];
$recovery = (string)$data["recovery"];
$role = $data["role"] ?? "student";
if (!preg_match("/^[a-zA-Z0-9_-]+$/", $name))
    api_exit(400, ["error" => "Недопустимые символы"]);
if (!in_array($role, ["student", "teacher"], true))
    api_exit(400, ["error" => "Недопустимая роль"]);
if (trim($recovery) === "")
    api_exit(400, ["error" => "Проверочное слово не заполнено"]);

$hash = password_hash($password, PASSWORD_DEFAULT);
$recovery_hash = password_hash($recovery, PASSWORD_DEFAULT);
$token = random_bytes(15);
try {
    $pdo = db_init();
    $stmt = $pdo->prepare("insert into `users` (`name`, `password_hash`, `recovery_hash`, `role`) values (?, ?, ?, ?)");
    $stmt->execute([$name, $hash, $recovery_hash, $role]);
    $user_id = (int)$pdo->lastInsertId();
    $stmt = $pdo->prepare("insert into `sessions` (`bearer_token`, `user_id`) values (?, ?)");
    $stmt->execute([$token, $user_id]);
} catch (PDOException $e) {
    if ($e->getCode() == 23000)
        api_exit(409, ["error" => "Пользователь уже существует"]);
    throw $e;
}
api_exit(200, [
    "bearer_token" => strtr(base64_encode($token), '+/', '-_'),
    "role" => $role
]);
?>

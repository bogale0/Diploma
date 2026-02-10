<?php
function api_exit(int $error_code, array $response) : void {
    http_response_code($error_code);
    header("Content-Type: application/json; charset=utf-8");
    echo json_encode($response);
    exit;
}

function db_init() : PDO {
    $password = trim(file_get_contents(__DIR__ . "/../secret/dbuser.pswd"));
    $pdo = new PDO("mysql:host=localhost;dbname=diploma;charset=utf8mb4", "diploma", $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
    return $pdo;
}
?>
<?php
function api_exit(int $error_code, array $response) : void {
    http_response_code($error_code);
    header("Content-Type: application/json; charset=utf-8");
    echo json_encode($response);
    exit;
}

function db_init() : PDO {
    $password = trim(file_get_contents(__DIR__ . "/../../secret/Diploma/dbuser.pswd"));
    $pdo = new PDO("mysql:host=localhost;dbname=Diploma;charset=utf8mb4", "Diploma", $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
    return $pdo;
}

function get_auth_user(PDO $pdo) : array {
    $authHeader = $_SERVER['HTTP_AUTHORIZATION'];
    if (strpos($authHeader, "Bearer ") !== 0) {
        api_exit(401, ["error" => "Missing bearer authHeader: $authHeader " . json_encode(getallheaders())]);
    }
    $token = trim(substr($authHeader, strlen("Bearer ")));
    if ($token === "") {
        api_exit(401, ["error" => "Missing bearer token: $token"]);
    }

    $tokenBytes = base64_decode(strtr($token, '-_', '+/'), true);
    if ($tokenBytes === false || strlen($tokenBytes) !== 15) {
        api_exit(401, ["error" => "Invalid bearer token"]);
    }

    $stmt = $pdo->prepare(
        "select users.id, users.name, users.role
         from sessions
         join users on users.id = sessions.user_id
         where sessions.bearer_token = ?
           and sessions.created_at >= (now() - interval 4 hour)
         limit 1"
    );
    $stmt->execute([$tokenBytes]);
    $user = $stmt->fetch();
    if ($user === false) {
        api_exit(401, ["error" => "Session expired"]);
    }

    return $user;
}

function require_teacher(PDO $pdo) : array {
    $user = get_auth_user($pdo);
    if (($user["role"] ?? "") !== "teacher") {
        api_exit(403, ["error" => "Teacher role required"]);
    }
    return $user;
}
?>

<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "GET")
    api_exit(405, ["error" => "Method not allowed"]);
if (!isset($_GET["theme_id"]))
    api_exit(400, ["error" => "Missing fields"]);
$stmt = db_init()->prepare("select theory, task from themes where id = ?");
$stmt->execute([$_GET["theme_id"]]);
api_exit(200, $stmt->fetch());
?>

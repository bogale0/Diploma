<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "GET")
    api_exit(405, ["error" => "Method not allowed"]);
if (!isset($_GET["lang_id"]))
    api_exit(400, ["error" => "Missing fields"]);
$stmt = db_init()->prepare("select `id`, `topic` as `text` from `themes` where `lang_id` = ?");
$stmt->execute([$_GET["lang_id"]]);
api_exit(200, ["themes" => $stmt->fetchAll()]);
?>

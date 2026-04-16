<?php
require_once "functions.php";
if ($_SERVER["REQUEST_METHOD"] !== "GET")
    api_exit(405, ["error" => "Method not allowed"]);
api_exit(200, ["languages" => db_init()->query("select `id`, `name` as `text` from `languages`")->fetchAll()]);
?>

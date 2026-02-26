<?php
require_once "functions.php";

if ($_SERVER["REQUEST_METHOD"] !== "GET") {
    api_exit(405, ["error" => "Method not allowed"]);
}

$userId = filter_input(INPUT_GET, "user_id", FILTER_VALIDATE_INT);
if ($userId === false || $userId === null || $userId <= 0) {
    api_exit(400, ["error" => "Invalid user_id"]);
}

$themes = [
    ["id" => 1, "name" => "Основы синтаксиса и переменные"],
    ["id" => 2, "name" => "Условия и циклы"],
    ["id" => 3, "name" => "Функции и массивы"]
];

$pdo = db_init();
ensure_progress_table($pdo);

$stmt = $pdo->prepare("select theme_id, progress_percent from user_theme_progress where user_id = ?");
$stmt->execute([$userId]);
$rows = $stmt->fetchAll();

$progressByTheme = [];
foreach ($rows as $row) {
    $progressByTheme[(int)$row["theme_id"]] = (int)$row["progress_percent"];
}

$completedThemes = [];
$pendingThemes = [];
$totalPercent = 0;

foreach ($themes as $theme) {
    $themeProgress = $progressByTheme[$theme["id"]] ?? 0;
    $totalPercent += $themeProgress;

    if ($themeProgress >= 33) {
        $completedThemes[] = $theme;
    } else {
        $pendingThemes[] = $theme;
    }
}

$overallProgress = (int)round($totalPercent / max(count($themes), 1));

api_exit(200, [
    "overall_progress" => $overallProgress,
    "completed_themes" => $completedThemes,
    "pending_themes" => $pendingThemes
]);

function ensure_progress_table(PDO $pdo) : void {
    $pdo->exec(
        "create table if not exists user_theme_progress (
            user_id int not null,
            theme_id int not null,
            progress_percent tinyint unsigned not null default 0,
            updated_at timestamp not null default current_timestamp on update current_timestamp,
            primary key (user_id, theme_id)
        )"
    );
}
?>

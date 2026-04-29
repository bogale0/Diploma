<?php
require_once "functions.php";

if ($_SERVER["REQUEST_METHOD"] !== "GET") {
    api_exit(405, ["error" => "Method not allowed"]);
}

$pdo = db_init();
$user = get_auth_user($pdo);

$stmt = $pdo->prepare(
    "select t.id, t.topic,
        coalesce(max(case when utp.user_id = ? then utp.progress_percent end), 0) as progress_percent
     from themes t
     left join user_theme_progress utp on utp.theme_id = t.id
     group by t.id, t.topic
     order by t.id"
);
$stmt->execute([(int)$user["id"]]);
$rows = $stmt->fetchAll();

$completedThemes = [];
$pendingThemes = [];
$totalPercent = 0;

foreach ($rows as $row) {
    $themeProgress = (int)$row["progress_percent"];
    $theme = ["id" => (int)$row["id"], "topic" => $row["topic"]];
    $totalPercent += $themeProgress;

    if ($themeProgress >= 100) {
        $completedThemes[] = $theme;
    } else {
        $pendingThemes[] = $theme;
    }
}

$overallProgress = count($rows) > 0 ? (int)round($totalPercent / count($rows)) : 0;

api_exit(200, [
    "overall_progress" => $overallProgress,
    "completed_themes" => $completedThemes,
    "pending_themes" => $pendingThemes
]);
?>

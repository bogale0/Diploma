<?php
require_once "functions.php";

if ($_SERVER["REQUEST_METHOD"] !== "GET") {
    api_exit(405, ["error" => "Метод не поддерживается"]);
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

// Courses (languages) progress: completed themes / total themes per language
$stmt = $pdo->prepare(
    "select l.id, l.name,
        count(t.id) as total_themes,
        sum(case when coalesce(utp.progress_percent, 0) >= 100 then 1 else 0 end) as completed_themes
     from languages l
     left join themes t on t.lang_id = l.id
     left join user_theme_progress utp on utp.theme_id = t.id and utp.user_id = ?
     group by l.id, l.name
     order by l.id"
);
$stmt->execute([(int)$user["id"]]);
$courseRows = $stmt->fetchAll();
$courses = [];
foreach ($courseRows as $row) {
    $total = (int)$row["total_themes"];
    $completed = (int)$row["completed_themes"];
    $percent = $total > 0 ? (int)floor(($completed * 100) / $total) : 0;
    $courses[] = [
        "id" => (int)$row["id"],
        "text" => $row["name"],
        "completed_lessons" => $completed,
        "total_lessons" => $total,
        "progress_percent" => $percent
    ];
}

api_exit(200, [
    "overall_progress" => $overallProgress,
    "completed_themes" => $completedThemes,
    "pending_themes" => $pendingThemes,
    "courses" => $courses
]);
?>

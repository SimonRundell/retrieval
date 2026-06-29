<?php
/**
 * watchStatus.php — returns a live leaderboard for a quiz.
 * Returns the best score per student, sorted descending.
 *
 * POST { quizCode }
 * Returns a JSON array of { studentName, score, quizComplete, lastUpdate }
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$quizCode = $receivedData['quizCode'] ?? '';
if (!$quizCode) send_response('quizCode is required', 400);

$stmt = $mysqli->prepare(
    "SELECT
        studentName,
        MAX(score)        AS score,
        MAX(quizComplete) AS quizComplete,
        MAX(lastUpdate)   AS lastUpdate
     FROM tblstatus
     WHERE quizCode = ?
     GROUP BY studentName
     ORDER BY score DESC, lastUpdate ASC"
);

if (!$stmt) {
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param("s", $quizCode);
$stmt->execute();
$rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stmt->close();

http_response_code(200);
die(json_encode($rows));

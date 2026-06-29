<?php
/**
 * getAllQuizzes.php — returns every quiz in the database.
 * Used by the teacher dashboard and student browse view.
 *
 * POST (no body required)
 * Returns a JSON array of quiz rows.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$stmt = $mysqli->prepare("SELECT * FROM tblquiz ORDER BY id DESC");

if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

$rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stmt->close();

http_response_code(200);
die(json_encode($rows));

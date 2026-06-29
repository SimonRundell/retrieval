<?php
/**
 * updateStatus.php — records a student's quiz progress.
 * Public endpoint; students are anonymous (name only, no account).
 *
 * POST { studentName, quizCode, score, quizComplete }
 * Returns 200 on success.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$studentName  = $receivedData['studentName']  ?? '';
$quizCode     = $receivedData['quizCode']     ?? '';
$score        = (int)($receivedData['score']        ?? 0);
$quizComplete = (int)($receivedData['quizComplete'] ?? 0);
$lastUpdate   = date('Y-m-d H:i:s');

if (!$studentName || !$quizCode) send_response('studentName and quizCode are required', 400);

$stmt = $mysqli->prepare(
    "INSERT INTO tblstatus (studentName, quizCode, score, quizComplete, lastUpdate) VALUES (?, ?, ?, ?, ?)"
);

if (!$stmt) {
    log_info("updateStatus prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param("ssiis", $studentName, $quizCode, $score, $quizComplete, $lastUpdate);

if (!$stmt->execute()) {
    log_info("updateStatus execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

$stmt->close();
send_response("Status recorded.", 200);

<?php
/**
 * getSession.php — returns the most recent timed session for a quiz code.
 * Public endpoint; used by students to sync the countdown timer.
 *
 * POST { quizCode }
 * Returns { sessionId, startTime, durationSecs } or 404 if none exists.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$quizCode = $receivedData['quizCode'] ?? '';
if (!$quizCode) send_response('quizCode is required', 400);

$stmt = $mysqli->prepare(
    "SELECT id, startTime, durationSecs FROM tblsession
     WHERE quizCode = ?
       AND DATE_ADD(startTime, INTERVAL durationSecs SECOND) > NOW()
     ORDER BY id DESC LIMIT 1"
);

if (!$stmt) {
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param("s", $quizCode);
$stmt->execute();
$result = $stmt->get_result();
$row    = $result->fetch_assoc();
$stmt->close();

if (!$row) {
    send_response("No active session found for this quiz.", 404);
}

/* Convert MySQL DATETIME to ISO 8601 with timezone offset so JavaScript
   Date() parses it unambiguously regardless of browser or OS locale. */
$startIso     = date('c', strtotime($row['startTime']));
$remainingSecs = max(0, strtotime($row['startTime']) + (int)$row['durationSecs'] - time());

send_response([
    'sessionId'    => $row['id'],
    'startTime'    => $startIso,
    'durationSecs' => (int)$row['durationSecs'],
    'remainingSecs' => $remainingSecs,
], 200);

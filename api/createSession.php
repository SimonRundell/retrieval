<?php
/**
 * createSession.php — teacher starts a timed quiz session.
 *
 * POST { quizCode, durationSecs }
 * Requires JWT authentication (teacher only).
 * Returns { sessionId, startTime, durationSecs }
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$auth = requireAuth();

$quizCode     = $receivedData['quizCode']    ?? '';
$durationSecs = (int)($receivedData['durationSecs'] ?? 600);
$clearScores  = !empty($receivedData['clearScores']);

if (!$quizCode) send_response('quizCode is required', 400);
if ($durationSecs < 30 || $durationSecs > 7200) send_response('durationSecs must be between 30 and 7200', 400);

if ($clearScores) {
    $del = $mysqli->prepare("DELETE FROM tblstatus WHERE quizCode = ?");
    $del->bind_param("s", $quizCode);
    $del->execute();
    $del->close();
    log_info("Scores cleared for {$quizCode} before new session");
}

$startTime = date('Y-m-d H:i:s');

$stmt = $mysqli->prepare(
    "INSERT INTO tblsession (quizCode, startTime, durationSecs, createdBy) VALUES (?, ?, ?, ?)"
);

if (!$stmt) {
    log_info("createSession prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param("ssii", $quizCode, $startTime, $durationSecs, $auth['userId']);

if (!$stmt->execute()) {
    log_info("createSession execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

$sessionId = $mysqli->insert_id;
$stmt->close();

log_info("Session created: {$quizCode} for {$durationSecs}s by user {$auth['userId']}");

send_response([
    'sessionId'    => $sessionId,
    'startTime'    => $startTime,
    'durationSecs' => $durationSecs,
], 200);

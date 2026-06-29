<?php
/**
 * getQuiz.php — returns a single quiz by its code.
 * Used by students (entry validation) and quiz player, and by the edit router.
 *
 * POST { quizCode }
 * Returns the quiz row as a JSON object, or 404 if not found.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$quizCode = $receivedData['quizCode'] ?? '';
if (!$quizCode) send_response('quizCode is required', 400);

$stmt = $mysqli->prepare("SELECT * FROM tblquiz WHERE quizCode = ?");

if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param("s", $quizCode);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

$row = $stmt->get_result()->fetch_assoc();
$stmt->close();

if (!$row) {
    send_response("No quiz found for code: {$quizCode}", 404);
}

/* quizData is stored as a JSON string in the DB — decode it so the
   frontend receives a proper object rather than a double-encoded string. */
$row['quizData'] = json_decode($row['quizData'], true);

http_response_code(200);
die(json_encode($row));

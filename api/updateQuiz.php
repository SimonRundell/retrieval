<?php
/**
 * updateQuiz.php — updates an existing quiz. Teacher JWT required.
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

requireAuth();

// Ensure quizData is properly encoded as a JSON string
$receivedData['quizData'] = json_encode($receivedData['quizData']);

$query = "UPDATE tblquiz SET
          quizType = ?,
          quizName = ?,
          quizSetBy = ?,
          quizSubject = ?,
          quizDescription = ?,
          quizTopic = ?,
          quizYear = ?,
          quizUnit = ?,
          quizData = ? 
          WHERE quizCode = ?";

$stmt = $mysqli->prepare($query);

if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param("isisssssss", 
    $receivedData['quizType'],
    $receivedData['quizName'], 
    $receivedData['quizSetBy'], 
    $receivedData['quizSubject'], 
    $receivedData['quizDescription'], 
    $receivedData['quizTopic'],
    $receivedData['quizYear'],
    $receivedData['quizUnit'],
    $receivedData['quizData'],
    $receivedData['quizCode']
);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
} else {
    if ($stmt->affected_rows > 0) {
        log_info("Quiz update was successful and {$stmt->affected_rows} rows were updated");
        send_response("Quiz update was successful and {$stmt->affected_rows} rows were updated", 200);
    } else {
        log_info("No rows were updated");
        send_response("No rows were updated", 400);
    }
}

$stmt->close();
<?php
/**
 * insertQuiz.php — creates a new quiz. Teacher JWT required.
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

requireAuth();

// Ensure quizData is properly encoded as a JSON string
$receivedData['quizData'] = json_encode($receivedData['quizData']);

$query = "INSERT INTO tblquiz (quizType, quizName, quizSetBy, 
                               quizSubject, quizDescription, 
                               quizTopic, quizYear, quizUnit, 
                               quizData, quizCode) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
    $inserted_id = $mysqli->insert_id;
    log_info("Quiz was successfully added to the database with ID: {$inserted_id}");
    send_response("Quiz was successfully added to the database with ID: {$inserted_id}", 200);
}

$stmt->close();
<?php
/**
 * deleteLookup.php — deletes a standardised Subject/Topic/Year/Unit value.
 * Teacher JWT required. Refuses if any quiz currently uses that value.
 *
 * POST { id }
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

requireAuth();

$categoryColumns = [
    'subject' => 'quizSubject',
    'topic'   => 'quizTopic',
    'year'    => 'quizYear',
    'unit'    => 'quizUnit',
];

$id = (int)($receivedData['id'] ?? 0);
if (!$id) send_response('Lookup id is required.', 400);

$stmt = $mysqli->prepare("SELECT category, value FROM tblLookup WHERE id = ?");
if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result()->fetch_assoc();
$stmt->close();

if (!$result) {
    send_response('No lookup value found with that id.', 400);
}
$category = $result['category'];
$value    = $result['value'];
$column   = $categoryColumns[$category];

// $column is drawn from the fixed $categoryColumns whitelist above, never from user input.
$countStmt = $mysqli->prepare("SELECT COUNT(*) AS n FROM tblquiz WHERE {$column} = ?");
if (!$countStmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$countStmt->bind_param("s", $value);
$countStmt->execute();
$count = $countStmt->get_result()->fetch_assoc()['n'];
$countStmt->close();

if ($count > 0) {
    $noun = $count === 1 ? 'quiz uses' : 'quizzes use';
    send_response("$count $noun this value — reassign them first.", 409);
}

$deleteStmt = $mysqli->prepare("DELETE FROM tblLookup WHERE id = ?");
if (!$deleteStmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$deleteStmt->bind_param("i", $id);
if (!$deleteStmt->execute()) {
    log_info("Execute failed: " . $deleteStmt->error);
    send_response("Execute failed: " . $deleteStmt->error, 500);
}

send_response('Value deleted.', 200);

$deleteStmt->close();

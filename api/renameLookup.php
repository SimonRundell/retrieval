<?php
/**
 * renameLookup.php — renames a standardised Subject/Topic/Year/Unit value.
 * Teacher JWT required. Existing quizzes using the old value are updated
 * to the new value so quiz metadata stays consistent.
 *
 * POST { id, value }
 * Returns 409 if the new value already exists for that category.
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

$id       = (int)($receivedData['id'] ?? 0);
$newValue = trim($receivedData['value'] ?? '');

if (!$id)  send_response('Lookup id is required.', 400);
if ($newValue === '') send_response('Value is required.', 400);

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
$oldValue = $result['value'];
$column   = $categoryColumns[$category];

if ($oldValue === $newValue) {
    send_response('Value updated.', 200);
}

$checkStmt = $mysqli->prepare("SELECT id FROM tblLookup WHERE category = ? AND value = ? AND id != ?");
if (!$checkStmt) {
    log_info("Prepare (duplicate check) failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$checkStmt->bind_param("ssi", $category, $newValue, $id);
$checkStmt->execute();
$checkStmt->store_result();
if ($checkStmt->num_rows > 0) {
    $checkStmt->close();
    send_response("That value already exists.", 409);
}
$checkStmt->close();

$updateStmt = $mysqli->prepare("UPDATE tblLookup SET value = ? WHERE id = ?");
if (!$updateStmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$updateStmt->bind_param("si", $newValue, $id);
if (!$updateStmt->execute()) {
    log_info("Execute failed: " . $updateStmt->error);
    send_response("Execute failed: " . $updateStmt->error, 500);
}
$updateStmt->close();

// $column is drawn from the fixed $categoryColumns whitelist above, never from user input.
$cascadeStmt = $mysqli->prepare("UPDATE tblquiz SET {$column} = ? WHERE {$column} = ?");
if (!$cascadeStmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$cascadeStmt->bind_param("ss", $newValue, $oldValue);
if (!$cascadeStmt->execute()) {
    log_info("Execute failed: " . $cascadeStmt->error);
    send_response("Execute failed: " . $cascadeStmt->error, 500);
}
$cascadeStmt->close();

send_response('Value updated.', 200);

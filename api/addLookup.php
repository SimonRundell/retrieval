<?php
/**
 * addLookup.php — adds a new standardised value to a Subject/Topic/Year/Unit list.
 * Teacher JWT required (any teacher may extend the shared lists).
 *
 * POST { category, value }
 * Returns 409 if that value already exists for the category.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

requireAuth();

$allowedCategories = ['subject', 'topic', 'year', 'unit'];
$category = $receivedData['category'] ?? '';
$value    = trim($receivedData['value'] ?? '');

if (!in_array($category, $allowedCategories, true)) {
    send_response('Invalid category.', 400);
}
if ($value === '') {
    send_response('Value is required.', 400);
}

$checkStmt = $mysqli->prepare("SELECT id FROM tblLookup WHERE category = ? AND value = ?");
if (!$checkStmt) {
    log_info("Prepare (duplicate check) failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$checkStmt->bind_param("ss", $category, $value);
$checkStmt->execute();
$checkStmt->store_result();
if ($checkStmt->num_rows > 0) {
    $checkStmt->close();
    send_response("That value already exists.", 409);
}
$checkStmt->close();

$stmt = $mysqli->prepare("INSERT INTO tblLookup (category, value) VALUES (?, ?)");
if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$stmt->bind_param("ss", $category, $value);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

send_response(['id' => $stmt->insert_id, 'value' => $value], 200);

$stmt->close();

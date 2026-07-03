<?php
/**
 * adminEditUser.php — updates a user's details and role flags. Admin JWT required.
 *
 * POST { id, email, studentName, schoolName, admin, teacher }
 * An admin may not remove their own admin flag (prevents self-lockout).
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$payload = requireAdmin();

$id      = (int)($receivedData['id'] ?? 0);
$admin   = !empty($receivedData['admin'])   ? 1 : 0;
$teacher = !empty($receivedData['teacher']) ? 1 : 0;

if (!$id) send_response('User id is required.', 400);

if ($id === (int)$payload['userId'] && !$admin) {
    send_response("You can't remove your own admin access.", 400);
}

// Reject a change of email that collides with a different account
$checkStmt = $mysqli->prepare("SELECT id FROM tbluser WHERE email = ? AND id != ?");
if (!$checkStmt) {
    log_info("Prepare (duplicate check) failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$checkStmt->bind_param("si", $receivedData['email'], $id);
$checkStmt->execute();
$checkStmt->store_result();
if ($checkStmt->num_rows > 0) {
    $checkStmt->close();
    send_response("An account with that email address already exists.", 409);
}
$checkStmt->close();

$stmt = $mysqli->prepare(
    "UPDATE tbluser SET email = ?, studentName = ?, schoolName = ?, admin = ?, teacher = ? WHERE id = ?"
);

if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param(
    "sssiii",
    $receivedData['email'],
    $receivedData['studentName'],
    $receivedData['schoolName'],
    $admin,
    $teacher,
    $id
);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

if ($stmt->affected_rows > 0) {
    send_response("User updated.", 200);
} else {
    send_response("No user found with that id.", 400);
}

$stmt->close();

<?php
/**
 * adminAddUser.php — creates a new user account. Admin JWT required.
 *
 * POST { email, passwordHash, studentName, schoolName, admin, teacher }
 * Returns 409 if the email is already registered.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

requireAdmin();

$checkStmt = $mysqli->prepare("SELECT id FROM tbluser WHERE email = ?");
if (!$checkStmt) {
    log_info("Prepare (duplicate check) failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$checkStmt->bind_param("s", $receivedData['email']);
$checkStmt->execute();
$checkStmt->store_result();
if ($checkStmt->num_rows > 0) {
    $checkStmt->close();
    send_response("An account with that email address already exists.", 409);
}
$checkStmt->close();

$admin   = !empty($receivedData['admin'])   ? 1 : 0;
$teacher = !empty($receivedData['teacher']) ? 1 : 0;

$stmt = $mysqli->prepare(
    "INSERT INTO tbluser (email, passwordHash, studentName, schoolName, admin, teacher) VALUES (?, ?, ?, ?, ?, ?)"
);

if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param(
    "ssssii",
    $receivedData['email'],
    $receivedData['passwordHash'],
    $receivedData['studentName'],
    $receivedData['schoolName'],
    $admin,
    $teacher
);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

log_info("Admin created user: " . $receivedData['email']);
send_response("User created.", 200);

$stmt->close();

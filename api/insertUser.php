<?php
/**
 * insertUser.php
 * Registers a new student user account.
 *
 * Expects POST JSON: { email, passwordHash, studentName, schoolName, classNamen }
 * Returns 409 if the email is already registered, 200 on success.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

// Reject duplicate emails
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

$query = "INSERT INTO tbluser (email, passwordHash, studentName, schoolName, classNamen, admin, teacher)
          VALUES (?, ?, ?, ?, ?, 0, 0)";
$stmt = $mysqli->prepare($query);

if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param(
    "sssss",
    $receivedData['email'],
    $receivedData['passwordHash'],
    $receivedData['studentName'],
    $receivedData['schoolName'],
    $receivedData['classNamen']
);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

log_info("New user registered: " . $receivedData['email']);
send_response("Registration successful. You can now log in.", 200);

$stmt->close();

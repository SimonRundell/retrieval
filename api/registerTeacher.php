<?php
/**
 * registerTeacher.php — self-service teacher account registration.
 *
 * POST { email, passwordHash, studentName, schoolName }
 * Creates a teacher account (teacher = 1, admin = 0) and logs the new
 * teacher straight in, returning the same shape as getLogin.php.
 * Returns 409 if the email is already registered.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

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

$stmt = $mysqli->prepare(
    "INSERT INTO tbluser (email, passwordHash, studentName, schoolName, admin, teacher) VALUES (?, ?, ?, ?, 0, 1)"
);

if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param(
    "ssss",
    $receivedData['email'],
    $receivedData['passwordHash'],
    $receivedData['studentName'],
    $receivedData['schoolName']
);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

$newId = $stmt->insert_id;
$stmt->close();

$token = generateJWT(
    [
        'userId'  => $newId,
        'teacher' => 1,
        'admin'   => 0,
        'name'    => $receivedData['studentName'],
        'exp'     => time() + 86400,
    ],
    $config['jwtSecret']
);

log_info("New teacher registered: " . $receivedData['email']);

send_response([
    'token'   => $token,
    'teacher' => [
        'id'    => $newId,
        'name'  => $receivedData['studentName'],
        'email' => $receivedData['email'],
        'admin' => false,
    ],
], 200);

<?php
/**
 * getLogin.php — authenticates a teacher and returns a JWT.
 *
 * POST { email, passwordHash }
 * Returns { token, teacher: { id, studentName, email } } on success.
 * Only teacher accounts (teacher = 1) may log in via this endpoint.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$stmt = $mysqli->prepare(
    "SELECT id, studentName, email, teacher FROM tbluser WHERE email = ? AND passwordHash = ? AND teacher = 1"
);

if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

$stmt->bind_param("ss", $receivedData['email'], $receivedData['passwordHash']);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

$result = $stmt->get_result();
$user   = $result->fetch_assoc();
$stmt->close();

if (!$user) {
    send_response("Invalid credentials or not a teacher account.", 401);
}

$token = generateJWT(
    [
        'userId'  => $user['id'],
        'teacher' => 1,
        'name'    => $user['studentName'],
        'exp'     => time() + 86400,
    ],
    $config['jwtSecret']
);

log_info("Teacher login: " . $user['email']);

send_response([
    'token'   => $token,
    'teacher' => [
        'id'   => $user['id'],
        'name' => $user['studentName'],
        'email' => $user['email'],
    ],
], 200);

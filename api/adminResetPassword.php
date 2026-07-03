<?php
/**
 * adminResetPassword.php — sets a new password for a user. Admin JWT required.
 *
 * POST { id, passwordHash }
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

requireAdmin();

$id = (int)($receivedData['id'] ?? 0);
if (!$id) send_response('User id is required.', 400);
if (empty($receivedData['passwordHash'])) send_response('New password is required.', 400);

$stmt = $mysqli->prepare("UPDATE tbluser SET passwordHash = ? WHERE id = ?");
if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$stmt->bind_param("si", $receivedData['passwordHash'], $id);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

if ($stmt->affected_rows > 0) {
    log_info("Admin reset password for user id: {$id}");
    send_response("Password reset.", 200);
} else {
    send_response("No user found with that id.", 400);
}

$stmt->close();

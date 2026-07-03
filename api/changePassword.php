<?php
/**
 * changePassword.php — lets a signed-in teacher change their own password. Teacher JWT required.
 *
 * POST { currentPasswordHash, newPasswordHash }
 * Returns 401 if currentPasswordHash doesn't match the account's stored hash.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$payload = requireAuth();
$userId  = (int)$payload['userId'];

if (empty($receivedData['currentPasswordHash'])) send_response('Current password is required.', 400);
if (empty($receivedData['newPasswordHash']))     send_response('New password is required.', 400);

$stmt = $mysqli->prepare("SELECT passwordHash FROM tbluser WHERE id = ?");
if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$stmt->bind_param("i", $userId);
$stmt->execute();
$row = $stmt->get_result()->fetch_assoc();
$stmt->close();

if (!$row || !hash_equals($row['passwordHash'], $receivedData['currentPasswordHash'])) {
    send_response('Current password is incorrect.', 401);
}

$stmt = $mysqli->prepare("UPDATE tbluser SET passwordHash = ? WHERE id = ?");
if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$stmt->bind_param("si", $receivedData['newPasswordHash'], $userId);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

log_info("Teacher changed their own password: user id {$userId}");
send_response("Password changed.", 200);

$stmt->close();

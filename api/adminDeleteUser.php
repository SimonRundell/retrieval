<?php
/**
 * adminDeleteUser.php — deletes a user account. Admin JWT required.
 *
 * POST { id }
 * An admin may not delete their own account.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

$payload = requireAdmin();

$id = (int)($receivedData['id'] ?? 0);
if (!$id) send_response('User id is required.', 400);

if ($id === (int)$payload['userId']) {
    send_response("You can't delete your own account.", 400);
}

$stmt = $mysqli->prepare("DELETE FROM tbluser WHERE id = ?");
if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}
$stmt->bind_param("i", $id);

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

if ($stmt->affected_rows > 0) {
    log_info("Admin deleted user id: {$id}");
    send_response("User deleted.", 200);
} else {
    send_response("No user found with that id.", 400);
}

$stmt->close();

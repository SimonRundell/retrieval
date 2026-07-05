<?php
/**
 * getLookups.php — returns the standardised Subject/Topic/Year/Unit value lists.
 *
 * POST (no body required). Teacher JWT required.
 * Returns { subject: [{id,value}], topic: [...], year: [...], unit: [...] }
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

requireAuth();

$stmt = $mysqli->prepare("SELECT id, category, value FROM tblLookup ORDER BY category, value");

if (!$stmt) {
    log_info("Prepare failed: " . $mysqli->error);
    send_response("Prepare failed: " . $mysqli->error, 500);
}

if (!$stmt->execute()) {
    log_info("Execute failed: " . $stmt->error);
    send_response("Execute failed: " . $stmt->error, 500);
}

$rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stmt->close();

$grouped = ['subject' => [], 'topic' => [], 'year' => [], 'unit' => []];
foreach ($rows as $row) {
    $grouped[$row['category']][] = ['id' => (int)$row['id'], 'value' => $row['value']];
}

http_response_code(200);
die(json_encode($grouped));

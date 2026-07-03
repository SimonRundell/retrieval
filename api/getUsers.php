<?php
/**
 * getUsers.php — lists all registered users. Admin JWT required.
 *
 * Returns an array of { id, email, studentName, schoolName, admin, teacher }.
 * passwordHash is never returned.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */
include 'setup.php';

requireAdmin();

$result = $mysqli->query(
    "SELECT id, email, studentName, schoolName, admin, teacher FROM tbluser ORDER BY teacher DESC, admin DESC, email ASC"
);

if (!$result) {
    log_info("Query failed: " . $mysqli->error);
    send_response("Query failed: " . $mysqli->error, 500);
}

$users = [];
while ($row = $result->fetch_assoc()) {
    $users[] = $row;
}

http_response_code(200);
die(json_encode($users));

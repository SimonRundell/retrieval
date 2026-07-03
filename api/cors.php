<?php
/**
 * cors.php — shared CORS handler, included first by every API endpoint.
 * Reflects the request's localhost origin (any port) back to the browser
 * so Vite's dev server is accepted regardless of which port it runs on,
 * and short-circuits OPTIONS preflight requests.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if (preg_match('#^https?://localhost(:\d+)?$#', $origin)) {
    header("Access-Control-Allow-Origin: $origin");
}

header("Content-Type: application/json; charset=utf-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Authorization, Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

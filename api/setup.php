<?php
/**
 * setup.php — shared bootstrap for all API endpoints.
 * Provides DB connection, CORS headers, JWT helpers, and response utilities.
 *
 * @license CC BY-NC-SA 4.0 — Simon Rundell / CodeMonkey Design Ltd. 2025
 */

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json");

ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(E_ALL);

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$config = json_decode(file_get_contents(__DIR__ . '/.config.json'), true);

$mysqli = new mysqli($config['servername'], $config['username'], $config['password'], $config['dbname']);
if ($mysqli->connect_error) {
    log_info("Connection failed: " . $mysqli->connect_error);
    send_response("Connection failed: " . $mysqli->connect_error, 500);
}

$jsonPayload  = file_get_contents('php://input');
$receivedData = json_decode($jsonPayload, true) ?? [];

if ($_SERVER['REQUEST_METHOD'] === 'POST' && !is_array($receivedData)) {
    send_response("Invalid JSON payload", 400);
}

/* ----------------------------------------------------------
   JWT HELPERS (HMAC-SHA256, no external library required)
   ---------------------------------------------------------- */

/**
 * Generates a JWT token.
 *
 * @param array  $payload  Claims to include (add 'exp' for expiry).
 * @param string $secret   Signing secret from config.
 * @return string Encoded JWT.
 */
function generateJWT(array $payload, string $secret): string {
    $header    = rtrim(base64_encode(json_encode(['alg' => 'HS256', 'typ' => 'JWT'])), '=');
    $payload   = rtrim(base64_encode(json_encode($payload)), '=');
    $signature = rtrim(base64_encode(hash_hmac('sha256', "$header.$payload", $secret, true)), '=');
    return "$header.$payload.$signature";
}

/**
 * Verifies a JWT token and returns its payload, or false on failure.
 *
 * @param string $token  JWT string.
 * @param string $secret Signing secret.
 * @return array|false   Decoded payload, or false if invalid/expired.
 */
function verifyJWT(string $token, string $secret) {
    $parts = explode('.', $token);
    if (count($parts) !== 3) return false;
    [$h, $p, $sig] = $parts;
    $expected = rtrim(base64_encode(hash_hmac('sha256', "$h.$p", $secret, true)), '=');
    if (!hash_equals($expected, $sig)) return false;
    $data = json_decode(base64_decode($p), true);
    if (!$data || (isset($data['exp']) && $data['exp'] < time())) return false;
    return $data;
}

/**
 * Enforces JWT authentication for teacher-only endpoints.
 * Terminates with 401 if the token is missing, invalid, or not a teacher token.
 *
 * @return array Decoded JWT payload.
 */
function requireAuth(): array {
    global $config;
    $authHeader = $_SERVER['HTTP_AUTHORIZATION']
        ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION']
        ?? apache_request_headers()['Authorization']
        ?? apache_request_headers()['authorization']
        ?? '';
    if (!preg_match('/Bearer\s+(.+)/i', $authHeader, $matches)) {
        send_response('Unauthorised: no token', 401);
    }
    $payload = verifyJWT($matches[1], $config['jwtSecret']);
    if (!$payload || empty($payload['teacher'])) {
        send_response('Unauthorised: invalid or expired token', 401);
    }
    return $payload;
}

/* ----------------------------------------------------------
   RESPONSE HELPERS
   ---------------------------------------------------------- */

/**
 * Sends a JSON response and terminates execution.
 *
 * @param mixed $response  String message or array data.
 * @param int   $code      HTTP status code.
 */
function send_response($response, int $code = 200): void {
    http_response_code($code);
    if (!is_array($response)) {
        $response = ['message' => $response];
    }
    $response['status_code'] = $code;
    die(json_encode($response));
}

/**
 * Sends a JSON response without terminating (for streaming / keep-alive use).
 *
 * @param mixed $response  String message or array data.
 * @param int   $code      HTTP status code.
 */
function send_response_keep_alive($response, int $code = 200): void {
    http_response_code($code);
    if (!is_array($response)) {
        $response = ['message' => $response];
    }
    $response['status_code'] = $code;
    echo json_encode($response);
}

/**
 * Appends a timestamped line to server.log in the api directory.
 *
 * @param string $log Message to log.
 */
function log_info(string $log): void {
    $file = __DIR__ . '/server.log';
    file_put_contents($file, date('Y-m-d H:i:s') . ' : ' . $log . PHP_EOL, FILE_APPEND);
}

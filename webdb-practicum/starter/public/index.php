<?php
declare(strict_types=1);
require __DIR__ . '/../src/bootstrap.php';
require __DIR__ . '/../src/auth.php';

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);

if ($method === 'GET' && $path === '/health') {
    respond(200, ['status' => 'ok']);
}
if ($method === 'GET' && $path === '/health/db') {
    try {
        db()->query('SELECT 1')->fetchColumn();
        respond(200, ['status' => 'ok', 'database' => 'available']);
    } catch (PDOException $error) {
        error_log('Database health check failed');
        respond(503, ['error' => 'database_unavailable']);
    }
}

// Add the three domain handlers for lab 2 here.
// In lab 4, call $user = lab_user() inside every protected domain handler.
// Compare the stored owner with $user['id']; never trust owner_id from JSON.
respond(404, ['error' => 'route_not_found']);

<?php
declare(strict_types=1);

function respond(int $status, array $data): never {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
    exit;
}

function db(): PDO {
    static $connection = null;
    if ($connection === null) {
        $host = getenv('DB_HOST') ?: 'db';
        $name = getenv('DB_NAME') ?: 'webdb';
        $connection = new PDO(
            "pgsql:host={$host};port=5432;dbname={$name}",
            getenv('DB_USER') ?: 'web_app',
            getenv('DB_PASSWORD') ?: '',
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
             PDO::ATTR_EMULATE_PREPARES => false,
             PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
        );
    }
    return $connection;
}

function json_body(): array {
    $json = file_get_contents('php://input');
    try {
        $value = json_decode($json, false, 512, JSON_THROW_ON_ERROR);
    } catch (JsonException $e) {
        respond(400, ['error' => 'invalid_json']);
    }
    if (!is_object($value)) {
        respond(422, ['error' => 'object_required']);
    }
    return json_decode($json, true, 512, JSON_THROW_ON_ERROR);
}

set_exception_handler(function (Throwable $error): void {
    error_log(get_class($error) . ': ' . (string)$error->getCode());
    respond(500, ['error' => 'internal_error']);
});

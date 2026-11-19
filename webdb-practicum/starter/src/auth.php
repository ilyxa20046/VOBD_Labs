<?php
declare(strict_types=1);

function lab_user(): array {
    $header = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    if (!preg_match('/^Bearer ([A-Za-z0-9]+)$/D', trim($header), $match)) {
        respond(401, ['error' => 'authentication_required']);
    }
    $identities = [
        ['env' => 'LAB_USER_TOKEN', 'id' => 1, 'role' => 'user'],
        ['env' => 'LAB_OTHER_TOKEN', 'id' => 2, 'role' => 'user'],
        ['env' => 'LAB_MANAGER_TOKEN', 'id' => 3, 'role' => 'manager']
    ];
    foreach ($identities as $identity) {
        $expected = getenv($identity['env']);
        if (is_string($expected) && strlen($expected) >= 32 && hash_equals($expected, $match[1])) {
            return ['id' => $identity['id'], 'role' => $identity['role']];
        }
    }
    respond(401, ['error' => 'invalid_token']);
}

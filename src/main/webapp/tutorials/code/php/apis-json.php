<?php
// APIs & JSON

// Fetch data from API using file_get_contents
$url = 'https://api.example.com/users';
$response = file_get_contents($url);
$data = json_decode($response, true);

// Using cURL (recommended)
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
print_r($data);

// POST request with cURL
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://api.example.com/users');
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
    'name' => 'John Doe',
    'email' => 'john@example.com'
]));
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json'
]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);
curl_close($ch);

// Create simple API endpoint
header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    echo json_encode([
        'users' => [
            ['id' => 1, 'name' => 'John'],
            ['id' => 2, 'name' => 'Jane']
        ]
    ]);
} elseif ($method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    echo json_encode(['success' => true, 'data' => $input]);
}

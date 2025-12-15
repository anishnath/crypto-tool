<?php
// JSON File Handling

// Create data
$users = [
    [
        'name' => 'John Doe',
        'email' => 'john@example.com',
        'age' => 30
    ],
    [
        'name' => 'Jane Smith',
        'email' => 'jane@example.com',
        'age' => 25
    ]
];

// Write JSON to file
$json = json_encode($users, JSON_PRETTY_PRINT);
file_put_contents('users.json', $json);

// Read JSON from file
$json = file_get_contents('users.json');
$users = json_decode($json, true); // true for associative array

print_r($users);

// Access data
echo $users[0]['name'] . "\n";

// JSON encode options
$json = json_encode($users, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

// Handle JSON errors
$json = file_get_contents('users.json');
$data = json_decode($json);

if (json_last_error() !== JSON_ERROR_NONE) {
    echo "JSON Error: " . json_last_error_msg() . "\n";
}

// Working with objects
$json = file_get_contents('users.json');
$users = json_decode($json); // Objects instead of arrays

echo $users[0]->name . "\n";

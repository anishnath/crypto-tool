<?php
// json_encode() - Convert PHP value to JSON
// Essential for APIs and data exchange

// Example 1: Simple array
$fruits = ["apple", "banana", "cherry"];
echo "Array to JSON:\n";
echo json_encode($fruits) . "\n\n";

// Example 2: Associative array (becomes JSON object)
$user = [
    "name" => "John Doe",
    "email" => "john@example.com",
    "age" => 30,
    "active" => true
];
echo "Object to JSON:\n";
echo json_encode($user) . "\n\n";

// Example 3: Pretty print
echo "Pretty printed:\n";
echo json_encode($user, JSON_PRETTY_PRINT) . "\n\n";

// Example 4: Nested data structure
$response = [
    "success" => true,
    "data" => [
        "users" => [
            ["id" => 1, "name" => "Alice"],
            ["id" => 2, "name" => "Bob"]
        ],
        "total" => 2
    ],
    "message" => "Users retrieved successfully"
];

echo "API Response:\n";
echo json_encode($response, JSON_PRETTY_PRINT) . "\n\n";

// Example 5: Using flags
$data = [
    "url" => "https://example.com/api/users",
    "greeting" => "Hello World!"
];

echo "With UNESCAPED_SLASHES:\n";
echo json_encode($data, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT) . "\n";

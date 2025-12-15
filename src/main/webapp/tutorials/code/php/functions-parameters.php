<?php
// Function Parameters

// Default parameters
function greet($name = "Guest")
{
    return "Hello, $name!";
}

echo greet();           // "Hello, Guest!"
echo "\n";
echo greet("Alice");    // "Hello, Alice!"
echo "\n";

// Multiple default parameters
function createUser($name, $role = "user", $active = true)
{
    return [
        "name" => $name,
        "role" => $role,
        "active" => $active
    ];
}

print_r(createUser("Bob"));
print_r(createUser("Alice", "admin"));
echo "\n";

// Type declarations (PHP 7+)
function addNumbers(int $a, int $b): int
{
    return $a + $b;
}

echo addNumbers(5, 3);  // 8
echo "\n";

// Nullable types (PHP 7.1+)
function findUser(?string $email): ?array
{
    if ($email === null) {
        return null;
    }
    return ["email" => $email];
}

var_dump(findUser(null));
var_dump(findUser("test@example.com"));

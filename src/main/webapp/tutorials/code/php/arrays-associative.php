<?php
// PHP Associative Arrays Demo
// 8gwifi.org/tutorials

echo "=== Creating Associative Arrays ===\n";

$person = [
    "name" => "John Doe",
    "age" => 30,
    "email" => "john@example.com",
    "city" => "New York"
];

echo "Person data:\n";
print_r($person);

echo "\n=== Accessing Values by Key ===\n";
echo "Name: " . $person["name"] . "\n";
echo "Age: " . $person["age"] . "\n";
echo "Email: " . $person["email"] . "\n";

echo "\n=== Adding and Modifying ===\n";
$person["country"] = "USA";  // Add new key
$person["age"] = 31;         // Modify existing
echo "After updates:\n";
print_r($person);

echo "\n=== Removing Elements ===\n";
unset($person["city"]);
echo "After removing 'city':\n";
print_r($person);

echo "\n=== Checking Keys and Values ===\n";
echo "Has 'name' key? " . (array_key_exists("name", $person) ? "Yes" : "No") . "\n";
echo "Has 'city' key? " . (array_key_exists("city", $person) ? "Yes" : "No") . "\n";
echo "Contains 'John Doe'? " . (in_array("John Doe", $person) ? "Yes" : "No") . "\n";

echo "\n=== Getting Keys and Values ===\n";
echo "All keys: ";
print_r(array_keys($person));

echo "All values: ";
print_r(array_values($person));

echo "\n=== Practical: Configuration Array ===\n";
$config = [
    "database" => [
        "host" => "localhost",
        "port" => 3306,
        "name" => "myapp"
    ],
    "debug" => true,
    "timezone" => "UTC"
];

echo "Database host: " . $config["database"]["host"] . "\n";
echo "Debug mode: " . ($config["debug"] ? "ON" : "OFF") . "\n";

echo "\n=== Mixed Keys (Not Recommended) ===\n";
$mixed = [
    0 => "Zero",
    "name" => "Alice",
    1 => "One",
    "age" => 25
];
print_r($mixed);
?>

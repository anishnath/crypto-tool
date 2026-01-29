<?php
// Extract column from multidimensional array
$users = [
    ["id" => 1, "name" => "Alice", "age" => 25],
    ["id" => 2, "name" => "Bob", "age" => 30],
    ["id" => 3, "name" => "Charlie", "age" => 35]
];

echo "Original array:\n";
print_r($users);

// Extract names
$names = array_column($users, "name");
echo "\nNames: ";
print_r($names);

// Extract ages
$ages = array_column($users, "age");
echo "\nAges: ";
print_r($ages);

// Use ID as index key
$names_by_id = array_column($users, "name", "id");
echo "\nNames indexed by ID: ";
print_r($names_by_id);

// Extract objects
$objects = [
    (object)["id" => 1, "title" => "First"],
    (object)["id" => 2, "title" => "Second"]
];
$titles = array_column($objects, "title");
echo "\nTitles from objects: ";
print_r($titles);
?>
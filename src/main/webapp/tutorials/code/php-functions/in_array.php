<?php
// Check if value exists
$fruits = ["apple", "banana", "cherry"];
if (in_array("banana", $fruits)) {
    echo "Found banana!\n";
}

// Strict type checking
$numbers = [1, 2, 3];
var_dump(in_array("1", $numbers));        // true (loose)
var_dump(in_array("1", $numbers, true));  // false (strict)

// Check multiple values
$required = ["name", "email"];
$input = ["name" => "John", "email" => "j@test.com"];
foreach ($required as $field) {
    if (!in_array($field, array_keys($input))) {
        echo "Missing: $field\n";
    }
}
?>

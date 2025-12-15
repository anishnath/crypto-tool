<?php
// Variable naming rules
$firstName = "John";      // ✓ camelCase
$last_name = "Doe";       // ✓ snake_case
$age2 = 25;               // ✓ numbers allowed (not at start)
$_temp = "value";         // ✓ underscore allowed

// Invalid variable names (commented to avoid errors)
// $2age = 25;            // ✗ can't start with number
// $first-name = "John";  // ✗ hyphens not allowed
// $first name = "John";  // ✗ spaces not allowed

echo "First Name: " . $firstName;
echo "\n";
echo "Last Name: " . $last_name;

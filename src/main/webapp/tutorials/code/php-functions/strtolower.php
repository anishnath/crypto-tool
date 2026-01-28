<?php
// Convert to lowercase
$str = "Hello World";
echo strtolower($str);  // "hello world"
echo "\n";

// All uppercase to lowercase
$str = "PHP IS AWESOME";
echo strtolower($str);  // "php is awesome"
echo "\n";

// Useful for comparisons
$input = "YES";
if (strtolower($input) === "yes") {
    echo "User said yes!";
}
?>

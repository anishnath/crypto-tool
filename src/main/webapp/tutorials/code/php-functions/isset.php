<?php
// Check if variable is set and not null
$name = "John";
var_dump(isset($name));  // true

$empty = "";
var_dump(isset($empty)); // true (set, but empty)

$null = null;
var_dump(isset($null));  // false (null)

// Check array key
$user = ["name" => "John"];
if (isset($user["name"])) {
    echo "Name: " . $user["name"];
}
echo "\n";

// Multiple variables
if (isset($a, $b, $c)) {
    echo "All set";
}
?>

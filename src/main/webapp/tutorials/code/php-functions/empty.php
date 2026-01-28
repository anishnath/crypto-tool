<?php
// Check if variable is empty
var_dump(empty(""));      // true
var_dump(empty(0));       // true
var_dump(empty(null));    // true
var_dump(empty([]));      // true
var_dump(empty(false));   // true
echo "\n";

var_dump(empty("hello")); // false
var_dump(empty(1));       // false
echo "\n";

// Common use: form validation
$username = "";
if (empty($username)) {
    echo "Username required!\n";
}

// Check array key safely
$data = [];
if (empty($data["email"])) {
    echo "Email not provided";
}
?>

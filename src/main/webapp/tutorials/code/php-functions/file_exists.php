<?php
// Check if file exists
$file = "config.json";
if (file_exists($file)) {
    echo "File exists!\n";
} else {
    echo "File not found\n";
}

// Use before reading
if (file_exists("data.json")) {
    $data = json_decode(file_get_contents("data.json"), true);
}

// Check directory
if (file_exists("uploads/")) {
    echo "Directory exists";
}

// Related: is_file() and is_dir()
var_dump(is_file("test.txt"));  // true if file
var_dump(is_dir("uploads"));    // true if directory
?>

<?php
// Decode JSON to object
$json = '{"name": "John", "age": 30}';
$obj = json_decode($json);
echo $obj->name;  // "John"
echo "\n";

// Decode to associative array
$arr = json_decode($json, true);
echo $arr["name"];  // "John"
echo "\n";

// Array of objects
$json = '[{"id": 1}, {"id": 2}]';
$items = json_decode($json, true);
print_r($items);

// Check for errors
$bad = json_decode("invalid");
if (json_last_error() !== JSON_ERROR_NONE) {
    echo "Error: " . json_last_error_msg();
}
?>

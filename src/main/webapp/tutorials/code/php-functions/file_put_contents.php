<?php
// Write string to file
$data = "Hello, World!";
file_put_contents("output.txt", $data);
echo "File written!\n";

// Append to file
file_put_contents("log.txt", "New log entry\n", FILE_APPEND);

// Write JSON
$config = ["name" => "MyApp", "version" => "1.0"];
file_put_contents(
    "config.json",
    json_encode($config, JSON_PRETTY_PRINT)
);

// Returns bytes written or false
$bytes = file_put_contents("test.txt", "Test");
echo "Wrote $bytes bytes";
?>

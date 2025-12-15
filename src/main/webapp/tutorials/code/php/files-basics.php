<?php
// File Operations Basics

// Read entire file
$content = file_get_contents('example.txt');
echo $content . "\n";

// Write to file (overwrites)
file_put_contents('output.txt', "Hello, World!\n");

// Append to file
file_put_contents('output.txt', "New line\n", FILE_APPEND);

// Read file into array (one line per element)
$lines = file('example.txt');
foreach ($lines as $line) {
    echo $line;
}

// Check if file exists
if (file_exists('example.txt')) {
    echo "File exists\n";
}

// Get file size
$size = filesize('example.txt');
echo "Size: $size bytes\n";

// Delete file
// unlink('temp.txt');

// File information
echo "Modified: " . date("Y-m-d H:i:s", filemtime('example.txt')) . "\n";
echo "Readable: " . (is_readable('example.txt') ? 'Yes' : 'No') . "\n";
echo "Writable: " . (is_writable('example.txt') ? 'Yes' : 'No') . "\n";

<?php
// Advanced File Operations

// Open file for reading
$handle = fopen('example.txt', 'r');
if ($handle) {
    // Read line by line
    while (($line = fgets($handle)) !== false) {
        echo $line;
    }
    fclose($handle);
}

// Open file for writing
$handle = fopen('output.txt', 'w');
fwrite($handle, "Line 1\n");
fwrite($handle, "Line 2\n");
fclose($handle);

// Open file for appending
$handle = fopen('output.txt', 'a');
fwrite($handle, "Line 3\n");
fclose($handle);

// Read specific number of bytes
$handle = fopen('example.txt', 'r');
$data = fread($handle, 100); // Read 100 bytes
fclose($handle);

// File modes:
// 'r'  - Read only
// 'w'  - Write only (truncates)
// 'a'  - Append only
// 'r+' - Read and write
// 'w+' - Read and write (truncates)
// 'a+' - Read and append

// Copy file
copy('source.txt', 'destination.txt');

// Rename/move file
rename('old.txt', 'new.txt');

<?php
// Directory Operations

// Create directory
mkdir('new_folder');

// Create nested directories
mkdir('path/to/folder', 0755, true);

// Check if directory exists
if (is_dir('new_folder')) {
    echo "Directory exists\n";
}

// List directory contents
$files = scandir('.');
foreach ($files as $file) {
    if ($file != '.' && $file != '..') {
        echo $file . "\n";
    }
}

// Using glob for pattern matching
$phpFiles = glob('*.php');
foreach ($phpFiles as $file) {
    echo $file . "\n";
}

// Remove empty directory
rmdir('empty_folder');

// Get current directory
echo "Current: " . getcwd() . "\n";

// Change directory
chdir('/path/to/directory');

// Directory iterator
$dir = new DirectoryIterator('.');
foreach ($dir as $file) {
    if (!$file->isDot()) {
        echo $file->getFilename() . "\n";
    }
}

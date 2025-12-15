<?php
// File Permissions and Security

// Check permissions
$file = 'example.txt';

echo "Readable: " . (is_readable($file) ? 'Yes' : 'No') . "\n";
echo "Writable: " . (is_writable($file) ? 'Yes' : 'No') . "\n";
echo "Executable: " . (is_executable($file) ? 'Yes' : 'No') . "\n";

// Get file permissions (octal)
$perms = fileperms($file);
echo "Permissions: " . substr(sprintf('%o', $perms), -4) . "\n";

// Change permissions
chmod($file, 0644); // rw-r--r--

// Get file owner
$owner = fileowner($file);
echo "Owner ID: $owner\n";

// Change owner (requires root)
// chown($file, 'username');

// Security: Validate file paths
function isPathSafe($path, $baseDir)
{
    $realPath = realpath($path);
    $realBase = realpath($baseDir);

    // Check if path is within base directory
    return $realPath !== false &&
        strpos($realPath, $realBase) === 0;
}

// Sanitize filename
function sanitizeFilename($filename)
{
    // Remove directory separators
    $filename = basename($filename);

    // Remove special characters
    $filename = preg_replace('/[^a-zA-Z0-9._-]/', '', $filename);

    return $filename;
}

$userFile = sanitizeFilename($_GET['file'] ?? 'default.txt');
echo "Safe filename: $userFile\n";

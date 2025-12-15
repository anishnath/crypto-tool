<?php
// Error Handling & Exceptions

// Basic error handling
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Try-catch block
try {
    $file = fopen('nonexistent.txt', 'r');
    if (!$file) {
        throw new Exception("File not found");
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}

// Custom exception
class DatabaseException extends Exception
{
}

try {
    throw new DatabaseException("Database connection failed");
} catch (DatabaseException $e) {
    echo "DB Error: " . $e->getMessage() . "\n";
}

// Finally block
try {
    $conn = new PDO("mysql:host=localhost;dbname=test", "root", "");
} catch (PDOException $e) {
    echo "Connection failed\n";
} finally {
    echo "Cleanup code runs always\n";
}

// Multiple catch blocks
try {
    // Some code
} catch (PDOException $e) {
    echo "Database error\n";
} catch (Exception $e) {
    echo "General error\n";
}

// Error handler
function customError($errno, $errstr)
{
    echo "Error [$errno]: $errstr\n";
}
set_error_handler("customError");

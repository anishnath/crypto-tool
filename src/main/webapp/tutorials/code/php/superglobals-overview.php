<?php
// Superglobals Overview

// $_SERVER - Server and execution environment information
echo "Server Name: " . $_SERVER['SERVER_NAME'] . "\n";
echo "Request Method: " . $_SERVER['REQUEST_METHOD'] . "\n";
echo "Script Name: " . $_SERVER['SCRIPT_NAME'] . "\n";

// $_GET - URL parameters
// Example: page.php?name=John&age=30
// $_GET['name'] would be "John"

// $_POST - Form data sent via POST
// Submitted from HTML forms

// $_REQUEST - Contains $_GET, $_POST, and $_COOKIE
// Not recommended - use specific superglobals instead

// $_SESSION - Session variables
// session_start();
// $_SESSION['user_id'] = 123;

// $_COOKIE - Cookie values
// $_COOKIE['username']

// $_FILES - Uploaded files
// $_FILES['upload']['name']

// $_ENV - Environment variables
// $_ENV['PATH']

// $_GLOBALS - All global variables
$myVar = "Hello";
echo $GLOBALS['myVar'];

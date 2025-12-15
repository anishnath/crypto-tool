<?php
// Sessions

// Start session (required before using $_SESSION)
session_start();

// Set session variables
$_SESSION['user_id'] = 123;
$_SESSION['username'] = "john_doe";
$_SESSION['logged_in'] = true;

// Read session variables
if (isset($_SESSION['username'])) {
    echo "Welcome back, " . $_SESSION['username'] . "!\n";
}

// Check if logged in
if (isset($_SESSION['logged_in']) && $_SESSION['logged_in'] === true) {
    echo "User is logged in\n";
} else {
    echo "Please log in\n";
}

// Modify session variable
$_SESSION['last_activity'] = time();

// Remove specific session variable
unset($_SESSION['temp_data']);

// Destroy all session data (logout)
// session_destroy();

// Session configuration
// session_set_cookie_params(3600); // 1 hour
// ini_set('session.gc_maxlifetime', 3600);

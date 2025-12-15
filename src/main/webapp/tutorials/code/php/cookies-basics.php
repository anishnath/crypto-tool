<?php
// Cookies

// Set a cookie (expires in 1 hour)
setcookie("username", "john_doe", time() + 3600, "/");

// Set cookie with more options
setcookie(
    "user_pref",           // name
    "dark_mode",           // value
    time() + (86400 * 30), // expires in 30 days
    "/",                   // path
    "",                    // domain
    false,                 // secure (HTTPS only)
    true                   // httponly (not accessible via JavaScript)
);

// Read cookie
if (isset($_COOKIE['username'])) {
    echo "Welcome back, " . $_COOKIE['username'] . "!\n";
}

// Delete cookie (set expiration to past)
setcookie("username", "", time() - 3600, "/");

// Cookie best practices:
// 1. Don't store sensitive data
// 2. Use httponly flag
// 3. Use secure flag for HTTPS
// 4. Set appropriate expiration
// 5. Validate cookie data

// Example: Remember me functionality
if (isset($_POST['remember_me'])) {
    setcookie("remember_token", bin2hex(random_bytes(32)), time() + (86400 * 30), "/", "", false, true);
}

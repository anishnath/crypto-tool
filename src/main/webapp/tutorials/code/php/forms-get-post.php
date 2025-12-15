<?php
// GET and POST Methods

// GET - Data in URL (visible)
// Example URL: form.php?name=John&email=john@example.com

if (isset($_GET['name'])) {
    $name = htmlspecialchars($_GET['name']);
    echo "Hello, $name!\n";
}

// POST - Data in request body (not visible in URL)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['username'])) {
        $username = htmlspecialchars($_POST['username']);
        $password = $_POST['password'];

        echo "Username: $username\n";
        // Never echo passwords!
    }
}

// When to use GET vs POST:
// GET: Retrieving data, bookmarkable URLs, search queries
// POST: Submitting forms, sensitive data, modifying data

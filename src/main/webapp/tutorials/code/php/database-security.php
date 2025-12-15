<?php
// Prepared Statements & Security

// PDO Prepared Statements (SECURE)
$pdo = new PDO("mysql:host=localhost;dbname=myapp", "root", "");

// Named parameters
$sql = "SELECT * FROM users WHERE email = :email AND status = :status";
$stmt = $pdo->prepare($sql);
$stmt->execute([
    'email' => $_POST['email'],
    'status' => 'active'
]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

// Positional parameters
$sql = "SELECT * FROM users WHERE id = ?";
$stmt = $pdo->prepare($sql);
$stmt->execute([1]);
$user = $stmt->fetch();

// MySQLi Prepared Statements
$mysqli = new mysqli("localhost", "root", "", "myapp");

$sql = "SELECT * FROM users WHERE email = ? AND status = ?";
$stmt = $mysqli->prepare($sql);
$stmt->bind_param("ss", $_POST['email'], "active");
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

// WRONG - SQL Injection Vulnerable
// $sql = "SELECT * FROM users WHERE email = '{$_POST['email']}'";
// NEVER do this!

// Security Best Practices:
// 1. Always use prepared statements
// 2. Never concatenate user input into SQL
// 3. Validate and sanitize input
// 4. Use appropriate data types
// 5. Limit database user permissions

// Input Validation
function validateEmail($email)
{
    return filter_var($email, FILTER_VALIDATE_EMAIL);
}

if (validateEmail($_POST['email'])) {
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = :email");
    $stmt->execute(['email' => $_POST['email']]);
}

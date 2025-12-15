<?php
// Security Best Practices

// 1. Password Hashing
$password = 'user_password';
$hash = password_hash($password, PASSWORD_DEFAULT);

// Verify password
if (password_verify($password, $hash)) {
    echo "Password correct\n";
}

// 2. Prevent XSS (Cross-Site Scripting)
$userInput = $_POST['comment'] ?? '';
$safe = htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');
echo $safe;

// 3. Prevent SQL Injection (use prepared statements)
$pdo = new PDO("mysql:host=localhost;dbname=myapp", "root", "");
$stmt = $pdo->prepare("SELECT * FROM users WHERE email = :email");
$stmt->execute(['email' => $_POST['email']]);

// 4. CSRF Protection
session_start();
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

// In form: <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">

// Validate CSRF token
if ($_POST['csrf_token'] !== $_SESSION['csrf_token']) {
die("CSRF token validation failed");
}

// 5. Secure session configuration
ini_set('session.cookie_httponly', 1);
ini_set('session.cookie_secure', 1); // HTTPS only
ini_set('session.use_strict_mode', 1);

// 6. Input validation
function validateEmail($email) {
return filter_var($email, FILTER_VALIDATE_EMAIL);
}

// 7. Sanitize output
echo strip_tags($_POST['content']);

// 8. Use HTTPS
if (!isset($_SERVER['HTTPS']) || $_SERVER['HTTPS'] !== 'on') {
header('Location: https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI']);
exit;
}
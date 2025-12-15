<?php
// PDO & CRUD Operations

// PDO Connection
$host = 'localhost';
$db = 'myapp';
$user = 'root';
$pass = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Connected with PDO\n";
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}

// CREATE - Insert data
$sql = "INSERT INTO users (name, email) VALUES (:name, :email)";
$stmt = $pdo->prepare($sql);
$stmt->execute(['name' => 'John Doe', 'email' => 'john@example.com']);
echo "User created\n";

// READ - Select data
$stmt = $pdo->query("SELECT * FROM users");
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);
foreach ($users as $user) {
    echo $user['name'] . "\n";
}

// UPDATE - Modify data
$sql = "UPDATE users SET email = :email WHERE id = :id";
$stmt = $pdo->prepare($sql);
$stmt->execute(['email' => 'newemail@example.com', 'id' => 1]);
echo "User updated\n";

// DELETE - Remove data
$sql = "DELETE FROM users WHERE id = :id";
$stmt = $pdo->prepare($sql);
$stmt->execute(['id' => 1]);
echo "User deleted\n";

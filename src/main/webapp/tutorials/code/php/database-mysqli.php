<?php
// MySQL & MySQLi Basics

// MySQLi Connection (Procedural)
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'myapp';

$conn = mysqli_connect($host, $username, $password, $database);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

echo "Connected successfully\n";

// MySQLi Connection (Object-Oriented)
$mysqli = new mysqli($host, $username, $password, $database);

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

echo "Connected successfully (OOP)\n";

// Simple Query
$sql = "SELECT * FROM users";
$result = mysqli_query($conn, $sql);

while ($row = mysqli_fetch_assoc($result)) {
    echo $row['name'] . "\n";
}

// OOP Query
$result = $mysqli->query("SELECT * FROM users");
while ($row = $result->fetch_assoc()) {
    echo $row['name'] . "\n";
}

// Close connection
mysqli_close($conn);
$mysqli->close();

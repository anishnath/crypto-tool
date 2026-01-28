<?php
// PHP preg_match() - Regular expression match

// Simple match
$text = "Hello World 123";
if (preg_match('/\d+/', $text)) {
    echo "Contains numbers: YES\n";
}

// Extract match
preg_match('/(\d+)/', $text, $matches);
echo "Number found: " . $matches[1] . "\n\n";

// Email validation
$email = "user@example.com";
$pattern = '/^[\w\.-]+@[\w\.-]+\.\w{2,}$/';
if (preg_match($pattern, $email)) {
    echo "Email '$email': VALID\n";
}

// Named groups
$date = "2025-01-28";
preg_match('/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/', $date, $m);
echo "\nDate parts:\n";
echo "Year: " . $m['year'] . ", Month: " . $m['month'] . ", Day: " . $m['day'];
?>

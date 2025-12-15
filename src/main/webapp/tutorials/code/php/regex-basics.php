<?php
// Regular Expressions

// preg_match - Find match
$text = "My email is john@example.com";
if (preg_match('/[\w\.-]+@[\w\.-]+\.\w+/', $text, $matches)) {
    echo "Email found: " . $matches[0] . "\n";
}

// preg_match_all - Find all matches
$text = "Call 123-456-7890 or 098-765-4321";
preg_match_all('/\d{3}-\d{3}-\d{4}/', $text, $matches);
print_r($matches[0]);

// preg_replace - Replace pattern
$text = "Hello World";
$result = preg_replace('/World/', 'PHP', $text);
echo $result . "\n"; // Hello PHP

// Common patterns
$patterns = [
    'email' => '/^[\w\.-]+@[\w\.-]+\.\w+$/',
    'phone' => '/^\d{3}-\d{3}-\d{4}$/',
    'url' => '/^https?:\/\/[\w\.-]+\.\w+/',
    'zipcode' => '/^\d{5}(-\d{4})?$/',
];

// Validate email
$email = "user@example.com";
if (preg_match($patterns['email'], $email)) {
    echo "Valid email\n";
}

// Extract data
$html = '<a href="https://example.com">Link</a>';
preg_match('/<a href="([^"]+)">([^<]+)<\/a>/', $html, $matches);
echo "URL: " . $matches[1] . "\n";
echo "Text: " . $matches[2] . "\n";

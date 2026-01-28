<?php
// PHP urlencode() - URL encode string

$text = "hello world";
echo "Original: $text\n";
echo "Encoded: " . urlencode($text) . "\n\n";

// Special characters
$special = "name=John&age=30";
echo "Special chars: $special\n";
echo "Encoded: " . urlencode($special) . "\n\n";

// Building URL with query parameter
$searchTerm = "PHP & MySQL tutorial";
$url = "https://example.com/search?q=" . urlencode($searchTerm);
echo "Full URL: $url\n\n";

// Compare with rawurlencode
echo "urlencode('a b'):    " . urlencode('a b') . "\n";
echo "rawurlencode('a b'): " . rawurlencode('a b');
?>

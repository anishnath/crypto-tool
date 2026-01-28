<?php
// PHP preg_replace() - Regex search and replace

// Remove extra whitespace
$text = "Hello    World   PHP";
$clean = preg_replace('/\s+/', ' ', $text);
echo "Clean: $clean\n";

// Replace digits
$str = "Order #123 total $456";
$masked = preg_replace('/\d/', 'X', $str);
echo "Masked: $masked\n";

// Backreferences
$name = "John Smith";
$reversed = preg_replace('/(\w+)\s+(\w+)/', '$2, $1', $name);
echo "Reversed: $reversed\n";

// Multiple patterns
$html = "<b>Bold</b> and <i>Italic</i>";
$patterns = ['/<b>/', '/<\/b>/', '/<i>/', '/<\/i>/'];
$replacements = ['**', '**', '_', '_'];
$markdown = preg_replace($patterns, $replacements, $html);
echo "Markdown: $markdown\n";
?>

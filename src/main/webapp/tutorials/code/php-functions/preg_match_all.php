<?php
// PHP preg_match_all() - Global regex match

$text = "Contact: 123-456-7890 or 987-654-3210";

// Find all phone numbers
$count = preg_match_all('/\d{3}-\d{3}-\d{4}/', $text, $matches);
echo "Found $count phone numbers:\n";
print_r($matches[0]);

// Extract all emails
$html = "Email john@test.com or jane@example.org for info";
preg_match_all('/[\w\.-]+@[\w\.-]+\.\w+/', $html, $emails);
echo "\nEmails found:\n";
foreach ($emails[0] as $email) {
    echo "- $email\n";
}

// With groups
$links = '<a href="page1.html">Link1</a> <a href="page2.html">Link2</a>';
preg_match_all('/href="([^"]+)"/', $links, $hrefs);
echo "\nHref values:\n";
print_r($hrefs[1]);
?>

<?php
// PHP get_meta_tags() - Extract meta tags from HTML

// Create sample HTML
$html = <<<HTML
<!DOCTYPE html>
<html>
<head>
    <meta name="description" content="This is a test page">
    <meta name="keywords" content="php, tutorial, example">
    <meta name="author" content="John Doe">
    <meta name="viewport" content="width=device-width">
    <title>Test Page</title>
</head>
<body></body>
</html>
HTML;

// Write to temp file (get_meta_tags needs a file)
$tempFile = '/tmp/test_meta_' . uniqid() . '.html';
file_put_contents($tempFile, $html);

// Extract meta tags
$tags = get_meta_tags($tempFile);

echo "Extracted meta tags:\n";
echo "====================\n";
print_r($tags);

// Access individual tags
echo "\nDescription: " . ($tags['description'] ?? 'N/A') . "\n";
echo "Keywords: " . ($tags['keywords'] ?? 'N/A') . "\n";
echo "Author: " . ($tags['author'] ?? 'N/A') . "\n";

// Cleanup
unlink($tempFile);
?>

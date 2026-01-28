<?php
// PHP preg_grep() - Filter array by regex

$files = ['test.php', 'image.jpg', 'app.php', 'style.css', 'data.json'];

// Find PHP files
$phpFiles = preg_grep('/\.php$/', $files);
echo "PHP files:\n";
print_r($phpFiles);

// Find non-PHP files (invert)
$nonPhp = preg_grep('/\.php$/', $files, PREG_GREP_INVERT);
echo "Non-PHP files:\n";
print_r($nonPhp);

// Find items with numbers
$items = ['item1', 'product', 'item2', 'service', 'item10'];
$numbered = preg_grep('/\d/', $items);
echo "Items with numbers:\n";
print_r($numbered);

// Case-insensitive search
$names = ['John', 'jane', 'JAMES', 'Bob'];
$jNames = preg_grep('/^j/i', $names);
echo "Names starting with J:\n";
print_r($jNames);
?>

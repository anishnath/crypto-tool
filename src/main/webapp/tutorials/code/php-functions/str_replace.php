<?php
// str_replace() - Replace all occurrences of search with replacement
// One of the most used string functions in PHP

// Example 1: Simple replacement
$text = "Hello World!";
echo "Original: $text\n";
echo "Replace 'World' with 'PHP': " . str_replace("World", "PHP", $text) . "\n\n";

// Example 2: Replace ALL occurrences
$repeated = "PHP is cool. PHP is fast. PHP is popular.";
echo "Original: $repeated\n";
echo "Replace all 'PHP': " . str_replace("PHP", "Python", $repeated) . "\n\n";

// Example 3: Multiple search/replace pairs
$template = "Dear {NAME}, your order #{ORDER_ID} is {STATUS}.";
echo "Template: $template\n";

$result = str_replace(
    ["{NAME}", "{ORDER_ID}", "{STATUS}"],
    ["John", "12345", "shipped"],
    $template
);
echo "Filled: $result\n\n";

// Example 4: Count replacements
$html = "<p>First</p> <p>Second</p> <p>Third</p>";
$count = 0;
$result = str_replace("<p>", "<div>", $html, $count);
$result = str_replace("</p>", "</div>", $result);
echo "HTML: $html\n";
echo "Converted: $result\n";
echo "Replacements made: $count\n\n";

// Example 5: Create URL slug
$title = "Hello World! This is a Test.";
$slug = str_replace(" ", "-", strtolower($title));
$slug = str_replace(["!", "."], "", $slug);
echo "Title: $title\n";
echo "Slug: $slug\n";

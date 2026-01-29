<?php
// Natural case-insensitive sort
$files = [
    "img12.png",
    "img10.png",
    "IMG2.png",
    "img1.png",
    "IMG20.png"
];

echo "Original:\n";
print_r($files);

natcasesort($files);
echo "\nAfter natcasesort():\n";
print_r($files);

// Compare with regular sort
$files2 = ["img12.png", "img10.png", "IMG2.png", "img1.png"];
sort($files2);
echo "\nRegular sort() for comparison:\n";
print_r($files2);
?>
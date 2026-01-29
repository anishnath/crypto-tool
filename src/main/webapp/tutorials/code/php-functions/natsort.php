<?php
// Natural order sort
$files = [
    "img12.png",
    "img10.png",
    "img2.png",
    "img1.png",
    "img20.png"
];

echo "Original:\n";
print_r($files);

natsort($files);
echo "\nAfter natsort():\n";
print_r($files);

// Compare with regular sort
$files2 = ["img12.png", "img10.png", "img2.png", "img1.png"];
sort($files2);
echo "\nRegular sort() for comparison:\n";
print_r($files2);
?>
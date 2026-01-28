<?php
echo "Basic: " . uniqid() . "\n";
echo "Prefix: " . uniqid('prefix_') . "\n";
echo "More entropy: " . uniqid('', true) . "\n";
?>
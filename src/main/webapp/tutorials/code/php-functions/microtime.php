<?php
// Microsecond precision
$start = microtime(true);
usleep(100);
$end = microtime(true);

echo "Execution time: " . ($end - $start) . " seconds\n";
echo "Current microtime: " . microtime() . "\n";
?>
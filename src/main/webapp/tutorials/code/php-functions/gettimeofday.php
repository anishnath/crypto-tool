<?php
// Get current time
$time = gettimeofday();

echo "Seconds: " . $time['sec'] . "\n";
echo "Microseconds: " . $time['usec'] . "\n";
echo "Minutes West: " . $time['minuteswest'] . "\n";

// Get as float
echo "Float time: " . gettimeofday(true) . "\n";
?>
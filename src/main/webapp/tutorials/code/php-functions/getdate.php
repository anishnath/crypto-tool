<?php
// Get current date/time info
$date = getdate();

echo "Seconds: " . $date['seconds'] . "\n";
echo "Minutes: " . $date['minutes'] . "\n";
echo "Hours:   " . $date['hours'] . "\n";
echo "Day:     " . $date['mday'] . "\n";
echo "Month:   " . $date['mon'] . "\n";
echo "Year:    " . $date['year'] . "\n";
echo "Weekday: " . $date['weekday'] . "\n";
?>
<?php
// Get local time array
$localtime = localtime(time(), true);

echo "Year: " . ($localtime['tm_year'] + 1900) . "\n";
echo "Month: " . ($localtime['tm_mon'] + 1) . "\n";
echo "Day: " . $localtime['tm_mday'] . "\n";
echo "Hour: " . $localtime['tm_hour'] . "\n";
?>
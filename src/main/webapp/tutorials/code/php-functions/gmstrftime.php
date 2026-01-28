<?php
// Format GMT time
setlocale(LC_TIME, 'en_US');
echo gmstrftime("%b %d %Y %H:%M:%S", mktime(20, 0, 0, 12, 31, 98)) . "\n";
echo gmstrftime("%A %d %B %Y"); // Current GMT
?>
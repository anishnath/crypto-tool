<?php
// High resolution time
$start = hrtime(true);
usleep(1000); // sleep for 1ms
$end = hrtime(true);

echo "Nanoseconds elapsed: " . ($end - $start) . "\n";
print_r(hrtime()); // Returns array [seconds, nanoseconds]
?>
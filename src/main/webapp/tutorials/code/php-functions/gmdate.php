<?php
// GMT date format
echo "Local: " . date("Y-m-d H:i:s") . "\n";
echo "GMT:   " . gmdate("Y-m-d H:i:s") . "\n";

// Specific timestamp
echo gmdate("M d Y H:i:s", mktime(0, 0, 0, 1, 1, 1998));
?>
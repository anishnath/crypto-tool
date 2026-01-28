<?php
$jd = gregoriantojd(10, 3, 1975);
$unix = jdtounix($jd);
echo $unix; // Timestamp
?>
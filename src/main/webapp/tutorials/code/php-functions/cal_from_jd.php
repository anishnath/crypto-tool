<?php
$jd = gregoriantojd(10, 3, 1975);
print_r(cal_from_jd($jd, CAL_GREGORIAN));
?>
<?php
$binarydata = "\x12\x34\x56\x78\x41\x42";
$array = unpack("nint1/vint2/c*chars", $binarydata);
print_r($array);
?>
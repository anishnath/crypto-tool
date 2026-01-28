<?php
$serialized = 'a:3:{i:0;s:5:"apple";i:1;s:6:"banana";i:2;s:6:"orange";}';
$data = unserialize($serialized);
print_r($data);
?>
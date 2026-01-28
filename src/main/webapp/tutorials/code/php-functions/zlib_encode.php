<?php
$data = "Hello World! Hello World! Hello World!";
$compressed = zlib_encode($data, ZLIB_ENCODING_DEFLATE);
echo bin2hex($compressed);
?>
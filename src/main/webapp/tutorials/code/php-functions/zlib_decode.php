<?php
// Compressed hex data (DEFLATE)
$compressedHex = "789cf348cdc9c95708cf2fca495154f0c0c50100ff080cf8";
$compressed = hex2bin($compressedHex);
$uncompressed = zlib_decode($compressed);
echo $uncompressed;
?>
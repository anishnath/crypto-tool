<?php
// PHP runs on the server and generates HTML
// This code executes on the server before being sent to the browser

$serverTime = date("Y-m-d H:i:s");
echo "Server time: " . $serverTime;
echo "\n";
echo "This was generated on the server!";

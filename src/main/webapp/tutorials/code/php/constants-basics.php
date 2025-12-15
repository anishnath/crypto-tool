<?php
// Constants in PHP

// Define a constant using define()
define("SITE_NAME", "8gwifi.org");
define("MAX_USERS", 100);
define("PI", 3.14159);

echo "Site: " . SITE_NAME;
echo "\n";
echo "Max Users: " . MAX_USERS;
echo "\n";
echo "Pi: " . PI;
echo "\n";

// Constants using const keyword (PHP 5.3+)
const APP_VERSION = "1.0.0";
const DEBUG_MODE = true;

echo "Version: " . APP_VERSION;
echo "\n";
echo "Debug: " . (DEBUG_MODE ? "On" : "Off");
echo "\n";

// Magic constants
echo "File: " . __FILE__;
echo "\n";
echo "Line: " . __LINE__;
echo "\n";
echo "Directory: " . __DIR__;

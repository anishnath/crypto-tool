<?php
// Date & Time

// Current date and time
echo date('Y-m-d H:i:s') . "\n";
echo date('F j, Y') . "\n"; // December 15, 2025

// DateTime object
$now = new DateTime();
echo $now->format('Y-m-d H:i:s') . "\n";

// Create specific date
$date = new DateTime('2025-12-25');
echo $date->format('l, F j, Y') . "\n";

// Modify dates
$date->modify('+7 days');
echo $date->format('Y-m-d') . "\n";

// Date difference
$date1 = new DateTime('2025-01-01');
$date2 = new DateTime('2025-12-31');
$diff = $date1->diff($date2);
echo $diff->days . " days\n";

// Timezones
$date = new DateTime('now', new DateTimeZone('America/New_York'));
echo $date->format('Y-m-d H:i:s T') . "\n";

// Timestamps
$timestamp = time();
echo $timestamp . "\n";
echo date('Y-m-d', $timestamp) . "\n";

// strtotime
$nextWeek = strtotime('+1 week');
echo date('Y-m-d', $nextWeek) . "\n";

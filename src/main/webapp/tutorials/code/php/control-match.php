<?php
// PHP 8 Match Expression Demo
// 8gwifi.org/tutorials

echo "=== PHP 8 Match Expression ===\n\n";

$statusCode = 404;

// Match is an expression (returns a value)
$message = match($statusCode) {
    200 => "OK",
    201 => "Created",
    301 => "Moved Permanently",
    302 => "Found (Redirect)",
    400 => "Bad Request",
    401 => "Unauthorized",
    403 => "Forbidden",
    404 => "Not Found",
    500 => "Internal Server Error",
    default => "Unknown Status"
};

echo "Status $statusCode: $message\n";

echo "\n=== Match with Multiple Values ===\n";
$httpMethod = "POST";

$action = match($httpMethod) {
    "GET" => "Fetching data",
    "POST", "PUT" => "Saving data",
    "DELETE" => "Removing data",
    default => "Unknown method"
};

echo "$httpMethod → $action\n";

echo "\n=== Match vs Switch Comparison ===\n";
$value = "2";

// Match uses strict comparison (===)
$matchResult = match($value) {
    2 => "Integer 2",
    "2" => "String '2'",
    default => "Neither"
};

echo "Match result for '2' (string): $matchResult\n";

echo "\n=== Match in Function ===\n";
function getSeasonEmoji($month) {
    return match(true) {
        in_array($month, [12, 1, 2]) => "❄️ Winter",
        in_array($month, [3, 4, 5]) => "🌸 Spring",
        in_array($month, [6, 7, 8]) => "☀️ Summer",
        in_array($month, [9, 10, 11]) => "🍂 Fall",
        default => "Invalid month"
    };
}

echo "March: " . getSeasonEmoji(3) . "\n";
echo "July: " . getSeasonEmoji(7) . "\n";
echo "October: " . getSeasonEmoji(10) . "\n";
?>

<?php
// CSV File Handling

// Write CSV
$data = [
    ['Name', 'Email', 'Age'],
    ['John Doe', 'john@example.com', 30],
    ['Jane Smith', 'jane@example.com', 25],
    ['Bob Johnson', 'bob@example.com', 35]
];

$handle = fopen('users.csv', 'w');
foreach ($data as $row) {
    fputcsv($handle, $row);
}
fclose($handle);

// Read CSV
$handle = fopen('users.csv', 'r');
while (($row = fgetcsv($handle)) !== false) {
    echo implode(', ', $row) . "\n";
}
fclose($handle);

// Read CSV into associative array
$handle = fopen('users.csv', 'r');
$headers = fgetcsv($handle); // First row as headers
$users = [];

while (($row = fgetcsv($handle)) !== false) {
    $users[] = array_combine($headers, $row);
}
fclose($handle);

print_r($users);

// Using str_getcsv for string parsing
$csvString = "John,john@example.com,30";
$data = str_getcsv($csvString);
print_r($data);

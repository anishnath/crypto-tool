<?php
// PHP preg_filter() - Search, replace, and filter

$subjects = ['abc123', 'hello', 'test456', 'world'];

// Replace digits, return only matched items
$result = preg_filter('/\d+/', '-NUM-', $subjects);
echo "Filtered results:\n";
print_r($result);
// Note: 'hello' and 'world' are excluded

// Compare with preg_replace
$replaced = preg_replace('/\d+/', '-NUM-', $subjects);
echo "\npreg_replace (all items):\n";
print_r($replaced);

// Multiple patterns
$data = ['name: John', 'age: 30', 'city: NYC', 'hello'];
$cleaned = preg_filter('/: /', '=', $data);
echo "\nFiltered with replacement:\n";
print_r($cleaned);
?>

<?php
// PHP Custom Sorting - usort and Advanced Examples
// 8gwifi.org/tutorials

echo "=== Spaceship Operator ===\n";

echo "1 <=> 2: " . (1 <=> 2) . "\n";   // -1
echo "2 <=> 2: " . (2 <=> 2) . "\n";   //  0
echo "3 <=> 2: " . (3 <=> 2) . "\n";   //  1
echo "\"apple\" <=> \"banana\": " . ("apple" <=> "banana") . "\n";

echo "\n=== usort() - Sort Objects by Property ===\n";

$products = [
    ["name" => "Widget", "price" => 29.99],
    ["name" => "Gadget", "price" => 49.99],
    ["name" => "Gizmo", "price" => 19.99],
    ["name" => "Thingamajig", "price" => 39.99]
];

// Sort by price ascending
usort($products, fn($a, $b) => $a["price"] <=> $b["price"]);

echo "Sorted by price (ascending):\n";
foreach ($products as $p) {
    echo "  {$p['name']}: \${$p['price']}\n";
}

// Sort by price descending (swap $a and $b)
usort($products, fn($a, $b) => $b["price"] <=> $a["price"]);

echo "\nSorted by price (descending):\n";
foreach ($products as $p) {
    echo "  {$p['name']}: \${$p['price']}\n";
}

echo "\n=== Multi-field Sorting ===\n";

$employees = [
    ["last" => "Smith", "first" => "John", "age" => 30],
    ["last" => "Smith", "first" => "Alice", "age" => 25],
    ["last" => "Jones", "first" => "Bob", "age" => 35],
    ["last" => "Smith", "first" => "Bob", "age" => 28]
];

// Sort by last name, then first name
usort($employees, fn($a, $b) =>
    ($a["last"] <=> $b["last"]) ?: ($a["first"] <=> $b["first"])
);

echo "Sorted by last, then first name:\n";
foreach ($employees as $e) {
    echo "  {$e['last']}, {$e['first']} (age {$e['age']})\n";
}

echo "\n=== Sort by String Length ===\n";

$words = ["elephant", "cat", "dog", "hippopotamus", "ant"];
usort($words, fn($a, $b) => strlen($a) <=> strlen($b));
echo "By length: " . implode(", ", $words) . "\n";

echo "\n=== Sort Dates ===\n";

$events = [
    ["name" => "Meeting", "date" => "2024-03-15"],
    ["name" => "Deadline", "date" => "2024-01-20"],
    ["name" => "Launch", "date" => "2024-02-28"]
];

usort($events, fn($a, $b) =>
    strtotime($a["date"]) <=> strtotime($b["date"])
);

echo "Events by date:\n";
foreach ($events as $e) {
    echo "  {$e['date']}: {$e['name']}\n";
}

echo "\n=== Custom Priority Order ===\n";

$tasks = [
    ["title" => "Fix bug", "priority" => "medium"],
    ["title" => "Deploy", "priority" => "high"],
    ["title" => "Update docs", "priority" => "low"],
    ["title" => "Code review", "priority" => "high"]
];

$priorityOrder = ["high" => 1, "medium" => 2, "low" => 3];

usort($tasks, fn($a, $b) =>
    $priorityOrder[$a["priority"]] <=> $priorityOrder[$b["priority"]]
);

echo "Tasks by priority:\n";
foreach ($tasks as $t) {
    echo "  [{$t['priority']}] {$t['title']}\n";
}

echo "\n=== uasort() - Preserve Keys ===\n";

$grades = [
    "alice" => 85,
    "bob" => 92,
    "carol" => 78
];

uasort($grades, fn($a, $b) => $b <=> $a);  // Descending

echo "Grades (descending, keys preserved):\n";
foreach ($grades as $name => $grade) {
    echo "  $name: $grade\n";
}

echo "\n=== array_multisort() ===\n";

$names = ["Carol", "Alice", "Bob"];
$ages = [30, 25, 35];

array_multisort($names, SORT_ASC, $ages);
echo "Names: " . implode(", ", $names) . "\n";
echo "Ages (following names): " . implode(", ", $ages) . "\n";
?>

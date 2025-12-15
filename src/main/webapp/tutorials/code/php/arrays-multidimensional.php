<?php
// PHP Multidimensional Arrays Demo
// 8gwifi.org/tutorials

echo "=== 2D Array (Matrix) ===\n";
$matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

echo "Matrix:\n";
for ($row = 0; $row < count($matrix); $row++) {
    for ($col = 0; $col < count($matrix[$row]); $col++) {
        echo $matrix[$row][$col] . " ";
    }
    echo "\n";
}

echo "\nAccess specific element: \$matrix[1][2] = " . $matrix[1][2] . "\n";

echo "\n=== Array of Associative Arrays ===\n";
$students = [
    ["name" => "Alice", "grade" => 95, "subject" => "Math"],
    ["name" => "Bob", "grade" => 88, "subject" => "Science"],
    ["name" => "Carol", "grade" => 92, "subject" => "English"]
];

echo "Student Records:\n";
foreach ($students as $index => $student) {
    echo ($index + 1) . ". {$student['name']}: {$student['grade']} in {$student['subject']}\n";
}

echo "\n=== Nested Associative Arrays ===\n";
$company = [
    "name" => "TechCorp",
    "founded" => 2010,
    "departments" => [
        "engineering" => [
            "head" => "Alice Johnson",
            "employees" => 25,
            "projects" => ["Website", "Mobile App", "API"]
        ],
        "sales" => [
            "head" => "Bob Smith",
            "employees" => 15,
            "projects" => ["North Region", "South Region"]
        ]
    ]
];

echo "Company: " . $company["name"] . "\n";
echo "Engineering Head: " . $company["departments"]["engineering"]["head"] . "\n";
echo "Engineering Projects: " . implode(", ", $company["departments"]["engineering"]["projects"]) . "\n";

echo "\n=== Computing Stats from 2D Array ===\n";
$salesData = [
    ["Jan", 1500, 1200, 1800],
    ["Feb", 1600, 1300, 1700],
    ["Mar", 1800, 1500, 2000]
];

foreach ($salesData as $row) {
    $month = $row[0];
    $total = $row[1] + $row[2] + $row[3];
    echo "$month Total: \$$total\n";
}
?>

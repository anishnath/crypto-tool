<?php
// PHP Break and Continue Levels Demo
// 8gwifi.org/tutorials

echo "=== Break with Levels ===\n";
echo "Finding value in 2D array:\n\n";

$matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];
$target = 5;
$found = false;

foreach ($matrix as $rowIndex => $row) {
    foreach ($row as $colIndex => $value) {
        echo "Checking [$rowIndex][$colIndex] = $value\n";
        if ($value === $target) {
            echo "Found $target at position [$rowIndex][$colIndex]!\n";
            $found = true;
            break 2;  // Exit BOTH loops
        }
    }
}

if (!$found) {
    echo "$target not found\n";
}

echo "\n=== Continue with Levels ===\n";
echo "Skipping rows with negative numbers:\n\n";

$data = [
    [1, 2, 3],
    [4, -5, 6],  // Has negative
    [7, 8, 9],
    [-1, 2, 3],  // Has negative
    [10, 11, 12]
];

foreach ($data as $rowNum => $row) {
    // Check for negative in this row
    foreach ($row as $val) {
        if ($val < 0) {
            echo "Row $rowNum has negative, skipping...\n";
            continue 2;  // Skip to next outer iteration
        }
    }

    // Only reached if no negatives found
    echo "Row $rowNum: " . implode(", ", $row) . "\n";
}

echo "\n=== Three Levels Deep ===\n";
echo "3D array traversal with break 3:\n\n";

$cube = [
    [[1, 2], [3, 4]],
    [[5, 6], [7, 8]],
    [[9, 10], [11, 12]]
];
$searchFor = 7;

for ($x = 0; $x < count($cube); $x++) {
    for ($y = 0; $y < count($cube[$x]); $y++) {
        for ($z = 0; $z < count($cube[$x][$y]); $z++) {
            $val = $cube[$x][$y][$z];
            echo "Checking [$x][$y][$z] = $val\n";
            if ($val === $searchFor) {
                echo "Found $searchFor!\n";
                break 3;  // Exit all 3 loops
            }
        }
    }
}

echo "\n=== Practical: Menu with Exit ===\n";

$running = true;
$menuOptions = [1, 2, 3, 4, 4];  // Simulated inputs, 4 = exit
$optionIndex = 0;

while ($running) {
    $choice = $menuOptions[$optionIndex++] ?? 4;

    switch ($choice) {
        case 1:
            echo "Option 1 selected\n";
            break;  // Exits switch only
        case 2:
            echo "Option 2 selected\n";
            break;  // Exits switch only
        case 3:
            echo "Option 3 selected\n";
            break;  // Exits switch only
        case 4:
            echo "Exiting...\n";
            break 2;  // Exits switch AND while loop
        default:
            echo "Invalid option\n";
    }
}

echo "Program ended.\n";
?>

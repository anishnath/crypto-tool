<?php
// Basic combine
$keys = ["a", "b", "c"];
$values = [1, 2, 3];

echo "Keys: ";
print_r($keys);
echo "Values: ";
print_r($values);

$combined = array_combine($keys, $values);
echo "\nCombined: ";
print_r($combined);

// With strings
$names = ["first_name", "last_name", "email"];
$data = ["John", "Doe", "john@example.com"];
$person = array_combine($names, $data);
echo "\nPerson data: ";
print_r($person);

// Numbers as keys
$ids = [101, 102, 103];
$products = ["Laptop", "Mouse", "Keyboard"];
$inventory = array_combine($ids, $products);
echo "\nInventory: ";
print_r($inventory);

// Different lengths throw ValueError in PHP 8.0+
$k = [1, 2];
$v = [1, 2, 3];

try {
    $result = array_combine($k, $v);
    echo "\nDifferent lengths result: ";
    var_dump($result);
} catch (ValueError $e) {
    echo "\nError: " . $e->getMessage() . "\n";
} catch (Exception $e) {
    echo "\nError: Arrays have different lengths\n";
}
?>
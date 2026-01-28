<?php
// Get variable type as string
echo gettype("Hello");   // string
echo "\n";
echo gettype(42);        // integer
echo "\n";
echo gettype(3.14);      // double
echo "\n";
echo gettype(true);      // boolean
echo "\n";
echo gettype([1, 2]);    // array
echo "\n";
echo gettype(null);      // NULL
echo "\n";

// Object type
$obj = new stdClass();
echo gettype($obj);      // object
echo "\n";

// Type checking
$val = "123";
if (gettype($val) === "string") {
    echo "It's a string";
}
?>

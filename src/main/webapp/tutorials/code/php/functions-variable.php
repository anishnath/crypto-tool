<?php
// Variable Functions and Anonymous Functions

// Variable functions
function sayHello()
{
    return "Hello!";
}

$func = 'sayHello';
echo $func();  // Calls sayHello()
echo "\n";

// Anonymous function (closure)
$greet = function ($name) {
    return "Hello, $name!";
};

echo $greet("Alice");
echo "\n";

// Anonymous function with use
$message = "Welcome";
$greeter = function ($name) use ($message) {
    return "$message, $name!";
};

echo $greeter("Bob");
echo "\n";

// Callback functions
$numbers = [1, 2, 3, 4, 5];

$squared = array_map(function ($n) {
    return $n * $n;
}, $numbers);

print_r($squared);

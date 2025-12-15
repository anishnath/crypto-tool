<?php
// Function Scope and Static Variables

// Global scope
$globalVar = "I'm global";

function testScope()
{
    // Cannot access $globalVar directly
    // echo $globalVar;  // Error!

    // Must use global keyword
    global $globalVar;
    echo $globalVar;
    echo "\n";
}

testScope();

// Static variables
function counter()
{
    static $count = 0;
    $count++;
    return $count;
}

echo counter();  // 1
echo "\n";
echo counter();  // 2
echo "\n";
echo counter();  // 3
echo "\n";

// Local scope
function localExample()
{
    $local = "I'm local";
    return $local;
}

echo localExample();
// echo $local;  // Error! Not accessible outside function

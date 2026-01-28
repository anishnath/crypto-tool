<?php
// Debug variable - shows type and value
$str = "Hello";
var_dump($str);  // string(5) "Hello"

$num = 42;
var_dump($num);  // int(42)

$arr = [1, 2, 3];
var_dump($arr);

// Object
$obj = new stdClass();
$obj->name = "John";
var_dump($obj);

// Multiple variables
$a = true;
$b = 3.14;
var_dump($a, $b);
?>

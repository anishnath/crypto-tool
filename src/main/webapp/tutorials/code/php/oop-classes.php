<?php
// Classes and Objects Basics

// Define a class
class Car
{
    // Properties
    public $brand;
    public $color;

    // Method
    public function drive()
    {
        echo "The $this->color $this->brand is driving!";
    }
}

// Create an object (instance)
$myCar = new Car();
$myCar->brand = "Toyota";
$myCar->color = "red";

echo $myCar->brand;  // Toyota
echo "\n";
$myCar->drive();
echo "\n";

// Another object
$yourCar = new Car();
$yourCar->brand = "Honda";
$yourCar->color = "blue";
$yourCar->drive();

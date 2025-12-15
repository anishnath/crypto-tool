<?php
// Abstract Classes

// Abstract class - cannot be instantiated
abstract class Shape
{
    protected $color;

    public function __construct($color)
    {
        $this->color = $color;
    }

    // Abstract method - must be implemented by child classes
    abstract public function calculateArea();

    // Concrete method - can be used by child classes
    public function getColor()
    {
        return $this->color;
    }
}

class Circle extends Shape
{
    private $radius;

    public function __construct($color, $radius)
    {
        parent::__construct($color);
        $this->radius = $radius;
    }

    public function calculateArea()
    {
        return pi() * $this->radius * $this->radius;
    }
}

class Rectangle extends Shape
{
    private $width;
    private $height;

    public function __construct($color, $width, $height)
    {
        parent::__construct($color);
        $this->width = $width;
        $this->height = $height;
    }

    public function calculateArea()
    {
        return $this->width * $this->height;
    }
}

$circle = new Circle("red", 5);
echo "Circle area: " . $circle->calculateArea() . "\n";

$rectangle = new Rectangle("blue", 10, 5);
echo "Rectangle area: " . $rectangle->calculateArea() . "\n";

<?php
// Inheritance

// Parent class
class Animal
{
    public $name;

    public function __construct($name)
    {
        $this->name = $name;
    }

    public function makeSound()
    {
        echo "Some generic sound\n";
    }
}

// Child class extends parent
class Dog extends Animal
{
    public function makeSound()
    {
        echo "$this->name says: Woof!\n";
    }

    public function fetch()
    {
        echo "$this->name is fetching the ball!\n";
    }
}

class Cat extends Animal
{
    public function makeSound()
    {
        echo "$this->name says: Meow!\n";
    }
}

$dog = new Dog("Buddy");
$dog->makeSound();  // Woof!
$dog->fetch();

$cat = new Cat("Whiskers");
$cat->makeSound();  // Meow!

<?php
// Magic Methods

class MagicExample
{
    private $data = [];

    // __get - called when accessing inaccessible property
    public function __get($name)
    {
        echo "__get called for: $name\n";
        return $this->data[$name] ?? null;
    }

    // __set - called when setting inaccessible property
    public function __set($name, $value)
    {
        echo "__set called for: $name = $value\n";
        $this->data[$name] = $value;
    }

    // __isset - called when using isset() on inaccessible property
    public function __isset($name)
    {
        return isset($this->data[$name]);
    }

    // __unset - called when using unset() on inaccessible property
    public function __unset($name)
    {
        unset($this->data[$name]);
    }

    // __toString - called when object is used as string
    public function __toString()
    {
        return "MagicExample object with " . count($this->data) . " properties";
    }

    // __call - called when invoking inaccessible method
    public function __call($name, $arguments)
    {
        echo "__call: $name(" . implode(", ", $arguments) . ")\n";
    }
}

$obj = new MagicExample();

// Triggers __set
$obj->name = "John";
$obj->age = 30;

// Triggers __get
echo $obj->name . "\n";

// Triggers __toString
echo $obj . "\n";

// Triggers __call
$obj->someMethod("arg1", "arg2");

// Triggers __isset
var_dump(isset($obj->name));

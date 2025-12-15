<?php
// Static Properties and Methods

class Counter
{
    // Static property - shared across all instances
    public static $count = 0;

    public $instanceId;

    public function __construct()
    {
        self::$count++;
        $this->instanceId = self::$count;
    }

    // Static method - can be called without instance
    public static function getCount()
    {
        return self::$count;
    }

    // Static method
    public static function reset()
    {
        self::$count = 0;
    }
}

// Call static method without creating instance
echo "Initial count: " . Counter::getCount() . "\n";

$c1 = new Counter();
echo "After c1: " . Counter::getCount() . "\n";

$c2 = new Counter();
$c3 = new Counter();
echo "After c3: " . Counter::getCount() . "\n";

// Access static property
echo "Direct access: " . Counter::$count . "\n";

Counter::reset();
echo "After reset: " . Counter::getCount() . "\n";

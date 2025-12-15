<?php
// Constructors and Destructors

class User
{
    public $name;
    public $email;

    // Constructor - called when object is created
    public function __construct($name, $email)
    {
        $this->name = $name;
        $this->email = $email;
        echo "User created: $name\n";
    }

    // Destructor - called when object is destroyed
    public function __destruct()
    {
        echo "User destroyed: $this->name\n";
    }
}

// Constructor is called automatically
$user1 = new User("Alice", "alice@example.com");
echo $user1->name . "\n";

$user2 = new User("Bob", "bob@example.com");

// Destructors called at end of script

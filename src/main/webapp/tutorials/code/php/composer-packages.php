<?php
// Composer & Packages

/*
Composer is PHP's dependency manager

Installation:
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

Create composer.json:
{
    "require": {
        "monolog/monolog": "^2.0",
        "guzzlehttp/guzzle": "^7.0"
    },
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    }
}

Install packages:
composer install

Update packages:
composer update
*/

// Using Composer autoloader
require 'vendor/autoload.php';

// Using installed package (Monolog example)
use Monolog\Logger;
use Monolog\Handler\StreamHandler;

$log = new Logger('app');
$log->pushHandler(new StreamHandler('app.log', Logger::WARNING));
$log->warning('This is a warning');

// PSR-4 Autoloading
// File: src/User.php
namespace App;

class User
{
    public $name;

    public function __construct($name)
    {
        $this->name = $name;
    }
}

// Usage
use App\User;
$user = new User('John');

// Custom autoloader (without Composer)
spl_autoload_register(function ($class) {
    $file = __DIR__ . '/' . str_replace('\\', '/', $class) . '.php';
    if (file_exists($file)) {
        require $file;
    }
});

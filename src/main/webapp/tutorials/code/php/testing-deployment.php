<?php
// Testing & Deployment

/*
PHPUnit - Unit Testing

Installation:
composer require --dev phpunit/phpunit

Create test: tests/UserTest.php
*/

use PHPUnit\Framework\TestCase;

class UserTest extends TestCase
{
    public function testUserCreation()
    {
        $user = new User('John');
        $this->assertEquals('John', $user->name);
    }

    public function testEmailValidation()
    {
        $this->assertTrue(validateEmail('user@example.com'));
        $this->assertFalse(validateEmail('invalid-email'));
    }
}

/*
Run tests:
./vendor/bin/phpunit tests

Deployment Checklist:

1. Environment Configuration
- Set error_reporting(0) in production
- Use .env files for sensitive data
- Enable OPcache for performance

2. Security
- Disable display_errors
- Use HTTPS
- Set secure session cookies
- Update dependencies regularly

3. Performance
php.ini settings:
opcache.enable=1
opcache.memory_consumption=128
opcache.max_accelerated_files=10000

4. Database
- Use connection pooling
- Enable query caching
- Optimize indexes

5. Monitoring
- Set up error logging
- Monitor server resources
- Track application performance

6. Backup
- Automated database backups
- Code version control (Git)
- Regular backup testing
*/

// Production error handling
if ($_SERVER['SERVER_NAME'] === 'production.com') {
    error_reporting(0);
    ini_set('display_errors', 0);
    ini_set('log_errors', 1);
    ini_set('error_log', '/var/log/php_errors.log');
}

// Environment variables
$dbHost = getenv('DB_HOST') ?: 'localhost';
$dbName = getenv('DB_NAME') ?: 'myapp';

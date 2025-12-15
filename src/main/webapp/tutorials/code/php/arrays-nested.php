<?php
// PHP Nested Arrays - Real-World Examples
// 8gwifi.org/tutorials

echo "=== E-commerce Product Catalog ===\n";
$catalog = [
    "electronics" => [
        [
            "id" => 1,
            "name" => "Laptop",
            "price" => 999.99,
            "specs" => ["RAM" => "16GB", "Storage" => "512GB SSD"]
        ],
        [
            "id" => 2,
            "name" => "Smartphone",
            "price" => 699.99,
            "specs" => ["RAM" => "8GB", "Storage" => "256GB"]
        ]
    ],
    "clothing" => [
        [
            "id" => 3,
            "name" => "T-Shirt",
            "price" => 29.99,
            "sizes" => ["S", "M", "L", "XL"]
        ]
    ]
];

// Navigate and display products
foreach ($catalog as $category => $products) {
    echo "\n--- " . ucfirst($category) . " ---\n";
    foreach ($products as $product) {
        echo "  {$product['name']}: \${$product['price']}\n";
    }
}

echo "\n=== API Response Structure ===\n";
$apiResponse = [
    "status" => "success",
    "code" => 200,
    "data" => [
        "users" => [
            ["id" => 1, "name" => "Alice", "email" => "alice@test.com"],
            ["id" => 2, "name" => "Bob", "email" => "bob@test.com"]
        ],
        "pagination" => [
            "page" => 1,
            "per_page" => 10,
            "total" => 2
        ]
    ]
];

echo "Status: " . $apiResponse["status"] . "\n";
echo "Users found: " . $apiResponse["data"]["pagination"]["total"] . "\n\n";

foreach ($apiResponse["data"]["users"] as $user) {
    echo "User #{$user['id']}: {$user['name']} ({$user['email']})\n";
}

echo "\n=== Configuration File Structure ===\n";
$config = [
    "app" => [
        "name" => "My Application",
        "version" => "2.0.0",
        "debug" => true
    ],
    "database" => [
        "primary" => [
            "host" => "localhost",
            "port" => 3306,
            "name" => "myapp_db"
        ],
        "replica" => [
            "host" => "replica.example.com",
            "port" => 3306,
            "name" => "myapp_db"
        ]
    ],
    "cache" => [
        "driver" => "redis",
        "host" => "127.0.0.1",
        "ttl" => 3600
    ]
];

// Access nested config values
echo "App: " . $config["app"]["name"] . " v" . $config["app"]["version"] . "\n";
echo "Primary DB: " . $config["database"]["primary"]["host"] . ":" . $config["database"]["primary"]["port"] . "\n";
echo "Cache TTL: " . $config["cache"]["ttl"] . " seconds\n";

echo "\n=== Modifying Nested Arrays ===\n";
// Add a new product
$catalog["electronics"][] = [
    "id" => 4,
    "name" => "Tablet",
    "price" => 449.99,
    "specs" => ["RAM" => "4GB", "Storage" => "128GB"]
];

echo "Added Tablet to electronics.\n";
echo "Electronics now has " . count($catalog["electronics"]) . " products.\n";
?>

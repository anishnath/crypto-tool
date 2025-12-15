<?php
// PHP Alternative If Syntax Demo
// 8gwifi.org/tutorials

$userRole = "admin";
$isLoggedIn = true;

echo "=== Alternative Syntax (if: endif;) ===\n";
echo "Useful for mixing PHP with HTML in templates.\n\n";

// Alternative syntax
if ($isLoggedIn):
    echo "Welcome back!\n";

    if ($userRole === "admin"):
        echo "You have admin privileges.\n";
    elseif ($userRole === "editor"):
        echo "You can edit content.\n";
    else:
        echo "You have standard access.\n";
    endif;

else:
    echo "Please log in.\n";
endif;

echo "\n=== When to Use Alternative Syntax ===\n";
echo "• In template files mixing HTML and PHP\n";
echo "• When code blocks span multiple lines of HTML\n";
echo "• For better readability in views\n";

echo "\n=== Single-Line If (Not Recommended) ===\n";
$status = "active";

// Works but not recommended
if ($status === "active") echo "Account is active.\n";

// Better: always use braces
if ($status === "active") {
    echo "Account is active (with braces).\n";
}
?>

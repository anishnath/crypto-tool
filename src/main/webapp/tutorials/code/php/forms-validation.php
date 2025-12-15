<?php
// Form Validation

// Validate required fields
function validateRequired($value)
{
    return !empty(trim($value));
}

// Validate email
function validateEmail($email)
{
    return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
}

// Validate length
function validateLength($value, $min, $max)
{
    $length = strlen($value);
    return $length >= $min && $length <= $max;
}

// Example validation
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $errors = [];

    // Validate name
    if (!validateRequired($_POST['name'] ?? '')) {
        $errors[] = "Name is required";
    }

    // Validate email
    $email = $_POST['email'] ?? '';
    if (!validateRequired($email)) {
        $errors[] = "Email is required";
    } elseif (!validateEmail($email)) {
        $errors[] = "Invalid email format";
    }

    // Validate password
    $password = $_POST['password'] ?? '';
    if (!validateLength($password, 8, 50)) {
        $errors[] = "Password must be 8-50 characters";
    }

    if (empty($errors)) {
        echo "Form is valid!\n";
    } else {
        foreach ($errors as $error) {
            echo "Error: $error\n";
        }
    }
}

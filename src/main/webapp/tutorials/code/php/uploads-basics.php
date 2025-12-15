<?php
// File Uploads

// Check if file was uploaded
if (isset($_FILES['upload'])) {
    $file = $_FILES['upload'];

    // File information
    echo "Name: " . $file['name'] . "\n";
    echo "Type: " . $file['type'] . "\n";
    echo "Size: " . $file['size'] . " bytes\n";
    echo "Temp: " . $file['tmp_name'] . "\n";
    echo "Error: " . $file['error'] . "\n";

    // Check for errors
    if ($file['error'] === UPLOAD_ERR_OK) {
        // Validate file type
        $allowed = ['image/jpeg', 'image/png', 'image/gif'];
        if (in_array($file['type'], $allowed)) {
            // Validate file size (5MB max)
            if ($file['size'] <= 5 * 1024 * 1024) {
                // Generate safe filename
                $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
                $filename = uniqid() . '.' . $extension;
                $destination = 'uploads/' . $filename;

                // Move uploaded file
                if (move_uploaded_file($file['tmp_name'], $destination)) {
                    echo "File uploaded successfully: $filename\n";
                } else {
                    echo "Failed to move uploaded file\n";
                }
            } else {
                echo "File too large (max 5MB)\n";
            }
        } else {
            echo "Invalid file type\n";
        }
    } else {
        echo "Upload error: " . $file['error'] . "\n";
    }
}

// Upload errors:
// UPLOAD_ERR_OK (0) - Success
// UPLOAD_ERR_INI_SIZE (1) - Exceeds upload_max_filesize
// UPLOAD_ERR_FORM_SIZE (2) - Exceeds MAX_FILE_SIZE
// UPLOAD_ERR_PARTIAL (3) - Partially uploaded
// UPLOAD_ERR_NO_FILE (4) - No file uploaded

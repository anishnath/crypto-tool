#!/bin/bash
# File Validation Patterns

echo "=== File Validation Patterns ==="
echo ""

# Function: Validate input file
validate_file() {
    local file="$1"
    local errors=0

    echo "Validating: $file"

    # Check if path provided
    if [[ -z "$file" ]]; then
        echo "  ERROR: No file path provided"
        return 1
    fi

    # Check existence
    if [[ ! -e "$file" ]]; then
        echo "  ERROR: File does not exist"
        return 1
    fi

    # Check if regular file
    if [[ ! -f "$file" ]]; then
        echo "  ERROR: Not a regular file"
        return 1
    fi

    # Check readable
    if [[ ! -r "$file" ]]; then
        echo "  ERROR: File not readable"
        ((errors++))
    fi

    # Check not empty
    if [[ ! -s "$file" ]]; then
        echo "  WARNING: File is empty"
    fi

    if [[ $errors -eq 0 ]]; then
        echo "  VALID: All checks passed"
        return 0
    else
        return 1
    fi
}

# Test cases
echo "--- Test Case 1: Valid file ---"
echo "test" > /tmp/valid.txt
validate_file "/tmp/valid.txt"
echo ""

echo "--- Test Case 2: Non-existent ---"
validate_file "/tmp/nonexistent_file.txt"
echo ""

echo "--- Test Case 3: Directory instead of file ---"
mkdir -p /tmp/testdir
validate_file "/tmp/testdir"
echo ""

echo "--- Test Case 4: Empty file ---"
touch /tmp/empty.txt
validate_file "/tmp/empty.txt"
echo ""

# Function: Safe file read
safe_read() {
    local file="$1"
    if [[ -f "$file" && -r "$file" ]]; then
        cat "$file"
        return 0
    else
        echo "ERROR: Cannot read file: $file" >&2
        return 1
    fi
}

echo "--- Safe Read Example ---"
safe_read "/tmp/valid.txt" && echo "(read successful)"
safe_read "/tmp/nonexistent.txt" || echo "(read failed as expected)"

# Cleanup
rm -f /tmp/valid.txt /tmp/empty.txt
rmdir /tmp/testdir 2>/dev/null

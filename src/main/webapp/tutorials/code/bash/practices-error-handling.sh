#!/usr/bin/env bash
# Error Handling Demo

echo "=== Error Handling Basics ==="
echo ""

# Demo 1: Exit codes
echo "--- Exit Codes ---"

# Success command
ls /tmp >/dev/null 2>&1
echo "ls /tmp: exit code = $?"

# Failed command (directory doesn't exist)
ls /nonexistent_dir 2>/dev/null
echo "ls /nonexistent_dir: exit code = $?"

echo ""

# Demo 2: The || and && operators
echo "--- Conditional Execution ---"

# Run second command only if first fails
ls /nonexistent 2>/dev/null || echo "Directory not found (|| triggered)"

# Run second command only if first succeeds
ls /tmp >/dev/null && echo "Directory exists (&& triggered)"

echo ""

# Demo 3: Custom die function
die() {
    echo "ERROR: $*" >&2
    # In real script: exit 1
    return 1
}

echo "--- Die Function ---"
# Simulating error
die "Something went wrong" 2>&1 || true
echo ""

# Demo 4: Checking command existence
echo "--- Command Existence Check ---"

check_command() {
    if command -v "$1" &>/dev/null; then
        echo "✓ $1 found"
        return 0
    else
        echo "✗ $1 NOT found"
        return 1
    fi
}

check_command "bash"
check_command "grep"
check_command "fake_command_xyz"

echo ""

# Demo 5: Input validation
echo "--- Input Validation ---"

validate_file() {
    local file="$1"

    if [[ -z "$file" ]]; then
        echo "Error: No file specified" >&2
        return 1
    fi

    if [[ ! -f "$file" ]]; then
        echo "Error: File not found: $file" >&2
        return 1
    fi

    if [[ ! -r "$file" ]]; then
        echo "Error: File not readable: $file" >&2
        return 1
    fi

    echo "✓ File valid: $file"
    return 0
}

# Create test file
test_file="/tmp/error_test.txt"
echo "test" > "$test_file"

validate_file "$test_file"
validate_file "/nonexistent/file.txt" 2>&1 || true
validate_file "" 2>&1 || true

rm -f "$test_file"

echo ""

# Demo 6: Safe defaults
echo "--- Safe Default Values ---"

# Using ${var:-default} pattern
config_file="${CONFIG_FILE:-/etc/default.conf}"
timeout="${TIMEOUT:-30}"
verbose="${VERBOSE:-false}"

echo "config_file: $config_file"
echo "timeout: $timeout"
echo "verbose: $verbose"

echo ""
echo "=== Key Takeaways ==="
echo "1. Always check exit codes"
echo "2. Use || and && for conditional execution"
echo "3. Validate inputs before using them"
echo "4. Provide meaningful error messages"
echo "5. Use default values with \${var:-default}"

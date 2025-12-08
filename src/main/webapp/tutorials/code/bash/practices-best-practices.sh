#!/usr/bin/env bash
# Bash Best Practices Demo

echo "=== Bash Best Practices ==="
echo ""

# Good Practice 1: Use strict mode
# set -euo pipefail  # Uncomment in real scripts

# Good Practice 2: Declare constants with readonly
readonly SCRIPT_VERSION="1.0.0"
readonly MAX_RETRIES=3

# Good Practice 3: Use meaningful variable names
user_count=0
is_valid=true
config_file="/etc/app.conf"

echo "--- Naming Conventions ---"
echo "Version: $SCRIPT_VERSION"
echo "Max retries: $MAX_RETRIES"
echo ""

# Good Practice 4: Quote all variable expansions
demo_quoting() {
    local filename="my file.txt"

    # Good - handles spaces correctly
    echo "Good: \"$filename\""

    # Would break with spaces (don't do this):
    # echo Bad: $filename
}

echo "--- Quoting Variables ---"
demo_quoting
echo ""

# Good Practice 5: Use [[ ]] for tests
demo_tests() {
    local value="hello"

    # Good - modern test syntax
    if [[ -n "$value" ]]; then
        echo "Value is set: $value"
    fi

    # Good - pattern matching works in [[ ]]
    if [[ "$value" == h* ]]; then
        echo "Value starts with 'h'"
    fi
}

echo "--- Modern Test Syntax ---"
demo_tests
echo ""

# Good Practice 6: Use functions for organization
validate_input() {
    local input="$1"

    if [[ -z "$input" ]]; then
        echo "Error: Input required" >&2
        return 1
    fi

    if [[ ! "$input" =~ ^[a-zA-Z0-9]+$ ]]; then
        echo "Error: Invalid characters" >&2
        return 1
    fi

    echo "Valid input: $input"
    return 0
}

echo "--- Input Validation ---"
validate_input "hello123"
validate_input "" 2>/dev/null || echo "(empty input rejected)"
validate_input "bad@input" 2>/dev/null || echo "(special chars rejected)"
echo ""

# Good Practice 7: Use $(command) not backticks
echo "--- Command Substitution ---"
current_date=$(date +%Y-%m-%d)
echo "Today: $current_date"

# Good Practice 8: Use default values
default_demo() {
    local name="${1:-Anonymous}"
    local count="${2:-10}"
    echo "Name: $name, Count: $count"
}

echo ""
echo "--- Default Values ---"
default_demo
default_demo "Alice" 5
echo ""

# Good Practice 9: Use local in functions
scope_demo() {
    local local_var="I'm local"
    global_var="I'm global"
    echo "Inside function: $local_var"
}

echo "--- Variable Scope ---"
scope_demo
echo "After function: global_var=$global_var"
echo ""

# Good Practice 10: Check command existence
echo "--- Dependency Check ---"
check_command() {
    if command -v "$1" &>/dev/null; then
        echo "✓ $1 is available"
    else
        echo "✗ $1 is NOT available"
    fi
}

check_command "bash"
check_command "curl"
check_command "nonexistent_command"

echo ""
echo "=== Best Practices Summary ==="
echo "1. Use set -euo pipefail"
echo "2. Quote all variables"
echo "3. Use [[ ]] for tests"
echo "4. Use meaningful names"
echo "5. Use functions with local vars"

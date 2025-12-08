#!/usr/bin/env bash
# Basic Testing Demo

echo "=== Bash Testing Demo ==="
echo ""

# ==============================================================================
# SIMPLE ASSERTION FUNCTIONS
# ==============================================================================

assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Values should be equal}"

    if [[ "$expected" != "$actual" ]]; then
        echo "FAIL: $message"
        echo "  Expected: '$expected'"
        echo "  Actual:   '$actual'"
        return 1
    fi
    echo "PASS: $message"
    return 0
}

assert_true() {
    local condition="$1"
    local message="${2:-Condition should be true}"

    if ! eval "$condition"; then
        echo "FAIL: $message"
        return 1
    fi
    echo "PASS: $message"
    return 0
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="${3:-Should contain substring}"

    if [[ "$haystack" != *"$needle"* ]]; then
        echo "FAIL: $message"
        echo "  Looking for: '$needle'"
        echo "  In: '$haystack'"
        return 1
    fi
    echo "PASS: $message"
    return 0
}

# ==============================================================================
# FUNCTIONS TO TEST
# ==============================================================================

add_numbers() {
    echo $(($1 + $2))
}

is_positive() {
    [[ $1 -gt 0 ]]
}

get_greeting() {
    local name="$1"
    echo "Hello, $name!"
}

# ==============================================================================
# TESTS
# ==============================================================================

test_add_numbers() {
    echo ""
    echo "--- Testing add_numbers ---"

    local result

    result=$(add_numbers 2 3)
    assert_equals "5" "$result" "2 + 3 = 5"

    result=$(add_numbers 0 0)
    assert_equals "0" "$result" "0 + 0 = 0"

    result=$(add_numbers -5 10)
    assert_equals "5" "$result" "-5 + 10 = 5"

    result=$(add_numbers 100 200)
    assert_equals "300" "$result" "100 + 200 = 300"
}

test_is_positive() {
    echo ""
    echo "--- Testing is_positive ---"

    is_positive 5 && echo "PASS: 5 is positive" || echo "FAIL: 5 should be positive"
    is_positive 0 && echo "FAIL: 0 should not be positive" || echo "PASS: 0 is not positive"
    is_positive -3 && echo "FAIL: -3 should not be positive" || echo "PASS: -3 is not positive"
}

test_get_greeting() {
    echo ""
    echo "--- Testing get_greeting ---"

    local result

    result=$(get_greeting "World")
    assert_equals "Hello, World!" "$result" "Greeting for World"

    result=$(get_greeting "Alice")
    assert_contains "$result" "Alice" "Greeting contains name"
}

# ==============================================================================
# TEST RUNNER
# ==============================================================================

run_all_tests() {
    echo "Running test suite..."

    local total=0
    local passed=0

    # Run each test function
    test_add_numbers && ((passed++)); ((total++))
    test_is_positive && ((passed++)); ((total++))
    test_get_greeting && ((passed++)); ((total++))

    # Summary
    echo ""
    echo "==========================="
    echo "Tests run: $total"
    echo "Passed: $passed"
    echo "Failed: $((total - passed))"
    echo "==========================="

    [[ $passed -eq $total ]]
}

# Run tests
run_all_tests

echo ""
echo "=== Testing Best Practices ==="
echo "1. Write small, focused test functions"
echo "2. Use clear assertion messages"
echo "3. Test edge cases (0, negative, empty)"
echo "4. Keep tests independent"
echo "5. Use setup/teardown for cleanup"

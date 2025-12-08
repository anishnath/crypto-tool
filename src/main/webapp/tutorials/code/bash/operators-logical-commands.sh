#!/bin/bash
# Logical Operators with Command Chaining

echo "=== Command Chaining with && and || ==="
echo ""

# && - Run second command only if first succeeds
echo "--- && (AND) - Run on Success ---"
echo "Test 1: mkdir creates directory, cd enters it"
mkdir -p /tmp/test_dir && echo "Directory created successfully"

echo ""
echo "Test 2: Command fails, second not executed"
# false always fails (exit code 1)
false && echo "This won't print"
echo "  (Notice the above line didn't print)"

echo ""
# || - Run second command only if first fails
echo "--- || (OR) - Run on Failure ---"
echo "Test 3: Fallback on failure"
# Try to read non-existent file, fallback to message
cat /nonexistent/file 2>/dev/null || echo "File not found, using fallback"

echo ""
echo "Test 4: Success, fallback not needed"
echo "Hello" || echo "This won't print"

echo ""
# Combining && and ||
echo "--- Ternary-like Pattern: cmd && true || false ---"
value=50
echo "Value: $value"
[[ $value -gt 25 ]] && echo "  Result: Greater than 25" || echo "  Result: 25 or less"

value=10
echo "Value: $value"
[[ $value -gt 25 ]] && echo "  Result: Greater than 25" || echo "  Result: 25 or less"

echo ""
# Practical example: create dir if not exists
echo "--- Practical Example ---"
target_dir="/tmp/my_app_data"
[[ -d $target_dir ]] && echo "Dir exists" || mkdir -p $target_dir && echo "Dir created"

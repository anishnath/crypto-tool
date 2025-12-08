#!/bin/bash
# Loop Control Statements

echo "=========================================="
echo "Loop Control: break, continue, exit"
echo "=========================================="
echo ""

# Break statement
echo "1. Using break to exit loop:"
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        echo "  Breaking at $i"
        break
    fi
    echo "  $i"
done
echo ""

# Continue statement
echo "2. Using continue to skip iteration:"
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        echo "  Skipping $i"
        continue
    fi
    echo "  $i"
done
echo ""

# Nested loop break (breaks inner loop only)
echo "3. Break in nested loops (breaks inner loop):"
for i in {1..3}; do
    for j in {1..3}; do
        if [ $j -eq 2 ]; then
            echo "  Breaking inner loop at j=$j"
            break
        fi
        echo "  i=$i, j=$j"
    done
done
echo ""

# Break with level (bash 4+)
echo "4. Breaking outer loop using labels (conceptual):"
# In practice, you might restructure or use flags
outer_done=false
for i in {1..3}; do
    for j in {1..3}; do
        if [ $i -eq 2 ] && [ $j -eq 2 ]; then
            echo "  Breaking both loops at i=$i, j=$j"
            outer_done=true
            break
        fi
        echo "  i=$i, j=$j"
    done
    [ "$outer_done" = true ] && break
done
echo ""

# Exit vs return
echo "5. exit vs return:"
function test_exit() {
    echo "  Inside function"
    return 0  # Returns from function
}
test_exit
echo "  After function call"
echo ""

echo "=========================================="
echo "break: exit loop"
echo "continue: skip to next iteration"
echo "exit: exit entire script"
echo "return: exit function"
echo "=========================================="


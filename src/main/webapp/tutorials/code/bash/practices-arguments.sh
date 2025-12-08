#!/usr/bin/env bash
# Command Line Arguments Demo

echo "=== Positional Arguments Demo ==="
echo ""

# Simulating script arguments for demo
set -- "file1.txt" "file2.txt" "hello world" "--verbose"

echo "--- Special Variables ---"
echo "\$0 (script name): $0"
echo "\$# (arg count): $#"
echo "\$1 (first arg): $1"
echo "\$2 (second arg): $2"
echo "\$3 (third arg): $3"
echo "\$4 (fourth arg): $4"
echo ""

echo "--- \$@ vs \$* ---"
echo "Using \"\$@\" (preserves quoting):"
count=1
for arg in "$@"; do
    echo "  Arg $count: '$arg'"
    ((count++))
done

echo ""
echo "Using \$* (without quotes, word splitting):"
count=1
for arg in $*; do
    echo "  Arg $count: '$arg'"
    ((count++))
done

echo ""

# Using shift
echo "--- Using shift ---"
echo "Before shift:"
echo "  \$1 = $1"
echo "  \$2 = $2"
echo "  \$# = $#"

shift  # Remove first argument

echo "After shift:"
echo "  \$1 = $1"
echo "  \$2 = $2"
echo "  \$# = $#"

shift 2  # Remove next two arguments

echo "After shift 2:"
echo "  \$1 = $1"
echo "  \$# = $#"

echo ""

# Default values
echo "--- Default Values ---"
# Reset arguments
set -- "provided_value"

arg1="${1:-default1}"
arg2="${2:-default2}"
arg3="${3:-default3}"

echo "arg1 = $arg1 (was provided)"
echo "arg2 = $arg2 (used default)"
echo "arg3 = $arg3 (used default)"

echo ""

# Required arguments
echo "--- Checking Required Args ---"

check_required() {
    if [[ $# -lt 2 ]]; then
        echo "Error: Requires 2 arguments, got $#"
        echo "Usage: script.sh <source> <dest>"
        return 1
    fi
    echo "Got required args: $1, $2"
    return 0
}

echo "With 2 args:"
check_required "src.txt" "dst.txt"

echo ""
echo "With 1 arg:"
check_required "src.txt" || true

echo ""
echo "=== Key Points ==="
echo "1. \$# = number of arguments"
echo "2. \"\$@\" = all args (preserves spaces)"
echo "3. shift = remove first N arguments"
echo "4. \${N:-default} = default if not set"

#!/bin/bash
# Special Variables in Bash

echo "=========================================="
echo "Special Variables in Bash"
echo "=========================================="
echo ""

# Script name
echo "1. \$0 - Script name:"
echo "   \$0='$0'"
echo ""

# Command line arguments ($1, $2, ...)
echo "2. Command line arguments (\$1, \$2, ...):"
echo "   (This script was called with arguments)"
echo "   \$1='${1:-not provided}'"
echo "   \$2='${2:-not provided}'"
echo "   \$3='${3:-not provided}'"
echo ""

# Number of arguments
echo "3. \$# - Number of arguments:"
echo "   \$#=$#"
echo ""

# All arguments
echo "4. \$@ and \$* - All arguments:"
echo "   \$@='$@' (each argument separately)"
echo "   \$*='$*' (all arguments as one string)"
echo ""

# Difference between $@ and $*
echo "5. Difference between \$@ and \$*:"
echo "   In a loop with \$@ (recommended):"
for arg in "$@"; do
    echo "     - '$arg'"
done
echo ""

# Process ID
echo "6. \$\$ - Current process ID:"
echo "   \$\$=$$"
echo ""

# Exit status of last command
echo "7. \$? - Exit status of last command:"
true
echo "   After 'true': \$?=$?"
false
echo "   After 'false': \$?=$?"
echo "   0 = success, non-zero = error"
echo ""

# Background process ID
echo "8. \$! - Process ID of last background job:"
echo "   (Not shown here as no background jobs started)"
echo ""

# All positional parameters
echo "9. Positional parameters summary:"
echo "   Script: $0"
echo "   Arg count: $#"
echo "   Args: $@"
echo ""

echo "=========================================="
echo "Special Variables Reference:"
echo "- \$0     : Script name"
echo "- \$1-\$9  : First 9 arguments"
echo "- \$#     : Number of arguments"
echo "- \$@     : All arguments (separate)"
echo "- \$*     : All arguments (one string)"
echo "- \$\$     : Current process ID"
echo "- \$?     : Exit status of last command"
echo "- \$!     : PID of last background job"
echo "=========================================="


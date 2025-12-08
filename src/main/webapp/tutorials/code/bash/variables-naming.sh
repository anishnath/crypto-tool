#!/bin/bash
# Variable Naming Rules and Best Practices

echo "=========================================="
echo "Variable Naming Rules in Bash"
echo "=========================================="
echo ""

# Valid variable names
valid_var1="Valid with number"
VALID_VAR="Valid uppercase"
_valid_var="Valid with underscore"
varName="Valid camelCase"

echo "1. Valid variable names:"
echo "   valid_var1='$valid_var1'"
echo "   VALID_VAR='$VALID_VAR'"
echo "   _valid_var='$_valid_var'"
echo "   varName='$varName'"
echo ""

# Invalid variable names (will cause errors)
# 2var="Invalid"  # Can't start with number
# var-name="Invalid"  # Can't use hyphens
# var name="Invalid"  # Can't have spaces

echo "2. Invalid variable names (commented out):"
echo "   2var='Invalid'          # Can't start with number"
echo "   var-name='Invalid'      # Can't use hyphens"
echo "   var name='Invalid'      # Can't have spaces"
echo ""

# Naming conventions
SCRIPT_NAME="my_script.sh"
MAX_RETRIES=3
user_input=""
is_active=true

echo "3. Common naming conventions:"
echo "   SCRIPT_NAME='$SCRIPT_NAME' (UPPERCASE for constants)"
echo "   MAX_RETRIES=$MAX_RETRIES (UPPERCASE for constants)"
echo "   user_input='$user_input' (lowercase for variables)"
echo "   is_active=$is_active (lowercase with underscore)"
echo ""

# Best practices
readonly CONFIG_FILE="/etc/config"
declare -r API_KEY="secret123"

echo "4. Read-only variables:"
echo "   readonly CONFIG_FILE='$CONFIG_FILE'"
echo "   declare -r API_KEY='***' (hidden for security)"
echo ""

echo "=========================================="
echo "Naming Best Practices:"
echo "- Use lowercase for regular variables"
echo "- Use UPPERCASE for constants/readonly"
echo "- Use underscores to separate words"
echo "- Use descriptive names (count, not c)"
echo "- Avoid reserved words (if, then, else, etc.)"
echo "=========================================="


#!/bin/bash
# Variable Expansion Techniques

echo "=========================================="
echo "Variable Expansion in Bash"
echo "=========================================="
echo ""

# Basic expansion
name="Alice"
echo "1. Basic expansion:"
echo "   name='$name'"
echo "   \${name}='${name}' (braces are optional here)"
echo ""

# Braces are required for clarity
value="test"
echo "2. When braces are required:"
echo "   value='$value'"
echo "   \${value}_file='${value}_file' (not \$value_file)"
echo ""

# Default value expansion
unset name
echo "3. Default value expansion (\${var:-default}):"
echo "   name is unset"
echo "   \${name:-Guest}='${name:-Guest}' (uses default)"
name="Alice"
echo "   name='$name'"
echo "   \${name:-Guest}='${name:-Guest}' (uses actual value)"
echo ""

# Assign default value
unset count
echo "4. Assign default value (\${var:=default}):"
echo "   count is unset"
echo "   \${count:=0}='${count:=0}' (assigns and uses)"
echo "   count='$count' (now set to 0)"
echo ""

# Error if unset
unset required_var
echo "5. Error if unset (\${var:?error message}):"
echo "   Testing with unset variable..."
# This would error: ${required_var:?Variable is required!}
echo "   (Skipping actual error to avoid stopping script)"
echo ""

# Length of string
text="Hello World"
echo "6. String length (\${#var}):"
echo "   text='$text'"
echo "   \${#text}=${#text} (length)"
echo ""

# Substring expansion
text="Hello World"
echo "7. Substring expansion (\${var:offset:length}):"
echo "   text='$text'"
echo "   \${text:0:5}='${text:0:5}' (first 5 chars)"
echo "   \${text:6}='${text:6}' (from index 6 to end)"
echo "   \${text: -5}='${text: -5}' (last 5 chars, note space before -)"
echo ""

echo "=========================================="
echo "Common Expansion Patterns:"
echo "- \${var}       : Variable value"
echo "- \${var:-default} : Use default if unset"
echo "- \${var:=default} : Assign default if unset"
echo "- \${var:?error}   : Error if unset"
echo "- \${#var}         : Length of string"
echo "- \${var:offset:length} : Substring"
echo "=========================================="


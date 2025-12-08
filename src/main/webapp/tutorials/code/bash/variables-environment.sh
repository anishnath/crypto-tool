#!/bin/bash
# Environment Variables

echo "=========================================="
echo "Environment Variables in Bash"
echo "=========================================="
echo ""

# Common environment variables
echo "1. Common environment variables:"
echo "   HOME: $HOME"
echo "   USER: $USER"
echo "   SHELL: $SHELL"
echo "   PWD: $PWD"
echo "   PATH: $PATH"
echo ""

# PATH variable (important!)
echo "2. PATH variable (first few entries):"
echo "$PATH" | tr ':' '\n' | head -5
echo "   (PATH tells the system where to find executables)"
echo ""

# Setting environment variables
export MY_VAR="Hello from environment"
echo "3. Setting environment variables:"
echo "   export MY_VAR='Hello from environment'"
echo "   MY_VAR='$MY_VAR'"
echo ""

# Environment vs local variables
LOCAL_VAR="This is local"
export EXPORTED_VAR="This is exported"
echo "4. Local vs exported variables:"
echo "   LOCAL_VAR='$LOCAL_VAR' (not exported)"
echo "   EXPORTED_VAR='$EXPORTED_VAR' (exported, available to child processes)"
echo ""

# Viewing all environment variables
echo "5. Viewing environment variables:"
echo "   Use 'env' or 'printenv' command"
echo "   Number of environment variables: $(env | wc -l)"
echo ""

# Specific environment variable
echo "6. Checking specific variable:"
echo "   USER: ${USER:-not set}"
echo "   EDITOR: ${EDITOR:-not set}"
echo "   LANG: ${LANG:-not set}"
echo ""

# Modifying PATH (temporary)
echo "7. Modifying PATH (example):"
echo "   Current PATH length: ${#PATH} characters"
echo "   (To add to PATH: export PATH=\"\$PATH:/new/path\")"
echo ""

echo "=========================================="
echo "Key Points:"
echo "- Environment variables are available to all child processes"
echo "- Use 'export' to make variables available to child processes"
echo "- Use 'env' or 'printenv' to view all environment variables"
echo "- Common vars: HOME, USER, PATH, SHELL, PWD"
echo "- PATH is critical - it tells system where to find commands"
echo "=========================================="


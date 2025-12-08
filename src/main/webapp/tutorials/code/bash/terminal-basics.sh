#!/bin/bash
# Terminal Basics - Common Commands

echo "=========================================="
echo "Terminal Basics - Essential Commands"
echo "=========================================="
echo ""

# pwd - Print Working Directory
echo "1. Current directory (pwd):"
pwd
echo ""

# ls - List files
echo "2. Listing files (ls):"
ls -la | head -10
echo ""

# whoami - Current user
echo "3. Current user (whoami):"
whoami
echo ""

# date - Current date/time
echo "4. Current date and time (date):"
date
echo ""

# echo - Display text
echo "5. Displaying text (echo):"
echo "   Hello from the terminal!"
echo ""

# Creating a test directory (will be cleaned up)
echo "6. Creating a test directory:"
mkdir -p /tmp/bash-test-$$ 2>/dev/null
echo "   Created: /tmp/bash-test-$$"
echo ""

# Changing directory
echo "7. Changing directory (cd):"
cd /tmp/bash-test-$$ 2>/dev/null
echo "   Now in: $(pwd)"
cd - > /dev/null
echo ""

# File operations
echo "8. File operations:"
echo "   - touch filename   # Create empty file"
echo "   - mkdir dirname    # Create directory"
echo "   - rm filename      # Remove file"
echo "   - cp source dest   # Copy file"
echo "   - mv source dest   # Move/rename file"
echo ""

# Cleanup
rm -rf /tmp/bash-test-$$ 2>/dev/null

echo "=========================================="
echo "These are the basic building blocks of"
echo "working with the terminal and Bash!"
echo "=========================================="


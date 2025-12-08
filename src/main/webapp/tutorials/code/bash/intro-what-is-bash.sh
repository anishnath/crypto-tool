#!/bin/bash
# What is Bash - Introduction Examples

echo "=========================================="
echo "Understanding Bash"
echo "=========================================="
echo ""

# Check current shell
echo "1. Your current shell:"
echo "   Shell: $SHELL"
echo ""

# Check Bash version
echo "2. Bash version:"
bash --version | head -1
echo ""

# Show Bash location
echo "3. Bash location:"
which bash
echo ""

# Environment info
echo "4. Some environment information:"
echo "   User: $USER"
echo "   Home: $HOME"
echo "   Current directory: $PWD"
echo ""

echo "=========================================="
echo "Bash is a command processor and scripting language"
echo "that runs on Unix-like operating systems."
echo "=========================================="


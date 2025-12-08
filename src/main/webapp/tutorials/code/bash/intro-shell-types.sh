#!/bin/bash
# Shell Types Comparison

echo "=========================================="
echo "Different Shell Types Available"
echo "=========================================="
echo ""

# Check what shells are available
echo "1. Available shells on this system:"
if [ -f /etc/shells ]; then
    echo "   $(cat /etc/shells | grep -v '^#' | grep -v '^$')"
else
    echo "   /bin/bash"
    echo "   /bin/sh"
fi
echo ""

# Show current shell
echo "2. Your current shell:"
echo "   $SHELL"
echo ""

# Show default user shell
echo "3. Common shell types:"
echo "   - Bash (Bourne Again SHell) - Most common on Linux"
echo "   - Zsh (Z Shell) - Default on macOS (Catalina+)"
echo "   - sh (Bourne Shell) - POSIX compliant, maximum compatibility"
echo "   - Fish (Friendly Interactive SHell) - User-friendly features"
echo ""

# Check if other shells are available
echo "4. Checking for other shells:"
[ -f /bin/zsh ] && echo "   ✓ Zsh is installed" || echo "   ✗ Zsh not found"
[ -f /bin/sh ] && echo "   ✓ sh is installed" || echo "   ✗ sh not found"
echo ""

echo "=========================================="
echo "Bash is the most widely used and compatible shell."
echo "Scripts written in Bash work on most Unix-like systems."
echo "=========================================="


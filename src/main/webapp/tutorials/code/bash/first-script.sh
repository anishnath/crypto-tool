#!/bin/bash
# Understanding the Shebang and Script Structure

echo "=========================================="
echo "Understanding Bash Script Structure"
echo "=========================================="
echo ""

# The shebang line (#!/bin/bash) tells the system which interpreter to use
echo "1. This script uses the shebang: #!/bin/bash"
echo ""

# Show current script name
echo "2. Script name: $0"
echo ""

# Comments
# This is a comment - it's ignored by Bash
echo "3. Comments start with # and are ignored"
echo ""

# Multiple commands
echo "4. Multiple commands in one script:"
date
whoami
pwd
echo ""

echo "=========================================="
echo "To run this script:"
echo "  bash first-script.sh"
echo "or"
echo "  chmod +x first-script.sh"
echo "  ./first-script.sh"
echo "=========================================="


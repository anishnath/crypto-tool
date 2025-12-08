#!/bin/bash
# File Permissions in Bash

echo "=== File Permissions ==="
echo ""

test_dir="/tmp/perm_test"
mkdir -p "$test_dir"
cd "$test_dir"

# Create test file
echo "#!/bin/bash" > script.sh
echo 'echo "Hello from script"' >> script.sh

echo "Created script.sh"
ls -la script.sh
echo ""

# chmod - Change permissions
echo "--- chmod: Change Permissions ---"

# Symbolic mode
chmod u+x script.sh
echo "chmod u+x (add execute for user)"
ls -la script.sh

chmod go-r script.sh
echo "chmod go-r (remove read for group/others)"
ls -la script.sh

chmod a+r script.sh
echo "chmod a+r (add read for all)"
ls -la script.sh
echo ""

# Numeric mode
echo "--- chmod: Numeric Mode ---"
chmod 755 script.sh
echo "chmod 755 (rwxr-xr-x)"
ls -la script.sh

chmod 644 script.sh
echo "chmod 644 (rw-r--r--)"
ls -la script.sh

chmod 700 script.sh
echo "chmod 700 (rwx------)"
ls -la script.sh
echo ""

# Permission reference
echo "--- Permission Reference ---"
echo "r (read)    = 4"
echo "w (write)   = 2"
echo "x (execute) = 1"
echo ""
echo "755 = rwxr-xr-x (owner: all, others: read+execute)"
echo "644 = rw-r--r-- (owner: read+write, others: read)"
echo "700 = rwx------ (owner only)"
echo "777 = rwxrwxrwx (everyone: all - DANGEROUS!)"

# Cleanup
cd /
rm -rf "$test_dir"

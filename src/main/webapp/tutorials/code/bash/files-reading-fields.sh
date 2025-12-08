#!/bin/bash
# Reading Files with Field Parsing

echo "=== Parsing File Fields ==="
echo ""

# Create CSV-like sample file
csv_file="/tmp/users.csv"
cat > "$csv_file" << 'EOF'
alice,25,developer
bob,30,designer
charlie,35,manager
diana,28,analyst
EOF

echo "Sample CSV file:"
cat "$csv_file"
echo ""

# Parse with IFS (Internal Field Separator)
echo "--- Parsing with IFS=, ---"
while IFS=, read -r name age role; do
    echo "Name: $name, Age: $age, Role: $role"
done < "$csv_file"
echo ""

# Parse /etc/passwd style (colon-separated)
echo "--- Parsing colon-separated data ---"
passwd_sample="/tmp/passwd_sample"
cat > "$passwd_sample" << 'EOF'
root:x:0:0:root:/root:/bin/bash
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
EOF

while IFS=: read -r user x uid gid desc home shell; do
    echo "User: $user (UID: $uid) -> $shell"
done < "$passwd_sample"
echo ""

# Using cut for specific fields
echo "--- Using cut for fields ---"
echo "Field 1 (names): $(cut -d',' -f1 "$csv_file" | tr '\n' ' ')"
echo "Field 3 (roles): $(cut -d',' -f3 "$csv_file" | tr '\n' ' ')"
echo ""

# Using awk for field extraction
echo "--- Using awk for fields ---"
echo "Name and Role columns:"
awk -F',' '{print $1 " is a " $3}' "$csv_file"

# Cleanup
rm -f "$csv_file" "$passwd_sample"

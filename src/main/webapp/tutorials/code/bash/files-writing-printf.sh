#!/bin/bash
# Printf for Formatted File Writing

echo "=== Printf Formatting ==="
echo ""

output="/tmp/formatted.txt"

# Basic printf formats
echo "--- Format Specifiers ---"
printf "String: %s\n" "Hello"
printf "Integer: %d\n" 42
printf "Float: %f\n" 3.14159
printf "Float (2 decimals): %.2f\n" 3.14159
printf "Padded: %10s|\n" "right"
printf "Padded: %-10s|\n" "left"
printf "Zero-padded: %05d\n" 42
echo ""

# Creating formatted table
echo "--- Formatted Table ---"
{
    printf "%-15s %8s %10s\n" "Name" "Age" "Salary"
    printf "%-15s %8s %10s\n" "---------------" "--------" "----------"
    printf "%-15s %8d %10.2f\n" "Alice Smith" 28 75000.50
    printf "%-15s %8d %10.2f\n" "Bob Johnson" 35 82500.00
    printf "%-15s %8d %10.2f\n" "Carol White" 42 95000.75
} | tee "$output"
echo ""
echo "Table saved to: $output"
echo ""

# CSV generation
echo "--- CSV Generation ---"
csv_file="/tmp/data.csv"
{
    printf "%s,%s,%s\n" "name" "email" "status"
    printf "%s,%s,%s\n" "alice" "alice@example.com" "active"
    printf "%s,%s,%s\n" "bob" "bob@example.com" "inactive"
    printf "%s,%s,%s\n" "carol" "carol@example.com" "active"
} > "$csv_file"
echo "CSV file:"
cat "$csv_file"
echo ""

# JSON-like output
echo "--- JSON-like Output ---"
name="Test User"
age=30
active=true
printf '{"name": "%s", "age": %d, "active": %s}\n' "$name" "$age" "$active"

# Cleanup
rm -f "$output" "$csv_file"

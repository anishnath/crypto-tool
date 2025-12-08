#!/bin/bash
# Recursive Directory Processing

echo "=== Recursive Directory Processing ==="
echo ""

# Setup test structure
base="/tmp/recursive_test"
mkdir -p "$base/level1/level2/level3"
touch "$base/root.txt"
touch "$base/level1/file1.txt"
touch "$base/level1/level2/file2.txt"
touch "$base/level1/level2/level3/file3.txt"

echo "Test structure:"
find "$base" -type f
echo ""

# Method 1: find with -exec
echo "--- Method 1: find -exec ---"
echo "Processing all .txt files:"
find "$base" -name "*.txt" -exec echo "Found: {}" \;
echo ""

# Method 2: find with while loop
echo "--- Method 2: find with while ---"
while IFS= read -r -d '' file; do
    echo "Processing: $file"
done < <(find "$base" -name "*.txt" -print0)
echo ""

# Method 3: Recursive function
echo "--- Method 3: Recursive Function ---"
process_dir() {
    local dir="$1"
    local indent="${2:-}"

    for item in "$dir"/*; do
        [[ -e "$item" ]] || continue
        if [[ -d "$item" ]]; then
            echo "${indent}[DIR] $(basename "$item")"
            process_dir "$item" "  $indent"
        else
            echo "${indent}[FILE] $(basename "$item")"
        fi
    done
}
process_dir "$base"
echo ""

# Method 4: globstar (Bash 4+)
echo "--- Method 4: globstar (**) ---"
shopt -s globstar
for file in "$base"/**/*.txt; do
    [[ -f "$file" ]] && echo "Globstar found: $file"
done
shopt -u globstar

# Cleanup
rm -rf "$base"

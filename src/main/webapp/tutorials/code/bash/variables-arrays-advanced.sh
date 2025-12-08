#!/bin/bash
# Advanced Array Operations

echo "=========================================="
echo "Advanced Array Operations in Bash"
echo "=========================================="
echo ""

# Slicing arrays
numbers=(0 1 2 3 4 5 6 7 8 9)
echo "1. Array slicing (\${array[@]:offset:length}):"
echo "   numbers=(${numbers[@]})"
echo "   \${numbers[@]:2:3}='${numbers[@]:2:3}' (from index 2, length 3)"
echo "   \${numbers[@]:5}='${numbers[@]:5}' (from index 5 to end)"
echo ""

# Finding array indices
echo "2. Array indices (\${!array[@]}):"
echo "   Indices in numbers array: ${!numbers[@]}"
echo ""

# Checking if element exists
echo "3. Checking if element exists:"
if [[ -v numbers[3] ]]; then
    echo "   numbers[3] exists: ${numbers[3]}"
fi
echo ""

# Removing elements (unset)
unset numbers[5]
echo "4. Removing elements (unset array[index]):"
echo "   After unset numbers[5]:"
echo "   Array: ${numbers[@]}"
echo "   Indices: ${!numbers[@]} (note: index 5 is now missing)"
echo ""

# Reindexing array (workaround)
reindexed=("${numbers[@]}")
echo "5. Reindexing array:"
echo "   Original indices: ${!numbers[@]}"
echo "   Reindexed array: ${reindexed[@]}"
echo "   Reindexed indices: ${!reindexed[@]}"
echo ""

# Array from command output
files=($(ls /bin | head -5))
echo "6. Array from command output:"
echo "   files=(\$(ls /bin | head -5))"
echo "   First 5 files in /bin: ${files[@]}"
echo ""

# Copying arrays
original=("a" "b" "c")
copy=("${original[@]}")
copy[0]="x"
echo "7. Copying arrays:"
echo "   original=(${original[@]})"
echo "   copy=(\"\${original[@]}\")"
echo "   After modifying copy[0]='x':"
echo "   original=(${original[@]}) (unchanged)"
echo "   copy=(${copy[@]}) (modified)"
echo ""

# Array concatenation
arr1=(1 2 3)
arr2=(4 5 6)
combined=("${arr1[@]}" "${arr2[@]}")
echo "8. Concatenating arrays:"
echo "   arr1=(${arr1[@]})"
echo "   arr2=(${arr2[@]})"
echo "   combined=(\"\${arr1[@]}\" \"\${arr2[@]}\")"
echo "   combined=(${combined[@]})"
echo ""

# Iterating with indices
echo "9. Iterating with indices:"
for i in "${!numbers[@]}"; do
    echo "   numbers[$i]=${numbers[$i]}"
done
echo ""

echo "=========================================="
echo "Advanced Array Tips:"
echo "- Use \${!array[@]} to get all indices"
echo "- Use -v to check if element exists"
echo "- Unset removes elements but leaves gaps"
echo "- Copy arrays with \${array[@]} to avoid reference issues"
echo "- Arrays from command output use word splitting"
echo "=========================================="


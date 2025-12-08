#!/usr/bin/env bash

# Recursive examples: factorial and directory traversal

factorial() {
  local n=$1
  if (( n <= 1 )); then
    echo 1
  else
    local prev=$(factorial $((n-1)))
    echo $(( n * prev ))
  fi
}

echo "Factorial of 5: $(factorial 5)"

traverse() {
  local dir=$1
  local indent=$2
  for entry in "$dir"/*; do
    [ -e "$entry" ] || continue
    echo "${indent}- ${entry##*/}"
    if [ -d "$entry" ]; then
      traverse "$entry" "${indent}  "
    fi
  done
}

echo "Current directory tree (depth-first):"
traverse "." ""


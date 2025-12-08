#!/usr/bin/env bash

# Function scope nuances: reading/writing globals, shadowing, exporting

counter=0

inc_global() {
  counter=$((counter + 1))
}

shadow_with_local() {
  local counter=100
  counter=$((counter + 1))
  echo "Inside shadow_with_local (local counter): $counter"
}

echo "Initial global counter: $counter"
inc_global
echo "After inc_global (global counter): $counter"

shadow_with_local
echo "After shadow_with_local (global counter): $counter"

# Exported variables and functions (note: exporting functions is bash-specific)
export GLOBAL_FLAG=yes
export -f inc_global
echo "GLOBAL_FLAG=$GLOBAL_FLAG (available to child processes)"


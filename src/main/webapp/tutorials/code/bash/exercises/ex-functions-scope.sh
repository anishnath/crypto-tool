#!/usr/bin/env bash
# TODO: Implement safe_inc() that echoes (n + 1) without mutating globals.
# - Accept one integer argument.
# - Return non-zero for invalid input.

counter=100  # global that must not be modified

safe_inc() {
  # your code here
  :
}

echo "global before: $counter"
safe_inc 41   # -> 42
echo "global after:  $counter"  # should remain 100


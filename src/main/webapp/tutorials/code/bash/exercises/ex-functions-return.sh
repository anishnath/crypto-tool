#!/usr/bin/env bash
# TODO: Implement max() that echoes the larger of two integers.
# - Accept exactly two integer args.
# - Return non-zero on invalid input.

max() {
  # your code here
  :
}

# Expected:
# 9
# (non-zero exit for invalid)
max 5 9
max x 2 || echo "invalid input" 1>&2


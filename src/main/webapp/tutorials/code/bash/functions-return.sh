#!/usr/bin/env bash

# Returning values from functions
# 1) Use return code (0..255)
# 2) Echo output and capture via command substitution

is_even() {
  local n=$1
  (( n % 2 == 0 ))
}

add() {
  local a=$1 b=$2
  echo $(( a + b ))
}

num=7
if is_even "$num"; then
  echo "$num is even"
else
  echo "$num is odd"
fi
echo "is_even exit code was: $?"

sum=$(add 10 32)
echo "10 + 32 = $sum"


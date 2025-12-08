#!/usr/bin/env bash

# Defining functions in Bash

# Style 1: function keyword
function greet_user() {
  echo "Hello, $1!"
}

# Style 2: name() without 'function'
say_time() {
  echo "Current time: $(date +"%H:%M:%S")"
}

echo "-- Calling greet_user --"
greet_user "Alice"

echo "-- Calling say_time --"
say_time

echo "-- Return status example --"
always_succeeds() { return 0; }
always_fails() { return 1; }

always_succeeds
echo "always_succeeds exit code: $?"

always_fails || echo "always_fails returned non-zero (as expected)"


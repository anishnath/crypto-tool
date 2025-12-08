#!/usr/bin/env bash

# Function parameters: $1..$9, $@, $*, shift

show_params() {
  echo "Param count: $#"
  echo "First: $1"
  echo "All with \$@: $@"
  echo "All with \$*: $*"

  echo "-- Iterating with \$@ --"
  idx=1
  for arg in "$@"; do
    echo "[$idx] $arg"
    ((idx++))
  done

  echo "-- Shift demo --"
  while (( "$#" )); do
    echo "Next: $1"
    shift
  done
}

show_params "alpha" "beta gamma" delta


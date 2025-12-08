#!/usr/bin/env bash

# Signal handling with trap

cleanup() {
  echo "Cleaning up..."
  rm -f tmpfile 2>/dev/null || true
}

trap 'echo "Caught SIGINT"; cleanup; exit 130' INT
trap 'echo "Exiting"; cleanup' EXIT

echo "Creating tmpfile and sleeping (try Ctrl-C)"
touch tmpfile
sleep 1
echo "Done"


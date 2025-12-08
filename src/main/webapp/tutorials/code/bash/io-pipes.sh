#!/usr/bin/env bash

# Pipes between commands

echo "-- count unique words (case-insensitive) --"
text="The quick brown fox jumps over the lazy dog the THE"
printf "%s\n" "$text" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alpha:]' '\n' | sort | uniq -c | sort -nr

echo "-- grep + awk pipeline --"
printf "user:alice\nuser:bob\nrole:admin\n" |
  grep '^user:' | awk -F: '{print $2}'

echo "-- tee to save and view --"
echo "important output" | tee saved.txt | sed 's/.*/[&]/'
echo "saved.txt:"; cat saved.txt


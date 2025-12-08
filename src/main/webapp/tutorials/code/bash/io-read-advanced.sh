#!/usr/bin/env bash

# Advanced input reads: delimiters, timeouts, mapfile

echo "-- read with delimiter (-d :) --"
read -r -d : token rest <<< "key:value:more"
echo "token='$token' rest='${rest#?}'"  # ${rest#?} to strip the delimiter

echo "-- read with timeout (-t 2) --"
if read -r -t 2 -p "Type quickly (2s): " quick; then
  echo "You typed: $quick"
else
  echo "Timed out"
fi

echo "-- mapfile/readarray --"
printf "a\nb\nc\n" | mapfile -t arr
echo "Array length: ${#arr[@]} | ${arr[*]}"


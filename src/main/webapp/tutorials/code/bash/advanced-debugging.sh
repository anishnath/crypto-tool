#!/usr/bin/env bash

# Debugging options: -x -e -u

echo "-- trace commands with set -x --"
set -x
a=10
echo $((a+5))
set +x

echo "-- exit on error (set -e) demo --"
( set -e; echo ok; false; echo never ) || echo "caught failure"

echo "-- unset variable check (set -u) --"
( set -u; foo=bar; echo "$foo"; : )


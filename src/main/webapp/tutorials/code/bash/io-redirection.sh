#!/usr/bin/env bash

# Output redirection basics

echo "-- redirect stdout to file (>) --"
echo "hello" > out.txt
echo "world" >> out.txt
echo "File out.txt contents:"; cat out.txt

echo "-- redirect stderr to file (2>) --"
{ ls /no/such/path; } 2> err.txt
echo "stderr in err.txt:"; cat err.txt

echo "-- merge stdout and stderr (2>&1) --"
{ echo ok; ls /missing; } > both.txt 2>&1
echo "both.txt:"; cat both.txt

echo "-- send message to stderr --"
echo "This is an error" 1>&2

echo "-- null sink --"
echo noisy > /dev/null


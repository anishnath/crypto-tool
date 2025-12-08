#!/usr/bin/env bash

# Process substitution <() and >()

echo "-- diff of sorted files --"
printf "c\na\nb\n" > f1.txt
printf "b\nc\nd\n" > f2.txt
diff <(sort f1.txt) <(sort f2.txt) | sed 's/^/| /'

echo "-- paste two command outputs side-by-side --"
paste <(seq 1 3) <(seq 3 -1 1)

echo "-- feed command output into another process (>(cmd)) --"
seq 1 5 > >(awk '{print "x"$0"x"}')


#!/usr/bin/env bash

# awk advanced: BEGIN/END, arrays, formatting

cat > data.tsv <<'TSV'
alice	100
bob	150
carol	200
TSV

echo "-- sum values with BEGIN/END --"
awk -F"\t" 'BEGIN{sum=0} {sum += $2} END{printf "total=%d\n", sum}' data.tsv

echo "-- associative array counts --"
printf "a\nb\na\nc\na\n" | awk '{count[$1]++} END{for(k in count) printf "%s %d\n", k, count[k]}' | sort


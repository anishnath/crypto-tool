#!/usr/bin/env bash

# awk basics: fields and patterns

cat > people.csv <<'CSV'
name,age,city
alice,30,nyc
bob,25,boston
carol,35,seattle
CSV

echo "-- print second column (age) --"
awk -F, 'NR>1 { print $2 }' people.csv

echo "-- filter: age > 28 and print name:city --"
awk -F, 'NR>1 && $2>28 { print $1 ":" $3 }' people.csv

echo "-- built-ins NR and NF --"
awk -F, '{ print "line=" NR, "fields=" NF }' people.csv


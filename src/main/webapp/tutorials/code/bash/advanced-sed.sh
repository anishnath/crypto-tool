#!/usr/bin/env bash

# sed: substitution, deletion, ranges

cat > input.txt <<'TXT'
alpha
beta
gamma
delta
epsilon
TXT

echo "-- substitute 'a'->'A' globally --"
sed 's/a/A/g' input.txt

echo "-- delete lines matching beta --"
sed '/^beta$/d' input.txt

echo "-- print only lines 2 through 4 --"
sed -n '2,4p' input.txt

echo "-- insert prefix before gamma --"
sed '/^gamma$/i\\
PREFIX:' input.txt


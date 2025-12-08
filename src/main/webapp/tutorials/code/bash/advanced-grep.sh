#!/usr/bin/env bash

# grep advanced switches

cat > words.txt <<'TXT'
foo
FooBar
bar
food
foobar
TXT

echo "-- case-insensitive -i --"
grep -i 'foo' words.txt

echo "-- word match -w --"
grep -w 'foo' words.txt

echo "-- only matching -o --"
echo 'user:alice id:42' | grep -oE 'id:[0-9]+'

echo "-- invert match -v --"
grep -v 'bar' words.txt


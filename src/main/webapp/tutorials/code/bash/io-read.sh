#!/usr/bin/env bash

# Reading input interactively and from files

echo "-- Basic read (single word) --"
echo "Type your name (first word only):"
read name
echo "Hello, $name"

echo "-- read -p prompt --"
read -p "Enter city: " city
echo "City: $city"

echo "-- read full line with -r (no backslash escapes) --"
read -r -p "Enter a sentence: " line
echo "You said: $line"

echo "-- read multiple vars with IFS=, --"
IFS=, read -r first last <<< "John,Doe"
echo "First='$first' Last='$last'"

echo "-- read -s for hidden input (password) --"
read -s -p "Password: " pass; echo
echo "Length of password: ${#pass}"

echo "-- read -a into array --"
read -r -a words <<< "alpha beta gamma"
echo "Words: ${words[0]} | ${words[1]} | ${words[2]}"

echo "-- while read loop over file --"
printf "one\ntwo three\nfour" > sample.txt
while IFS= read -r ln; do
  echo "[$ln]"
done < sample.txt


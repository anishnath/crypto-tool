#!/usr/bin/env bash

# Regular expressions with grep/sed

echo "Sample data:" > data.txt
cat > data.txt <<'TXT'
alice  alice@example.com  555-123-4567
Bob    bob@example.org    555-000-9999
carol  carol@example.net  123-45-6789
TXT

echo "-- grep -E email addresses --"
grep -Eo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' data.txt

echo "-- grep lines starting with lowercase name --"
grep -E '^[a-z]+' data.txt

echo "-- sed: mask phone middle digits --"
sed -E 's/(\b[0-9]{3})-([0-9]{3})-([0-9]{4})/\1-XXX-\3/g' data.txt

echo "-- sed: select lines with .org using address --"
sed -n '/@example\.org/p' data.txt


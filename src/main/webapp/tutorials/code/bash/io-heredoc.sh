#!/usr/bin/env bash

# Here documents and here strings

echo "-- basic here doc --"
cat <<EOF
Line 1
Var expansion: $USER
Command: $(echo hi)
EOF

echo "-- quoted delimiter to prevent expansion --"
cat <<'NOEXPAND'
Literal $USER and $(date)
NOEXPAND

echo "-- strip leading tabs with <<- --"
cat <<-TAB
	Indented with tabs only
TAB

echo "-- here string <<< --"
wc -w <<< "one two three"


#!/bin/bash

# Parameter Expansion

filename="image.tar.gz"

# Remove shortest match from end (%)
echo "Strip extension: ${filename%.*}"      # image.tar

# Remove longest match from end (%%)
echo "Strip all extensions: ${filename%%.*}" # image

path="/usr/local/bin/bash"

# Remove shortest match from beginning (#)
echo "Remove prefix: ${path#*/}"            # usr/local/bin/bash

# Remove longest match from beginning (##)
echo "Basename: ${path##*/}"                # bash

# Default values
unset name
echo "Name is: ${name:-Unknown}"            # Unknown (var remains unset)
echo "Name is: ${name:=Guest}"              # Guest (var is set to Guest)
echo "Name is: $name"                       # Guest

#!/usr/bin/env bash

# Advanced parameter expansion

text="abcdefg"
echo "slice 2..: ${text:2}"
echo "slice 2..4: ${text:2:4}"

path="/usr/local/bin/bash"
echo "# shortest from front: ${path#*/}"
echo "## longest from front: ${path##*/}"
echo "% shortest from back: ${path%/*}"
echo "%% longest from back: ${path%%/*}"

name="hello_world_world"
echo "replace first: ${name/_/-}"
echo "replace all: ${name//_/ - }"


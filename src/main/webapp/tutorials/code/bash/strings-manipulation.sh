#!/bin/bash

# String Manipulation

text="The quick brown fox jumps over the lazy dog"

# Substring Extraction ${string:position:length}
echo "Original: $text"
echo "Substring (4:5): ${text:4:5}"  # quick
echo "Substring (10): ${text:10}"    # brown fox...

# String Replacement ${string/pattern/replacement}
echo "Replace first 'the': ${text/the/a}"
echo "Replace all 'the': ${text//the/a}"

# Case Conversion
word="Hello World"
echo "Uppercase: ${word^^}"
echo "Lowercase: ${word,,}"

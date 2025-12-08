#!/bin/bash

# Here Documents

# Basic Here Doc
cat <<EOF
This is a multi-line text block.
Variables like $USER are expanded.
EOF

# Here Doc with no expansion (quoted delimiter)
cat <<'EOF'
Variables like $USER are NOT expanded here.
This is useful for generating config files or scripts.
EOF

# Here String
text="Hello World"
tr 'a-z' 'A-Z' <<< "$text"

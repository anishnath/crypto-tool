#!/usr/bin/env bash

# Global vs local variables in Bash functions

name="GlobalName"

show_names() {
  echo "Inside show_names: name='${name}'"
}

shadow_global_without_local() {
  name="OverwrittenGlobal"
  echo "Inside shadow_global_without_local: name='${name}'"
}

use_local_to_avoid_side_effects() {
  local name="LocalOnly"
  echo "Inside use_local_to_avoid_side_effects: name='${name}'"
}

echo "Before any function: name='${name}'"
show_names

shadow_global_without_local
echo "After shadow_global_without_local: name='${name}' (global changed)"

use_local_to_avoid_side_effects
echo "After use_local_to_avoid_side_effects: name='${name}' (global preserved)"


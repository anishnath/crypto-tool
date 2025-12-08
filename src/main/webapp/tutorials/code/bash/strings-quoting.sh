#!/bin/bash

# Quoting Mechanisms

# Double Quotes (Variables are expanded)
name="Alice"
echo "Double Quotes: My name is $name"

# Single Quotes (Literal string, no expansion)
echo 'Single Quotes: My name is $name'

# Backticks (Command substitution - legacy)
echo "Current date is `date +%F`"

# Preferred Command Substitution
echo "Current date is $(date +%F)"

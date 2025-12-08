#!/usr/bin/env bash
# Configuration Demo - Sourcing Config Files

echo "=== Configuration Demo ==="
echo ""

# Create a sample config file
CONFIG_FILE="/tmp/demo_config.sh"

cat > "$CONFIG_FILE" << 'EOF'
# Sample configuration file
# This gets sourced by the main script

# Database settings
DB_HOST="localhost"
DB_PORT=5432
DB_NAME="myapp"
DB_USER="appuser"

# Application settings
APP_ENV="development"
APP_DEBUG=true
LOG_LEVEL="INFO"

# Paths
DATA_DIR="/var/data"
TEMP_DIR="/tmp/myapp"
EOF

echo "--- Config File Contents ---"
cat "$CONFIG_FILE"
echo ""

# Source the config file
echo "--- Loading Configuration ---"
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
    echo "Configuration loaded from: $CONFIG_FILE"
else
    echo "Config file not found!"
fi
echo ""

# Display loaded values
echo "--- Loaded Values ---"
echo "DB_HOST=$DB_HOST"
echo "DB_PORT=$DB_PORT"
echo "DB_NAME=$DB_NAME"
echo "DB_USER=$DB_USER"
echo "APP_ENV=$APP_ENV"
echo "APP_DEBUG=$APP_DEBUG"
echo "LOG_LEVEL=$LOG_LEVEL"
echo ""

# Using defaults for missing values
echo "--- Using Defaults ---"
# This variable wasn't in config, so use default
TIMEOUT="${TIMEOUT:-30}"
MAX_RETRIES="${MAX_RETRIES:-3}"

echo "TIMEOUT=$TIMEOUT (default: 30)"
echo "MAX_RETRIES=$MAX_RETRIES (default: 3)"
echo ""

# Environment variable override
echo "--- Environment Overrides ---"
echo "Original DB_HOST: $DB_HOST"

# Simulate environment override
export MYAPP_DB_HOST="production-db.example.com"
DB_HOST="${MYAPP_DB_HOST:-$DB_HOST}"
echo "After env override: $DB_HOST"
echo ""

# Config file search order
echo "--- Config Search Order ---"
find_config() {
    local config_name="myapp.conf"
    local search_paths=(
        "./$config_name"                    # Current directory
        "$HOME/.$config_name"               # User home
        "$HOME/.config/myapp/$config_name"  # XDG config
        "/etc/myapp/$config_name"           # System config
    )

    for path in "${search_paths[@]}"; do
        echo "  Checking: $path"
        if [[ -f "$path" ]]; then
            echo "  -> Found!"
            return 0
        fi
    done
    echo "  -> Not found in any location"
    return 1
}

find_config

# Cleanup
rm -f "$CONFIG_FILE"

echo ""
echo "=== Key Takeaways ==="
echo "1. Use 'source' to load config files"
echo "2. Always provide default values"
echo "3. Allow environment variable overrides"
echo "4. Search multiple locations for config"

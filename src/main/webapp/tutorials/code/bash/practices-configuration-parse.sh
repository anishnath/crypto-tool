#!/usr/bin/env bash
# Configuration Parsing Demo

echo "=== Config Parsing Demo ==="
echo ""

# Create sample config files
KEY_VALUE_FILE="/tmp/app.conf"
INI_FILE="/tmp/app.ini"

# Simple key=value config
cat > "$KEY_VALUE_FILE" << 'EOF'
# Application Configuration
# Comments start with #

host=localhost
port=8080
debug=true
name=My Application
timeout=30
EOF

# INI-style config
cat > "$INI_FILE" << 'EOF'
# INI Configuration File

[database]
host=db.example.com
port=5432
name=production_db

[cache]
enabled=true
ttl=3600
host=redis.example.com

[logging]
level=INFO
file=/var/log/app.log
EOF

# Parser 1: Simple key=value
echo "--- Simple Key=Value Parser ---"
parse_simple() {
    local file="$1"
    echo "Parsing: $file"
    echo ""

    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue

        # Trim whitespace
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        echo "  $key = $value"

        # Make available as variable (uppercase)
        declare -g "CONFIG_${key^^}=$value"
    done < "$file"
}

parse_simple "$KEY_VALUE_FILE"
echo ""
echo "Accessing parsed values:"
echo "  CONFIG_HOST=$CONFIG_HOST"
echo "  CONFIG_PORT=$CONFIG_PORT"
echo ""

# Parser 2: INI file
echo "--- INI File Parser ---"
parse_ini() {
    local file="$1"
    local section=""
    echo "Parsing: $file"
    echo ""

    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*[#\;] ]] && continue
        [[ -z "${line// }" ]] && continue

        # Section header [section]
        if [[ "$line" =~ ^\[([^\]]+)\] ]]; then
            section="${BASH_REMATCH[1]}"
            echo "[$section]"
            continue
        fi

        # Key=value pair
        if [[ "$line" =~ ^([^=]+)=(.*)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"

            # Trim whitespace
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)

            echo "  $key = $value"

            # Create variable: SECTION_KEY=value
            local var_name="${section^^}_${key^^}"
            declare -g "$var_name=$value"
        fi
    done < "$file"
}

parse_ini "$INI_FILE"
echo ""
echo "Accessing INI values:"
echo "  DATABASE_HOST=$DATABASE_HOST"
echo "  DATABASE_PORT=$DATABASE_PORT"
echo "  CACHE_ENABLED=$CACHE_ENABLED"
echo "  LOGGING_LEVEL=$LOGGING_LEVEL"
echo ""

# Parser 3: Using associative array
echo "--- Associative Array Parser ---"
declare -A config

load_to_array() {
    local file="$1"

    while IFS='=' read -r key value; do
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue

        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        config["$key"]="$value"
    done < "$file"
}

load_to_array "$KEY_VALUE_FILE"

echo "Config array contents:"
for key in "${!config[@]}"; do
    echo "  config[$key] = ${config[$key]}"
done

echo ""
echo "Getting specific values:"
echo "  config[host] = ${config[host]}"
echo "  config[port] = ${config[port]}"
echo "  config[missing] = ${config[missing]:-<not set>}"

# Cleanup
rm -f "$KEY_VALUE_FILE" "$INI_FILE"

echo ""
echo "=== Parsing Summary ==="
echo "1. Simple: while IFS='=' read key value"
echo "2. INI: Detect [sections] and prefix vars"
echo "3. Array: Store in associative array"

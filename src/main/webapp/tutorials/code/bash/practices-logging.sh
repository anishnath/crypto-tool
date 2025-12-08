#!/usr/bin/env bash
# Basic Logging Demo

echo "=== Basic Logging Demo ==="
echo ""

# Simple timestamp function
timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Basic log function
log() {
    echo "[$(timestamp)] $*"
}

# Error log (to stderr)
log_error() {
    echo "[$(timestamp)] ERROR: $*" >&2
}

# Warning log
log_warn() {
    echo "[$(timestamp)] WARN: $*" >&2
}

# Info log
log_info() {
    echo "[$(timestamp)] INFO: $*"
}

# Debug log (controlled by DEBUG variable)
DEBUG="${DEBUG:-false}"
log_debug() {
    [[ "$DEBUG" == "true" ]] && echo "[$(timestamp)] DEBUG: $*"
}

# Demo the logging functions
echo "--- Standard Log Output ---"
log "Script started"
log_info "Processing data..."
log_warn "File not found, using defaults"
log_error "Connection failed"
log "Script completed"

echo ""
echo "--- Debug Logging (DEBUG=false) ---"
log_debug "This won't show because DEBUG=false"
echo "(No debug output)"

echo ""
echo "--- Debug Logging (DEBUG=true) ---"
DEBUG=true
log_debug "Now debug messages are visible"
log_debug "Variable value: x=42"
DEBUG=false

echo ""

# Log with context
echo "--- Contextual Logging ---"
log_context() {
    local context="$1"
    shift
    echo "[$(timestamp)] [$context] $*"
}

log_context "MAIN" "Starting application"
log_context "DB" "Connecting to database"
log_context "API" "Fetching user data"
log_context "MAIN" "Shutdown complete"

echo ""

# Log with PID (useful for parallel scripts)
echo "--- Logging with PID ---"
log_pid() {
    echo "[$(timestamp)] [PID:$$] $*"
}

log_pid "Process started"
log_pid "Doing work..."
log_pid "Process finished"

echo ""
echo "=== Logging Best Practices ==="
echo "1. Always include timestamps"
echo "2. Send errors to stderr (>&2)"
echo "3. Use log levels (DEBUG, INFO, WARN, ERROR)"
echo "4. Include context (function name, PID)"
echo "5. Make debug output controllable"

#!/usr/bin/env bash
# Log Levels Demo

echo "=== Log Levels Demo ==="
echo ""

# Define log levels as numbers
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=2
readonly LOG_LEVEL_ERROR=3

# Current log level (configurable)
CURRENT_LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}

# Color codes (optional, for terminal output)
readonly COLOR_DEBUG="\033[36m"  # Cyan
readonly COLOR_INFO="\033[32m"   # Green
readonly COLOR_WARN="\033[33m"   # Yellow
readonly COLOR_ERROR="\033[31m"  # Red
readonly COLOR_RESET="\033[0m"

# Core logging function
_log() {
    local level=$1
    local level_name=$2
    local color=$3
    shift 3
    local message="$*"

    # Check if we should log this level
    [[ $level -lt $CURRENT_LOG_LEVEL ]] && return 0

    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Output with color if terminal supports it
    if [[ -t 1 ]]; then
        echo -e "[${timestamp}] ${color}${level_name}${COLOR_RESET}: ${message}"
    else
        echo "[${timestamp}] ${level_name}: ${message}"
    fi
}

# Log level functions
log_debug() { _log $LOG_LEVEL_DEBUG "DEBUG" "$COLOR_DEBUG" "$@"; }
log_info()  { _log $LOG_LEVEL_INFO  "INFO " "$COLOR_INFO"  "$@"; }
log_warn()  { _log $LOG_LEVEL_WARN  "WARN " "$COLOR_WARN"  "$@" >&2; }
log_error() { _log $LOG_LEVEL_ERROR "ERROR" "$COLOR_ERROR" "$@" >&2; }

# Demo with different log levels
echo "--- Current Level: INFO (level=$CURRENT_LOG_LEVEL) ---"
log_debug "This debug message won't show"
log_info "Application started"
log_warn "Configuration file missing, using defaults"
log_error "Failed to connect to server"

echo ""
echo "--- Changing to Level: DEBUG ---"
CURRENT_LOG_LEVEL=$LOG_LEVEL_DEBUG
log_debug "Now debug messages are visible"
log_debug "Variable dump: user=john, count=42"
log_info "Processing request"

echo ""
echo "--- Changing to Level: WARN ---"
CURRENT_LOG_LEVEL=$LOG_LEVEL_WARN
log_debug "This won't show"
log_info "This won't show either"
log_warn "Only warnings and errors show"
log_error "Critical failure!"

echo ""
echo "--- Changing to Level: ERROR ---"
CURRENT_LOG_LEVEL=$LOG_LEVEL_ERROR
log_debug "Hidden"
log_info "Hidden"
log_warn "Hidden"
log_error "Only errors show at this level"

# Reset for summary
CURRENT_LOG_LEVEL=$LOG_LEVEL_INFO

echo ""
echo "=== Log Level Summary ==="
echo "DEBUG (0) - Detailed diagnostic info"
echo "INFO  (1) - General progress messages"
echo "WARN  (2) - Warning conditions"
echo "ERROR (3) - Error conditions"
echo ""
echo "Set LOG_LEVEL environment variable:"
echo "  LOG_LEVEL=0 ./script.sh  # Debug mode"
echo "  LOG_LEVEL=2 ./script.sh  # Warnings only"

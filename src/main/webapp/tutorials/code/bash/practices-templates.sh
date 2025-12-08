#!/usr/bin/env bash
#
# Minimal Script Template
#
# A simple but safe starting point for quick scripts.
#

set -euo pipefail

# Script info
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==============================================================================
# CONFIGURATION
# ==============================================================================

# Add your defaults here
output_dir="${OUTPUT_DIR:-/tmp}"
verbose="${VERBOSE:-false}"

# ==============================================================================
# FUNCTIONS
# ==============================================================================

log() {
    echo "[$(date '+%H:%M:%S')] $*"
}

die() {
    echo "ERROR: $*" >&2
    exit 1
}

cleanup() {
    # Add cleanup tasks here
    [[ "$verbose" == "true" ]] && log "Cleanup complete"
}

trap cleanup EXIT

# ==============================================================================
# MAIN
# ==============================================================================

main() {
    log "Script started"
    log "Script dir: $SCRIPT_DIR"
    log "Output dir: $output_dir"

    # Your logic here
    log "Doing work..."

    # Example: check dependencies
    command -v bash &>/dev/null || die "bash not found"

    # Example: validate inputs
    [[ -d "$output_dir" ]] || die "Output dir not found: $output_dir"

    log "Script completed successfully"
}

# Run main
main "$@"

# ==============================================================================
# TEMPLATE NOTES
# ==============================================================================
#
# This minimal template includes:
#   - set -euo pipefail for safety
#   - Script directory detection
#   - Basic logging functions
#   - Cleanup trap
#   - Main function pattern
#
# Add as needed:
#   - Argument parsing (getopts or manual)
#   - More detailed help/usage
#   - Configuration file loading
#   - More sophisticated logging
#

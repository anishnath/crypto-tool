#!/usr/bin/env bash
#
# monitor.sh - System monitoring script demonstration
#
# This is a simplified demo that shows monitoring concepts.
#

set -euo pipefail

echo "=== System Monitoring Demo ==="
echo ""

# Configuration
WARN_CPU=80
CRIT_CPU=90
WARN_MEM=80
CRIT_MEM=90
WARN_DISK=80
CRIT_DISK=90

# Status codes
readonly STATUS_OK=0
readonly STATUS_WARN=1
readonly STATUS_CRIT=2

# Logging
timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

log() {
    echo "[$(timestamp)] $*"
}

# Get CPU usage (simplified)
get_cpu_usage() {
    # This is a simplified demo - real implementation would use /proc/stat
    # For demo purposes, generate a random value
    local usage=$((RANDOM % 100))
    echo "$usage"
}

# Get memory usage
get_memory_usage() {
    # Try to get real memory info, fall back to demo value
    if command -v free &>/dev/null; then
        free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}'
    else
        # Demo fallback
        echo $((RANDOM % 100))
    fi
}

# Get disk usage
get_disk_usage() {
    local path="${1:-/}"
    if df "$path" &>/dev/null; then
        df "$path" | awk 'NR==2 {gsub(/%/,""); print $5}'
    else
        # Demo fallback
        echo $((RANDOM % 100))
    fi
}

# Check threshold and return status
check_threshold() {
    local value="$1"
    local warn="$2"
    local crit="$3"

    if [[ $value -ge $crit ]]; then
        echo $STATUS_CRIT
    elif [[ $value -ge $warn ]]; then
        echo $STATUS_WARN
    else
        echo $STATUS_OK
    fi
}

# Format status for display
format_status() {
    local status="$1"
    case $status in
        $STATUS_OK)   echo "OK" ;;
        $STATUS_WARN) echo "WARNING" ;;
        $STATUS_CRIT) echo "CRITICAL" ;;
        *)            echo "UNKNOWN" ;;
    esac
}

# Get status color (for terminals that support it)
status_indicator() {
    local status="$1"
    case $status in
        $STATUS_OK)   echo "[OK]" ;;
        $STATUS_WARN) echo "[WARN]" ;;
        $STATUS_CRIT) echo "[CRIT]" ;;
        *)            echo "[????]" ;;
    esac
}

# Monitor CPU
monitor_cpu() {
    local usage=$(get_cpu_usage)
    local status=$(check_threshold "$usage" "$WARN_CPU" "$CRIT_CPU")

    echo "CPU Usage: ${usage}% $(status_indicator $status)"
    return $status
}

# Monitor memory
monitor_memory() {
    local usage=$(get_memory_usage)
    local status=$(check_threshold "$usage" "$WARN_MEM" "$CRIT_MEM")

    echo "Memory Usage: ${usage}% $(status_indicator $status)"
    return $status
}

# Monitor disk
monitor_disk() {
    local path="${1:-/tmp}"
    local usage=$(get_disk_usage "$path")
    local status=$(check_threshold "$usage" "$WARN_DISK" "$CRIT_DISK")

    echo "Disk Usage ($path): ${usage}% $(status_indicator $status)"
    return $status
}

# Monitor running processes
monitor_processes() {
    echo "--- Top Processes by Memory ---"

    if command -v ps &>/dev/null; then
        ps aux --sort=-%mem 2>/dev/null | head -6 | awk '
            NR==1 {printf "  %-10s %5s %5s  %s\n", "USER", "%MEM", "%CPU", "COMMAND"}
            NR>1  {printf "  %-10s %5s %5s  %s\n", $1, $4, $3, $11}
        ' 2>/dev/null || echo "  (ps command not available in this environment)"
    else
        echo "  (ps command not available)"
    fi
}

# Generate report
generate_report() {
    echo "========================================"
    echo "       SYSTEM MONITORING REPORT"
    echo "========================================"
    echo "Timestamp: $(timestamp)"
    echo "Hostname:  ${HOSTNAME:-$(hostname 2>/dev/null || echo 'unknown')}"
    echo ""

    echo "--- Resource Usage ---"
    local overall_status=$STATUS_OK

    monitor_cpu || overall_status=$?
    monitor_memory || { [[ $? -gt $overall_status ]] && overall_status=$?; }
    monitor_disk "/tmp" || { [[ $? -gt $overall_status ]] && overall_status=$?; }

    echo ""
    monitor_processes

    echo ""
    echo "========================================"
    echo "Overall Status: $(format_status $overall_status)"
    echo "========================================"

    return $overall_status
}

# Alert function (simplified)
send_alert() {
    local level="$1"
    local message="$2"

    log "ALERT [$level]: $message"

    # In production, this would:
    # - Send email: mail -s "Alert: $message" admin@example.com
    # - Send to Slack: curl -X POST -d '{"text":"'$message'"}' $SLACK_WEBHOOK
    # - Page on-call: curl -X POST pagerduty.com/...
}

# Main monitoring loop (demo runs once)
main() {
    log "Starting system monitoring..."
    echo ""

    # Generate report
    generate_report
    local status=$?

    echo ""

    # Check if alerts needed
    if [[ $status -eq $STATUS_CRIT ]]; then
        send_alert "CRITICAL" "System resources critical!"
    elif [[ $status -eq $STATUS_WARN ]]; then
        send_alert "WARNING" "System resources warning"
    else
        log "All systems nominal"
    fi

    echo ""
    log "Monitoring complete"

    # In production, you might:
    # - Run in a loop with sleep
    # - Write metrics to a time-series database
    # - Expose metrics endpoint for Prometheus
}

main "$@"

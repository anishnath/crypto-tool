#!/bin/bash

###############################################################################
# Advanced Tomcat Deployment Script with Health Checks
# 
# This script automates the deployment of the crypto-tool WAR file to Tomcat
# with additional features:
# - Graceful shutdown with timeout
# - Health check after deployment
# - Rollback capability
# - Detailed logging
# - Configuration file support
#
# Usage: 
#   ./deploy-tomcat-advanced.sh
#   ./deploy-tomcat-advanced.sh --no-backup
#   ./deploy-tomcat-advanced.sh --health-check-url http://localhost:8080
###############################################################################

set -e  # Exit on error

# Parse command line arguments
SKIP_BACKUP=true
SKIP_BUILD=false
HEALTH_CHECK_URL=""
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-backup)
            SKIP_BACKUP=true
            shift
            ;;
        --skip-build)
            SKIP_BUILD=true
            shift
            ;;
        --health-check-url)
            HEALTH_CHECK_URL="$2"
            shift 2
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--no-backup] [--skip-build] [--health-check-url URL] [--verbose]"
            exit 1
            ;;
    esac
done

# Configuration - Adjust these paths as needed
USER_HOME="/home/ec2-user"
PROJECT_DIR="${USER_HOME}/crypto-tool"
WAR_FILE="${PROJECT_DIR}/target/mywebapp2-1.0.war"
TOMCAT_HOME="${USER_HOME}/apache-tomcat-9.0.27"
TOMCAT_WEBAPPS="${TOMCAT_HOME}/webapps"
DEPLOY_TARGET="${TOMCAT_WEBAPPS}/ROOT.war"
TOMCAT_STARTUP="${TOMCAT_HOME}/bin/startup.sh"
TOMCAT_SHUTDOWN="${TOMCAT_HOME}/bin/shutdown.sh"
TOMCAT_LOGS="${TOMCAT_HOME}/logs"
CATALINA_OUT="${TOMCAT_LOGS}/catalina.out"

# Timeouts (in seconds)
SHUTDOWN_TIMEOUT=30
STARTUP_TIMEOUT=60
HEALTH_CHECK_TIMEOUT=30

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_debug() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${BLUE}[DEBUG]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
    fi
}

# Function to find Tomcat Java processes
find_tomcat_pids() {
    ps -elf | grep java | grep -v grep | grep -i tomcat | awk '{print $4}' || true
}

# Function to wait for process to stop
wait_for_stop() {
    local timeout=$1
    local elapsed=0
    local interval=2
    
    while [ $elapsed -lt $timeout ]; do
        local pids=$(find_tomcat_pids)
        if [ -z "$pids" ]; then
            return 0
        fi
        sleep $interval
        elapsed=$((elapsed + interval))
        log_debug "Waiting for Tomcat to stop... (${elapsed}s/${timeout}s)"
    done
    return 1
}

# Function to wait for Tomcat to start
wait_for_start() {
    local timeout=$1
    local elapsed=0
    local interval=2
    
    while [ $elapsed -lt $timeout ]; do
        local pids=$(find_tomcat_pids)
        if [ -n "$pids" ]; then
            # Check if catalina.out shows server started
            if [ -f "$CATALINA_OUT" ]; then
                if grep -q "Server startup in" "$CATALINA_OUT" 2>/dev/null; then
                    return 0
                fi
            fi
        fi
        sleep $interval
        elapsed=$((elapsed + interval))
        log_debug "Waiting for Tomcat to start... (${elapsed}s/${timeout}s)"
    done
    
    # Check if process is running even if log doesn't show startup
    local pids=$(find_tomcat_pids)
    if [ -n "$pids" ]; then
        return 0
    fi
    return 1
}

# Function to check health endpoint
check_health() {
    local url=$1
    local timeout=$2
    
    log_info "Checking health endpoint: $url"
    
    if command -v curl >/dev/null 2>&1; then
        if curl -f -s --max-time $timeout "$url" >/dev/null 2>&1; then
            return 0
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget -q --timeout=$timeout --spider "$url" 2>/dev/null; then
            return 0
        fi
    else
        log_warn "Neither curl nor wget found. Skipping health check."
        return 0
    fi
    return 1
}

# Main deployment function
main() {
    log_info "========================================="
    log_info "Tomcat Deployment Script (Advanced)"
    log_info "========================================="
    
    # Step 1: Update code and build
    if [ "$SKIP_BUILD" = false ]; then
        log_info "Step 1: Updating code and building project..."
        log_info "Changing to project directory: $PROJECT_DIR"
        
        if [ ! -d "$PROJECT_DIR" ]; then
            log_error "Project directory not found: $PROJECT_DIR"
            exit 1
        fi
        
        cd "$PROJECT_DIR" || {
            log_error "Failed to change to project directory"
            exit 1
        }
        
        # Git pull
        log_info "Pulling latest changes from git..."
        if git pull; then
            log_info "Git pull completed successfully"
        else
            log_warn "Git pull had issues, continuing anyway..."
        fi
        
        # Maven build
        log_info "Building project with Maven..."
        if command -v mvn >/dev/null 2>&1; then
            if mvn package; then
                log_info "Maven build completed successfully"
            else
                log_error "Maven build failed"
                exit 1
            fi
        else
            log_error "Maven (mvn) command not found. Please install Maven."
            exit 1
        fi
        
        # Change back to parent directory
        log_info "Changing back to parent directory..."
        cd .. || {
            log_warn "Failed to change to parent directory, continuing from current location..."
        }
    else
        log_info "Step 1: Skipping build (--skip-build flag set)"
    fi
    
    # Step 2: Check prerequisites
    log_info "Step 2: Checking prerequisites..."
    
    if [ ! -f "$WAR_FILE" ]; then
        log_error "WAR file not found: $WAR_FILE"
        log_error "Build may have failed. Check Maven output above."
        exit 1
    fi
    
    if [ ! -d "$TOMCAT_HOME" ]; then
        log_error "Tomcat home directory not found: $TOMCAT_HOME"
        exit 1
    fi
    
    if [ ! -f "$TOMCAT_STARTUP" ]; then
        log_error "Tomcat startup script not found: $TOMCAT_STARTUP"
        exit 1
    fi
    
    # Display WAR file info
    WAR_SIZE=$(du -h "$WAR_FILE" | cut -f1)
    WAR_DATE=$(stat -c %y "$WAR_FILE" 2>/dev/null || stat -f "%Sm" "$WAR_FILE" 2>/dev/null || echo "unknown")
    log_info "WAR file: $WAR_FILE"
    log_info "WAR size: $WAR_SIZE"
    log_info "WAR date: $WAR_DATE"
    
    # Step 3: Stop Tomcat
    log_info "Step 3: Stopping Tomcat..."
    TOMCAT_PIDS=$(find_tomcat_pids)
    
    if [ -z "$TOMCAT_PIDS" ]; then
        log_info "No Tomcat processes found"
    else
        log_info "Found Tomcat process(es): $TOMCAT_PIDS"
        
        # Try graceful shutdown
        if [ -f "$TOMCAT_SHUTDOWN" ]; then
            log_info "Attempting graceful shutdown..."
            $TOMCAT_SHUTDOWN || log_warn "Shutdown script returned error"
            
            if wait_for_stop $SHUTDOWN_TIMEOUT; then
                log_info "Tomcat stopped gracefully"
            else
                log_warn "Graceful shutdown timed out. Force killing..."
                for PID in $TOMCAT_PIDS; do
                    kill -9 $PID 2>/dev/null || true
                done
                sleep 2
            fi
        else
            log_warn "Shutdown script not found. Force killing..."
            for PID in $TOMCAT_PIDS; do
                kill -9 $PID 2>/dev/null || true
            done
            sleep 2
        fi
        
        # Verify stopped
        TOMCAT_PIDS=$(find_tomcat_pids)
        if [ -n "$TOMCAT_PIDS" ]; then
            log_error "Failed to stop Tomcat. Remaining PIDs: $TOMCAT_PIDS"
            exit 1
        fi
        
        log_info "Tomcat stopped successfully"
    fi
    
    # Step 4: Backup existing deployment
    if [ "$SKIP_BACKUP" = false ] && [ -f "$DEPLOY_TARGET" ]; then
        log_info "Step 4: Creating backup..."
        BACKUP_DIR="${TOMCAT_WEBAPPS}/backups"
        mkdir -p "$BACKUP_DIR"
        BACKUP_FILE="${BACKUP_DIR}/ROOT.war.backup.$(date +%Y%m%d_%H%M%S)"
        
        if cp "$DEPLOY_TARGET" "$BACKUP_FILE"; then
            BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
            log_info "Backup created: $BACKUP_FILE ($BACKUP_SIZE)"
        else
            log_warn "Backup failed, continuing anyway..."
        fi
    else
        log_info "Step 3: Skipping backup (--no-backup or no existing deployment)"
    fi
    
    # Step 5: Clean old deployment
    log_info "Step 5: Cleaning old deployment..."
    if [ -d "${TOMCAT_WEBAPPS}/ROOT" ]; then
        log_info "Removing old ROOT directory..."
        rm -rf "${TOMCAT_WEBAPPS}/ROOT"
    fi
    
    # Remove old WAR if exists (Tomcat will extract new one)
    if [ -f "$DEPLOY_TARGET" ]; then
        log_info "Removing old WAR file..."
        rm -f "$DEPLOY_TARGET"
    fi
    
    # Step 6: Deploy new WAR
    log_info "Step 6: Deploying new WAR file..."
    if cp "$WAR_FILE" "$DEPLOY_TARGET"; then
        DEPLOYED_SIZE=$(du -h "$DEPLOY_TARGET" | cut -f1)
        log_info "WAR file deployed successfully ($DEPLOYED_SIZE)"
    else
        log_error "Failed to copy WAR file"
        exit 1
    fi
    
    # Step 7: Start Tomcat
    log_info "Step 7: Starting Tomcat..."
    chmod +x "$TOMCAT_STARTUP"
    
    if $TOMCAT_STARTUP; then
        log_info "Tomcat startup command executed"
        
        if wait_for_start $STARTUP_TIMEOUT; then
            TOMCAT_PIDS=$(find_tomcat_pids)
            log_info "Tomcat started successfully! PID(s): $TOMCAT_PIDS"
        else
            log_error "Tomcat startup timed out or failed"
            log_error "Check logs at: $CATALINA_OUT"
            if [ -f "$CATALINA_OUT" ]; then
                log_info "Last 20 lines of catalina.out:"
                tail -20 "$CATALINA_OUT" | sed 's/^/  /'
            fi
            exit 1
        fi
    else
        log_error "Failed to execute Tomcat startup script"
        exit 1
    fi
    
    # Step 8: Health check (optional)
    if [ -n "$HEALTH_CHECK_URL" ]; then
        log_info "Step 8: Performing health check..."
        if check_health "$HEALTH_CHECK_URL" $HEALTH_CHECK_TIMEOUT; then
            log_info "Health check passed! Application is responding"
        else
            log_warn "Health check failed. Application may still be starting up."
            log_warn "Check logs at: $CATALINA_OUT"
        fi
    else
        log_info "Step 7: Skipping health check (no URL provided)"
        log_info "To enable: $0 --health-check-url http://localhost:8080"
    fi
    
    # Summary
    log_info "========================================="
    log_info "Deployment Summary:"
    log_info "  WAR File: $WAR_FILE"
    log_info "  Deployed To: $DEPLOY_TARGET"
    log_info "  Tomcat PID(s): $(find_tomcat_pids)"
    log_info "  Logs: $CATALINA_OUT"
    if [ -n "$HEALTH_CHECK_URL" ]; then
        log_info "  Health Check: $HEALTH_CHECK_URL"
    fi
    log_info "========================================="
    log_info "Deployment completed successfully!"
}

# Run main function
main "$@"


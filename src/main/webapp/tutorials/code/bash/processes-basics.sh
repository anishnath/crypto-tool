#!/bin/bash
# Process Basics

echo "=========================================="
echo "Process Basics"
echo "=========================================="
echo ""

# Current process ID
echo "Current script PID: $$"
echo ""

# Background process
echo "Starting background process..."
sleep 5 &
bg_pid=$!
echo "Background process PID: $bg_pid"
echo "Process ID stored in \$!: $!"
echo ""

# Parent process ID
echo "Parent process ID (PPID): $PPID"
echo ""

# Wait for background process
echo "Waiting for background process..."
wait $bg_pid
echo "Background process completed"
echo ""

# Process status
echo "Checking if process is still running:"
if ps -p $bg_pid > /dev/null 2>&1; then
    echo "Process $bg_pid is still running"
else
    echo "Process $bg_pid has finished"
fi
echo ""

# Process information
echo "Current process information:"
echo "PID: $$"
echo "PPID: $PPID"
echo "User: $USER"
echo ""

echo "=========================================="
echo "Process management basics covered"
echo "=========================================="


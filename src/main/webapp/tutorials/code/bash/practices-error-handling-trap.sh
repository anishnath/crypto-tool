#!/usr/bin/env bash
# Trap Command Demo

echo "=== Trap Command Demo ==="
echo ""

# Demo 1: Basic EXIT trap
echo "--- EXIT Trap ---"

demo_exit_trap() {
    # Define cleanup function
    cleanup() {
        echo "  [TRAP] Cleanup executed!"
    }

    # Set trap
    trap cleanup EXIT

    echo "  Running some code..."
    echo "  Exiting function..."

    # Cleanup runs automatically when function exits
}

# Run in subshell to isolate trap
(demo_exit_trap)

echo ""

# Demo 2: Cleanup temporary files
echo "--- Temp File Cleanup ---"

demo_temp_cleanup() {
    local temp_file
    temp_file=$(mktemp)
    echo "  Created temp file: $temp_file"

    # Trap to remove temp file
    trap "rm -f '$temp_file'; echo '  [TRAP] Removed temp file'" EXIT

    # Use the temp file
    echo "test data" > "$temp_file"
    echo "  Wrote to temp file"

    # File is automatically cleaned up on exit
}

(demo_temp_cleanup)

echo ""

# Demo 3: ERR trap for error handling
echo "--- ERR Trap ---"

demo_err_trap() {
    # Error handler
    on_error() {
        echo "  [TRAP] Error occurred on line $1!"
    }

    # Note: ERR trap needs set -E to work in functions
    trap 'on_error $LINENO' ERR

    echo "  Running commands..."
    true  # Success
    echo "  First command succeeded"

    # Simulate an error (but don't exit)
    false || echo "  Second command failed (caught with ||)"
}

demo_err_trap

echo ""

# Demo 4: Multiple signals
echo "--- Multiple Signal Handlers ---"

show_signals() {
    echo "  Common signals you can trap:"
    echo "    EXIT  - Script exits (any reason)"
    echo "    ERR   - Command returns non-zero"
    echo "    INT   - Ctrl+C (SIGINT)"
    echo "    TERM  - kill command (SIGTERM)"
    echo "    HUP   - Terminal hangup"
    echo ""
    echo "  Signals you CANNOT trap:"
    echo "    KILL (9)  - Cannot be caught"
    echo "    STOP (19) - Cannot be caught"
}

show_signals

echo ""

# Demo 5: Stack-based cleanup
echo "--- Stack-based Cleanup ---"

demo_cleanup_stack() {
    # Array to hold cleanup commands
    declare -a cleanup_stack=()

    # Function to add cleanup task
    push_cleanup() {
        cleanup_stack+=("$1")
        echo "  Added cleanup: $1"
    }

    # Function to run all cleanup tasks (in reverse order)
    run_cleanup() {
        echo "  [TRAP] Running cleanup stack..."
        local i
        for ((i=${#cleanup_stack[@]}-1; i>=0; i--)); do
            echo "    Executing: ${cleanup_stack[i]}"
            eval "${cleanup_stack[i]}" 2>/dev/null || true
        done
    }

    trap run_cleanup EXIT

    # Add some cleanup tasks
    push_cleanup "echo 'Task 1: Done'"
    push_cleanup "echo 'Task 2: Done'"
    push_cleanup "echo 'Task 3: Done'"

    echo "  Simulating script work..."
}

(demo_cleanup_stack)

echo ""

# Demo 6: Trap best practices
echo "--- Best Practices ---"
cat << 'EOF'
  1. Always trap EXIT for cleanup:
     trap cleanup EXIT

  2. Create temp files safely:
     temp=$(mktemp)
     trap "rm -f '$temp'" EXIT

  3. Handle interrupts gracefully:
     trap 'echo "Interrupted"; exit 130' INT

  4. Use trap -p to show current traps:
     trap -p

  5. Reset a trap with:
     trap - SIGNAL
EOF

echo ""
echo "=== Trap Demo Complete ==="

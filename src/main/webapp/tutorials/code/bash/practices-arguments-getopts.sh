#!/usr/bin/env bash
# getopts Demo

echo "=== getopts Demo ==="
echo ""

# Reset for demo
OPTIND=1

# Initialize defaults
verbose=false
debug=false
output_file=""
input_file=""

# Demo with simulated arguments
set -- -v -d -o "output.txt" -f "input.txt" "extra_arg1" "extra_arg2"

echo "Arguments: $@"
echo ""

echo "--- Parsing with getopts ---"

# getopts string: "vdo:f:"
# v, d = flags (no argument)
# o:, f: = options (require argument)
# Leading : = silent error mode

while getopts ":vdo:f:" opt; do
    case $opt in
        v)
            verbose=true
            echo "Found -v (verbose)"
            ;;
        d)
            debug=true
            echo "Found -d (debug)"
            ;;
        o)
            output_file="$OPTARG"
            echo "Found -o with value: $OPTARG"
            ;;
        f)
            input_file="$OPTARG"
            echo "Found -f with value: $OPTARG"
            ;;
        :)
            echo "Error: Option -$OPTARG requires an argument"
            ;;
        \?)
            echo "Error: Invalid option -$OPTARG"
            ;;
    esac
done

echo ""
echo "--- After getopts ---"
echo "OPTIND = $OPTIND (index of next arg to process)"
echo ""

# Shift away processed options
shift $((OPTIND - 1))

echo "--- Parsed Values ---"
echo "verbose = $verbose"
echo "debug = $debug"
echo "output_file = $output_file"
echo "input_file = $input_file"
echo ""

echo "--- Remaining Arguments ---"
echo "Count: $#"
for arg in "$@"; do
    echo "  - $arg"
done

echo ""

# Complete example function
echo "=== Complete Example ==="

process_files() {
    local verbose=false
    local force=false
    local output=""
    OPTIND=1  # Reset for function

    while getopts ":vfo:" opt; do
        case $opt in
            v) verbose=true ;;
            f) force=true ;;
            o) output="$OPTARG" ;;
            :) echo "Option -$OPTARG requires argument" >&2; return 1 ;;
            \?) echo "Invalid option: -$OPTARG" >&2; return 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    echo "Settings:"
    echo "  verbose: $verbose"
    echo "  force: $force"
    echo "  output: ${output:-<stdout>}"
    echo "  files: $@"
}

echo "Calling: process_files -v -o result.txt file1 file2"
process_files -v -o result.txt file1 file2

echo ""
echo "=== getopts Summary ==="
echo "1. Use ':' after letter for required arg"
echo "2. OPTARG contains the argument value"
echo "3. OPTIND tracks position in args"
echo "4. shift \$((OPTIND-1)) for remaining args"
echo "5. Reset OPTIND=1 when parsing in functions"

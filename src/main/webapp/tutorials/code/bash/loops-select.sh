#!/bin/bash
# Select Menus in Bash

echo "=========================================="
echo "Select Menu Loops"
echo "=========================================="
echo ""

# Basic select menu
echo "1. Basic select menu:"
PS3="Choose an option: "
options=("Option 1" "Option 2" "Option 3" "Quit")
select opt in "${options[@]}"; do
    case $opt in
        "Option 1")
            echo "  You chose Option 1"
            break
            ;;
        "Option 2")
            echo "  You chose Option 2"
            break
            ;;
        "Option 3")
            echo "  You chose Option 3"
            break
            ;;
        "Quit")
            echo "  Exiting..."
            break
            ;;
        *)
            echo "  Invalid option"
            ;;
    esac
done
echo ""

# Select with number display
echo "2. Select menu with custom prompt:"
PS3="Please enter your choice (1-4): "
select choice in "Start" "Stop" "Restart" "Status" "Exit"; do
    case $choice in
        "Start")
            echo "  Starting service..."
            break
            ;;
        "Stop")
            echo "  Stopping service..."
            break
            ;;
        "Restart")
            echo "  Restarting service..."
            break
            ;;
        "Status")
            echo "  Service status: running"
            break
            ;;
        "Exit")
            echo "  Goodbye!"
            break
            ;;
        *)
            echo "  Invalid selection. Please choose 1-5."
            ;;
    esac
done
echo ""

# Select without break (continuous)
echo "3. Select menu structure (simulated output):"
echo "  1) View files"
echo "  2) Edit file"
echo "  3) Delete file"
echo "  4) Exit"
echo "  (Select menus create interactive prompts)"
echo ""

echo "=========================================="
echo "Select creates interactive menus"
echo "PS3 controls the prompt"
echo "Use break to exit select loop"
echo "=========================================="


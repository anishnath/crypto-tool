#!/bin/bash
# Case Statements in Bash

echo "=========================================="
echo "Case Statements"
echo "=========================================="
echo ""

# Basic case statement
choice="y"
case $choice in
    y|Y|yes|YES)
        echo "You chose yes"
        ;;
    n|N|no|NO)
        echo "You chose no"
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
echo ""

# Pattern matching
filename="image.jpg"
case $filename in
    *.jpg|*.jpeg)
        echo "JPEG image"
        ;;
    *.png)
        echo "PNG image"
        ;;
    *.gif)
        echo "GIF image"
        ;;
    *)
        echo "Unknown file type"
        ;;
esac
echo ""

# Using character classes
char="a"
case $char in
    [a-z])
        echo "Lowercase letter"
        ;;
    [A-Z])
        echo "Uppercase letter"
        ;;
    [0-9])
        echo "Digit"
        ;;
    *)
        echo "Other character"
        ;;
esac
echo ""

# Multiple patterns
action="start"
case $action in
    start|START)
        echo "Starting service..."
        ;;
    stop|STOP)
        echo "Stopping service..."
        ;;
    restart|RESTART)
        echo "Restarting service..."
        ;;
    *)
        echo "Unknown action: $action"
        ;;
esac
echo ""

echo "=========================================="
echo "Case statements are cleaner than multiple if-elif"
echo "Use ;; to end each case"
echo "Use *) for default case"
echo "=========================================="


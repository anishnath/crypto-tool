package main

import (
	"fmt"
	"runtime"
)

func main() {
	fmt.Println("Compiler Flags Demo")
	fmt.Println("===================\n")

	// Show build information
	fmt.Println("Build Information:")
	fmt.Printf("  Go Version: %s\n", runtime.Version())
	fmt.Printf("  OS: %s\n", runtime.GOOS)
	fmt.Printf("  Architecture: %s\n", runtime.GOARCH)
	fmt.Printf("  Compiler: %s\n", runtime.Compiler)
	fmt.Printf("  CPUs: %d\n\n", runtime.NumCPU())

	// Demonstrate optimization levels
	fmt.Println("Common Compiler Flags:")
	fmt.Println("  -gcflags=\"-m\"          # Escape analysis")
	fmt.Println("  -gcflags=\"-N\"          # Disable optimizations")
	fmt.Println("  -gcflags=\"-l\"          # Disable inlining")
	fmt.Println("  -gcflags=\"-N -l\"       # Debug mode (no opt, no inline)")
	fmt.Println("  -ldflags=\"-s\"          # Strip debug symbols")
	fmt.Println("  -ldflags=\"-w\"          # Strip DWARF symbols")
	fmt.Println("  -ldflags=\"-s -w\"       # Minimal binary size")
	fmt.Println()

	// Build examples
	fmt.Println("Build Commands:")
	fmt.Println("  # Standard build")
	fmt.Println("  go build")
	fmt.Println()
	fmt.Println("  # Debug build (with symbols)")
	fmt.Println("  go build -gcflags=\"-N -l\"")
	fmt.Println()
	fmt.Println("  # Release build (optimized, stripped)")
	fmt.Println("  go build -ldflags=\"-s -w\"")
	fmt.Println()
	fmt.Println("  # With version info")
	fmt.Println("  go build -ldflags=\"-X main.Version=1.0.0\"")
	fmt.Println()

	// Performance flags
	fmt.Println("Performance Flags:")
	fmt.Println("  -race                  # Enable race detector")
	fmt.Println("  -msan                  # Enable memory sanitizer")
	fmt.Println("  -asan                  # Enable address sanitizer")
	fmt.Println("  -buildmode=pie         # Position independent executable")
	fmt.Println("  -trimpath              # Remove file paths from binary")
	fmt.Println()

	// Linker flags
	fmt.Println("Linker Flags (-ldflags):")
	fmt.Println("  -s                     # Strip symbol table")
	fmt.Println("  -w                     # Strip DWARF debug info")
	fmt.Println("  -X key=value           # Set string variable")
	fmt.Println("  -extldflags            # Pass flags to external linker")
	fmt.Println()

	// Example with version
	version := "dev"
	buildTime := "unknown"

	fmt.Println("Version Information:")
	fmt.Printf("  Version: %s\n", version)
	fmt.Printf("  Build Time: %s\n", buildTime)
	fmt.Println()
	fmt.Println("To set at build time:")
	fmt.Println("  go build -ldflags=\"-X main.version=1.0.0 -X main.buildTime=$(date)\"")
}

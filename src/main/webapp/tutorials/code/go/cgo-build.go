//go:build cgo
// +build cgo

package main

// Build tags for conditional compilation

/*
#cgo CFLAGS: -Wall -O2
#cgo LDFLAGS: -lm

#include <math.h>
#include <stdio.h>

double calculate_circle_area(double radius) {
    return M_PI * radius * radius;
}

void print_build_info() {
    printf("Built with CGO\n");
    #ifdef __linux__
    printf("Platform: Linux\n");
    #elif __APPLE__
    printf("Platform: macOS\n");
    #elif _WIN32
    printf("Platform: Windows\n");
    #endif
}
*/
import "C"
import "fmt"

func main() {
	fmt.Println("CGO Build Configuration")
	fmt.Println("=======================\n")

	// Use C math library
	fmt.Println("1. Using C math library:")
	radius := 5.0
	area := C.calculate_circle_area(C.double(radius))
	fmt.Printf("   Circle area (radius=%.1f): %.2f\n\n", radius, area)

	// Print build info
	fmt.Println("2. Build information:")
	C.print_build_info()
	fmt.Println()

	fmt.Println("Build Configuration:")
	fmt.Println("  #cgo CFLAGS: -Wall -O2")
	fmt.Println("    → Compiler flags for C code")
	fmt.Println("  #cgo LDFLAGS: -lm")
	fmt.Println("    → Linker flags (link math library)")
	fmt.Println()

	fmt.Println("Build Tags:")
	fmt.Println("  // +build cgo")
	fmt.Println("    → Only build when CGO is enabled")
	fmt.Println("  // +build linux")
	fmt.Println("    → Only build on Linux")
	fmt.Println("  // +build !windows")
	fmt.Println("    → Build on all platforms except Windows")
	fmt.Println()

	fmt.Println("Platform-Specific Flags:")
	fmt.Println("  #cgo linux CFLAGS: -D_GNU_SOURCE")
	fmt.Println("  #cgo darwin LDFLAGS: -framework CoreFoundation")
	fmt.Println("  #cgo windows LDFLAGS: -lws2_32")
	fmt.Println()

	fmt.Println("Build Commands:")
	fmt.Println("  go build                  # Build with CGO")
	fmt.Println("  CGO_ENABLED=0 go build    # Build without CGO")
	fmt.Println("  go build -tags nocgo      # Skip CGO files")
	fmt.Println()

	fmt.Println("Environment Variables:")
	fmt.Println("  CGO_ENABLED=1             # Enable CGO (default)")
	fmt.Println("  CGO_CFLAGS                # Additional C flags")
	fmt.Println("  CGO_LDFLAGS               # Additional linker flags")
	fmt.Println("  CC=gcc                    # C compiler to use")
}

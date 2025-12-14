//go:build (linux || darwin) && (amd64 || arm64)
// +build linux darwin
// +build amd64 arm64

package main

import (
	"fmt"
	"runtime"
)

func main() {
	fmt.Println("Build Tags Demo")
	fmt.Println("===============\n")

	fmt.Println("This file only builds on:")
	fmt.Println("  • Linux or macOS (darwin)")
	fmt.Println("  • amd64 or arm64 architecture")
	fmt.Println()

	fmt.Printf("Current OS: %s\n", runtime.GOOS)
	fmt.Printf("Current Arch: %s\n\n", runtime.GOARCH)

	// Platform-specific code
	platformSpecific()

	fmt.Println("\nBuild Tag Syntax:")
	fmt.Println("  // +build linux          # Only Linux")
	fmt.Println("  // +build darwin         # Only macOS")
	fmt.Println("  // +build windows        # Only Windows")
	fmt.Println("  // +build linux,darwin   # Linux AND macOS")
	fmt.Println("  // +build linux darwin   # Linux OR macOS")
	fmt.Println("  // +build !windows       # NOT Windows")
	fmt.Println()

	fmt.Println("Go 1.17+ Syntax:")
	fmt.Println("  //go:build linux")
	fmt.Println("  //go:build darwin")
	fmt.Println("  //go:build linux && amd64")
	fmt.Println("  //go:build linux || darwin")
	fmt.Println("  //go:build !windows")
	fmt.Println()

	fmt.Println("Custom Tags:")
	fmt.Println("  // +build integration")
	fmt.Println("  go test -tags=integration")
	fmt.Println()
	fmt.Println("  // +build debug")
	fmt.Println("  go build -tags=debug")
	fmt.Println()

	fmt.Println("Common Use Cases:")
	fmt.Println("  • Platform-specific code")
	fmt.Println("  • Feature flags")
	fmt.Println("  • Test separation (unit vs integration)")
	fmt.Println("  • Debug vs release builds")
	fmt.Println("  • CGO vs pure Go")
}

func platformSpecific() {
	fmt.Println("Platform-specific function executed!")

	// This would contain OS-specific code
	switch runtime.GOOS {
	case "linux":
		fmt.Println("  Running on Linux")
	case "darwin":
		fmt.Println("  Running on macOS")
	default:
		fmt.Println("  Running on", runtime.GOOS)
	}
}

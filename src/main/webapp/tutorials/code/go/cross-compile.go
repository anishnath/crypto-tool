package main

import (
	"fmt"
	"runtime"
)

func main() {
	fmt.Println("Cross-Compilation Demo")
	fmt.Println("======================\n")

	fmt.Println("Current Platform:")
	fmt.Printf("  GOOS: %s\n", runtime.GOOS)
	fmt.Printf("  GOARCH: %s\n\n", runtime.GOARCH)

	fmt.Println("Cross-Compilation Commands:")
	fmt.Println()

	// Linux targets
	fmt.Println("Linux Targets:")
	fmt.Println("  # Linux AMD64")
	fmt.Println("  GOOS=linux GOARCH=amd64 go build -o myapp-linux-amd64")
	fmt.Println()
	fmt.Println("  # Linux ARM64")
	fmt.Println("  GOOS=linux GOARCH=arm64 go build -o myapp-linux-arm64")
	fmt.Println()
	fmt.Println("  # Linux ARM (32-bit)")
	fmt.Println("  GOOS=linux GOARCH=arm GOARM=7 go build -o myapp-linux-arm")
	fmt.Println()

	// macOS targets
	fmt.Println("macOS Targets:")
	fmt.Println("  # macOS AMD64 (Intel)")
	fmt.Println("  GOOS=darwin GOARCH=amd64 go build -o myapp-darwin-amd64")
	fmt.Println()
	fmt.Println("  # macOS ARM64 (Apple Silicon)")
	fmt.Println("  GOOS=darwin GOARCH=arm64 go build -o myapp-darwin-arm64")
	fmt.Println()
	fmt.Println("  # Universal Binary (both)")
	fmt.Println("  lipo -create myapp-darwin-amd64 myapp-darwin-arm64 -output myapp-darwin-universal")
	fmt.Println()

	// Windows targets
	fmt.Println("Windows Targets:")
	fmt.Println("  # Windows AMD64")
	fmt.Println("  GOOS=windows GOARCH=amd64 go build -o myapp-windows-amd64.exe")
	fmt.Println()
	fmt.Println("  # Windows 386 (32-bit)")
	fmt.Println("  GOOS=windows GOARCH=386 go build -o myapp-windows-386.exe")
	fmt.Println()
	fmt.Println("  # Windows ARM64")
	fmt.Println("  GOOS=windows GOARCH=arm64 go build -o myapp-windows-arm64.exe")
	fmt.Println()

	// Other platforms
	fmt.Println("Other Platforms:")
	fmt.Println("  # FreeBSD")
	fmt.Println("  GOOS=freebsd GOARCH=amd64 go build")
	fmt.Println()
	fmt.Println("  # OpenBSD")
	fmt.Println("  GOOS=openbsd GOARCH=amd64 go build")
	fmt.Println()
	fmt.Println("  # WebAssembly")
	fmt.Println("  GOOS=js GOARCH=wasm go build -o myapp.wasm")
	fmt.Println()

	// Build script example
	fmt.Println("Build Script Example:")
	fmt.Println("  #!/bin/bash")
	fmt.Println("  platforms=(")
	fmt.Println("    \"linux/amd64\"")
	fmt.Println("    \"linux/arm64\"")
	fmt.Println("    \"darwin/amd64\"")
	fmt.Println("    \"darwin/arm64\"")
	fmt.Println("    \"windows/amd64\"")
	fmt.Println("  )")
	fmt.Println()
	fmt.Println("  for platform in \"${platforms[@]}\"; do")
	fmt.Println("    GOOS=${platform%/*}")
	fmt.Println("    GOARCH=${platform#*/}")
	fmt.Println("    output=\"myapp-${GOOS}-${GOARCH}\"")
	fmt.Println("    [ \"$GOOS\" = \"windows\" ] && output=\"${output}.exe\"")
	fmt.Println("    GOOS=$GOOS GOARCH=$GOARCH go build -o $output")
	fmt.Println("  done")
	fmt.Println()

	// CGO considerations
	fmt.Println("CGO Cross-Compilation:")
	fmt.Println("  # Disable CGO for pure Go")
	fmt.Println("  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build")
	fmt.Println()
	fmt.Println("  # With CGO (requires cross-compiler)")
	fmt.Println("  CGO_ENABLED=1 CC=x86_64-linux-gnu-gcc GOOS=linux GOARCH=amd64 go build")
	fmt.Println()

	// List all platforms
	fmt.Println("List All Supported Platforms:")
	fmt.Println("  go tool dist list")
	fmt.Println()

	fmt.Println("Tips:")
	fmt.Println("  ✓ Test on target platform when possible")
	fmt.Println("  ✓ Use CGO_ENABLED=0 for pure Go binaries")
	fmt.Println("  ✓ Consider file paths (/ vs \\)")
	fmt.Println("  ✓ Handle platform-specific features")
	fmt.Println("  ✓ Use build tags for platform code")
}

package main

import (
	"fmt"
)

func main() {
	fmt.Println("Plugin Loader Demo")
	fmt.Println("==================\n")

	// Note: This is a demonstration of the plugin loading API
	// Actual plugin loading requires building plugins separately

	fmt.Println("Loading a plugin:")
	fmt.Println("  1. Build plugin: go build -buildmode=plugin -o greeter.so plugin.go")
	fmt.Println("  2. Load plugin: plugin.Open(\"greeter.so\")")
	fmt.Println("  3. Lookup symbol: p.Lookup(\"GreeterPlugin\")")
	fmt.Println("  4. Type assert: greeter := symbol.(GreeterPlugin)")
	fmt.Println("  5. Use plugin: greeter.Greet(\"World\")")
	fmt.Println()

	// Example plugin loading code (would work with actual .so file)
	fmt.Println("Example Code:")
	fmt.Println(`
	// Load the plugin
	p, err := plugin.Open("greeter.so")
	if err != nil {
		log.Fatal(err)
	}
	
	// Look up the exported symbol
	symbol, err := p.Lookup("GreeterPlugin")
	if err != nil {
		log.Fatal(err)
	}
	
	// Assert the symbol to the plugin interface
	greeter, ok := symbol.(GreeterPlugin)
	if !ok {
		log.Fatal("Invalid plugin type")
	}
	
	// Initialize the plugin
	if err := greeter.Initialize(); err != nil {
		log.Fatal(err)
	}
	
	// Use the plugin
	message := greeter.Greet("World")
	fmt.Println(message)
	
	// Get plugin info
	info := greeter.Info()
	fmt.Printf("Plugin: %s v%s\n", info.Name, info.Version)
	
	// Shutdown the plugin
	greeter.Shutdown()
	`)

	fmt.Println("\nPlugin System Benefits:")
	fmt.Println("  ✓ Extend applications without recompiling")
	fmt.Println("  ✓ Third-party extensions")
	fmt.Println("  ✓ Hot-swappable functionality")
	fmt.Println("  ✓ Modular architecture")

	fmt.Println("\nLimitations:")
	fmt.Println("  ⚠ Linux/macOS only (not Windows)")
	fmt.Println("  ⚠ Must use same Go version")
	fmt.Println("  ⚠ Cannot unload plugins")
	fmt.Println("  ⚠ Shared dependencies must match")

	fmt.Println("\nBuild Commands:")
	fmt.Println("  # Build plugin")
	fmt.Println("  go build -buildmode=plugin -o myplugin.so plugin.go")
	fmt.Println()
	fmt.Println("  # Build main app")
	fmt.Println("  go build -o app main.go")
	fmt.Println()
	fmt.Println("  # Run")
	fmt.Println("  ./app")
}

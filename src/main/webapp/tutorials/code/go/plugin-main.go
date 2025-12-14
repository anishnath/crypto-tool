package main

import (
	"fmt"
	"path/filepath"
	"plugin"
	"time"
)

// PluginManager manages loaded plugins
type PluginManager struct {
	plugins map[string]*LoadedPlugin
}

// LoadedPlugin represents a loaded plugin
type LoadedPlugin struct {
	Path     string
	Plugin   *plugin.Plugin
	LoadTime time.Time
	Instance GreeterPlugin
}

// NewPluginManager creates a new plugin manager
func NewPluginManager() *PluginManager {
	return &PluginManager{
		plugins: make(map[string]*LoadedPlugin),
	}
}

// LoadPlugin loads a plugin from the given path
func (pm *PluginManager) LoadPlugin(path string) error {
	// Open the plugin
	p, err := plugin.Open(path)
	if err != nil {
		return fmt.Errorf("failed to open plugin: %w", err)
	}

	// Lookup the symbol
	symbol, err := p.Lookup("GreeterPlugin")
	if err != nil {
		return fmt.Errorf("failed to lookup symbol: %w", err)
	}

	// Type assert
	greeter, ok := symbol.(GreeterPlugin)
	if !ok {
		return fmt.Errorf("invalid plugin type")
	}

	// Initialize
	if err := greeter.Initialize(); err != nil {
		return fmt.Errorf("failed to initialize plugin: %w", err)
	}

	// Store the loaded plugin
	name := filepath.Base(path)
	pm.plugins[name] = &LoadedPlugin{
		Path:     path,
		Plugin:   p,
		LoadTime: time.Now(),
		Instance: greeter,
	}

	return nil
}

// GetPlugin retrieves a loaded plugin by name
func (pm *PluginManager) GetPlugin(name string) (GreeterPlugin, bool) {
	loaded, ok := pm.plugins[name]
	if !ok {
		return nil, false
	}
	return loaded.Instance, true
}

// ListPlugins returns all loaded plugin names
func (pm *PluginManager) ListPlugins() []string {
	names := make([]string, 0, len(pm.plugins))
	for name := range pm.plugins {
		names = append(names, name)
	}
	return names
}

// ShutdownAll shuts down all loaded plugins
func (pm *PluginManager) ShutdownAll() {
	for _, loaded := range pm.plugins {
		loaded.Instance.Shutdown()
	}
}

func main() {
	fmt.Println("Plugin Manager Demo")
	fmt.Println("===================\n")

	// Create plugin manager
	manager := NewPluginManager()
	defer manager.ShutdownAll()

	// This demonstrates the plugin manager API
	// In a real application, you would load actual .so files

	fmt.Println("Plugin Manager Features:")
	fmt.Println("  • Load plugins dynamically")
	fmt.Println("  • Track loaded plugins")
	fmt.Println("  • Retrieve plugins by name")
	fmt.Println("  • Graceful shutdown")
	fmt.Println()

	fmt.Println("Example Usage:")
	fmt.Println(`
	manager := NewPluginManager()
	
	// Load plugins
	manager.LoadPlugin("plugins/english.so")
	manager.LoadPlugin("plugins/spanish.so")
	
	// Use a plugin
	if greeter, ok := manager.GetPlugin("english.so"); ok {
		message := greeter.Greet("World")
		fmt.Println(message)
	}
	
	// List all plugins
	for _, name := range manager.ListPlugins() {
		fmt.Println("Loaded:", name)
	}
	
	// Shutdown all
	manager.ShutdownAll()
	`)

	fmt.Println("\nPlugin Discovery:")
	fmt.Println("  • Scan plugin directory")
	fmt.Println("  • Load plugins matching pattern")
	fmt.Println("  • Validate plugin interfaces")
	fmt.Println("  • Handle load failures gracefully")

	fmt.Println("\nBest Practices:")
	fmt.Println("  ✓ Define clear plugin interfaces")
	fmt.Println("  ✓ Version your plugin API")
	fmt.Println("  ✓ Handle plugin errors gracefully")
	fmt.Println("  ✓ Provide plugin metadata")
	fmt.Println("  ✓ Document plugin requirements")
}

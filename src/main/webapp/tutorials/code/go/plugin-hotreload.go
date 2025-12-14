package main

import (
	"fmt"
	"os"
	"plugin"
	"time"
)

// HotReloadManager manages hot-reloadable plugins
type HotReloadManager struct {
	pluginPath string
	plugin     *plugin.Plugin
	greeter    GreeterPlugin
	lastMod    time.Time
}

// NewHotReloadManager creates a new hot reload manager
func NewHotReloadManager(path string) *HotReloadManager {
	return &HotReloadManager{
		pluginPath: path,
	}
}

// Load loads or reloads the plugin
func (hrm *HotReloadManager) Load() error {
	// Check if file exists
	info, err := os.Stat(hrm.pluginPath)
	if err != nil {
		return fmt.Errorf("plugin file not found: %w", err)
	}

	// Check if plugin needs reloading
	if hrm.lastMod.Equal(info.ModTime()) {
		return nil // No changes
	}

	// Shutdown old plugin if exists
	if hrm.greeter != nil {
		hrm.greeter.Shutdown()
	}

	// Load new plugin
	p, err := plugin.Open(hrm.pluginPath)
	if err != nil {
		return fmt.Errorf("failed to load plugin: %w", err)
	}

	// Lookup symbol
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
		return fmt.Errorf("failed to initialize: %w", err)
	}

	// Update state
	hrm.plugin = p
	hrm.greeter = greeter
	hrm.lastMod = info.ModTime()

	fmt.Printf("Plugin loaded/reloaded at %s\n", time.Now().Format(time.RFC3339))

	return nil
}

// CheckAndReload checks for changes and reloads if needed
func (hrm *HotReloadManager) CheckAndReload() error {
	info, err := os.Stat(hrm.pluginPath)
	if err != nil {
		return err
	}

	if info.ModTime().After(hrm.lastMod) {
		fmt.Println("Plugin file changed, reloading...")
		return hrm.Load()
	}

	return nil
}

// GetGreeter returns the current greeter instance
func (hrm *HotReloadManager) GetGreeter() GreeterPlugin {
	return hrm.greeter
}

func main() {
	fmt.Println("Hot Reload Demo")
	fmt.Println("===============\n")

	fmt.Println("Hot Reload Concept:")
	fmt.Println("  1. Watch plugin file for changes")
	fmt.Println("  2. Detect modification time changes")
	fmt.Println("  3. Reload plugin when changed")
	fmt.Println("  4. Shutdown old instance")
	fmt.Println("  5. Initialize new instance")
	fmt.Println()

	fmt.Println("Example Implementation:")
	fmt.Println(`
	manager := NewHotReloadManager("plugin.so")
	
	// Initial load
	if err := manager.Load(); err != nil {
		log.Fatal(err)
	}
	
	// Watch for changes
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	
	for range ticker.C {
		// Check and reload if changed
		if err := manager.CheckAndReload(); err != nil {
			log.Println("Reload error:", err)
			continue
		}
		
		// Use the current plugin
		greeter := manager.GetGreeter()
		if greeter != nil {
			message := greeter.Greet("World")
			fmt.Println(message)
		}
	}
	`)

	fmt.Println("\nHot Reload Strategies:")
	fmt.Println()
	fmt.Println("1. File Watcher:")
	fmt.Println("   • Use fsnotify or similar")
	fmt.Println("   • React to file system events")
	fmt.Println("   • Immediate reload on change")
	fmt.Println()

	fmt.Println("2. Polling:")
	fmt.Println("   • Check modification time periodically")
	fmt.Println("   • Simple to implement")
	fmt.Println("   • Slight delay in detection")
	fmt.Println()

	fmt.Println("3. Signal-based:")
	fmt.Println("   • Reload on SIGHUP or custom signal")
	fmt.Println("   • Manual control")
	fmt.Println("   • Predictable timing")
	fmt.Println()

	fmt.Println("Challenges:")
	fmt.Println("  ⚠ Cannot unload old plugin from memory")
	fmt.Println("  ⚠ Must manage state transitions")
	fmt.Println("  ⚠ Handle in-flight requests")
	fmt.Println("  ⚠ Version compatibility")

	fmt.Println("\nUse Cases:")
	fmt.Println("  • Development hot-reload")
	fmt.Println("  • A/B testing")
	fmt.Println("  • Feature flags")
	fmt.Println("  • Dynamic configuration")
	fmt.Println("  • Plugin updates without downtime")
}

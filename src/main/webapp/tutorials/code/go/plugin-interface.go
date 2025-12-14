package main

// Plugin interface that all plugins must implement
type Greeter interface {
	Greet(name string) string
	Description() string
}

// Plugin metadata
type PluginInfo struct {
	Name    string
	Version string
	Author  string
}

// Base plugin interface
type Plugin interface {
	Info() PluginInfo
	Initialize() error
	Shutdown() error
}

// Example: Greeter plugin interface
type GreeterPlugin interface {
	Plugin
	Greeter
}

package main

import "fmt"

// EnglishGreeter implements the GreeterPlugin interface
type EnglishGreeter struct{}

func (g *EnglishGreeter) Info() PluginInfo {
	return PluginInfo{
		Name:    "English Greeter",
		Version: "1.0.0",
		Author:  "Example Author",
	}
}

func (g *EnglishGreeter) Initialize() error {
	fmt.Println("English Greeter plugin initialized")
	return nil
}

func (g *EnglishGreeter) Shutdown() error {
	fmt.Println("English Greeter plugin shutdown")
	return nil
}

func (g *EnglishGreeter) Greet(name string) string {
	return fmt.Sprintf("Hello, %s!", name)
}

func (g *EnglishGreeter) Description() string {
	return "Greets in English"
}

// SpanishGreeter implements the GreeterPlugin interface
type SpanishGreeter struct{}

func (g *SpanishGreeter) Info() PluginInfo {
	return PluginInfo{
		Name:    "Spanish Greeter",
		Version: "1.0.0",
		Author:  "Example Author",
	}
}

func (g *SpanishGreeter) Initialize() error {
	fmt.Println("Spanish Greeter plugin initialized")
	return nil
}

func (g *SpanishGreeter) Shutdown() error {
	fmt.Println("Spanish Greeter plugin shutdown")
	return nil
}

func (g *SpanishGreeter) Greet(name string) string {
	return fmt.Sprintf("¡Hola, %s!", name)
}

func (g *SpanishGreeter) Description() string {
	return "Greets in Spanish"
}

// Plugin symbol that will be looked up
var GreeterPlugin GreeterPlugin

func init() {
	// This would be set to either EnglishGreeter or SpanishGreeter
	// depending on which plugin is being built
	GreeterPlugin = &EnglishGreeter{}
}

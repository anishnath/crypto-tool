package main

import "fmt"

// Closure captures variable - causes escape
func closureCapture() func() int {
	x := 42
	return func() int {
		return x // x escapes: captured by closure
	}
}

// Closure modifies captured variable
func closureModify() func() {
	count := 0
	return func() {
		count++ // count escapes: modified by closure
		fmt.Println("Count:", count)
	}
}

// Multiple closures share variable
func sharedCapture() (func(), func()) {
	x := 0

	inc := func() {
		x++ // x escapes: shared between closures
	}

	print := func() {
		fmt.Println("X:", x)
	}

	return inc, print
}

// Closure in loop - common mistake
func closureInLoop() []func() {
	funcs := make([]func(), 3)

	for i := 0; i < 3; i++ {
		// ❌ Wrong - all closures share same i
		funcs[i] = func() {
			fmt.Println(i) // i escapes
		}
	}

	return funcs
}

// Closure in loop - fixed
func closureInLoopFixed() []func() {
	funcs := make([]func(), 3)

	for i := 0; i < 3; i++ {
		// ✅ Correct - each closure gets own copy
		i := i // Create new variable
		funcs[i] = func() {
			fmt.Println(i) // This i doesn't escape
		}
	}

	return funcs
}

// Goroutine with closure
func goroutineClosure() {
	x := 42

	go func() {
		fmt.Println("Goroutine:", x) // x escapes: used in goroutine
	}()
}

func main() {
	fmt.Println("Escape Analysis - Closures")
	fmt.Println("==========================\n")

	fmt.Println("1. Closure captures variable:")
	fn1 := closureCapture()
	fmt.Printf("   Closure result: %d\n\n", fn1())

	fmt.Println("2. Closure modifies variable:")
	fn2 := closureModify()
	fn2()
	fn2()
	fmt.Println()

	fmt.Println("3. Shared capture:")
	inc, print := sharedCapture()
	inc()
	inc()
	print()
	fmt.Println()

	fmt.Println("4. Closure in loop (wrong):")
	wrongFuncs := closureInLoop()
	for _, fn := range wrongFuncs {
		fn() // All print 3!
	}
	fmt.Println()

	fmt.Println("5. Closure in loop (fixed):")
	fixedFuncs := closureInLoopFixed()
	for _, fn := range fixedFuncs {
		fn() // Prints 0, 1, 2
	}
	fmt.Println()

	fmt.Println("6. Goroutine with closure:")
	goroutineClosure()
	fmt.Println("   Variable escaped for goroutine\n")

	fmt.Println("Closure escape rules:")
	fmt.Println("  • Captured variables escape to heap")
	fmt.Println("  • Shared between closure and parent")
	fmt.Println("  • Lifetime extends beyond function")

	fmt.Println("\nEscape analysis:")
	fmt.Println("  go build -gcflags='-m' escape-closures.go")
}

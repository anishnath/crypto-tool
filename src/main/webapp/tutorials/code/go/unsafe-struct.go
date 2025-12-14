package main

import (
	"fmt"
	"unsafe"
)

func main() {
	fmt.Println("Unsafe Struct Operations")
	fmt.Println("=========================\n")

	// Example 1: Field offsets
	fmt.Println("1. Struct field offsets:")

	type Person struct {
		Name   string
		Age    int
		Height float64
		Active bool
	}

	p := Person{}

	fmt.Printf("   Struct size: %d bytes\n", unsafe.Sizeof(p))
	fmt.Printf("   Name offset:   %d\n", unsafe.Offsetof(p.Name))
	fmt.Printf("   Age offset:    %d\n", unsafe.Offsetof(p.Age))
	fmt.Printf("   Height offset: %d\n", unsafe.Offsetof(p.Height))
	fmt.Printf("   Active offset: %d\n\n", unsafe.Offsetof(p.Active))

	// Example 2: Direct field access by offset
	fmt.Println("2. Access fields by offset:")

	person := Person{
		Name:   "Alice",
		Age:    30,
		Height: 5.6,
		Active: true,
	}

	fmt.Printf("   Original: %+v\n", person)

	// Access Age field using offset
	basePtr := unsafe.Pointer(&person)
	ageOffset := unsafe.Offsetof(person.Age)
	agePtr := (*int)(unsafe.Pointer(uintptr(basePtr) + ageOffset))

	fmt.Printf("   Age via offset: %d\n", *agePtr)

	// Modify via pointer
	*agePtr = 31
	fmt.Printf("   Modified: %+v\n\n", person)

	// Example 3: Struct field iteration
	fmt.Println("3. Iterate struct fields (conceptual):")

	type Point struct {
		X int
		Y int
		Z int
	}

	pt := Point{10, 20, 30}
	fmt.Printf("   Point: %+v\n", pt)

	// Access each int field
	ptPtr := unsafe.Pointer(&pt)
	for i := 0; i < 3; i++ {
		fieldPtr := (*int)(unsafe.Pointer(uintptr(ptPtr) + uintptr(i)*unsafe.Sizeof(pt.X)))
		fmt.Printf("   Field %d: %d\n", i, *fieldPtr)
	}
	fmt.Println()

	// Example 4: Packed vs unpacked structs
	fmt.Println("4. Struct packing:")

	type Unpacked struct {
		a bool  // 1 byte + 7 padding
		b int64 // 8 bytes
		c bool  // 1 byte + 7 padding
		d int64 // 8 bytes
	}

	type Packed struct {
		b int64 // 8 bytes
		d int64 // 8 bytes
		a bool  // 1 byte
		c bool  // 1 byte + 6 padding
	}

	fmt.Printf("   Unpacked size: %d bytes\n", unsafe.Sizeof(Unpacked{}))
	fmt.Printf("   Packed size:   %d bytes\n", unsafe.Sizeof(Packed{}))
	fmt.Printf("   Space saved:   %d bytes\n\n",
		unsafe.Sizeof(Unpacked{})-unsafe.Sizeof(Packed{}))

	// Example 5: Embedding and offsets
	fmt.Println("5. Embedded struct offsets:")

	type Address struct {
		Street string
		City   string
	}

	type Employee struct {
		Name    string
		Address // Embedded
		Salary  int
	}

	emp := Employee{}

	fmt.Printf("   Employee size: %d bytes\n", unsafe.Sizeof(emp))
	fmt.Printf("   Name offset:    %d\n", unsafe.Offsetof(emp.Name))
	fmt.Printf("   Address offset: %d\n", unsafe.Offsetof(emp.Address))
	fmt.Printf("   Street offset:  %d\n", unsafe.Offsetof(emp.Street))
	fmt.Printf("   City offset:    %d\n", unsafe.Offsetof(emp.City))
	fmt.Printf("   Salary offset:  %d\n\n", unsafe.Offsetof(emp.Salary))

	// Example 6: Zero-copy struct conversion
	fmt.Println("6. Struct type conversion:")

	type Point2D struct {
		X float64
		Y float64
	}

	type Vector2D struct {
		X float64
		Y float64
	}

	point := Point2D{3.0, 4.0}
	fmt.Printf("   Point2D: %+v\n", point)

	// Convert to Vector2D (same layout)
	vectorPtr := (*Vector2D)(unsafe.Pointer(&point))
	fmt.Printf("   As Vector2D: %+v\n", *vectorPtr)
	fmt.Printf("   ⚠️  Only safe if layouts match exactly!\n\n")

	fmt.Println("Struct Safety Rules:")
	fmt.Println("  ✓ Use Offsetof() for field access")
	fmt.Println("  ✓ Understand struct padding")
	fmt.Println("  ✓ Order fields by size (largest first)")
	fmt.Println("  ✓ Be careful with embedded structs")
	fmt.Println("  ✓ Only convert structs with identical layouts")
	fmt.Println("  ✓ Alignment matters!")
}

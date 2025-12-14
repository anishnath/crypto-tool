package main

import "fmt"

type Address struct {
	Street string
	City   string
	Zip    string
}

type Employee struct {
	Name    string
	Age     int
	Address Address  // Nested struct
}

// Embedded struct (composition)
type Manager struct {
	Employee        // Embedded
	Department string
}

func main() {
	// Nested struct
	emp := Employee{
		Name: "Alice",
		Age:  30,
		Address: Address{
			Street: "123 Main St",
			City:   "Boston",
			Zip:    "02101",
		},
	}
	
	fmt.Println("Employee:", emp)
	fmt.Println("City:", emp.Address.City)
	
	// Embedded struct
	mgr := Manager{
		Employee: Employee{
			Name: "Bob",
			Age:  35,
			Address: Address{
				Street: "456 Oak Ave",
				City:   "Seattle",
				Zip:    "98101",
			},
		},
		Department: "Engineering",
	}
	
	// Can access embedded fields directly
	fmt.Println("Manager:", mgr.Name)
	fmt.Println("Department:", mgr.Department)
}

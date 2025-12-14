package main

import (
	"encoding/json"
	"fmt"
)

type Person struct {
	Name string `json:"name"`
	Age  int    `json:"age"`
	City string `json:"city"`
}

func main() {
	// Marshal (Go -> JSON)
	p := Person{Name: "Alice", Age: 25, City: "NYC"}
	jsonData, _ := json.Marshal(p)
	fmt.Println("JSON:", string(jsonData))
	
	// Unmarshal (JSON -> Go)
	jsonStr := `{"name":"Bob","age":30,"city":"LA"}`
	var p2 Person
	json.Unmarshal([]byte(jsonStr), &p2)
	fmt.Printf("Person: %+v\n", p2)
}

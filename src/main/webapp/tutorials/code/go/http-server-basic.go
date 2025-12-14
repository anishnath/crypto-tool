package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, Go HTTP!")
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Server starting on :8080...")
	http.ListenAndServe(":8080", nil)
}

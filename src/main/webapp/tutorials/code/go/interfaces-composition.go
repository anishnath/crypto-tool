package main

import "fmt"

type Reader interface {
	Read() string
}

type Writer interface {
	Write(string)
}

// Composed interface
type ReadWriter interface {
	Reader
	Writer
}

type File struct {
	content string
}

func (f *File) Read() string {
	return f.content
}

func (f *File) Write(s string) {
	f.content = s
}

func main() {
	var rw ReadWriter = &File{}
	
	rw.Write("Hello, Go!")
	fmt.Println(rw.Read())
}

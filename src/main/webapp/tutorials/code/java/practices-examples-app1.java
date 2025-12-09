// Real-World Example: Simple Library Management System
package com.example.library;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents a book in the library system.
 */
class Book {
    private String isbn;
    private String title;
    private String author;
    private boolean isAvailable;
    
    public Book(String isbn, String title, String author) {
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.isAvailable = true;
    }
    
    public String getIsbn() { return isbn; }
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public boolean isAvailable() { return isAvailable; }
    
    public void setAvailable(boolean available) {
        this.isAvailable = available;
    }
    
    @Override
    public String toString() {
        return String.format("Book{ISBN='%s', Title='%s', Author='%s', Available=%s}", 
                           isbn, title, author, isAvailable);
    }
}

/**
 * Manages the library's book collection.
 */
class Library {
    private List<Book> books;
    
    public Library() {
        this.books = new ArrayList<>();
    }
    
    public void addBook(Book book) {
        books.add(book);
        System.out.println("Book added: " + book.getTitle());
    }
    
    public Book findBook(String isbn) {
        return books.stream()
                   .filter(b -> b.getIsbn().equals(isbn))
                   .findFirst()
                   .orElse(null);
    }
    
    public boolean borrowBook(String isbn) {
        Book book = findBook(isbn);
        if (book != null && book.isAvailable()) {
            book.setAvailable(false);
            System.out.println("Book borrowed: " + book.getTitle());
            return true;
        }
        System.out.println("Book not available: " + isbn);
        return false;
    }
    
    public boolean returnBook(String isbn) {
        Book book = findBook(isbn);
        if (book != null && !book.isAvailable()) {
            book.setAvailable(true);
            System.out.println("Book returned: " + book.getTitle());
            return true;
        }
        return false;
    }
    
    public void displayAllBooks() {
        System.out.println("\nAll Books:");
        books.forEach(System.out::println);
    }
}

/**
 * Main application demonstrating the library system.
 */
public class LibraryApp {
    public static void main(String[] args) {
        Library library = new Library();
        
        // Add books
        library.addBook(new Book("978-0134685991", "Effective Java", "Joshua Bloch"));
        library.addBook(new Book("978-0596009205", "Head First Java", "Kathy Sierra"));
        library.addBook(new Book("978-1617293566", "Java 8 in Action", "Raoul-Gabriel Urma"));
        
        // Display all books
        library.displayAllBooks();
        
        // Borrow a book
        library.borrowBook("978-0134685991");
        
        // Try to borrow same book again
        library.borrowBook("978-0134685991");
        
        // Return the book
        library.returnBook("978-0134685991");
        
        // Display status after operations
        library.displayAllBooks();
    }
}


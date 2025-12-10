fn main() {
    // Box<T> stores data on the heap
    let b = Box::new(5);
    println!("b = {}", b);

    // Box implements Deref, so we can use it like a reference
    let x = 5;
    let y = Box::new(x);

    assert_eq!(5, x);
    assert_eq!(5, *y);  // Dereference the Box

    // Box is useful for recursive types
    enum List {
        Cons(i32, Box<List>),
        Nil,
    }

    use List::{Cons, Nil};

    let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));
    println!("Created a recursive list");
}

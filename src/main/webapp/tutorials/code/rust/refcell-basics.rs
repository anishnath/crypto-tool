use std::cell::RefCell;

fn main() {
    // RefCell allows interior mutability
    let value = RefCell::new(5);

    // Borrow immutably
    {
        let borrowed = value.borrow();
        println!("Borrowed value: {}", *borrowed);
    }

    // Borrow mutably
    {
        let mut borrowed_mut = value.borrow_mut();
        *borrowed_mut += 10;
        println!("Modified value: {}", *borrowed_mut);
    }

    // Borrow again to see the change
    println!("Final value: {}", *value.borrow());

    // Multiple immutable borrows are OK
    let borrow1 = value.borrow();
    let borrow2 = value.borrow();
    println!("borrow1: {}, borrow2: {}", *borrow1, *borrow2);
}

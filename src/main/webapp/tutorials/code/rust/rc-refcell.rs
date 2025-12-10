use std::rc::Rc;
use std::cell::RefCell;

#[derive(Debug)]
struct Node {
    value: i32,
    children: RefCell<Vec<Rc<Node>>>,
}

fn main() {
    // Combining Rc and RefCell for shared mutable data
    let leaf = Rc::new(Node {
        value: 3,
        children: RefCell::new(vec![]),
    });

    let branch = Rc::new(Node {
        value: 5,
        children: RefCell::new(vec![Rc::clone(&leaf)]),
    });

    println!("leaf strong count: {}", Rc::strong_count(&leaf));
    println!("branch: {:?}", branch);

    // Modify the children through RefCell
    branch.children.borrow_mut().push(Rc::new(Node {
        value: 7,
        children: RefCell::new(vec![]),
    }));

    println!("Modified branch: {:?}", branch);
}

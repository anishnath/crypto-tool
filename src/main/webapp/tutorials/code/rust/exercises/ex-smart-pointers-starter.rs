// Exercise: Implement a simple graph structure using Rc and RefCell
// TODO: Complete the implementation

use std::rc::Rc;
use std::cell::RefCell;

#[derive(Debug)]
struct Node {
    value: i32,
    // TODO: Add a field for storing neighbors using Rc and RefCell
    // neighbors: ...
}

impl Node {
    fn new(value: i32) -> Rc<RefCell<Node>> {
        // TODO: Create a new node wrapped in Rc<RefCell<>>
        todo!()
    }

    fn add_neighbor(&mut self, neighbor: Rc<RefCell<Node>>) {
        // TODO: Add a neighbor to this node
        todo!()
    }
}

fn main() {
    // Create three nodes
    let node1 = Node::new(1);
    let node2 = Node::new(2);
    let node3 = Node::new(3);

    // TODO: Connect the nodes
    // node1 -> node2
    // node2 -> node3
    // node3 -> node1 (create a cycle)

    println!("Graph created with cycles using Rc and RefCell!");
}

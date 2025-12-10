fn main() {
    // Define an enum
    enum IpAddrKind {
        V4,
        V6,
    }
    
    // Create enum values
    let four = IpAddrKind::V4;
    let six = IpAddrKind::V6;
    
    // Enums with data
    enum IpAddr {
        V4(u8, u8, u8, u8),
        V6(String),
    }
    
    let home = IpAddr::V4(127, 0, 0, 1);
    let loopback = IpAddr::V6(String::from("::1"));
    
    // Enum with different types
    enum Message {
        Quit,                       // No data
        Move { x: i32, y: i32 },   // Named fields
        Write(String),              // Single String
        ChangeColor(i32, i32, i32), // Three i32s
    }
    
    let msg1 = Message::Quit;
    let msg2 = Message::Move { x: 10, y: 20 };
    let msg3 = Message::Write(String::from("hello"));
    let msg4 = Message::ChangeColor(255, 0, 0);
    
    // Match on enums
    match msg2 {
        Message::Quit => println!("Quit"),
        Message::Move { x, y } => println!("Move to ({}, {})", x, y),
        Message::Write(text) => println!("Write: {}", text),
        Message::ChangeColor(r, g, b) => println!("Color: ({}, {}, {})", r, g, b),
    }
}

// Enums can have methods too!
enum TrafficLight {
    Red,
    Yellow,
    Green,
}

impl TrafficLight {
    fn time(&self) -> u32 {
        match self {
            TrafficLight::Red => 60,
            TrafficLight::Yellow => 3,
            TrafficLight::Green => 45,
        }
    }
}

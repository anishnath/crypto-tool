fn main() {
    // Integer types
    let decimal = 98_222;
    let hex = 0xff;
    let octal = 0o77;
    let binary = 0b1111_0000;
    let byte = b'A';  // u8 only
    
    println!("Decimal: {}", decimal);
    println!("Hex: {}", hex);
    println!("Octal: {}", octal);
    println!("Binary: {}", binary);
    println!("Byte: {}", byte);
    
    // Floating point
    let x = 2.0;      // f64 (default)
    let y: f32 = 3.0; // f32
    
    println!("x = {}, y = {}", x, y);
    
    // Boolean
    let t = true;
    let f: bool = false;
    
    println!("t = {}, f = {}", t, f);
    
    // Character (4 bytes, Unicode)
    let c = 'z';
    let z = 'ℤ';
    let heart = '❤';
    
    println!("Characters: {}, {}, {}", c, z, heart);
}

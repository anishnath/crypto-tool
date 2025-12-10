// Abstract Classes

abstract class Shape {
    constructor(public color: string) {}
    
    // Abstract method - must be implemented by child classes
    abstract calculateArea(): number;
    
    // Concrete method - can be used by all children
    describe(): string {
        return `A ${this.color} shape with area ${this.calculateArea()}`;
    }
}

class Circle extends Shape {
    constructor(color: string, public radius: number) {
        super(color);
    }
    
    calculateArea(): number {
        return Math.PI * this.radius * this.radius;
    }
}

class Rectangle extends Shape {
    constructor(color: string, public width: number, public height: number) {
        super(color);
    }
    
    calculateArea(): number {
        return this.width * this.height;
    }
}

let circle = new Circle("red", 5);
let rectangle = new Rectangle("blue", 10, 5);

console.log(circle.describe());
console.log(rectangle.describe());

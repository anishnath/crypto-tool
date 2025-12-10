// Static Members

class MathUtils {
    static PI: number = 3.14159;
    
    static square(x: number): number {
        return x * x;
    }
    
    static circleArea(radius: number): number {
        return this.PI * this.square(radius);
    }
}

// Use without creating instance
console.log("PI:", MathUtils.PI);
console.log("Square of 5:", MathUtils.square(5));
console.log("Circle area:", MathUtils.circleArea(10));

class Counter {
    static count: number = 0;
    
    constructor(public instanceName: string) {
        Counter.count++;  // Increment static counter
    }
    
    static getCount(): number {
        return Counter.count;
    }
}

let c1 = new Counter("first");
let c2 = new Counter("second");
let c3 = new Counter("third");
console.log("Total instances:", Counter.getCount());

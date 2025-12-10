// Properties and Methods

class Calculator {
    result: number = 0;  // Property with initial value
    
    add(value: number): void {
        this.result += value;
    }
    
    subtract(value: number): void {
        this.result -= value;
    }
    
    getResult(): number {
        return this.result;
    }
    
    reset(): void {
        this.result = 0;
    }
}

let calc = new Calculator();
calc.add(10);
calc.add(5);
console.log("Result:", calc.getResult());
calc.reset();

// Namespaces

namespace Utilities {
    export function formatDate(date: Date): string {
        return date.toISOString().split('T')[0];
    }
    
    export function capitalize(str: string): string {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }
    
    export namespace Math {
        export function add(a: number, b: number): number {
            return a + b;
        }
        
        export function multiply(a: number, b: number): number {
            return a * b;
        }
    }
}

// Usage
let formattedDate = Utilities.formatDate(new Date());
let capitalizedText = Utilities.capitalize("hello");
let sum = Utilities.Math.add(5, 3);

console.log(formattedDate, capitalizedText, sum);

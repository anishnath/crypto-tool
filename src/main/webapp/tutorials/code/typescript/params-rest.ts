// Rest Parameters (variable number of arguments)

function sum(...numbers: number[]): number {
    return numbers.reduce((total, n) => total + n, 0);
}

console.log("Sum of 1,2,3:", sum(1, 2, 3));
console.log("Sum of 1,2,3,4,5:", sum(1, 2, 3, 4, 5));

function buildName(firstName: string, ...restOfName: string[]): string {
    return firstName + " " + restOfName.join(" ");
}

console.log(buildName("John", "Q", "Public"));

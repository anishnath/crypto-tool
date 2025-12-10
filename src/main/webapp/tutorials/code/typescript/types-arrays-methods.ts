// Array Methods with Type Safety

let numbers: number[] = [1, 2, 3, 4, 5];

// push - add to end
numbers.push(6);
console.log("After push:", numbers);

// pop - remove from end
let last = numbers.pop();
console.log("Popped:", last, "Array:", numbers);

// map - transform each element
let doubled = numbers.map(n => n * 2);
console.log("Doubled:", doubled);

// filter - keep elements that match condition
let evens = numbers.filter(n => n % 2 === 0);
console.log("Evens:", evens);

// indexOf - find position of element
let position = numbers.indexOf(4);
console.log("Position of 4:", position);

// reduce - combine into single value
let sum = numbers.reduce((acc, n) => acc + n, 0);
console.log("Sum:", sum);

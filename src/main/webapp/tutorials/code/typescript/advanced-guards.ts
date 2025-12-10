// Type Guards

function isString(value: unknown): value is string {
    return typeof value === "string";
}

function isNumber(value: unknown): value is number {
    return typeof value === "number";
}

function processValue(value: string | number) {
    if (isString(value)) {
        console.log("String:", value.toUpperCase());
    } else if (isNumber(value)) {
        console.log("Number:", value.toFixed(2));
    }
}

processValue("hello");
processValue(42.5);

// instanceof guard
class Dog {
    bark() { console.log("Woof!"); }
}

class Cat {
    meow() { console.log("Meow!"); }
}

function makeSound(animal: Dog | Cat) {
    if (animal instanceof Dog) {
        animal.bark();
    } else {
        animal.meow();
    }
}

makeSound(new Dog());
makeSound(new Cat());

// Extending Interfaces

interface Animal {
    nameAnimal: string;
}

interface Dog extends Animal {
    breed: string;
}

let myDog: Dog = {
    nameAnimal: "Buddy",
    breed: "Golden Retriever"
};

console.log(myDog);

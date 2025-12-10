// Indexed Access Types

interface Product {
    id: number;
    productName: string;
    price: number;
    details: {
        description: string;
        weight: number;
    };
}

// Access specific property type
type ProductName = Product["productName"];  // string
type ProductPrice = Product["price"];  // number

// Access nested property type
type ProductDetails = Product["details"];
// Type: { description: string; weight: number }

type Description = Product["details"]["description"];  // string

// Access multiple properties
type ProductInfo = Product["productName" | "price"];
// Type: string | number

console.log("Indexed access types demonstrated");

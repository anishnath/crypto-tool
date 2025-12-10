// Utility Types: Pick & Omit

interface Product {
    id: number;
    productName: string;
    price: number;
    description: string;
    stock: number;
}

// Pick - select specific properties
type ProductPreview = Pick<Product, "id" | "productName" | "price">;

let preview: ProductPreview = {
    id: 1,
    productName: "Laptop",
    price: 999
};

console.log(preview);

// Omit - exclude specific properties
type ProductWithoutStock = Omit<Product, "stock">;

let product: ProductWithoutStock = {
    id: 1,
    productName: "Laptop",
    price: 999,
    description: "High-performance laptop"
};

console.log(product);

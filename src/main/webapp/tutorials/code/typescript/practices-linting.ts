// Linting & Formatting with ESLint and Prettier

// .eslintrc.json configuration:
// {
//   "parser": "@typescript-eslint/parser",
//   "plugins": ["@typescript-eslint"],
//   "extends": [
//     "eslint:recommended",
//     "plugin:@typescript-eslint/recommended"
//   ],
//   "rules": {
//     "no-console": "warn",
//     "@typescript-eslint/explicit-function-return-type": "error"
//   }
// }

// Good practices
export function calculateTotal(items: number[]): number {
    return items.reduce((sum, item) => sum + item, 0);
}

export class DataProcessor {
    private data: string[];
    
    constructor(data: string[]) {
        this.data = data;
    }
    
    public process(): string[] {
        return this.data.map(item => item.trim().toLowerCase());
    }
}

console.log("Linting demonstrated");

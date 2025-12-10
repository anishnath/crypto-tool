// Error Handling in TypeScript

class ValidationError extends Error {
    constructor(message: string) {
        super(message);
        this.name = "ValidationError";
    }
}

class NetworkError extends Error {
    statusCode: number;
    
    constructor(message: string, statusCode: number) {
        super(message);
        this.name = "NetworkError";
        this.statusCode = statusCode;
    }
}

function validateEmail(email: string): void {
    if (!email.includes("@")) {
        throw new ValidationError("Invalid email format");
    }
}

async function fetchData(url: string): Promise<any> {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new NetworkError("Request failed", response.status);
        }
        return await response.json();
    } catch (error) {
        if (error instanceof NetworkError) {
            console.error(`Network error (${error.statusCode}):`, error.message);
        } else if (error instanceof ValidationError) {
            console.error("Validation error:", error.message);
        } else {
            console.error("Unknown error:", error);
        }
        throw error;
    }
}

console.log("Error handling demonstrated");

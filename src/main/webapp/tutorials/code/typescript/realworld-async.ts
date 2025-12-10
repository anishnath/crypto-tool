// Async/Await with TypeScript

interface UserData {
    id: number;
    userName: string;
    email: string;
}

// Async function with typed return
async function fetchUser(id: number): Promise<UserData> {
    const response = await fetch(`https://api.example.com/users/${id}`);
    const data: UserData = await response.json();
    return data;
}

// Error handling with async/await
async function getUserSafely(id: number): Promise<UserData | null> {
    try {
        const userData = await fetchUser(id);
        return userData;
    } catch (error) {
        console.error("Failed to fetch user:", error);
        return null;
    }
}

// Multiple async operations
async function fetchMultipleUsers(ids: number[]): Promise<UserData[]> {
    const promises = ids.map(id => fetchUser(id));
    return Promise.all(promises);
}

console.log("Async/await demonstrated");

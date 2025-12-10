// Testing TypeScript with Jest

// Example test file: user.test.ts

interface User {
    id: number;
    userName: string;
    isActive: boolean;
}

export function createUser(userName: string): User {
    return {
        id: Math.random(),
        userName,
        isActive: true
    };
}

export function deactivateUser(user: User): User {
    return { ...user, isActive: false };
}

// Test examples (would be in .test.ts file):
// describe('User functions', () => {
//   test('createUser creates active user', () => {
//     const user = createUser('Alice');
//     expect(user.isActive).toBe(true);
//     expect(user.userName).toBe('Alice');
//   });
//
//   test('deactivateUser sets isActive to false', () => {
//     const user = createUser('Bob');
//     const deactivated = deactivateUser(user);
//     expect(deactivated.isActive).toBe(false);
//   });
// });

console.log("Testing demonstrated");

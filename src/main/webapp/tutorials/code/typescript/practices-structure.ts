// Project Structure Best Practices

// Organize by feature
// src/
//   features/
//     auth/
//       auth.service.ts
//       auth.types.ts
//     users/
//       user.service.ts
//       user.types.ts
//   shared/
//     utils/
//     types/
//   config/

// Example types organization
export interface AppConfig {
    apiUrl: string;
    timeout: number;
    debug: boolean;
}

export const config: AppConfig = {
    apiUrl: process.env.API_URL || "https://api.example.com",
    timeout: 5000,
    debug: process.env.NODE_ENV === "development"
};

// Barrel exports (index.ts)
export * from './config';
export { default as Logger } from './logger';

console.log("Project structure demonstrated");

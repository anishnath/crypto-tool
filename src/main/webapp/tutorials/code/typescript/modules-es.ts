// ES Modules - Export and Import

// Named exports
export const API_URL = "https://api.example.com";
export const TIMEOUT = 5000;

export function fetchData(url: string): Promise<any> {
    return fetch(url).then(res => res.json());
}

export class ApiClient {
    baseUrl: string;
    
    constructor(baseUrl: string) {
        this.baseUrl = baseUrl;
    }
    
    get(endpoint: string) {
        return fetchData(`${this.baseUrl}/${endpoint}`);
    }
}

// Default export
export default class Logger {
    log(message: string) {
        console.log(`[LOG] ${message}`);
    }
}

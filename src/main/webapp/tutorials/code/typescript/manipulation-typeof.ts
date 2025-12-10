// typeof Operator

let userConfig = {
    theme: "dark",
    fontSize: 14,
    autoSave: true
};

// typeof captures the type
type Config = typeof userConfig;
// Type: { theme: string; fontSize: number; autoSave: boolean }

function applyConfig(config: Config) {
    console.log("Theme:", config.theme);
    console.log("Font size:", config.fontSize);
}

applyConfig(userConfig);

// typeof with functions
function greet(userName: string) {
    return `Hello, ${userName}!`;
}

type GreetFunction = typeof greet;
// Type: (userName: string) => string

let myGreet: GreetFunction = (userName) => `Hi, ${userName}!`;
console.log(myGreet("Bob"));

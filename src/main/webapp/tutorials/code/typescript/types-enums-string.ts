// String Enums

enum Color {
    Red = "RED",
    Green = "GREEN",
    Blue = "BLUE"
}

console.log("Red:", Color.Red);
console.log("Green:", Color.Green);

// More readable and debuggable
enum LogLevel {
    Error = "ERROR",
    Warning = "WARNING",
    Info = "INFO",
    Debug = "DEBUG"
}

function log(level: LogLevel, message: string) {
    console.log(`[${level}] ${message}`);
}

log(LogLevel.Info, "Application started");
log(LogLevel.Warning, "Low memory");

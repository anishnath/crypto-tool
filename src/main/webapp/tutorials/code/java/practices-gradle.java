// Gradle Project Structure Example
/*
Gradle Project Layout:
project-root/
├── build.gradle           # Build configuration (Groovy or Kotlin DSL)
├── settings.gradle        # Project settings
├── src/
│   ├── main/
│   │   ├── java/         # Source code
│   │   │   └── com/example/MyApp.java
│   │   └── resources/    # Configuration files
│   └── test/
│       └── java/         # Test code
│           └── com/example/MyAppTest.java
└── build/                # Compiled classes (generated)
*/

// Example build.gradle (shown as comment):
/*
plugins {
    id 'java'
}

group = 'com.example'
version = '1.0-SNAPSHOT'

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'junit:junit:4.13.2'
}
*/

// Gradle commands:
// ./gradlew build      - Builds the project
// ./gradlew test       - Runs tests
// ./gradlew clean      - Cleans build directory
// ./gradlew run        - Runs the application
// ./gradlew jar        - Creates JAR file

public class GradleExample {
    public static void main(String[] args) {
        System.out.println("Gradle uses Groovy/Kotlin DSL for build scripts");
        System.out.println("Use 'gradle build' to build the project");
        System.out.println("Use 'gradle test' to run unit tests");
    }
}


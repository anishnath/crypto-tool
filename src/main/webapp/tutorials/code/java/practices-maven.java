// Maven Project Structure Example
/*
Maven Project Layout:
project-root/
├── pom.xml                 # Project Object Model (configuration file)
├── src/
│   ├── main/
│   │   ├── java/          # Source code
│   │   │   └── com/example/MyApp.java
│   │   └── resources/     # Configuration files
│   └── test/
│       └── java/          # Test code
│           └── com/example/MyAppTest.java
└── target/                # Compiled classes (generated)
*/

// Example pom.xml structure (shown as comment):
/*
<?xml version="1.0" encoding="UTF-8"?>
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0-SNAPSHOT</version>
    
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
*/

// Maven commands:
// mvn compile     - Compiles source code
// mvn test        - Runs tests
// mvn package     - Creates JAR file
// mvn clean       - Deletes target directory
// mvn install     - Installs to local repository

public class MavenExample {
    public static void main(String[] args) {
        System.out.println("Maven manages project structure and dependencies");
        System.out.println("Use 'mvn compile' to build the project");
        System.out.println("Use 'mvn test' to run unit tests");
    }
}


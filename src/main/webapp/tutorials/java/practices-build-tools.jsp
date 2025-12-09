<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "practices-build-tools" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Java Build Tools (Maven/Gradle) - Java Tutorial | 8gwifi.org</title>
            <meta name="description" content="Learn about Maven and Gradle build tools.">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>
                (function () {
                    var theme = localStorage.getItem('tutorial-theme');
                    if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                        document.documentElement.setAttribute('data-theme', 'dark');
                    }
                })();
            </script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="practices-build-tools">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-java.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/java/">Java</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Build Tools</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Build Tools: Maven and Gradle</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>
                                <div class="lesson-body">
                                    <p class="lead">Build tools automate compilation, testing, packaging, and dependency
                                        management. Maven and Gradle are the two dominant build tools in the Java ecosystem.</p>

                                    <h2>Maven vs Gradle</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Maven</th>
                                                <th>Gradle</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Config Format</td>
                                                <td>XML (<code>pom.xml</code>)</td>
                                                <td>Groovy/Kotlin (<code>build.gradle</code>)</td>
                                            </tr>
                                            <tr>
                                                <td>Build Speed</td>
                                                <td>Slower</td>
                                                <td>Faster (incremental builds)</td>
                                            </tr>
                                            <tr>
                                                <td>Learning Curve</td>
                                                <td>Easier (convention)</td>
                                                <td>Steeper (more flexible)</td>
                                            </tr>
                                            <tr>
                                                <td>Flexibility</td>
                                                <td>Convention over config</td>
                                                <td>Highly customizable</td>
                                            </tr>
                                            <tr>
                                                <td>IDE Support</td>
                                                <td>Excellent</td>
                                                <td>Excellent</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Maven</h2>
                                    <p>Maven uses <code>pom.xml</code> (Project Object Model) for configuration.</p>

                                    <h3>Project Structure</h3>
                                    <pre><code>my-project/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/          # Application source code
│   │   └── resources/     # Config files, properties
│   └── test/
│       ├── java/          # Test source code
│       └── resources/     # Test resources
└── target/                # Compiled output (generated)</code></pre>

                                    <h3>Basic pom.xml</h3>
                                    <pre><code class="language-xml">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd"&gt;

    &lt;modelVersion&gt;4.0.0&lt;/modelVersion&gt;

    &lt;!-- Project coordinates --&gt;
    &lt;groupId&gt;com.example&lt;/groupId&gt;
    &lt;artifactId&gt;my-app&lt;/artifactId&gt;
    &lt;version&gt;1.0.0&lt;/version&gt;
    &lt;packaging&gt;jar&lt;/packaging&gt;

    &lt;properties&gt;
        &lt;maven.compiler.source&gt;17&lt;/maven.compiler.source&gt;
        &lt;maven.compiler.target&gt;17&lt;/maven.compiler.target&gt;
        &lt;project.build.sourceEncoding&gt;UTF-8&lt;/project.build.sourceEncoding&gt;
    &lt;/properties&gt;

    &lt;dependencies&gt;
        &lt;!-- JUnit 5 for testing --&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.junit.jupiter&lt;/groupId&gt;
            &lt;artifactId&gt;junit-jupiter&lt;/artifactId&gt;
            &lt;version&gt;5.10.0&lt;/version&gt;
            &lt;scope&gt;test&lt;/scope&gt;
        &lt;/dependency&gt;

        &lt;!-- SLF4J for logging --&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.slf4j&lt;/groupId&gt;
            &lt;artifactId&gt;slf4j-api&lt;/artifactId&gt;
            &lt;version&gt;2.0.9&lt;/version&gt;
        &lt;/dependency&gt;
    &lt;/dependencies&gt;
&lt;/project&gt;</code></pre>

                                    <h3>Common Maven Commands</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Command</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>mvn clean</code></td>
                                                <td>Delete target directory</td>
                                            </tr>
                                            <tr>
                                                <td><code>mvn compile</code></td>
                                                <td>Compile source code</td>
                                            </tr>
                                            <tr>
                                                <td><code>mvn test</code></td>
                                                <td>Run unit tests</td>
                                            </tr>
                                            <tr>
                                                <td><code>mvn package</code></td>
                                                <td>Create JAR/WAR file</td>
                                            </tr>
                                            <tr>
                                                <td><code>mvn install</code></td>
                                                <td>Install to local repository</td>
                                            </tr>
                                            <tr>
                                                <td><code>mvn clean install</code></td>
                                                <td>Clean, compile, test, and install</td>
                                            </tr>
                                            <tr>
                                                <td><code>mvn dependency:tree</code></td>
                                                <td>Show dependency hierarchy</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Dependency Scopes</h3>
                                    <pre><code class="language-xml">&lt;!-- compile (default): Available everywhere --&gt;
&lt;dependency&gt;
    &lt;groupId&gt;com.google.guava&lt;/groupId&gt;
    &lt;artifactId&gt;guava&lt;/artifactId&gt;
    &lt;version&gt;32.1.2-jre&lt;/version&gt;
&lt;/dependency&gt;

&lt;!-- provided: Available at compile, not packaged (e.g., servlet API) --&gt;
&lt;dependency&gt;
    &lt;groupId&gt;javax.servlet&lt;/groupId&gt;
    &lt;artifactId&gt;javax.servlet-api&lt;/artifactId&gt;
    &lt;version&gt;4.0.1&lt;/version&gt;
    &lt;scope&gt;provided&lt;/scope&gt;
&lt;/dependency&gt;

&lt;!-- test: Only for testing --&gt;
&lt;dependency&gt;
    &lt;groupId&gt;org.junit.jupiter&lt;/groupId&gt;
    &lt;artifactId&gt;junit-jupiter&lt;/artifactId&gt;
    &lt;version&gt;5.10.0&lt;/version&gt;
    &lt;scope&gt;test&lt;/scope&gt;
&lt;/dependency&gt;

&lt;!-- runtime: Not needed for compilation, only at runtime --&gt;
&lt;dependency&gt;
    &lt;groupId&gt;mysql&lt;/groupId&gt;
    &lt;artifactId&gt;mysql-connector-java&lt;/artifactId&gt;
    &lt;version&gt;8.0.33&lt;/version&gt;
    &lt;scope&gt;runtime&lt;/scope&gt;
&lt;/dependency&gt;</code></pre>

                                    <h2>Gradle</h2>
                                    <p>Gradle uses Groovy or Kotlin DSL for configuration.</p>

                                    <h3>Basic build.gradle</h3>
                                    <pre><code class="language-groovy">plugins {
    id 'java'
    id 'application'
}

group = 'com.example'
version = '1.0.0'

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

repositories {
    mavenCentral()
}

dependencies {
    // Implementation dependencies
    implementation 'com.google.guava:guava:32.1.2-jre'
    implementation 'org.slf4j:slf4j-api:2.0.9'

    // Test dependencies
    testImplementation 'org.junit.jupiter:junit-jupiter:5.10.0'
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
}

application {
    mainClass = 'com.example.Main'
}

test {
    useJUnitPlatform()
}</code></pre>

                                    <h3>Common Gradle Commands</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Command</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>./gradlew build</code></td>
                                                <td>Compile, test, and package</td>
                                            </tr>
                                            <tr>
                                                <td><code>./gradlew clean</code></td>
                                                <td>Delete build directory</td>
                                            </tr>
                                            <tr>
                                                <td><code>./gradlew test</code></td>
                                                <td>Run unit tests</td>
                                            </tr>
                                            <tr>
                                                <td><code>./gradlew run</code></td>
                                                <td>Run the application</td>
                                            </tr>
                                            <tr>
                                                <td><code>./gradlew dependencies</code></td>
                                                <td>Show dependency tree</td>
                                            </tr>
                                            <tr>
                                                <td><code>./gradlew tasks</code></td>
                                                <td>List available tasks</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>Gradle Wrapper:</strong> Always use <code>./gradlew</code> (or <code>gradlew.bat</code>
                                        on Windows) instead of <code>gradle</code>. The wrapper ensures everyone uses the same
                                        Gradle version.
                                    </div>

                                    <h2>Creating Executable JARs</h2>

                                    <h3>Maven (with shade plugin)</h3>
                                    <pre><code class="language-xml">&lt;build&gt;
    &lt;plugins&gt;
        &lt;plugin&gt;
            &lt;groupId&gt;org.apache.maven.plugins&lt;/groupId&gt;
            &lt;artifactId&gt;maven-shade-plugin&lt;/artifactId&gt;
            &lt;version&gt;3.5.0&lt;/version&gt;
            &lt;executions&gt;
                &lt;execution&gt;
                    &lt;phase&gt;package&lt;/phase&gt;
                    &lt;goals&gt;&lt;goal&gt;shade&lt;/goal&gt;&lt;/goals&gt;
                    &lt;configuration&gt;
                        &lt;transformers&gt;
                            &lt;transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer"&gt;
                                &lt;mainClass&gt;com.example.Main&lt;/mainClass&gt;
                            &lt;/transformer&gt;
                        &lt;/transformers&gt;
                    &lt;/configuration&gt;
                &lt;/execution&gt;
            &lt;/executions&gt;
        &lt;/plugin&gt;
    &lt;/plugins&gt;
&lt;/build&gt;</code></pre>

                                    <h3>Gradle (fat JAR)</h3>
                                    <pre><code class="language-groovy">jar {
    manifest {
        attributes 'Main-Class': 'com.example.Main'
    }
    // Include all dependencies in the JAR
    from {
        configurations.runtimeClasspath.collect { it.isDirectory() ? it : zipTree(it) }
    }
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}</code></pre>

                                    <h2>Multi-Module Projects</h2>

                                    <h3>Maven Parent POM</h3>
                                    <pre><code class="language-xml">&lt;!-- parent/pom.xml --&gt;
&lt;project&gt;
    &lt;groupId&gt;com.example&lt;/groupId&gt;
    &lt;artifactId&gt;parent&lt;/artifactId&gt;
    &lt;version&gt;1.0.0&lt;/version&gt;
    &lt;packaging&gt;pom&lt;/packaging&gt;

    &lt;modules&gt;
        &lt;module&gt;core&lt;/module&gt;
        &lt;module&gt;web&lt;/module&gt;
        &lt;module&gt;api&lt;/module&gt;
    &lt;/modules&gt;

    &lt;dependencyManagement&gt;
        &lt;dependencies&gt;
            &lt;!-- Version managed here, used in children --&gt;
            &lt;dependency&gt;
                &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
                &lt;artifactId&gt;spring-boot-dependencies&lt;/artifactId&gt;
                &lt;version&gt;3.1.5&lt;/version&gt;
                &lt;type&gt;pom&lt;/type&gt;
                &lt;scope&gt;import&lt;/scope&gt;
            &lt;/dependency&gt;
        &lt;/dependencies&gt;
    &lt;/dependencyManagement&gt;
&lt;/project&gt;</code></pre>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Maven:</strong> Convention-based, XML config, great for standard projects</li>
                                            <li><strong>Gradle:</strong> Flexible, faster builds, Groovy/Kotlin DSL</li>
                                            <li>Use <strong>dependency scopes</strong> to control classpath</li>
                                            <li>Use the <strong>Gradle Wrapper</strong> for consistent builds</li>
                                            <li><strong>Shade/Fat JARs</strong> bundle dependencies for deployment</li>
                                            <li><strong>Multi-module</strong> projects share configuration via parent</li>
                                        </ul>
                                    </div>
                                </div>
                                <% String prevLinkUrl=request.getContextPath()
                                    + "/tutorials/java/practices-best-practices.jsp" ; String
                                    nextLinkUrl=request.getContextPath() + "/tutorials/java/practices-logging.jsp" ; %>
                                    <jsp:include page="../tutorial-nav.jsp">
                                        <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                        <jsp:param name="prevTitle" value="← Best Practices" />
                                        <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                        <jsp:param name="nextTitle" value="Logging →" />
                                    <jsp:param name="currentLessonId" value="practices-build-tools" />
                                    </jsp:include>
                            </article>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>
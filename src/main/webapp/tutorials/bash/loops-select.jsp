<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-select");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash Select Menus - Interactive Menu Loops | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash select loops for creating interactive menus. Master PS3 prompt, case statements with select, and building user-friendly CLI interfaces.">
    <meta name="keywords"
        content="bash select, bash menu, bash interactive menu, bash PS3, bash select loop, shell scripting menu">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash Select Menus - Interactive Menu Loops">
    <meta property="og:description" content="Master select loops for creating interactive menu systems in Bash.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/loops-select.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Bash Select Menus",
        "description": "Learn Bash select loops for creating interactive menu systems and user-friendly CLI interfaces.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Select loop syntax", "PS3 prompt", "Interactive menus", "Case statements with select", "Menu loops"],
        "timeRequired": "PT15M",
        "isPartOf": {
            "@type": "Course",
            "name": "Bash Tutorial",
            "url": "https://8gwifi.org/tutorials/bash/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="loops-select">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-bash.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/bash/">Bash</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Select Menus</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Select Menus</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Select loops create interactive menu systems that display numbered options and prompt users to make a choice. They're perfect for building user-friendly command-line interfaces, installation scripts, configuration tools, and any interactive Bash program. Select loops automatically handle menu display and user input, making them much simpler than manually coding menus with echo and read!</p>

                    <!-- Section 1: Basic Select Loop -->
                    <h2>Basic Select Loop</h2>
                    <p>A select loop automatically displays a numbered menu and prompts the user to choose. The syntax is similar to a for loop, but select creates an interactive menu.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/loops-select.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-select" />
                    </jsp:include>

                    <pre><code class="language-bash"># Basic select syntax
select variable in item1 item2 item3; do
    # code to handle selection
    break  # Usually break after handling
done

# Example
PS3="Choose an option: "
select choice in "Option 1" "Option 2" "Option 3" "Quit"; do
    echo "You chose: $choice"
    break
done

# Output:
# 1) Option 1
# 2) Option 2
# 3) Option 3
# 4) Quit
# Choose an option: _</code></pre>

                    <div class="info-box">
                        <strong>How Select Works:</strong><br>
                        - Automatically displays numbered menu (1), 2), 3)...)<br>
                        - Stores selected item in variable<br>
                        - Stores selected number in <code>REPLY</code> variable<br>
                        - Prompts user with <code>PS3</code> (default: "#? ")<br>
                        - Loop continues until <code>break</code> is used
                    </div>

                    <!-- Section 2: PS3 Prompt -->
                    <h2>Customizing the Prompt with PS3</h2>
                    <p>The <code>PS3</code> variable controls the prompt text displayed when select is waiting for user input. Set it before your select statement.</p>

                    <pre><code class="language-bash"># Default PS3 is "#? "
select item in a b c; do
    break
done
# Prompt: #? 

# Custom PS3
PS3="Please choose (1-3): "
select item in "Start" "Stop" "Restart"; do
    break
done
# Prompt: Please choose (1-3): 

# More descriptive prompt
PS3="Select an option [1-4]: "
options=("Install" "Uninstall" "Update" "Exit")
select opt in "\${options[@]}"; do
    break
done</code></pre>

                    <div class="tip-box">
                        <strong>PS3 Tips:</strong><br>
                        - Set <code>PS3</code> before the select statement<br>
                        - Make prompts clear and indicate valid range<br>
                        - Consider including example: <code>"Choose [1-4]: "</code>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Using Select with Case Statements -->
                    <h2>Using Select with Case Statements</h2>
                    <p>Select loops are almost always used with case statements to handle different menu options. This is the most common pattern.</p>

                    <pre><code class="language-bash"># Select with case statement
PS3="Choose an action: "
select action in "Start" "Stop" "Restart" "Status" "Exit"; do
    case $action in
        "Start")
            echo "Starting service..."
            break
            ;;
        "Stop")
            echo "Stopping service..."
            break
            ;;
        "Restart")
            echo "Restarting service..."
            break
            ;;
        "Status")
            echo "Service status: running"
            break
            ;;
        "Exit")
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose 1-5."
            ;;
    esac
done</code></pre>

                    <div class="info-box">
                        <strong>Best Practice:</strong><br>
                        - Use <code>case</code> statements with select<br>
                        - Include <code>*)</code> default case for invalid input<br>
                        - Use <code>break</code> after each valid selection (except Exit)<br>
                        - Use <code>exit</code> for quit/exit option
                    </div>

                    <!-- Section 4: Continuous Menus -->
                    <h2>Continuous Menus</h2>
                    <p>By default, select loops continue until you use <code>break</code>. You can create menus that keep running until the user explicitly exits.</p>

                    <pre><code class="language-bash"># Continuous menu (keeps looping)
PS3="Select option: "
select choice in "View files" "Edit file" "Delete file" "Exit"; do
    case $choice in
        "View files")
            ls -la
            # No break - menu continues
            ;;
        "Edit file")
            echo "Editing..."
            ;;
        "Delete file")
            echo "Deleting..."
            ;;
        "Exit")
            echo "Exiting..."
            break  # Exit select loop
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
    # Menu prompts again automatically
done
echo "Goodbye!"</code></pre>

                    <!-- Section 5: Using Arrays with Select -->
                    <h2>Using Arrays with Select</h2>
                    <p>You can use arrays with select loops to make your menus more dynamic and maintainable.</p>

                    <pre><code class="language-bash"># Using array with select
options=("Option 1" "Option 2" "Option 3" "Quit")

PS3="Choose: "
select opt in "\${options[@]}"; do
    case $opt in
        "Option 1"|"Option 2"|"Option 3")
            echo "You selected: $opt"
            break
            ;;
        "Quit")
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
done</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting break, causing infinite menu</h4>
                        <pre><code class="language-bash"># Wrong - menu loops forever
select choice in "Start" "Exit"; do
    case $choice in
        "Start")
            echo "Started"
            # Missing break!
            ;;
        "Exit")
            exit 0
            ;;
    esac
done  # Keeps prompting forever

# Correct - break after handling
select choice in "Start" "Exit"; do
    case $choice in
        "Start")
            echo "Started"
            break  # Exit menu after action
            ;;
        "Exit")
            exit 0
            ;;
    esac
done</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Not handling invalid input</h4>
                        <pre><code class="language-bash"># Wrong - no handling for invalid numbers
select choice in "Option 1" "Option 2"; do
    case $choice in
        "Option 1")
            echo "One"
            break
            ;;
        "Option 2")
            echo "Two"
            break
            ;;
        # Missing default case!
    esac
done

# Correct - handle invalid input
select choice in "Option 1" "Option 2"; do
    case $choice in
        "Option 1")
            echo "One"
            break
            ;;
        "Option 2")
            echo "Two"
            break
            ;;
        *)
            echo "Invalid option. Choose 1 or 2."
            ;;
    esac
done</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not setting PS3, confusing prompt</h4>
                        <pre><code class="language-bash"># Wrong - default PS3 is "#? " (confusing)
select choice in a b c; do
    break
done
# Prompt: #?  (user doesn't know what to do)

# Correct - set clear PS3
PS3="Choose an option [1-3]: "
select choice in a b c; do
    break
done
# Prompt: Choose an option [1-3]: </code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create an Interactive Menu</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script with an interactive select menu!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a select menu with at least 4 options</li>
                            <li>Use a case statement to handle each option</li>
                            <li>Set a custom PS3 prompt</li>
                            <li>Include an Exit option</li>
                            <li>Handle invalid input with a default case</li>
                            <li>Use break appropriately (either after each action or create continuous menu)</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Interactive menu example

PS3="Please choose an option [1-5]: "

select option in "Show current directory" "List files" "Show date" "Show user" "Exit"; do
    case $option in
        "Show current directory")
            echo "Current directory: $(pwd)"
            break
            ;;
        "List files")
            echo "Files in current directory:"
            ls -lh
            break
            ;;
        "Show date")
            echo "Current date: $(date)"
            break
            ;;
        "Show user")
            echo "Current user: $USER"
            break
            ;;
        "Exit")
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose 1-5."
            ;;
    esac
done</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Syntax:</strong> <code>select variable in list; do ... done</code></li>
                            <li><strong>PS3:</strong> Controls the prompt text (set before select)</li>
                            <li><strong>Menu:</strong> Automatically displays numbered options</li>
                            <li><strong>Variable:</strong> Selected item stored in loop variable</li>
                            <li><strong>REPLY:</strong> Selected number stored in <code>$REPLY</code></li>
                            <li><strong>Case:</strong> Use case statements to handle menu options</li>
                            <li><strong>Break:</strong> Use break to exit select loop after action</li>
                            <li><strong>Default:</strong> Use <code>*)</code> to handle invalid input</li>
                            <li><strong>Arrays:</strong> Can use arrays: <code>select opt in "\${array[@]}"</code></li>
                            <li><strong>Continuous:</strong> Omit break for menus that keep running</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Excellent! You've completed the Control Flow module! You now know how to make decisions with if and case statements, iterate with for/while/until loops, control loop execution, and create interactive menus. Next up is <strong>Functions</strong> - learn how to organize your code into reusable blocks, pass arguments, return values, and create modular, maintainable scripts!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="loops-control.jsp" />
                    <jsp:param name="prevTitle" value="Loop Control" />
                    <jsp:param name="nextLink" value="functions-basics.jsp" />
                    <jsp:param name="nextTitle" value="Functions" />
                    <jsp:param name="currentLessonId" value="loops-select" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/shell.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>


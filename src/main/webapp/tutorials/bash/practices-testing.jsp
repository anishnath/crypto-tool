<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "practices-testing");
   request.setAttribute("currentModule", "Professional Practices"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Testing Scripts - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn to test Bash scripts with unit tests, integration tests, and automated testing frameworks. Build reliable, bug-free shell scripts.">
    <meta name="keywords"
        content="bash testing, shell script testing, bats testing, bash unit test, bash test framework, shell script validation">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Testing Scripts - Bash Tutorial">
    <meta property="og:description" content="Learn testing strategies and frameworks for reliable Bash scripts.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/practices-testing.jsp">
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
        "name": "Bash Testing Scripts",
        "description": "Learn testing strategies and frameworks for creating reliable Bash scripts.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Unit testing", "Integration testing", "Test functions", "Assertions", "BATS framework", "CI integration"],
        "timeRequired": "PT25M",
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

<body class="tutorial-body no-preview" data-lesson="practices-testing">
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
                    <span>Testing Scripts</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Testing Scripts</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Untested code is broken code waiting to happen. While Bash scripts are often treated as "throwaway," production scripts deserve proper testing. This lesson teaches you techniques from simple assertions to full test frameworks!</p>

                    <!-- Section 1: Basic Testing -->
                    <h2>Basic Testing Techniques</h2>
                    <p>Start with simple, built-in testing approaches before reaching for frameworks.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-testing.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <h3>Assert Functions</h3>
                    <pre><code class="language-bash"># Simple assertion library
assert_equals() {
    local expected="\$1"
    local actual="\$2"
    local message="\${3:-Values should be equal}"

    if [[ "\$expected" != "\$actual" ]]; then
        echo "FAIL: \$message"
        echo "  Expected: '\$expected'"
        echo "  Actual:   '\$actual'"
        return 1
    fi
    echo "PASS: \$message"
    return 0
}

assert_true() {
    local condition="\$1"
    local message="\${2:-Condition should be true}"

    if ! eval "\$condition"; then
        echo "FAIL: \$message"
        echo "  Condition: \$condition"
        return 1
    fi
    echo "PASS: \$message"
    return 0
}

assert_file_exists() {
    local file="\$1"
    local message="\${2:-File should exist: \$file}"

    if [[ ! -f "\$file" ]]; then
        echo "FAIL: \$message"
        return 1
    fi
    echo "PASS: \$message"
    return 0
}

assert_exit_code() {
    local expected="\$1"
    local actual="\$2"
    local message="\${3:-Exit code should be \$expected}"

    if [[ "\$expected" -ne "\$actual" ]]; then
        echo "FAIL: \$message (got \$actual)"
        return 1
    fi
    echo "PASS: \$message"
    return 0
}</code></pre>

                    <div class="info-box">
                        <strong>Test-Driven Workflow:</strong> Write a failing test, implement the feature, verify the test passes. This ensures your code actually does what you think it does.
                    </div>

                    <!-- Section 2: Unit Testing -->
                    <h2>Unit Testing Functions</h2>
                    <p>Test individual functions in isolation for targeted verification.</p>

                    <pre><code class="language-bash"># Function to test
calculate_sum() {
    local a="\$1"
    local b="\$2"
    echo \$((a + b))
}

validate_email() {
    local email="\$1"
    [[ "\$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\$ ]]
}

# Unit tests
test_calculate_sum() {
    echo "Testing calculate_sum..."

    local result

    result=\$(calculate_sum 2 3)
    assert_equals "5" "\$result" "2 + 3 = 5"

    result=\$(calculate_sum 0 0)
    assert_equals "0" "\$result" "0 + 0 = 0"

    result=\$(calculate_sum -5 10)
    assert_equals "5" "\$result" "-5 + 10 = 5"
}

test_validate_email() {
    echo "Testing validate_email..."

    validate_email "user@example.com"
    assert_exit_code 0 \$? "Valid email accepted"

    validate_email "invalid-email"
    assert_exit_code 1 \$? "Invalid email rejected"

    validate_email "user@domain"
    assert_exit_code 1 \$? "Email without TLD rejected"
}

# Test runner
run_tests() {
    local failed=0

    test_calculate_sum || ((failed++))
    test_validate_email || ((failed++))

    echo ""
    if [[ \$failed -eq 0 ]]; then
        echo "All tests passed!"
        return 0
    else
        echo "Tests failed: \$failed"
        return 1
    fi
}

run_tests</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Integration Testing -->
                    <h2>Integration Testing</h2>
                    <p>Test scripts as a whole, verifying they work correctly end-to-end.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash
# Integration test suite for backup.sh

readonly SCRIPT_UNDER_TEST="./backup.sh"
readonly TEST_DIR="/tmp/backup_test_\$\$"

# Setup test environment
setup() {
    mkdir -p "\$TEST_DIR"/{source,dest}
    echo "test file 1" > "\$TEST_DIR/source/file1.txt"
    echo "test file 2" > "\$TEST_DIR/source/file2.txt"
}

# Cleanup after tests
teardown() {
    rm -rf "\$TEST_DIR"
}

# Test: Script runs without error
test_script_runs() {
    echo "Test: Script runs successfully"

    \$SCRIPT_UNDER_TEST "\$TEST_DIR/source" "\$TEST_DIR/dest" >/dev/null 2>&1
    local exit_code=\$?

    assert_exit_code 0 \$exit_code "Script should exit with 0"
}

# Test: Files are copied correctly
test_files_copied() {
    echo "Test: Files are copied to destination"

    \$SCRIPT_UNDER_TEST "\$TEST_DIR/source" "\$TEST_DIR/dest" >/dev/null 2>&1

    assert_file_exists "\$TEST_DIR/dest/file1.txt"
    assert_file_exists "\$TEST_DIR/dest/file2.txt"

    local original=\$(cat "\$TEST_DIR/source/file1.txt")
    local copied=\$(cat "\$TEST_DIR/dest/file1.txt")
    assert_equals "\$original" "\$copied" "File content preserved"
}

# Test: Error on missing source
test_missing_source_fails() {
    echo "Test: Missing source returns error"

    \$SCRIPT_UNDER_TEST "/nonexistent" "\$TEST_DIR/dest" >/dev/null 2>&1
    local exit_code=\$?

    assert_true "[[ \$exit_code -ne 0 ]]" "Should fail with non-zero exit"
}

# Test: Help flag works
test_help_flag() {
    echo "Test: Help flag shows usage"

    local output=\$(\$SCRIPT_UNDER_TEST --help 2>&1)

    assert_true "[[ \"\$output\" == *\"Usage\"* ]]" "Help contains Usage"
    assert_true "[[ \"\$output\" == *\"--help\"* ]]" "Help mentions --help"
}

# Main test runner
main() {
    echo "=== Integration Tests for backup.sh ==="
    echo ""

    setup
    trap teardown EXIT

    local tests_failed=0

    test_script_runs || ((tests_failed++))
    test_files_copied || ((tests_failed++))
    test_missing_source_fails || ((tests_failed++))
    test_help_flag || ((tests_failed++))

    echo ""
    echo "=== Results ==="
    if [[ \$tests_failed -eq 0 ]]; then
        echo "All integration tests passed!"
        exit 0
    else
        echo "Failed tests: \$tests_failed"
        exit 1
    fi
}

main</code></pre>

                    <!-- Section 4: Test Frameworks -->
                    <h2>Test Frameworks</h2>
                    <p>For larger projects, use dedicated testing frameworks.</p>

                    <h3>BATS (Bash Automated Testing System)</h3>
                    <pre><code class="language-bash"># test_backup.bats

# Setup runs before each test
setup() {
    TEST_DIR="\$(mktemp -d)"
    mkdir -p "\$TEST_DIR"/{source,dest}
    echo "content" > "\$TEST_DIR/source/file.txt"
}

# Teardown runs after each test
teardown() {
    rm -rf "\$TEST_DIR"
}

@test "backup creates destination directory" {
    run ./backup.sh "\$TEST_DIR/source" "\$TEST_DIR/newdest"
    [ "\$status" -eq 0 ]
    [ -d "\$TEST_DIR/newdest" ]
}

@test "backup copies files correctly" {
    run ./backup.sh "\$TEST_DIR/source" "\$TEST_DIR/dest"
    [ "\$status" -eq 0 ]
    [ -f "\$TEST_DIR/dest/file.txt" ]
}

@test "backup preserves file content" {
    ./backup.sh "\$TEST_DIR/source" "\$TEST_DIR/dest"

    original=\$(cat "\$TEST_DIR/source/file.txt")
    copied=\$(cat "\$TEST_DIR/dest/file.txt")
    [ "\$original" = "\$copied" ]
}

@test "backup fails on missing source" {
    run ./backup.sh "/nonexistent" "\$TEST_DIR/dest"
    [ "\$status" -ne 0 ]
}

@test "help flag shows usage information" {
    run ./backup.sh --help
    [ "\$status" -eq 0 ]
    [[ "\$output" == *"Usage"* ]]
}</code></pre>

                    <div class="tip-box">
                        <strong>Installing BATS:</strong>
                        <pre><code class="language-bash"># macOS
brew install bats-core

# Linux (apt)
sudo apt install bats

# Run tests
bats test_backup.bats</code></pre>
                    </div>

                    <!-- Section 5: CI Integration -->
                    <h2>CI/CD Integration</h2>
                    <p>Run tests automatically on every commit.</p>

                    <pre><code class="language-yaml"># .github/workflows/test.yml
name: Test Bash Scripts

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install BATS
        run: |
          sudo apt-get update
          sudo apt-get install -y bats

      - name: Run ShellCheck
        run: |
          shellcheck scripts/*.sh

      - name: Run unit tests
        run: |
          bats tests/

      - name: Run integration tests
        run: |
          ./tests/integration/run_all.sh</code></pre>

                    <h3>ShellCheck Integration</h3>
                    <pre><code class="language-bash"># Run ShellCheck on all scripts
shellcheck scripts/*.sh

# Ignore specific warnings
# shellcheck disable=SC2086
echo \$unquoted_var

# Check with severity level
shellcheck --severity=warning scripts/*.sh</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Not isolating tests</h4>
                        <pre><code class="language-bash"># Wrong - tests affect each other
test1() {
    create_file "/tmp/test.txt"  # Left behind!
}

# Correct - use setup/teardown
setup() { TEST_DIR=\$(mktemp -d); }
teardown() { rm -rf "\$TEST_DIR"; }
trap teardown EXIT</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Testing implementation, not behavior</h4>
                        <pre><code class="language-bash"># Wrong - tests internal details
assert_equals "grep" "\$SEARCH_COMMAND"

# Correct - test the outcome
result=\$(search_for "pattern" "file.txt")
assert_equals "found" "\$result"</code></pre>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Assertions:</strong> Build simple assert functions for quick checks</li>
                            <li><strong>Unit Tests:</strong> Test functions in isolation</li>
                            <li><strong>Integration:</strong> Test scripts end-to-end with setup/teardown</li>
                            <li><strong>BATS:</strong> Use for larger projects with many tests</li>
                            <li><strong>ShellCheck:</strong> Static analysis catches bugs early</li>
                            <li><strong>CI/CD:</strong> Automate testing on every commit</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Let's see everything in action with <strong>Real-World Examples</strong>. You'll explore complete, production-ready scripts that demonstrate all the practices from this module!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="practices-templates.jsp" />
                    <jsp:param name="prevTitle" value="Script Templates" />
                    <jsp:param name="nextLink" value="practices-examples.jsp" />
                    <jsp:param name="nextTitle" value="Real-World Examples" />
                    <jsp:param name="currentLessonId" value="practices-testing" />
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

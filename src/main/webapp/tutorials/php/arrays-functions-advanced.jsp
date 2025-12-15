<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "arrays-functions-advanced");
   request.setAttribute("currentModule", "Arrays"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Array Functions II - PHP Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn PHP array functions for modifying arrays. Master array_push, array_pop, array_merge, array_slice, array_splice, and more.">
    <meta name="keywords"
        content="php array_push, php array_pop, php array_merge, php array_slice, php array_splice, php array functions">
    <link rel="canonical" href="https://8gwifi.org/tutorials/php/arrays-functions-advanced.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
    <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Array Functions II","description":"Learn PHP array functions for modifying, merging, and manipulating arrays","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["array_push()","array_pop()","array_merge()","array_slice()","array_splice()","array_combine()"],"timeRequired":"PT35M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="arrays-functions-advanced">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>
        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-php.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/php/">PHP</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Array Functions II</span>
                </nav>
                <header class="lesson-header">
                    <h1 class="lesson-title">PHP Array Functions II</h1>
                    <div class="lesson-meta"><span>Intermediate</span><span>~35 min read</span></div>
                </header>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>
                <div class="lesson-body">
                    <p class="lead">Now let's explore array functions that modify arrays - adding, removing, merging,
                        slicing, and restructuring elements. These functions are essential for dynamic data manipulation.</p>

                    <h2>Adding Elements</h2>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Function</th>
                                <th>Where</th>
                                <th>Returns</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>array_push($arr, $val)</code></td>
                                <td>End of array</td>
                                <td>New length</td>
                            </tr>
                            <tr>
                                <td><code>$arr[] = $val</code></td>
                                <td>End of array</td>
                                <td>-</td>
                            </tr>
                            <tr>
                                <td><code>array_unshift($arr, $val)</code></td>
                                <td>Beginning of array</td>
                                <td>New length</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-php">&lt;?php
$stack = ["A", "B"];

// Add to end
array_push($stack, "C", "D");  // ["A", "B", "C", "D"]

// Shorthand (single element)
$stack[] = "E";                // ["A", "B", "C", "D", "E"]

// Add to beginning
array_unshift($stack, "Z");    // ["Z", "A", "B", "C", "D", "E"]
?&gt;</code></pre>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="php/arrays-functions-advanced.php" />
                        <jsp:param name="language" value="php" />
                        <jsp:param name="editorId" value="compiler-advanced" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Performance:</strong> Use <code>$arr[] = $val</code> instead of
                        <code>array_push()</code> for single elements - it's faster!
                    </div>

                    <h2>Removing Elements</h2>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Function</th>
                                <th>From</th>
                                <th>Returns</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>array_pop($arr)</code></td>
                                <td>End of array</td>
                                <td>Removed element</td>
                            </tr>
                            <tr>
                                <td><code>array_shift($arr)</code></td>
                                <td>Beginning of array</td>
                                <td>Removed element</td>
                            </tr>
                            <tr>
                                <td><code>unset($arr[$key])</code></td>
                                <td>Specific key</td>
                                <td>-</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-php">&lt;?php
$queue = ["First", "Second", "Third", "Fourth"];

// Remove from end
$last = array_pop($queue);
echo $last;  // "Fourth"
// $queue: ["First", "Second", "Third"]

// Remove from beginning
$first = array_shift($queue);
echo $first;  // "First"
// $queue: ["Second", "Third"]

// Remove specific element
unset($queue[0]);
// $queue: [1 => "Third"] - Note: doesn't reindex!

// Reindex after unset
$queue = array_values($queue);
// $queue: [0 => "Third"]
?&gt;</code></pre>

                    <h2>Merging Arrays</h2>

                    <h3>array_merge()</h3>
                    <pre><code class="language-php">&lt;?php
// Indexed arrays - concatenates
$a = [1, 2, 3];
$b = [4, 5, 6];
$merged = array_merge($a, $b);  // [1, 2, 3, 4, 5, 6]

// Associative arrays - later values overwrite
$defaults = ["color" => "red", "size" => "M"];
$custom = ["size" => "L", "qty" => 2];
$config = array_merge($defaults, $custom);
// ["color" => "red", "size" => "L", "qty" => 2]
?&gt;</code></pre>

                    <h3>Spread Operator (PHP 7.4+)</h3>
                    <pre><code class="language-php">&lt;?php
$first = [1, 2, 3];
$second = [4, 5, 6];

// Combine with spread
$all = [...$first, ...$second];  // [1, 2, 3, 4, 5, 6]

// Insert in middle
$middle = [...$first, "X", ...$second];
// [1, 2, 3, "X", 4, 5, 6]
?&gt;</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <h2>array_combine()</h2>
                    <p>Create an associative array from two arrays:</p>

                    <pre><code class="language-php">&lt;?php
$headers = ["Name", "Email", "Age"];
$values = ["John", "john@test.com", 30];

$row = array_combine($headers, $values);
// ["Name" => "John", "Email" => "john@test.com", "Age" => 30]

// Useful for CSV processing
$csvHeader = ["id", "product", "price"];
$csvRow = ["101", "Widget", "29.99"];
$record = array_combine($csvHeader, $csvRow);
?&gt;</code></pre>

                    <h2>Slicing Arrays</h2>

                    <h3>array_slice()</h3>
                    <p>Extract a portion without modifying original:</p>

                    <pre><code class="language-php">&lt;?php
$arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

// slice(offset, length)
array_slice($arr, 2, 4);    // [2, 3, 4, 5]
array_slice($arr, 5);       // [5, 6, 7, 8, 9]
array_slice($arr, -3);      // [7, 8, 9]
array_slice($arr, 0, -2);   // [0, 1, 2, 3, 4, 5, 6, 7]
array_slice($arr, 2, -2);   // [2, 3, 4, 5, 6, 7]

// Preserve keys
$assoc = ["a" => 1, "b" => 2, "c" => 3];
array_slice($assoc, 1, 2, true);  // ["b" => 2, "c" => 3]
?&gt;</code></pre>

                    <h3>array_splice()</h3>
                    <p>Remove/replace portion AND modify original:</p>

                    <pre><code class="language-php">&lt;?php
// Remove elements
$arr = ["a", "b", "c", "d", "e"];
$removed = array_splice($arr, 2, 2);  // Remove 2 at index 2
// $removed: ["c", "d"]
// $arr: ["a", "b", "e"]

// Replace elements
$arr = ["a", "b", "c", "d", "e"];
array_splice($arr, 1, 2, ["X", "Y", "Z"]);
// $arr: ["a", "X", "Y", "Z", "d", "e"]

// Insert elements (length = 0)
$arr = ["a", "b", "e"];
array_splice($arr, 2, 0, ["c", "d"]);
// $arr: ["a", "b", "c", "d", "e"]
?&gt;</code></pre>

                    <h2>Other Useful Functions</h2>

                    <pre><code class="language-php">&lt;?php
// array_flip - Swap keys and values
$arr = ["a" => 1, "b" => 2, "c" => 3];
array_flip($arr);  // [1 => "a", 2 => "b", 3 => "c"]

// array_reverse - Reverse order
$arr = [1, 2, 3, 4, 5];
array_reverse($arr);  // [5, 4, 3, 2, 1]

// array_chunk - Split into chunks
$arr = [1, 2, 3, 4, 5, 6, 7];
array_chunk($arr, 3);
// [[1, 2, 3], [4, 5, 6], [7]]

// array_pad - Pad to specified length
$arr = [1, 2, 3];
array_pad($arr, 5, 0);   // [1, 2, 3, 0, 0]
array_pad($arr, -5, 0);  // [0, 0, 1, 2, 3]

// array_fill_keys - Create with same value
$keys = ["a", "b", "c"];
array_fill_keys($keys, 0);  // ["a" => 0, "b" => 0, "c" => 0]
?&gt;</code></pre>

                    <h2>Quick Reference</h2>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Task</th>
                                <th>Function</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Add to end</td>
                                <td><code>array_push()</code> or <code>$arr[]</code></td>
                            </tr>
                            <tr>
                                <td>Add to beginning</td>
                                <td><code>array_unshift()</code></td>
                            </tr>
                            <tr>
                                <td>Remove from end</td>
                                <td><code>array_pop()</code></td>
                            </tr>
                            <tr>
                                <td>Remove from beginning</td>
                                <td><code>array_shift()</code></td>
                            </tr>
                            <tr>
                                <td>Merge arrays</td>
                                <td><code>array_merge()</code></td>
                            </tr>
                            <tr>
                                <td>Create from keys/values</td>
                                <td><code>array_combine()</code></td>
                            </tr>
                            <tr>
                                <td>Extract portion</td>
                                <td><code>array_slice()</code></td>
                            </tr>
                            <tr>
                                <td>Remove/insert in place</td>
                                <td><code>array_splice()</code></td>
                            </tr>
                            <tr>
                                <td>Reverse order</td>
                                <td><code>array_reverse()</code></td>
                            </tr>
                            <tr>
                                <td>Split into chunks</td>
                                <td><code>array_chunk()</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <h2>Exercise: Playlist Manager</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a playlist manager with array functions.</p>
                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Add songs to end of playlist</li>
                            <li>Add song to beginning (play next)</li>
                            <li>Remove currently playing song (first)</li>
                            <li>Move a song to a different position</li>
                            <li>Merge two playlists</li>
                        </ul>
                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-php">&lt;?php
class Playlist {
    private $songs = [];

    // Add to end
    public function add($song) {
        $this->songs[] = $song;
    }

    // Add to beginning (play next)
    public function playNext($song) {
        array_unshift($this->songs, $song);
    }

    // Remove current (first song)
    public function skipCurrent() {
        return array_shift($this->songs);
    }

    // Move song to new position
    public function moveSong($fromIndex, $toIndex) {
        $song = array_splice($this->songs, $fromIndex, 1);
        array_splice($this->songs, $toIndex, 0, $song);
    }

    // Merge another playlist
    public function merge($otherSongs) {
        $this->songs = array_merge($this->songs, $otherSongs);
    }

    public function show() {
        foreach ($this->songs as $i => $song) {
            echo ($i + 1) . ". $song\n";
        }
    }
}

$playlist = new Playlist();
$playlist->add("Song A");
$playlist->add("Song B");
$playlist->add("Song C");

echo "Initial playlist:\n";
$playlist->show();

$playlist->playNext("Urgent Song");
echo "\nAfter playNext:\n";
$playlist->show();

$skipped = $playlist->skipCurrent();
echo "\nSkipped: $skipped\n";
$playlist->show();

$playlist->merge(["Song X", "Song Y"]);
echo "\nAfter merge:\n";
$playlist->show();
?&gt;</code></pre>
                        </details>
                    </div>

                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Adding:</strong> <code>array_push()</code>, <code>array_unshift()</code>, <code>$arr[]</code></li>
                            <li><strong>Removing:</strong> <code>array_pop()</code>, <code>array_shift()</code>, <code>unset()</code></li>
                            <li><strong>Merging:</strong> <code>array_merge()</code> or spread <code>...</code></li>
                            <li><strong>Slicing:</strong> <code>array_slice()</code> (non-destructive)</li>
                            <li><strong>Splicing:</strong> <code>array_splice()</code> (destructive)</li>
                            <li><strong>Use spread:</strong> For clean, readable array merging</li>
                            <li><strong>Remember:</strong> <code>unset()</code> doesn't reindex!</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's explore <strong>Array Iteration</strong> - powerful functions like
                        <code>array_map()</code>, <code>array_filter()</code>, and <code>array_reduce()</code>
                        for functional-style array processing!</p>
                </div>
                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>
                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="arrays-functions-basic.jsp" />
                    <jsp:param name="prevTitle" value="Array Functions I" />
                    <jsp:param name="nextLink" value="arrays-iteration.jsp" />
                    <jsp:param name="nextTitle" value="Array Iteration" />
                    <jsp:param name="currentLessonId" value="arrays-functions-advanced" />
                </jsp:include>
            </article>
        </main>
        <%@ include file="../tutorial-footer.jsp" %>
    </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>

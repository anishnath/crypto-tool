<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "oop-polymorphism");
   request.setAttribute("currentModule", "Object-Oriented Programming"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python Polymorphism - Duck Typing, Method Overriding, Protocols | 8gwifi.org</title>
    <meta name="description"
        content="Master Python polymorphism: duck typing, method overriding, and protocols. Learn to write flexible code that works with different types through shared interfaces.">
    <meta name="keywords"
        content="python polymorphism, python duck typing, python method overriding, python protocols, python interface, python EAFP">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python Polymorphism - Duck Typing, Method Overriding, Protocols">
    <meta property="og:description" content="Master Python polymorphism: duck typing, method overriding, and protocols for flexible code.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/oop-polymorphism.jsp">
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
        "name": "Python Polymorphism",
        "description": "Master Python polymorphism: duck typing, method overriding, and protocols for flexible, reusable code.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Polymorphism concept", "Method overriding", "Duck typing", "EAFP principle", "Python protocols", "Iterable protocol", "Callable objects", "Sized protocol"],
        "timeRequired": "PT25M",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="oop-polymorphism">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>OOP</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Polymorphism</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Polymorphism ("many forms") allows different objects to respond to the same method call
                        in their own way. Python embraces polymorphism through duck typing - focusing on what an object
                        <em>can do</em> (its methods) rather than what it <em>is</em> (its type).</p>

                    <div class="info-box">
                        <h4>Python's Approach to Polymorphism</h4>
                        <p>Unlike Java or C++, Python doesn't require explicit interfaces or inheritance for polymorphism.
                            If an object has the right methods, it can be used - this is called <strong>duck typing</strong>:
                            "If it walks like a duck and quacks like a duck, it's a duck."</p>
                    </div>

                    <!-- Section 1: Polymorphism Basics -->
                    <h2>Polymorphism Basics</h2>
                    <p>Polymorphism allows you to write code that works with objects of different types, as long as they
                        share a common interface (same method names).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/poly-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-poly-basics" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Write Generic Functions</h4>
                        <p>The key benefit of polymorphism is writing functions that work with ANY object having the right
                            methods. Your function doesn't need to know about every possible type - it just uses the interface.</p>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 2: Inheritance Polymorphism -->
                    <h2>Polymorphism Through Inheritance</h2>
                    <p>Inheritance naturally creates polymorphism. A base class defines the interface, and child classes
                        provide different implementations through method overriding.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/poly-inheritance.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-poly-inheritance" />
                    </jsp:include>

                    <div class="info-box">
                        <h4>Open/Closed Principle</h4>
                        <p>Polymorphism enables the Open/Closed Principle: code is <strong>open for extension</strong>
                            (add new shapes without changing existing code) but <strong>closed for modification</strong>
                            (existing functions work with new types automatically).</p>
                    </div>

                    <!-- Section 3: Duck Typing -->
                    <h2>Duck Typing</h2>
                    <p>Python's duck typing means you don't need inheritance for polymorphism. Any object with the right
                        methods will work - the type doesn't matter, only the behavior.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/poly-duck-typing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-poly-duck" />
                    </jsp:include>

                    <div class="warning-box">
                        <h4>EAFP: Easier to Ask Forgiveness than Permission</h4>
                        <p>Python's preferred style is EAFP - try to use the object and handle exceptions if it fails.
                            Don't check types with <code>isinstance()</code> before using an object. Let duck typing work!</p>
                    </div>

                    <!-- Section 4: Python Protocols -->
                    <h2>Python Protocols</h2>
                    <p>Protocols are informal interfaces that enable polymorphism with built-in functions like
                        <code>len()</code>, <code>for</code> loops, and operators. Implement special methods to make
                        your objects work with Python's syntax.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/poly-protocols.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-poly-protocols" />
                    </jsp:include>

                    <div class="tip-box">
                        <h4>Make Objects Pythonic</h4>
                        <p>By implementing protocols (<code>__len__</code>, <code>__iter__</code>, <code>__contains__</code>, etc.),
                            your custom objects can work with Python's built-in functions and syntax, making them feel like
                            native Python types.</p>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Unnecessary type checking</h4>
                        <pre><code class="language-python"># Bad - defeats duck typing
def process(obj):
    if isinstance(obj, MyClass):
        return obj.process()
    raise TypeError("Must be MyClass!")

# Good - just use it
def process(obj):
    return obj.process()  # Works with any class that has process()</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Not handling missing methods gracefully</h4>
                        <pre><code class="language-python"># Bad - crashes if method missing
def display(obj):
    return obj.render()  # AttributeError if no render()

# Good - EAFP style
def display(obj):
    try:
        return obj.render()
    except AttributeError:
        return str(obj)  # Fallback</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting to implement all interface methods</h4>
                        <pre><code class="language-python"># Problem - incomplete implementation
class MyIterator:
    def __iter__(self):
        return self
    # Missing __next__! Will fail at runtime.

# Complete implementation
class MyIterator:
    def __init__(self, data):
        self.data = data
        self.index = 0

    def __iter__(self):
        return self

    def __next__(self):
        if self.index >= len(self.data):
            raise StopIteration
        value = self.data[self.index]
        self.index += 1
        return value</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Breaking the interface contract</h4>
                        <pre><code class="language-python"># Bad - same method name, different behavior
class GoodDuck:
    def speak(self):
        return "Quack"  # Returns string

class BadDuck:
    def speak(self):
        print("Quack")  # Prints instead of returning!

# Now this breaks:
message = BadDuck().speak()  # message is None!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Over-relying on inheritance for polymorphism</h4>
                        <pre><code class="language-python"># Overly complex - forced inheritance
class BaseProcessor:
    def process(self): pass

class CSVProcessor(BaseProcessor):
    def process(self): ...

class JSONProcessor(BaseProcessor):
    def process(self): ...

# Simpler - just use duck typing
# No base class needed! Just have process() method
class CSVProcessor:
    def process(self): ...

class JSONProcessor:
    def process(self): ...</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Media Player</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a polymorphic media player system using both inheritance and duck typing.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li><code>AudioFile</code> and <code>VideoFile</code> classes inheriting from <code>MediaFile</code></li>
                            <li><code>ImageFile</code> class (no inheritance - demonstrates duck typing)</li>
                            <li>All classes implement <code>play()</code> and <code>get_info()</code> methods</li>
                            <li><code>play_all()</code> function that works with any media type</li>
                            <li><code>total_duration()</code> using duck typing (some media has duration, some doesn't)</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-oop-polymorphism.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-polymorphism" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">class MediaFile:
    def __init__(self, filename, duration):
        self.filename = filename
        self.duration = duration

    def play(self):
        raise NotImplementedError

    def get_info(self):
        return f"{self.filename} ({self.duration}s)"


class AudioFile(MediaFile):
    def __init__(self, filename, duration, bitrate):
        super().__init__(filename, duration)
        self.bitrate = bitrate

    def play(self):
        return f"Playing audio: {self.filename}"

    def get_info(self):
        return f"{self.filename} ({self.duration}s, {self.bitrate}kbps)"


class VideoFile(MediaFile):
    def __init__(self, filename, duration, resolution):
        super().__init__(filename, duration)
        self.resolution = resolution

    def play(self):
        return f"Playing video: {self.filename}"

    def get_info(self):
        return f"{self.filename} ({self.duration}s, {self.resolution})"


class ImageFile:  # No inheritance - duck typing!
    def __init__(self, filename, dimensions):
        self.filename = filename
        self.dimensions = dimensions
        # No duration attribute!

    def play(self):
        return f"Displaying image: {self.filename}"

    def get_info(self):
        return f"{self.filename} ({self.dimensions})"


def play_all(media_list):
    for media in media_list:
        print(media.play())


def total_duration(media_list):
    total = 0
    for media in media_list:
        try:
            total += media.duration
        except AttributeError:
            pass  # Skip items without duration
    return total


# Test
media = [
    AudioFile("song.mp3", 180, 320),
    VideoFile("movie.mp4", 7200, "1920x1080"),
    ImageFile("photo.jpg", "4000x3000"),
]

for m in media:
    print(m.get_info())

play_all(media)
print(f"Total duration: {total_duration(media)}s")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <div class="summary-box">
                        <h4>Summary</h4>
                        <ul>
                            <li><strong>Polymorphism:</strong> Different objects responding to the same method call</li>
                            <li><strong>Duck typing:</strong> "If it has the right methods, use it" - no type checks</li>
                            <li><strong>EAFP:</strong> Try to use the object, handle exceptions if it fails</li>
                            <li><strong>Protocols:</strong> Implement <code>__len__</code>, <code>__iter__</code>, etc. for Python integration</li>
                            <li><strong>Inheritance polymorphism:</strong> Base class defines interface, children override</li>
                            <li>Write generic functions that work with any object having the right methods</li>
                        </ul>
                    </div>

                    <!-- What's Next -->
                    <div class="info-box">
                        <h4>What's Next?</h4>
                        <p>Now that you understand polymorphism and protocols, learn about <strong>Special Methods</strong>
                            (dunder methods) - the double-underscore methods like <code>__init__</code>, <code>__str__</code>,
                            and <code>__eq__</code> that make your classes work with Python's syntax.</p>
                    </div>

                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="oop-encapsulation.jsp" />
                    <jsp:param name="prevTitle" value="Encapsulation" />
                    <jsp:param name="nextLink" value="oop-dunder.jsp" />
                    <jsp:param name="nextTitle" value="Special Methods" />
                    <jsp:param name="currentLessonId" value="oop-polymorphism" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>

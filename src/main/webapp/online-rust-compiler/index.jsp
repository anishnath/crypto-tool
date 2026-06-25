<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Rust Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run Rust online and visualize algorithms and concurrency step by step—watch vectors, matrices, hash maps, linked lists, trees, recursion, and threads and channels animate as your code runs. Free Rust algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-rust-compiler/");
request.setAttribute("preferredLanguage", "rust");
request.setAttribute("h1Text", "Online Rust Compiler & Algorithm Visualizer");
request.setAttribute("seoIntroTitle", "Run & Visualize Rust Online");
request.setAttribute("seoIntroBody", "Compile and run Rust online with stdin and multi‑file support. Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch vectors, 2‑D matrices, hash maps, sets, stacks, queues and heaps, linked lists (singly, doubly and circular), and binary trees animate line by line — great for learning sorting, binary search, recursion, and tree traversals. It even renders <strong>concurrency</strong>: threads, channels and mutexes become swim lanes, with send/receive rendezvous and deadlock detection.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does it include a Rust algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while vectors, 2‑D matrices, hash maps, sets, stacks/queues/heaps, linked lists, and binary trees animate — the visualizer highlights each read and write and the current line.</p>" +
    "<p><strong>Which data structures can I visualize?</strong> <code>Vec&lt;i32&gt;</code> and arrays, <code>Vec&lt;Vec&lt;i32&gt;&gt;</code> matrices, <code>HashMap</code>/<code>BTreeMap</code>, <code>HashSet</code>/<code>BTreeSet</code>, <code>VecDeque</code> and <code>BinaryHeap</code>, and linked lists &amp; trees built from <code>Box</code> or <code>Rc&lt;RefCell&gt;</code> (singly, doubly and circular). The visualizer renders <code>i32</code> values.</p>" +
    "<p><strong>Which algorithms?</strong> Sorting (bubble, insertion), binary search, two‑pointer and sliding‑window techniques, frequency counts, recursion (with a live call stack), and binary‑tree construction and traversal.</p>" +
    "<p><strong>Can I visualize concurrency?</strong> Yes. Use <code>std::thread::spawn</code> with <code>mpsc</code> channels or a <code>Mutex</code> and the visualizer draws one swim lane per thread, pairs channel sends with receives, and flags deadlocks (lanes parked waiting on each other).</p>" +
    "<p><strong>Which Rust versions are available?</strong> Stable Rust, including 1.74, 1.75 and the latest releases.</p>" +
    "<p><strong>Crates?</strong> Prefer self‑contained examples; external crates aren't persisted.</p>" +
    "<p><strong>How do I share code?</strong> Click Share to generate a snippet URL.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online Rust compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your code while vectors, 2-D matrices, hash maps, sets, stacks, queues, heaps, linked lists, and binary trees animate — a built-in algorithm visualizer that highlights each read and write and the current line of code.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which data structures can I visualize in Rust?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Vec and arrays, Vec-of-Vec matrices, HashMap and BTreeMap, HashSet and BTreeSet, VecDeque and BinaryHeap, and linked lists and binary trees built from Box or Rc<RefCell> (singly, doubly, and circular). The visualizer renders i32 values.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which algorithms can I visualize in Rust?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Sorting (bubble, insertion), binary search, two-pointer and sliding-window techniques, frequency counts, recursion with a live call stack, and binary-tree construction and traversal.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Can I visualize concurrency in Rust?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Use std::thread::spawn with mpsc channels or a Mutex and the visualizer draws one swim lane per thread, pairs channel sends with receives, and detects deadlocks where threads are parked waiting on each other.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Rust versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Stable Rust, including 1.74, 1.75 and the latest releases.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share Rust code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to generate a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>

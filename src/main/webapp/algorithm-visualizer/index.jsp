<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Online Algorithm Visualizer — Watch Code Run Step by Step" />
    <jsp:param name="toolCategory" value="Computer Science" />
    <jsp:param name="toolDescription" value="Free online algorithm and code visualizer. Run Python, Java, C, C++, Go, Rust, Lua, or C# and watch arrays, linked lists, trees, graphs, recursion, and memory animate line by line. A free Python Tutor alternative for 8 languages — no signup." />
    <jsp:param name="toolUrl" value="algorithm-visualizer/" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="toolKeywords" value="algorithm visualizer online, code visualizer, visualize code online, python tutor alternative, data structure visualizer, recursion visualizer, step through code online, memory visualizer, online code execution visualizer, watch code run, visualize algorithms, call stack visualizer, linked list visualizer, tree visualizer, graph traversal visualizer" />
    <jsp:param name="breadcrumbCategoryUrl" value="" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate, AP Computer Science, Data Structures and Algorithms" />
    <jsp:param name="teaches" value="arrays, matrices, linked lists, binary trees, graphs, BFS, DFS, recursion, call stack, hash maps, sets, stacks, queues, sorting, binary search, memory model, stack and heap" />
    <jsp:param name="toolFeatures" value="Step-by-step code execution for 8 languages,Animated arrays 2D matrices linked lists trees and graphs,Recursion and call-stack visualization,Memory view with stack frames and heap (C C++ Go Python),Highlights each variable read and write and the current line,Free Python Tutor alternative,100% browser-based no signup" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Write or paste your code|Type your program in any of the 8 supported languages or open a ready-made example.,Click Visualize|Press the Visualize button to run your code in step mode instead of plain output.,Step through execution|Use next and previous to watch each line run while data structures and memory update live." />
    <jsp:param name="faq1q" value="What is the online algorithm visualizer?" />
    <jsp:param name="faq1a" value="A free browser-based tool that runs your code line by line and animates what happens in memory — arrays, linked lists, trees, graphs, hash maps, recursion, and the call stack update visually as each statement executes. It works for 8 languages (Python, Java, C, C++, Go, Rust, Lua, C#) with no installation or signup." />
    <jsp:param name="faq2q" value="Is the algorithm visualizer free?" />
    <jsp:param name="faq2a" value="Yes, completely free with no signup. Every language visualizer runs in your browser. Write code, click Visualize, and step through execution." />
    <jsp:param name="faq3q" value="Is this a Python Tutor alternative?" />
    <jsp:param name="faq3a" value="Yes. Like Python Tutor, it steps through your code and shows variables, references, and data structures as they change — but it supports 8 languages (not just Python), animates linked lists, trees, and graphs, and shows a real memory view with stack frames and heap for C, C++, Go, and Python." />
    <jsp:param name="faq4q" value="Which languages can I visualize?" />
    <jsp:param name="faq4a" value="Python, Java, C, C++, Go, Rust, Lua, and C#. Each has a dedicated online compiler with a built-in Visualize button that steps through execution and animates its native data structures." />
    <jsp:param name="faq5q" value="What data structures and algorithms can I visualize?" />
    <jsp:param name="faq5a" value="Arrays and 2D matrices, strings, linked lists, binary trees and general trees, graphs, hash maps and sets, stacks and queues. That covers sorting (bubble, selection, insertion, merge), binary search, two-pointer techniques, recursion, tree and graph traversals (BFS and DFS), and linked-list operations — each shown step by step." />
    <jsp:param name="faq6q" value="Does it show memory, stack, and heap?" />
    <jsp:param name="faq6a" value="Yes for C, C++, Go, and Python. The memory view shows stack frames, heap allocations, and pointer or reference arrows using real execution data — so you can see how pointers, escape analysis, and object references actually behave." />
</jsp:include>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">

<!-- ItemList Schema: the 8 language visualizers -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "name": "Online Algorithm Visualizer",
  "description": "Free step-by-step code and algorithm visualizer for 8 languages",
  "url": "https://8gwifi.org/algorithm-visualizer/",
  "mainEntity": {
    "@type": "ItemList",
    "numberOfItems": 8,
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Python Algorithm Visualizer","url":"https://8gwifi.org/online-python-compiler/"},
      {"@type":"ListItem","position":2,"name":"Java Algorithm Visualizer","url":"https://8gwifi.org/online-java-compiler/"},
      {"@type":"ListItem","position":3,"name":"C++ Algorithm Visualizer","url":"https://8gwifi.org/online-cpp-compiler/"},
      {"@type":"ListItem","position":4,"name":"C Algorithm Visualizer","url":"https://8gwifi.org/online-c-compiler/"},
      {"@type":"ListItem","position":5,"name":"Go Algorithm Visualizer","url":"https://8gwifi.org/online-go-compiler/"},
      {"@type":"ListItem","position":6,"name":"Rust Algorithm Visualizer","url":"https://8gwifi.org/online-rust-compiler/"},
      {"@type":"ListItem","position":7,"name":"C# Algorithm Visualizer","url":"https://8gwifi.org/online-csharp-compiler/"},
      {"@type":"ListItem","position":8,"name":"Lua Algorithm Visualizer","url":"https://8gwifi.org/online-lua-compiler/"}
    ]
  }
}
</script>

<!-- GPT Ads -->
<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js" onerror="console.warn('GPT failed')"></script>
<script>
window.googletag=window.googletag||{cmd:[]};
googletag.cmd.push(function(){
  var w=window.innerWidth;
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_970x90_hero_desktop',[[970,90],[728,90]],'ad_viz_hero').addService(googletag.pubads());
  else if(w>=768)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_hero_tablet',[[728,90]],'ad_viz_hero').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_hero_mobile',[[320,50],[320,100]],'ad_viz_hero').addService(googletag.pubads());
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop',[[970,90],[728,90]],'ad_viz_below').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_leaderboard_mobile',[[320,100],[320,50]],'ad_viz_below').addService(googletag.pubads());
  googletag.pubads().disableInitialLoad();googletag.pubads().enableSingleRequest();googletag.pubads().collapseEmptyDivs();googletag.enableServices();
});
</script>

<style>
:root {
  --vz-bg:#0B1120; --vz-surface:#131B2A; --vz-border:rgba(139,92,246,0.14);
  --vz-text:#E2E8F0; --vz-text2:#94A3B8; --vz-text3:#64748B; --vz-accent:#8B5CF6; --vz-accent2:#06B6D4;
}
[data-theme="light"] {
  --vz-bg:#F0F4F8; --vz-surface:#FFFFFF; --vz-border:rgba(139,92,246,0.12);
  --vz-text:#1E293B; --vz-text2:#475569; --vz-text3:#94A3B8;
}
body { background:var(--vz-bg); margin:0; font-family:'DM Sans',sans-serif; color:var(--vz-text); }
.vz-wrap { max-width:1000px; margin:0 auto; padding:84px 20px 48px; }
@media(max-width:768px){ .vz-wrap{ padding-top:76px; } }

.vz-crumb { font-size:0.75rem; color:var(--vz-text3); margin-bottom:6px; }
.vz-crumb a { color:var(--vz-text3); text-decoration:none; }
.vz-crumb a:hover { color:var(--vz-accent); }

.vz-hero { text-align:center; padding:20px 0 16px; }
.vz-hero h1 {
  font-family:'Sora',sans-serif; font-size:1.9rem; font-weight:700; margin:0 0 10px;
  background:linear-gradient(135deg,#8B5CF6,#06B6D4);
  -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text;
}
.vz-hero p { color:var(--vz-text2); font-size:0.98rem; line-height:1.55; margin:0 auto 16px; max-width:640px; }
.vz-stats { display:flex; justify-content:center; gap:12px; flex-wrap:wrap; }
.vz-stat { background:var(--vz-surface); border:1px solid var(--vz-border); border-radius:8px; padding:6px 14px; font-size:0.76rem; font-weight:600; color:var(--vz-accent); }

.vz-h2 { font-family:'Sora',sans-serif; font-size:1.25rem; font-weight:700; margin:34px 0 6px; }
.vz-sub { color:var(--vz-text2); font-size:0.9rem; margin:0 0 16px; }

/* Language grid */
.vz-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(220px,1fr)); gap:14px; }
.vz-card {
  display:flex; flex-direction:column; padding:18px; background:var(--vz-surface);
  border:1px solid var(--vz-border); border-radius:14px; text-decoration:none; transition:all .22s;
}
.vz-card:hover { border-color:var(--vz-accent); box-shadow:0 4px 24px rgba(139,92,246,0.18); transform:translateY(-3px); }
.vz-card-head { display:flex; align-items:center; gap:11px; margin-bottom:9px; }
.vz-badge {
  width:42px; height:42px; border-radius:11px; flex-shrink:0; display:flex; align-items:center; justify-content:center;
  font-family:'Sora',sans-serif; font-weight:700; font-size:0.9rem; color:#fff;
}
.vz-card-name { font-family:'Sora',sans-serif; font-size:1.02rem; font-weight:700; color:var(--vz-text); margin:0; }
.vz-card-tag { font-size:0.72rem; color:var(--vz-accent2); font-weight:600; margin:1px 0 0; }
.vz-card-desc { font-size:0.82rem; color:var(--vz-text2); line-height:1.5; margin:0; }

/* Concept grid */
.vz-concepts { display:grid; grid-template-columns:repeat(auto-fill,minmax(240px,1fr)); gap:12px; }
.vz-concept { background:var(--vz-surface); border:1px solid var(--vz-border); border-radius:12px; padding:15px; }
.vz-concept h3 { font-family:'Sora',sans-serif; font-size:0.95rem; margin:0 0 5px; color:var(--vz-text); }
.vz-concept p { font-size:0.8rem; color:var(--vz-text2); line-height:1.5; margin:0; }

/* Steps */
.vz-steps { display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); gap:14px; counter-reset:step; }
.vz-step { background:var(--vz-surface); border:1px solid var(--vz-border); border-radius:12px; padding:16px 16px 16px 46px; position:relative; }
.vz-step::before {
  counter-increment:step; content:counter(step); position:absolute; left:14px; top:16px;
  width:22px; height:22px; border-radius:50%; background:linear-gradient(135deg,#8B5CF6,#06B6D4);
  color:#fff; font-weight:700; font-size:0.78rem; display:flex; align-items:center; justify-content:center;
}
.vz-step h3 { font-family:'Sora',sans-serif; font-size:0.92rem; margin:0 0 4px; }
.vz-step p { font-size:0.8rem; color:var(--vz-text2); line-height:1.5; margin:0; }

/* FAQ */
.vz-faq details { background:var(--vz-surface); border:1px solid var(--vz-border); border-radius:10px; padding:12px 14px; margin-bottom:8px; }
.vz-faq summary { cursor:pointer; font-weight:600; font-size:0.9rem; color:var(--vz-text); }
.vz-faq p { font-size:0.85rem; color:var(--vz-text2); line-height:1.55; margin:8px 0 0; }

.vz-related { display:flex; gap:10px; flex-wrap:wrap; align-items:center; margin-top:30px; font-size:0.75rem; color:var(--vz-text3); }
.vz-related a { padding:5px 12px; background:var(--vz-surface); border:1px solid var(--vz-border); border-radius:8px; text-decoration:none; font-size:0.78rem; font-weight:500; color:var(--vz-text); transition:all .15s; }
.vz-related a:hover { border-color:var(--vz-accent); color:#A78BFA; }

.ad-vz { text-align:center; max-width:970px; margin:0 auto; min-height:50px; }
.ad-vz .ad-label { font-size:.55rem; text-transform:uppercase; letter-spacing:.06em; color:var(--vz-text3); opacity:.5; margin-bottom:4px; }
</style>
</head>
<body>
<%@ include file="../modern/components/nav-header.jsp" %>

<div class="vz-wrap">

<div class="ad-vz" id="ad_viz_hero"><div class="ad-label">Advertisement</div></div>

<nav class="vz-crumb">
  <a href="<%=request.getContextPath()%>/">Home</a> / <span>Algorithm Visualizer</span>
</nav>

<section class="vz-hero">
  <h1>Online Algorithm Visualizer</h1>
  <p>Watch your code run <strong>line by line</strong> — see arrays, linked lists, trees, graphs, recursion, and memory animate as each statement executes. A free <strong>Python Tutor alternative</strong> for 8 languages, right in your browser.</p>
  <div class="vz-stats">
    <span class="vz-stat">8 Languages</span>
    <span class="vz-stat">Step-by-Step</span>
    <span class="vz-stat">Stack &amp; Heap View</span>
    <span class="vz-stat">100% Free</span>
    <span class="vz-stat">No Signup</span>
  </div>
</section>

<p style="color:var(--vz-text2);font-size:0.92rem;line-height:1.6;max-width:760px;margin:6px auto 0;text-align:center;">
  Most online compilers only print output. These do more: press <strong>Visualize</strong> and the compiler
  replays your program one line at a time, drawing every data structure as it changes and highlighting each
  variable read and write. It's the fastest way to <em>see</em> how sorting, binary search, recursion, and
  BFS/DFS actually work — and to debug why your algorithm does what it does.
</p>

<h2 class="vz-h2">Pick a language to visualize</h2>
<p class="vz-sub">Each language opens its online compiler with the built-in visualizer.</p>
<div class="vz-grid">

  <a class="vz-card" href="<%=request.getContextPath()%>/online-python-compiler/">
    <div class="vz-card-head"><div class="vz-badge" style="background:linear-gradient(135deg,#3776AB,#FFD43B);">Py</div>
      <div><p class="vz-card-name">Python</p><p class="vz-card-tag">names → objects memory</p></div></div>
    <p class="vz-card-desc">Step through Python while lists, dicts, sets, heaps, trees, and graphs animate — plus a Python Tutor–style view of names pointing to objects.</p>
  </a>

  <a class="vz-card" href="<%=request.getContextPath()%>/online-java-compiler/">
    <div class="vz-card-head"><div class="vz-badge" style="background:linear-gradient(135deg,#E76F00,#5382A1);">Jv</div>
      <div><p class="vz-card-name">Java</p><p class="vz-card-tag">arrays · collections · trees</p></div></div>
    <p class="vz-card-desc">Visualize arrays, 2D arrays, lists, maps, trees, and graphs, with recursion shown on the call stack as methods enter and return.</p>
  </a>

  <a class="vz-card" href="<%=request.getContextPath()%>/online-cpp-compiler/">
    <div class="vz-card-head"><div class="vz-badge" style="background:linear-gradient(135deg,#00599C,#659AD2);">C++</div>
      <div><p class="vz-card-name">C++</p><p class="vz-card-tag">STL + stack/heap memory</p></div></div>
    <p class="vz-card-desc">Watch STL containers, 2D arrays, trees, and graphs update, with a real memory view of stack frames, heap, and pointer arrows.</p>
  </a>

  <a class="vz-card" href="<%=request.getContextPath()%>/online-c-compiler/">
    <div class="vz-card-head"><div class="vz-badge" style="background:linear-gradient(135deg,#283593,#5C6BC0);">C</div>
      <div><p class="vz-card-name">C</p><p class="vz-card-tag">pointers · call stack</p></div></div>
    <p class="vz-card-desc">See arrays, strings, matrices, linked lists, and trees, with pointers and the call stack made visible — and even pthreads concurrency.</p>
  </a>

  <a class="vz-card" href="<%=request.getContextPath()%>/online-go-compiler/">
    <div class="vz-card-head"><div class="vz-badge" style="background:linear-gradient(135deg,#00ADD8,#5DC9E2);">Go</div>
      <div><p class="vz-card-name">Go</p><p class="vz-card-tag">slices + escape analysis</p></div></div>
    <p class="vz-card-desc">Visualize slices, maps, structs, trees, and graphs, plus a memory tab showing real escape analysis and slice backing-array aliasing.</p>
  </a>

  <a class="vz-card" href="<%=request.getContextPath()%>/online-rust-compiler/">
    <div class="vz-card-head"><div class="vz-badge" style="background:linear-gradient(135deg,#CE422B,#A33)">Rs</div>
      <div><p class="vz-card-name">Rust</p><p class="vz-card-tag">ownership · Rc/RefCell</p></div></div>
    <p class="vz-card-desc">Step through vectors, trees, and graphs while ownership, borrows, Rc/RefCell sharing, and drop order become visible.</p>
  </a>

  <a class="vz-card" href="<%=request.getContextPath()%>/online-csharp-compiler/">
    <div class="vz-card-head"><div class="vz-badge" style="background:linear-gradient(135deg,#68217A,#9B4F96);">C#</div>
      <div><p class="vz-card-name">C#</p><p class="vz-card-tag">List/Dict + threads</p></div></div>
    <p class="vz-card-desc">Visualize List, Dictionary, HashSet, Stack, Queue, 2D arrays, and trees, with recursion and threads/locks shown step by step.</p>
  </a>

  <a class="vz-card" href="<%=request.getContextPath()%>/online-lua-compiler/">
    <div class="vz-card-head"><div class="vz-badge" style="background:linear-gradient(135deg,#000080,#3355CC);">Lua</div>
      <div><p class="vz-card-name">Lua</p><p class="vz-card-tag">tables · call stack</p></div></div>
    <p class="vz-card-desc">Watch tables render as arrays, 2D grids, and maps — plus linked lists, trees, and graphs — with reads highlighted on each line.</p>
  </a>

</div>

<h2 class="vz-h2">What you can visualize</h2>
<p class="vz-sub">The same data structures and algorithms across every language.</p>
<div class="vz-concepts">
  <div class="vz-concept"><h3>Arrays &amp; matrices</h3><p>1D arrays and 2D grids with each read and write highlighted — perfect for sorting and dynamic programming.</p></div>
  <div class="vz-concept"><h3>Linked lists &amp; trees</h3><p>Nodes and pointers drawn as a diagram that rewires itself as you insert, delete, and traverse.</p></div>
  <div class="vz-concept"><h3>Graphs (BFS / DFS)</h3><p>Vertices and edges laid out visually so you can follow breadth-first and depth-first traversals node by node.</p></div>
  <div class="vz-concept"><h3>Recursion &amp; call stack</h3><p>Each call pushes a frame and each return pops one, so recursion and backtracking are easy to follow.</p></div>
  <div class="vz-concept"><h3>Hash maps, sets &amp; queues</h3><p>Dictionaries, sets, stacks, and queues update live as keys are added, looked up, and removed.</p></div>
  <div class="vz-concept"><h3>Memory: stack &amp; heap</h3><p>For C, C++, Go, and Python — real stack frames, heap allocations, and pointer/reference arrows.</p></div>
</div>

<h2 class="vz-h2">How it works</h2>
<div class="vz-steps">
  <div class="vz-step"><h3>Write or paste your code</h3><p>Start from an example or type your own program in any of the 8 supported languages.</p></div>
  <div class="vz-step"><h3>Click Visualize</h3><p>Run in step mode instead of plain output — the compiler records every line as it executes.</p></div>
  <div class="vz-step"><h3>Step through execution</h3><p>Move next and previous to watch data structures, memory, and the call stack update at each line.</p></div>
</div>

<h2 class="vz-h2">Frequently asked questions</h2>
<div class="vz-faq">
  <details open><summary>What is the online algorithm visualizer?</summary><p>A free browser-based tool that runs your code line by line and animates what happens in memory — arrays, linked lists, trees, graphs, hash maps, recursion, and the call stack update visually as each statement executes. It works for 8 languages with no installation or signup.</p></details>
  <details><summary>Is this a Python Tutor alternative?</summary><p>Yes. Like Python Tutor, it steps through your code and shows variables, references, and data structures as they change — but it supports 8 languages (not just Python), animates linked lists, trees, and graphs, and shows a real memory view with stack frames and heap for C, C++, Go, and Python.</p></details>
  <details><summary>Which languages can I visualize?</summary><p>Python, Java, C, C++, Go, Rust, Lua, and C#. Each has a dedicated online compiler with a built-in Visualize button.</p></details>
  <details><summary>What data structures and algorithms can I visualize?</summary><p>Arrays and 2D matrices, strings, linked lists, trees, graphs, hash maps, sets, stacks, and queues — covering sorting, binary search, two-pointer techniques, recursion, BFS/DFS, and linked-list operations, each shown step by step.</p></details>
  <details><summary>Does it show memory, stack, and heap?</summary><p>Yes for C, C++, Go, and Python. The memory view shows stack frames, heap allocations, and pointer or reference arrows using real execution data.</p></details>
  <details><summary>Is it free?</summary><p>Completely free with no signup. Every language visualizer runs in your browser.</p></details>
</div>

<div class="ad-vz" style="margin-top:26px;opacity:0;transition:opacity .4s;" id="ad_viz_below"><div class="ad-label">Advertisement</div></div>

<div class="vz-related">
  <span>Also try &rarr;</span>
  <a href="<%=request.getContextPath()%>/online-python-compiler/">Python Compiler</a>
  <a href="<%=request.getContextPath()%>/online-java-compiler/">Java Compiler</a>
  <a href="<%=request.getContextPath()%>/tutorials/dsa/">DSA Tutorials</a>
  <a href="<%=request.getContextPath()%>/electronics/logic-simulator.jsp">Logic Gate Simulator</a>
</div>

</div>

<script>
(function(){
  if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_viz_hero')});
  var below=document.getElementById('ad_viz_below');
  if(below&&'IntersectionObserver'in window){
    var obs=new IntersectionObserver(function(e){e.forEach(function(en){if(en.isIntersecting){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_viz_below');below.style.opacity='1'});obs.unobserve(below)}})},{rootMargin:'200px'});
    obs.observe(below);
  }
})();
</script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>

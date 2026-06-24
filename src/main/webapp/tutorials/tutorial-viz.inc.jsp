<%-- Inline algorithm-visualizer assets for tutorials.
     Include once before </body> on any tutorial page that has a code block with
     data-viz-lang="go|python|java". Adds a "Visualize" button that animates the code. --%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/viz-workspace.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-viz.css">
<script>window.OC_VIZ_BASE = '<%=request.getContextPath()%>/OneCompilerVizFunctionality';</script>
<script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-api.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-parser.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-render.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-concurrency.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-player.js"></script>
<script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-viz.js"></script>

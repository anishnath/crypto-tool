<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- Critical CSS -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
    </style>

    <!-- SEO -->
    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Neural Network Architecture SVG Visualizer Online Free" />
        <jsp:param name="toolDescription" value="Create publication-ready neural network architecture diagrams. Visualize FCNN, CNN (LeNet), and deep networks (AlexNet) in 2D and 3D. Export as SVG. Free, no signup." />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolUrl" value="ml/nn-viz.jsp" />
        <jsp:param name="toolKeywords" value="neural network diagram, nn architecture visualizer, neural network svg, FCNN diagram, CNN architecture, LeNet visualizer, AlexNet 3D, deep learning diagram, network schematic, publication neural network, ml architecture tool" />
        <jsp:param name="toolFeatures" value="Three visualization modes: FCNN LeNet AlexNet,Publication-ready SVG export,Interactive zoom and pan,Customizable colors and styles,Dynamic layer add/remove,3D CNN visualization with Three.js,Dark mode support,No signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Mode|Select FCNN for fully-connected networks or LeNet for 2D CNN or AlexNet for 3D CNN visualization,Configure Architecture|Add or remove layers and set node counts or filter dimensions using the controls panel,Style and Export|Customize colors and spacing then click Download SVG to export a publication-ready diagram" />
        <jsp:param name="faq1q" value="What neural network types can I visualize?" />
        <jsp:param name="faq1a" value="Three types: Fully-Connected Neural Networks (FCNN) with nodes and weighted edges, Convolutional Neural Networks in 2D (LeNet style) with feature maps and filters, and Deep CNNs in 3D (AlexNet style) with volumetric layers and receptive field pyramids." />
        <jsp:param name="faq2q" value="Can I export the diagram?" />
        <jsp:param name="faq2a" value="Yes. Click Download SVG to get a scalable vector graphic suitable for papers, slides, and websites. The AlexNet 3D mode exports as PNG." />
        <jsp:param name="faq3q" value="Is this free?" />
        <jsp:param name="faq3a" value="Completely free with no signup required. All visualization, customization, and export features are available immediately." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/nn-viz.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body>

    <!-- Navigation -->
    <%@ include file="../modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Neural Network Architecture SVG Visualizer</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#ml">Machine Learning</a> /
                    NN Architecture Visualizer
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">FCNN</span>
                <span class="tool-badge">CNN 2D</span>
                <span class="tool-badge">CNN 3D</span>
                <span class="tool-badge">SVG Export</span>
            </div>
        </div>
    </header>

    <!-- Tool Description + Ad Section -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Create publication-ready neural network architecture diagrams. Three visualization modes: fully-connected networks (FCNN), convolutional networks in 2D (LeNet), and deep networks in 3D (AlexNet). Export as SVG or PNG.</p>
            </div>
            <div class="tool-description-ad">
                <%@ include file="../modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <!-- Main Tool -->
    <div class="nn-svg-app" style="max-width:1600px;margin:0 auto;padding:0 1.5rem;">

        <!-- Tab bar -->
        <div class="nn-tabs">
            <button class="nn-tab-btn active" data-tab="fcnn">FCNN (Fully Connected)</button>
            <button class="nn-tab-btn" data-tab="lenet">LeNet (CNN 2D)</button>
            <button class="nn-tab-btn" data-tab="alexnet">AlexNet (CNN 3D)</button>
        </div>

        <div class="nn-layout">

            <!-- Controls column -->
            <div class="nn-controls">

                <!-- Preset selector -->
                <div class="nn-preset-bar">
                    <label for="nn-preset">Preset:</label>
                    <select id="nn-preset"><option value="">Custom</option></select>
                </div>

                <!-- Action bar -->
                <div class="nn-action-bar">
                    <button class="nn-play-btn" id="nn-play-btn" onclick="nnPlay()"><span class="nn-play-icon">&#9654;</span> Forward Pass</button>
                    <button class="nn-download-btn" onclick="nnDownload()">Download SVG</button>
                    <button class="nn-record-btn" id="nn-record-btn" onclick="nnRecord()"><span class="nn-rec-dot"></span> Record GIF</button>
                </div>
                <div class="nn-gif-status" id="nn-gif-status" style="display:none;"></div>

                <!-- Animation mode + controls -->
                <div class="nn-anim-controls">
                    <div class="nn-ctrl-row">
                        <label for="nn-anim-mode">Animation</label>
                        <select id="nn-anim-mode">
                            <option value="forward">Forward Pass</option>
                            <option value="backprop">Forward + Backprop</option>
                            <option value="training">Training Loop</option>
                            <option value="dropout">Dropout</option>
                        </select>
                    </div>
                    <div class="nn-ctrl-row">
                        <label for="nn-speed">Speed</label>
                        <input type="range" id="nn-speed" min="0.25" max="3" step="0.25" value="1">
                    </div>
                    <div class="nn-ctrl-row">
                        <input type="checkbox" id="nn-loop"><label for="nn-loop">Loop</label>
                    </div>
                    <div class="nn-ctrl-row">
                        <input type="checkbox" id="nn-heatmap"><label for="nn-heatmap">Activation heatmap</label>
                    </div>
                    <div class="nn-ctrl-row nn-dropout-row" style="display:none;">
                        <label for="nn-dropout-rate">Drop rate</label>
                        <input type="range" id="nn-dropout-rate" min="0.1" max="0.8" step="0.05" value="0.3">
                    </div>
                    <div class="nn-ctrl-row nn-training-row" style="display:none;">
                        <label for="nn-epochs">Epochs</label>
                        <input type="number" id="nn-epochs" min="1" max="100" value="10" style="width:60px;">
                    </div>
                </div>

                <!-- Training status -->
                <div class="nn-training-status" id="nn-training-status" style="display:none;"></div>

                <!-- ══════════ FCNN Controls ══════════ -->
                <div id="controls-fcnn" class="nn-tab-panel active">

                    <div class="nn-ctrl-section">
                        <h5>Edge Style</h5>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="fcnn-edgeWidthProp"><label for="fcnn-edgeWidthProp">Width ~ weight</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="fcnn-edgeWidth">Width</label>
                            <input type="range" id="fcnn-edgeWidth" min="0" max="2" step="0.01" value="0.5">
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="fcnn-edgeOpacityProp"><label for="fcnn-edgeOpacityProp">Opacity ~ weight</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="fcnn-edgeOpacity">Opacity</label>
                            <input type="range" id="fcnn-edgeOpacity" min="0" max="1" step="0.01" value="1">
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="fcnn-edgeColorProp"><label for="fcnn-edgeColorProp">Color ~ weight</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="color" id="fcnn-negativeColor" value="#0000ff"><label for="fcnn-negativeColor">Negative</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="color" id="fcnn-positiveColor" value="#ff0000"><label for="fcnn-positiveColor">Positive</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="color" id="fcnn-defaultColor" value="#505050"><label for="fcnn-defaultColor">Default</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="fcnn-bezier"><label for="fcnn-bezier">Bezier curves</label>
                        </div>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Node Style</h5>
                        <div class="nn-ctrl-row">
                            <label for="fcnn-nodeDiameter">Diameter</label>
                            <input type="range" id="fcnn-nodeDiameter" min="10" max="50" step="1" value="20">
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="color" id="fcnn-nodeColor" value="#ffffff"><label for="fcnn-nodeColor">Fill</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="color" id="fcnn-nodeBorderColor" value="#333333"><label for="fcnn-nodeBorderColor">Border</label>
                        </div>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Layout</h5>
                        <div class="nn-ctrl-row">
                            <label for="fcnn-betweenLayers">Layer spacing</label>
                            <input type="range" id="fcnn-betweenLayers" min="30" max="400" step="1" value="160">
                        </div>
                        <div class="nn-ctrl-row">
                            <label>Direction</label>
                            <label><input type="radio" name="fcnn-direction" value="right" checked> H</label>
                            <label><input type="radio" name="fcnn-direction" value="up"> V</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="fcnn-showBias"><label for="fcnn-showBias">Bias units</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="fcnn-showLabels" checked><label for="fcnn-showLabels">Labels</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="fcnn-showArrowheads"><label for="fcnn-showArrowheads">Arrowheads</label>
                            <label><input type="radio" name="fcnn-arrowStyle" value="empty" checked> empty</label>
                            <label><input type="radio" name="fcnn-arrowStyle" value="solid"> solid</label>
                        </div>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Architecture</h5>
                        <div id="fcnn-arch">
                            <div class="nn-arch-row">
                                <button class="nn-arch-btn nn-arch-btn-remove">&minus;</button>
                                <input type="number" name="fcnn-nodes" value="16" min="1" max="50">
                                <input type="range" name="fcnn-spacing" min="0" max="100" step="1" value="20">
                            </div>
                            <div class="nn-arch-row">
                                <button class="nn-arch-btn nn-arch-btn-remove">&minus;</button>
                                <input type="number" name="fcnn-nodes" value="12" min="1" max="50">
                                <input type="range" name="fcnn-spacing" min="0" max="100" step="1" value="20">
                            </div>
                            <div class="nn-arch-row">
                                <button class="nn-arch-btn nn-arch-btn-remove">&minus;</button>
                                <input type="number" name="fcnn-nodes" value="10" min="1" max="50">
                                <input type="range" name="fcnn-spacing" min="0" max="100" step="1" value="20">
                            </div>
                            <div class="nn-arch-row">
                                <button class="nn-arch-btn nn-arch-btn-add">+</button>
                                <input type="number" name="fcnn-nodes" value="1" min="1" max="50">
                                <input type="range" name="fcnn-spacing" min="0" max="100" step="1" value="20">
                            </div>
                        </div>
                        <button style="margin-top:0.5rem;padding:0.3rem 0.8rem;font-size:0.8rem;border:1px solid #e2e8f0;border-radius:4px;background:#f8fafc;cursor:pointer;" id="fcnn-newWeights">New Random Weights</button>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Skip Connections (ResNet)</h5>
                        <div id="fcnn-skip-list"></div>
                        <div class="nn-ctrl-row" style="margin-top:0.3rem;">
                            <label for="fcnn-skip-from" style="min-width:auto;">From layer</label>
                            <input type="number" id="fcnn-skip-from" value="0" min="0" style="width:48px;">
                            <label for="fcnn-skip-to" style="min-width:auto;">to</label>
                            <input type="number" id="fcnn-skip-to" value="2" min="1" style="width:48px;">
                            <button class="nn-arch-btn nn-arch-btn-add" id="fcnn-skip-add" title="Add skip connection">+</button>
                        </div>
                    </div>
                </div>

                <!-- ══════════ LeNet Controls ══════════ -->
                <div id="controls-lenet" class="nn-tab-panel">

                    <div class="nn-ctrl-section">
                        <h5>Style</h5>
                        <div class="nn-ctrl-row">
                            <input type="color" id="lenet-color1" value="#e0e0e0"><label for="lenet-color1">Color 1</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="color" id="lenet-color2" value="#a0a0a0"><label for="lenet-color2">Color 2</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="lenet-borderWidth">Border</label>
                            <input type="range" id="lenet-borderWidth" min="0" max="4" step="0.1" value="1">
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="lenet-opacity">Opacity</label>
                            <input type="range" id="lenet-opacity" min="0" max="1" step="0.05" value="0.8">
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="lenet-showLabels" checked><label for="lenet-showLabels">Labels</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="lenet-betweenSquares">Spacing</label>
                            <input type="range" id="lenet-betweenSquares" min="0" max="30" step="1" value="8">
                        </div>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Conv Layers</h5>
                        <div style="font-size:0.75rem;color:#888;margin-bottom:0.3rem;">Filters | H | W | fH | fW</div>
                        <div id="lenet-arch">
                            <div class="nn-arch-row">
                                <input type="number" name="lenet-n" value="1" min="1" max="64" style="width:45px">
                                <input type="number" name="lenet-h" value="28" min="1" style="width:45px">
                                <input type="number" name="lenet-w" value="28" min="1" style="width:45px">
                                <input type="number" name="lenet-fh" value="5" min="1" style="width:40px">
                                <input type="number" name="lenet-fw" value="5" min="1" style="width:40px">
                                <select name="lenet-op" style="width:60px;font-size:0.75rem"><option>Convolution</option><option>Max-Pool</option></select>
                            </div>
                            <div class="nn-arch-row">
                                <input type="number" name="lenet-n" value="6" min="1" max="64" style="width:45px">
                                <input type="number" name="lenet-h" value="24" min="1" style="width:45px">
                                <input type="number" name="lenet-w" value="24" min="1" style="width:45px">
                                <input type="number" name="lenet-fh" value="2" min="1" style="width:40px">
                                <input type="number" name="lenet-fw" value="2" min="1" style="width:40px">
                                <select name="lenet-op" style="width:60px;font-size:0.75rem"><option>Convolution</option><option selected>Max-Pool</option></select>
                            </div>
                            <div class="nn-arch-row">
                                <input type="number" name="lenet-n" value="16" min="1" max="64" style="width:45px">
                                <input type="number" name="lenet-h" value="8" min="1" style="width:45px">
                                <input type="number" name="lenet-w" value="8" min="1" style="width:45px">
                                <input type="number" name="lenet-fh" value="5" min="1" style="width:40px">
                                <input type="number" name="lenet-fw" value="5" min="1" style="width:40px">
                                <select name="lenet-op" style="width:60px;font-size:0.75rem"><option selected>Convolution</option><option>Max-Pool</option></select>
                            </div>
                        </div>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Dense Layers</h5>
                        <div id="lenet-fc">
                            <div class="nn-arch-row">
                                <input type="number" name="lenet-fc-size" value="120" min="1">
                            </div>
                            <div class="nn-arch-row">
                                <input type="number" name="lenet-fc-size" value="84" min="1">
                            </div>
                            <div class="nn-arch-row">
                                <input type="number" name="lenet-fc-size" value="10" min="1">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ══════════ AlexNet Controls ══════════ -->
                <div id="controls-alexnet" class="nn-tab-panel">

                    <div class="nn-ctrl-section">
                        <h5>Style</h5>
                        <div class="nn-ctrl-row">
                            <input type="color" id="alexnet-color1" value="#eeeeee"><label for="alexnet-color1">Layer</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="color" id="alexnet-color2" value="#99ddff"><label for="alexnet-color2">Filter</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="color" id="alexnet-color3" value="#ffbbbb"><label for="alexnet-color3">Pyramid</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="alexnet-rectOpacity">Layer opacity</label>
                            <input type="range" id="alexnet-rectOpacity" min="0" max="1" step="0.05" value="0.4">
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="alexnet-filterOpacity">Filter opacity</label>
                            <input type="range" id="alexnet-filterOpacity" min="0" max="1" step="0.05" value="0.4">
                        </div>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Scale</h5>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="alexnet-logDepth" checked><label for="alexnet-logDepth">Log depth</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="alexnet-depthScale">Depth scale</label>
                            <input type="range" id="alexnet-depthScale" min="1" max="30" step="0.5" value="10">
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="alexnet-logWidth" checked><label for="alexnet-logWidth">Log width</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="alexnet-widthScale">Width scale</label>
                            <input type="range" id="alexnet-widthScale" min="1" max="30" step="0.5" value="10">
                        </div>
                        <div class="nn-ctrl-row">
                            <label for="alexnet-betweenLayers">Layer gap</label>
                            <input type="range" id="alexnet-betweenLayers" min="5" max="60" step="1" value="20">
                        </div>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Dimensions</h5>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="alexnet-showDims"><label for="alexnet-showDims">Tensor dims</label>
                        </div>
                        <div class="nn-ctrl-row">
                            <input type="checkbox" id="alexnet-showConvDims"><label for="alexnet-showConvDims">Conv dims</label>
                        </div>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Conv Layers</h5>
                        <div style="font-size:0.75rem;color:#888;margin-bottom:0.3rem;">H | W | Depth | fH | fW</div>
                        <div id="alexnet-arch">
                            <div class="nn-arch-row">
                                <input type="number" name="alexnet-h" value="227" min="1" style="width:50px">
                                <input type="number" name="alexnet-w" value="227" min="1" style="width:50px">
                                <input type="number" name="alexnet-d" value="3" min="1" style="width:45px">
                                <input type="number" name="alexnet-fh" value="11" min="1" style="width:40px">
                                <input type="number" name="alexnet-fw" value="11" min="1" style="width:40px">
                            </div>
                            <div class="nn-arch-row">
                                <input type="number" name="alexnet-h" value="55" min="1" style="width:50px">
                                <input type="number" name="alexnet-w" value="55" min="1" style="width:50px">
                                <input type="number" name="alexnet-d" value="64" min="1" style="width:45px">
                                <input type="number" name="alexnet-fh" value="5" min="1" style="width:40px">
                                <input type="number" name="alexnet-fw" value="5" min="1" style="width:40px">
                            </div>
                            <div class="nn-arch-row">
                                <input type="number" name="alexnet-h" value="27" min="1" style="width:50px">
                                <input type="number" name="alexnet-w" value="27" min="1" style="width:50px">
                                <input type="number" name="alexnet-d" value="192" min="1" style="width:45px">
                                <input type="number" name="alexnet-fh" value="3" min="1" style="width:40px">
                                <input type="number" name="alexnet-fw" value="3" min="1" style="width:40px">
                            </div>
                        </div>
                    </div>

                    <div class="nn-ctrl-section">
                        <h5>Dense Layers</h5>
                        <div id="alexnet-fc">
                            <div class="nn-arch-row">
                                <input type="number" name="alexnet-fc-size" value="4096" min="1">
                            </div>
                            <div class="nn-arch-row">
                                <input type="number" name="alexnet-fc-size" value="4096" min="1">
                            </div>
                            <div class="nn-arch-row">
                                <input type="number" name="alexnet-fc-size" value="1000" min="1">
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Canvas -->
            <div class="nn-canvas-wrap" id="nn-graph-container"></div>

        </div>

        <div class="nn-status" id="nn-status"></div>

    </div>

    <!-- In-Content Ad (All Devices) -->
    <div style="max-width:1600px;margin:1rem auto;padding:0 1.5rem;">
        <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="/modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="ml/nn-viz.jsp"/>
        <jsp:param name="category" value="Machine Learning"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- Support Section -->
    <%@ include file="../modern/components/support-section.jsp" %>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
            <div style="margin-top:0.5rem;font-size:0.75rem;color:#94a3b8;">
                Inspired by <a href="https://github.com/zfrenchee/NN-SVG" target="_blank" rel="noopener" style="color:#94a3b8;">NN-SVG</a> by Alexander LeNail (JOSS, 2019).
            </div>
        </div>
    </footer>

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="../modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>

    <!-- D3.js v7 -->
    <script src="https://d3js.org/d3.v7.min.js" defer></script>

    <!-- Tool scripts -->
    <script src="<%=request.getContextPath()%>/ml/js/util.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/ml/js/fcnn.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/ml/js/lenet.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/ml/js/alexnet.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/ml/js/export.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/ml/js/presets.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/ml/js/gif-export.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/ml/js/animation.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/ml/js/controls.js?v=<%=cacheVersion%>" defer></script>

</body>
</html>

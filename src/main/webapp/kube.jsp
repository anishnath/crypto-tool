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
    <link rel="dns-prefetch" href="https://code.jquery.com">

    <!-- Critical CSS -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root{--primary:#326ce5;--primary-dark:#1d4ed8;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Kubernetes YAML Generator Online Free - K8s Manifest Builder" />
        <jsp:param name="toolDescription" value="Free Kubernetes YAML generator online. Create Deployments, Pods, Services, ConfigMaps, Secrets, Jobs, CronJobs & StatefulSets instantly. Live preview, copy & download. No signup required." />
        <jsp:param name="toolCategory" value="DevOps" />
        <jsp:param name="toolUrl" value="kube.jsp" />
        <jsp:param name="toolKeywords" value="kubernetes yaml generator, k8s yaml generator online, kubernetes manifest generator, kubernetes deployment yaml generator, kubectl yaml generator, k8s config generator, kubernetes service yaml, kubernetes pod yaml, configmap generator, kubernetes secret generator, statefulset yaml, cronjob yaml kubernetes, kubernetes job yaml, helm alternative, k8s yaml online, kubernetes yaml builder, free kubernetes tool, yaml generator online, k8s deployment generator, kubernetes yaml creator" />
        <jsp:param name="toolImage" value="kube.png" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a Kubernetes YAML generator?" />
        <jsp:param name="faq1a" value="A Kubernetes YAML generator creates properly formatted manifest files for K8s resources like Deployments, Pods, Services, and ConfigMaps without manual coding." />
        <jsp:param name="faq2q" value="Is this Kubernetes YAML generator free?" />
        <jsp:param name="faq2a" value="Yes, completely free with no registration required. All processing happens in your browser for security." />
        <jsp:param name="faq3q" value="What Kubernetes resources can I generate?" />
        <jsp:param name="faq3a" value="Deployments, Pods, Services, StatefulSets, Jobs, CronJobs, ConfigMaps, and Secrets with full configuration options." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

    <style>
        /* Kubernetes-specific theme variables */
        :root {
            --tool-primary: #326ce5;
            --tool-primary-dark: #1d4ed8;
            --tool-gradient: linear-gradient(135deg, #326ce5 0%, #1d4ed8 100%);
            --tool-light: #eff6ff;
            --kube-gradient: var(--tool-gradient);
            --kube-light: var(--tool-light);
        }

        [data-theme="dark"] {
            --tool-gradient: linear-gradient(135deg, #4f7fdb 0%, #3b6fd1 100%);
            --tool-light: rgba(50, 108, 229, 0.15);
            --kube-gradient: var(--tool-gradient);
            --kube-light: var(--tool-light);
        }

        /* YAML Syntax Highlighting */
        .tool-output-pre .yaml-key { color: #7dd3fc; }
        .tool-output-pre .yaml-value { color: #fde68a; }
        .tool-output-pre .yaml-string { color: #86efac; }
        .tool-output-pre .yaml-number { color: #c4b5fd; }
        .tool-output-pre .yaml-comment { color: #64748b; font-style: italic; }
        .tool-output-pre .yaml-boolean { color: #f472b6; }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Kubernetes YAML Generator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/devops.jsp">DevOps</a> /
                    Kubernetes Generator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">K8s v1.28+</span>
                <span class="tool-badge">YAML & JSON</span>
                <span class="tool-badge">Live Preview</span>
            </div>
        </div>
    </header>

    <!-- Tool Description + Ad Section -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Generate production-ready Kubernetes manifests instantly. Create Deployments, Services, ConfigMaps, Secrets, Jobs, CronJobs, and StatefulSets with live YAML/JSON preview. Use presets for popular stacks like nginx, Redis, and PostgreSQL.</p>
            </div>
            <div class="tool-description-ad">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="tool-page-container">
        <!-- ========== INPUT COLUMN ========== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <!-- Resource Type Tabs -->
                <div class="tool-tabs" role="tablist">
                    <button class="tool-tab active" data-resource="deployment" role="tab">Deployment</button>
                    <button class="tool-tab" data-resource="pod" role="tab">Pod</button>
                    <button class="tool-tab" data-resource="service" role="tab">Service</button>
                    <button class="tool-tab" data-resource="statefulset" role="tab">StatefulSet</button>
                    <button class="tool-tab" data-resource="job" role="tab">Job</button>
                    <button class="tool-tab" data-resource="cronjob" role="tab">CronJob</button>
                    <button class="tool-tab" data-resource="configmap" role="tab">ConfigMap</button>
                    <button class="tool-tab" data-resource="secret" role="tab">Secret</button>
                </div>

                <!-- Template Presets -->
                <div class="tool-presets" id="presetsBar">
                    <button class="tool-preset-btn" data-preset="nginx-prod">Nginx</button>
                    <button class="tool-preset-btn" data-preset="node-api">Node.js API</button>
                    <button class="tool-preset-btn" data-preset="python-api">Python API</button>
                    <button class="tool-preset-btn" data-preset="go-api">Go API</button>
                    <button class="tool-preset-btn" data-preset="redis-prod">Redis</button>
                    <button class="tool-preset-btn" data-preset="postgres-prod">PostgreSQL</button>
                    <button class="tool-preset-btn" data-preset="mongodb">MongoDB</button>
                    <button class="tool-preset-btn" data-preset="elasticsearch">Elasticsearch</button>
                </div>

                <div class="tool-card-body">
                    <!-- Hidden fields for form submission -->
                    <input type="hidden" id="resourceType" value="deployment">
                    <input type="hidden" id="labelData" name="label">
                    <input type="hidden" id="annotationData" name="annotation">
                    <input type="hidden" id="envData" name="environment">

                    <!-- ========== DEPLOYMENT/POD FORM ========== -->
                    <div id="formDeployment" class="tool-resource-form">
                        <div class="tool-section">
                            <div class="tool-section-header" onclick="toggleSection(this)">
                                <span>Basic Configuration</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content">
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Name</label>
                                        <input type="text" class="tool-input" id="name" placeholder="my-app" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Namespace</label>
                                        <input type="text" class="tool-input" id="namespace" value="default" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Image <span class="required">*</span></label>
                                        <input type="text" class="tool-input" id="image" placeholder="nginx:latest" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Replicas</label>
                                        <input type="number" class="tool-input" id="replicas" value="1" min="1" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Container Ports</label>
                                    <input type="text" class="tool-input" id="containerPorts" placeholder="80, 443" oninput="updatePreview()">
                                    <span class="tool-form-hint">Comma-separated port numbers</span>
                                </div>
                            </div>
                        </div>

                        <div class="tool-section">
                            <div class="tool-section-header collapsed" onclick="toggleSection(this)">
                                <span>Labels & Annotations</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content hidden">
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Labels</label>
                                    <div class="kv-container" id="labelsContainer">
                                        <div class="kv-pair">
                                            <input type="text" class="kv-key" placeholder="Key" value="app" oninput="updatePreview()">
                                            <input type="text" class="kv-value" placeholder="Value" value="myapp" oninput="updatePreview()">
                                            <button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-add-kv" onclick="addKVPair('labelsContainer')">+ Add</button>
                                </div>
                            </div>
                        </div>

                        <div class="tool-section">
                            <div class="tool-section-header collapsed" onclick="toggleSection(this)">
                                <span>Resources</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content hidden">
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">CPU Request</label>
                                        <input type="text" class="tool-input" id="cpuRequest" placeholder="100m" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">CPU Limit</label>
                                        <input type="text" class="tool-input" id="cpuLimit" placeholder="500m" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Memory Request</label>
                                        <input type="text" class="tool-input" id="memoryRequest" placeholder="128Mi" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Memory Limit</label>
                                        <input type="text" class="tool-input" id="memoryLimit" placeholder="512Mi" oninput="updatePreview()">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tool-section">
                            <div class="tool-section-header collapsed" onclick="toggleSection(this)">
                                <span>Environment Variables</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content hidden">
                                <div class="kv-container" id="envContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="kv-key" placeholder="Key" oninput="updatePreview()">
                                        <input type="text" class="kv-value" placeholder="Value" oninput="updatePreview()">
                                        <button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>
                                    </div>
                                </div>
                                <button type="button" class="btn-add-kv" onclick="addKVPair('envContainer')">+ Add</button>
                            </div>
                        </div>

                        <div class="tool-section">
                            <div class="tool-section-header collapsed" onclick="toggleSection(this)">
                                <span>Health Checks</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content hidden">
                                <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.5rem;">Liveness Probe</p>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Path</label>
                                        <input type="text" class="tool-input" id="livenessPath" placeholder="/healthz" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Port</label>
                                        <input type="text" class="tool-input" id="livenessPort" placeholder="8080" oninput="updatePreview()">
                                    </div>
                                </div>
                                <p style="font-size: 0.75rem; color: var(--text-secondary); margin: 0.75rem 0 0.5rem;">Readiness Probe</p>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Path</label>
                                        <input type="text" class="tool-input" id="readinessPath" placeholder="/ready" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Port</label>
                                        <input type="text" class="tool-input" id="readinessPort" placeholder="8080" oninput="updatePreview()">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tool-section">
                            <div class="tool-section-header collapsed" onclick="toggleSection(this)">
                                <span>Security Context</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content hidden">
                                <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.5rem;">Pod Security Context</p>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Run As User</label>
                                        <input type="number" class="tool-input" id="runAsUser" placeholder="1000" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Run As Group</label>
                                        <input type="number" class="tool-input" id="runAsGroup" placeholder="1000" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">FS Group</label>
                                        <input type="number" class="tool-input" id="fsGroup" placeholder="2000" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">
                                            <input type="checkbox" id="runAsNonRoot" onchange="updatePreview()"> Run As Non-Root
                                        </label>
                                    </div>
                                </div>
                                <p style="font-size: 0.75rem; color: var(--text-secondary); margin: 0.75rem 0 0.5rem;">Container Security Context</p>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">
                                            <input type="checkbox" id="privileged" onchange="updatePreview()"> Privileged
                                        </label>
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">
                                            <input type="checkbox" id="readOnlyRootFs" onchange="updatePreview()"> Read-Only Root FS
                                        </label>
                                    </div>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">
                                        <input type="checkbox" id="allowPrivilegeEscalation" onchange="updatePreview()"> Allow Privilege Escalation
                                    </label>
                                </div>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Add Capabilities</label>
                                        <input type="text" class="tool-input" id="capAdd" placeholder="NET_ADMIN, SYS_TIME" oninput="updatePreview()">
                                        <span class="tool-form-hint">Comma-separated</span>
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Drop Capabilities</label>
                                        <input type="text" class="tool-input" id="capDrop" placeholder="ALL" oninput="updatePreview()">
                                        <span class="tool-form-hint">Comma-separated</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tool-section">
                            <div class="tool-section-header collapsed" onclick="toggleSection(this)">
                                <span>Volumes & Mounts</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content hidden">
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Volume Mounts</label>
                                    <div class="kv-container" id="volumeMountsContainer">
                                        <div class="volume-mount-row" style="display: flex; gap: 0.375rem; margin-bottom: 0.375rem; align-items: center; flex-wrap: wrap;">
                                            <select class="tool-select" style="width: 100px;" onchange="updatePreview()">
                                                <option value="emptyDir">EmptyDir</option>
                                                <option value="configMap">ConfigMap</option>
                                                <option value="secret">Secret</option>
                                                <option value="pvc">PVC</option>
                                                <option value="hostPath">HostPath</option>
                                            </select>
                                            <input type="text" class="kv-key" placeholder="Volume Name" style="flex: 1; min-width: 80px;" oninput="updatePreview()">
                                            <input type="text" class="kv-value" placeholder="Mount Path" style="flex: 1; min-width: 100px;" oninput="updatePreview()">
                                            <input type="text" class="kv-extra" placeholder="Source (ConfigMap/Secret/PVC name)" style="flex: 1; min-width: 100px;" oninput="updatePreview()">
                                            <button type="button" class="btn-remove-kv" onclick="removeVolumeMountRow(this)">&#10005;</button>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-add-kv" onclick="addVolumeMountRow()">+ Add Volume</button>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Service Account</label>
                                    <input type="text" class="tool-input" id="serviceAccount" placeholder="default" oninput="updatePreview()">
                                </div>
                            </div>
                        </div>

                        <div class="tool-section">
                            <div class="tool-section-header collapsed" onclick="toggleSection(this)">
                                <span>Scheduling</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content hidden">
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Node Selector</label>
                                    <div class="kv-container" id="nodeSelectorContainer">
                                        <div class="kv-pair">
                                            <input type="text" class="kv-key" placeholder="Key" oninput="updatePreview()">
                                            <input type="text" class="kv-value" placeholder="Value" oninput="updatePreview()">
                                            <button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-add-kv" onclick="addKVPair('nodeSelectorContainer')">+ Add</button>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Tolerations</label>
                                    <div class="kv-container" id="tolerationsContainer">
                                        <div class="toleration-row" style="display: flex; gap: 0.375rem; margin-bottom: 0.375rem; align-items: center; flex-wrap: wrap;">
                                            <input type="text" class="kv-key" placeholder="Key" style="flex: 1; min-width: 60px;" oninput="updatePreview()">
                                            <select class="tool-select" style="width: 80px;" onchange="updatePreview()">
                                                <option value="Equal">Equal</option>
                                                <option value="Exists">Exists</option>
                                            </select>
                                            <input type="text" class="kv-value" placeholder="Value" style="flex: 1; min-width: 60px;" oninput="updatePreview()">
                                            <select class="tool-select" style="width: 100px;" onchange="updatePreview()">
                                                <option value="NoSchedule">NoSchedule</option>
                                                <option value="PreferNoSchedule">PreferNoSchedule</option>
                                                <option value="NoExecute">NoExecute</option>
                                            </select>
                                            <button type="button" class="btn-remove-kv" onclick="removeTolerationRow(this)">&#10005;</button>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-add-kv" onclick="addTolerationRow()">+ Add Toleration</button>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Restart Policy</label>
                                    <select class="tool-select" id="restartPolicy" onchange="updatePreview()">
                                        <option value="">Default (Always)</option>
                                        <option value="Always">Always</option>
                                        <option value="OnFailure">OnFailure</option>
                                        <option value="Never">Never</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========== SERVICE FORM ========== -->
                    <div id="formService" class="tool-resource-form" style="display: none;">
                        <div class="tool-section">
                            <div class="tool-section-header" onclick="toggleSection(this)">
                                <span>Service Configuration</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content">
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Name</label>
                                        <input type="text" class="tool-input" id="svcName" placeholder="my-service" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Namespace</label>
                                        <input type="text" class="tool-input" id="svcNamespace" value="default" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Type</label>
                                    <select class="tool-select" id="svcType" onchange="updatePreview(); toggleServiceFields()">
                                        <option value="ClusterIP">ClusterIP</option>
                                        <option value="NodePort">NodePort</option>
                                        <option value="LoadBalancer">LoadBalancer</option>
                                    </select>
                                </div>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Port</label>
                                        <input type="number" class="tool-input" id="svcPort" placeholder="80" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Target Port</label>
                                        <input type="text" class="tool-input" id="svcTargetPort" placeholder="8080" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-group" id="nodePortField" style="display: none;">
                                    <label class="tool-form-label">Node Port</label>
                                    <input type="number" class="tool-input" id="svcNodePort" placeholder="30000" min="30000" max="32767" oninput="updatePreview()">
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Selector (app label)</label>
                                    <input type="text" class="tool-input" id="svcSelector" placeholder="myapp" oninput="updatePreview()">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========== CONFIGMAP FORM ========== -->
                    <div id="formConfigmap" class="tool-resource-form" style="display: none;">
                        <div class="tool-section">
                            <div class="tool-section-header" onclick="toggleSection(this)">
                                <span>ConfigMap Configuration</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content">
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Name</label>
                                        <input type="text" class="tool-input" id="cmName" placeholder="my-config" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Namespace</label>
                                        <input type="text" class="tool-input" id="cmNamespace" value="default" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Data</label>
                                    <div class="kv-container" id="cmDataContainer">
                                        <div class="kv-pair">
                                            <input type="text" class="kv-key" placeholder="Key" value="APP_ENV" oninput="updatePreview()">
                                            <input type="text" class="kv-value" placeholder="Value" value="production" oninput="updatePreview()">
                                            <button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-add-kv" onclick="addKVPair('cmDataContainer')">+ Add</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========== SECRET FORM ========== -->
                    <div id="formSecret" class="tool-resource-form" style="display: none;">
                        <div class="tool-alert tool-alert-warning">
                            <span>&#9888;</span>
                            <span>Secrets are base64-encoded, not encrypted. Use external secret management in production.</span>
                        </div>
                        <div class="tool-section">
                            <div class="tool-section-header" onclick="toggleSection(this)">
                                <span>Secret Configuration</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content">
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Name</label>
                                        <input type="text" class="tool-input" id="secretName" placeholder="my-secret" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Namespace</label>
                                        <input type="text" class="tool-input" id="secretNamespace" value="default" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Type</label>
                                    <select class="tool-select" id="secretType" onchange="updatePreview()">
                                        <option value="Opaque">Opaque</option>
                                        <option value="kubernetes.io/tls">TLS</option>
                                        <option value="kubernetes.io/dockerconfigjson">Docker Registry</option>
                                    </select>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Data</label>
                                    <div class="kv-container" id="secretDataContainer">
                                        <div class="kv-pair">
                                            <input type="text" class="kv-key" placeholder="Key" value="API_KEY" oninput="updatePreview()">
                                            <input type="text" class="kv-value" placeholder="Value" value="secret-value" oninput="updatePreview()">
                                            <button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-add-kv" onclick="addKVPair('secretDataContainer')">+ Add</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========== JOB FORM ========== -->
                    <div id="formJob" class="tool-resource-form" style="display: none;">
                        <div class="tool-section">
                            <div class="tool-section-header" onclick="toggleSection(this)">
                                <span>Job Configuration</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content">
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Name</label>
                                        <input type="text" class="tool-input" id="jobName" placeholder="my-job" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Namespace</label>
                                        <input type="text" class="tool-input" id="jobNamespace" value="default" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Image <span class="required">*</span></label>
                                    <input type="text" class="tool-input" id="jobImage" placeholder="busybox:latest" oninput="updatePreview()">
                                </div>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Command</label>
                                        <input type="text" class="tool-input" id="jobCommand" placeholder="echo" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Args</label>
                                        <input type="text" class="tool-input" id="jobArgs" placeholder="Hello World" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Completions</label>
                                        <input type="number" class="tool-input" id="jobCompletions" value="1" min="1" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Backoff Limit</label>
                                        <input type="number" class="tool-input" id="jobBackoffLimit" value="6" min="0" oninput="updatePreview()">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========== CRONJOB FORM ========== -->
                    <div id="formCronjob" class="tool-resource-form" style="display: none;">
                        <div class="tool-section">
                            <div class="tool-section-header" onclick="toggleSection(this)">
                                <span>CronJob Configuration</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content">
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Name</label>
                                        <input type="text" class="tool-input" id="cronName" placeholder="my-cronjob" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Namespace</label>
                                        <input type="text" class="tool-input" id="cronNamespace" value="default" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Schedule <span class="required">*</span></label>
                                    <input type="text" class="tool-input" id="cronSchedule" placeholder="*/5 * * * *" oninput="updatePreview()">
                                    <span class="tool-form-hint">Cron format: MIN HOUR DOM MON DOW</span>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Image <span class="required">*</span></label>
                                    <input type="text" class="tool-input" id="cronImage" placeholder="busybox:latest" oninput="updatePreview()">
                                </div>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Command</label>
                                        <input type="text" class="tool-input" id="cronCommand" placeholder="echo" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Args</label>
                                        <input type="text" class="tool-input" id="cronArgs" placeholder="Running task" oninput="updatePreview()">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ========== STATEFULSET FORM ========== -->
                    <div id="formStatefulset" class="tool-resource-form" style="display: none;">
                        <div class="tool-section">
                            <div class="tool-section-header" onclick="toggleSection(this)">
                                <span>StatefulSet Configuration</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content">
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Name</label>
                                        <input type="text" class="tool-input" id="ssName" placeholder="my-statefulset" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Namespace</label>
                                        <input type="text" class="tool-input" id="ssNamespace" value="default" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Image <span class="required">*</span></label>
                                        <input type="text" class="tool-input" id="ssImage" placeholder="nginx:latest" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Replicas</label>
                                        <input type="number" class="tool-input" id="ssReplicas" value="3" min="1" oninput="updatePreview()">
                                    </div>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label">Service Name</label>
                                    <input type="text" class="tool-input" id="ssServiceName" placeholder="my-service" oninput="updatePreview()">
                                    <span class="tool-form-hint">Required headless service name</span>
                                </div>
                            </div>
                        </div>
                        <div class="tool-section">
                            <div class="tool-section-header collapsed" onclick="toggleSection(this)">
                                <span>Volume Claim</span>
                                <span class="chevron">&#9660;</span>
                            </div>
                            <div class="tool-section-content hidden">
                                <div class="tool-form-row">
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Volume Name</label>
                                        <input type="text" class="tool-input" id="ssVolumeName" placeholder="data" oninput="updatePreview()">
                                    </div>
                                    <div class="tool-form-group">
                                        <label class="tool-form-label">Storage Size</label>
                                        <input type="text" class="tool-input" id="ssStorageSize" placeholder="10Gi" oninput="updatePreview()">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Generate Button -->
                    <button type="button" class="tool-action-btn" id="generateBtn" onclick="generateManifest()">
                        Generate & Download
                    </button>
                </div>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <div class="tool-card tool-output-wrapper">
                <!-- Actions Bar -->
                <div class="tool-actions-bar">
                    <div class="tool-format-toggle">
                        <button class="tool-format-btn active" data-format="yaml">YAML</button>
                        <button class="tool-format-btn" data-format="json">JSON</button>
                    </div>
                    <div class="tool-live-indicator">
                        <span class="tool-live-dot"></span>
                        Live Preview
                    </div>
                    <div class="tool-actions-spacer"></div>
                    <button class="tool-btn" id="copyBtn" onclick="copyOutput()" disabled>
                        <span>&#128203;</span> Copy
                    </button>
                    <button class="tool-btn" id="shareBtn" onclick="shareOutput()" disabled>
                        <span>&#128279;</span> Share
                    </button>
                    <button class="tool-btn" id="downloadBtn" onclick="downloadOutput()" disabled>
                        <span>&#8681;</span> Download
                    </button>
                    <button class="tool-btn" onclick="resetForm()">
                        <span>&#8635;</span> Reset
                    </button>
                </div>

                <!-- Status Bar (shown when valid) -->
                <div class="tool-status" id="statusBar" style="display: none;">
                    <span class="tool-status-dot"></span>
                    <span id="statusText">Valid Kubernetes manifest</span>
                </div>

                <!-- Output Area -->
                <div id="outputEmpty" class="tool-empty-state">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                    </svg>
                    <h3>Configure your resource</h3>
                    <p>Fill in the form on the left. YAML preview will appear here as you type.</p>
                </div>
                <pre class="tool-output-pre" id="outputPre" style="display: none;"></pre>
            </div>
        </div>

        <!-- ========== ADS COLUMN ========== -->
        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <!-- In-Content Ad (All Devices) -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="kube.jsp"/>
        <jsp:param name="category" value="DevOps & Infrastructure"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>

    <script>
    // ========== GLOBAL STATE ==========
    var currentFormat = 'yaml';
    var currentResource = 'deployment';
    var currentYaml = '';
    var currentJson = '';
    var updateTimeout = null;

    // ========== PRESETS ==========
    var presets = {
        'nginx-prod': {
            name: 'nginx-web',
            image: 'nginx:1.25-alpine',
            replicas: 3,
            ports: '80, 443',
            labels: {app: 'nginx-web', tier: 'frontend'},
            cpuRequest: '100m',
            cpuLimit: '500m',
            memoryRequest: '128Mi',
            memoryLimit: '256Mi',
            livenessPath: '/healthz',
            livenessPort: '80',
            readinessPath: '/ready',
            readinessPort: '80',
            runAsNonRoot: true,
            readOnlyRootFs: true,
            capDrop: 'ALL',
            volumes: [
                { type: 'configMap', name: 'nginx-config', mountPath: '/etc/nginx/conf.d', source: 'nginx-config' }
            ]
        },
        'redis-prod': {
            name: 'redis-cache',
            image: 'redis:7.2-alpine',
            replicas: 1,
            ports: '6379',
            labels: {app: 'redis-cache', tier: 'cache'},
            cpuRequest: '100m',
            cpuLimit: '250m',
            memoryRequest: '128Mi',
            memoryLimit: '512Mi',
            livenessPath: '',
            livenessPort: '',
            runAsUser: '999',
            runAsGroup: '999',
            runAsNonRoot: true,
            readOnlyRootFs: true,
            capDrop: 'ALL',
            volumes: [
                { type: 'emptyDir', name: 'redis-data', mountPath: '/data', source: '' }
            ],
            env: { REDIS_MAXMEMORY: '256mb', REDIS_MAXMEMORY_POLICY: 'allkeys-lru' }
        },
        'postgres-prod': {
            name: 'postgres-db',
            image: 'postgres:16-alpine',
            replicas: 1,
            ports: '5432',
            labels: {app: 'postgres-db', tier: 'database'},
            cpuRequest: '250m',
            cpuLimit: '1000m',
            memoryRequest: '256Mi',
            memoryLimit: '1Gi',
            runAsUser: '70',
            runAsGroup: '70',
            fsGroup: '70',
            runAsNonRoot: true,
            volumes: [
                { type: 'pvc', name: 'postgres-data', mountPath: '/var/lib/postgresql/data', source: 'postgres-pvc' }
            ],
            env: { POSTGRES_DB: 'appdb', PGDATA: '/var/lib/postgresql/data/pgdata' }
        },
        'node-api': {
            name: 'node-api',
            image: 'node:20-alpine',
            replicas: 3,
            ports: '3000',
            labels: {app: 'node-api', tier: 'backend'},
            cpuRequest: '100m',
            cpuLimit: '500m',
            memoryRequest: '128Mi',
            memoryLimit: '512Mi',
            livenessPath: '/health',
            livenessPort: '3000',
            readinessPath: '/ready',
            readinessPort: '3000',
            runAsUser: '1000',
            runAsGroup: '1000',
            runAsNonRoot: true,
            readOnlyRootFs: true,
            capDrop: 'ALL',
            env: { NODE_ENV: 'production', PORT: '3000' }
        },
        'python-api': {
            name: 'python-api',
            image: 'python:3.12-slim',
            replicas: 3,
            ports: '8000',
            labels: {app: 'python-api', tier: 'backend'},
            cpuRequest: '100m',
            cpuLimit: '500m',
            memoryRequest: '128Mi',
            memoryLimit: '512Mi',
            livenessPath: '/health',
            livenessPort: '8000',
            readinessPath: '/ready',
            readinessPort: '8000',
            runAsUser: '1000',
            runAsGroup: '1000',
            runAsNonRoot: true,
            capDrop: 'ALL',
            env: { PYTHONUNBUFFERED: '1', WORKERS: '4' }
        },
        'go-api': {
            name: 'go-api',
            image: 'golang:1.22-alpine',
            replicas: 3,
            ports: '8080',
            labels: {app: 'go-api', tier: 'backend'},
            cpuRequest: '50m',
            cpuLimit: '200m',
            memoryRequest: '64Mi',
            memoryLimit: '128Mi',
            livenessPath: '/healthz',
            livenessPort: '8080',
            readinessPath: '/readyz',
            readinessPort: '8080',
            runAsUser: '65534',
            runAsGroup: '65534',
            runAsNonRoot: true,
            readOnlyRootFs: true,
            capDrop: 'ALL',
            env: { GIN_MODE: 'release' }
        },
        'mongodb': {
            name: 'mongodb',
            image: 'mongo:7.0',
            replicas: 1,
            ports: '27017',
            labels: {app: 'mongodb', tier: 'database'},
            cpuRequest: '250m',
            cpuLimit: '1000m',
            memoryRequest: '512Mi',
            memoryLimit: '2Gi',
            runAsUser: '999',
            runAsGroup: '999',
            fsGroup: '999',
            volumes: [
                { type: 'pvc', name: 'mongo-data', mountPath: '/data/db', source: 'mongo-pvc' }
            ],
            env: { MONGO_INITDB_DATABASE: 'appdb' }
        },
        'elasticsearch': {
            name: 'elasticsearch',
            image: 'docker.elastic.co/elasticsearch/elasticsearch:8.11.0',
            replicas: 1,
            ports: '9200, 9300',
            labels: {app: 'elasticsearch', tier: 'search'},
            cpuRequest: '500m',
            cpuLimit: '2000m',
            memoryRequest: '1Gi',
            memoryLimit: '2Gi',
            fsGroup: '1000',
            volumes: [
                { type: 'pvc', name: 'es-data', mountPath: '/usr/share/elasticsearch/data', source: 'elasticsearch-pvc' }
            ],
            env: { 'discovery.type': 'single-node', 'xpack.security.enabled': 'false', 'ES_JAVA_OPTS': '-Xms512m -Xmx512m' }
        }
    };

    // ========== UTILITIES ==========
    // Use ToolUtils.showToast for consistency across all tools
    function showToast(msg, type) {
        if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
            ToolUtils.showToast(msg, 2500, type || 'success');
        } else {
            // Fallback if ToolUtils not loaded yet
            var toast = document.createElement('div');
            toast.className = 'tool-toast';
            toast.textContent = msg;
            document.body.appendChild(toast);
            setTimeout(function() {
                toast.style.opacity = '0';
                toast.style.transition = 'opacity 0.3s';
                setTimeout(function() { toast.remove(); }, 300);
            }, 2500);
        }
    }

    function toggleSection(header) {
        header.classList.toggle('collapsed');
        header.nextElementSibling.classList.toggle('hidden');
    }

    function collectKVPairs(containerId) {
        var result = {};
        $('#' + containerId + ' .kv-pair').each(function() {
            var k = $(this).find('.kv-key').val().trim();
            var v = $(this).find('.kv-value').val().trim();
            if (k) result[k] = v;
        });
        return result;
    }

    function addKVPair(containerId) {
        var html = '<div class="kv-pair">' +
            '<input type="text" class="kv-key" placeholder="Key" oninput="updatePreview()">' +
            '<input type="text" class="kv-value" placeholder="Value" oninput="updatePreview()">' +
            '<button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>' +
            '</div>';
        $('#' + containerId).append(html);
    }

    function removeKVPair(el) {
        var container = $(el).closest('.kv-container');
        if (container.find('.kv-pair').length > 1) {
            $(el).closest('.kv-pair').remove();
        } else {
            $(el).closest('.kv-pair').find('input').val('');
        }
        updatePreview();
    }

    // Volume Mounts helpers
    function addVolumeMountRow() {
        var html = '<div class="volume-mount-row" style="display: flex; gap: 0.375rem; margin-bottom: 0.375rem; align-items: center; flex-wrap: wrap;">' +
            '<select class="tool-select" style="width: 100px;" onchange="updatePreview()">' +
            '<option value="emptyDir">EmptyDir</option>' +
            '<option value="configMap">ConfigMap</option>' +
            '<option value="secret">Secret</option>' +
            '<option value="pvc">PVC</option>' +
            '<option value="hostPath">HostPath</option>' +
            '</select>' +
            '<input type="text" class="kv-key" placeholder="Volume Name" style="flex: 1; min-width: 80px;" oninput="updatePreview()">' +
            '<input type="text" class="kv-value" placeholder="Mount Path" style="flex: 1; min-width: 100px;" oninput="updatePreview()">' +
            '<input type="text" class="kv-extra" placeholder="Source (ConfigMap/Secret/PVC name)" style="flex: 1; min-width: 100px;" oninput="updatePreview()">' +
            '<button type="button" class="btn-remove-kv" onclick="removeVolumeMountRow(this)">&#10005;</button>' +
            '</div>';
        $('#volumeMountsContainer').append(html);
    }

    function removeVolumeMountRow(el) {
        var container = $('#volumeMountsContainer');
        if (container.find('.volume-mount-row').length > 1) {
            $(el).closest('.volume-mount-row').remove();
        } else {
            $(el).closest('.volume-mount-row').find('input').val('');
            $(el).closest('.volume-mount-row').find('select').val('emptyDir');
        }
        updatePreview();
    }

    function collectVolumeMounts() {
        var result = [];
        $('#volumeMountsContainer .volume-mount-row').each(function() {
            var type = $(this).find('select').val();
            var name = $(this).find('.kv-key').val().trim();
            var mountPath = $(this).find('.kv-value').val().trim();
            var source = $(this).find('.kv-extra').val().trim();
            if (name && mountPath) {
                result.push({
                    type: type,
                    name: name,
                    mountPath: mountPath,
                    source: source
                });
            }
        });
        return result;
    }

    // Tolerations helpers
    function addTolerationRow() {
        var html = '<div class="toleration-row" style="display: flex; gap: 0.375rem; margin-bottom: 0.375rem; align-items: center; flex-wrap: wrap;">' +
            '<input type="text" class="kv-key" placeholder="Key" style="flex: 1; min-width: 60px;" oninput="updatePreview()">' +
            '<select class="tool-select" style="width: 80px;" onchange="updatePreview()">' +
            '<option value="Equal">Equal</option>' +
            '<option value="Exists">Exists</option>' +
            '</select>' +
            '<input type="text" class="kv-value" placeholder="Value" style="flex: 1; min-width: 60px;" oninput="updatePreview()">' +
            '<select class="tool-select effect-select" style="width: 100px;" onchange="updatePreview()">' +
            '<option value="NoSchedule">NoSchedule</option>' +
            '<option value="PreferNoSchedule">PreferNoSchedule</option>' +
            '<option value="NoExecute">NoExecute</option>' +
            '</select>' +
            '<button type="button" class="btn-remove-kv" onclick="removeTolerationRow(this)">&#10005;</button>' +
            '</div>';
        $('#tolerationsContainer').append(html);
    }

    function removeTolerationRow(el) {
        var container = $('#tolerationsContainer');
        if (container.find('.toleration-row').length > 1) {
            $(el).closest('.toleration-row').remove();
        } else {
            $(el).closest('.toleration-row').find('input').val('');
            $(el).closest('.toleration-row').find('select').first().val('Equal');
            $(el).closest('.toleration-row').find('.effect-select').val('NoSchedule');
        }
        updatePreview();
    }

    function collectTolerations() {
        var result = [];
        $('#tolerationsContainer .toleration-row').each(function() {
            var key = $(this).find('.kv-key').val().trim();
            var operator = $(this).find('select').first().val();
            var value = $(this).find('.kv-value').val().trim();
            var effect = $(this).find('.effect-select').val();
            if (key) {
                result.push({
                    key: key,
                    operator: operator,
                    value: value,
                    effect: effect
                });
            }
        });
        return result;
    }

    function toggleServiceFields() {
        var type = $('#svcType').val();
        $('#nodePortField').toggle(type === 'NodePort' || type === 'LoadBalancer');
    }

    // ========== YAML GENERATION (Client-side) ==========
    function generateYamlPreview() {
        var yaml = '';
        var json = {};

        switch(currentResource) {
            case 'deployment':
            case 'pod':
                yaml = generateDeploymentYaml();
                json = generateDeploymentJson();
                break;
            case 'service':
                yaml = generateServiceYaml();
                json = generateServiceJson();
                break;
            case 'configmap':
                yaml = generateConfigMapYaml();
                json = generateConfigMapJson();
                break;
            case 'secret':
                yaml = generateSecretYaml();
                json = generateSecretJson();
                break;
            case 'job':
                yaml = generateJobYaml();
                json = generateJobJson();
                break;
            case 'cronjob':
                yaml = generateCronJobYaml();
                json = generateCronJobJson();
                break;
            case 'statefulset':
                yaml = generateStatefulSetYaml();
                json = generateStatefulSetJson();
                break;
        }

        currentYaml = yaml;
        currentJson = JSON.stringify(json, null, 2);

        return currentFormat === 'yaml' ? currentYaml : currentJson;
    }

    function generateDeploymentYaml() {
        var name = $('#name').val().trim() || 'my-app';
        var ns = $('#namespace').val().trim() || 'default';
        var image = $('#image').val().trim() || 'nginx:latest';
        var replicas = $('#replicas').val() || '1';
        var ports = $('#containerPorts').val().trim();
        var labels = collectKVPairs('labelsContainer');
        var envVars = collectKVPairs('envContainer');
        var cpuReq = $('#cpuRequest').val().trim();
        var cpuLim = $('#cpuLimit').val().trim();
        var memReq = $('#memoryRequest').val().trim();
        var memLim = $('#memoryLimit').val().trim();
        var livePath = $('#livenessPath').val().trim();
        var livePort = $('#livenessPort').val().trim();
        var readyPath = $('#readinessPath').val().trim();
        var readyPort = $('#readinessPort').val().trim();

        // Security Context
        var runAsUser = $('#runAsUser').val().trim();
        var runAsGroup = $('#runAsGroup').val().trim();
        var fsGroup = $('#fsGroup').val().trim();
        var runAsNonRoot = $('#runAsNonRoot').is(':checked');
        var privileged = $('#privileged').is(':checked');
        var readOnlyRootFs = $('#readOnlyRootFs').is(':checked');
        var allowPrivEsc = $('#allowPrivilegeEscalation').is(':checked');
        var capAdd = $('#capAdd').val().trim();
        var capDrop = $('#capDrop').val().trim();

        // Volumes & Mounts
        var volumeMounts = collectVolumeMounts();
        var serviceAccount = $('#serviceAccount').val().trim();

        // Scheduling
        var nodeSelectors = collectKVPairs('nodeSelectorContainer');
        var tolerations = collectTolerations();
        var restartPolicy = $('#restartPolicy').val();

        var isPod = currentResource === 'pod';
        var kind = isPod ? 'Pod' : 'Deployment';
        var apiVersion = isPod ? 'v1' : 'apps/v1';

        var labelStr = '';
        for (var k in labels) {
            labelStr += '    ' + k + ': ' + labels[k] + '\n';
        }
        if (!labelStr) labelStr = '    app: ' + name + '\n';

        var yaml = 'apiVersion: ' + apiVersion + '\n';
        yaml += 'kind: ' + kind + '\n';
        yaml += 'metadata:\n';
        yaml += '  name: ' + name + '\n';
        yaml += '  namespace: ' + ns + '\n';
        yaml += '  labels:\n' + labelStr;

        var specIndent = isPod ? '  ' : '      ';
        var containerIndent = isPod ? '    ' : '        ';
        var containerPropIndent = isPod ? '      ' : '          ';

        if (!isPod) {
            yaml += 'spec:\n';
            yaml += '  replicas: ' + replicas + '\n';
            yaml += '  selector:\n';
            yaml += '    matchLabels:\n';
            yaml += '      app: ' + name + '\n';
            yaml += '  template:\n';
            yaml += '    metadata:\n';
            yaml += '      labels:\n';
            yaml += '        app: ' + name + '\n';
            yaml += '    spec:\n';
        } else {
            yaml += 'spec:\n';
        }

        // Service Account
        if (serviceAccount) {
            yaml += specIndent + 'serviceAccountName: ' + serviceAccount + '\n';
        }

        // Restart Policy (mainly for Pod)
        if (restartPolicy) {
            yaml += specIndent + 'restartPolicy: ' + restartPolicy + '\n';
        }

        // Pod Security Context
        var hasPodSecCtx = runAsUser || runAsGroup || fsGroup || runAsNonRoot;
        if (hasPodSecCtx) {
            yaml += specIndent + 'securityContext:\n';
            if (runAsUser) yaml += specIndent + '  runAsUser: ' + runAsUser + '\n';
            if (runAsGroup) yaml += specIndent + '  runAsGroup: ' + runAsGroup + '\n';
            if (fsGroup) yaml += specIndent + '  fsGroup: ' + fsGroup + '\n';
            if (runAsNonRoot) yaml += specIndent + '  runAsNonRoot: true\n';
        }

        // Node Selector
        if (Object.keys(nodeSelectors).length > 0) {
            yaml += specIndent + 'nodeSelector:\n';
            for (var ns_key in nodeSelectors) {
                yaml += specIndent + '  ' + ns_key + ': ' + nodeSelectors[ns_key] + '\n';
            }
        }

        // Tolerations
        if (tolerations.length > 0) {
            yaml += specIndent + 'tolerations:\n';
            tolerations.forEach(function(t) {
                yaml += specIndent + '  - key: "' + t.key + '"\n';
                yaml += specIndent + '    operator: "' + t.operator + '"\n';
                if (t.operator === 'Equal' && t.value) {
                    yaml += specIndent + '    value: "' + t.value + '"\n';
                }
                yaml += specIndent + '    effect: "' + t.effect + '"\n';
            });
        }

        // Volumes (at pod spec level)
        if (volumeMounts.length > 0) {
            yaml += specIndent + 'volumes:\n';
            volumeMounts.forEach(function(v) {
                yaml += specIndent + '  - name: ' + v.name + '\n';
                if (v.type === 'emptyDir') {
                    yaml += specIndent + '    emptyDir: {}\n';
                } else if (v.type === 'configMap') {
                    yaml += specIndent + '    configMap:\n';
                    yaml += specIndent + '      name: ' + (v.source || v.name) + '\n';
                } else if (v.type === 'secret') {
                    yaml += specIndent + '    secret:\n';
                    yaml += specIndent + '      secretName: ' + (v.source || v.name) + '\n';
                } else if (v.type === 'pvc') {
                    yaml += specIndent + '    persistentVolumeClaim:\n';
                    yaml += specIndent + '      claimName: ' + (v.source || v.name) + '\n';
                } else if (v.type === 'hostPath') {
                    yaml += specIndent + '    hostPath:\n';
                    yaml += specIndent + '      path: ' + (v.source || '/tmp') + '\n';
                }
            });
        }

        // Containers
        yaml += specIndent + 'containers:\n';
        yaml += containerIndent + '- name: ' + name + '\n';
        yaml += containerIndent + '  image: ' + image + '\n';

        // Container Security Context
        var hasContainerSecCtx = privileged || readOnlyRootFs || allowPrivEsc || capAdd || capDrop;
        if (hasContainerSecCtx) {
            yaml += containerIndent + '  securityContext:\n';
            if (privileged) yaml += containerIndent + '    privileged: true\n';
            if (readOnlyRootFs) yaml += containerIndent + '    readOnlyRootFilesystem: true\n';
            if (allowPrivEsc) yaml += containerIndent + '    allowPrivilegeEscalation: true\n';
            if (capAdd || capDrop) {
                yaml += containerIndent + '    capabilities:\n';
                if (capAdd) {
                    yaml += containerIndent + '      add:\n';
                    capAdd.split(',').forEach(function(c) {
                        c = c.trim();
                        if (c) yaml += containerIndent + '        - ' + c + '\n';
                    });
                }
                if (capDrop) {
                    yaml += containerIndent + '      drop:\n';
                    capDrop.split(',').forEach(function(c) {
                        c = c.trim();
                        if (c) yaml += containerIndent + '        - ' + c + '\n';
                    });
                }
            }
        }

        // Ports
        if (ports) {
            yaml += containerIndent + '  ports:\n';
            ports.split(',').forEach(function(p) {
                p = p.trim();
                if (p) yaml += containerIndent + '    - containerPort: ' + p + '\n';
            });
        }

        // Environment Variables
        if (Object.keys(envVars).length > 0) {
            yaml += containerIndent + '  env:\n';
            for (var ek in envVars) {
                yaml += containerIndent + '    - name: ' + ek + '\n';
                yaml += containerIndent + '      value: "' + envVars[ek] + '"\n';
            }
        }

        // Resources
        if (cpuReq || cpuLim || memReq || memLim) {
            yaml += containerIndent + '  resources:\n';
            if (cpuReq || memReq) {
                yaml += containerIndent + '    requests:\n';
                if (cpuReq) yaml += containerIndent + '      cpu: ' + cpuReq + '\n';
                if (memReq) yaml += containerIndent + '      memory: ' + memReq + '\n';
            }
            if (cpuLim || memLim) {
                yaml += containerIndent + '    limits:\n';
                if (cpuLim) yaml += containerIndent + '      cpu: ' + cpuLim + '\n';
                if (memLim) yaml += containerIndent + '      memory: ' + memLim + '\n';
            }
        }

        // Volume Mounts (at container level)
        if (volumeMounts.length > 0) {
            yaml += containerIndent + '  volumeMounts:\n';
            volumeMounts.forEach(function(v) {
                yaml += containerIndent + '    - name: ' + v.name + '\n';
                yaml += containerIndent + '      mountPath: ' + v.mountPath + '\n';
            });
        }

        // Liveness Probe
        if (livePath && livePort) {
            yaml += containerIndent + '  livenessProbe:\n';
            yaml += containerIndent + '    httpGet:\n';
            yaml += containerIndent + '      path: ' + livePath + '\n';
            yaml += containerIndent + '      port: ' + livePort + '\n';
            yaml += containerIndent + '    initialDelaySeconds: 15\n';
            yaml += containerIndent + '    periodSeconds: 10\n';
        }

        // Readiness Probe
        if (readyPath && readyPort) {
            yaml += containerIndent + '  readinessProbe:\n';
            yaml += containerIndent + '    httpGet:\n';
            yaml += containerIndent + '      path: ' + readyPath + '\n';
            yaml += containerIndent + '      port: ' + readyPort + '\n';
            yaml += containerIndent + '    initialDelaySeconds: 5\n';
            yaml += containerIndent + '    periodSeconds: 5\n';
        }

        return yaml;
    }

    function generateDeploymentJson() {
        var name = $('#name').val().trim() || 'my-app';
        var ns = $('#namespace').val().trim() || 'default';
        var image = $('#image').val().trim() || 'nginx:latest';
        var replicas = parseInt($('#replicas').val()) || 1;
        var isPod = currentResource === 'pod';

        var container = {
            name: name,
            image: image
        };

        var ports = $('#containerPorts').val().trim();
        if (ports) {
            container.ports = ports.split(',').map(function(p) {
                return { containerPort: parseInt(p.trim()) };
            }).filter(function(p) { return !isNaN(p.containerPort); });
        }

        if (isPod) {
            return {
                apiVersion: 'v1',
                kind: 'Pod',
                metadata: { name: name, namespace: ns, labels: { app: name } },
                spec: { containers: [container] }
            };
        }

        return {
            apiVersion: 'apps/v1',
            kind: 'Deployment',
            metadata: { name: name, namespace: ns, labels: { app: name } },
            spec: {
                replicas: replicas,
                selector: { matchLabels: { app: name } },
                template: {
                    metadata: { labels: { app: name } },
                    spec: { containers: [container] }
                }
            }
        };
    }

    function generateServiceYaml() {
        var name = $('#svcName').val().trim() || 'my-service';
        var ns = $('#svcNamespace').val().trim() || 'default';
        var type = $('#svcType').val() || 'ClusterIP';
        var port = $('#svcPort').val() || '80';
        var targetPort = $('#svcTargetPort').val() || '8080';
        var selector = $('#svcSelector').val().trim() || 'myapp';
        var nodePort = $('#svcNodePort').val();

        var yaml = 'apiVersion: v1\n';
        yaml += 'kind: Service\n';
        yaml += 'metadata:\n';
        yaml += '  name: ' + name + '\n';
        yaml += '  namespace: ' + ns + '\n';
        yaml += 'spec:\n';
        yaml += '  type: ' + type + '\n';
        yaml += '  selector:\n';
        yaml += '    app: ' + selector + '\n';
        yaml += '  ports:\n';
        yaml += '    - port: ' + port + '\n';
        yaml += '      targetPort: ' + targetPort + '\n';
        if ((type === 'NodePort' || type === 'LoadBalancer') && nodePort) {
            yaml += '      nodePort: ' + nodePort + '\n';
        }

        return yaml;
    }

    function generateServiceJson() {
        var name = $('#svcName').val().trim() || 'my-service';
        var ns = $('#svcNamespace').val().trim() || 'default';
        var type = $('#svcType').val() || 'ClusterIP';
        var port = parseInt($('#svcPort').val()) || 80;
        var targetPort = $('#svcTargetPort').val() || '8080';
        var selector = $('#svcSelector').val().trim() || 'myapp';

        return {
            apiVersion: 'v1',
            kind: 'Service',
            metadata: { name: name, namespace: ns },
            spec: {
                type: type,
                selector: { app: selector },
                ports: [{ port: port, targetPort: isNaN(parseInt(targetPort)) ? targetPort : parseInt(targetPort) }]
            }
        };
    }

    function generateConfigMapYaml() {
        var name = $('#cmName').val().trim() || 'my-config';
        var ns = $('#cmNamespace').val().trim() || 'default';
        var data = collectKVPairs('cmDataContainer');

        var yaml = 'apiVersion: v1\n';
        yaml += 'kind: ConfigMap\n';
        yaml += 'metadata:\n';
        yaml += '  name: ' + name + '\n';
        yaml += '  namespace: ' + ns + '\n';
        yaml += 'data:\n';
        for (var k in data) {
            yaml += '  ' + k + ': "' + data[k] + '"\n';
        }
        return yaml;
    }

    function generateConfigMapJson() {
        var name = $('#cmName').val().trim() || 'my-config';
        var ns = $('#cmNamespace').val().trim() || 'default';
        var data = collectKVPairs('cmDataContainer');

        return {
            apiVersion: 'v1',
            kind: 'ConfigMap',
            metadata: { name: name, namespace: ns },
            data: data
        };
    }

    function generateSecretYaml() {
        var name = $('#secretName').val().trim() || 'my-secret';
        var ns = $('#secretNamespace').val().trim() || 'default';
        var type = $('#secretType').val() || 'Opaque';
        var data = collectKVPairs('secretDataContainer');

        var yaml = 'apiVersion: v1\n';
        yaml += 'kind: Secret\n';
        yaml += 'metadata:\n';
        yaml += '  name: ' + name + '\n';
        yaml += '  namespace: ' + ns + '\n';
        yaml += 'type: ' + type + '\n';
        yaml += 'stringData:\n';
        for (var k in data) {
            yaml += '  ' + k + ': "' + data[k] + '"\n';
        }
        return yaml;
    }

    function generateSecretJson() {
        var name = $('#secretName').val().trim() || 'my-secret';
        var ns = $('#secretNamespace').val().trim() || 'default';
        var type = $('#secretType').val() || 'Opaque';
        var data = collectKVPairs('secretDataContainer');

        return {
            apiVersion: 'v1',
            kind: 'Secret',
            metadata: { name: name, namespace: ns },
            type: type,
            stringData: data
        };
    }

    function generateJobYaml() {
        var name = $('#jobName').val().trim() || 'my-job';
        var ns = $('#jobNamespace').val().trim() || 'default';
        var image = $('#jobImage').val().trim() || 'busybox:latest';
        var cmd = $('#jobCommand').val().trim();
        var args = $('#jobArgs').val().trim();
        var completions = $('#jobCompletions').val() || '1';
        var backoff = $('#jobBackoffLimit').val() || '6';

        var yaml = 'apiVersion: batch/v1\n';
        yaml += 'kind: Job\n';
        yaml += 'metadata:\n';
        yaml += '  name: ' + name + '\n';
        yaml += '  namespace: ' + ns + '\n';
        yaml += 'spec:\n';
        yaml += '  completions: ' + completions + '\n';
        yaml += '  backoffLimit: ' + backoff + '\n';
        yaml += '  template:\n';
        yaml += '    spec:\n';
        yaml += '      containers:\n';
        yaml += '        - name: ' + name + '\n';
        yaml += '          image: ' + image + '\n';
        if (cmd) yaml += '          command: ["' + cmd + '"]\n';
        if (args) yaml += '          args: ["' + args + '"]\n';
        yaml += '      restartPolicy: Never\n';
        return yaml;
    }

    function generateJobJson() {
        var name = $('#jobName').val().trim() || 'my-job';
        var ns = $('#jobNamespace').val().trim() || 'default';
        var image = $('#jobImage').val().trim() || 'busybox:latest';

        return {
            apiVersion: 'batch/v1',
            kind: 'Job',
            metadata: { name: name, namespace: ns },
            spec: {
                template: {
                    spec: {
                        containers: [{ name: name, image: image }],
                        restartPolicy: 'Never'
                    }
                }
            }
        };
    }

    function generateCronJobYaml() {
        var name = $('#cronName').val().trim() || 'my-cronjob';
        var ns = $('#cronNamespace').val().trim() || 'default';
        var schedule = $('#cronSchedule').val().trim() || '*/5 * * * *';
        var image = $('#cronImage').val().trim() || 'busybox:latest';
        var cmd = $('#cronCommand').val().trim();
        var args = $('#cronArgs').val().trim();

        var yaml = 'apiVersion: batch/v1\n';
        yaml += 'kind: CronJob\n';
        yaml += 'metadata:\n';
        yaml += '  name: ' + name + '\n';
        yaml += '  namespace: ' + ns + '\n';
        yaml += 'spec:\n';
        yaml += '  schedule: "' + schedule + '"\n';
        yaml += '  jobTemplate:\n';
        yaml += '    spec:\n';
        yaml += '      template:\n';
        yaml += '        spec:\n';
        yaml += '          containers:\n';
        yaml += '            - name: ' + name + '\n';
        yaml += '              image: ' + image + '\n';
        if (cmd) yaml += '              command: ["' + cmd + '"]\n';
        if (args) yaml += '              args: ["' + args + '"]\n';
        yaml += '          restartPolicy: OnFailure\n';
        return yaml;
    }

    function generateCronJobJson() {
        var name = $('#cronName').val().trim() || 'my-cronjob';
        var ns = $('#cronNamespace').val().trim() || 'default';
        var schedule = $('#cronSchedule').val().trim() || '*/5 * * * *';
        var image = $('#cronImage').val().trim() || 'busybox:latest';

        return {
            apiVersion: 'batch/v1',
            kind: 'CronJob',
            metadata: { name: name, namespace: ns },
            spec: {
                schedule: schedule,
                jobTemplate: {
                    spec: {
                        template: {
                            spec: {
                                containers: [{ name: name, image: image }],
                                restartPolicy: 'OnFailure'
                            }
                        }
                    }
                }
            }
        };
    }

    function generateStatefulSetYaml() {
        var name = $('#ssName').val().trim() || 'my-statefulset';
        var ns = $('#ssNamespace').val().trim() || 'default';
        var image = $('#ssImage').val().trim() || 'nginx:latest';
        var replicas = $('#ssReplicas').val() || '3';
        var serviceName = $('#ssServiceName').val().trim() || name;
        var volName = $('#ssVolumeName').val().trim();
        var storageSize = $('#ssStorageSize').val().trim();

        var yaml = 'apiVersion: apps/v1\n';
        yaml += 'kind: StatefulSet\n';
        yaml += 'metadata:\n';
        yaml += '  name: ' + name + '\n';
        yaml += '  namespace: ' + ns + '\n';
        yaml += 'spec:\n';
        yaml += '  serviceName: ' + serviceName + '\n';
        yaml += '  replicas: ' + replicas + '\n';
        yaml += '  selector:\n';
        yaml += '    matchLabels:\n';
        yaml += '      app: ' + name + '\n';
        yaml += '  template:\n';
        yaml += '    metadata:\n';
        yaml += '      labels:\n';
        yaml += '        app: ' + name + '\n';
        yaml += '    spec:\n';
        yaml += '      containers:\n';
        yaml += '        - name: ' + name + '\n';
        yaml += '          image: ' + image + '\n';

        if (volName && storageSize) {
            yaml += '          volumeMounts:\n';
            yaml += '            - name: ' + volName + '\n';
            yaml += '              mountPath: /data\n';
            yaml += '  volumeClaimTemplates:\n';
            yaml += '    - metadata:\n';
            yaml += '        name: ' + volName + '\n';
            yaml += '      spec:\n';
            yaml += '        accessModes: ["ReadWriteOnce"]\n';
            yaml += '        resources:\n';
            yaml += '          requests:\n';
            yaml += '            storage: ' + storageSize + '\n';
        }

        return yaml;
    }

    function generateStatefulSetJson() {
        var name = $('#ssName').val().trim() || 'my-statefulset';
        var ns = $('#ssNamespace').val().trim() || 'default';
        var image = $('#ssImage').val().trim() || 'nginx:latest';
        var replicas = parseInt($('#ssReplicas').val()) || 3;
        var serviceName = $('#ssServiceName').val().trim() || name;

        return {
            apiVersion: 'apps/v1',
            kind: 'StatefulSet',
            metadata: { name: name, namespace: ns },
            spec: {
                serviceName: serviceName,
                replicas: replicas,
                selector: { matchLabels: { app: name } },
                template: {
                    metadata: { labels: { app: name } },
                    spec: { containers: [{ name: name, image: image }] }
                }
            }
        };
    }

    // ========== SYNTAX HIGHLIGHTING ==========
    function highlightYaml(yaml) {
        return yaml
            .replace(/^(\s*)([a-zA-Z0-9_-]+):/gm, '$1<span class="yaml-key">$2</span>:')
            .replace(/: "([^"]*)"/g, ': "<span class="yaml-string">$1</span>"')
            .replace(/: (\d+)$/gm, ': <span class="yaml-number">$1</span>')
            .replace(/: (true|false)$/gm, ': <span class="yaml-boolean">$1</span>')
            .replace(/(#.*$)/gm, '<span class="yaml-comment">$1</span>');
    }

    // ========== UPDATE PREVIEW ==========
    function updatePreview() {
        clearTimeout(updateTimeout);
        updateTimeout = setTimeout(function() {
            var output = generateYamlPreview();

            if (output && output.trim()) {
                $('#outputEmpty').hide();
                $('#outputPre').show().html(currentFormat === 'yaml' ? highlightYaml(output) : output);
                $('#copyBtn, #shareBtn, #downloadBtn').prop('disabled', false);
                $('#statusBar').show();
                $('#statusText').text('Valid ' + currentResource.charAt(0).toUpperCase() + currentResource.slice(1) + ' manifest');
            } else {
                $('#outputEmpty').show();
                $('#outputPre').hide();
                $('#copyBtn, #shareBtn, #downloadBtn').prop('disabled', true);
                $('#statusBar').hide();
            }
        }, 150);
    }

    // ========== ACTIONS ==========
    function copyOutput() {
        var text = currentFormat === 'yaml' ? currentYaml : currentJson;
        if (!text) {
            showToast('No content to copy', 'warning');
            return;
        }

        if (typeof ToolUtils !== 'undefined' && ToolUtils.copyToClipboard) {
            ToolUtils.copyToClipboard(text, {
                toastMessage: 'Kubernetes manifest copied!',
                showSupportPopup: true,
                toolName: 'Kubernetes YAML Generator',
                resultText: text.substring(0, 100) + '...'
            });
        } else {
            // Fallback
            navigator.clipboard.writeText(text).then(function() {
                showToast('Copied to clipboard!');
            });
        }
    }

    function downloadOutput() {
        var text = currentFormat === 'yaml' ? currentYaml : currentJson;
        if (!text) {
            showToast('No content to download', 'warning');
            return;
        }

        var ext = currentFormat === 'yaml' ? '.yaml' : '.json';
        var name = ($('#name').val().trim() || currentResource) + ext;

        if (typeof ToolUtils !== 'undefined' && ToolUtils.downloadAsFile) {
            ToolUtils.downloadAsFile(text, name, {
                toastMessage: 'Downloaded ' + name,
                showSupportPopup: true,
                toolName: 'Kubernetes YAML Generator'
            });
        } else {
            // Fallback
            var mime = currentFormat === 'yaml' ? 'text/yaml' : 'application/json';
            var blob = new Blob([text], { type: mime });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = name;
            a.click();
            URL.revokeObjectURL(url);
            showToast('Downloaded ' + name);
        }
    }

    function shareOutput() {
        var text = currentFormat === 'yaml' ? currentYaml : currentJson;
        if (!text) {
            showToast('No content to share', 'warning');
            return;
        }

        if (typeof ToolUtils !== 'undefined' && ToolUtils.shareResult) {
            ToolUtils.shareResult(text, {
                paramName: 'manifest',
                encode: true,
                extraParams: {
                    type: currentResource,
                    format: currentFormat
                },
                copyToClipboard: true,
                showSupportPopup: true,
                toolName: 'Kubernetes YAML Generator'
            });
        } else {
            // Fallback - simple URL encoding
            var encoded = btoa(unescape(encodeURIComponent(text)));
            var shareUrl = window.location.origin + window.location.pathname +
                '?manifest=' + encoded + '&enc=base64&type=' + currentResource + '&format=' + currentFormat;
            navigator.clipboard.writeText(shareUrl).then(function() {
                showToast('Share URL copied to clipboard!');
            });
        }
    }

    function resetForm() {
        $('.tool-resource-form input[type="text"], .tool-resource-form input[type="number"]').val('');
        $('.tool-resource-form input[type="checkbox"]').prop('checked', false);
        $('.tool-resource-form select').each(function() {
            $(this).val($(this).find('option:first').val());
        });
        $('#namespace, #svcNamespace, #cmNamespace, #secretNamespace, #jobNamespace, #cronNamespace, #ssNamespace').val('default');
        $('#replicas, #jobCompletions, #ssReplicas').val('1');
        $('#jobBackoffLimit').val('6');
        $('#restartPolicy').val('');

        // Reset volume mounts to single empty row
        $('#volumeMountsContainer').html(
            '<div class="volume-mount-row" style="display: flex; gap: 0.375rem; margin-bottom: 0.375rem; align-items: center; flex-wrap: wrap;">' +
            '<select class="tool-select" style="width: 100px;" onchange="updatePreview()">' +
            '<option value="emptyDir">EmptyDir</option>' +
            '<option value="configMap">ConfigMap</option>' +
            '<option value="secret">Secret</option>' +
            '<option value="pvc">PVC</option>' +
            '<option value="hostPath">HostPath</option>' +
            '</select>' +
            '<input type="text" class="kv-key" placeholder="Volume Name" style="flex: 1; min-width: 80px;" oninput="updatePreview()">' +
            '<input type="text" class="kv-value" placeholder="Mount Path" style="flex: 1; min-width: 100px;" oninput="updatePreview()">' +
            '<input type="text" class="kv-extra" placeholder="Source (ConfigMap/Secret/PVC name)" style="flex: 1; min-width: 100px;" oninput="updatePreview()">' +
            '<button type="button" class="btn-remove-kv" onclick="removeVolumeMountRow(this)">&#10005;</button>' +
            '</div>'
        );

        // Reset tolerations to single empty row
        $('#tolerationsContainer').html(
            '<div class="toleration-row" style="display: flex; gap: 0.375rem; margin-bottom: 0.375rem; align-items: center; flex-wrap: wrap;">' +
            '<input type="text" class="kv-key" placeholder="Key" style="flex: 1; min-width: 60px;" oninput="updatePreview()">' +
            '<select class="tool-select" style="width: 80px;" onchange="updatePreview()">' +
            '<option value="Equal">Equal</option>' +
            '<option value="Exists">Exists</option>' +
            '</select>' +
            '<input type="text" class="kv-value" placeholder="Value" style="flex: 1; min-width: 60px;" oninput="updatePreview()">' +
            '<select class="tool-select effect-select" style="width: 100px;" onchange="updatePreview()">' +
            '<option value="NoSchedule">NoSchedule</option>' +
            '<option value="PreferNoSchedule">PreferNoSchedule</option>' +
            '<option value="NoExecute">NoExecute</option>' +
            '</select>' +
            '<button type="button" class="btn-remove-kv" onclick="removeTolerationRow(this)">&#10005;</button>' +
            '</div>'
        );

        // Reset node selector to single empty row
        $('#nodeSelectorContainer').html(
            '<div class="kv-pair">' +
            '<input type="text" class="kv-key" placeholder="Key" oninput="updatePreview()">' +
            '<input type="text" class="kv-value" placeholder="Value" oninput="updatePreview()">' +
            '<button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>' +
            '</div>'
        );

        updatePreview();
        showToast('Form reset');
    }

    function generateManifest() {
        updatePreview();
        downloadOutput();
    }

    function applyPreset(presetName) {
        var p = presets[presetName];
        if (!p) return;

        // Basic fields
        $('#name').val(p.name);
        $('#image').val(p.image);
        $('#replicas').val(p.replicas);
        $('#containerPorts').val(p.ports);

        // Resources
        $('#cpuRequest').val(p.cpuRequest || '');
        $('#cpuLimit').val(p.cpuLimit || '');
        $('#memoryRequest').val(p.memoryRequest || '');
        $('#memoryLimit').val(p.memoryLimit || '');

        // Health Checks
        $('#livenessPath').val(p.livenessPath || '');
        $('#livenessPort').val(p.livenessPort || '');
        $('#readinessPath').val(p.readinessPath || '');
        $('#readinessPort').val(p.readinessPort || '');

        // Security Context
        $('#runAsUser').val(p.runAsUser || '');
        $('#runAsGroup').val(p.runAsGroup || '');
        $('#fsGroup').val(p.fsGroup || '');
        $('#runAsNonRoot').prop('checked', p.runAsNonRoot || false);
        $('#privileged').prop('checked', p.privileged || false);
        $('#readOnlyRootFs').prop('checked', p.readOnlyRootFs || false);
        $('#allowPrivilegeEscalation').prop('checked', p.allowPrivilegeEscalation || false);
        $('#capAdd').val(p.capAdd || '');
        $('#capDrop').val(p.capDrop || '');

        // Service Account
        $('#serviceAccount').val(p.serviceAccount || '');

        // Update labels
        var labelsHtml = '';
        if (p.labels) {
            for (var k in p.labels) {
                labelsHtml += '<div class="kv-pair">' +
                    '<input type="text" class="kv-key" value="' + k + '" oninput="updatePreview()">' +
                    '<input type="text" class="kv-value" value="' + p.labels[k] + '" oninput="updatePreview()">' +
                    '<button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>' +
                    '</div>';
            }
        }
        if (!labelsHtml) {
            labelsHtml = '<div class="kv-pair">' +
                '<input type="text" class="kv-key" value="app" oninput="updatePreview()">' +
                '<input type="text" class="kv-value" value="' + p.name + '" oninput="updatePreview()">' +
                '<button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>' +
                '</div>';
        }
        $('#labelsContainer').html(labelsHtml);

        // Update environment variables
        var envHtml = '';
        if (p.env) {
            for (var ek in p.env) {
                envHtml += '<div class="kv-pair">' +
                    '<input type="text" class="kv-key" value="' + ek + '" oninput="updatePreview()">' +
                    '<input type="text" class="kv-value" value="' + p.env[ek] + '" oninput="updatePreview()">' +
                    '<button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>' +
                    '</div>';
            }
        }
        if (!envHtml) {
            envHtml = '<div class="kv-pair">' +
                '<input type="text" class="kv-key" placeholder="Key" oninput="updatePreview()">' +
                '<input type="text" class="kv-value" placeholder="Value" oninput="updatePreview()">' +
                '<button type="button" class="btn-remove-kv" onclick="removeKVPair(this)">&#10005;</button>' +
                '</div>';
        }
        $('#envContainer').html(envHtml);

        // Update volume mounts
        var volHtml = '';
        if (p.volumes && p.volumes.length > 0) {
            p.volumes.forEach(function(v) {
                volHtml += '<div class="volume-mount-row" style="display: flex; gap: 0.375rem; margin-bottom: 0.375rem; align-items: center; flex-wrap: wrap;">' +
                    '<select class="tool-select" style="width: 100px;" onchange="updatePreview()">' +
                    '<option value="emptyDir"' + (v.type === 'emptyDir' ? ' selected' : '') + '>EmptyDir</option>' +
                    '<option value="configMap"' + (v.type === 'configMap' ? ' selected' : '') + '>ConfigMap</option>' +
                    '<option value="secret"' + (v.type === 'secret' ? ' selected' : '') + '>Secret</option>' +
                    '<option value="pvc"' + (v.type === 'pvc' ? ' selected' : '') + '>PVC</option>' +
                    '<option value="hostPath"' + (v.type === 'hostPath' ? ' selected' : '') + '>HostPath</option>' +
                    '</select>' +
                    '<input type="text" class="kv-key" placeholder="Volume Name" style="flex: 1; min-width: 80px;" value="' + v.name + '" oninput="updatePreview()">' +
                    '<input type="text" class="kv-value" placeholder="Mount Path" style="flex: 1; min-width: 100px;" value="' + v.mountPath + '" oninput="updatePreview()">' +
                    '<input type="text" class="kv-extra" placeholder="Source" style="flex: 1; min-width: 100px;" value="' + (v.source || '') + '" oninput="updatePreview()">' +
                    '<button type="button" class="btn-remove-kv" onclick="removeVolumeMountRow(this)">&#10005;</button>' +
                    '</div>';
            });
        }
        if (!volHtml) {
            volHtml = '<div class="volume-mount-row" style="display: flex; gap: 0.375rem; margin-bottom: 0.375rem; align-items: center; flex-wrap: wrap;">' +
                '<select class="tool-select" style="width: 100px;" onchange="updatePreview()">' +
                '<option value="emptyDir">EmptyDir</option>' +
                '<option value="configMap">ConfigMap</option>' +
                '<option value="secret">Secret</option>' +
                '<option value="pvc">PVC</option>' +
                '<option value="hostPath">HostPath</option>' +
                '</select>' +
                '<input type="text" class="kv-key" placeholder="Volume Name" style="flex: 1; min-width: 80px;" oninput="updatePreview()">' +
                '<input type="text" class="kv-value" placeholder="Mount Path" style="flex: 1; min-width: 100px;" oninput="updatePreview()">' +
                '<input type="text" class="kv-extra" placeholder="Source" style="flex: 1; min-width: 100px;" oninput="updatePreview()">' +
                '<button type="button" class="btn-remove-kv" onclick="removeVolumeMountRow(this)">&#10005;</button>' +
                '</div>';
        }
        $('#volumeMountsContainer').html(volHtml);

        // Expand relevant sections to show the preset config
        expandSectionsForPreset(p);

        updatePreview();
        showToast('Applied ' + presetName + ' preset');
    }

    function expandSectionsForPreset(p) {
        // Expand sections that have values
        if (p.cpuRequest || p.cpuLimit || p.memoryRequest || p.memoryLimit) {
            expandSection('Resources');
        }
        if (p.livenessPath || p.readinessPath) {
            expandSection('Health Checks');
        }
        if (p.runAsUser || p.runAsNonRoot || p.capDrop) {
            expandSection('Security Context');
        }
        if (p.volumes && p.volumes.length > 0) {
            expandSection('Volumes & Mounts');
        }
        if (p.env && Object.keys(p.env).length > 0) {
            expandSection('Environment Variables');
        }
    }

    function expandSection(sectionName) {
        $('.tool-section-header').each(function() {
            if ($(this).find('span').first().text().trim() === sectionName) {
                if ($(this).hasClass('collapsed')) {
                    $(this).removeClass('collapsed');
                    $(this).next('.tool-section-content').removeClass('hidden');
                }
            }
        });
    }

    // ========== EVENT HANDLERS ==========
    $(document).ready(function() {
        // Tab switching
        $('.tool-tab').on('click', function() {
            $('.tool-tab').removeClass('active');
            $(this).addClass('active');
            currentResource = $(this).data('resource');
            $('#resourceType').val(currentResource);

            // Show/hide forms
            $('.tool-resource-form').hide();
            if (currentResource === 'deployment' || currentResource === 'pod') {
                $('#formDeployment').show();
            } else {
                $('#form' + currentResource.charAt(0).toUpperCase() + currentResource.slice(1)).show();
            }

            // Update presets visibility
            $('#presetsBar').toggle(currentResource === 'deployment' || currentResource === 'pod');

            updatePreview();
        });

        // Format toggle
        $('.tool-format-btn').on('click', function() {
            $('.tool-format-btn').removeClass('active');
            $(this).addClass('active');
            currentFormat = $(this).data('format');
            updatePreview();
        });

        // Preset buttons
        $('.tool-preset-btn').on('click', function() {
            applyPreset($(this).data('preset'));
        });

        // Initial preview
        updatePreview();

        // Load shared manifest from URL if present
        loadSharedManifest();
    });

    // ========== LOAD SHARED MANIFEST ==========
    function loadSharedManifest() {
        var urlParams = new URLSearchParams(window.location.search);
        var manifestData = urlParams.get('manifest');

        if (!manifestData) return;

        try {
            var encoding = urlParams.get('enc');
            var decoded;

            if (encoding === 'base64') {
                // Decode base64
                decoded = decodeURIComponent(escape(atob(manifestData)));
            } else {
                decoded = decodeURIComponent(manifestData);
            }

            if (!decoded) return;

            // Get format and type from URL
            var format = urlParams.get('format') || 'yaml';
            var type = urlParams.get('type') || 'deployment';

            // Set format
            currentFormat = format;
            $('.tool-format-btn').removeClass('active');
            $('.tool-format-btn[data-format="' + format + '"]').addClass('active');

            // Set resource type
            currentResource = type;
            $('.tool-tab').removeClass('active');
            $('.tool-tab[data-resource="' + type + '"]').addClass('active');
            $('#resourceType').val(type);

            // Show appropriate form
            $('.tool-resource-form').hide();
            if (type === 'deployment' || type === 'pod') {
                $('#formDeployment').show();
            } else {
                $('#form' + type.charAt(0).toUpperCase() + type.slice(1)).show();
            }

            // Display the shared manifest directly in output
            if (format === 'yaml') {
                currentYaml = decoded;
                currentJson = ''; // Would need to parse YAML to get JSON
            } else {
                currentJson = decoded;
                currentYaml = ''; // Would need to convert JSON to YAML
            }

            $('#outputEmpty').hide();
            $('#outputPre').show().html(format === 'yaml' ? highlightYaml(decoded) : decoded);
            $('#copyBtn, #shareBtn, #downloadBtn').prop('disabled', false);
            $('#statusBar').show();
            $('#statusText').text('Loaded shared ' + type.charAt(0).toUpperCase() + type.slice(1) + ' manifest');

            showToast('Shared manifest loaded!', 'success');

        } catch (e) {
            console.error('Failed to load shared manifest:', e);
            showToast('Failed to load shared manifest', 'error');
        }
    }
    </script>
</body>
</html>

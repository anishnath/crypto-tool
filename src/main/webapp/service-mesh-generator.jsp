<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Istio Service Mesh Generator Online – Free | 8gwifi.org</title>
        <meta name="description"
            content="Free Istio generator for Kubernetes. Create canary deployments, blue-green traffic splitting, VirtualServices, DestinationRules, Gateways, mTLS, and authorization policies. No YAML required.">
        <meta name="keywords"
            content="istio generator, canary deployment kubernetes, blue green deployment, service mesh istio, virtualservice generator, destinationrule, istio gateway yaml, mtls kubernetes, istio authorization policy, kubernetes traffic splitting, istio canary release">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Istio Service Mesh Configuration Generator",
      "description": "Generate Istio service mesh configurations for traffic splitting, gateways, and mTLS policies.",
      "url": "https://8gwifi.org/service-mesh-generator.jsp",
      "applicationCategory": "DeveloperApplication",
      "operatingSystem": "Any",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      },
      "datePublished": "2025-12-01",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Canary Deployment Generator",
        "Blue-Green Deployment",
        "Visual Traffic Splitting Builder",
        "Gateway Configuration",
        "mTLS Policy Generator",
        "Authorization Policy Builder",
        "Real-time YAML Preview"
      ]
    }
    </script>
            <style>
                :root {
                    --theme-primary: #0f1689;
                    --theme-secondary: #326ce5;
                    --theme-istio: #466BB0;
                    --theme-gradient: linear-gradient(135deg, #0f1689 0%, #326ce5 100%);
                    --theme-light: #e3f2fd
                }

                .tool-card {
                    border: none;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, .1)
                }

                .card-header-custom {
                    background: var(--theme-gradient);
                    color: white;
                    font-weight: 600
                }

                .form-section {
                    background-color: var(--theme-light);
                    padding: 1rem;
                    border-radius: .5rem;
                    margin-bottom: 1rem
                }

                .form-section-title {
                    color: var(--theme-primary);
                    font-weight: 700;
                    margin-bottom: 1rem;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem
                }

                .code-preview {
                    background: #1e293b;
                    color: #e2e8f0;
                    padding: 1rem;
                    border-radius: 4px;
                    font-family: 'Courier New', monospace;
                    font-size: .85rem;
                    white-space: pre-wrap;
                    min-height: 400px;
                    max-height: 700px;
                    overflow-y: auto;
                    line-height: 1.5
                }

                .eeat-badge {
                    background: var(--theme-gradient);
                    color: white;
                    padding: .35rem .75rem;
                    border-radius: 20px;
                    font-size: .75rem;
                    display: inline-flex;
                    align-items: center;
                    gap: .5rem
                }

                .sticky-preview {
                    position: sticky;
                    top: 80px
                }

                .preset-btn {
                    margin: 0.25rem;
                    font-size: 0.85rem;
                    padding: 0.4rem 0.8rem;
                    border-radius: 20px;
                    transition: all 0.3s ease
                }

                .preset-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2)
                }

                .mode-selector {
                    border-bottom: 2px solid #dee2e6;
                    margin-bottom: 1.5rem;
                }

                .mode-selector .nav-link {
                    border: none;
                    color: #6c757d;
                    font-weight: 500;
                    padding: 0.75rem 1.5rem;
                    cursor: pointer;
                    transition: all 0.3s ease
                }

                .mode-selector .nav-link:hover {
                    color: var(--theme-secondary);
                    background-color: rgba(50, 108, 229, 0.1)
                }

                .mode-selector .nav-link.active {
                    color: var(--theme-istio);
                    border-bottom: 3px solid var(--theme-istio);
                    background-color: transparent
                }

                .tab-preview {
                    border-bottom: 2px solid #dee2e6
                }

                .tab-preview .nav-link {
                    border: none;
                    color: #6c757d;
                    font-weight: 500;
                    padding: 0.75rem 1rem;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    font-size: 0.85rem;
                }

                .tab-preview .nav-link:hover {
                    color: var(--theme-secondary);
                    background-color: rgba(50, 108, 229, 0.1)
                }

                .tab-preview .nav-link.active {
                    color: var(--theme-primary);
                    border-bottom: 3px solid var(--theme-primary);
                    background-color: transparent
                }

                .subset-item {
                    background: white;
                    border: 1px solid #dee2e6;
                    border-radius: 8px;
                    padding: 1rem;
                    margin-bottom: 0.75rem;
                    position: relative;
                }

                .weight-slider {
                    width: 100%;
                }

                .weight-display {
                    font-size: 1.5rem;
                    font-weight: 700;
                    color: var(--theme-istio);
                }
            </style>
    </head>
    <%@ include file="body-script.jsp" %>
        <%@ include file="devops-tools-navbar.jsp" %>

            <div class="container-fluid px-lg-5 mt-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">Istio Service Mesh Generator</h1>
                        <p class="text-muted mb-0">Canary/Blue-Green Deployments, Gateways, mTLS & Authorization</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <!-- Preset Templates -->
                <div class="card tool-card mb-4">
                    <div class="card-body">
                        <h6 class="mb-3"><i class="fas fa-magic"></i> Quick Start Presets</h6>
                        <div class="d-flex flex-wrap">
                            <button class="btn btn-outline-primary preset-btn" onclick="loadPreset('canary')">
                                <i class="fas fa-random"></i> Canary Deployment (90/10)
                            </button>
                            <button class="btn btn-outline-success preset-btn" onclick="loadPreset('blue-green')">
                                <i class="fas fa-exchange-alt"></i> Blue-Green (50/50)
                            </button>
                            <button class="btn btn-outline-info preset-btn" onclick="loadPreset('http-gateway')">
                                <i class="fas fa-door-open"></i> HTTP Gateway
                            </button>
                            <button class="btn btn-outline-warning preset-btn" onclick="loadPreset('https-gateway')">
                                <i class="fas fa-lock"></i> HTTPS Gateway
                            </button>
                            <button class="btn btn-outline-danger preset-btn" onclick="loadPreset('mtls-strict')">
                                <i class="fas fa-shield-alt"></i> Strict mTLS
                            </button>
                            <button class="btn btn-outline-secondary preset-btn" onclick="loadPreset('authz-policy')">
                                <i class="fas fa-user-lock"></i> Authorization Policy
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Mode Selector -->
                <ul class="nav mode-selector" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#trafficMode"
                            onclick="switchMode('traffic')">
                            <i class="fas fa-route"></i> Traffic Splitting
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#gatewayMode" onclick="switchMode('gateway')">
                            <i class="fas fa-door-open"></i> Gateway
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#securityMode" onclick="switchMode('security')">
                            <i class="fas fa-shield-alt"></i> Security
                        </a>
                    </li>
                </ul>

                <div class="row mt-4">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-sliders-h mr-2"></i>
                                Configuration</div>
                            <div class="card-body" style="max-height: 800px; overflow-y: auto;">
                                <div class="tab-content">
                                    <!-- Traffic Splitting Mode -->
                                    <div id="trafficMode" class="tab-pane fade show active">
                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-info-circle"></i> Service
                                                Info</div>
                                            <div class="form-group">
                                                <label>Service Name</label>
                                                <input type="text" class="form-control" id="trafficServiceName"
                                                    value="my-service">
                                                <small class="text-muted">The Kubernetes service to route to</small>
                                            </div>
                                            <div class="form-group">
                                                <label>Namespace</label>
                                                <input type="text" class="form-control" id="trafficNamespace"
                                                    value="default">
                                            </div>
                                            <div class="form-group">
                                                <label>Host</label>
                                                <input type="text" class="form-control" id="trafficHost"
                                                    value="my-service.example.com">
                                                <small class="text-muted">DNS name to match (use * for all)</small>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-code-branch"></i> Version
                                                Subsets</div>
                                            <div id="subsetsContainer">
                                                <!-- Subsets will be added here -->
                                            </div>
                                            <button type="button" class="btn btn-outline-primary btn-block btn-sm"
                                                onclick="addSubset()">
                                                <i class="fas fa-plus"></i> Add Subset
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Gateway Mode -->
                                    <div id="gatewayMode" class="tab-pane fade">
                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-info-circle"></i> Gateway
                                                Info</div>
                                            <div class="form-group">
                                                <label>Gateway Name</label>
                                                <input type="text" class="form-control" id="gatewayName"
                                                    value="my-gateway">
                                            </div>
                                            <div class="form-group">
                                                <label>Namespace</label>
                                                <input type="text" class="form-control" id="gatewayNamespace"
                                                    value="default">
                                            </div>
                                            <div class="form-group">
                                                <label>Selector</label>
                                                <input type="text" class="form-control" id="gatewaySelector"
                                                    value="istio: ingressgateway">
                                                <small class="text-muted">Label selector for the gateway pods</small>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-network-wired"></i> Server
                                                Config</div>
                                            <div class="form-group">
                                                <label>Port</label>
                                                <input type="number" class="form-control" id="gatewayPort" value="80">
                                            </div>
                                            <div class="form-group">
                                                <label>Protocol</label>
                                                <select class="form-control" id="gatewayProtocol">
                                                    <option>HTTP</option>
                                                    <option>HTTPS</option>
                                                    <option>TCP</option>
                                                    <option>TLS</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>Hosts</label>
                                                <input type="text" class="form-control" id="gatewayHosts" value="*">
                                                <small class="text-muted">Comma-separated list of hosts (e.g.,
                                                    *.example.com)</small>
                                            </div>
                                            <div class="custom-control custom-switch">
                                                <input type="checkbox" class="custom-control-input" id="enableTLS">
                                                <label class="custom-control-label" for="enableTLS">Enable
                                                    TLS/HTTPS</label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Security Mode -->
                                    <div id="securityMode" class="tab-pane fade">
                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-info-circle"></i> Policy
                                                Info</div>
                                            <div class="form-group">
                                                <label>Policy Name</label>
                                                <input type="text" class="form-control" id="policyName"
                                                    value="default-mtls">
                                            </div>
                                            <div class="form-group">
                                                <label>Namespace</label>
                                                <input type="text" class="form-control" id="policyNamespace"
                                                    value="default">
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-lock"></i> mTLS
                                                Configuration</div>
                                            <div class="custom-control custom-switch mb-3">
                                                <input type="checkbox" class="custom-control-input" id="enableMtls"
                                                    checked>
                                                <label class="custom-control-label" for="enableMtls">Enable mTLS
                                                    Policy</label>
                                            </div>
                                            <div id="mtlsSettings">
                                                <div class="form-group">
                                                    <label>Mode</label>
                                                    <select class="form-control" id="mtlsMode">
                                                        <option value="STRICT">STRICT - Require mTLS</option>
                                                        <option value="PERMISSIVE">PERMISSIVE - Accept both mTLS and
                                                            plaintext</option>
                                                        <option value="DISABLE">DISABLE - No mTLS</option>
                                                    </select>
                                                    <small class="text-muted">STRICT is recommended for
                                                        production</small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-user-lock"></i>
                                                Authorization Policy</div>
                                            <div class="custom-control custom-switch mb-3">
                                                <input type="checkbox" class="custom-control-input" id="enableAuthz">
                                                <label class="custom-control-label" for="enableAuthz">Enable
                                                    Authorization Policy</label>
                                            </div>
                                            <div id="authzSettings" style="display:none">
                                                <div class="form-group">
                                                    <label>Action</label>
                                                    <select class="form-control" id="authzAction">
                                                        <option value="ALLOW">ALLOW</option>
                                                        <option value="DENY">DENY</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label>From Source (Namespace/Principal)</label>
                                                    <input type="text" class="form-control" id="authzFromSource"
                                                        value="istio-system/*"
                                                        placeholder="e.g., istio-system/*, cluster.local/ns/default/sa/myapp">
                                                    <small class="text-muted">Leave empty for all sources</small>
                                                </div>
                                                <div class="form-group">
                                                    <label>To Operation (Method/Path)</label>
                                                    <input type="text" class="form-control" id="authzToPath"
                                                        value="/api/*" placeholder="e.g., /api/*, /admin">
                                                    <small class="text-muted">Leave empty for all paths</small>
                                                </div>
                                                <div class="form-group">
                                                    <label>HTTP Methods</label>
                                                    <input type="text" class="form-control" id="authzMethods"
                                                        value="GET, POST" placeholder="e.g., GET, POST, DELETE">
                                                    <small class="text-muted">Comma-separated, leave empty for all
                                                        methods</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="sticky-preview">
                            <div class="card tool-card mb-3">
                                <div class="card-header bg-white p-0">
                                    <ul class="nav tab-preview" role="tablist" id="outputTabs">
                                        <!-- Tabs will be dynamically generated -->
                                    </ul>
                                </div>
                                <div class="card-body p-0">
                                    <div class="tab-content" id="outputContent">
                                        <!-- Output will be dynamically generated -->
                                    </div>
                                </div>
                                <div class="card-footer bg-light d-flex justify-content-end">
                                    <button class="btn btn-sm btn-outline-dark mr-2" onclick="copyYAML()"><i
                                            class="fas fa-copy"></i> Copy All</button>
                                    <button class="btn btn-sm btn-primary" onclick="downloadYAML()"><i
                                            class="fas fa-download"></i> Download All</button>
                                </div>
                            </div>

                            <div class="card tool-card bg-light">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-terminal"></i> How to Apply</h6>
                                    <pre class="bg-white p-2 mb-0 rounded"
                                        style="font-size: 0.8rem;">kubectl apply -f istio-config.yaml</pre>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card tool-card">
                            <div class="card-body">
                                <h5 class="card-title mb-4"><i class="fas fa-question-circle"></i> Frequently Asked
                                    Questions</h5>
                                <div class="accordion" id="faqAccordion">
                                    <div class="card">
                                        <div class="card-header" id="headingOne">
                                            <h2 class="mb-0">
                                                <button class="btn btn-link btn-block text-left" type="button"
                                                    data-toggle="collapse" data-target="#collapseOne">
                                                    What is a VirtualService?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseOne" class="collapse show" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                A <strong>VirtualService</strong> defines traffic routing rules. It
                                                controls how requests are routed to different versions of your service
                                                (e.g., 90% to v1, 10% to v2 for canary deployments).
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header" id="headingTwo">
                                            <h2 class="mb-0">
                                                <button class="btn btn-link btn-block text-left collapsed" type="button"
                                                    data-toggle="collapse" data-target="#collapseTwo">
                                                    What is a DestinationRule?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseTwo" class="collapse" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                A <strong>DestinationRule</strong> defines subsets of a service based on
                                                labels (e.g., version: v1). It's required for traffic splitting to work
                                                properly.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header" id="headingThree">
                                            <h2 class="mb-0">
                                                <button class="btn btn-link btn-block text-left collapsed" type="button"
                                                    data-toggle="collapse" data-target="#collapseThree">
                                                    What does mTLS STRICT mode do?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseThree" class="collapse" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                <strong>STRICT mode</strong> enforces mutual TLS for all traffic. Only
                                                encrypted, authenticated connections are allowed. This is the most
                                                secure option for production.
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                let subsets = [];
                let subsetCounter = 0;
                let currentMode = 'traffic';

                document.addEventListener('DOMContentLoaded', function () {
                    addSubset(); // Start with one subset
                    addSubset(); // And a second one
                    generateYAML();

                    // Add listeners
                    ['trafficServiceName', 'trafficNamespace', 'trafficHost'].forEach(id => {
                        document.getElementById(id).addEventListener('input', generateYAML);
                    });

                    ['gatewayName', 'gatewayNamespace', 'gatewaySelector', 'gatewayPort', 'gatewayProtocol', 'gatewayHosts'].forEach(id => {
                        document.getElementById(id).addEventListener('input', generateYAML);
                    });

                    document.getElementById('enableTLS').addEventListener('change', generateYAML);

                    ['policyName', 'policyNamespace', 'mtlsMode'].forEach(id => {
                        document.getElementById(id).addEventListener('input', generateYAML);
                    });

                    document.getElementById('enableMtls').addEventListener('change', function () {
                        document.getElementById('mtlsSettings').style.display = this.checked ? 'block' : 'none';
                        generateYAML();
                    });

                    document.getElementById('enableAuthz').addEventListener('change', function () {
                        document.getElementById('authzSettings').style.display = this.checked ? 'block' : 'none';
                        generateYAML();
                    });

                    ['authzAction', 'authzFromSource', 'authzToPath', 'authzMethods'].forEach(id => {
                        document.getElementById(id).addEventListener('input', generateYAML);
                    });
                });

                function switchMode(mode) {
                    currentMode = mode;
                    generateYAML();
                }

                function addSubset() {
                    const id = ++subsetCounter;
                    const version = `v${subsets.length + 1}`;
                    subsets.push({
                        id: id,
                        name: version,
                        labels: `version: ${version}`,
                        weight: subsets.length === 0 ? 90 : 10
                    });
                    renderSubsets();
                    generateYAML();
                }

                function removeSubset(id) {
                    subsets = subsets.filter(s => s.id !== id);
                    // Redistribute weights
                    if (subsets.length > 0) {
                        const equalWeight = Math.floor(100 / subsets.length);
                        subsets.forEach((s, idx) => {
                            s.weight = idx === 0 ? 100 - (equalWeight * (subsets.length - 1)) : equalWeight;
                        });
                    }
                    renderSubsets();
                    generateYAML();
                }

                function renderSubsets() {
                    const container = document.getElementById('subsetsContainer');
                    container.innerHTML = '';
                    subsets.forEach((subset) => {
                        const div = document.createElement('div');
                        div.className = 'subset-item';
                        div.innerHTML = `
                        <button class="btn btn-sm btn-danger float-right" onclick="removeSubset(${subset.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                        <div class="form-group">
                            <label class="font-weight-bold">Subset Name</label>
                            <input type="text" class="form-control form-control-sm" value="${subset.name}" 
                                   oninput="updateSubset(${subset.id}, 'name', this.value)">
                        </div>
                        <div class="form-group">
                            <label class="font-weight-bold">Labels (key: value)</label>
                            <input type="text" class="form-control form-control-sm" value="${subset.labels}" 
                                   oninput="updateSubset(${subset.id}, 'labels', this.value)">
                            <small class="text-muted">e.g., version: v1, env: prod</small>
                        </div>
                        <div class="form-group">
                            <label class="font-weight-bold">Traffic Weight</label>
                            <div class="d-flex align-items-center">
                                <input type="range" class="form-control-range weight-slider" min="0" max="100" value="${subset.weight}" 
                                       oninput="updateSubset(${subset.id}, 'weight', parseInt(this.value)); this.nextElementSibling.textContent = this.value + '%'">
                                <span class="weight-display ml-3">${subset.weight}%</span>
                            </div>
                        </div>
                    `;
                        container.appendChild(div);
                    });
                }

                function updateSubset(id, field, value) {
                    const subset = subsets.find(s => s.id === id);
                    subset[field] = value;

                    // Normalize weights if needed
                    if (field === 'weight') {
                        const total = subsets.reduce((sum, s) => sum + s.weight, 0);
                        if (total !== 100 && subsets.length > 1) {
                            // Adjust other weights proportionally
                            const others = subsets.filter(s => s.id !== id);
                            const remaining = 100 - value;
                            const oldTotal = others.reduce((sum, s) => sum + s.weight, 0);
                            others.forEach(s => {
                                s.weight = oldTotal > 0 ? Math.round((s.weight / oldTotal) * remaining) : Math.floor(remaining / others.length);
                            });
                            renderSubsets();
                        }
                    }
                    generateYAML();
                }

                function generateYAML() {
                    const outputTabs = document.getElementById('outputTabs');
                    const outputContent = document.getElementById('outputContent');
                    outputTabs.innerHTML = '';
                    outputContent.innerHTML = '';

                    if (currentMode === 'traffic') {
                        generateTrafficYAML(outputTabs, outputContent);
                    } else if (currentMode === 'gateway') {
                        generateGatewayYAML(outputTabs, outputContent);
                    } else if (currentMode === 'security') {
                        generateSecurityYAML(outputTabs, outputContent);
                    }
                }

                function generateTrafficYAML(tabsContainer, contentContainer) {
                    const serviceName = document.getElementById('trafficServiceName').value;
                    const namespace = document.getElementById('trafficNamespace').value;
                    const host = document.getElementById('trafficHost').value;

                    // VirtualService
                    let vsYaml = `apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: ${serviceName}-vs
  namespace: ${namespace}
spec:
  hosts:
  - ${host}
  http:
  - route:
`;
                    subsets.forEach(subset => {
                        vsYaml += `    - destination:
        host: ${serviceName}
        subset: ${subset.name}
      weight: ${subset.weight}
`;
                    });

                    // DestinationRule
                    let drYaml = `apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: ${serviceName}-dr
  namespace: ${namespace}
spec:
  host: ${serviceName}
  subsets:
`;
                    subsets.forEach(subset => {
                        const labels = subset.labels.split(',').map(l => {
                            const [key, val] = l.split(':').map(s => s.trim());
                            return `    ${key}: ${val}`;
                        }).join('\n');
                        drYaml += `  - name: ${subset.name}
    labels:
${labels}
`;
                    });

                    addOutputTab(tabsContainer, contentContainer, 'VirtualService', vsYaml, true);
                    addOutputTab(tabsContainer, contentContainer, 'DestinationRule', drYaml, false);
                }

                function generateGatewayYAML(tabsContainer, contentContainer) {
                    const name = document.getElementById('gatewayName').value;
                    const namespace = document.getElementById('gatewayNamespace').value;
                    const selector = document.getElementById('gatewaySelector').value;
                    const port = document.getElementById('gatewayPort').value;
                    const protocol = document.getElementById('gatewayProtocol').value;
                    const hosts = document.getElementById('gatewayHosts').value.split(',').map(h => h.trim());
                    const enableTLS = document.getElementById('enableTLS').checked;

                    // Gateway
                    const selectorParts = selector.split(':').map(s => s.trim());
                    let gwYaml = `apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: ${name}
  namespace: ${namespace}
spec:
  selector:
    ${selectorParts[0]}: ${selectorParts[1] || 'ingressgateway'}
  servers:
  - port:
      number: ${port}
      name: ${protocol.toLowerCase()}
      protocol: ${protocol}
    hosts:
${hosts.map(h => `    - ${h}`).join('\n')}`;

                    if (enableTLS && (protocol === 'HTTPS' || protocol === 'TLS')) {
                        gwYaml += `
    tls:
      mode: SIMPLE
      credentialName: ${name}-cert`;
                    }

                    addOutputTab(tabsContainer, contentContainer, 'Gateway', gwYaml, true);
                }

                function generateSecurityYAML(tabsContainer, contentContainer) {
                    const name = document.getElementById('policyName').value;
                    const namespace = document.getElementById('policyNamespace').value;
                    const mode = document.getElementById('mtlsMode').value;
                    const enableMtls = document.getElementById('enableMtls').checked;
                    const enableAuthz = document.getElementById('enableAuthz').checked;

                    let tabIndex = 0;

                    if (enableMtls) {
                        let paYaml = `apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: ${name}
  namespace: ${namespace}
spec:
  mtls:
    mode: ${mode}`;
                        addOutputTab(tabsContainer, contentContainer, 'PeerAuthentication', paYaml, tabIndex === 0);
                        tabIndex++;
                    }

                    if (enableAuthz) {
                        const action = document.getElementById('authzAction').value;
                        const fromSource = document.getElementById('authzFromSource').value.trim();
                        const toPath = document.getElementById('authzToPath').value.trim();
                        const methods = document.getElementById('authzMethods').value.trim();

                        let azYaml = `apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: ${name}-authz
  namespace: ${namespace}
spec:
  action: ${action}`;

                        if (fromSource || toPath || methods) {
                            azYaml += `\n  rules:\n  - `;
                            if (fromSource) {
                                azYaml += `from:\n    - source:\n        namespaces: ["${fromSource.split('/')[0]}"]\n    `;
                            }
                            if (toPath || methods) {
                                azYaml += `to:\n    - operation:`;
                                if (methods) {
                                    const methodList = methods.split(',').map(m => `"${m.trim()}"`).join(', ');
                                    azYaml += `\n        methods: [${methodList}]`;
                                }
                                if (toPath) {
                                    azYaml += `\n        paths: ["${toPath}"]`;
                                }
                            }
                        }

                        addOutputTab(tabsContainer, contentContainer, 'AuthorizationPolicy', azYaml, tabIndex === 0);
                    }
                }

                function addOutputTab(tabsContainer, contentContainer, name, yaml, active) {
                    const tabId = name.toLowerCase().replace(/\s+/g, '-');

                    const tab = document.createElement('li');
                    tab.className = 'nav-item';
                    tab.innerHTML = `<a class="nav-link ${active ? 'active' : ''}" data-toggle="tab" href="#${tabId}">${name}</a>`;
                    tabsContainer.appendChild(tab);

                    const content = document.createElement('div');
                    content.id = tabId;
                    content.className = `tab-pane fade ${active ? 'show active' : ''}`;
                    content.innerHTML = `<pre class="code-preview mb-0">${yaml}</pre>`;
                    contentContainer.appendChild(content);
                }

                function loadPreset(name) {
                    subsets = [];
                    subsetCounter = 0;

                    if (name === 'canary') {
                        currentMode = 'traffic';
                        document.getElementById('trafficServiceName').value = 'my-app';
                        document.getElementById('trafficHost').value = 'my-app.example.com';
                        subsets = [
                            { id: 1, name: 'stable', labels: 'version: stable', weight: 90 },
                            { id: 2, name: 'canary', labels: 'version: canary', weight: 10 }
                        ];
                        subsetCounter = 2;
                    } else if (name === 'blue-green') {
                        currentMode = 'traffic';
                        document.getElementById('trafficServiceName').value = 'my-app';
                        document.getElementById('trafficHost').value = 'my-app.example.com';
                        subsets = [
                            { id: 1, name: 'blue', labels: 'version: blue', weight: 50 },
                            { id: 2, name: 'green', labels: 'version: green', weight: 50 }
                        ];
                        subsetCounter = 2;
                    } else if (name === 'http-gateway') {
                        currentMode = 'gateway';
                        document.getElementById('gatewayName').value = 'http-gateway';
                        document.getElementById('gatewayPort').value = '80';
                        document.getElementById('gatewayProtocol').value = 'HTTP';
                        document.getElementById('gatewayHosts').value = '*';
                        document.getElementById('enableTLS').checked = false;
                    } else if (name === 'https-gateway') {
                        currentMode = 'gateway';
                        document.getElementById('gatewayName').value = 'https-gateway';
                        document.getElementById('gatewayPort').value = '443';
                        document.getElementById('gatewayProtocol').value = 'HTTPS';
                        document.getElementById('gatewayHosts').value = '*.example.com';
                        document.getElementById('enableTLS').checked = true;
                    } else if (name === 'mtls-strict') {
                        currentMode = 'security';
                        document.getElementById('policyName').value = 'default-mtls';
                        document.getElementById('policyNamespace').value = 'production';
                        document.getElementById('mtlsMode').value = 'STRICT';
                        document.getElementById('enableMtls').checked = true;
                        document.getElementById('enableAuthz').checked = false;
                        document.getElementById('mtlsSettings').style.display = 'block';
                        document.getElementById('authzSettings').style.display = 'none';
                    } else if (name === 'authz-policy') {
                        currentMode = 'security';
                        document.getElementById('policyName').value = 'api-access';
                        document.getElementById('policyNamespace').value = 'production';
                        document.getElementById('enableMtls').checked = false;
                        document.getElementById('enableAuthz').checked = true;
                        document.getElementById('authzAction').value = 'ALLOW';
                        document.getElementById('authzFromSource').value = 'istio-system/*';
                        document.getElementById('authzToPath').value = '/api/*';
                        document.getElementById('authzMethods').value = 'GET, POST';
                        document.getElementById('mtlsSettings').style.display = 'none';
                        document.getElementById('authzSettings').style.display = 'block';
                    }

                    // Switch to the appropriate tab
                    const modeMap = { traffic: 'trafficMode', gateway: 'gatewayMode', security: 'securityMode' };
                    $('.mode-selector .nav-link').removeClass('active');
                    $(`.mode-selector .nav-link[href="#${modeMap[currentMode]}"]`).addClass('active').tab('show');

                    renderSubsets();
                    generateYAML();
                }

                function copyYAML() {
                    const allYamls = [];
                    document.querySelectorAll('.code-preview').forEach(pre => {
                        allYamls.push(pre.textContent);
                    });
                    const combined = allYamls.join('\n---\n');

                    navigator.clipboard.writeText(combined).then(() => {
                        alert('All configurations copied to clipboard!');
                    });
                }

                function downloadYAML() {
                    const allYamls = [];
                    document.querySelectorAll('.code-preview').forEach(pre => {
                        allYamls.push(pre.textContent);
                    });
                    const combined = allYamls.join('\n---\n');

                    const blob = new Blob([combined], { type: 'text/yaml' });
                    const link = document.createElement('a');
                    link.href = URL.createObjectURL(blob);
                    link.download = 'istio-config.yaml';
                    link.click();
                }
            </script>

            <div class="sharethis-inline-share-buttons"></div>
            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="thanks.jsp" %>
                    <hr>
                    <%@ include file="addcomments.jsp" %>
                        </div>
                        <%@ include file="body-close.jsp" %>

    </html>
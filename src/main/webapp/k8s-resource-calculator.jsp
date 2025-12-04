<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

<head>
        <title>Kubernetes Resource Calculator Online – Free | 8gwifi.org</title>
        <meta name="description"
            content="Free Kubernetes resource calculator. Calculate optimal CPU and memory requests/limits, generate ResourceQuota and LimitRange YAML, estimate cloud costs for AWS, GCP, and Azure.">
        <meta name="keywords"
            content="kubernetes resource calculator, k8s quota calculator, cpu memory calculator, resourcequota generator, limitrange yaml, kubernetes cost calculator, pod resource limits">
        <%@ include file="header-script.jsp" %>
        <link rel="canonical" href="https://8gwifi.org/k8s-resource-calculator.jsp" />
        <meta property="og:type" content="website" />
        <meta property="og:title" content="Kubernetes Resource Calculator – Requests & Limits Sizing" />
        <meta property="og:description" content="Calculate Kubernetes CPU/Memory requests and limits with presets and guidance. Free, no signup." />
        <meta property="og:url" content="https://8gwifi.org/k8s-resource-calculator.jsp" />
        <meta property="og:site_name" content="8gwifi.org" />
        <meta property="og:image" content="https://8gwifi.org/images/site/kube.png" />
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content="Kubernetes Resource Calculator – Requests & Limits Sizing" />
        <meta name="twitter:description" content="Calculate Kubernetes CPU/Memory requests and limits with presets and guidance. Free, no signup." />
        <meta name="twitter:image" content="https://8gwifi.org/images/site/kube.png" />
        <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question","name": "What is the difference between requests and limits?","acceptedAnswer": {"@type": "Answer","text": "Requests are the guaranteed minimum for scheduling; limits cap the maximum usage to prevent noisy neighbors."}},
    {"@type": "Question","name": "How do I size resources for Java/Node/Go?","acceptedAnswer": {"@type": "Answer","text": "Start with language presets, profile under load, and apply a safety margin. Adjust per latency and GC behavior."}},
    {"@type": "Question","name": "How can I avoid OOMKilled?","acceptedAnswer": {"@type": "Answer","text": "Set memory limits above peak usage with headroom and monitor RSS; avoid aggressive overcommit for critical services."}}
  ]
}
        </script>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Kubernetes Resource Calculator",
      "description": "Calculate optimal resource requests/limits, generate ResourceQuota and LimitRange YAML, and estimate cloud costs.",
      "url": "https://8gwifi.org/k8s-resource-calculator.jsp",
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
        "Resource Request/Limit Calculator",
        "ResourceQuota Generator",
        "LimitRange Generator",
        "Cloud Cost Estimator"
      ]
    }
    </script>
            <style>
                :root {
                    --theme-primary: #0f1689;
                    --theme-secondary: #326ce5;
                    --theme-gradient: linear-gradient(135deg, #0f1689 0%, #326ce5 100%);
                    --theme-light: #e3f2fd;
                    --color-cpu: #3498db;
                    --color-memory: #e74c3c;
                    --color-cost: #2ecc71;
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
                    color: var(--theme-primary);
                    border-bottom: 3px solid var(--theme-primary);
                    background-color: transparent
                }

                .metric-card {
                    background: white;
                    border-left: 4px solid var(--color-cpu);
                    padding: 1rem;
                    border-radius: 4px;
                    margin-bottom: 1rem;
                }

                .metric-card.memory {
                    border-left-color: var(--color-memory);
                }

                .metric-card.cost {
                    border-left-color: var(--color-cost);
                }

                .metric-value {
                    font-size: 2rem;
                    font-weight: 700;
                    color: var(--theme-primary);
                }

                .metric-label {
                    color: #6c757d;
                    font-size: 0.9rem;
                }

                .recommendation {
                    background: #fff3cd;
                    border-left: 4px solid #ffc107;
                    padding: 1rem;
                    margin: 1rem 0;
                    border-radius: 4px;
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

                .qos-badge {
                    display: inline-block;
                    padding: 0.4rem 0.8rem;
                    border-radius: 20px;
                    font-weight: 600;
                    font-size: 0.85rem;
                    margin-left: 0.5rem;
                }

                .qos-guaranteed {
                    background: #d4edda;
                    color: #155724;
                    border: 2px solid #28a745;
                }

                .qos-burstable {
                    background: #fff3cd;
                    color: #856404;
                    border: 2px solid #ffc107;
                }

                .qos-besteffort {
                    background: #f8d7da;
                    color: #721c24;
                    border: 2px solid #dc3545;
                }

                .capacity-bar {
                    height: 30px;
                    background: #e9ecef;
                    border-radius: 4px;
                    overflow: hidden;
                    position: relative;
                    margin: 0.5rem 0;
                }

                .capacity-fill {
                    height: 100%;
                    background: linear-gradient(90deg, #28a745 0%, #28a745 70%, #ffc107 70%, #ffc107 90%, #dc3545 90%);
                    transition: width 0.3s ease;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-weight: 600;
                }
            </style>
    </head>
    <%@ include file="body-script.jsp" %>
        <%@ include file="devops-tools-navbar.jsp" %>

            <div class="container-fluid px-lg-5 mt-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">Kubernetes Resource Calculator</h1>
                        <p class="text-muted mb-0">Optimize Resource Quotas, Limits & Cloud Costs</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <!-- Preset Templates -->
                <div class="card tool-card mb-4">
                    <div class="card-body">
                        <h6 class="mb-3"><i class="fas fa-magic"></i> Quick Start Presets</h6>
                        <div class="d-flex flex-wrap">
                            <button class="btn btn-outline-primary preset-btn" onclick="loadPreset('development')">
                                <i class="fas fa-code"></i> Development
                            </button>
                            <button class="btn btn-outline-info preset-btn" onclick="loadPreset('staging')">
                                <i class="fas fa-flask"></i> Staging
                            </button>
                            <button class="btn btn-outline-success preset-btn" onclick="loadPreset('production')">
                                <i class="fas fa-rocket"></i> Production
                            </button>
                            <button class="btn btn-outline-warning preset-btn" onclick="loadPreset('microservices')">
                                <i class="fas fa-cubes"></i> Microservices
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Mode Selector -->
                <ul class="nav mode-selector" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#calculatorMode"
                            onclick="switchMode('calculator')">
                            <i class="fas fa-calculator"></i> Calculator
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#quotaMode" onclick="switchMode('quota')">
                            <i class="fas fa-tachometer-alt"></i> ResourceQuota
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#limitMode" onclick="switchMode('limit')">
                            <i class="fas fa-sliders-h"></i> LimitRange
                        </a>
                    </li>
                </ul>

                <div class="row mt-4">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-cog mr-2"></i> Configuration
                            </div>
                            <div class="card-body" style="max-height: 800px; overflow-y: auto;">
                                <div class="tab-content">
                                    <!-- Calculator Mode -->
                                    <div id="calculatorMode" class="tab-pane fade show active">
                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-cubes"></i> Workload
                                                Details</div>
                                            <div class="form-group">
                                                <label>Workload Type</label>
                                                <select class="form-control" id="workloadType">
                                                    <option value="web">Web Application</option>
                                                    <option value="api">API Service</option>
                                                    <option value="worker">Background Worker</option>
                                                    <option value="database">Database</option>
                                                    <option value="cache">Cache (Redis/Memcached)</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>Number of Pods</label>
                                                <input type="number" class="form-control" id="podCount" value="3"
                                                    min="1">
                                            </div>
                                            <div class="form-group">
                                                <label>Safety Margin for Limits</label>
                                                <input type="range" class="form-control-range" id="safetyMargin"
                                                    min="1.0" max="3.0" step="0.1" value="1.5">
                                                <small class="text-muted">Limit = Request × <span
                                                        id="safetyMarginValue">1.5</span></small>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-server"></i> Node Capacity
                                                Planning</div>
                                            <div class="form-group">
                                                <label>Node Size (vCPU)</label>
                                                <select class="form-control" id="nodeSize">
                                                    <option value="2,4">Small (2 vCPU, 4Gi RAM)</option>
                                                    <option value="4,16" selected>Medium (4 vCPU, 16Gi RAM)</option>
                                                    <option value="8,32">Large (8 vCPU, 32Gi RAM)</option>
                                                    <option value="16,64">XLarge (16 vCPU, 64Gi RAM)</option>
                                                </select>
                                                <small class="text-muted">How many pods fit per node?</small>
                                            </div>
                                            <div id="nodeCapacityInfo" class="mt-3">
                                                <strong>Pods per Node: <span id="podsPerNode"
                                                        class="text-primary">-</span></strong>
                                                <div class="capacity-bar mt-2">
                                                    <div class="capacity-fill" id="capacityFill" style="width: 0%">0%
                                                    </div>
                                                </div>
                                                <small class="text-muted">Node utilization based on your pod
                                                    resources</small>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-chart-line"></i>
                                                Utilization Simulator</div>
                                            <div class="form-group">
                                                <label>Average CPU Utilization (%)</label>
                                                <input type="range" class="form-control-range" id="avgCpuUtilization"
                                                    min="10" max="90" step="5" value="50">
                                                <small class="text-muted">Simulate average CPU usage: <span
                                                        id="avgCpuUtilizationValue">50</span>%</small>
                                            </div>
                                            <div class="form-group">
                                                <label>Average Memory Utilization (%)</label>
                                                <input type="range" class="form-control-range" id="avgMemUtilization"
                                                    min="10" max="90" step="5" value="60">
                                                <small class="text-muted">Simulate average Memory usage: <span
                                                        id="avgMemUtilizationValue">60</span>%</small>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-arrows-alt-h"></i>
                                                Right-Sizing Recommendations</div>
                                            <div class="form-group">
                                                <label>Target CPU Utilization (%)</label>
                                                <input type="range" class="form-control-range" id="targetCpuUtilization"
                                                    min="50" max="90" step="5" value="70">
                                                <small class="text-muted">Aim for <span
                                                        id="targetCpuUtilizationValue">70</span>% average CPU
                                                    utilization</small>
                                            </div>
                                            <div class="form-group">
                                                <label>Target Memory Utilization (%)</label>
                                                <input type="range" class="form-control-range" id="targetMemUtilization"
                                                    min="50" max="90" step="5" value="80">
                                                <small class="text-muted">Aim for <span
                                                        id="targetMemUtilizationValue">80</span>% average Memory
                                                    utilization</small>
                                            </div>
                                            <div class="form-group">
                                                <label>Peak CPU Usage (observed)</label>
                                                <input type="number" class="form-control" id="peakCpuUsage" value="0"
                                                    min="0" step="0.1">
                                                <small class="text-muted">Enter observed peak CPU usage (e.g., from
                                                    Prometheus)</small>
                                            </div>
                                            <div class="form-group">
                                                <label>Peak Memory Usage (observed)</label>
                                                <input type="number" class="form-control" id="peakMemUsage" value="0"
                                                    min="0" step="1">
                                                <small class="text-muted">Enter observed peak Memory usage in
                                                    MiB</small>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ResourceQuota Mode -->
                                    <div id="quotaMode" class="tab-pane fade">
                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-info-circle"></i> Namespace
                                                Info</div>
                                            <div class="form-group">
                                                <label>Namespace Name</label>
                                                <input type="text" class="form-control" id="quotaNamespace"
                                                    value="production">
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-microchip"></i> Compute
                                                Resources</div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label>CPU Limit (cores)</label>
                                                        <input type="number" class="form-control" id="quotaCpuLimit"
                                                            value="100">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label>Memory Limit (Gi)</label>
                                                        <input type="number" class="form-control" id="quotaMemLimit"
                                                            value="200">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-boxes"></i> Object Limits
                                            </div>
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label>Max Pods</label>
                                                        <input type="number" class="form-control" id="quotaMaxPods"
                                                            value="100">
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label>Max Services</label>
                                                        <input type="number" class="form-control" id="quotaMaxServices"
                                                            value="20">
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label>Max PVCs</label>
                                                        <input type="number" class="form-control" id="quotaMaxPvcs"
                                                            value="10">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- LimitRange Mode -->
                                    <div id="limitMode" class="tab-pane fade">
                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-info-circle"></i>
                                                LimitRange Info</div>
                                            <div class="form-group">
                                                <label>Namespace Name</label>
                                                <input type="text" class="form-control" id="limitNamespace"
                                                    value="production">
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-server"></i> Container
                                                Defaults</div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <label class="font-weight-bold">CPU</label>
                                                    <div class="form-group">
                                                        <label class="small">Default Request</label>
                                                        <input type="text" class="form-control form-control-sm"
                                                            id="limitCpuRequest" value="100m">
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="small">Default Limit</label>
                                                        <input type="text" class="form-control form-control-sm"
                                                            id="limitCpuLimit" value="500m">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="font-weight-bold">Memory</label>
                                                    <div class="form-group">
                                                        <label class="small">Default Request</label>
                                                        <input type="text" class="form-control form-control-sm"
                                                            id="limitMemRequest" value="128Mi">
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="small">Default Limit</label>
                                                        <input type="text" class="form-control form-control-sm"
                                                            id="limitMemLimit" value="512Mi">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><i class="fas fa-expand-arrows-alt"></i>
                                                Min/Max Constraints</div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="small">Max CPU</label>
                                                        <input type="text" class="form-control form-control-sm"
                                                            id="limitMaxCpu" value="4">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="small">Max Memory</label>
                                                        <input type="text" class="form-control form-control-sm"
                                                            id="limitMaxMem" value="8Gi">
                                                    </div>
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
                            <!-- Metrics Cards (Calculator Mode Only) -->
                            <div id="metricsSection" style="display:block;">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="metric-card">
                                            <div class="metric-label">CPU Request/Limit</div>
                                            <div class="metric-value" id="cpuMetric">-</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="metric-card memory">
                                            <div class="metric-label">Memory Request/Limit</div>
                                            <div class="metric-value" id="memMetric">-</div>
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <div class="metric-card" style="border-left-color: #9b59b6">
                                            <div class="metric-label">
                                                QoS Class
                                                <span id="qosBadge" class="qos-badge">-</span>
                                            </div>
                                            <small class="text-muted" id="qosExplanation">-</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="metric-card cost">
                                    <div class="metric-label">
                                        Monthly Cost
                                        <select id="cloudProvider" class="form-control form-control-sm d-inline-block"
                                            style="width: auto; margin-left: 10px;">
                                            <option value="aws">AWS</option>
                                            <option value="gcp">GCP</option>
                                            <option value="azure">Azure</option>
                                        </select>
                                    </div>
                                    <div class="metric-value" id="costMetric">$0</div>
                                    <small class="text-muted" id="costBreakdown">-</small>
                                </div>
                                <div class="recommendation" id="recommendation">
                                    <strong><i class="fas fa-lightbulb"></i> Recommendation:</strong>
                                    <span id="recommendationText">Configure your workload to see recommendations.</span>
                                </div>
                            </div>

                            <!-- YAML Output -->
                            <div class="card tool-card mb-3">
                                <div class="card-header bg-white p-0">
                                    <ul class="nav tab-preview" role="tablist" id="outputTabs">
                                        <li class="nav-item">
                                            <a class="nav-link active" data-toggle="tab" href="#yamlOutput">YAML
                                                Output</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body p-0">
                                    <pre id="yamlOutput" class="code-preview mb-0"></pre>
                                </div>
                                <div class="card-footer bg-light d-flex justify-content-end">
                                    <button class="btn btn-sm btn-outline-dark mr-2" onclick="copyYAML()"><i
                                            class="fas fa-copy"></i> Copy</button>
                                    <button class="btn btn-sm btn-primary" onclick="downloadYAML()"><i
                                            class="fas fa-download"></i> Download</button>
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
                                                    What's the difference between requests and limits?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseOne" class="collapse show" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                <strong>Requests</strong> are the guaranteed resources a pod gets. The
                                                scheduler uses this for placement.<br>
                                                <strong>Limits</strong> are the maximum resources a pod can use. If
                                                exceeded, the pod may be throttled (CPU) or OOMKilled (memory).
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header" id="headingTwo">
                                            <h2 class="mb-0">
                                                <button class="btn btn-link btn-block text-left collapsed" type="button"
                                                    data-toggle="collapse" data-target="#collapseTwo">
                                                    What is ResourceQuota?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseTwo" class="collapse" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                <strong>ResourceQuota</strong> sets limits on the total resources (CPU,
                                                memory, pods, etc.) that can be consumed in a namespace. It prevents
                                                resource hoarding.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header" id="headingThree">
                                            <h2 class="mb-0">
                                                <button class="btn btn-link btn-block text-left collapsed" type="button"
                                                    data-toggle="collapse" data-target="#collapseThree">
                                                    How accurate is the cost estimation?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseThree" class="collapse" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                Cost estimates are based on standard on-demand pricing for
                                                general-purpose instances. Actual costs vary based on region, instance
                                                type, reserved capacity, and spot instances.
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
                let currentMode = 'calculator';

                // Workload presets (CPU in millicores, Memory in Mi)
                const workloadDefaults = {
                    web: { cpuRequest: 100, memRequest: 256 },
                    api: { cpuRequest: 200, memRequest: 512 },
                    worker: { cpuRequest: 500, memRequest: 1024 },
                    database: { cpuRequest: 1000, memRequest: 2048 },
                    cache: { cpuRequest: 250, memRequest: 512 }
                };

                // Cloud pricing per vCPU/month and per GB memory/month (approximate)
                const cloudPricing = {
                    aws: { cpu: 36.5, memory: 4.5 },    // EKS on t3 instances
                    gcp: { cpu: 31.5, memory: 4.2 },    // GKE standard
                    azure: { cpu: 35.0, memory: 4.3 }   // AKS
                };

                document.addEventListener('DOMContentLoaded', function () {
                    calculate();

                    // Add event listeners
                    ['workloadType', 'podCount', 'safetyMargin', 'cloudProvider', 'nodeSize'].forEach(id => {
                        const el = document.getElementById(id);
                        if (el) el.addEventListener('change', calculate);
                    });

                    document.getElementById('safetyMargin').addEventListener('input', function () {
                        document.getElementById('safetyMarginValue').textContent = this.value;
                        calculate();
                    });

                    ['quotaNamespace', 'quotaCpuLimit', 'quotaMemLimit', 'quotaMaxPods', 'quotaMaxServices', 'quotaMaxPvcs'].forEach(id => {
                        const el = document.getElementById(id);
                        if (el) el.addEventListener('input', generateYAML);
                    });

                    ['limitNamespace', 'limitCpuRequest', 'limitCpuLimit', 'limitMemRequest', 'limitMemLimit', 'limitMaxCpu', 'limitMaxMem'].forEach(id => {
                        const el = document.getElementById(id);
                        if (el) el.addEventListener('input', generateYAML);
                    });

                    ['simNamespaceCpu', 'simNamespaceMem'].forEach(id => {
                        const el = document.getElementById(id);
                        if (el) el.addEventListener('input', calculateUtilization);
                    });
                });

                function switchMode(mode) {
                    currentMode = mode;
                    if (mode === 'calculator') {
                        document.getElementById('metricsSection').style.display = 'block';
                        calculate();
                    } else {
                        document.getElementById('metricsSection').style.display = 'none';
                        generateYAML();
                    }
                }

                function calculate() {
                    const workloadType = document.getElementById('workloadType').value;
                    const podCount = parseInt(document.getElementById('podCount').value) || 1;
                    const safetyMargin = parseFloat(document.getElementById('safetyMargin').value);
                    const cloudProvider = document.getElementById('cloudProvider').value;

                    const defaults = workloadDefaults[workloadType];
                    const cpuRequest = defaults.cpuRequest;
                    const memRequest = defaults.memRequest;
                    const cpuLimit = Math.round(cpuRequest * safetyMargin);
                    const memLimit = Math.round(memRequest * safetyMargin);

                    // Display metrics
                    document.getElementById('cpuMetric').textContent = `${cpuRequest}m / ${cpuLimit}m`;
                    document.getElementById('memMetric').textContent = `${memRequest}Mi / ${memLimit}Mi`;

                    // Calculate QoS Class
                    const qosClass = calculateQoS(cpuRequest, cpuLimit, memRequest, memLimit);
                    updateQoSDisplay(qosClass);

                    // Calculate node capacity
                    calculateNodeCapacity(cpuRequest, memRequest);

                    // Calculate utilization simulator
                    calculateUtilization();

                    // Calculate cost
                    const pricing = cloudPricing[cloudProvider];
                    const totalCpu = (cpuRequest / 1000) * podCount; // Convert to cores
                    const totalMem = (memRequest / 1024) * podCount; // Convert to GB
                    const monthlyCost = (totalCpu * pricing.cpu) + (totalMem * pricing.memory);

                    document.getElementById('costMetric').textContent = `$${monthlyCost.toFixed(2)}/mo`;
                    document.getElementById('costBreakdown').textContent = `${podCount} pods × ${cpuRequest}m CPU, ${memRequest}Mi RAM`;

                    // Generate recommendation
                    let rec = `For ${workloadType} workloads, these resources should handle normal traffic. `;
                    if (safetyMargin < 1.3) {
                        rec += '⚠️ Your safety margin is low - pods may get throttled.';
                    } else if (safetyMargin > 2.0) {
                        rec += '💡 Consider reducing the safety margin to save costs.';
                    } else {
                        rec += '✅ Good safety margin for production.';
                    }
                    document.getElementById('recommendationText').textContent = rec;

                    // Generate YAML (per-pod resources)
                    let yaml = `# Resource configuration for ${podCount} ${workloadType} pod(s)\n\n`;
                    yaml += `resources:\n`;
                    yaml += `  requests:\n`;
                    yaml += `    cpu: ${cpuRequest}m\n`;
                    yaml += `    memory: ${memRequest}Mi\n`;
                    yaml += `  limits:\n`;
                    yaml += `    cpu: ${cpuLimit}m\n`;
                    yaml += `    memory: ${memLimit}Mi\n`;

                    document.getElementById('yamlOutput').textContent = yaml;
                }

                function calculateQoS(cpuReq, cpuLim, memReq, memLim) {
                    // Guaranteed: requests = limits for both CPU and memory
                    if (cpuReq === cpuLim && memReq === memLim) {
                        return 'Guaranteed';
                    }
                    // BestEffort: no requests or limits set
                    if (cpuReq === 0 && memReq === 0) {
                        return 'BestEffort';
                    }
                    // Burstable: everything else
                    return 'Burstable';
                }

                function updateQoSDisplay(qosClass) {
                    const badge = document.getElementById('qosBadge');
                    const explanation = document.getElementById('qosExplanation');

                    badge.textContent = qosClass;
                    badge.className = 'qos-badge';

                    if (qosClass === 'Guaranteed') {
                        badge.classList.add('qos-guaranteed');
                        explanation.textContent = 'Highest priority. Pod gets exactly what it requests. Never evicted due to resource pressure from other pods.';
                    } else if (qosClass === 'Burstable') {
                        badge.classList.add('qos-burstable');
                        explanation.textContent = 'Medium priority. Can use more than requested (up to limit). May be throttled or evicted under memory pressure.';
                    } else {
                        badge.classList.add('qos-besteffort');
                        explanation.textContent = 'Lowest priority. No guaranteed resources. First to be evicted when nodes run out of resources.';
                    }
                }

                function calculateNodeCapacity(cpuReq, memReq) {
                    const nodeSize = document.getElementById('nodeSize').value.split(',');
                    const nodeCpu = parseFloat(nodeSize[0]) * 1000; // Convert to millicores
                    const nodeMem = parseFloat(nodeSize[1]) * 1024; // Convert to Mi

                    // Account for system overhead (~10%)
                    const availableCpu = nodeCpu * 0.9;
                    const availableMem = nodeMem * 0.9;

                    // Calculate how many pods fit
                    const podsByCpu = Math.floor(availableCpu / cpuReq);
                    const podsByMem = Math.floor(availableMem / memReq);
                    const podsPerNode = Math.min(podsByCpu, podsByMem);

                    // Calculate utilization
                    const cpuUtil = (cpuReq * podsPerNode) / availableCpu * 100;
                    const memUtil = (memReq * podsPerNode) / availableMem * 100;
                    const avgUtil = (cpuUtil + memUtil) / 2;

                    document.getElementById('podsPerNode').textContent = podsPerNode;
                    document.getElementById('capacityFill').style.width = `${avgUtil}%`;
                    document.getElementById('capacityFill').textContent = `${avgUtil.toFixed(0)}%`;
                }

                function calculateUtilization() {
                    // Check if utilization simulator elements exist
                    const simCpuEl = document.getElementById('simNamespaceCpu');
                    const simMemEl = document.getElementById('simNamespaceMem');

                    if (!simCpuEl || !simMemEl) {
                        return; // Elements don't exist, skip calculation
                    }

                    const workloadType = document.getElementById('workloadType').value;
                    const podCount = parseInt(document.getElementById('podCount').value) || 1;
                    const namespaceCpu = parseFloat(simCpuEl.value) * 1000; // Convert to millicores
                    const namespaceMem = parseFloat(simMemEl.value) * 1024; // Convert to Mi

                    const defaults = workloadDefaults[workloadType];
                    const cpuRequest = defaults.cpuRequest;
                    const memRequest = defaults.memRequest;

                    // Calculate max pods that fit in namespace
                    const maxPodsByCpu = Math.floor(namespaceCpu / cpuRequest);
                    const maxPodsByMem = Math.floor(namespaceMem / memRequest);
                    const maxPods = Math.min(maxPodsByCpu, maxPodsByMem);

                    // Calculate remaining capacity
                    const usedCpu = cpuRequest * podCount;
                    const usedMem = memRequest * podCount;
                    const remainingCpu = namespaceCpu - usedCpu;
                    const remainingMem = namespaceMem - usedMem;
                    const remainingPods = maxPods - podCount;

                    const maxPodsEl = document.getElementById('maxPods');
                    const remainingEl = document.getElementById('remaining');

                    if (maxPodsEl) maxPodsEl.textContent = `${maxPods} pods`;
                    if (remainingEl) {
                        if (remainingPods > 0) {
                            remainingEl.innerHTML = `<span class="text-success">✅ ${remainingPods} more pods (${(remainingCpu / 1000).toFixed(1)} CPU, ${(remainingMem / 1024).toFixed(1)}Gi RAM)</span>`;
                        } else if (remainingPods === 0) {
                            remainingEl.innerHTML = `<span class="text-warning">⚠️ At capacity</span>`;
                        } else {
                            remainingEl.innerHTML = `<span class="text-danger">🚫 Over quota by ${Math.abs(remainingPods)} pods!</span>`;
                        }
                    }
                }

                function analyzeMetrics() {
                    const input = document.getElementById('kubectlTopInput').value.trim();
                    if (!input) {
                        alert('Please paste kubectl top pod output');
                        return;
                    }

                    // Parse kubectl top output
                    const lines = input.split('\n').filter(l => l.trim() && !l.startsWith('NAME'));
                    const metrics = [];

                    lines.forEach(line => {
                        const parts = line.trim().split(/\s+/);
                        if (parts.length >= 3) {
                            const cpuStr = parts[1]; // e.g., "150m"
                            const memStr = parts[2]; // e.g., "280Mi"

                            const cpu = parseInt(cpuStr.replace('m', '')) || 0;
                            const mem = parseInt(memStr.replace('Mi', '').replace('M', '')) || 0;

                            metrics.push({ cpu, mem });
                        }
                    });

                    if (metrics.length === 0) {
                        alert('Could not parse metrics. Format: NAME CPU(cores) MEMORY(bytes)');
                        return;
                    }

                    // Calculate P95 (95th percentile)
                    const cpuValues = metrics.map(m => m.cpu).sort((a, b) => a - b);
                    const memValues = metrics.map(m => m.mem).sort((a, b) => a - b);
                    const p95Index = Math.floor(metrics.length * 0.95);

                    const p95Cpu = cpuValues[p95Index];
                    const p95Mem = memValues[p95Index];

                    // Recommend request = P95, limit = P95 * 1.3
                    const recommendedCpuRequest = Math.ceil(p95Cpu / 10) * 10; // Round up to nearest 10m
                    const recommendedMemRequest = Math.ceil(p95Mem / 64) * 64; // Round up to nearest 64Mi
                    const recommendedCpuLimit = Math.ceil(recommendedCpuRequest * 1.3);
                    const recommendedMemLimit = Math.ceil(recommendedMemRequest * 1.3);

                    // Show results
                    const resultDiv = document.getElementById('rightsizingResult');
                    const resultText = document.getElementById('rightsizingText');

                    resultText.innerHTML = `
                        <strong>Analyzed ${metrics.length} pods</strong><br>
                        <strong>Recommended Request:</strong> ${recommendedCpuRequest}m CPU, ${recommendedMemRequest}Mi RAM<br>
                        <strong>Recommended Limit:</strong> ${recommendedCpuLimit}m CPU, ${recommendedMemLimit}Mi RAM<br>
                        <small class="text-muted">Based on P95 (95th percentile) actual usage + 30% safety margin</small>
                    `;

                    resultDiv.style.display = 'block';
                }

                function generateYAML() {
                    let yaml = '';

                    if (currentMode === 'quota') {
                        const ns = document.getElementById('quotaNamespace').value;
                        const cpuLimit = document.getElementById('quotaCpuLimit').value;
                        const memLimit = document.getElementById('quotaMemLimit').value;
                        const maxPods = document.getElementById('quotaMaxPods').value;
                        const maxServices = document.getElementById('quotaMaxServices').value;
                        const maxPvcs = document.getElementById('quotaMaxPvcs').value;

                        yaml = `apiVersion: v1\nkind: ResourceQuota\nmetadata:\n  name: ${ns}-quota\n  namespace: ${ns}\nspec:\n  hard:\n    requests.cpu: "${cpuLimit}"\n    requests.memory: ${memLimit}Gi\n    limits.cpu: "${cpuLimit}"\n    limits.memory: ${memLimit}Gi\n    pods: "${maxPods}"\n    services: "${maxServices}"\n    persistentvolumeclaims: "${maxPvcs}"`;
                    } else if (currentMode === 'limit') {
                        const ns = document.getElementById('limitNamespace').value;
                        const cpuReq = document.getElementById('limitCpuRequest').value;
                        const cpuLim = document.getElementById('limitCpuLimit').value;
                        const memReq = document.getElementById('limitMemRequest').value;
                        const memLim = document.getElementById('limitMemLimit').value;
                        const maxCpu = document.getElementById('limitMaxCpu').value;
                        const maxMem = document.getElementById('limitMaxMem').value;

                        yaml = `apiVersion: v1\nkind: LimitRange\nmetadata:\n  name: ${ns}-limits\n  namespace: ${ns}\nspec:\n  limits:\n  - default:\n      cpu: ${cpuLim}\n      memory: ${memLim}\n    defaultRequest:\n      cpu: ${cpuReq}\n      memory: ${memReq}\n    max:\n      cpu: ${maxCpu}\n      memory: ${maxMem}\n    type: Container`;
                    }

                    document.getElementById('yamlOutput').textContent = yaml;
                }

                function loadPreset(name) {
                    if (name === 'development') {
                        document.getElementById('workloadType').value = 'web';
                        document.getElementById('podCount').value = '2';
                        document.getElementById('safetyMargin').value = '1.3';
                    } else if (name === 'staging') {
                        document.getElementById('workloadType').value = 'api';
                        document.getElementById('podCount').value = '5';
                        document.getElementById('safetyMargin').value = '1.5';
                    } else if (name === 'production') {
                        document.getElementById('workloadType').value = 'api';
                        document.getElementById('podCount').value = '10';
                        document.getElementById('safetyMargin').value = '1.8';
                    } else if (name === 'microservices') {
                        document.getElementById('workloadType').value = 'api';
                        document.getElementById('podCount').value = '15';
                        document.getElementById('safetyMargin').value = '1.5';
                    }

                    document.getElementById('safetyMarginValue').textContent = document.getElementById('safetyMargin').value;

                    // Switch to calculator mode
                    $('.mode-selector .nav-link').removeClass('active');
                    $('.mode-selector .nav-link[href="#calculatorMode"]').addClass('active').tab('show');
                    currentMode = 'calculator';
                    document.getElementById('metricsSection').style.display = 'block';
                    calculate();
                }

                function copyYAML() {
                    const content = document.getElementById('yamlOutput').textContent;
                    navigator.clipboard.writeText(content).then(() => {
                        alert('Copied to clipboard!');
                    });
                }

                function downloadYAML() {
                    const content = document.getElementById('yamlOutput').textContent;
                    const blob = new Blob([content], { type: 'text/yaml' });
                    const link = document.createElement('a');
                    link.href = URL.createObjectURL(blob);
                    link.download = currentMode === 'quota' ? 'resourcequota.yaml' :
                        (currentMode === 'limit' ? 'limitrange.yaml' : 'resources.yaml');
                    link.click();
                }
            </script>

            <hr>
            <h2 class="mt-4" id="faqs">Kubernetes Resources FAQs</h2>
            <div class="accordion" id="k8sResFaqs">
                <div class="card"><div class="card-header"><h6 class="mb-0">Requests vs limits?</h6></div><div class="card-body small text-muted">Requests guarantee scheduling; limits cap maximum usage. Start with requests≈typical load and add modest headroom.</div></div>
                <div class="card"><div class="card-header"><h6 class="mb-0">Language presets guidance</h6></div><div class="card-body small text-muted">Use presets per runtime, then profile under realistic load. Tune CPU for latency and memory for GC or heap growth.</div></div>
                <div class="card"><div class="card-header"><h6 class="mb-0">Avoiding OOMKilled</h6></div><div class="card-body small text-muted">Set memory limits above peak, monitor RSS, and avoid extreme overcommit for critical workloads.</div></div>
            </div>

            <div class="sharethis-inline-share-buttons"></div>
            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="thanks.jsp" %>
                    <hr>
                    <%@ include file="addcomments.jsp" %>
                        </div>
                        <%@ include file="body-close.jsp" %>

    </html>

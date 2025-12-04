<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <title>Helm Chart Generator – Kubernetes Chart Scaffolder – Free | 8gwifi.org</title>
    <meta name="description"
        content="Generate production-ready Helm charts with deployments, services, ingress, HPA, and more. Free Kubernetes chart generator.">
    <meta name="keywords"
        content="helm chart, kubernetes, helm generator, k8s chart, helm scaffolder, kubernetes deployment, values.yaml, ingress, hpa">
    <link rel="canonical" href="https://8gwifi.org/helm-chart-generator.jsp" />
    <meta property="og:type" content="website" />
    <meta property="og:title" content="Helm Chart Generator – Kubernetes Charts with Deploy, Ingress, HPA" />
    <meta property="og:description" content="Generate complete Helm charts: Deployments, Services, Ingress, HPA, and more. Free, no signup." />
    <meta property="og:url" content="https://8gwifi.org/helm-chart-generator.jsp" />
    <meta property="og:site_name" content="8gwifi.org" />
    <meta property="og:image" content="https://8gwifi.org/images/site/helm-chart-generator.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Helm Chart Generator – Kubernetes Charts with Deploy, Ingress, HPA" />
    <meta name="twitter:description" content="Generate complete Helm charts: Deployments, Services, Ingress, HPA, and more. Free, no signup." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/helm-chart-generator.png" />
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {"@context":"https://schema.org","@type":"WebApplication","name":"Helm Chart Generator","description":"Generate complete Helm charts for Kubernetes applications.","url":"https://8gwifi.org/helm-chart-generator.jsp","author":{"@type":"Person","name":"Anish Nath"},"datePublished":"2025-01-15"}
    </script>
        <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question","name": "How do I structure values.yaml?","acceptedAnswer": {"@type": "Answer","text": "Keep image, resources, service, ingress, and autoscaling keys at the top level for clarity; the generator outputs a clean default structure."}},
    {"@type": "Question","name": "Does this support Ingress and HPA?","acceptedAnswer": {"@type": "Answer","text": "Yes. Toggle Ingress and HorizontalPodAutoscaler; YAML is generated with sensible defaults."}},
    {"@type": "Question","name": "Can I download the chart?","acceptedAnswer": {"@type": "Answer","text": "Yes. Copy individual files or download the full chart as a bundle."}}
  ]
}
        </script>
        <style>
            :root {
                --theme-primary: #0f1689;
                --theme-secondary: #326ce5;
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
                min-height: 500px;
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

            .tab-preview {
                border-bottom: 2px solid #dee2e6
            }

            .tab-preview .nav-link {
                border: none;
                color: #6c757d;
                font-weight: 500;
                padding: 0.75rem 1rem;
                cursor: pointer;
                transition: all 0.3s ease
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

            .help-text {
                font-size: 0.8rem;
                color: #6c757d;
                margin-top: 0.25rem
            }

            .feature-tag {
                display: inline-block;
                background: #e3f2fd;
                color: var(--theme-primary);
                padding: 0.2rem 0.6rem;
                border-radius: 12px;
                font-size: 0.75rem;
                margin-left: 0.5rem
            }
        </style>
</head>
<%@ include file="body-script.jsp" %>
    <%@ include file="devops-tools-navbar.jsp" %>

        <div class="container-fluid px-lg-5 mt-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 mb-0">Helm Chart Scaffolder</h1>
                    <p class="text-muted mb-0">Generate production-ready Kubernetes Helm charts</p>
                </div>
                <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
            </div>

            <!-- Preset Templates -->
            <div class="card tool-card mb-4">
                <div class="card-body">
                    <h6 class="mb-3"><i class="fas fa-magic"></i> Quick Start Presets</h6>
                    <div class="d-flex flex-wrap">
                        <button class="btn btn-outline-primary preset-btn" onclick="loadPreset('web-app')">
                            <i class="fas fa-globe"></i> Web Application
                        </button>
                        <button class="btn btn-outline-info preset-btn" onclick="loadPreset('microservice')">
                            <i class="fas fa-cubes"></i> Microservice
                        </button>
                        <button class="btn btn-outline-success preset-btn" onclick="loadPreset('stateful')">
                            <i class="fas fa-database"></i> Stateful App
                        </button>
                        <button class="btn btn-outline-warning preset-btn" onclick="loadPreset('batch-job')">
                            <i class="fas fa-tasks"></i> Batch Job
                        </button>
                        <button class="btn btn-outline-danger preset-btn" onclick="loadPreset('ingress-controller')">
                            <i class="fas fa-network-wired"></i> Ingress Controller
                        </button>
                        <button class="btn btn-outline-secondary preset-btn" onclick="loadPreset('monitoring')">
                            <i class="fas fa-chart-line"></i> Monitoring Stack
                        </button>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-5">
                    <div class="card tool-card mb-4">
                        <div class="card-header card-header-custom"><i class="fas fa-dharmachakra mr-2"></i> Chart
                            Configuration</div>
                        <div class="card-body" style="max-height: 800px; overflow-y: auto;">
                            <form id="chartForm">
                                <!-- Basic Info -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-info-circle"></i> Basic Information
                                    </div>
                                    <div class="form-group">
                                        <label>Chart Name</label>
                                        <input type="text" class="form-control" id="chartName" value="my-app">
                                        <small class="help-text">Lowercase letters, numbers, and hyphens only</small>
                                    </div>
                                    <div class="form-group">
                                        <label>Description</label>
                                        <input type="text" class="form-control" id="chartDescription"
                                            value="A Helm chart for Kubernetes">
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Version</label>
                                                <input type="text" class="form-control" id="chartVersion" value="0.1.0">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>App Version</label>
                                                <input type="text" class="form-control" id="appVersion" value="1.0.0">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Application Settings -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-cog"></i> Application Settings
                                    </div>
                                    <div class="form-group">
                                        <label>Container Image</label>
                                        <input type="text" class="form-control" id="image" value="nginx:1.21">
                                        <small class="help-text">Format: repository:tag</small>
                                    </div>
                                    <div class="form-group">
                                        <label>Image Pull Policy</label>
                                        <select class="form-control" id="imagePullPolicy">
                                            <option value="IfNotPresent">IfNotPresent</option>
                                            <option value="Always">Always</option>
                                            <option value="Never">Never</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Replica Count</label>
                                        <input type="number" class="form-control" id="replicaCount" value="2" min="1">
                                    </div>
                                    <div class="form-group">
                                        <label>Container Port</label>
                                        <input type="number" class="form-control" id="containerPort" value="80" min="1">
                                    </div>
                                </div>

                                <!-- Service Configuration -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-network-wired"></i> Service</div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableService" checked>
                                        <label class="custom-control-label" for="enableService">Enable Service</label>
                                    </div>
                                    <div id="serviceSettings">
                                        <div class="form-group">
                                            <label>Service Type</label>
                                            <select class="form-control" id="serviceType">
                                                <option value="ClusterIP">ClusterIP</option>
                                                <option value="NodePort">NodePort</option>
                                                <option value="LoadBalancer">LoadBalancer</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Service Port</label>
                                            <input type="number" class="form-control" id="servicePort" value="80">
                                        </div>
                                    </div>
                                </div>

                                <!-- Ingress -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-door-open"></i> Ingress</div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableIngress">
                                        <label class="custom-control-label" for="enableIngress">Enable Ingress</label>
                                    </div>
                                    <div id="ingressSettings" style="display:none">
                                        <div class="form-group">
                                            <label>Ingress Class</label>
                                            <input type="text" class="form-control" id="ingressClass" value="nginx">
                                        </div>
                                        <div class="form-group">
                                            <label>Host</label>
                                            <input type="text" class="form-control" id="ingressHost"
                                                value="chart-example.local">
                                        </div>
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="enableTLS">
                                            <label class="custom-control-label" for="enableTLS">Enable TLS</label>
                                        </div>
                                    </div>
                                </div>

                                <!-- Resources -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-microchip"></i> Resources</div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableResources"
                                            checked>
                                        <label class="custom-control-label" for="enableResources">Set Resource
                                            Limits</label>
                                    </div>
                                    <div id="resourceSettings">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <label class="font-weight-bold">Limits</label>
                                                <div class="form-group">
                                                    <label>CPU</label>
                                                    <input type="text" class="form-control" id="limitsCpu" value="500m">
                                                </div>
                                                <div class="form-group">
                                                    <label>Memory</label>
                                                    <input type="text" class="form-control" id="limitsMemory"
                                                        value="512Mi">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="font-weight-bold">Requests</label>
                                                <div class="form-group">
                                                    <label>CPU</label>
                                                    <input type="text" class="form-control" id="requestsCpu"
                                                        value="250m">
                                                </div>
                                                <div class="form-group">
                                                    <label>Memory</label>
                                                    <input type="text" class="form-control" id="requestsMemory"
                                                        value="256Mi">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Environment Variables -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-code"></i> Environment Variables
                                    </div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableEnvVars">
                                        <label class="custom-control-label" for="enableEnvVars">Add Environment
                                            Variables</label>
                                    </div>
                                    <div id="envVarsSettings" style="display:none">
                                        <div class="form-group">
                                            <label>Environment Variables (one per line: KEY=value)</label>
                                            <textarea class="form-control" id="envVars" rows="4"
                                                placeholder="DB_HOST=postgres&#10;DB_PORT=5432&#10;APP_ENV=production"></textarea>
                                            <small class="help-text">Format: KEY=value</small>
                                        </div>
                                    </div>
                                </div>

                                <!-- Volumes & PVCs -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-hdd"></i> Persistent Volumes</div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enablePVC">
                                        <label class="custom-control-label" for="enablePVC">Enable Persistent Volume
                                            Claim</label>
                                    </div>
                                    <div id="pvcSettings" style="display:none">
                                        <div class="form-group">
                                            <label>Storage Class</label>
                                            <input type="text" class="form-control" id="storageClass" value="standard">
                                        </div>
                                        <div class="form-group">
                                            <label>Storage Size</label>
                                            <input type="text" class="form-control" id="storageSize" value="10Gi">
                                        </div>
                                        <div class="form-group">
                                            <label>Mount Path</label>
                                            <input type="text" class="form-control" id="mountPath" value="/data">
                                        </div>
                                        <div class="form-group">
                                            <label>Access Mode</label>
                                            <select class="form-control" id="accessMode">
                                                <option value="ReadWriteOnce">ReadWriteOnce</option>
                                                <option value="ReadOnlyMany">ReadOnlyMany</option>
                                                <option value="ReadWriteMany">ReadWriteMany</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Health Probes -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-heartbeat"></i> Health Probes</div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="customizeProbes"
                                            checked>
                                        <label class="custom-control-label" for="customizeProbes">Customize Health
                                            Probes</label>
                                    </div>
                                    <div id="probesSettings">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <label class="font-weight-bold">Liveness Probe</label>
                                                <div class="form-group">
                                                    <label>Path</label>
                                                    <input type="text" class="form-control" id="livenessPath"
                                                        value="/healthz">
                                                </div>
                                                <div class="form-group">
                                                    <label>Initial Delay (s)</label>
                                                    <input type="number" class="form-control" id="livenessDelay"
                                                        value="30">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="font-weight-bold">Readiness Probe</label>
                                                <div class="form-group">
                                                    <label>Path</label>
                                                    <input type="text" class="form-control" id="readinessPath"
                                                        value="/ready">
                                                </div>
                                                <div class="form-group">
                                                    <label>Initial Delay (s)</label>
                                                    <input type="number" class="form-control" id="readinessDelay"
                                                        value="10">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Init Containers -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-play-circle"></i> Init Containers
                                    </div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableInitContainers">
                                        <label class="custom-control-label" for="enableInitContainers">Add Init
                                            Container</label>
                                    </div>
                                    <div id="initContainerSettings" style="display:none">
                                        <div class="form-group">
                                            <label>Init Container Image</label>
                                            <input type="text" class="form-control" id="initImage" value="busybox:1.28">
                                        </div>
                                        <div class="form-group">
                                            <label>Init Command</label>
                                            <textarea class="form-control" id="initCommand" rows="2"
                                                placeholder="sh -c 'until nslookup myservice; do sleep 2; done'">sh -c 'echo Initializing...'</textarea>
                                            <small class="help-text">Shell command to run before main container
                                                starts</small>
                                        </div>
                                    </div>
                                </div>

                                <!-- Advanced Features -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-sliders-h"></i> Advanced Features
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableHPA">
                                        <label class="custom-control-label" for="enableHPA">Horizontal Pod
                                            Autoscaler<span class="feature-tag">HPA</span></label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enablePDB">
                                        <label class="custom-control-label" for="enablePDB">Pod Disruption Budget<span
                                                class="feature-tag">PDB</span></label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableConfigMap">
                                        <label class="custom-control-label" for="enableConfigMap">ConfigMap</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableSecret">
                                        <label class="custom-control-label" for="enableSecret">Secret</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableServiceAccount">
                                        <label class="custom-control-label" for="enableServiceAccount">Service
                                            Account</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableNetworkPolicy">
                                        <label class="custom-control-label" for="enableNetworkPolicy">Network
                                            Policy</label>
                                    </div>
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" class="custom-control-input" id="enableServiceMonitor">
                                        <label class="custom-control-label" for="enableServiceMonitor">Service
                                            Monitor<span class="feature-tag">Prometheus</span></label>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7">
                    <div class="sticky-preview">
                        <div class="card tool-card">
                            <div
                                class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-dharmachakra mr-2"></i> Generated Helm Chart</span>
                                <div>
                                    <button class="btn btn-sm btn-outline-light mr-2" onclick="downloadChart()"><i
                                            class="fas fa-download"></i> Download</button>
                                    <button class="btn btn-sm btn-outline-light mr-2" onclick="shareUrl()"><i
                                            class="fas fa-share-alt"></i> Share</button>
                                    <button class="btn btn-sm btn-light text-dark" onclick="copyToClipboard()"><i
                                            class="fas fa-copy"></i> Copy</button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <ul class="nav tab-preview" id="chartTabs" role="tablist">
                                    <li class="nav-item">
                                        <a class="nav-link active" data-toggle="tab" href="#tabChart">Chart.yaml</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#tabValues">values.yaml</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#tabDeployment">deployment.yaml</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#tabService">service.yaml</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#tabOthers">More...</a>
                                    </li>
                                </ul>
                                <div class="tab-content">
                                    <div id="tabChart" class="tab-pane fade show active">
                                        <pre id="outputChart" class="code-preview mb-0"></pre>
                                    </div>
                                    <div id="tabValues" class="tab-pane fade">
                                        <pre id="outputValues" class="code-preview mb-0"></pre>
                                    </div>
                                    <div id="tabDeployment" class="tab-pane fade">
                                        <pre id="outputDeployment" class="code-preview mb-0"></pre>
                                    </div>
                                    <div id="tabService" class="tab-pane fade">
                                        <pre id="outputService" class="code-preview mb-0"></pre>
                                    </div>
                                    <div id="tabOthers" class="tab-pane fade">
                                        <pre id="outputOthers" class="code-preview mb-0"></pre>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Share URL Modal -->
        <div class="modal fade" id="shareUrlModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header" style="background:var(--theme-gradient);color:white">
                        <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share Configuration</h5>
                        <button type="button" class="close text-white"
                            data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <div class="input-group mb-3">
                            <input type="text" class="form-control" id="shareUrlText" readonly>
                            <div class="input-group-append">
                                <button class="btn btn-success" id="copyShareUrl"><i class="fas fa-copy"></i>
                                    Copy</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
        <script>
            const presets = {
                'web-app': {
                    chartName: 'web-app',
                    chartDescription: 'A production-ready web application',
                    image: 'nginx:1.21',
                    replicaCount: 3,
                    containerPort: 80,
                    enableService: true,
                    serviceType: 'ClusterIP',
                    enableIngress: true,
                    ingressClass: 'nginx',
                    enableTLS: true,
                    enableResources: true,
                    enableHPA: true,
                    enablePDB: true,
                    enableServiceAccount: true
                },
                'microservice': {
                    chartName: 'microservice-api',
                    chartDescription: 'Microservice API with monitoring',
                    image: 'my-api:latest',
                    replicaCount: 2,
                    containerPort: 8080,
                    enableService: true,
                    serviceType: 'ClusterIP',
                    enableIngress: false,
                    enableResources: true,
                    enableHPA: true,
                    enableConfigMap: true,
                    enableSecret: true,
                    enableServiceAccount: true,
                    enableServiceMonitor: true
                },
                'stateful': {
                    chartName: 'stateful-app',
                    chartDescription: 'Stateful application with persistent storage',
                    image: 'postgres:14',
                    replicaCount: 1,
                    containerPort: 5432,
                    enableService: true,
                    serviceType: 'ClusterIP',
                    enableIngress: false,
                    enableResources: true,
                    enableConfigMap: true,
                    enableSecret: true,
                    enablePDB: true,
                    enableServiceAccount: true
                },
                'batch-job': {
                    chartName: 'batch-job',
                    chartDescription: 'Kubernetes batch job',
                    image: 'my-job:latest',
                    replicaCount: 1,
                    containerPort: 8080,
                    enableService: false,
                    enableIngress: false,
                    enableResources: true,
                    enableConfigMap: true,
                    enableSecret: true,
                    enableServiceAccount: true
                },
                'ingress-controller': {
                    chartName: 'ingress-nginx',
                    chartDescription: 'NGINX Ingress Controller',
                    image: 'k8s.gcr.io/ingress-nginx/controller:v1.0.0',
                    replicaCount: 2,
                    containerPort: 80,
                    enableService: true,
                    serviceType: 'LoadBalancer',
                    enableIngress: false,
                    enableResources: true,
                    enableHPA: true,
                    enablePDB: true,
                    enableServiceAccount: true,
                    enableNetworkPolicy: true
                },
                'monitoring': {
                    chartName: 'monitoring-stack',
                    chartDescription: 'Prometheus monitoring stack',
                    image: 'prom/prometheus:latest',
                    replicaCount: 1,
                    containerPort: 9090,
                    enableService: true,
                    serviceType: 'ClusterIP',
                    enableIngress: true,
                    enableResources: true,
                    enableConfigMap: true,
                    enableServiceAccount: true,
                    enableServiceMonitor: true
                }
            };

            function loadPreset(presetName) {
                const preset = presets[presetName];
                if (!preset) return;

                Object.keys(preset).forEach(key => {
                    const el = document.getElementById(key);
                    if (el) {
                        if (el.type === 'checkbox') {
                            el.checked = preset[key];
                            el.dispatchEvent(new Event('change'));
                        } else {
                            el.value = preset[key];
                        }
                    }
                });

                generateChart();
            }

            function generateChart() {
                generateChartYaml();
                generateValuesYaml();
                generateDeploymentYaml();
                generateServiceYaml();
                generateOthers();
            }

            function generateChartYaml() {
                const name = document.getElementById('chartName').value;
                const description = document.getElementById('chartDescription').value;
                const version = document.getElementById('chartVersion').value;
                const appVersion = document.getElementById('appVersion').value;

                let yaml = `apiVersion: v2
name: ${name}
description: ${description}
type: application
version: ${version}
appVersion: "${appVersion}"
keywords:
  - kubernetes
  - helm
maintainers:
  - name: Your Name
    email: your.email@example.com
`;
                document.getElementById('outputChart').textContent = yaml;
            }

            function generateValuesYaml() {
                const replicaCount = document.getElementById('replicaCount').value;
                const image = document.getElementById('image').value;
                const imagePullPolicy = document.getElementById('imagePullPolicy').value;
                const containerPort = document.getElementById('containerPort').value;
                const serviceType = document.getElementById('serviceType').value;
                const servicePort = document.getElementById('servicePort').value;
                const enableResources = document.getElementById('enableResources').checked;

                let yaml = `replicaCount: ${replicaCount}

image:
  repository: ${image.split(':')[0]}
  pullPolicy: ${imagePullPolicy}
  tag: "${image.split(':')[1] || 'latest'}"

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  create: ${document.getElementById('enableServiceAccount').checked}
  annotations: {}
  name: ""

podAnnotations: {}

podSecurityContext: {}

securityContext: {}

service:
  type: ${serviceType}
  port: ${servicePort}

ingress:
  enabled: ${document.getElementById('enableIngress').checked}
  className: "${document.getElementById('ingressClass').value}"
  annotations: {}
  hosts:
    - host: ${document.getElementById('ingressHost').value}
      paths:
        - path: /
          pathType: Prefix
  tls: ${document.getElementById('enableTLS').checked ? `
  - secretName: chart-example-tls
    hosts:
      - ${document.getElementById('ingressHost').value}` : '[]'}

resources: ${enableResources ? `
  limits:
    cpu: ${document.getElementById('limitsCpu').value}
    memory: ${document.getElementById('limitsMemory').value}
  requests:
    cpu: ${document.getElementById('requestsCpu').value}
    memory: ${document.getElementById('requestsMemory').value}` : '{}'}

autoscaling:
  enabled: ${document.getElementById('enableHPA').checked}
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80

nodeSelector: {}

tolerations: []

affinity: {}
`;

                // Add environment variables
                if (document.getElementById('enableEnvVars').checked) {
                    const envVars = document.getElementById('envVars').value;
                    if (envVars.trim()) {
                        yaml += `\nenvironment:\n`;
                        envVars.split('\n').forEach(line => {
                            const [key, ...valueParts] = line.split('=');
                            if (key && valueParts.length > 0) {
                                yaml += `  ${key.trim()}: "${valueParts.join('=').trim()}"\n`;
                            }
                        });
                    }
                }

                // Add PVC configuration
                if (document.getElementById('enablePVC').checked) {
                    yaml += `\npersistence:\n  enabled: true\n  storageClass: "${document.getElementById('storageClass').value}"\n  accessMode: ${document.getElementById('accessMode').value}\n  size: ${document.getElementById('storageSize').value}\n  mountPath: ${document.getElementById('mountPath').value}\n`;
                } else {
                    yaml += `\npersistence:\n  enabled: false\n`;
                }

                // Add probe configuration
                if (document.getElementById('customizeProbes').checked) {
                    yaml += `\nprobes:\n  liveness:\n    path: ${document.getElementById('livenessPath').value}\n    initialDelaySeconds: ${document.getElementById('livenessDelay').value}\n    periodSeconds: 10\n  readiness:\n    path: ${document.getElementById('readinessPath').value}\n    initialDelaySeconds: ${document.getElementById('readinessDelay').value}\n    periodSeconds: 10\n`;
                }

                // Add init container configuration
                if (document.getElementById('enableInitContainers').checked) {
                    yaml += `\ninitContainers:\n  enabled: true\n  image: ${document.getElementById('initImage').value}\n  command: "${document.getElementById('initCommand').value}"\n`;
                }

                document.getElementById('outputValues').textContent = yaml;
            }

            function generateDeploymentYaml() {
                const name = document.getElementById('chartName').value;
                const containerPort = document.getElementById('containerPort').value;

                let yaml = `apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "${name}.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "${name}.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "${name}.serviceAccountName" . }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      {{- if .Values.initContainers.enabled }}
      initContainers:
        - name: init-{{ .Chart.Name }}
          image: "{{ .Values.initContainers.image }}"
          command: ["sh", "-c", "{{ .Values.initContainers.command }}"]
      {{- end }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.securityContext | nindent 12 }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - name: http
          containerPort: ${containerPort}
          protocol: TCP
        {{- if .Values.environment }}
        env:
        {{- range $key, $value := .Values.environment }}
        - name: {{ $key }}
          value: {{ $value | quote }}
        {{- end }}
        {{- end }}
        livenessProbe:
          httpGet:
            path: {{ .Values.probes.liveness.path | default "/" }}
            port: http
          initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds | default 30 }}
          periodSeconds: {{ .Values.probes.liveness.periodSeconds | default 10 }}
        readinessProbe:
          httpGet:
            path: {{ .Values.probes.readiness.path | default "/" }}
            port: http
          initialDelaySeconds: {{ .Values.probes.readiness.initialDelaySeconds | default 10 }}
          periodSeconds: {{ .Values.probes.readiness.periodSeconds | default 10 }}
        resources:
          {{- toYaml .Values.resources | nindent 12 }}
        {{- if .Values.persistence.enabled }}
        volumeMounts:
          - name: data
            mountPath: {{ .Values.persistence.mountPath }}
        {{- end }}
      {{- if .Values.persistence.enabled }}
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: {{ include "${name}.fullname" . }}
      {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
`;
                document.getElementById('outputDeployment').textContent = yaml;
            }

            function generateServiceYaml() {
                const name = document.getElementById('chartName').value;
                const enableService = document.getElementById('enableService').checked;

                if (!enableService) {
                    document.getElementById('outputService').textContent = '# Service is disabled';
                    return;
                }

                let yaml = `apiVersion: v1
kind: Service
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "${name}.selectorLabels" . | nindent 4 }}
`;
                document.getElementById('outputService').textContent = yaml;
            }

            function generateOthers() {
                let output = '';
                const name = document.getElementById('chartName').value;

                if (document.getElementById('enableIngress').checked) {
                    output += `# ingress.yaml
{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.ingress.className }}
  ingressClassName: {{ .Values.ingress.className }}
  {{- end }}
  {{- if .Values.ingress.tls }}
  tls:
    {{- range .Values.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range .Values.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            pathType: {{ .pathType }}
            backend:
              service:
                name: {{ include "${name}.fullname" $ }}
                port:
                  number: {{ $.Values.service.port }}
          {{- end }}
    {{- end }}
{{- end }}

`;
                }

                if (document.getElementById('enableHPA').checked) {
                    output += `# hpa.yaml
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "${name}.fullname" . }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
{{- end }}

`;
                }

                if (document.getElementById('enablePDB').checked) {
                    output += `# pdb.yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
spec:
  minAvailable: 1
  selector:
    matchLabels:
      {{- include "${name}.selectorLabels" . | nindent 6 }}

`;
                }

                if (document.getElementById('enableServiceAccount').checked) {
                    output += `# serviceaccount.yaml
{{- if .Values.serviceAccount.create -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "${name}.serviceAccountName" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}

`;
                }

                if (document.getElementById('enableConfigMap').checked) {
                    output += `# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
data:
  config.yaml: |
    # Add your configuration here

`;
                }

                if (document.getElementById('enableSecret').checked) {
                    output += `# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
type: Opaque
data:
  # Add your secrets here (base64 encoded)

`;
                }

                if (document.getElementById('enableNetworkPolicy').checked) {
                    output += `# networkpolicy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
spec:
  podSelector:
    matchLabels:
      {{- include "${name}.selectorLabels" . | nindent 6 }}
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector: {}
  egress:
    - to:
        - podSelector: {}

`;
                }

                // Add PVC template
                if (document.getElementById('enablePVC').checked) {
                    output += `# pvc.yaml
{{- if .Values.persistence.enabled }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
spec:
  accessModes:
    - {{ .Values.persistence.accessMode }}
  {{- if .Values.persistence.storageClass }}
  storageClassName: {{ .Values.persistence.storageClass }}
  {{- end }}
  resources:
    requests:
      storage: {{ .Values.persistence.size }}
{{- end }}

`;
                }

                // Add NOTES.txt with comprehensive installation instructions
                const notesContent = `1. Get the application URL by running these commands:
{{- if .Values.ingress.enabled }}
{{- range $host := .Values.ingress.hosts }}
  {{- range .paths }}
  http{{ if $.Values.ingress.tls }}s{{ end }}://{{ $host.host }}{{ .path }}
  {{- end }}
{{- end }}
{{- else if contains "NodePort" .Values.service.type }}
  export NODE_PORT=$(kubectl get --namespace {{ .Release.Namespace }} -o jsonpath="{.spec.ports[0].nodePort}" services {{ include "${name}.fullname" . }})
  export NODE_IP=$(kubectl get nodes --namespace {{ .Release.Namespace }} -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
{{- else if contains "LoadBalancer" .Values.service.type }}
     NOTE: It may take a few minutes for the LoadBalancer IP to be available.
           You can watch the status of by running 'kubectl get --namespace {{ .Release.Namespace }} svc -w {{ include "${name}.fullname" . }}'
  export SERVICE_IP=$(kubectl get svc --namespace {{ .Release.Namespace }} {{ include "${name}.fullname" . }} --template "{{"{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"}}")
  echo http://$SERVICE_IP:{{ .Values.service.port }}
{{- else if contains "ClusterIP" .Values.service.type }}
  export POD_NAME=$(kubectl get pods --namespace {{ .Release.Namespace }} -l "app.kubernetes.io/name={{ include "${name}.name" . }},app.kubernetes.io/instance={{ .Release.Name }}" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace {{ .Release.Namespace }} $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace {{ .Release.Namespace }} port-forward $POD_NAME 8080:$CONTAINER_PORT
{{- end }}

2. To check the status of the pods:
  kubectl get pods --namespace {{ .Release.Namespace }} -l "app.kubernetes.io/instance={{ .Release.Name }}"

{{- if .Values.persistence.enabled }}
3. Persistent Volume:
  kubectl get pvc --namespace {{ .Release.Namespace }} {{ include "${name}.fullname" . }}
{{- end }}`;

                output += `# NOTES.txt\n${notesContent}\n\n`;

                // Add .helmignore
                output += `# .helmignore
# Patterns to ignore when building packages.
# This is a .gitignore-style file.
#
# Common paths:
.DS_Store
.git/
.gitignore
.vscode/
#
# Build artifacts:
*.tgz
*.zip
*.tar.gz
#
# Other:
.terraform/

`;

                if (document.getElementById('enableServiceMonitor').checked) {
                    output += `# servicemonitor.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ include "${name}.fullname" . }}
  labels:
    {{- include "${name}.labels" . | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "${name}.selectorLabels" . | nindent 6 }}
  endpoints:
    - port: http
      interval: 30s
`;
                }

                output += `
# _helpers.tpl
{{/*
Expand the name of the chart.
*/}}
{{- define "${name}.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "${name}.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "${name}.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "${name}.labels" -}}
helm.sh/chart: {{ include "${name}.chart" . }}
{{ include "${name}.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "${name}.selectorLabels" -}}
app.kubernetes.io/name: {{ include "${name}.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "${name}.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "${name}.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
`;

                document.getElementById('outputOthers').textContent = output || '# No additional resources selected';
            }

            // Event listeners
            document.getElementById('enableService').addEventListener('change', function () {
                document.getElementById('serviceSettings').style.display = this.checked ? 'block' : 'none';
                generateChart();
            });

            document.getElementById('enableIngress').addEventListener('change', function () {
                document.getElementById('ingressSettings').style.display = this.checked ? 'block' : 'none';
                generateChart();
            });

            document.getElementById('enableResources').addEventListener('change', function () {
                document.getElementById('resourceSettings').style.display = this.checked ? 'block' : 'none';
                generateChart();
            });

            document.getElementById('enableEnvVars').addEventListener('change', function () {
                document.getElementById('envVarsSettings').style.display = this.checked ? 'block' : 'none';
                generateChart();
            });

            document.getElementById('enablePVC').addEventListener('change', function () {
                document.getElementById('pvcSettings').style.display = this.checked ? 'block' : 'none';
                generateChart();
            });

            document.getElementById('customizeProbes').addEventListener('change', function () {
                document.getElementById('probesSettings').style.display = this.checked ? 'block' : 'none';
                generateChart();
            });

            document.getElementById('enableInitContainers').addEventListener('change', function () {
                document.getElementById('initContainerSettings').style.display = this.checked ? 'block' : 'none';
                generateChart();
            });

            document.querySelectorAll('input, select').forEach(el => {
                el.addEventListener('input', generateChart);
                el.addEventListener('change', generateChart);
            });

            function copyToClipboard() {
                const activeTab = document.querySelector('.tab-preview .nav-link.active').getAttribute('href');
                const content = document.querySelector(activeTab + ' pre').textContent;
                navigator.clipboard.writeText(content).then(() => {
                    const btn = event.target.closest('button');
                    const orig = btn.innerHTML;
                    btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                    setTimeout(() => btn.innerHTML = orig, 2000);
                });
            }

            function downloadChart() {
                const zip = new JSZip();
                const chartName = document.getElementById('chartName').value;
                const chartFolder = zip.folder(chartName);
                const templatesFolder = chartFolder.folder('templates');

                chartFolder.file('Chart.yaml', document.getElementById('outputChart').textContent);
                chartFolder.file('values.yaml', document.getElementById('outputValues').textContent);
                templatesFolder.file('deployment.yaml', document.getElementById('outputDeployment').textContent);

                if (document.getElementById('enableService').checked) {
                    templatesFolder.file('service.yaml', document.getElementById('outputService').textContent);
                }

                const others = document.getElementById('outputOthers').textContent;
                const otherFiles = others.split('\n# ').filter(f => f.trim());

                otherFiles.forEach(file => {
                    const lines = file.split('\n');
                    const filename = lines[0].trim();
                    if (filename && filename !== 'No additional resources selected') {
                        const content = lines.slice(1).join('\n');
                        if (filename === '_helpers.tpl') {
                            templatesFolder.file(filename, content);
                        } else if (filename === 'NOTES.txt') {
                            templatesFolder.file(filename, content);
                        } else if (filename === '.helmignore') {
                            chartFolder.file(filename, content);
                        } else if (filename.endsWith('.yaml')) {
                            templatesFolder.file(filename, content);
                        }
                    }
                });

                zip.generateAsync({ type: 'blob' }).then(function (content) {
                    saveAs(content, chartName + '-helm-chart.zip');
                });
            }

            function shareUrl() {
                const formData = {
                    chartName: document.getElementById('chartName').value,
                    chartDescription: document.getElementById('chartDescription').value,
                    chartVersion: document.getElementById('chartVersion').value,
                    appVersion: document.getElementById('appVersion').value,
                    image: document.getElementById('image').value,
                    imagePullPolicy: document.getElementById('imagePullPolicy').value,
                    replicaCount: document.getElementById('replicaCount').value,
                    containerPort: document.getElementById('containerPort').value,
                    enableService: document.getElementById('enableService').checked,
                    serviceType: document.getElementById('serviceType').value,
                    servicePort: document.getElementById('servicePort').value,
                    enableIngress: document.getElementById('enableIngress').checked,
                    ingressClass: document.getElementById('ingressClass').value,
                    ingressHost: document.getElementById('ingressHost').value,
                    enableTLS: document.getElementById('enableTLS').checked,
                    enableResources: document.getElementById('enableResources').checked,
                    limitsCpu: document.getElementById('limitsCpu').value,
                    limitsMemory: document.getElementById('limitsMemory').value,
                    requestsCpu: document.getElementById('requestsCpu').value,
                    requestsMemory: document.getElementById('requestsMemory').value,
                    enableHPA: document.getElementById('enableHPA').checked,
                    enablePDB: document.getElementById('enablePDB').checked,
                    enableConfigMap: document.getElementById('enableConfigMap').checked,
                    enableSecret: document.getElementById('enableSecret').checked,
                    enableServiceAccount: document.getElementById('enableServiceAccount').checked,
                    enableNetworkPolicy: document.getElementById('enableNetworkPolicy').checked,
                    enableServiceMonitor: document.getElementById('enableServiceMonitor').checked
                };

                const jsonData = JSON.stringify(formData);
                const base64Encoded = btoa(unescape(encodeURIComponent(jsonData)));
                const shareUrl = window.location.origin + window.location.pathname + '?data=' + encodeURIComponent(base64Encoded);
                document.getElementById('shareUrlText').value = shareUrl;
                $('#shareUrlModal').modal('show');
            }

            function loadFromUrl() {
                const urlParams = new URLSearchParams(window.location.search);
                const dataParam = urlParams.get('data');
                if (dataParam) {
                    try {
                        const jsonData = decodeURIComponent(escape(atob(decodeURIComponent(dataParam))));
                        const formData = JSON.parse(jsonData);
                        Object.keys(formData).forEach(key => {
                            const el = document.getElementById(key);
                            if (el) {
                                if (el.type === 'checkbox') {
                                    el.checked = formData[key];
                                    el.dispatchEvent(new Event('change'));
                                } else {
                                    el.value = formData[key];
                                }
                            }
                        });
                        generateChart();
                    } catch (e) {
                        console.error('Error loading:', e);
                        generateChart();
                    }
                } else {
                    generateChart();
                }
            }

            document.getElementById('copyShareUrl').addEventListener('click', function () {
                navigator.clipboard.writeText(document.getElementById('shareUrlText').value).then(() => {
                    this.innerHTML = '<i class="fas fa-check"></i> Copied!';
                    setTimeout(() => this.innerHTML = '<i class="fas fa-copy"></i> Copy', 2000);
                });
            });

            loadFromUrl();
        </script>

        <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="footer_adsense.jsp" %>
            <%@ include file="thanks.jsp" %>
                <hr>
                <%@ include file="addcomments.jsp" %>
                    </div>
                    <%@ include file="body-close.jsp" %>

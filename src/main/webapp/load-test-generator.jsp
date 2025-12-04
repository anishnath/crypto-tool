<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <title>Load Testing Script Generator – k6, Locust, JMeter, Gatling – Free | 8gwifi.org</title>
    <meta name="description"
        content="Generate load testing scripts for k6, Locust, JMeter, Gatling, Artillery, and Vegeta with visual scenarios and thresholds. Free, no signup.">
    <link rel="canonical" href="https://8gwifi.org/load-test-generator.jsp" />
    <meta property="og:type" content="website" />
    <meta property="og:title" content="Load Testing Script Generator – k6, Locust, JMeter, Gatling" />
    <meta property="og:description" content="Create load testing scripts with scenarios, thresholds and reports. Free, no signup." />
    <meta property="og:url" content="https://8gwifi.org/load-test-generator.jsp" />
    <meta property="og:site_name" content="8gwifi.org" />
    <meta property="og:image" content="https://8gwifi.org/images/site/logo.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Load Testing Script Generator – k6, Locust, JMeter, Gatling" />
    <meta name="twitter:description" content="Create load testing scripts with scenarios, thresholds and reports. Free, no signup." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/logo.png" />
    <meta name="keywords"
        content="k6 script generator, locust load test, jmeter script, gatling simulation, artillery load testing, vegeta attack, performance testing, stress testing, load testing tool">
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Load Testing Script Generator",
      "description": "Generate K6, Locust, JMeter, Gatling, Artillery, and Vegeta load testing scripts with visual scenario builder.",
      "url": "https://8gwifi.org/load-test-generator.jsp",
      "applicationCategory": "DeveloperApplication",
      "operatingSystem": "Any",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      },
      "datePublished": "2025-01-31",
      "dateModified": "2025-12-01",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Visual Scenario Builder",
        "Multi-framework Support (K6, Locust, JMeter, Gatling, Artillery, Vegeta)",
        "Performance Threshold Configuration",
        "One-click Script Generation"
      ]
    }
    </script>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {"@type": "Question","name": "When should I use VUs vs RPS (k6)?","acceptedAnswer": {"@type": "Answer","text": "Use VUs to model concurrent users; use RPS for throughput targets. Combine with thresholds for SLOs."}},
        {"@type": "Question","name": "How do I model multi-step user flows?","acceptedAnswer": {"@type": "Answer","text": "Group steps into scenarios with think time between actions; use tags to correlate metrics and results."}},
        {"@type": "Question","name": "How do I run tests in CI/CD?","acceptedAnswer": {"@type": "Answer","text": "Export scripts and run via CLI in GitHub Actions/GitLab CI; fail builds using thresholds on latency or error rate."}}
      ]
    }
    </script>
        <style>
            :root {
                --theme-primary: #0f1689;
                --theme-secondary: #326ce5;
                --theme-k6: #7d64ff;
                --theme-locust: #3c9;
                --theme-jmeter: #d22128;
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

            .framework-tabs {
                border-bottom: 2px solid #dee2e6
            }

            .framework-tabs .nav-link {
                border: none;
                color: #6c757d;
                font-weight: 500;
                padding: 0.75rem 1.5rem;
                cursor: pointer;
                transition: all 0.3s ease
            }

            .framework-tabs .nav-link:hover {
                color: var(--theme-secondary);
                background-color: rgba(50, 108, 229, 0.1)
            }

            .framework-tabs .nav-link.active {
                color: white;
                background: var(--theme-k6);
                border-radius: 8px 8px 0 0
            }

            .framework-tabs .nav-link.active[data-framework="k6"] {
                background: var(--theme-k6)
            }

            .framework-tabs .nav-link.active[data-framework="locust"] {
                background: var(--theme-locust)
            }

            .framework-tabs .nav-link.active[data-framework="jmeter"] {
                background: var(--theme-jmeter)
            }

            .help-text {
                font-size: 0.8rem;
                color: #6c757d;
                margin-top: 0.25rem
            }

            .step-item {
                background: white;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                padding: 1rem;
                margin-bottom: 0.75rem;
                cursor: move;
                transition: all 0.2s ease
            }

            .step-item:hover {
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border-color: var(--theme-primary)
            }

            .step-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 0.5rem
            }

            .step-badge {
                background: var(--theme-primary);
                color: white;
                padding: 0.25rem 0.6rem;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 600
            }

            .step-actions {
                display: flex;
                gap: 0.5rem
            }

            .step-actions button {
                padding: 0.25rem 0.5rem;
                font-size: 0.8rem
            }

            .add-step-btn {
                width: 100%;
                padding: 0.75rem;
                border: 2px dashed #dee2e6;
                background: transparent;
                color: var(--theme-primary);
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease
            }

            .add-step-btn:hover {
                border-color: var(--theme-primary);
                background: var(--theme-light);
                transform: translateY(-2px)
            }
</style>
</head>
<%@ include file="body-script.jsp" %>
    <%@ include file="devops-tools-navbar.jsp" %>

        <div class="container-fluid px-lg-5 mt-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 mb-0">Load Testing Script Generator</h1>
                    <p class="text-muted mb-0">Generate scripts for K6, Locust, and JMeter</p>
                </div>
                <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
            </div>

            <!-- Framework Selection -->
            <div class="card tool-card mb-4">
                <div class="card-body">
                    <h6 class="mb-3"><i class="fas fa-cog"></i> Select Framework</h6>
                    <ul class="nav framework-tabs" id="frameworkTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" data-framework="k6" data-toggle="tab" href="#k6Tab">
                                <i class="fab fa-js-square"></i> K6 (JavaScript)
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-framework="locust" data-toggle="tab" href="#locustTab">
                                <i class="fab fa-python"></i> Locust (Python)
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-framework="jmeter" data-toggle="tab" href="#jmeterTab">
                                <i class="fas fa-file-code"></i> JMeter (XML)
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-framework="gatling" data-toggle="tab" href="#gatlingTab">
                                <i class="fas fa-code"></i> Gatling (Scala)
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-framework="artillery" data-toggle="tab" href="#artilleryTab">
                                <i class="fab fa-node-js"></i> Artillery (YAML)
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-framework="vegeta" data-toggle="tab" href="#vegetaTab">
                                <i class="fas fa-carrot"></i> Vegeta (Go)
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Preset Templates -->
            <div class="card tool-card mb-4">
                <div class="card-body">
                    <h6 class="mb-3"><i class="fas fa-magic"></i> Quick Start Templates</h6>
                    <div class="d-flex flex-wrap">
                        <button class="btn btn-outline-primary preset-btn" onclick="loadPreset('api-test')">
                            <i class="fas fa-plug"></i> Simple API Test
                        </button>
                        <button class="btn btn-outline-info preset-btn" onclick="loadPreset('stress-test')">
                            <i class="fas fa-tachometer-alt"></i> Stress Test
                        </button>
                        <button class="btn btn-outline-success preset-btn" onclick="loadPreset('multi-step')">
                            <i class="fas fa-list-ol"></i> Multi-Step Flow
                        </button>
                        <button class="btn btn-outline-warning preset-btn" onclick="loadPreset('spike-test')">
                            <i class="fas fa-chart-line"></i> Spike Test
                        </button>
                        <button class="btn btn-outline-danger preset-btn" onclick="loadPreset('endurance')">
                            <i class="fas fa-clock"></i> Endurance Test
                        </button>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-5">
                    <div class="card tool-card mb-4">
                        <div class="card-header card-header-custom"><i class="fas fa-sliders-h mr-2"></i> Test
                            Configuration</div>
                        <div class="card-body" style="max-height: 800px; overflow-y: auto;">
                            <form id="testForm">
                                <!-- Basic Configuration -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-info-circle"></i> Basic Settings
                                    </div>
                                    <div class="form-group">
                                        <label>Test Name</label>
                                        <input type="text" class="form-control" id="testName" value="api-load-test">
                                        <small class="help-text">Descriptive name for your load test</small>
                                    </div>
                                    <div class="form-group">
                                        <label>Base URL</label>
                                        <input type="text" class="form-control" id="baseUrl"
                                            value="https://api.example.com">
                                        <small class="help-text">Target server URL</small>
                                    </div>
                                </div>

                                <!-- Authentication -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-lock"></i> Authentication</div>
                                    <div class="form-group">
                                        <label>Auth Type</label>
                                        <select class="form-control" id="authType" onchange="toggleAuthFields()">
                                            <option value="none">None</option>
                                            <option value="basic">Basic Auth</option>
                                            <option value="bearer">Bearer Token</option>
                                            <option value="apikey">API Key</option>
                                        </select>
                                    </div>
                                    <div id="authFields" style="display: none;">
                                        <div id="basicAuthFields" style="display: none;">
                                            <div class="form-group">
                                                <label>Username</label>
                                                <input type="text" class="form-control" id="authUsername">
                                            </div>
                                            <div class="form-group">
                                                <label>Password</label>
                                                <input type="password" class="form-control" id="authPassword">
                                            </div>
                                        </div>
                                        <div id="bearerAuthFields" style="display: none;">
                                            <div class="form-group">
                                                <label>Token</label>
                                                <input type="text" class="form-control" id="authToken"
                                                    placeholder="eyJhbGciOi...">
                                            </div>
                                        </div>
                                        <div id="apiKeyFields" style="display: none;">
                                            <div class="form-group">
                                                <label>Key Name</label>
                                                <input type="text" class="form-control" id="authKeyName"
                                                    placeholder="X-API-Key">
                                            </div>
                                            <div class="form-group">
                                                <label>Key Value</label>
                                                <input type="text" class="form-control" id="authKeyValue">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Load Configuration -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-users"></i> Load Pattern</div>
                                    <div class="form-group">
                                        <label>Virtual Users (VUs)</label>
                                        <input type="number" class="form-control" id="virtualUsers" value="10" min="1">
                                    </div>
                                    <div class="form-group">
                                        <label>Duration</label>
                                        <div class="row">
                                            <div class="col-8">
                                                <input type="number" class="form-control" id="duration" value="30"
                                                    min="1">
                                            </div>
                                            <div class="col-4">
                                                <select class="form-control" id="durationUnit">
                                                    <option value="s">seconds</option>
                                                    <option value="m">minutes</option>
                                                    <option value="h">hours</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Load Pattern</label>
                                        <select class="form-control" id="loadPattern">
                                            <option value="constant">Constant Load</option>
                                            <option value="ramp">Ramp Up/Down</option>
                                            <option value="spike">Spike Test</option>
                                            <option value="stress">Stress Test</option>
                                        </select>
                                    </div>
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" class="custom-control-input" id="distributedMode"
                                            onchange="generateAllScripts()">
                                        <label class="custom-control-label" for="distributedMode">Distributed Mode
                                            (Cluster)</label>
                                    </div>
                                </div>

                                <!-- Performance Thresholds -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-tachometer-alt"></i> Performance
                                        Thresholds</div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableThresholds"
                                            checked>
                                        <label class="custom-control-label" for="enableThresholds">Enable Performance
                                            Thresholds</label>
                                    </div>
                                    <div id="thresholdsSettings">
                                        <div class="form-group">
                                            <label>Max Response Time (ms)</label>
                                            <input type="number" class="form-control" id="maxResponseTime" value="500">
                                        </div>
                                        <div class="form-group">
                                            <label>Max Error Rate (%)</label>
                                            <input type="number" class="form-control" id="maxErrorRate" value="1"
                                                step="0.1">
                                        </div>
                                        <div class="form-group">
                                            <label>P95 Response Time (ms)</label>
                                            <input type="number" class="form-control" id="p95ResponseTime" value="1000">
                                        </div>
                                    </div>
                                </div>

                                <!-- Scenario Steps -->
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-list-ol"></i> Test Scenario</div>
                                    <div id="scenarioSteps">
                                        <!-- Steps will be dynamically added here -->
                                    </div>
                                    <div class="dropdown">
                                        <button class="add-step-btn dropdown-toggle" type="button"
                                            data-toggle="dropdown">
                                            <i class="fas fa-plus-circle"></i> Add Step
                                        </button>
                                        <div class="dropdown-menu">
                                            <a class="dropdown-item" href="#" onclick="addStep('http'); return false;">
                                                <i class="fas fa-globe"></i> HTTP Request
                                            </a>
                                            <a class="dropdown-item" href="#"
                                                onclick="addStep('think-time'); return false;">
                                                <i class="fas fa-clock"></i> Think Time / Wait
                                            </a>
                                            <a class="dropdown-item" href="#" onclick="addStep('check'); return false;">
                                                <i class="fas fa-check-circle"></i> Assertion / Check
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7">
                    <div class="sticky-preview">
                        <div class="card tool-card mb-3">
                            <div
                                class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-code mr-2"></i> Generated Script</span>
                                <div>
                                    <button class="btn btn-sm btn-outline-light mr-2" onclick="downloadScript()"><i
                                            class="fas fa-download"></i> Download</button>
                                    <button class="btn btn-sm btn-light text-dark" onclick="copyScript()"><i
                                            class="fas fa-copy"></i> Copy</button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <div class="tab-content">
                                    <div id="k6Tab" class="tab-pane fade show active">
                                        <pre id="k6Output" class="code-preview mb-0"></pre>
                                    </div>
                                    <div id="locustTab" class="tab-pane fade">
                                        <pre id="locustOutput" class="code-preview mb-0"></pre>
                                    </div>
                                    <div id="jmeterTab" class="tab-pane fade">
                                        <pre id="jmeterOutput" class="code-preview mb-0"></pre>
                                    </div>
                                    <div id="gatlingTab" class="tab-pane fade">
                                        <pre id="gatlingOutput" class="code-preview mb-0"></pre>
                                    </div>
                                    <div id="artilleryTab" class="tab-pane fade">
                                        <pre id="artilleryOutput" class="code-preview mb-0"></pre>
                                    </div>
                                    <div id="vegetaTab" class="tab-pane fade">
                                        <pre id="vegetaOutput" class="code-preview mb-0"></pre>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- How to Run Section -->
                        <div class="card tool-card bg-light">
                            <div class="card-body">
                                <h6 class="card-title"><i class="fas fa-terminal"></i> How to Run</h6>
                                <div id="runInstructions">
                                    <!-- Dynamic content based on selected tab -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row mt-4">
                <div class="col-12">
                    <div class="card tool-card">
                        <div class="card-body">
                            <h5 class="card-title mb-4"><i class="fas fa-book-reader"></i> Understanding Your Load
                                Testing Tools</h5>

                            <div class="row">
                                <div class="col-md-4 mb-4">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="mr-3"
                                            style="width: 50px; height: 50px; background: #7d64ff; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 24px;">
                                            k6</div>
                                        <h5 class="mb-0">K6</h5>
                                    </div>
                                    <p class="text-muted small">
                                        <strong>Best for:</strong> Developers, CI/CD pipelines, and high-performance
                                        testing.
                                    </p>
                                    <p class="small">
                                        K6 is a modern load testing tool built in Go and scripted in
                                        <strong>JavaScript</strong>. It's designed to be developer-friendly and
                                        integrates seamlessly into automation workflows.
                                    </p>
                                    <ul class="small text-muted pl-3">
                                        <li>Uses virtual users (VUs) to simulate load.</li>
                                        <li>Excellent performance (can run thousands of VUs on a single machine).</li>
                                        <li><strong>What to look for:</strong> Check the <code>options</code> object for
                                            load configuration and <code>thresholds</code> for pass/fail criteria.</li>
                                    </ul>
                                </div>

                                <div class="col-md-4 mb-4">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="mr-3"
                                            style="width: 50px; height: 50px; background: #3c9; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">
                                            <i class="fas fa-bug"></i>
                                        </div>
                                        <h5 class="mb-0">Locust</h5>
                                    </div>
                                    <p class="text-muted small">
                                        <strong>Best for:</strong> Complex user flows, distributed testing, and Python
                                        lovers.
                                    </p>
                                    <p class="small">
                                        Locust is an easy-to-use, distributed user load testing tool. It uses
                                        <strong>Python</strong> code to define user behavior, making it very flexible
                                        for complex scenarios.
                                    </p>
                                    <ul class="small text-muted pl-3">
                                        <li>Event-based (gevent), allowing thousands of concurrent users.</li>
                                        <li>Web-based UI for real-time monitoring.</li>
                                        <li><strong>What to look for:</strong> The <code>HttpUser</code> class defines
                                            the user, and <code>@task</code> decorators define the actions they perform.
                                        </li>
                                    </ul>
                                </div>

                                <div class="col-md-4 mb-4">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="mr-3"
                                            style="width: 50px; height: 50px; background: #d22128; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">
                                            <i class="fas fa-feather-alt"></i>
                                        </div>
                                        <h5 class="mb-0">Apache JMeter</h5>
                                    </div>
                                    <p class="text-muted small">
                                        <strong>Best for:</strong> Enterprise protocol support, non-programmers, and
                                        legacy systems.
                                    </p>
                                    <p class="small">
                                        JMeter is the industry standard for performance testing. It's a pure
                                        <strong>Java</strong> application with a GUI, though this tool generates the
                                        <strong>XML (.jmx)</strong> test plan for you.
                                    </p>
                                    <ul class="small text-muted pl-3">
                                        <li>Supports a vast array of protocols (HTTP, JDBC, JMS, FTP, etc.).</li>
                                        <li>Extensive ecosystem of plugins.</li>
                                        <li><strong>What to look for:</strong> The <code>ThreadGroup</code> controls the
                                            load, and <code>HTTPSamplerProxy</code> defines the requests.</li>
                                    </ul>
                                </div>

                                <div class="col-md-4 mb-4">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="mr-3"
                                            style="width: 50px; height: 50px; background: #FF9E2A; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">
                                            <i class="fas fa-code"></i>
                                        </div>
                                        <h5 class="mb-0">Gatling</h5>
                                    </div>
                                    <p class="text-muted small">
                                        <strong>Best for:</strong> High-performance testing, detailed reporting, and
                                        Scala/Java environments.
                                    </p>
                                    <p class="small">
                                        Gatling is a powerful load testing tool that uses <strong>Scala</strong>, Akka,
                                        and Netty. It's known for its high performance and HTML reports.
                                    </p>
                                </div>

                                <div class="col-md-4 mb-4">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="mr-3"
                                            style="width: 50px; height: 50px; background: #222; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #339933; font-size: 24px;">
                                            <i class="fab fa-node-js"></i>
                                        </div>
                                        <h5 class="mb-0">Artillery</h5>
                                    </div>
                                    <p class="text-muted small">
                                        <strong>Best for:</strong> Serverless load testing, Node.js developers, and
                                        cloud-native apps.
                                    </p>
                                    <p class="small">
                                        Artillery is a modern, powerful load testing toolkit. It's written in
                                        <strong>Node.js</strong> and uses YAML/JSON for configuration, making it great
                                        for CI/CD.
                                    </p>
                                </div>

                                <div class="col-md-4 mb-4">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="mr-3"
                                            style="width: 50px; height: 50px; background: #00ADD8; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">
                                            <i class="fas fa-carrot"></i>
                                        </div>
                                        <h5 class="mb-0">Vegeta</h5>
                                    </div>
                                    <p class="text-muted small">
                                        <strong>Best for:</strong> Constant request rate attacks, simple HTTP
                                        benchmarking.
                                    </p>
                                    <p class="small">
                                        Vegeta is a versatile HTTP load testing tool built in <strong>Go</strong>. It
                                        focuses on drilling HTTP services with a constant request rate.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            let steps = [];
            let stepCounter = 0;

            // Initialize with one default HTTP request
            document.addEventListener('DOMContentLoaded', function () {
                addStep('http');
                generateAllScripts();
                updateRunInstructions();

                // Event listeners for form changes
                document.querySelectorAll('#testForm input, #testForm select').forEach(el => {
                    el.addEventListener('input', generateAllScripts);
                    el.addEventListener('change', generateAllScripts);
                });

                // Event listener for tab changes
                $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                    updateRunInstructions();
                });
            });

            function addStep(type) {
                const stepId = ++stepCounter;
                const step = { id: stepId, type: type };

                if (type === 'http') {
                    step.method = 'GET';
                    step.path = '/api/users';
                    step.headers = '';
                    step.body = '';
                } else if (type === 'think-time') {
                    step.duration = 1;
                } else if (type === 'check') {
                    step.condition = 'status == 200';
                }

                steps.push(step);
                renderSteps();
                generateAllScripts();
            }

            function removeStep(stepId) {
                steps = steps.filter(s => s.id !== stepId);
                renderSteps();
                generateAllScripts();
            }

            function renderSteps() {
                const container = document.getElementById('scenarioSteps');
                container.innerHTML = '';

                steps.forEach((step, index) => {
                    const stepEl = document.createElement('div');
                    stepEl.className = 'step-item';
                    stepEl.innerHTML = `
                        <div class="step-header">
                            <div>
                                <span class="step-badge">${index + 1}</span>
                                <strong>${getStepTypeName(step.type)}</strong>
                            </div>
                            <div class="step-actions">
                                <button class="btn btn-sm btn-danger" onclick="removeStep(${step.id})">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                        ${renderStepContent(step)}
                    `;
                    container.appendChild(stepEl);
                });
            }

            function getStepTypeName(type) {
                const names = {
                    'http': 'HTTP Request',
                    'think-time': 'Think Time',
                    'check': 'Assertion/Check'
                };
                return names[type] || type;
            }

            function renderStepContent(step) {
                if (step.type === 'http') {
                    return `
                        <div class="form-group mt-2">
                            <label class="small">Method & Path</label>
                            <div class="row">
                                <div class="col-4">
                                    <select class="form-control form-control-sm" onchange="updateStep(${step.id}, 'method', this.value)">
                                        <option ${step.method === 'GET' ? 'selected' : ''}>GET</option>
                                        <option ${step.method === 'POST' ? 'selected' : ''}>POST</option>
                                        <option ${step.method === 'PUT' ? 'selected' : ''}>PUT</option>
                                        <option ${step.method === 'DELETE' ? 'selected' : ''}>DELETE</option>
                                    </select>
                                </div>
                                <div class="col-8">
                                    <input type="text" class="form-control form-control-sm" value="${step.path}" 
                                           onchange="updateStep(${step.id}, 'path', this.value)">
                                </div>
                            </div>
                        </div>
                    `;
                } else if (step.type === 'think-time') {
                    return `
                        <div class="form-group mt-2">
                            <label class="small">Duration (seconds)</label>
                            <input type="number" class="form-control form-control-sm" value="${step.duration}" 
                                   onchange="updateStep(${step.id}, 'duration', this.value)" min="0" step="0.1">
                        </div>
                    `;
                } else if (step.type === 'check') {
                    return `
                        <div class="form-group mt-2">
                            <label class="small">Condition</label>
                            <input type="text" class="form-control form-control-sm" value="${step.condition}" 
                                   onchange="updateStep(${step.id}, 'condition', this.value)">
                        </div>
                    `;
                }
                return '';
            }

            function updateStep(stepId, field, value) {
                const step = steps.find(s => s.id === stepId);
                if (step) {
                    step[field] = value;
                    generateAllScripts();
                }
            }

            function generateAllScripts() {
                generateK6Script();
                generateLocustScript();
                generateJMeterScript();
                generateGatlingScript();
                generateArtilleryScript();
                generateVegetaScript();
            }

            function generateK6Script() {
                const testName = document.getElementById('testName').value;
                const baseUrl = document.getElementById('baseUrl').value;
                const vus = document.getElementById('virtualUsers').value;
                const duration = document.getElementById('duration').value;
                const unit = document.getElementById('durationUnit').value;
                const enableThresholds = document.getElementById('enableThresholds').checked;
                const maxResponseTime = document.getElementById('maxResponseTime').value;
                const p95 = document.getElementById('p95ResponseTime').value;
                const loadPattern = document.getElementById('loadPattern').value;

                // Auth
                const authType = document.getElementById('authType').value;
                let authHeaders = '';
                if (authType === 'basic') {
                    // K6 handles basic auth in options or headers, but headers is easier for per-request
                    // Actually K6 has a nice way: http.get(url, { headers: { 'Authorization': 'Basic ' + encoding.b64encode(user + ':' + pass) } })
                    // But simpler to just assume user knows or use a helper. 
                    // Let's use a simple header injection for now.
                    const user = document.getElementById('authUsername').value;
                    const pass = document.getElementById('authPassword').value;
                    // Note: K6 requires encoding module for b64encode, or we can just say 'Basic <base64>'
                    // For simplicity in this generator, we'll add a comment or use a placeholder function
                    authHeaders = `, { headers: { 'Authorization': 'Basic ' + encoding.b64encode('${user}:${pass}') } }`;
                } else if (authType === 'bearer') {
                    const token = document.getElementById('authToken').value;
                    authHeaders = `, { headers: { 'Authorization': 'Bearer ${token}' } }`;
                } else if (authType === 'apikey') {
                    const key = document.getElementById('authKeyName').value;
                    const val = document.getElementById('authKeyValue').value;
                    authHeaders = `, { headers: { '${key}': '${val}' } }`;
                }

                let script = `import http from 'k6/http';
import { check, sleep } from 'k6';
import encoding from 'k6/encoding';

export const options = {
  vus: ${vus},
  duration: '${duration}${unit}',`;

                if (document.getElementById('distributedMode').checked) {
                    script = `/* 
 * DISTRIBUTED MODE ENABLED
 * To run this in distributed mode with K6:
 * k6 run --execution-segment "0:1/4" script.js  # Instance 1
 * k6 run --execution-segment "1/4:2/4" script.js # Instance 2
 * ...
 */
` + script;
                }

                if (loadPattern === 'ramp') {
                    // Calculate stages based on duration
                    // Simple ramp: 1/3 ramp up, 1/3 stay, 1/3 ramp down
                    // We need to parse duration and unit to split it, but for simplicity let's just use fixed stages relative to total
                    // Actually K6 stages override duration.
                    script = script.replace(`duration: '${duration}${unit}',`, '');
                    script = script.replace(`vus: ${vus},`, '');

                    script += `
  stages: [
    { duration: '10s', target: ${Math.floor(vus / 2)} }, // Ramp up to 50%
    { duration: '20s', target: ${vus} }, // Ramp up to 100%
    { duration: '${duration}${unit}', target: ${vus} }, // Stay at 100%
    { duration: '10s', target: 0 }, // Ramp down
  ],`;
                } else if (loadPattern === 'spike') {
                    script = script.replace(`duration: '${duration}${unit}',`, '');
                    script = script.replace(`vus: ${vus},`, '');
                    script += `
  stages: [
    { duration: '10s', target: ${Math.floor(vus / 5)} }, // Warm up
    { duration: '10s', target: ${vus * 2} }, // Spike!
    { duration: '1m', target: ${vus * 2} }, // Hold spike
    { duration: '10s', target: 0 }, // Cool down
  ],`;
                } else if (loadPattern === 'stress') {
                    script += `
  stages: [
    { duration: '1m', target: ${vus} },
    { duration: '2m', target: ${vus} },
    { duration: '1m', target: ${vus * 2} }, // Stress point
    { duration: '2m', target: ${vus * 2} },
    { duration: '1m', target: 0 },
  ],`;
                    // Remove default duration/vus if we use stages, but for stress we might want to keep them as base
                    // K6 prefers stages for this.
                    script = script.replace(`duration: '${duration}${unit}',`, '');
                    script = script.replace(`vus: ${vus},`, '');
                }

                if (enableThresholds) {
                    script += `
  thresholds: {
    http_req_duration: ['p(95)<${p95}', 'max<${maxResponseTime * 2}'],
    http_req_failed: ['rate<${maxErrorRate / 100}'],
  },`;
                }

                script += `
};

export default function() {`;

                steps.forEach((step, index) => {
                    if (step.type === 'http') {
                        const url = step.path.startsWith('http') ? step.path : `\${baseUrl}${step.path}`;
                        let params = authHeaders || '';
                        if (!params && step.method === 'POST') params = ', { headers: { "Content-Type": "application/json" } }';
                        // Merge auth headers if exists

                        script += `
  const res${index} = http.${step.method.toLowerCase()}('${url}'${params});`;

                        script += `
  check(res${index}, {
    'status is 200': (r) => r.status === 200,
    'response time < ${maxResponseTime}ms': (r) => r.timings.duration < ${maxResponseTime},
  });`;
                    } else if (step.type === 'think-time') {
                        script += `
  sleep(${step.duration});`;
                    } else if (step.type === 'check') {
                        script += `
  // Check: ${step.condition}`;
                    }
                });

                script += `
}`;

                document.getElementById('k6Output').textContent = script;
            }

            function generateLocustScript() {
                const testName = document.getElementById('testName').value;
                const baseUrl = document.getElementById('baseUrl').value;

                const authType = document.getElementById('authType').value;
                let authHeaders = '';

                let script = `from locust import HttpUser, task, between

class ${testName.replace(/[^a-zA-Z0-9]/g, '')}User(HttpUser):
    wait_time = between(1, 3)
    host = '${baseUrl}'
`;
                if (document.getElementById('distributedMode').checked) {
                    script = `# DISTRIBUTED MODE
# Run master: locust -f script.py --master
# Run worker: locust -f script.py --worker --master-host=<master-ip>
` + script;
                }

                if (authType === 'basic') {
                    const user = document.getElementById('authUsername').value;
                    const pass = document.getElementById('authPassword').value;
                    script += `    # Basic Auth is handled automatically if provided in URL or via client.auth
    # self.client.auth = ('${user}', '${pass}')
`;
                } else if (authType === 'bearer') {
                    const token = document.getElementById('authToken').value;
                    script += `    
    def on_start(self):
        self.client.headers.update({'Authorization': 'Bearer ${token}'})
`;
                } else if (authType === 'apikey') {
                    const key = document.getElementById('authKeyName').value;
                    const val = document.getElementById('authKeyValue').value;
                    script += `    
    def on_start(self):
        self.client.headers.update({'${key}': '${val}'})
`;
                }

                steps.forEach((step, index) => {
                    if (step.type === 'http') {
                        const methodName = `${step.method.toLowerCase()}_${step.path.replace(/[^a-zA-Z0-9]/g, '_')}`;
                        script += `
    @task
    def ${methodName}(self):
        self.client.${step.method.toLowerCase()}('${step.path}')`;
                    }
                });

                if (loadPattern === 'ramp' || loadPattern === 'spike') {
                    script += `

from locust import LoadTestShape

class StepLoadShape(LoadTestShape):
    """
    A step load shape
    """
    step_time = 30
    step_load = 10
    spawn_rate = 10
    limit = ${vus}

    def tick(self):
        run_time = self.get_run_time()
        if run_time > self.step_time:
            self.step_time += 30
            self.step_load += 10
            if self.step_load > self.limit:
                self.step_load = self.limit
        return (self.step_load, self.spawn_rate)
`;
                }

                document.getElementById('locustOutput').textContent = script;
            }

            function generateJMeterScript() {
                const testName = document.getElementById('testName').value;
                const baseUrl = document.getElementById('baseUrl').value;
                const vus = document.getElementById('virtualUsers').value;
                const duration = document.getElementById('duration').value;

                let script = `<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2">
  <hashTree>
    <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="${testName}">
      <elementProp name="TestPlan.user_defined_variables" elementType="Arguments"/>
    </TestPlan>
    <hashTree>
      <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Users">
        <stringProp name="ThreadGroup.num_threads">${vus}</stringProp>
        <stringProp name="ThreadGroup.duration">${duration}</stringProp>
      </ThreadGroup>
      <!-- Distributed Mode: To run distributed, configure remote_hosts in jmeter.properties and run: jmeter -n -t script.jmx -r -->
      <hashTree>`;
                if (document.getElementById('distributedMode').checked) {
                    // JMeter distributed mode is mostly config outside the script, but we can add a comment property
                }

                steps.forEach((step) => {
                    if (step.type === 'http') {
                        script += `
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="${step.method} ${step.path}">
          <stringProp name="HTTPSampler.domain">${baseUrl.replace(/https?:\/\//, '')}</stringProp>
          <stringProp name="HTTPSampler.path">${step.path}</stringProp>
          <stringProp name="HTTPSampler.method">${step.method}</stringProp>
        </HTTPSamplerProxy>
        <hashTree/>`;
                    }
                });

                script += `
      </hashTree>
    </hashTree>
  </hashTree>
</jmeterTestPlan>`;

                document.getElementById('jmeterOutput').textContent = script;
            }

            function generateGatlingScript() {
                const testName = document.getElementById('testName').value;
                const baseUrl = document.getElementById('baseUrl').value;
                const vus = document.getElementById('virtualUsers').value;
                const duration = document.getElementById('duration').value;
                const unit = document.getElementById('durationUnit').value;

                const className = testName.replace(/[^a-zA-Z0-9]/g, '') || 'LoadTest';
                const durationInSeconds = unit === 'm' ? duration * 60 : (unit === 'h' ? duration * 3600 : duration);

                let script = `import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class ${className} extends Simulation {

  val httpProtocol = http
    .baseUrl("${baseUrl}")
    .acceptHeader("application/json")

  val scn = scenario("${testName}")`;

                steps.forEach((step, index) => {
                    if (step.type === 'http') {
                        script += `
    .exec(http("request_${index}")
      .${step.method.toLowerCase()}("${step.path}"))`;
                    } else if (step.type === 'think-time') {
                        script += `
    .pause(${step.duration})`;
                    }
                });

                script += `

  setUp(
    scn.inject(
      rampUsers(${vus}).during(${durationInSeconds} seconds)
    ).protocols(httpProtocol)
  )
}`;

                document.getElementById('gatlingOutput').textContent = script;
            }

            function generateArtilleryScript() {
                const baseUrl = document.getElementById('baseUrl').value;
                const vus = document.getElementById('virtualUsers').value;
                const duration = document.getElementById('duration').value;
                const unit = document.getElementById('durationUnit').value;
                const durationInSeconds = unit === 'm' ? duration * 60 : (unit === 'h' ? duration * 3600 : duration);

                let script = `config:
  target: "${baseUrl}"
  phases:
    - duration: ${durationInSeconds}
      arrivalRate: ${vus}
scenarios:
  - flow:`;

                steps.forEach((step) => {
                    if (step.type === 'http') {
                        script += `
      - ${step.method.toLowerCase()}:
          url: "${step.path}"`;
                    } else if (step.type === 'think-time') {
                        script += `
      - think: ${step.duration}`;
                    }
                });

                document.getElementById('artilleryOutput').textContent = script;
            }

            function generateVegetaScript() {
                const baseUrl = document.getElementById('baseUrl').value;
                let script = '';

                steps.forEach((step) => {
                    if (step.type === 'http') {
                        const url = step.path.startsWith('http') ? step.path : `${baseUrl}${step.path}`;
                        script += `${step.method} ${url}\n`;
                    }
                });

                document.getElementById('vegetaOutput').textContent = script;
            }

            function updateRunInstructions() {
                const activeTab = document.querySelector('.framework-tabs .nav-link.active');
                const framework = activeTab.getAttribute('data-framework');
                const container = document.getElementById('runInstructions');
                const filename = getFilename(framework);

                let content = '';
                if (framework === 'k6') {
                    content = `
                        <div class="alert alert-secondary mb-0">
                            <code class="d-block mb-2"># 1. Install K6</code>
                            <code class="d-block mb-2">brew install k6</code>
                            <code class="d-block mb-2"># 2. Run the script</code>
                            <code class="d-block">k6 run ${filename}</code>
                        </div>`;
                } else if (framework === 'locust') {
                    content = `
                        <div class="alert alert-secondary mb-0">
                            <code class="d-block mb-2"># 1. Install Locust</code>
                            <code class="d-block mb-2">pip3 install locust</code>
                            <code class="d-block mb-2"># 2. Run the script</code>
                            <code class="d-block mb-2">locust -f ${filename}</code>
                            <code class="d-block"># 3. Open http://localhost:8089 in your browser</code>
                        </div>`;
                } else if (framework === 'jmeter') {
                    content = `
                        <div class="alert alert-secondary mb-0">
                            <code class="d-block mb-2"># 1. Install JMeter (requires Java)</code>
                            <code class="d-block mb-2">brew install jmeter</code>
                            <code class="d-block mb-2"># 2. Run in GUI mode</code>
                            <code class="d-block mb-2">jmeter -t ${filename}</code>
                            <code class="d-block mb-2"># 3. Run in CLI mode (for load testing)</code>
                            <code class="d-block">jmeter -n -t ${filename} -l results.jtl</code>
                        </div>`;
                } else if (framework === 'gatling') {
                    content = `
                        <div class="alert alert-secondary mb-0">
                            <code class="d-block mb-2"># 1. Download Gatling bundle from gatling.io</code>
                            <code class="d-block mb-2"># 2. Place script in user-files/simulations/</code>
                            <code class="d-block mb-2"># 3. Run Gatling</code>
                            <code class="d-block">./bin/gatling.sh</code>
                        </div>`;
                } else if (framework === 'artillery') {
                    content = `
                        <div class="alert alert-secondary mb-0">
                            <code class="d-block mb-2"># 1. Install Artillery</code>
                            <code class="d-block mb-2">npm install -g artillery</code>
                            <code class="d-block mb-2"># 2. Run the script</code>
                            <code class="d-block">artillery run ${filename}</code>
                        </div>`;
                } else if (framework === 'vegeta') {
                    content = `
                        <div class="alert alert-secondary mb-0">
                            <code class="d-block mb-2"># 1. Install Vegeta</code>
                            <code class="d-block mb-2">brew install vegeta</code>
                            <code class="d-block mb-2"># 2. Run the attack</code>
                            <code class="d-block">vegeta attack -targets=${filename} -rate=10 -duration=30s | vegeta report</code>
                        </div>`;
                }
                container.innerHTML = content;
            }

            function getFilename(framework) {
                const extensions = { k6: 'js', locust: 'py', jmeter: 'jmx', gatling: 'scala', artillery: 'yml', vegeta: 'txt' };
                return `load-test.${extensions[framework]}`;
            }

            function loadPreset(presetName) {
                steps = [];
                stepCounter = 0;

                if (presetName === 'api-test') {
                    document.getElementById('testName').value = 'simple-api-test';
                    document.getElementById('baseUrl').value = 'https://api.example.com';
                    document.getElementById('virtualUsers').value = '10';
                    document.getElementById('duration').value = '30';
                    document.getElementById('durationUnit').value = 's';
                    document.getElementById('loadPattern').value = 'constant';
                    document.getElementById('maxResponseTime').value = '200';
                    document.getElementById('p95ResponseTime').value = '500';
                    document.getElementById('maxErrorRate').value = '0.1';

                    addStep('http');
                    steps[steps.length - 1].method = 'GET';
                    steps[steps.length - 1].path = '/api/users';

                } else if (presetName === 'multi-step') {
                    document.getElementById('testName').value = 'multi-step-flow';
                    document.getElementById('baseUrl').value = 'https://api.example.com';
                    document.getElementById('virtualUsers').value = '20';
                    document.getElementById('duration').value = '2';
                    document.getElementById('durationUnit').value = 'm';

                    // Step 1: Browse products
                    addStep('http');
                    steps[steps.length - 1].method = 'GET';
                    steps[steps.length - 1].path = '/api/products';

                    // Step 2: Think time
                    addStep('think-time');
                    steps[steps.length - 1].duration = 2;

                    // Step 3: Add to cart
                    addStep('http');
                    steps[steps.length - 1].method = 'POST';
                    steps[steps.length - 1].path = '/api/cart/add';

                    // Step 4: Think time
                    addStep('think-time');
                    steps[steps.length - 1].duration = 1;

                    // Step 5: Checkout
                    addStep('http');
                    steps[steps.length - 1].method = 'POST';
                    steps[steps.length - 1].path = '/api/checkout';

                } else if (presetName === 'stress-test') {
                    document.getElementById('testName').value = 'stress-test';
                    document.getElementById('baseUrl').value = 'https://api.example.com';
                    document.getElementById('virtualUsers').value = '100';
                    document.getElementById('duration').value = '5';
                    document.getElementById('durationUnit').value = 'm';
                    document.getElementById('loadPattern').value = 'stress';
                    document.getElementById('maxResponseTime').value = '1000';
                    document.getElementById('p95ResponseTime').value = '2000';
                    document.getElementById('maxErrorRate').value = '5';

                    addStep('http');
                    steps[steps.length - 1].method = 'POST';
                    steps[steps.length - 1].path = '/api/process';

                } else if (presetName === 'spike-test') {
                    document.getElementById('testName').value = 'spike-test';
                    document.getElementById('baseUrl').value = 'https://api.example.com';
                    document.getElementById('virtualUsers').value = '50';
                    document.getElementById('duration').value = '3';
                    document.getElementById('durationUnit').value = 'm';
                    document.getElementById('loadPattern').value = 'spike';
                    document.getElementById('maxResponseTime').value = '500';
                    document.getElementById('p95ResponseTime').value = '1500';
                    document.getElementById('maxErrorRate').value = '2';

                    addStep('http');
                    steps[steps.length - 1].method = 'GET';
                    steps[steps.length - 1].path = '/api/data';

                } else if (presetName === 'endurance') {
                    document.getElementById('testName').value = 'endurance-test';
                    document.getElementById('baseUrl').value = 'https://api.example.com';
                    document.getElementById('virtualUsers').value = '30';
                    document.getElementById('duration').value = '2';
                    document.getElementById('durationUnit').value = 'h';
                    document.getElementById('loadPattern').value = 'constant';
                    document.getElementById('maxResponseTime').value = '300';
                    document.getElementById('p95ResponseTime').value = '800';
                    document.getElementById('maxErrorRate').value = '0.5';

                    addStep('http');
                    steps[steps.length - 1].method = 'GET';
                    steps[steps.length - 1].path = '/api/health';

                    addStep('think-time');
                    steps[steps.length - 1].duration = 3;
                }

                renderSteps();
                generateAllScripts();
            }

            function copyScript() {
                const activeTab = document.querySelector('.framework-tabs .nav-link.active');
                const framework = activeTab.getAttribute('data-framework');
                const content = document.getElementById(framework + 'Output').textContent;

                navigator.clipboard.writeText(content).then(() => {
                    const btn = event.target.closest('button');
                    const orig = btn.innerHTML;
                    btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                    setTimeout(() => btn.innerHTML = orig, 2000);
                });
            }

            function downloadScript() {
                const activeTab = document.querySelector('.framework-tabs .nav-link.active');
                const framework = activeTab.getAttribute('data-framework');
                const content = document.getElementById(framework + 'Output').textContent;
                const filename = getFilename(framework);

                const blob = new Blob([content], { type: 'text/plain' });
                const link = document.createElement('a');
                link.href = URL.createObjectURL(blob);
                link.download = filename;
                link.click();
            }

            function toggleAuthFields() {
                const type = document.getElementById('authType').value;
                document.getElementById('authFields').style.display = type === 'none' ? 'none' : 'block';
                document.getElementById('basicAuthFields').style.display = type === 'basic' ? 'block' : 'none';
                document.getElementById('bearerAuthFields').style.display = type === 'bearer' ? 'block' : 'none';
                document.getElementById('apiKeyFields').style.display = type === 'apikey' ? 'block' : 'none';
                generateAllScripts();
            }
        </script>

        <div class="row mt-4">
            <div class="col-12">
                <div class="card tool-card">
                    <div class="card-body">
                        <h5 class="card-title mb-4"><i class="fas fa-question-circle"></i> Frequently Asked Questions
                        </h5>
                        <div class="accordion" id="faqAccordion">
                            <div class="card">
                                <div class="card-header" id="headingOne">
                                    <h2 class="mb-0">
                                        <button class="btn btn-link btn-block text-left" type="button"
                                            data-toggle="collapse" data-target="#collapseOne">
                                            Which load testing tool should I choose?
                                        </button>
                                    </h2>
                                </div>
                                <div id="collapseOne" class="collapse show" data-parent="#faqAccordion">
                                    <div class="card-body">
                                        It depends on your team's expertise and requirements:
                                        <ul>
                                            <li><strong>K6 (JavaScript):</strong> Best for developers and CI/CD
                                                integration.</li>
                                            <li><strong>Locust (Python):</strong> Great for complex user flows and
                                                Python developers.</li>
                                            <li><strong>JMeter (Java/GUI):</strong> Ideal for enterprise protocols and
                                                non-coders.</li>
                                            <li><strong>Gatling (Scala):</strong> Excellent for high performance and
                                                detailed reporting.</li>
                                            <li><strong>Artillery (Node.js):</strong> Perfect for serverless and
                                                cloud-native apps.</li>
                                            <li><strong>Vegeta (Go):</strong> Best for simple, high-concurrency HTTP
                                                benchmarking.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header" id="headingTwo">
                                    <h2 class="mb-0">
                                        <button class="btn btn-link btn-block text-left collapsed" type="button"
                                            data-toggle="collapse" data-target="#collapseTwo">
                                            How do I run the generated scripts?
                                        </button>
                                    </h2>
                                </div>
                                <div id="collapseTwo" class="collapse" data-parent="#faqAccordion">
                                    <div class="card-body">
                                        Each tool requires its own runtime. The "How to Run" section in the generator
                                        provides the exact CLI commands for your generated script. Generally, you'll
                                        need to install the tool (e.g., <code>brew install k6</code> or
                                        <code>pip install locust</code>) and then run the script file.
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header" id="headingThree">
                                    <h2 class="mb-0">
                                        <button class="btn btn-link btn-block text-left collapsed" type="button"
                                            data-toggle="collapse" data-target="#collapseThree">
                                            Can I customize the load pattern?
                                        </button>
                                    </h2>
                                </div>
                                <div id="collapseThree" class="collapse" data-parent="#faqAccordion">
                                    <div class="card-body">
                                        Yes! You can choose between Constant Load, Ramp Up/Down, Spike Test, and Stress
                                        Test patterns. You can also configure the number of virtual users (VUs) and the
                                        test duration.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

            <hr>
            <h2 class="mt-4" id="faqs">Load Testing FAQs</h2>
            <div class="accordion" id="ltFaqs">
                <div class="card"><div class="card-header"><h6 class="mb-0">When should I use VUs vs RPS (k6)?</h6></div><div class="card-body small text-muted">VUs emulate users and think time; RPS targets throughput. Use thresholds to enforce SLOs.</div></div>
                <div class="card"><div class="card-header"><h6 class="mb-0">How do I model multi-step flows?</h6></div><div class="card-body small text-muted">Define scenarios with sequential steps and think time; tag requests to group results.</div></div>
                <div class="card"><div class="card-header"><h6 class="mb-0">Can I run tests in CI?</h6></div><div class="card-body small text-muted">Yes—run via CLI in GitHub Actions/GitLab CI and fail builds using latency/error thresholds.</div></div>
            </div>

            <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="footer_adsense.jsp" %>
            <%@ include file="thanks.jsp" %>
                <hr>
                <%@ include file="addcomments.jsp" %>
                    </div>
                    <%@ include file="body-close.jsp" %>

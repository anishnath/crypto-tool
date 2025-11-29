<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Kubernetes YAML Generator Online – Free | 8gwifi.org</title>
    <meta name="description" content="Free online Kubernetes YAML/JSON generator for Pods, Deployments, StatefulSets, Jobs, CronJobs, ConfigMaps, Secrets, and Services. Generate K8s manifests instantly with resource limits, health checks, and environment variables. No signup required.">
    <meta name="keywords" content="kubernetes yaml generator, k8s manifest generator, kubernetes deployment generator, kubernetes pod generator, kubernetes statefulset generator, kubernetes job generator, kubernetes cronjob generator, kubernetes configmap generator, kubernetes secret generator, kubernetes service generator, k8s yaml online, kubernetes json generator, generate kubernetes yaml, k8s deployment yaml, kubectl apply yaml, kubernetes manifest creator, kubernetes config generator, k8s yaml template, kubernetes resource generator">
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/kube.jsp" />

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Kubernetes YAML/JSON Generator",
        "alternateName": ["K8s Manifest Generator", "Kubernetes Config Generator", "K8s YAML Tool"],
        "description": "Free online tool to generate Kubernetes manifests for Pods, Deployments, StatefulSets, Jobs, CronJobs, ConfigMaps, Secrets, and Services in YAML and JSON format. Supports resource limits, health checks, environment variables, and all secret types.",
        "url": "https://8gwifi.org/kube.jsp",
        "applicationCategory": "DeveloperApplication",
        "applicationSubCategory": "DevOps Tools",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
        "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
        "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
        "datePublished": "2020-02-19",
        "dateModified": "2025-11-29",
        "featureList": [
            "Generate Kubernetes Pod YAML/JSON",
            "Generate Kubernetes Deployment manifests",
            "Generate StatefulSet configurations",
            "Generate Kubernetes Jobs and CronJobs",
            "Generate ConfigMaps and Secrets",
            "Generate Kubernetes Services (ClusterIP, NodePort, LoadBalancer)",
            "Support for TLS, Docker Registry, SSH, and Basic Auth secrets",
            "Resource limits and requests configuration",
            "Liveness and readiness probe setup",
            "Environment variables with key-value editor",
            "Download YAML/JSON files",
            "Share configuration via URL"
        ],
        "screenshot": "https://8gwifi.org/images/site/kube.png",
        "softwareVersion": "2.0",
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.8",
            "ratingCount": "1250",
            "bestRating": "5",
            "worstRating": "1"
        }
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "How do I generate Kubernetes YAML/JSON manifests?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Select the resource type (Pod, Deployment, StatefulSet, Job, CronJob, ConfigMap, Secret, or Service) from the dropdown. Fill in the configuration form with details like container image, ports, environment variables, resource limits, and labels. Click Generate to create valid Kubernetes YAML and JSON manifests ready for kubectl apply."
            }
        },{
            "@type": "Question",
            "name": "What Kubernetes resources can I generate with this tool?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "This tool generates 8 Kubernetes resource types: 1) Pods - single container instances, 2) Deployments - for stateless apps with rolling updates, 3) StatefulSets - for stateful apps with persistent storage, 4) Jobs - one-time batch tasks, 5) CronJobs - scheduled recurring tasks, 6) ConfigMaps - configuration data storage, 7) Secrets - sensitive data like passwords, TLS certs, Docker registry credentials, and 8) Services - network access with ClusterIP, NodePort, LoadBalancer types."
            }
        },{
            "@type": "Question",
            "name": "What types of Kubernetes Secrets can I create?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The generator supports 5 Kubernetes Secret types: 1) Opaque - generic key-value secrets, 2) kubernetes.io/basic-auth - username/password for HTTP authentication, 3) kubernetes.io/ssh-auth - SSH private keys, 4) kubernetes.io/tls - TLS certificates with tls.crt and tls.key, and 5) kubernetes.io/dockerconfigjson - Docker registry credentials for pulling private images. All secrets use stringData for automatic base64 encoding."
            }
        },{
            "@type": "Question",
            "name": "How do I create a Kubernetes CronJob YAML?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Select 'CronJob' from the resource dropdown. Enter the cron schedule (e.g., '*/5 * * * *' for every 5 minutes), container image, command, and optional settings like concurrency policy, backoff limit, and job history limits. The generator creates a valid batch/v1 CronJob manifest with proper jobTemplate structure."
            }
        },{
            "@type": "Question",
            "name": "What is the difference between ConfigMap and Secret in Kubernetes?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "ConfigMaps store non-sensitive configuration data like environment variables and config files in plain text. Secrets store sensitive data like passwords, API keys, and TLS certificates with base64 encoding. While both can be mounted as volumes or environment variables, Secrets provide additional security features and should be used for any sensitive information."
            }
        },{
            "@type": "Question",
            "name": "How do I set resource limits and requests in Kubernetes?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "In the Resource Limits section, set CPU limits/requests (e.g., '500m' for 0.5 CPU cores, '1' for 1 core) and memory limits/requests (e.g., '256Mi', '1Gi'). Requests guarantee minimum resources for scheduling, while limits cap maximum usage. Best practice: set requests equal to or slightly below limits for predictable performance."
            }
        },{
            "@type": "Question",
            "name": "Can I download the generated Kubernetes manifest?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes! After generating a manifest, use the Download YAML or Download JSON buttons to save the file directly. You can also use the Share URL feature to create a shareable link that preserves all your configuration settings, making it easy to collaborate or save configurations for later."
            }
        },{
            "@type": "Question",
            "name": "What API versions does the generator use?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The generator uses current stable API versions: v1 for Pods, Services, ConfigMaps, and Secrets; apps/v1 for Deployments and StatefulSets; batch/v1 for Jobs and CronJobs. These are the recommended versions for Kubernetes 1.16+ and ensure compatibility with modern clusters."
            }
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Generate Kubernetes YAML Manifests Online",
        "description": "Step-by-step guide to create Kubernetes resource manifests (Pod, Deployment, StatefulSet, Job, CronJob, ConfigMap, Secret, Service) using our free online generator.",
        "totalTime": "PT2M",
        "estimatedCost": {"@type": "MonetaryAmount", "currency": "USD", "value": "0"},
        "tool": [
            {"@type": "HowToTool", "name": "Web browser"},
            {"@type": "HowToTool", "name": "kubectl (for applying manifests)"}
        ],
        "step": [{
            "@type": "HowToStep",
            "position": 1,
            "name": "Select Resource Type",
            "text": "Choose the Kubernetes resource type from the dropdown: Pod/Deployment, Service, StatefulSet, Job, CronJob, ConfigMap, or Secret.",
            "url": "https://8gwifi.org/kube.jsp#step1"
        },{
            "@type": "HowToStep",
            "position": 2,
            "name": "Configure Basic Settings",
            "text": "Enter the resource name, namespace, and for workloads specify the container image (e.g., nginx:latest, redis:7-alpine).",
            "url": "https://8gwifi.org/kube.jsp#step2"
        },{
            "@type": "HowToStep",
            "position": 3,
            "name": "Add Labels and Environment Variables",
            "text": "Use the key-value editor to add labels for organization and selectors, and environment variables for configuration.",
            "url": "https://8gwifi.org/kube.jsp#step3"
        },{
            "@type": "HowToStep",
            "position": 4,
            "name": "Set Resource Limits (Recommended)",
            "text": "Configure CPU and memory requests/limits. Example: CPU request 100m, limit 500m; Memory request 128Mi, limit 512Mi.",
            "url": "https://8gwifi.org/kube.jsp#step4"
        },{
            "@type": "HowToStep",
            "position": 5,
            "name": "Generate and Download",
            "text": "Click Generate to create the manifest. Review the YAML/JSON output, then use Download YAML or Download JSON to save the file.",
            "url": "https://8gwifi.org/kube.jsp#step5"
        },{
            "@type": "HowToStep",
            "position": 6,
            "name": "Apply to Kubernetes Cluster",
            "text": "Apply the manifest to your cluster using: kubectl apply -f manifest.yaml. Verify with kubectl get pods or kubectl get deployments.",
            "url": "https://8gwifi.org/kube.jsp#step6"
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [{
            "@type": "ListItem",
            "position": 1,
            "name": "Home",
            "item": "https://8gwifi.org"
        },{
            "@type": "ListItem",
            "position": 2,
            "name": "DevOps Tools",
            "item": "https://8gwifi.org/devops.jsp"
        },{
            "@type": "ListItem",
            "position": 3,
            "name": "Kubernetes YAML Generator",
            "item": "https://8gwifi.org/kube.jsp"
        }]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #326ce5;
            --theme-secondary: #1d4ed8;
            --theme-gradient: linear-gradient(135deg, #326ce5 0%, #1d4ed8 100%);
            --theme-light: #eff6ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(50, 108, 229, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(50, 108, 229, 0.25);
        }
        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 0.75rem 1rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
            font-size: 1rem;
        }
        .form-section {
            background: var(--theme-light);
            border-radius: 6px;
            padding: 0.5rem;
            margin-bottom: 0.5rem;
        }
        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.4rem;
            font-size: 0.8rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .form-section-title:hover {
            color: var(--theme-secondary);
        }
        .form-section-title i {
            transition: transform 0.2s;
        }
        .form-section-title[aria-expanded="true"] i.fa-chevron-down {
            transform: rotate(180deg);
        }
        .form-section-content.collapse:not(.show) {
            display: none;
        }
        .form-section-content.collapsing {
            position: relative;
            height: 0;
            overflow: hidden;
            transition: height 0.35s ease;
        }
        .form-group {
            margin-bottom: 0.5rem;
        }
        .form-group label {
            font-size: 0.8rem;
            margin-bottom: 0.2rem;
            font-weight: 500;
        }
        .form-control-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        .card-body {
            max-height: 80vh;
            overflow-y: auto;
            padding: 0.75rem;
        }
        .card-body::-webkit-scrollbar {
            width: 6px;
        }
        .card-body::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }
        .card-body::-webkit-scrollbar-thumb {
            background: var(--theme-primary);
            border-radius: 3px;
        }
        .card-body::-webkit-scrollbar-thumb:hover {
            background: var(--theme-secondary);
        }
        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 200px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 150px;
        }
        .result-content {
            display: none;
        }
        .eeat-badge {
            background: var(--theme-gradient);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .info-badge {
            display: inline-block;
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.2rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            margin-right: 0.25rem;
        }
        .hash-output {
            font-family: 'Courier New', monospace;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 0.5rem;
            word-break: break-all;
            position: relative;
            white-space: pre-wrap;
        }
        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1rem;
        }
        .related-tool-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
        }
        .related-tool-card:hover {
            border-color: var(--theme-primary);
            box-shadow: 0 2px 8px rgba(50, 108, 229, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 {
            color: var(--theme-primary);
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
        }
        .related-tool-card p {
            font-size: 0.75rem;
            color: #6c757d;
            margin: 0;
        }
        /* KV Pair Styles */
        .kv-container {
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 0.5rem;
            background: #fff;
        }
        .kv-pair {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            align-items: center;
        }
        .kv-pair:last-child {
            margin-bottom: 0;
        }
        .kv-pair input {
            flex: 1;
        }
        .kv-pair .btn-remove-kv {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            line-height: 1;
            color: #dc3545;
            background: transparent;
            border: 1px solid #dc3545;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
        }
        .kv-pair .btn-remove-kv:hover {
            background: #dc3545;
            color: white;
            text-decoration: none;
        }
        .btn-add-kv {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.25rem 0.75rem;
            font-size: 0.75rem;
            color: var(--theme-primary);
            background: var(--theme-light);
            border: 1px dashed var(--theme-primary);
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 0.5rem;
            text-decoration: none;
        }
        .btn-add-kv:hover {
            background: var(--theme-primary);
            color: white;
            border-style: solid;
            text-decoration: none;
        }
        .kv-label {
            font-size: 0.8rem;
            font-weight: 500;
            margin-bottom: 0.25rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .kv-label small {
            font-weight: normal;
            color: #6c757d;
        }
        /* Prevent icon clicks from causing issues */
        .btn-add-kv i,
        .btn-remove-kv i {
            pointer-events: none;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="devops-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">Kubernetes Spec Generator</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-dharmachakra"></i> Kubernetes</span>
            <span class="info-badge"><i class="fas fa-cube"></i> Pods</span>
            <span class="info-badge"><i class="fas fa-layer-group"></i> Deployments</span>
            <span class="info-badge"><i class="fas fa-network-wired"></i> Services</span>
        </div>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-user-check"></i>
        <span>Anish Nath</span>
    </div>
</div>

<div class="row">
    <!-- Left Column: Input Forms -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-cogs mr-2"></i>Kubernetes Configuration</h5>
            </div>
            <div class="card-body">
                <!-- Resource Type Selector -->
                <div class="form-group mb-3">
                    <label for="selectkubeobject">Build Kubernetes Object</label>
                    <select class="form-control form-control-sm" id="selectkubeobject">
                        <option value="1">Pod / Deployment</option>
                        <option value="2">Service</option>
                        <option value="3">StatefulSet</option>
                        <option value="4">Job</option>
                        <option value="5">CronJob</option>
                        <option value="6">ConfigMap</option>
                        <option value="7">Secret</option>
                    </select>
                </div>

                <!-- Service Form -->
                <form id="service" method="POST" style="display: none;">
                    <input type="hidden" name="methodName" value="SERVICE_GENERATE">

                    <div class="form-section">
                        <div class="form-section-title" data-section="#serviceBasic" aria-expanded="true">
                            <span><i class="fas fa-network-wired mr-1"></i>Service Configuration</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="serviceBasic" class="form-section-content collapse show">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="svcName">Name</label>
                                    <input type="text" class="form-control form-control-sm" id="svcName" name="name" placeholder="my-service">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="svcNamespace">Namespace</label>
                                    <input type="text" class="form-control form-control-sm" value="default" id="svcNamespace" name="namespace">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="type">Service Type</label>
                                <select class="form-control form-control-sm" name="type" id="type">
                                    <option value="ClusterIP" selected>ClusterIP</option>
                                    <option value="NodePort">NodePort</option>
                                    <option value="LoadBalancer">LoadBalancer</option>
                                    <option value="ExternalName">ExternalName</option>
                                </select>
                            </div>

                            <!-- Selector Labels for Service -->
                            <div class="form-group">
                                <div class="kv-label">
                                    <span>Selector Labels</span>
                                    <small>Matches pod labels</small>
                                </div>
                                <input type="hidden" name="label" id="svcLabel">
                                <div class="kv-container" id="svcLabelsContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key (e.g., app)" value="app">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value (e.g., nginx)" value="nginx">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('svcLabelsContainer')">
                                    <i class="fas fa-plus"></i> Add Label
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title" data-section="#servicePorts" aria-expanded="true">
                            <span><i class="fas fa-plug mr-1"></i>Ports</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="servicePorts" class="form-section-content collapse show">
                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="portname">Port Name</label>
                                    <input type="text" class="form-control form-control-sm" value="http" id="portname" name="portname">
                                </div>
                                <div class="form-group col-md-2">
                                    <label for="port">Port</label>
                                    <input type="text" class="form-control form-control-sm" value="80" id="port" name="port">
                                </div>
                                <div class="form-group col-md-3">
                                    <label for="targetPort">Target</label>
                                    <input type="text" class="form-control form-control-sm" value="80" name="targetPort" id="targetPort">
                                </div>
                                <div class="form-group col-md-3">
                                    <label for="protocol">Protocol</label>
                                    <select class="form-control form-control-sm" name="protocol" id="protocol">
                                        <option value="TCP" selected>TCP</option>
                                        <option value="UDP">UDP</option>
                                    </select>
                                </div>
                            </div>
                            <div id="nodePortRow" class="form-row" style="display: none;">
                                <div class="form-group col-md-6">
                                    <label for="nodePort">Node Port</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="30000-32767" name="nodePort" id="nodePort">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title" data-section="#serviceAdvanced" aria-expanded="false">
                            <span><i class="fas fa-sliders-h mr-1"></i>Advanced</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="serviceAdvanced" class="form-section-content collapse">
                            <div class="form-row">
                                <div class="form-group col-md-6" id="clusterIPField">
                                    <label for="clusterIP">Cluster IP</label>
                                    <input type="text" class="form-control form-control-sm" id="clusterIP" name="clusterIP" placeholder="None or IP">
                                </div>
                                <div class="form-group col-md-6" id="loadBalancerIPField" style="display: none;">
                                    <label for="loadBalancerIP">LoadBalancer IP</label>
                                    <input type="text" class="form-control form-control-sm" id="loadBalancerIP" name="loadBalancerIP">
                                </div>
                            </div>
                            <div class="form-group" id="externalNameField" style="display: none;">
                                <label for="externalName">External Name</label>
                                <input type="text" class="form-control form-control-sm" id="externalName" name="externalName" placeholder="my.database.example.com">
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="externalIPs">External IPs</label>
                                    <input type="text" class="form-control form-control-sm" name="externalIPs" id="externalIPs" placeholder="1.2.3.4,5.6.7.8">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="sessionAffinity">Session Affinity</label>
                                    <select class="form-control form-control-sm" name="sessionAffinity" id="sessionAffinity">
                                        <option value="None" selected>None</option>
                                        <option value="ClientIP">ClientIP</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100 mt-2" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-magic mr-2"></i>Generate Service
                    </button>
                </form>

                <!-- Pod/Deployment Form -->
                <form id="form" method="POST">
                    <input type="hidden" name="methodName" value="POD_GENERATE">
                    <input type="hidden" name="deployment" id="deployment" value="pod">

                    <div class="form-section">
                        <div class="form-section-title" data-section="#podMetadata" aria-expanded="true">
                            <span><i class="fas fa-info-circle mr-1"></i>Metadata</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="podMetadata" class="form-section-content collapse show">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="name">Name</label>
                                    <input type="text" class="form-control form-control-sm" id="name" name="name" placeholder="my-pod">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="namespace">Namespace</label>
                                    <input type="text" class="form-control form-control-sm" value="default" id="namespace" name="namespace">
                                </div>
                            </div>
                            <!-- Labels -->
                            <div class="form-group">
                                <div class="kv-label">
                                    <span>Labels</span>
                                    <small>Used for pod selection</small>
                                </div>
                                <input type="hidden" name="label" id="label">
                                <div class="kv-container" id="labelsContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key (e.g., app)" value="app">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value (e.g., nginx)" value="nginx">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('labelsContainer')">
                                    <i class="fas fa-plus"></i> Add Label
                                </a>
                            </div>

                            <!-- Annotations -->
                            <div class="form-group">
                                <div class="kv-label">
                                    <span>Annotations</span>
                                    <small>Metadata for tools</small>
                                </div>
                                <input type="hidden" name="annotation" id="annotation">
                                <div class="kv-container" id="annotationsContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('annotationsContainer')">
                                    <i class="fas fa-plus"></i> Add Annotation
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title" data-section="#containerSpec" aria-expanded="true">
                            <span><i class="fas fa-cube mr-1"></i>Container Spec</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="containerSpec" class="form-section-content collapse show">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="image">Docker Image</label>
                                    <input type="text" class="form-control form-control-sm" id="image" value="nginx" name="image">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="containerName">Container Name</label>
                                    <input type="text" class="form-control form-control-sm" name="containerName" id="containerName" placeholder="nginx">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="imagePullPolicy">Pull Policy</label>
                                    <select class="form-control form-control-sm" name="imagePullPolicy" id="imagePullPolicy">
                                        <option value="IfNotPresent" selected>IfNotPresent</option>
                                        <option value="Always">Always</option>
                                        <option value="Never">Never</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="restartPolicy">Restart</label>
                                    <select class="form-control form-control-sm" name="restartPolicy" id="restartPolicy">
                                        <option value="Always" selected>Always</option>
                                        <option value="OnFailure">OnFailure</option>
                                        <option value="Never">Never</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="containerPorts">Ports</label>
                                    <input type="text" class="form-control form-control-sm" value="80" id="containerPorts" name="containerPorts" placeholder="80,443">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title" data-section="#resourcesSection" aria-expanded="false">
                            <span><i class="fas fa-microchip mr-1"></i>Resources (CPU/Memory)</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="resourcesSection" class="form-section-content collapse">
                            <p class="small text-muted mb-2">Requests (guaranteed resources)</p>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="cpuRequest">CPU Request</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="100m" id="cpuRequest" name="cpuRequest">
                                    <small class="text-muted" style="font-size: 0.65rem;">e.g., 100m, 0.5, 1</small>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="memoryRequest">Memory Request</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="128Mi" id="memoryRequest" name="memoryRequest">
                                    <small class="text-muted" style="font-size: 0.65rem;">e.g., 128Mi, 1Gi</small>
                                </div>
                            </div>
                            <p class="small text-muted mb-2">Limits (maximum allowed)</p>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="cpuLimit">CPU Limit</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="500m" id="cpuLimit" name="cpuLimit">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="memoryLimit">Memory Limit</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="256Mi" id="memoryLimit" name="memoryLimit">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title" data-section="#deploymentSection" aria-expanded="false">
                            <span><i class="fas fa-clone mr-1"></i>Deployment Settings</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="deploymentSection" class="form-section-content collapse">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="replicas">Replicas</label>
                                    <input type="number" class="form-control form-control-sm" value="1" min="1" max="100" id="replicas" name="replicas">
                                    <small class="text-muted" style="font-size: 0.65rem;">Number of pod replicas (for Deployments)</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title" data-section="#envSection" aria-expanded="false">
                            <span><i class="fas fa-cog mr-1"></i>Environment & Commands</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="envSection" class="form-section-content collapse">
                            <!-- Environment Variables -->
                            <div class="form-group">
                                <div class="kv-label">
                                    <span>Environment Variables</span>
                                    <small>KEY=VALUE pairs</small>
                                </div>
                                <input type="hidden" name="environment" id="environment">
                                <div class="kv-container" id="envContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="KEY (e.g., NGINX_HOST)">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value (e.g., example.com)">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('envContainer')">
                                    <i class="fas fa-plus"></i> Add Environment Variable
                                </a>
                            </div>

                            <hr class="my-2">

                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="containercommand">Commands</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="/bin/sh,-c" id="containercommand" name="containercommand">
                                    <small class="text-muted" style="font-size: 0.65rem;">Comma separated</small>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="containerargs">Arguments</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="echo hello" name="containerargs" id="containerargs">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title" data-section="#healthSection" aria-expanded="false">
                            <span><i class="fas fa-heartbeat mr-1"></i>Health Checks</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="healthSection" class="form-section-content collapse">
                            <p class="small text-muted mb-2">Liveness Probe</p>
                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="livenessProbepath">Path</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="/healthz" id="livenessProbepath" name="livenessProbepath">
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="livenessProbeport">Port</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="8080" id="livenessProbeport" name="livenessProbeport">
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="livenessProbescheme">Scheme</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="HTTP" id="livenessProbescheme" name="livenessProbescheme">
                                </div>
                            </div>
                            <p class="small text-muted mb-2">Readiness Probe</p>
                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="readinessProbepath">Path</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="/ready" id="readinessProbepath" name="readinessProbepath">
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="readinessProbeport">Port</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="8080" id="readinessProbeport" name="readinessProbeport">
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="readinessProbescheme">Scheme</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="HTTP" id="readinessProbescheme" name="readinessProbescheme">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title" data-section="#advancedSection" aria-expanded="false">
                            <span><i class="fas fa-sliders-h mr-1"></i>Advanced</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="advancedSection" class="form-section-content collapse">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="volumeMounts">Volume Mounts</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="/mnt/data" name="volumeMounts" id="volumeMounts">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="dnsPolicy">DNS Policy</label>
                                    <select class="form-control form-control-sm" name="dnsPolicy" id="dnsPolicy">
                                        <option value="ClusterFirst" selected>ClusterFirst</option>
                                        <option value="ClusterFirstWithHostNet">ClusterFirstWithHostNet</option>
                                        <option value="None">None</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="serviceAccountName">Service Account</label>
                                    <input type="text" class="form-control form-control-sm" name="serviceAccountName" id="serviceAccountName">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="nodeName">Node Name</label>
                                    <input type="text" class="form-control form-control-sm" name="nodeName" id="nodeName">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title" data-section="#securitySection" aria-expanded="false">
                            <span><i class="fas fa-shield-alt mr-1"></i>Security Context</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="securitySection" class="form-section-content collapse">
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" name="apployonPod" id="apployonPod" value="apployonPod">
                                <label class="form-check-label small" for="apployonPod">Apply on Pod Level</label>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-3">
                                    <label for="runAsUser">runAsUser</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="1000" name="runAsUser" id="runAsUser">
                                </div>
                                <div class="form-group col-md-3">
                                    <label for="runAsGroup">runAsGroup</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="1000" name="runAsGroup" id="runAsGroup">
                                </div>
                                <div class="form-group col-md-3">
                                    <label for="fsGroup">fsGroup</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="2000" name="fsGroup" id="fsGroup">
                                </div>
                                <div class="form-group col-md-3">
                                    <label for="runAsNonRoot">nonRoot</label>
                                    <input type="text" class="form-control form-control-sm" placeholder="true" name="runAsNonRoot" id="runAsNonRoot">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex mt-2" style="gap: 0.5rem;">
                        <button type="button" class="btn flex-fill" id="generatePod" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                            <i class="fas fa-cube mr-1"></i>Generate Pod
                        </button>
                        <button type="button" class="btn flex-fill" id="generateDeployment" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                            <i class="fas fa-layer-group mr-1"></i>Generate Deployment
                        </button>
                    </div>
                </form>

                <!-- StatefulSet Form -->
                <form id="statefulsetForm" method="POST" style="display: none;">
                    <input type="hidden" name="methodName" value="STATEFULSET_GENERATE">

                    <div class="form-section">
                        <div class="form-section-title" data-section="#ssMetadata" aria-expanded="true">
                            <span><i class="fas fa-database mr-1"></i>StatefulSet Configuration</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="ssMetadata" class="form-section-content collapse show">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="ssName">Name</label>
                                    <input type="text" class="form-control form-control-sm" id="ssName" name="name" placeholder="my-statefulset">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="ssNamespace">Namespace</label>
                                    <input type="text" class="form-control form-control-sm" id="ssNamespace" name="namespace" value="default">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="ssImage">Docker Image <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control form-control-sm" id="ssImage" name="image" placeholder="nginx:latest" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="ssContainerName">Container Name</label>
                                    <input type="text" class="form-control form-control-sm" id="ssContainerName" name="containerName" placeholder="container-name">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="ssReplicas">Replicas</label>
                                    <input type="number" class="form-control form-control-sm" id="ssReplicas" name="replicas" value="3" min="1">
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="ssServiceName">Service Name</label>
                                    <input type="text" class="form-control form-control-sm" id="ssServiceName" name="serviceName" placeholder="headless-svc">
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="ssPodManagementPolicy">Pod Management</label>
                                    <select class="form-control form-control-sm" id="ssPodManagementPolicy" name="podManagementPolicy">
                                        <option value="OrderedReady">OrderedReady</option>
                                        <option value="Parallel">Parallel</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="ssContainerPorts">Container Ports</label>
                                    <input type="text" class="form-control form-control-sm" id="ssContainerPorts" name="containerPorts" placeholder="80,443">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="ssVolumeMounts">Volume Mounts</label>
                                    <input type="text" class="form-control form-control-sm" id="ssVolumeMounts" name="volumeMounts" placeholder="/data,/config">
                                    <small class="form-text text-muted">Comma-separated mount paths</small>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Labels</label>
                                <input type="hidden" id="ssLabel" name="label">
                                <div class="kv-container" id="ssLabelsContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key" value="app">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value" value="myapp">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('ssLabelsContainer')">
                                    <i class="fas fa-plus"></i> Add Label
                                </a>
                            </div>
                            <div class="form-group">
                                <label>Environment Variables</label>
                                <input type="hidden" id="ssEnvironment" name="environment">
                                <div class="kv-container" id="ssEnvContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('ssEnvContainer')">
                                    <i class="fas fa-plus"></i> Add Environment Variable
                                </a>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-block mt-3" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-database mr-1"></i>Generate StatefulSet
                    </button>
                </form>

                <!-- Job Form -->
                <form id="jobForm" method="POST" style="display: none;">
                    <input type="hidden" name="methodName" value="JOB_GENERATE">

                    <div class="form-section">
                        <div class="form-section-title" data-section="#jobConfig" aria-expanded="true">
                            <span><i class="fas fa-tasks mr-1"></i>Job Configuration</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="jobConfig" class="form-section-content collapse show">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="jobName">Name</label>
                                    <input type="text" class="form-control form-control-sm" id="jobName" name="name" placeholder="my-job">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="jobNamespace">Namespace</label>
                                    <input type="text" class="form-control form-control-sm" id="jobNamespace" name="namespace" value="default">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="jobImage">Docker Image <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control form-control-sm" id="jobImage" name="image" placeholder="busybox:latest" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="jobContainerName">Container Name</label>
                                    <input type="text" class="form-control form-control-sm" id="jobContainerName" name="containerName" placeholder="container-name">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="jobCommand">Command</label>
                                    <input type="text" class="form-control form-control-sm" id="jobCommand" name="containercommand" placeholder="echo">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="jobArgs">Arguments</label>
                                    <input type="text" class="form-control form-control-sm" id="jobArgs" name="containerargs" placeholder="Hello World">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-3">
                                    <label for="jobBackoffLimit">Backoff Limit</label>
                                    <input type="number" class="form-control form-control-sm" id="jobBackoffLimit" name="backoffLimit" value="6" min="0">
                                </div>
                                <div class="form-group col-md-3">
                                    <label for="jobCompletions">Completions</label>
                                    <input type="number" class="form-control form-control-sm" id="jobCompletions" name="completions" value="1" min="1">
                                </div>
                                <div class="form-group col-md-3">
                                    <label for="jobParallelism">Parallelism</label>
                                    <input type="number" class="form-control form-control-sm" id="jobParallelism" name="parallelism" value="1" min="1">
                                </div>
                                <div class="form-group col-md-3">
                                    <label for="jobRestartPolicy">Restart Policy</label>
                                    <select class="form-control form-control-sm" id="jobRestartPolicy" name="restartPolicy">
                                        <option value="Never">Never</option>
                                        <option value="OnFailure">OnFailure</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="jobTtl">TTL After Finished (seconds)</label>
                                <input type="number" class="form-control form-control-sm" id="jobTtl" name="ttlSecondsAfterFinished" placeholder="100">
                                <small class="form-text text-muted">Auto-delete completed jobs</small>
                            </div>
                            <div class="form-group">
                                <label>Labels</label>
                                <input type="hidden" id="jobLabel" name="label">
                                <div class="kv-container" id="jobLabelsContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key" value="app">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value" value="myjob">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('jobLabelsContainer')">
                                    <i class="fas fa-plus"></i> Add Label
                                </a>
                            </div>
                            <div class="form-group">
                                <label>Environment Variables</label>
                                <input type="hidden" id="jobEnvironment" name="environment">
                                <div class="kv-container" id="jobEnvContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('jobEnvContainer')">
                                    <i class="fas fa-plus"></i> Add Environment Variable
                                </a>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-block mt-3" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-tasks mr-1"></i>Generate Job
                    </button>
                </form>

                <!-- CronJob Form -->
                <form id="cronjobForm" method="POST" style="display: none;">
                    <input type="hidden" name="methodName" value="CRONJOB_GENERATE">

                    <div class="form-section">
                        <div class="form-section-title" data-section="#cronjobConfig" aria-expanded="true">
                            <span><i class="fas fa-clock mr-1"></i>CronJob Configuration</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="cronjobConfig" class="form-section-content collapse show">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="cronjobName">Name</label>
                                    <input type="text" class="form-control form-control-sm" id="cronjobName" name="name" placeholder="my-cronjob">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="cronjobNamespace">Namespace</label>
                                    <input type="text" class="form-control form-control-sm" id="cronjobNamespace" name="namespace" value="default">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="cronjobSchedule">Schedule <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-sm" id="cronjobSchedule" name="schedule" placeholder="*/5 * * * *" required>
                                <small class="form-text text-muted">Cron format: MIN HOUR DOM MON DOW (e.g., "0 2 * * *" for daily at 2am)</small>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="cronjobImage">Docker Image <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control form-control-sm" id="cronjobImage" name="image" placeholder="busybox:latest" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="cronjobContainerName">Container Name</label>
                                    <input type="text" class="form-control form-control-sm" id="cronjobContainerName" name="containerName" placeholder="container-name">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="cronjobCommand">Command</label>
                                    <input type="text" class="form-control form-control-sm" id="cronjobCommand" name="containercommand" placeholder="echo">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="cronjobArgs">Arguments</label>
                                    <input type="text" class="form-control form-control-sm" id="cronjobArgs" name="containerargs" placeholder="Running scheduled task">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="cronjobConcurrency">Concurrency Policy</label>
                                    <select class="form-control form-control-sm" id="cronjobConcurrency" name="concurrencyPolicy">
                                        <option value="Allow">Allow</option>
                                        <option value="Forbid">Forbid</option>
                                        <option value="Replace">Replace</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="cronjobSuccessHistory">Success History</label>
                                    <input type="number" class="form-control form-control-sm" id="cronjobSuccessHistory" name="successfulJobsHistoryLimit" value="3" min="0">
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="cronjobFailHistory">Failed History</label>
                                    <input type="number" class="form-control form-control-sm" id="cronjobFailHistory" name="failedJobsHistoryLimit" value="1" min="0">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Labels</label>
                                <input type="hidden" id="cronjobLabel" name="label">
                                <div class="kv-container" id="cronjobLabelsContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key" value="app">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value" value="mycronjob">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('cronjobLabelsContainer')">
                                    <i class="fas fa-plus"></i> Add Label
                                </a>
                            </div>
                            <div class="form-group">
                                <label>Environment Variables</label>
                                <input type="hidden" id="cronjobEnvironment" name="environment">
                                <div class="kv-container" id="cronjobEnvContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('cronjobEnvContainer')">
                                    <i class="fas fa-plus"></i> Add Environment Variable
                                </a>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-block mt-3" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-clock mr-1"></i>Generate CronJob
                    </button>
                </form>

                <!-- ConfigMap Form -->
                <form id="configmapForm" method="POST" style="display: none;">
                    <input type="hidden" name="methodName" value="CONFIGMAP_GENERATE">

                    <div class="form-section">
                        <div class="form-section-title" data-section="#configmapConfig" aria-expanded="true">
                            <span><i class="fas fa-file-alt mr-1"></i>ConfigMap Configuration</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="configmapConfig" class="form-section-content collapse show">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="configmapName">Name</label>
                                    <input type="text" class="form-control form-control-sm" id="configmapName" name="name" placeholder="my-configmap">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="configmapNamespace">Namespace</label>
                                    <input type="text" class="form-control form-control-sm" id="configmapNamespace" name="namespace" value="default">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Data (Configuration)</label>
                                <input type="hidden" id="configmapData" name="data">
                                <div class="kv-container" id="configmapDataContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key (e.g., APP_ENV)" value="APP_ENV">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value (e.g., production)" value="production">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('configmapDataContainer')">
                                    <i class="fas fa-plus"></i> Add Data Entry
                                </a>
                            </div>
                            <div class="form-group">
                                <label>Labels</label>
                                <input type="hidden" id="configmapLabel" name="label">
                                <div class="kv-container" id="configmapLabelsContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('configmapLabelsContainer')">
                                    <i class="fas fa-plus"></i> Add Label
                                </a>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="configmapImmutable" name="immutable" value="true">
                                <label class="form-check-label small" for="configmapImmutable">Immutable (cannot be modified after creation)</label>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-block mt-3" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-file-alt mr-1"></i>Generate ConfigMap
                    </button>
                </form>

                <!-- Secret Form -->
                <form id="secretForm" method="POST" style="display: none;">
                    <input type="hidden" name="methodName" value="SECRET_GENERATE">

                    <div class="form-section">
                        <div class="form-section-title" data-section="#secretConfig" aria-expanded="true">
                            <span><i class="fas fa-key mr-1"></i>Secret Configuration</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="secretConfig" class="form-section-content collapse show">
                            <div class="alert alert-warning small py-2">
                                <i class="fas fa-exclamation-triangle mr-1"></i>
                                <strong>Security Note:</strong> Secrets are base64-encoded, not encrypted. Use external secret management for production.
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="secretName">Name</label>
                                    <input type="text" class="form-control form-control-sm" id="secretName" name="name" placeholder="my-secret">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="secretNamespace">Namespace</label>
                                    <input type="text" class="form-control form-control-sm" id="secretNamespace" name="namespace" value="default">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="secretType">Secret Type</label>
                                <select class="form-control form-control-sm" id="secretType" name="secretType">
                                    <option value="Opaque">Opaque (generic)</option>
                                    <option value="kubernetes.io/basic-auth">Basic Auth</option>
                                    <option value="kubernetes.io/ssh-auth">SSH Auth</option>
                                    <option value="kubernetes.io/tls">TLS Certificate</option>
                                    <option value="kubernetes.io/dockerconfigjson">Docker Registry</option>
                                </select>
                            </div>

                            <!-- Opaque Secret Data (Generic KV pairs) -->
                            <div class="form-group secret-type-field" id="secretOpaqueFields">
                                <label>Secret Data</label>
                                <input type="hidden" id="secretData" name="data">
                                <div class="kv-container" id="secretDataContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key (e.g., API_KEY)" value="API_KEY">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value" value="your-api-key-here">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('secretDataContainer')">
                                    <i class="fas fa-plus"></i> Add Secret Entry
                                </a>
                                <small class="form-text text-muted">Generic key-value pairs (stringData - auto base64 encoded)</small>
                            </div>

                            <!-- Basic Auth Fields -->
                            <div class="form-group secret-type-field" id="secretBasicAuthFields" style="display: none;">
                                <label>Basic Auth Credentials</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="secretBasicUsername" class="small">Username</label>
                                        <input type="text" class="form-control form-control-sm" id="secretBasicUsername" placeholder="admin">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="secretBasicPassword" class="small">Password</label>
                                        <input type="password" class="form-control form-control-sm" id="secretBasicPassword" placeholder="password">
                                    </div>
                                </div>
                                <small class="form-text text-muted">Used for basic HTTP authentication</small>
                            </div>

                            <!-- SSH Auth Fields -->
                            <div class="form-group secret-type-field" id="secretSSHFields" style="display: none;">
                                <label>SSH Private Key</label>
                                <textarea class="form-control form-control-sm" id="secretSSHKey" rows="6" placeholder="-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----"></textarea>
                                <small class="form-text text-muted">Paste your SSH private key (will be stored as ssh-privatekey)</small>
                            </div>

                            <!-- TLS Certificate Fields -->
                            <div class="form-group secret-type-field" id="secretTLSFields" style="display: none;">
                                <label>TLS Certificate</label>
                                <textarea class="form-control form-control-sm mb-2" id="secretTLSCert" rows="4" placeholder="-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----"></textarea>
                                <label>TLS Private Key</label>
                                <textarea class="form-control form-control-sm" id="secretTLSKey" rows="4" placeholder="-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----"></textarea>
                                <small class="form-text text-muted">For HTTPS/TLS termination (stored as tls.crt and tls.key)</small>
                            </div>

                            <!-- Docker Registry Fields -->
                            <div class="form-group secret-type-field" id="secretDockerFields" style="display: none;">
                                <label>Docker Registry Credentials</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="secretDockerServer" class="small">Registry Server</label>
                                        <input type="text" class="form-control form-control-sm" id="secretDockerServer" placeholder="https://index.docker.io/v1/" value="https://index.docker.io/v1/">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="secretDockerEmail" class="small">Email</label>
                                        <input type="email" class="form-control form-control-sm" id="secretDockerEmail" placeholder="user@example.com">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="secretDockerUsername" class="small">Username</label>
                                        <input type="text" class="form-control form-control-sm" id="secretDockerUsername" placeholder="docker-username">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="secretDockerPassword" class="small">Password / Token</label>
                                        <input type="password" class="form-control form-control-sm" id="secretDockerPassword" placeholder="docker-password">
                                    </div>
                                </div>
                                <small class="form-text text-muted">For pulling images from private registries (stored as .dockerconfigjson)</small>
                            </div>
                            <div class="form-group">
                                <label>Labels</label>
                                <input type="hidden" id="secretLabel" name="label">
                                <div class="kv-container" id="secretLabelsContainer">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm kv-key" placeholder="Key">
                                        <input type="text" class="form-control form-control-sm kv-value" placeholder="Value">
                                        <a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="btn-add-kv" onclick="addKVPair('secretLabelsContainer')">
                                    <i class="fas fa-plus"></i> Add Label
                                </a>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="secretImmutable" name="immutable" value="true">
                                <label class="form-check-label small" for="secretImmutable">Immutable (cannot be modified after creation)</label>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-block mt-3" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-key mr-1"></i>Generate Secret
                    </button>
                </form>

            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-code mr-2"></i>Generated Kubernetes Manifest</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-dharmachakra fa-3x text-muted mb-3"></i>
                        <p class="text-muted mb-0">Configure your Kubernetes resource and click Generate</p>
                        <p class="text-muted small">Output will appear here in YAML and JSON format</p>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
                    <div id="output"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- kubectl Commands Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-dark text-white py-2">
        <h6 class="mb-0"><i class="fas fa-terminal mr-2"></i>kubectl Commands</h6>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Apply manifest</strong></p>
                <pre class="bg-light p-2 rounded small mb-2"><code>kubectl apply -f manifest.yaml</code></pre>
                <p class="small mb-1"><strong>Create deployment</strong></p>
                <pre class="bg-light p-2 rounded small mb-2"><code>kubectl create deployment nginx --image=nginx</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Expose as service</strong></p>
                <pre class="bg-light p-2 rounded small mb-2"><code>kubectl expose deployment nginx --port=80 --type=LoadBalancer</code></pre>
                <p class="small mb-1"><strong>Generate YAML (dry-run)</strong></p>
                <pre class="bg-light p-2 rounded small mb-2"><code>kubectl create deployment nginx --image=nginx --dry-run=client -o yaml</code></pre>
            </div>
        </div>
    </div>
</div>

<!-- Educational Content Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap mr-2"></i>Understanding Kubernetes Resources</h5>
    </div>
    <div class="card-body">
        <h6>What is Kubernetes?</h6>
        <p>Kubernetes (K8s) is an open-source container orchestration platform that automates deployment, scaling, and management of containerized applications. This tool helps you generate Kubernetes resource manifests in YAML or JSON format.</p>

        <h6 class="mt-4">Kubernetes Resource Types</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Resource</th>
                    <th>Purpose</th>
                    <th>Use Case</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Pod</strong></td>
                    <td>Smallest deployable unit</td>
                    <td>Single container instances, one-off tasks</td>
                </tr>
                <tr class="table-success">
                    <td><strong>Deployment</strong></td>
                    <td>Manages ReplicaSets and Pods</td>
                    <td>Stateless apps, rolling updates (recommended)</td>
                </tr>
                <tr>
                    <td><strong>Service</strong></td>
                    <td>Network access to pods</td>
                    <td>Load balancing, service discovery</td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">API Versions (Current Standard)</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Resource</th>
                    <th>API Version</th>
                    <th>Notes</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Pod</td>
                    <td><code>v1</code></td>
                    <td>Core API, stable</td>
                </tr>
                <tr>
                    <td>Deployment</td>
                    <td><code>apps/v1</code></td>
                    <td>Stable since K8s 1.9 (replaces apps/v1beta1)</td>
                </tr>
                <tr>
                    <td>Service</td>
                    <td><code>v1</code></td>
                    <td>Core API, stable</td>
                </tr>
                <tr>
                    <td>StatefulSet</td>
                    <td><code>apps/v1</code></td>
                    <td>For stateful applications</td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">Resource Limits Best Practices</h6>
        <ul class="small">
            <li><strong>Always set requests:</strong> Helps scheduler place pods efficiently</li>
            <li><strong>CPU units:</strong> 1 CPU = 1000m (millicores). Use 100m-500m for typical apps</li>
            <li><strong>Memory units:</strong> Mi (mebibytes), Gi (gibibytes). Use 128Mi-512Mi for typical apps</li>
            <li><strong>Limits vs Requests:</strong> Limits cap usage; requests guarantee minimum resources</li>
        </ul>

        <h6 class="mt-4">Service Types</h6>
        <ul class="small">
            <li><strong>ClusterIP:</strong> Internal cluster access only (default)</li>
            <li><strong>NodePort:</strong> Exposes on each node's IP at a static port (30000-32767)</li>
            <li><strong>LoadBalancer:</strong> Creates external load balancer (cloud providers)</li>
            <li><strong>ExternalName:</strong> Maps service to external DNS name (CNAME)</li>
        </ul>

        <h6 class="mt-4">Code Examples</h6>
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Python (kubernetes client)</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>from kubernetes import client, config
config.load_kube_config()
v1 = client.CoreV1Api()
pods = v1.list_namespaced_pod("default")</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Go (client-go)</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>clientset, _ := kubernetes.NewForConfig(config)
pods, _ := clientset.CoreV1().
    Pods("default").List(ctx, metav1.ListOptions{})</code></pre>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools mr-2"></i>Related Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="dc.jsp" class="related-tool-card">
                <h6><i class="fab fa-docker mr-1"></i>Docker Compose Generator</h6>
                <p>Generate docker-compose.yml files</p>
            </a>
            <a href="kube1.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt mr-1"></i>Compose to Kubernetes</h6>
                <p>Convert Docker Compose to K8s</p>
            </a>
            <a href="kube2.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt mr-1"></i>Kubernetes to Compose</h6>
                <p>Convert K8s manifests to Compose</p>
            </a>
            <a href="dc1.jsp" class="related-tool-card">
                <h6><i class="fas fa-terminal mr-1"></i>Docker Run to Compose</h6>
                <p>Convert docker run commands</p>
            </a>
            <a href="yamlparser.jsp" class="related-tool-card">
                <h6><i class="fas fa-code mr-1"></i>YAML Parser</h6>
                <p>Parse and validate YAML</p>
            </a>
            <a href="jsonparser.jsp" class="related-tool-card">
                <h6><i class="fas fa-code mr-1"></i>JSON Parser</h6>
                <p>Parse and format JSON</p>
            </a>
        </div>
    </div>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                <h5 class="modal-title">
                    <i class="fas fa-share-alt"></i> Share Kubernetes Manifest
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info mb-3">
                    <strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
                    <ul class="mb-0 mt-2">
                        <li><strong>All Form Fields:</strong> Pod/Deployment name, image, ports, labels, environment variables, and all other configuration</li>
                        <li><strong>Generated YAML/JSON:</strong> The Kubernetes manifest content</li>
                        <li><strong class="text-success">NOT Included:</strong> Your personal data or secrets</li>
                    </ul>
                </div>
                <div class="input-group mb-3">
                    <input type="text" class="form-control" id="shareUrlText" readonly>
                    <div class="input-group-append">
                        <button class="btn btn-success" id="copyShareUrl">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                    </div>
                </div>
                <p class="text-muted small mb-0">
                    <i class="fas fa-info-circle"></i> Anyone with this link can view and download the Kubernetes manifest.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<script>
var lastYaml = '';
var lastJson = '';

function showToast(message) {
    var toast = $('<div class="position-fixed" style="bottom: 20px; right: 20px; z-index: 9999;">' +
        '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
        '<i class="fas fa-info-circle mr-2"></i>' + message + '</div></div></div>');
    $('body').append(toast);
    setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
}

function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function copyToClipboard(text) {
    var textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);
    showToast('Copied to clipboard!');
}

function displayResult(response) {
    if (!response.success) {
        $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>' + escapeHtml(response.errorMessage || 'Error generating manifest') + '</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();
        showToast('Error: ' + (response.errorMessage || 'Unknown error'));
        return;
    }

    lastYaml = response.kubernetesYaml || '';
    lastJson = response.kubernetesJson || '';
    window.lastResourceType = response.resourceType || 'kubernetes';

    var html = '<div class="mb-3">' +
        '<div class="d-flex justify-content-between align-items-center mb-2">' +
        '<span class="badge" style="background: var(--theme-gradient); color: white;"><i class="fas fa-check-circle mr-1"></i>' + escapeHtml(response.resourceType || 'Resource') + ' Generated</span>' +
        '</div>';

    if (lastYaml) {
        html += '<div class="mb-3">' +
            '<div class="d-flex justify-content-between align-items-center mb-1">' +
            '<strong class="small">YAML</strong>' +
            '<button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard(lastYaml)"><i class="fas fa-copy mr-1"></i>Copy</button>' +
            '</div>' +
            '<pre class="hash-output" style="max-height: 300px; overflow-y: auto; font-size: 0.8rem;">' + escapeHtml(lastYaml) + '</pre>' +
            '</div>';
    }

    if (lastJson) {
        html += '<div class="mb-3">' +
            '<div class="d-flex justify-content-between align-items-center mb-1">' +
            '<strong class="small">JSON</strong>' +
            '<button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard(lastJson)"><i class="fas fa-copy mr-1"></i>Copy</button>' +
            '</div>' +
            '<pre class="hash-output" style="max-height: 300px; overflow-y: auto; font-size: 0.8rem;">' + escapeHtml(lastJson) + '</pre>' +
            '</div>';
    }

    // Add Download and Share buttons
    html += '<div class="d-flex mt-2" style="gap: 0.5rem;">' +
        '<button class="btn btn-sm" onclick="downloadYaml()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download mr-1"></i>Download YAML</button>' +
        '<button class="btn btn-sm" onclick="downloadJson()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download mr-1"></i>Download JSON</button>' +
        '<button class="btn btn-sm" onclick="shareUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt mr-1"></i>Share</button>' +
        '</div>';

    html += '</div>';

    $('#output').html(html);
    $('#resultPlaceholder').hide();
    $('#resultContent').show();
    showToast(response.resourceType + ' generated successfully!');
}

function downloadYaml() {
    if (!lastYaml || !lastYaml.trim()) {
        showToast('No YAML content to download');
        return;
    }
    var resourceType = (window.lastResourceType || 'kubernetes').toLowerCase().replace(/\s+/g, '-');
    var today = new Date();
    var dateStr = today.getFullYear() + '-' +
                 String(today.getMonth() + 1).padStart(2, '0') + '-' +
                 String(today.getDate()).padStart(2, '0');
    var filename = '8gwifi-' + resourceType + '-' + dateStr + '.yaml';

    var blob = new Blob([lastYaml], { type: 'text/yaml' });
    var url = window.URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
    showToast('Download started!');
}

function downloadJson() {
    if (!lastJson || !lastJson.trim()) {
        showToast('No JSON content to download');
        return;
    }
    var resourceType = (window.lastResourceType || 'kubernetes').toLowerCase().replace(/\s+/g, '-');
    var today = new Date();
    var dateStr = today.getFullYear() + '-' +
                 String(today.getMonth() + 1).padStart(2, '0') + '-' +
                 String(today.getDate()).padStart(2, '0');
    var filename = '8gwifi-' + resourceType + '-' + dateStr + '.json';

    var blob = new Blob([lastJson], { type: 'application/json' });
    var url = window.URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
    showToast('Download started!');
}

function shareUrl() {
    var formType = $('#selectkubeobject').val();
    var formData = { formType: formType };

    if (formType === '1') {
        // Pod/Deployment form
        formData.name = $('#name').val() || '';
        formData.namespace = $('#namespace').val() || '';
        formData.image = $('#image').val() || '';
        formData.containerName = $('#containerName').val() || '';
        formData.imagePullPolicy = $('#imagePullPolicy').val() || '';
        formData.restartPolicy = $('#restartPolicy').val() || '';
        formData.containerPorts = $('#containerPorts').val() || '';
        formData.deployment = $('#deployment').val() || '';
        formData.replicas = $('#replicas').val() || '';
        formData.cpuRequest = $('#cpuRequest').val() || '';
        formData.memoryRequest = $('#memoryRequest').val() || '';
        formData.cpuLimit = $('#cpuLimit').val() || '';
        formData.memoryLimit = $('#memoryLimit').val() || '';
        formData.containercommand = $('#containercommand').val() || '';
        formData.containerargs = $('#containerargs').val() || '';
        formData.livenessProbepath = $('#livenessProbepath').val() || '';
        formData.livenessProbeport = $('#livenessProbeport').val() || '';
        formData.livenessProbescheme = $('#livenessProbescheme').val() || '';
        formData.readinessProbepath = $('#readinessProbepath').val() || '';
        formData.readinessProbeport = $('#readinessProbeport').val() || '';
        formData.readinessProbescheme = $('#readinessProbescheme').val() || '';
        formData.volumeMounts = $('#volumeMounts').val() || '';
        formData.dnsPolicy = $('#dnsPolicy').val() || '';
        formData.serviceAccountName = $('#serviceAccountName').val() || '';
        formData.nodeName = $('#nodeName').val() || '';
        formData.runAsUser = $('#runAsUser').val() || '';
        formData.runAsGroup = $('#runAsGroup').val() || '';
        formData.fsGroup = $('#fsGroup').val() || '';
        formData.runAsNonRoot = $('#runAsNonRoot').val() || '';
        formData.apployonPod = $('#apployonPod').is(':checked') ? 'apployonPod' : '';

        // Collect KV pairs
        formData.labelPairs = [];
        $('#labelsContainer .kv-pair').each(function() {
            var key = $(this).find('.kv-key').val().trim();
            var value = $(this).find('.kv-value').val().trim();
            if (key || value) formData.labelPairs.push({key: key, value: value});
        });
        formData.annotationPairs = [];
        $('#annotationsContainer .kv-pair').each(function() {
            var key = $(this).find('.kv-key').val().trim();
            var value = $(this).find('.kv-value').val().trim();
            if (key || value) formData.annotationPairs.push({key: key, value: value});
        });
        formData.envPairs = [];
        $('#envContainer .kv-pair').each(function() {
            var key = $(this).find('.kv-key').val().trim();
            var value = $(this).find('.kv-value').val().trim();
            if (key || value) formData.envPairs.push({key: key, value: value});
        });
    } else {
        // Service form
        formData.svcName = $('#svcName').val() || '';
        formData.svcNamespace = $('#svcNamespace').val() || '';
        formData.type = $('#type').val() || '';
        formData.portname = $('#portname').val() || '';
        formData.port = $('#port').val() || '';
        formData.targetPort = $('#targetPort').val() || '';
        formData.protocol = $('#protocol').val() || '';
        formData.nodePort = $('#nodePort').val() || '';
        formData.clusterIP = $('#clusterIP').val() || '';
        formData.loadBalancerIP = $('#loadBalancerIP').val() || '';
        formData.externalName = $('#externalName').val() || '';
        formData.externalIPs = $('#externalIPs').val() || '';
        formData.sessionAffinity = $('#sessionAffinity').val() || '';

        formData.svcLabelPairs = [];
        $('#svcLabelsContainer .kv-pair').each(function() {
            var key = $(this).find('.kv-key').val().trim();
            var value = $(this).find('.kv-value').val().trim();
            if (key || value) formData.svcLabelPairs.push({key: key, value: value});
        });
    }

    // Include generated content
    if (lastYaml) formData.kubernetesYaml = lastYaml;
    if (lastJson) formData.kubernetesJson = lastJson;
    if (window.lastResourceType) formData.resourceType = window.lastResourceType;

    try {
        var jsonData = JSON.stringify(formData);
        var base64Encoded = btoa(unescape(encodeURIComponent(jsonData)));
        var urlEncoded = encodeURIComponent(base64Encoded);
        var shareUrlValue = window.location.origin + window.location.pathname + '?data=' + urlEncoded;

        $('#shareUrlText').val(shareUrlValue);
        $('#shareUrlModal').modal('show');
    } catch (e) {
        showToast('Error generating share URL: ' + e.message);
    }
}

function loadFromUrl() {
    var urlParams = new URLSearchParams(window.location.search);
    var dataParam = urlParams.get('data');

    if (!dataParam) return;

    try {
        var base64Decoded = decodeURIComponent(dataParam);
        var jsonData = decodeURIComponent(escape(atob(base64Decoded)));
        var formData = JSON.parse(jsonData);

        // Set form type
        if (formData.formType) {
            $('#selectkubeobject').val(formData.formType).trigger('change');
        }

        if (formData.formType === '1') {
            // Populate Pod/Deployment form
            if (formData.name) $('#name').val(formData.name);
            if (formData.namespace) $('#namespace').val(formData.namespace);
            if (formData.image) $('#image').val(formData.image);
            if (formData.containerName) $('#containerName').val(formData.containerName);
            if (formData.imagePullPolicy) $('#imagePullPolicy').val(formData.imagePullPolicy);
            if (formData.restartPolicy) $('#restartPolicy').val(formData.restartPolicy);
            if (formData.containerPorts) $('#containerPorts').val(formData.containerPorts);
            if (formData.deployment) $('#deployment').val(formData.deployment);
            if (formData.replicas) $('#replicas').val(formData.replicas);
            if (formData.cpuRequest) $('#cpuRequest').val(formData.cpuRequest);
            if (formData.memoryRequest) $('#memoryRequest').val(formData.memoryRequest);
            if (formData.cpuLimit) $('#cpuLimit').val(formData.cpuLimit);
            if (formData.memoryLimit) $('#memoryLimit').val(formData.memoryLimit);
            if (formData.containercommand) $('#containercommand').val(formData.containercommand);
            if (formData.containerargs) $('#containerargs').val(formData.containerargs);
            if (formData.livenessProbepath) $('#livenessProbepath').val(formData.livenessProbepath);
            if (formData.livenessProbeport) $('#livenessProbeport').val(formData.livenessProbeport);
            if (formData.livenessProbescheme) $('#livenessProbescheme').val(formData.livenessProbescheme);
            if (formData.readinessProbepath) $('#readinessProbepath').val(formData.readinessProbepath);
            if (formData.readinessProbeport) $('#readinessProbeport').val(formData.readinessProbeport);
            if (formData.readinessProbescheme) $('#readinessProbescheme').val(formData.readinessProbescheme);
            if (formData.volumeMounts) $('#volumeMounts').val(formData.volumeMounts);
            if (formData.dnsPolicy) $('#dnsPolicy').val(formData.dnsPolicy);
            if (formData.serviceAccountName) $('#serviceAccountName').val(formData.serviceAccountName);
            if (formData.nodeName) $('#nodeName').val(formData.nodeName);
            if (formData.runAsUser) $('#runAsUser').val(formData.runAsUser);
            if (formData.runAsGroup) $('#runAsGroup').val(formData.runAsGroup);
            if (formData.fsGroup) $('#fsGroup').val(formData.fsGroup);
            if (formData.runAsNonRoot) $('#runAsNonRoot').val(formData.runAsNonRoot);
            if (formData.apployonPod === 'apployonPod') $('#apployonPod').prop('checked', true);

            // Restore KV pairs
            if (formData.labelPairs && formData.labelPairs.length > 0) {
                $('#labelsContainer').empty();
                formData.labelPairs.forEach(function(pair) {
                    addKVPair('labelsContainer');
                    var lastPair = $('#labelsContainer .kv-pair').last();
                    lastPair.find('.kv-key').val(pair.key || '');
                    lastPair.find('.kv-value').val(pair.value || '');
                });
            }
            if (formData.annotationPairs && formData.annotationPairs.length > 0) {
                $('#annotationsContainer').empty();
                formData.annotationPairs.forEach(function(pair) {
                    addKVPair('annotationsContainer');
                    var lastPair = $('#annotationsContainer .kv-pair').last();
                    lastPair.find('.kv-key').val(pair.key || '');
                    lastPair.find('.kv-value').val(pair.value || '');
                });
            }
            if (formData.envPairs && formData.envPairs.length > 0) {
                $('#envContainer').empty();
                formData.envPairs.forEach(function(pair) {
                    addKVPair('envContainer');
                    var lastPair = $('#envContainer .kv-pair').last();
                    lastPair.find('.kv-key').val(pair.key || '');
                    lastPair.find('.kv-value').val(pair.value || '');
                });
            }
        } else {
            // Populate Service form
            if (formData.svcName) $('#svcName').val(formData.svcName);
            if (formData.svcNamespace) $('#svcNamespace').val(formData.svcNamespace);
            if (formData.type) $('#type').val(formData.type).trigger('change');
            if (formData.portname) $('#portname').val(formData.portname);
            if (formData.port) $('#port').val(formData.port);
            if (formData.targetPort) $('#targetPort').val(formData.targetPort);
            if (formData.protocol) $('#protocol').val(formData.protocol);
            if (formData.nodePort) $('#nodePort').val(formData.nodePort);
            if (formData.clusterIP) $('#clusterIP').val(formData.clusterIP);
            if (formData.loadBalancerIP) $('#loadBalancerIP').val(formData.loadBalancerIP);
            if (formData.externalName) $('#externalName').val(formData.externalName);
            if (formData.externalIPs) $('#externalIPs').val(formData.externalIPs);
            if (formData.sessionAffinity) $('#sessionAffinity').val(formData.sessionAffinity);

            if (formData.svcLabelPairs && formData.svcLabelPairs.length > 0) {
                $('#svcLabelsContainer').empty();
                formData.svcLabelPairs.forEach(function(pair) {
                    addKVPair('svcLabelsContainer');
                    var lastPair = $('#svcLabelsContainer .kv-pair').last();
                    lastPair.find('.kv-key').val(pair.key || '');
                    lastPair.find('.kv-value').val(pair.value || '');
                });
            }
        }

        // Display generated content if available
        if (formData.kubernetesYaml || formData.kubernetesJson) {
            lastYaml = formData.kubernetesYaml || '';
            lastJson = formData.kubernetesJson || '';
            window.lastResourceType = formData.resourceType || 'Kubernetes';

            var html = '<div class="mb-3">' +
                '<div class="d-flex justify-content-between align-items-center mb-2">' +
                '<span class="badge" style="background: var(--theme-gradient); color: white;"><i class="fas fa-link mr-1"></i>' + escapeHtml(formData.resourceType || 'Resource') + ' (from shared link)</span>' +
                '</div>';

            if (lastYaml) {
                html += '<div class="mb-3">' +
                    '<div class="d-flex justify-content-between align-items-center mb-1">' +
                    '<strong class="small">YAML</strong>' +
                    '<button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard(lastYaml)"><i class="fas fa-copy mr-1"></i>Copy</button>' +
                    '</div>' +
                    '<pre class="hash-output" style="max-height: 300px; overflow-y: auto; font-size: 0.8rem;">' + escapeHtml(lastYaml) + '</pre>' +
                    '</div>';
            }

            if (lastJson) {
                html += '<div class="mb-3">' +
                    '<div class="d-flex justify-content-between align-items-center mb-1">' +
                    '<strong class="small">JSON</strong>' +
                    '<button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard(lastJson)"><i class="fas fa-copy mr-1"></i>Copy</button>' +
                    '</div>' +
                    '<pre class="hash-output" style="max-height: 300px; overflow-y: auto; font-size: 0.8rem;">' + escapeHtml(lastJson) + '</pre>' +
                    '</div>';
            }

            html += '<div class="d-flex mt-2" style="gap: 0.5rem;">' +
                '<button class="btn btn-sm" onclick="downloadYaml()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download mr-1"></i>Download YAML</button>' +
                '<button class="btn btn-sm" onclick="downloadJson()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download mr-1"></i>Download JSON</button>' +
                '<button class="btn btn-sm" onclick="shareUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt mr-1"></i>Share</button>' +
                '</div></div>';

            $('#output').html(html);
            $('#resultPlaceholder').hide();
            $('#resultContent').show();
        }

        showToast('Configuration loaded from shared link!');
    } catch (e) {
        console.error('Error loading from URL:', e);
    }
}

// KV Pair Management Functions
function collectKVPairs(containerId) {
    var pairs = [];
    $('#' + containerId + ' .kv-pair').each(function() {
        var key = $(this).find('.kv-key').val().trim();
        var value = $(this).find('.kv-value').val().trim();
        if (key && value) {
            pairs.push(key + '=' + value);
        }
    });
    return pairs.join(',');
}

function addKVPair(containerId) {
    var newPair = '<div class="kv-pair">' +
        '<input type="text" class="form-control form-control-sm kv-key" placeholder="Key">' +
        '<input type="text" class="form-control form-control-sm kv-value" placeholder="Value">' +
        '<a href="javascript:void(0)" class="btn-remove-kv" onclick="removeKVPair(this)" title="Remove"><i class="fas fa-times"></i></a>' +
        '</div>';
    $('#' + containerId).append(newPair);
}

function removeKVPair(el) {
    var $el = $(el);
    var $container = $el.closest('.kv-container');
    var $pairs = $container.find('.kv-pair');
    if ($pairs.length > 1) {
        $el.closest('.kv-pair').remove();
    } else {
        // Clear the values instead of removing the last pair
        $el.closest('.kv-pair').find('input').val('');
    }
}

function updateHiddenKVFields() {
    $('#label').val(collectKVPairs('labelsContainer'));
    $('#annotation').val(collectKVPairs('annotationsContainer'));
    $('#environment').val(collectKVPairs('envContainer'));
}

$(document).ready(function() {
    // Load from URL on page load
    loadFromUrl();

    // Copy share URL button handler
    $('#copyShareUrl').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        var shareUrlText = $('#shareUrlText').val();
        if (shareUrlText) {
            copyToClipboard(shareUrlText);
        }
    });

    // Custom collapse handler - avoids Bootstrap's data-toggle issues
    $('.form-section-title').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        var target = $(this).data('section');
        if (target) {
            var $target = $(target);
            var isExpanded = $(this).attr('aria-expanded') === 'true';
            if (isExpanded) {
                $target.removeClass('show');
                $(this).attr('aria-expanded', 'false');
            } else {
                $target.addClass('show');
                $(this).attr('aria-expanded', 'true');
            }
        }
    });

    // Toggle between different Kubernetes resource forms
    $('#selectkubeobject').on('change', function(e) {
        e.stopPropagation();
        var val = $(this).val();
        // Hide all forms first
        $('#form, #service, #statefulsetForm, #jobForm, #cronjobForm, #configmapForm, #secretForm').hide();
        // Show the selected form
        switch(val) {
            case '1': $('#form').show(); break;
            case '2': $('#service').show(); break;
            case '3': $('#statefulsetForm').show(); break;
            case '4': $('#jobForm').show(); break;
            case '5': $('#cronjobForm').show(); break;
            case '6': $('#configmapForm').show(); break;
            case '7': $('#secretForm').show(); break;
        }
    });

    // Secret type change handler
    $('#secretType').on('change', function(e) {
        e.stopPropagation();
        var secretType = $(this).val();
        // Hide all secret type fields
        $('.secret-type-field').hide();
        // Show relevant field based on type
        switch(secretType) {
            case 'Opaque':
                $('#secretOpaqueFields').show();
                break;
            case 'kubernetes.io/basic-auth':
                $('#secretBasicAuthFields').show();
                break;
            case 'kubernetes.io/ssh-auth':
                $('#secretSSHFields').show();
                break;
            case 'kubernetes.io/tls':
                $('#secretTLSFields').show();
                break;
            case 'kubernetes.io/dockerconfigjson':
                $('#secretDockerFields').show();
                break;
        }
    });

    // Service type change handler
    $('#type').on('change', function(e) {
        e.stopPropagation();
        var type = $(this).val();
        if (type === 'NodePort' || type === 'LoadBalancer') {
            $('#nodePortRow').show();
        } else {
            $('#nodePortRow').hide();
        }
        if (type === 'LoadBalancer') {
            $('#loadBalancerIPField').show();
        } else {
            $('#loadBalancerIPField').hide();
        }
        if (type === 'ExternalName') {
            $('#externalNameField').show();
            $('#clusterIPField').hide();
            $('#servicePorts').closest('.form-section').hide();
        } else {
            $('#externalNameField').hide();
            $('#clusterIPField').show();
            $('#servicePorts').closest('.form-section').show();
        }
    });

    // Generate Pod
    $('#generatePod').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $('#deployment').val('pod');
        submitPodForm();
    });

    // Generate Deployment
    $('#generateDeployment').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $('#deployment').val('deployment');
        submitPodForm();
    });

    function submitPodForm() {
        // Collect all KV pairs into hidden fields before submission
        updateHiddenKVFields();

        $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x mb-2" style="color: var(--theme-primary);"></i><p class="text-muted">Generating Kubernetes manifest...</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();

        $.ajax({
            type: "POST",
            url: "KubeFunctionality",
            data: $("#form").serialize(),
            dataType: "json",
            success: function(response) {
                displayResult(response);
            },
            error: function(xhr, status, error) {
                $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>Error generating manifest. Please try again.</p></div>');
                showToast('Error: ' + error);
            }
        });
    }

    // Service form submission
    $('#service').on('submit', function(event) {
        event.preventDefault();
        event.stopPropagation();

        // Collect service selector labels
        $('#svcLabel').val(collectKVPairs('svcLabelsContainer'));

        $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x mb-2" style="color: var(--theme-primary);"></i><p class="text-muted">Generating Kubernetes Service...</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();

        $.ajax({
            type: "POST",
            url: "KubeFunctionality",
            data: $("#service").serialize(),
            dataType: "json",
            success: function(response) {
                displayResult(response);
            },
            error: function(xhr, status, error) {
                $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>Error generating service. Please try again.</p></div>');
                showToast('Error: ' + error);
            }
        });
    });

    // StatefulSet form submission
    $('#statefulsetForm').on('submit', function(event) {
        event.preventDefault();
        event.stopPropagation();

        // Collect KV pairs
        $('#ssLabel').val(collectKVPairs('ssLabelsContainer'));
        $('#ssEnvironment').val(collectKVPairs('ssEnvContainer'));

        $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x mb-2" style="color: var(--theme-primary);"></i><p class="text-muted">Generating StatefulSet...</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();

        $.ajax({
            type: "POST",
            url: "KubeFunctionality",
            data: $("#statefulsetForm").serialize(),
            dataType: "json",
            success: function(response) {
                displayResult(response);
            },
            error: function(xhr, status, error) {
                $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>Error generating StatefulSet. Please try again.</p></div>');
                showToast('Error: ' + error);
            }
        });
    });

    // Job form submission
    $('#jobForm').on('submit', function(event) {
        event.preventDefault();
        event.stopPropagation();

        // Collect KV pairs
        $('#jobLabel').val(collectKVPairs('jobLabelsContainer'));
        $('#jobEnvironment').val(collectKVPairs('jobEnvContainer'));

        $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x mb-2" style="color: var(--theme-primary);"></i><p class="text-muted">Generating Job...</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();

        $.ajax({
            type: "POST",
            url: "KubeFunctionality",
            data: $("#jobForm").serialize(),
            dataType: "json",
            success: function(response) {
                displayResult(response);
            },
            error: function(xhr, status, error) {
                $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>Error generating Job. Please try again.</p></div>');
                showToast('Error: ' + error);
            }
        });
    });

    // CronJob form submission
    $('#cronjobForm').on('submit', function(event) {
        event.preventDefault();
        event.stopPropagation();

        // Collect KV pairs
        $('#cronjobLabel').val(collectKVPairs('cronjobLabelsContainer'));
        $('#cronjobEnvironment').val(collectKVPairs('cronjobEnvContainer'));

        $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x mb-2" style="color: var(--theme-primary);"></i><p class="text-muted">Generating CronJob...</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();

        $.ajax({
            type: "POST",
            url: "KubeFunctionality",
            data: $("#cronjobForm").serialize(),
            dataType: "json",
            success: function(response) {
                displayResult(response);
            },
            error: function(xhr, status, error) {
                $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>Error generating CronJob. Please try again.</p></div>');
                showToast('Error: ' + error);
            }
        });
    });

    // ConfigMap form submission
    $('#configmapForm').on('submit', function(event) {
        event.preventDefault();
        event.stopPropagation();

        // Collect KV pairs
        $('#configmapData').val(collectKVPairs('configmapDataContainer'));
        $('#configmapLabel').val(collectKVPairs('configmapLabelsContainer'));

        $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x mb-2" style="color: var(--theme-primary);"></i><p class="text-muted">Generating ConfigMap...</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();

        $.ajax({
            type: "POST",
            url: "KubeFunctionality",
            data: $("#configmapForm").serialize(),
            dataType: "json",
            success: function(response) {
                displayResult(response);
            },
            error: function(xhr, status, error) {
                $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>Error generating ConfigMap. Please try again.</p></div>');
                showToast('Error: ' + error);
            }
        });
    });

    // Secret form submission
    $('#secretForm').on('submit', function(event) {
        event.preventDefault();
        event.stopPropagation();

        // Collect labels
        $('#secretLabel').val(collectKVPairs('secretLabelsContainer'));

        // Build data based on secret type
        var secretType = $('#secretType').val();
        var secretData = '';

        switch(secretType) {
            case 'Opaque':
                // Generic KV pairs
                secretData = collectKVPairs('secretDataContainer');
                break;
            case 'kubernetes.io/basic-auth':
                // Basic auth: username and password
                var username = $('#secretBasicUsername').val().trim();
                var password = $('#secretBasicPassword').val().trim();
                if (username) secretData += 'username=' + username;
                if (password) secretData += (secretData ? ',' : '') + 'password=' + password;
                break;
            case 'kubernetes.io/ssh-auth':
                // SSH auth: ssh-privatekey
                var sshKey = $('#secretSSHKey').val().trim();
                if (sshKey) secretData = 'ssh-privatekey=' + sshKey;
                break;
            case 'kubernetes.io/tls':
                // TLS: tls.crt and tls.key
                var tlsCert = $('#secretTLSCert').val().trim();
                var tlsKey = $('#secretTLSKey').val().trim();
                if (tlsCert) secretData += 'tls.crt=' + tlsCert;
                if (tlsKey) secretData += (secretData ? ',' : '') + 'tls.key=' + tlsKey;
                break;
            case 'kubernetes.io/dockerconfigjson':
                // Docker registry: build dockerconfigjson structure
                var server = $('#secretDockerServer').val().trim() || 'https://index.docker.io/v1/';
                var email = $('#secretDockerEmail').val().trim();
                var dockerUser = $('#secretDockerUsername').val().trim();
                var dockerPass = $('#secretDockerPassword').val().trim();
                // Build the docker config JSON
                var dockerConfig = {
                    auths: {}
                };
                dockerConfig.auths[server] = {
                    username: dockerUser,
                    password: dockerPass,
                    email: email,
                    auth: btoa(dockerUser + ':' + dockerPass)
                };
                secretData = '.dockerconfigjson=' + JSON.stringify(dockerConfig);
                break;
        }

        $('#secretData').val(secretData);

        $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x mb-2" style="color: var(--theme-primary);"></i><p class="text-muted">Generating Secret...</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();

        $.ajax({
            type: "POST",
            url: "KubeFunctionality",
            data: $("#secretForm").serialize(),
            dataType: "json",
            success: function(response) {
                displayResult(response);
            },
            error: function(xhr, status, error) {
                $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>Error generating Secret. Please try again.</p></div>');
                showToast('Error: ' + error);
            }
        });
    });
});
</script>
</div>
<%@ include file="body-close.jsp"%>

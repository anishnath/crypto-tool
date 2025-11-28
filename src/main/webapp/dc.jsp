<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Docker Compose Generator Online – Free | 8gwifi.org</title>
    <meta name="description" content="Free online Docker Compose file generator. Generate docker-compose.yml files with version 3 syntax. Configure services, volumes, networks, environment variables, and more.">
    <meta name="keywords" content="docker compose generator, docker-compose.yml generator, docker compose file generator, generate docker compose online, docker compose v3, docker compose yaml generator, docker compose config generator">
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/dc.jsp" />

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
{
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Docker Compose Generator",
        "description": "Free online tool to generate Docker Compose YAML files with version 3 syntax. Configure services, volumes, networks, environment variables, ports, and resource limits.",
        "url": "https://8gwifi.org/dc.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
        "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
        "datePublished": "2020-02-26",
        "dateModified": "2025-01-28"
}
</script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "What is Docker Compose?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Docker Compose is a tool for defining and running multi-container Docker applications. You use a YAML file (docker-compose.yml) to configure your application's services, networks, and volumes, then run a single command to create and start all services."
            }
        },{
            "@type": "Question",
            "name": "What version of Docker Compose does this generator use?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "This generator creates Docker Compose files using version 3 syntax, which is compatible with Docker Swarm mode and provides advanced features like resource limits, placement constraints, and service scaling."
            }
        },{
            "@type": "Question",
            "name": "How do I use the generated docker-compose.yml file?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Save the generated YAML content to a file named 'docker-compose.yml' in your project directory. Then run 'docker-compose up' to start all services, or 'docker-compose up -d' to run in detached mode."
            }
        },{
            "@type": "Question",
            "name": "What is the difference between expose and ports in Docker Compose?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The 'expose' directive exposes ports to other services on the same network but not to the host machine. The 'ports' directive maps container ports to host ports, making them accessible from outside the container."
            }
        },{
            "@type": "Question",
            "name": "What is depends_on in Docker Compose?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The 'depends_on' directive specifies service dependencies, ensuring that dependent services start before the service that depends on them. However, it doesn't wait for the service to be 'ready' - only for it to start."
            }
        }]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #8b5cf6;
            --theme-secondary: #7c3aed;
            --theme-gradient: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
            --theme-light: #faf5ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(139, 92, 246, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(139, 92, 246, 0.25);
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
            box-shadow: 0 2px 8px rgba(139, 92, 246, 0.2);
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
        .kv-pair {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            align-items: center;
        }
        .kv-pair input {
            flex: 1;
        }
        .kv-pair .btn-remove {
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .kv-pair .btn-remove:hover {
            background: #c82333;
        }
        .btn-add-kv {
            padding: 0.25rem 0.75rem;
            font-size: 0.8rem;
            background: var(--theme-primary);
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 0.25rem;
        }
        .btn-add-kv:hover {
            background: var(--theme-secondary);
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">Docker Compose Generator</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fab fa-docker"></i> Docker Compose v3</span>
            <span class="info-badge"><i class="fas fa-code"></i> YAML Generator</span>
            <span class="info-badge"><i class="fas fa-server"></i> Multi-Container</span>
        </div>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-user-check"></i>
        <span>Anish Nath</span>
    </div>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-cogs me-2"></i>Docker Compose Configuration</h5>
            </div>
            <div class="card-body">
<form id="form" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="GENERATE_DC">

                    <!-- Basic Service Configuration -->
                    <div class="form-section">
                        <div class="form-section-title" data-toggle="collapse" data-target="#serviceConfig" aria-expanded="true">
                            <span><i class="fas fa-server me-1"></i>Service Configuration</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="serviceConfig" class="form-section-content collapse show">
    <div class="form-row">
                                <div class="form-group col-md-12 mb-2">
            <label for="serviceName">Service Name</label>
                                    <input type="text" class="form-control form-control-sm" name="serviceName" id="serviceName" placeholder="web">
        </div>
    </div>
    <div class="form-row">
                                <div class="form-group col-md-6 mb-2">
            <label for="image">Docker Image</label>
                                    <input type="text" class="form-control form-control-sm" id="image" name="image" placeholder="nginx:latest">
        </div>
                                <div class="form-group col-md-6 mb-2">
                                    <label for="container_name">Container Name</label>
                                    <input type="text" class="form-control form-control-sm" id="container_name" name="container_name" placeholder="nginx-container">
        </div>
    </div>
                        </div>
                    </div>

                    <!-- Entrypoint and Volumes -->
                    <div class="form-section">
                        <div class="form-section-title" data-toggle="collapse" data-target="#entrypointVolumes" aria-expanded="false">
                            <span><i class="fas fa-terminal me-1"></i>Entrypoint & Volumes</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="entrypointVolumes" class="form-section-content collapse">
                            <div class="form-group mb-2">
            <label for="entrypoint">Entrypoint</label>
                                <input type="text" class="form-control form-control-sm" id="entrypoint" name="entrypoint" placeholder="/code/entrypoint.sh">
                            </div>
                            <div class="form-group mb-2">
                                <label for="volumes">Volumes</label>
                                <input type="text" class="form-control form-control-sm" name="volumes" id="volumes" placeholder="db-data:/var/lib/data,www-data:/var/www">
                                <small class="text-muted" style="font-size: 0.7rem;">Format: name:path,name:path</small>
                            </div>
        </div>
    </div>

                    <!-- Environment and Labels -->
                    <div class="form-section">
                        <div class="form-section-title" data-toggle="collapse" data-target="#envLabels" aria-expanded="false">
                            <span><i class="fas fa-tags me-1"></i>Environment & Labels</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="envLabels" class="form-section-content collapse">
                            <div class="form-group mb-2">
                                <label>Environment Variables</label>
                                <div id="envPairs">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm env-key" placeholder="KEY">
                                        <input type="text" class="form-control form-control-sm env-value" placeholder="value">
                                        <button type="button" class="btn-remove" onclick="removeKVPair(this, 'env')"><i class="fas fa-times"></i></button>
                                    </div>
                                </div>
                                <button type="button" class="btn-add-kv" onclick="addKVPair('env')"><i class="fas fa-plus me-1"></i>Add Environment Variable</button>
                                <input type="hidden" id="environment" name="environment">
                            </div>
                            <div class="form-group mb-2">
                                <label>Labels</label>
                                <div id="labelPairs">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm label-key" placeholder="key">
                                        <input type="text" class="form-control form-control-sm label-value" placeholder="value">
                                        <button type="button" class="btn-remove" onclick="removeKVPair(this, 'label')"><i class="fas fa-times"></i></button>
                                    </div>
                                </div>
                                <button type="button" class="btn-add-kv" onclick="addKVPair('label')"><i class="fas fa-plus me-1"></i>Add Label</button>
                                <input type="hidden" id="labels" name="labels">
                            </div>
        </div>
    </div>

                    <!-- Networking -->
                    <div class="form-section">
                        <div class="form-section-title" data-toggle="collapse" data-target="#networking" aria-expanded="false">
                            <span><i class="fas fa-network-wired me-1"></i>Networking</span>
                            <i class="fas fa-chevron-down"></i>
        </div>
                        <div id="networking" class="form-section-content collapse">
                            <div class="form-group mb-2">
                                <label>Port Mappings</label>
                                <small class="text-muted d-block" style="font-size: 0.7rem; margin-bottom: 0.25rem;">Map host ports to container ports</small>
                                <div id="portPairs">
                                    <div class="kv-pair">
                                        <input type="text" class="form-control form-control-sm port-host" placeholder="Host Port">
                                        <input type="text" class="form-control form-control-sm port-container" placeholder="Container Port">
                                        <button type="button" class="btn-remove" onclick="removeKVPair(this, 'port')"><i class="fas fa-times"></i></button>
        </div>
    </div>
                                <button type="button" class="btn-add-kv" onclick="addKVPair('port')"><i class="fas fa-plus me-1"></i>Add Port Mapping</button>
                                <input type="hidden" id="ports" name="ports">
                            </div>
                            <div class="form-group mb-2">
                                <label for="expose">Expose Ports</label>
            <input type="text" class="form-control form-control-sm" name="expose" id="expose" placeholder="80,443">
                                <small class="text-muted" style="font-size: 0.7rem;">Internal only (comma-separated)</small>
        </div>
    <div class="form-row">
                                <div class="form-group col-md-6 mb-2">
                                    <label for="dns">DNS Servers</label>
                                    <input type="text" class="form-control form-control-sm" name="dns" id="dns" placeholder="8.8.8.8,9.9.9.9">
                                    <small class="text-muted" style="font-size: 0.7rem;">Comma-separated IPs</small>
                                </div>
                                <div class="form-group col-md-6 mb-2">
                                    <label for="dns_search">DNS Search</label>
                                    <input type="text" class="form-control form-control-sm" id="dns_search" name="dns_search" placeholder="example.com">
                                    <small class="text-muted" style="font-size: 0.7rem;">Comma-separated domains</small>
                                </div>
        </div>
        </div>
    </div>

                    <!-- Container Settings -->
                    <div class="form-section">
                        <div class="form-section-title" data-toggle="collapse" data-target="#containerSettings" aria-expanded="false">
                            <span><i class="fas fa-cog me-1"></i>Container Settings</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="containerSettings" class="form-section-content collapse">
    <div class="form-row">
                                <div class="form-group col-md-6 mb-2">
                                    <label for="user">User</label>
            <input type="text" class="form-control form-control-sm" name="user" id="user" placeholder="1000">
        </div>
                                <div class="form-group col-md-6 mb-2">
                                    <label for="working_dir">Working Dir</label>
                                    <input type="text" class="form-control form-control-sm" id="working_dir" name="working_dir" placeholder="/app">
        </div>
        </div>
                            <div class="form-row">
                                <div class="form-group col-md-6 mb-2">
                                    <label for="hostname">Hostname</label>
                                    <input type="text" class="form-control form-control-sm" id="hostname" name="hostname" placeholder="my-container">
        </div>
                                <div class="form-group col-md-6 mb-2">
                                    <label for="domainname">Domain</label>
                                    <input type="text" class="form-control form-control-sm" id="domainname" name="domainname" placeholder="example.com">
    </div>
    </div>
    <div class="form-row">
                                <div class="form-group col-md-4 mb-2">
                                    <label for="ipc">IPC Mode</label>
            <input type="text" class="form-control form-control-sm" name="ipc" id="ipc" placeholder="host">
        </div>
                                <div class="form-group col-md-4 mb-2">
                                    <label for="mac_address">MAC Address</label>
                                    <input type="text" class="form-control form-control-sm" name="mac_address" id="mac_address" placeholder="02:42:ac:11:00:02">
        </div>
                                <div class="form-group col-md-4 mb-2">
                                    <label for="privileged">Privileged</label>
                                    <select class="form-control form-control-sm" name="privileged" id="privileged">
                                        <option value="false" selected>false</option>
                <option value="true">true</option>
            </select>
        </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-12 mb-2">
                                    <label for="restart_policy">Restart Policy</label>
                                    <select class="form-control form-control-sm" name="restart_policy" id="restart_policy">
                                        <option value="no" selected>no</option>
                                        <option value="always">always</option>
                <option value="on-failure">on-failure</option>
                                        <option value="unless-stopped">unless-stopped</option>
            </select>
                                </div>
                            </div>
        </div>
    </div>

                    <!-- Dependencies -->
                    <div class="form-section">
                        <div class="form-section-title" data-toggle="collapse" data-target="#dependencies" aria-expanded="false">
                            <span><i class="fas fa-link me-1"></i>Dependencies</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="dependencies" class="form-section-content collapse">
    <div class="form-row">
                                <div class="form-group col-md-6 mb-2">
                                    <label for="links">Links</label>
                                    <input type="text" class="form-control form-control-sm" id="links" name="links" placeholder="db,redis">
                                    <small class="text-muted" style="font-size: 0.7rem;">Link containers</small>
        </div>
                                <div class="form-group col-md-6 mb-2">
                                    <label for="depends_on">Depends On</label>
                                    <input type="text" class="form-control form-control-sm" id="depends_on" name="depends_on" placeholder="db,redis">
                                    <small class="text-muted" style="font-size: 0.7rem;">Service deps</small>
        </div>
        </div>
        </div>
    </div>

                    <!-- Resource Limits -->
                    <div class="form-section">
                        <div class="form-section-title" data-toggle="collapse" data-target="#resources" aria-expanded="false">
                            <span><i class="fas fa-tachometer-alt me-1"></i>Resource Limits</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="resources" class="form-section-content collapse">
    <div class="form-row">
                                <div class="form-group col-md-6 mb-2">
                                    <label for="cpus">CPU Limit</label>
            <input type="text" class="form-control form-control-sm" name="cpus" id="cpus" placeholder="0.50">
        </div>
                                <div class="form-group col-md-6 mb-2">
                                    <label for="memory">Memory Limit</label>
                                    <input type="text" class="form-control form-control-sm" id="memory" name="memory" placeholder="512M">
        </div>
        </div>
                            <div class="form-row">
                                <div class="form-group col-md-6 mb-2">
                                    <label for="rcpus">CPU Reservation</label>
            <input type="text" class="form-control form-control-sm" id="rcpus" name="rcpus" placeholder="0.25">
        </div>
                                <div class="form-group col-md-6 mb-2">
                                    <label for="rmemory">Memory Reservation</label>
                                    <input type="text" class="form-control form-control-sm" id="rmemory" name="rmemory" placeholder="256M">
        </div>
    </div>
                        </div>
        </div>

                    <!-- Advanced -->
                    <div class="form-section">
                        <div class="form-section-title" data-toggle="collapse" data-target="#advanced" aria-expanded="false">
                            <span><i class="fas fa-sliders-h me-1"></i>Advanced</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="advanced" class="form-section-content collapse">
                            <div class="form-group mb-2">
                                <label for="constraints">Placement Constraints</label>
                                <input type="text" class="form-control form-control-sm" name="constraints" id="constraints" placeholder="node.role == manager">
                                <small class="text-muted" style="font-size: 0.7rem;">Swarm constraints</small>
                            </div>
                            <div class="form-check">
            <input class="form-check-input" type="checkbox" value="healthcheck" name="healthcheck" id="healthcheck">
                                <label class="form-check-label" for="healthcheck" style="font-size: 0.85rem;">
                                    Add Health Check
                                </label>
        </div>
                        </div>
    </div>

                    <button type="button" class="btn w-100 mt-2" id="generatedc" style="background: var(--theme-gradient); color: white; font-weight: 600; padding: 0.5rem;">
                        <i class="fas fa-magic me-2"></i>Generate docker-compose.yml
                    </button>
</form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-file-code me-2"></i>Generated Docker Compose File</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-arrow-left fa-2x text-muted mb-2"></i>
                        <p class="text-muted mb-0">Fill in the form and click Generate to create your docker-compose.yml</p>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
<div id="output"></div>
                </div>
            </div>
        </div>
    </div>
        </div>

<!-- Educational Content Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Docker Compose</h5>
    </div>
    <div class="card-body">
        <h6>What is Docker Compose?</h6>
        <p>Docker Compose is a tool for defining and running multi-container Docker applications. Instead of running multiple <code>docker run</code> commands, you define your application's services, networks, and volumes in a single YAML file (<code>docker-compose.yml</code>), then run <code>docker-compose up</code> to start everything.</p>

        <h6 class="mt-4">Docker Compose Version 3</h6>
        <p>Version 3 of the Docker Compose file format is designed for Docker Swarm mode and includes features like:</p>
        <ul>
            <li><strong>Resource Limits:</strong> CPU and memory limits and reservations</li>
            <li><strong>Placement Constraints:</strong> Control where containers run in a Swarm cluster</li>
            <li><strong>Deploy Configuration:</strong> Replicas, update strategies, and restart policies</li>
            <li><strong>Networks:</strong> Advanced networking with overlay networks for multi-host deployments</li>
        </ul>

        <h6 class="mt-4">Key Concepts</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Concept</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Services</strong></td>
                    <td>Containers that run the same image with the same configuration</td>
                </tr>
                <tr>
                    <td><strong>Volumes</strong></td>
                    <td>Persistent data storage that survives container restarts</td>
                </tr>
                <tr>
                    <td><strong>Networks</strong></td>
                    <td>Isolated networks for service communication</td>
                </tr>
                <tr>
                    <td><strong>Environment Variables</strong></td>
                    <td>Configuration passed to containers at runtime</td>
                </tr>
                <tr>
                    <td><strong>Depends On</strong></td>
                    <td>Service startup order dependencies</td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">Common Docker Compose Commands</h6>
<div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Start Services</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>docker-compose up
docker-compose up -d  # detached mode</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Stop Services</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>docker-compose down
docker-compose stop</code></pre>
            </div>
        </div>
        <div class="row mt-2">
            <div class="col-md-6">
                <p class="small mb-1"><strong>View Logs</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>docker-compose logs
docker-compose logs -f  # follow</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Scale Services</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>docker-compose up --scale web=3</code></pre>
            </div>
        </div>

        <h6 class="mt-4">Example Use Cases</h6>
        <ul>
            <li><strong>Web Application Stack:</strong> Nginx, application server, and database in separate containers</li>
            <li><strong>Development Environment:</strong> Consistent setup across team members</li>
            <li><strong>Microservices:</strong> Multiple services that need to communicate</li>
            <li><strong>CI/CD Pipelines:</strong> Test environments that match production</li>
        </ul>
    </div>
</div>

<!-- Related Tools Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="dc1.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt me-1"></i>Docker Run to Compose</h6>
                <p>Convert docker run commands to docker-compose.yml</p>
            </a>
            <a href="dc2.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt me-1"></i>Compose to Docker Run</h6>
                <p>Convert docker-compose.yml to docker run commands</p>
            </a>
            <a href="kube1.jsp" class="related-tool-card">
                <h6><i class="fas fa-cube me-1"></i>Compose to Kubernetes</h6>
                <p>Convert Docker Compose to Kubernetes manifests</p>
            </a>
            <a href="kube2.jsp" class="related-tool-card">
                <h6><i class="fas fa-cube me-1"></i>Kubernetes to Compose</h6>
                <p>Convert Kubernetes manifests to Docker Compose</p>
            </a>
            <a href="kube.jsp" class="related-tool-card">
                <h6><i class="fas fa-server me-1"></i>Kubernetes Spec Generator</h6>
                <p>Generate Kubernetes Pod and Service specs</p>
            </a>
            <a href="yamlparser.jsp" class="related-tool-card">
                <h6><i class="fas fa-code me-1"></i>YAML Parser</h6>
                <p>Parse and validate YAML files</p>
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
                    <i class="fas fa-share-alt"></i> Share Docker Compose File
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info mb-3">
                    <strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
                    <ul class="mb-0 mt-2">
                        <li><strong>All Form Fields:</strong> Service name, image, ports, environment variables, labels, and all other configuration</li>
                        <li><strong>Docker Compose YAML:</strong> The generated docker-compose.yml content</li>
                        <li><strong class="text-success">NOT Included:</strong> Your personal data or passwords</li>
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
                    <i class="fas fa-info-circle"></i> Anyone with this link can view and download the Docker Compose file.
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
function showToast(message) {
    var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
        '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
        '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
    $('body').append(toast);
    setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
}

function addKVPair(type) {
    var container, keyClass, valueClass, keyPlaceholder, valuePlaceholder;
    
    if (type === 'env') {
        container = $('#envPairs');
        keyClass = 'env-key';
        valueClass = 'env-value';
        keyPlaceholder = 'KEY';
        valuePlaceholder = 'value';
    } else if (type === 'label') {
        container = $('#labelPairs');
        keyClass = 'label-key';
        valueClass = 'label-value';
        keyPlaceholder = 'key';
        valuePlaceholder = 'value';
    } else if (type === 'port') {
        container = $('#portPairs');
        keyClass = 'port-host';
        valueClass = 'port-container';
        keyPlaceholder = 'Host Port';
        valuePlaceholder = 'Container Port';
    }
    
    var pair = $('<div class="kv-pair">' +
        '<input type="text" class="form-control form-control-sm ' + keyClass + '" placeholder="' + keyPlaceholder + '">' +
        '<input type="text" class="form-control form-control-sm ' + valueClass + '" placeholder="' + valuePlaceholder + '">' +
        '<button type="button" class="btn-remove" onclick="removeKVPair(this, \'' + type + '\')"><i class="fas fa-times"></i></button>' +
        '</div>');
    
    container.append(pair);
    updateKVPairs(type);
}

function removeKVPair(btn, type) {
    var container;
    if (type === 'env') {
        container = $('#envPairs');
    } else if (type === 'label') {
        container = $('#labelPairs');
    } else if (type === 'port') {
        container = $('#portPairs');
    }
    
    if (container && container.children().length > 1) {
        $(btn).closest('.kv-pair').remove();
        updateKVPairs(type);
    } else {
        // Keep at least one empty pair, just clear it
        $(btn).closest('.kv-pair').find('input').val('');
        updateKVPairs(type);
    }
}

function updateKVPairs(type) {
    var pairs = [];
    var container, keyClass, valueClass, hiddenInput, separator;
    
    if (type === 'env') {
        container = $('#envPairs');
        keyClass = '.env-key';
        valueClass = '.env-value';
        hiddenInput = $('#environment');
        separator = '=';
    } else if (type === 'label') {
        container = $('#labelPairs');
        keyClass = '.label-key';
        valueClass = '.label-value';
        hiddenInput = $('#labels');
        separator = '=';
    } else if (type === 'port') {
        container = $('#portPairs');
        keyClass = '.port-host';
        valueClass = '.port-container';
        hiddenInput = $('#ports');
        separator = ':';
    }
    
    container.find('.kv-pair').each(function() {
        var key = $(this).find(keyClass).val().trim();
        var value = $(this).find(valueClass).val().trim();
        if (key && value) {
            pairs.push(key + separator + value);
        }
    });
    
    hiddenInput.val(pairs.join(','));
}

$(document).ready(function() {
    // Initialize collapse sections - Bootstrap 4 handles this automatically with data attributes
    $('.form-section-title').on('click', function() {
        var isExpanded = $(this).attr('aria-expanded') === 'true';
        $(this).attr('aria-expanded', !isExpanded);
    });
    
    // Update hidden inputs when key-value pairs change
    $(document).on('input', '.env-key, .env-value', function() {
        updateKVPairs('env');
    });
    
    $(document).on('input', '.label-key, .label-value', function() {
        updateKVPairs('label');
    });
    
    $(document).on('input', '.port-host, .port-container', function() {
        updateKVPairs('port');
    });
    
    $('#generatedc').click(function (event) {
        // Update key-value pairs before submission
        updateKVPairs('env');
        updateKVPairs('label');
        updateKVPairs('port');
        $('#form').delay(200).submit();
    });
    
    // Load from URL on page load
    loadFromUrl();

    $('#form').submit(function (event) {
        event.preventDefault();
        
        // Show loading state
        $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x text-primary mb-2"></i><p class="text-muted">Generating docker-compose.yml...</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();
        
        $.ajax({
            type: "POST",
            url: "DockerFunctionality",
            data: $("#form").serialize(),
            dataType: "text",
            success: function(response) {
                try {
                    // Parse JSON response
                    var data;
                    if (typeof response === 'string') {
                        // Try to parse as JSON
                        try {
                            data = JSON.parse(response);
                        } catch (parseError) {
                            // If parsing fails, might be HTML response (backward compatibility)
                            $('#resultPlaceholder').hide();
                            $('#resultContent').show();
                            $('#output').html(response);
                            if ($('#output textarea').length > 0) {
                                $('#output textarea').addClass('hash-output');
                                $('#output textarea').after('<button class="btn btn-sm mt-2" onclick="copyDockerCompose()" style="background: var(--theme-gradient); color: white;"><i class="fas fa-copy me-1"></i>Copy</button>');
                            }
                            showToast('Docker Compose file generated successfully!');
                            return;
                        }
                    } else {
                        data = response;
                    }
                    
                    // Check if response indicates failure
                    if (!data.success) {
                        $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>' + (data.errorMessage || 'Error generating file') + '</p></div>');
                        $('#resultPlaceholder').show();
                        $('#resultContent').hide();
                        showToast(data.errorMessage || 'Error generating Docker Compose file');
                        return;
                    }
                    
                    // Success - display the YAML content
                    var yamlContent = data.dockerComposeYaml || '';
                    
                    if (!yamlContent) {
                        $('#resultPlaceholder').html('<div class="text-center text-warning"><i class="fas fa-exclamation-triangle fa-2x mb-2"></i><p>No YAML content generated</p></div>');
                        $('#resultPlaceholder').show();
                        $('#resultContent').hide();
                        return;
                    }
                    
                    // Create formatted display
                    var html = '<div class="result-label"><i class="fas fa-file-code me-1"></i>docker-compose.yml</div>';
                    html += '<pre class="hash-output" style="max-height: 500px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                    html += escapeHtml(yamlContent);
                    html += '</pre>';
                    html += '<div class="d-flex mt-2" style="gap: 0.5rem;">';
                    html += '<button class="btn btn-sm" onclick="copyDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button>';
                    html += '<button class="btn btn-sm" onclick="downloadDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button>';
                    html += '<button class="btn btn-sm" onclick="shareUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button>';
                    html += '</div>';
                    
                    // Store YAML content globally for download/share
                    window.lastDockerComposeYaml = yamlContent;
                    
                    $('#output').html(html);
                    $('#resultPlaceholder').hide();
                    $('#resultContent').show();
                    
                    showToast('Docker Compose file generated successfully!');
                } catch (e) {
                    console.error('Error processing response:', e);
                    // Fallback for HTML response (backward compatibility)
                    $('#resultPlaceholder').hide();
                    $('#resultContent').show();
                    $('#output').html(response);
                    
                    // Add copy button if not present
                    if ($('#output .hash-output').length === 0 && $('#output textarea').length > 0) {
                        $('#output textarea').addClass('hash-output');
                        $('#output textarea').after('<button class="btn btn-sm mt-2" onclick="copyDockerCompose()" style="background: var(--theme-gradient); color: white;"><i class="fas fa-copy me-1"></i>Copy</button>');
                    }
                    
                    showToast('Docker Compose file generated successfully!');
                }
            },
            error: function(xhr, status, error) {
                var errorMsg = 'Error generating file. Please try again.';
                try {
                    var errorData = JSON.parse(xhr.responseText);
                    if (errorData.errorMessage) {
                        errorMsg = errorData.errorMessage;
                    }
                } catch (e) {
                    // Use default error message
                }
                
                $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>' + errorMsg + '</p></div>');
                $('#resultPlaceholder').show();
                $('#resultContent').hide();
                showToast(errorMsg);
            }
        });
    });
});

function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function copyDockerCompose() {
    var yamlContent = window.lastDockerComposeYaml || '';
    
    if (!yamlContent) {
        // Try to get from textarea first
        var textarea = $('#output textarea');
        if (textarea.length > 0) {
            yamlContent = textarea.val();
        } else {
            // Get from pre or hash-output element
            var hashOutput = $('#output pre, #output .hash-output');
            if (hashOutput.length > 0) {
                yamlContent = hashOutput.text();
            } else {
                // Fallback: get all text
                yamlContent = $('#output').text();
            }
        }
    }
    
    if (yamlContent && yamlContent.trim()) {
        var tempTextarea = $('<textarea>').val(yamlContent).appendTo('body').css({
            position: 'fixed',
            opacity: '0',
            left: '-9999px'
        }).select();
        document.execCommand('copy');
        tempTextarea.remove();
        showToast('Copied to clipboard!');
    } else {
        showToast('Nothing to copy');
    }
}

function downloadDockerCompose() {
    var yamlContent = window.lastDockerComposeYaml || '';
    
    if (!yamlContent) {
        // Try to get from display
        var hashOutput = $('#output pre, #output .hash-output');
        if (hashOutput.length > 0) {
            yamlContent = hashOutput.text();
        } else {
            showToast('No Docker Compose content to download');
            return;
        }
    }
    
    if (yamlContent && yamlContent.trim()) {
        // Generate filename: {brand}-{filename}-{date}.yaml
        var brand = '8gwifi';
        var filename = 'docker-compose';
        var today = new Date();
        var dateStr = today.getFullYear() + '-' + 
                     String(today.getMonth() + 1).padStart(2, '0') + '-' + 
                     String(today.getDate()).padStart(2, '0');
        var downloadFilename = brand + '-' + filename + '-' + dateStr + '.yaml';
        
        var blob = new Blob([yamlContent], { type: 'text/yaml' });
        var url = window.URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = downloadFilename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
        showToast('Download started!');
    } else {
        showToast('No Docker Compose content to download');
    }
}

function shareUrl() {
    // Collect all form field values
    var formData = {
        serviceName: $('#serviceName').val() || '',
        image: $('#image').val() || '',
        container_name: $('#container_name').val() || '',
        entrypoint: $('#entrypoint').val() || '',
        volumes: $('#volumes').val() || '',
        expose: $('#expose').val() || '',
        user: $('#user').val() || '',
        working_dir: $('#working_dir').val() || '',
        hostname: $('#hostname').val() || '',
        domainname: $('#domainname').val() || '',
        ipc: $('#ipc').val() || '',
        mac_address: $('#mac_address').val() || '',
        privileged: $('#privileged').val() || 'false',
        restart_policy: $('#restart_policy').val() || 'no',
        dns: $('#dns').val() || '',
        dns_search: $('#dns_search').val() || '',
        links: $('#links').val() || '',
        depends_on: $('#depends_on').val() || '',
        cpus: $('#cpus').val() || '',
        memory: $('#memory').val() || '',
        rcpus: $('#rcpus').val() || '',
        rmemory: $('#rmemory').val() || '',
        constraints: $('#constraints').val() || '',
        healthcheck: $('#healthcheck').is(':checked') ? 'healthcheck' : '',
        // Key-value pairs
        envPairs: [],
        labelPairs: [],
        portPairs: []
    };
    
    // Collect environment variable pairs
    $('#envPairs .kv-pair').each(function() {
        var key = $(this).find('.env-key').val().trim();
        var value = $(this).find('.env-value').val().trim();
        if (key || value) {
            formData.envPairs.push({key: key, value: value});
        }
    });
    
    // Collect label pairs
    $('#labelPairs .kv-pair').each(function() {
        var key = $(this).find('.label-key').val().trim();
        var value = $(this).find('.label-value').val().trim();
        if (key || value) {
            formData.labelPairs.push({key: key, value: value});
        }
    });
    
    // Collect port pairs
    $('#portPairs .kv-pair').each(function() {
        var host = $(this).find('.port-host').val().trim();
        var container = $(this).find('.port-container').val().trim();
        if (host || container) {
            formData.portPairs.push({host: host, container: container});
        }
    });
    
    // Include generated YAML if available
    var yamlContent = window.lastDockerComposeYaml || '';
    if (yamlContent) {
        formData.dockerComposeYaml = yamlContent;
    }
    
    // Encode form data to JSON, then base64, then URL encode
    try {
        var jsonData = JSON.stringify(formData);
        var base64Encoded = btoa(unescape(encodeURIComponent(jsonData)));
        var urlEncoded = encodeURIComponent(base64Encoded);
        var shareUrl = window.location.origin + window.location.pathname + '?data=' + urlEncoded;
        
        $('#shareUrlText').val(shareUrl);
        $('#shareUrlModal').modal('show');
    } catch (e) {
        showToast('Error generating share URL: ' + e.message);
    }
}

// Load from URL on page load
function loadFromUrl() {
    var urlParams = new URLSearchParams(window.location.search);
    var dataParam = urlParams.get('data');
    var composeParam = urlParams.get('compose'); // Backward compatibility
    
    if (dataParam) {
        try {
            // First URL decode, then base64 decode, then parse JSON
            var base64Decoded = decodeURIComponent(dataParam);
            var jsonData = decodeURIComponent(escape(atob(base64Decoded)));
            var formData = JSON.parse(jsonData);
            
            // Populate all form fields
            if (formData.serviceName) $('#serviceName').val(formData.serviceName);
            if (formData.image) $('#image').val(formData.image);
            if (formData.container_name) $('#container_name').val(formData.container_name);
            if (formData.entrypoint) $('#entrypoint').val(formData.entrypoint);
            if (formData.volumes) $('#volumes').val(formData.volumes);
            if (formData.expose) $('#expose').val(formData.expose);
            if (formData.user) $('#user').val(formData.user);
            if (formData.working_dir) $('#working_dir').val(formData.working_dir);
            if (formData.hostname) $('#hostname').val(formData.hostname);
            if (formData.domainname) $('#domainname').val(formData.domainname);
            if (formData.ipc) $('#ipc').val(formData.ipc);
            if (formData.mac_address) $('#mac_address').val(formData.mac_address);
            if (formData.privileged) $('#privileged').val(formData.privileged);
            if (formData.restart_policy) $('#restart_policy').val(formData.restart_policy);
            if (formData.dns) $('#dns').val(formData.dns);
            if (formData.dns_search) $('#dns_search').val(formData.dns_search);
            if (formData.links) $('#links').val(formData.links);
            if (formData.depends_on) $('#depends_on').val(formData.depends_on);
            if (formData.cpus) $('#cpus').val(formData.cpus);
            if (formData.memory) $('#memory').val(formData.memory);
            if (formData.rcpus) $('#rcpus').val(formData.rcpus);
            if (formData.rmemory) $('#rmemory').val(formData.rmemory);
            if (formData.constraints) $('#constraints').val(formData.constraints);
            if (formData.healthcheck === 'healthcheck') $('#healthcheck').prop('checked', true);
            
            // Restore key-value pairs
            if (formData.envPairs && formData.envPairs.length > 0) {
                $('#envPairs').empty();
                formData.envPairs.forEach(function(pair) {
                    addKVPair('env');
                    var lastPair = $('#envPairs .kv-pair').last();
                    lastPair.find('.env-key').val(pair.key || '');
                    lastPair.find('.env-value').val(pair.value || '');
                });
                updateKVPairs('env');
            }
            
            if (formData.labelPairs && formData.labelPairs.length > 0) {
                $('#labelPairs').empty();
                formData.labelPairs.forEach(function(pair) {
                    addKVPair('label');
                    var lastPair = $('#labelPairs .kv-pair').last();
                    lastPair.find('.label-key').val(pair.key || '');
                    lastPair.find('.label-value').val(pair.value || '');
                });
                updateKVPairs('label');
            }
            
            if (formData.portPairs && formData.portPairs.length > 0) {
                $('#portPairs').empty();
                formData.portPairs.forEach(function(pair) {
                    addKVPair('port');
                    var lastPair = $('#portPairs .kv-pair').last();
                    lastPair.find('.port-host').val(pair.host || '');
                    lastPair.find('.port-container').val(pair.container || '');
                });
                updateKVPairs('port');
            }
            
            // Display YAML if available
            if (formData.dockerComposeYaml) {
                var yamlContent = formData.dockerComposeYaml;
                var html = '<div class="result-label"><i class="fas fa-file-code me-1"></i>docker-compose.yml (from shared link)</div>';
                html += '<pre class="hash-output" style="max-height: 500px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                html += escapeHtml(yamlContent);
                html += '</pre>';
                html += '<div class="d-flex mt-2" style="gap: 0.5rem;">';
                html += '<button class="btn btn-sm" onclick="copyDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button>';
                html += '<button class="btn btn-sm" onclick="downloadDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button>';
                html += '<button class="btn btn-sm" onclick="shareUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button>';
                html += '</div>';
                
                window.lastDockerComposeYaml = yamlContent;
                
                $('#output').html(html);
                $('#resultPlaceholder').hide();
                $('#resultContent').show();
            }
            
            // Expand relevant sections
            $('#serviceConfig').addClass('show');
            if (formData.envPairs && formData.envPairs.length > 0) {
                $('#envLabels').addClass('show');
            }
            if (formData.portPairs && formData.portPairs.length > 0) {
                $('#networking').addClass('show');
            }
            
            showToast('Form data loaded from shared link!');
        } catch (e) {
            console.error('Error loading from URL:', e);
            showToast('Error loading shared form data');
        }
    } else if (composeParam) {
        // Backward compatibility: old format with just YAML
        try {
            var base64Decoded = decodeURIComponent(composeParam);
            var yamlContent = decodeURIComponent(escape(atob(base64Decoded)));
            
            var html = '<div class="result-label"><i class="fas fa-file-code me-1"></i>docker-compose.yml (from shared link)</div>';
            html += '<pre class="hash-output" style="max-height: 500px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
            html += escapeHtml(yamlContent);
            html += '</pre>';
            html += '<div class="d-flex mt-2" style="gap: 0.5rem;">';
            html += '<button class="btn btn-sm" onclick="copyDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button>';
            html += '<button class="btn btn-sm" onclick="downloadDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button>';
            html += '<button class="btn btn-sm" onclick="shareUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button>';
            html += '</div>';
            
            window.lastDockerComposeYaml = yamlContent;
            
            $('#output').html(html);
            $('#resultPlaceholder').hide();
            $('#resultContent').show();
            
            showToast('Docker Compose file loaded from shared link!');
        } catch (e) {
            console.error('Error loading from URL:', e);
            showToast('Error loading shared Docker Compose file');
        }
    }
}

// Copy share URL button
$(document).on('click', '#copyShareUrl', function() {
    var shareUrl = $('#shareUrlText').val();
    var tempInput = $('<input>').val(shareUrl).appendTo('body').css({
        position: 'fixed',
        opacity: '0',
        left: '-9999px'
    }).select();
    document.execCommand('copy');
    tempInput.remove();
    
    var btn = $(this);
    var originalText = btn.html();
    btn.html('<i class="fas fa-check"></i> Copied!').css('background', '#28a745');
    setTimeout(function() {
        btn.html(originalText).css('background', '');
    }, 2000);
    
    showToast('Share URL copied to clipboard!');
});
</script>
</div>
<%@ include file="body-close.jsp"%>

<%@ include file="body-close.jsp"%>
<%@ include file="body-close.jsp"%>
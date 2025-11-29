<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Docker Compose to Kubernetes Converter Online – Free | 8gwifi.org</title>
    <meta name="description" content="Free online tool to convert Docker Compose files to Kubernetes resources. Generate Pods, Deployments, ReplicaSets, and StatefulSets from docker-compose.yml.">
    <meta name="keywords" content="docker compose to kubernetes, docker compose to k8s, compose to kubernetes converter, docker compose to pod, docker compose to deployment">
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/kube1.jsp" />

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Docker Compose to Kubernetes Converter",
        "description": "Free online tool to convert Docker Compose files to Kubernetes resources. Generate Pods, Deployments, ReplicaSets, and StatefulSets from docker-compose.yml.",
        "url": "https://8gwifi.org/kube1.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
        "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
        "datePublished": "2020-03-11",
        "dateModified": "2025-01-28"
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "How do I convert Docker Compose to Kubernetes?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Paste your docker-compose.yml file into the input field, select the Kubernetes resource type (Pod, Deployment, ReplicaSet, or StatefulSet), and click 'Generate Kubernetes Resources'. The tool automatically converts Docker Compose services, volumes, networks, and configurations into equivalent Kubernetes manifests."
            }
        },{
            "@type": "Question",
            "name": "What Kubernetes resource types are supported?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The converter supports Pod, Deployment, ReplicaSet, and StatefulSet resource types. Pods are single instances, Deployments manage replica sets, ReplicaSets ensure a specified number of pod replicas are running, and StatefulSets provide stable network identities and persistent storage."
            }
        },{
            "@type": "Question",
            "name": "Why convert Docker Compose to Kubernetes?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Kubernetes provides advanced orchestration features like auto-scaling, self-healing, rolling updates, service discovery, and load balancing. Converting Docker Compose to Kubernetes allows you to deploy applications in production environments with better reliability, scalability, and management capabilities."
            }
        },{
            "@type": "Question",
            "name": "What Docker Compose features are converted?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The converter handles services, images, ports, volumes, environment variables, networks, restart policies, depends_on relationships, and security contexts. It maps Docker Compose concepts to their Kubernetes equivalents (e.g., services → Deployments, volumes → PersistentVolumeClaims)."
            }
        },{
            "@type": "Question",
            "name": "Can I use the generated Kubernetes manifests in production?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The generated manifests provide a good starting point, but you should review and customize them for production use. Consider adding resource limits, health checks, security policies, and proper namespaces. The converter handles basic configurations, but production deployments may require additional Kubernetes features."
            }
        }]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #f97316;
            --theme-secondary: #ea580c;
            --theme-gradient: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            --theme-light: #fff7ed;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(249, 115, 22, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(249, 115, 22, 0.25);
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
            border-radius: 8px;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
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
        .result-label {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
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
            box-shadow: 0 2px 8px rgba(249, 115, 22, 0.2);
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
    </style>


    <script type="text/javascript">
        $(document).ready(function() {

            $('#generatedc').click(function (event)
            {
                //
                $('#form').delay(200).submit()

            });

            function showToast(message) {
                var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
                    '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
                    '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
                $('body').append(toast);
                setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
            }

            function escapeHtml(text) {
                if (!text) return '';
                var div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            }

            function copyKubernetes() {
                var yamlContent = window.lastKubernetesYaml || '';
                
                if (!yamlContent) {
                    var hashOutput = $('#output pre, #output .hash-output, #output textarea');
                    if (hashOutput.length > 0) {
                        yamlContent = hashOutput.first().text() || hashOutput.first().val();
                    } else {
                        showToast('Nothing to copy');
                        return;
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

            function downloadKubernetes() {
                var yamlContent = window.lastKubernetesYaml || '';
                
                if (!yamlContent) {
                    var hashOutput = $('#output pre, #output .hash-output, #output textarea');
                    if (hashOutput.length > 0) {
                        yamlContent = hashOutput.first().text() || hashOutput.first().val();
                    } else {
                        showToast('No Kubernetes manifest to download');
                        return;
                    }
                }
                
                if (yamlContent && yamlContent.trim()) {
                    var brand = '8gwifi';
                    var resourceType = window.lastResourceType || 'kubernetes';
                    var today = new Date();
                    var dateStr = today.getFullYear() + '-' + 
                                 String(today.getMonth() + 1).padStart(2, '0') + '-' + 
                                 String(today.getDate()).padStart(2, '0');
                    var downloadFilename = brand + '-' + resourceType.toLowerCase() + '-' + dateStr + '.yaml';
                    
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
                    showToast('No Kubernetes manifest to download');
                }
            }

            function shareKubernetesUrl() {
                var dockerComposeFile = $('#dockerstuff').val() || '';
                var yamlContent = window.lastKubernetesYaml || '';
                
                if (!yamlContent) {
                    var hashOutput = $('#output pre, #output .hash-output, #output textarea');
                    if (hashOutput.length > 0) {
                        yamlContent = hashOutput.first().text() || hashOutput.first().val();
                    } else {
                        showToast('No Kubernetes manifest to share');
                        return;
                    }
                }
                
                if (!yamlContent || !yamlContent.trim()) {
                    showToast('No Kubernetes manifest to share');
                    return;
                }
                
                var formData = {
                    dockerComposeFile: dockerComposeFile,
                    kubernetesYaml: yamlContent,
                    resourceType: window.lastResourceType || 'Pod'
                };
                
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

            $('#form').submit(function (event)
            {
                // Show loading state
                $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x text-primary mb-2"></i><p class="text-muted">Converting to Kubernetes resources...</p></div>');
                $('#resultPlaceholder').show();
                $('#resultContent').hide();
                
                event.preventDefault();
                $.ajax({
                    type: "POST",
                    url: "KubeFunctionality",
                    data: $("#form").serialize(),
                    dataType: "text",
                    success: function(response){
                        try {
                            var data = typeof response === 'string' ? JSON.parse(response) : response;
                            
                            if (!data.success) {
                                $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>' + (data.errorMessage || 'Error converting') + '</p></div>');
                                $('#resultPlaceholder').show();
                                $('#resultContent').hide();
                                showToast(data.errorMessage || 'Error converting to Kubernetes');
                                return;
                            }
                            
                            var yamlContent = data.kubernetesYaml || '';
                            
                            if (!yamlContent) {
                                $('#resultPlaceholder').html('<div class="text-center text-warning"><i class="fas fa-exclamation-triangle fa-2x mb-2"></i><p>No Kubernetes manifest generated</p></div>');
                                $('#resultPlaceholder').show();
                                $('#resultContent').hide();
                                return;
                            }
                            
                            // Store for copy/download/share
                            window.lastKubernetesYaml = yamlContent;
                            window.lastResourceType = data.resourceType || 'Pod';
                            
                            // Create formatted display
                            var html = '<div class="result-label"><i class="fas fa-cube me-1"></i>' + (data.resourceType || 'Kubernetes') + ' YAML</div>';
                            html += '<pre class="hash-output" style="max-height: 500px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                            html += escapeHtml(yamlContent);
                            html += '</pre>';
                            
                            // Add JSON if available
                            if (data.kubernetesJson) {
                                html += '<div class="result-label mt-3"><i class="fas fa-code me-1"></i>' + (data.resourceType || 'Kubernetes') + ' JSON</div>';
                                html += '<pre class="hash-output" style="max-height: 300px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                                html += escapeHtml(data.kubernetesJson);
                                html += '</pre>';
                            }
                            
                            html += '<div class="d-flex mt-2" style="gap: 0.5rem;">';
                            html += '<button class="btn btn-sm" onclick="copyKubernetes()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button>';
                            html += '<button class="btn btn-sm" onclick="downloadKubernetes()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button>';
                            html += '<button class="btn btn-sm" onclick="shareKubernetesUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button>';
                            html += '</div>';
                            
                            $('#output').html(html);
                            $('#resultPlaceholder').hide();
                            $('#resultContent').show();
                            showToast('Kubernetes resources generated successfully!');
                        } catch (e) {
                            // Fallback for HTML response (backward compatibility)
                            $('#output').empty();
                            $('#output').append(response);
                            $('#resultPlaceholder').hide();
                            $('#resultContent').show();
                            showToast('Kubernetes resources generated successfully!');
                        }
                    },
                    error: function() {
                        $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>Error converting. Please try again.</p></div>');
                        $('#resultPlaceholder').show();
                        $('#resultContent').hide();
                        showToast('Error converting to Kubernetes');
                    }
                });
            });
        });

    </script>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="devops-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">Docker Compose to Kubernetes Converter</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fab fa-docker"></i> Compose</span>
            <span class="info-badge"><i class="fas fa-exchange-alt"></i> Converter</span>
            <span class="info-badge"><i class="fas fa-cube"></i> Kubernetes</span>
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
                <h5><i class="fas fa-file-code me-2"></i>Docker Compose Configuration</h5>
            </div>
            <div class="card-body">
                <form id="form" method="POST">
                    <input type="hidden" name="methodName" id="methodName" value="CONFIG_GENERATE">

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-cube me-1"></i>Choose Kubernetes Resources</div>
                        <div class="form-row">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="generateroption" id="podGen" value="podGen" checked>
                                <label class="form-check-label" for="podGen">Pod</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="generateroption" id="deployGen" value="deployGen">
                                <label class="form-check-label" for="deployGen">Deployment</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="generateroption" id="repliGen" value="repliGen">
                                <label class="form-check-label" for="repliGen">ReplicaSet</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="generateroption" id="statefulGen" value="statefulGen">
                                <label class="form-check-label" for="statefulGen">StatefulSet</label>
                            </div>
                        </div>
                        <div class="form-check mt-2">
                            <input class="form-check-input" type="checkbox" value="pod" name="addSecurityContextOn" id="addSecurityContextOn">
                            <label class="form-check-label" for="addSecurityContextOn">
                                Add Security Context on Container (Default is Pod)
                            </label>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-code me-1"></i>Paste Docker Compose File</div>
                        <textarea class="form-control" name="dockerstuff" id="dockerstuff" rows="15" placeholder="version: '3'\nservices:\n  nginx:\n    image: nginx:latest" style="font-family: 'Courier New', monospace; font-size: 0.85rem;">version: "3.7"
services:
  db:
    image: postgres:9.4
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend
    deploy:
      placement:
        constraints: [node.role == manager]

  vote:
    image: dockersamples/examplevotingapp_vote:before
    ports:
      - "5000:80"
    networks:
      - frontend
    depends_on:
      - redis
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
      restart_policy:
        condition: on-failure
networks:
  frontend:
  backend:

volumes:
  db-data:</textarea>
                        <small class="text-muted d-block mt-2" style="font-size: 0.75rem;">
                            <i class="fas fa-info-circle me-1"></i>Paste your complete docker-compose.yml file here
                        </small>
                    </div>

                    <button type="button" class="btn w-100" id="generatedc" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-magic me-2"></i>Generate Kubernetes Resources
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-cube me-2"></i>Generated Kubernetes Resources</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-arrow-left fa-2x text-muted mb-2"></i>
                        <p class="text-muted mb-0">Paste a docker-compose.yml file and click Generate to create Kubernetes resources</p>
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
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Docker Compose to Kubernetes Conversion</h5>
    </div>
    <div class="card-body">
        <h6>What is Docker Compose to Kubernetes Conversion?</h6>
        <p>This tool automatically converts Docker Compose files into Kubernetes resource manifests. Instead of manually translating each service, volume, and network configuration, the converter parses your docker-compose.yml file and generates equivalent Kubernetes Pods, Deployments, ReplicaSets, or StatefulSets.</p>

        <h6 class="mt-4">Docker Compose to Kubernetes Mapping</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Docker Compose</th>
                    <th>Kubernetes Equivalent</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>services</code></td>
                    <td><code>Deployment/Pod</code></td>
                    <td>Container definitions</td>
                </tr>
                <tr>
                    <td><code>image</code></td>
                    <td><code>spec.containers[].image</code></td>
                    <td>Container image</td>
                </tr>
                <tr>
                    <td><code>ports</code></td>
                    <td><code>spec.containers[].ports</code></td>
                    <td>Port mappings</td>
                </tr>
                <tr>
                    <td><code>volumes</code></td>
                    <td><code>PersistentVolumeClaim</code></td>
                    <td>Persistent storage</td>
                </tr>
                <tr>
                    <td><code>environment</code></td>
                    <td><code>ConfigMap/Secret</code></td>
                    <td>Environment variables</td>
                </tr>
                <tr>
                    <td><code>networks</code></td>
                    <td><code>Service</code></td>
                    <td>Network connectivity</td>
                </tr>
                <tr>
                    <td><code>depends_on</code></td>
                    <td><code>initContainers</code></td>
                    <td>Service dependencies</td>
                </tr>
                <tr>
                    <td><code>restart</code></td>
                    <td><code>restartPolicy</code></td>
                    <td>Restart behavior</td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">Kubernetes Resource Types</h6>
        <ul>
            <li><strong>Pod:</strong> Single instance of a container. Use for one-off tasks or testing.</li>
            <li><strong>Deployment:</strong> Manages ReplicaSets and provides rolling updates. Best for stateless applications.</li>
            <li><strong>ReplicaSet:</strong> Ensures a specified number of pod replicas are running. Usually managed by Deployments.</li>
            <li><strong>StatefulSet:</strong> Manages stateful applications with stable network identities and persistent storage.</li>
        </ul>

        <h6 class="mt-4">Example Conversion</h6>
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>docker-compose.yml</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>version: '3'
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    environment:
      NGINX_HOST: localhost</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Generated Kubernetes Deployment</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  template:
    spec:
      containers:
      - image: nginx:latest
        ports:
        - containerPort: 80
        env:
        - name: NGINX_HOST
          value: localhost</code></pre>
            </div>
        </div>

        <h6 class="mt-4">Benefits of Kubernetes</h6>
        <ul>
            <li><strong>Auto-scaling:</strong> Automatically scale based on demand</li>
            <li><strong>Self-healing:</strong> Restart failed containers automatically</li>
            <li><strong>Rolling Updates:</strong> Update applications with zero downtime</li>
            <li><strong>Service Discovery:</strong> Built-in DNS and load balancing</li>
            <li><strong>Resource Management:</strong> CPU and memory limits per container</li>
            <li><strong>Multi-Cloud:</strong> Run on any cloud provider or on-premises</li>
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
            <a href="dc.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-code me-1"></i>Docker Compose Generator</h6>
                <p>Generate compose files from form inputs</p>
            </a>
            <a href="dc1.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt me-1"></i>Docker Run to Compose</h6>
                <p>Convert docker run commands to compose</p>
            </a>
            <a href="dc2.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt me-1"></i>Compose to Docker Run</h6>
                <p>Convert compose files to docker run commands</p>
            </a>
            <a href="kube.jsp" class="related-tool-card">
                <h6><i class="fas fa-server me-1"></i>Kubernetes Spec Generator</h6>
                <p>Generate Kubernetes Pods and Services</p>
            </a>
            <a href="kube2.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt me-1"></i>Kubernetes to Compose</h6>
                <p>Convert Kubernetes manifests to Docker Compose</p>
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
                    <i class="fas fa-share-alt"></i> Share Kubernetes Resources
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info mb-3">
                    <strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
                    <ul class="mb-0 mt-2">
                        <li><strong>Docker Compose File:</strong> The original docker-compose.yml you pasted</li>
                        <li><strong>Kubernetes YAML:</strong> The generated Kubernetes manifest</li>
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
                    <i class="fas fa-info-circle"></i> Anyone with this link can view and download the Kubernetes resources.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
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

    // Load from URL on page load
    function loadFromUrl() {
        var urlParams = new URLSearchParams(window.location.search);
        var dataParam = urlParams.get('data');
        
        if (dataParam) {
            try {
                var base64Decoded = decodeURIComponent(dataParam);
                var jsonData = decodeURIComponent(escape(atob(base64Decoded)));
                var formData = JSON.parse(jsonData);
                
                // Populate docker compose file
                if (formData.dockerComposeFile) {
                    $('#dockerstuff').val(formData.dockerComposeFile);
                }
                
                // Display Kubernetes YAML if available
                if (formData.kubernetesYaml) {
                    var yamlContent = formData.kubernetesYaml;
                    var html = '<div class="result-label"><i class="fas fa-cube me-1"></i>' + (formData.resourceType || 'Kubernetes') + ' YAML (from shared link)</div>';
                    html += '<pre class="hash-output" style="max-height: 500px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                    html += escapeHtml(yamlContent);
                    html += '</pre>';
                    
                    if (formData.kubernetesJson) {
                        html += '<div class="result-label mt-3"><i class="fas fa-code me-1"></i>' + (formData.resourceType || 'Kubernetes') + ' JSON</div>';
                        html += '<pre class="hash-output" style="max-height: 300px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                        html += escapeHtml(formData.kubernetesJson);
                        html += '</pre>';
                    }
                    
                    html += '<div class="d-flex mt-2" style="gap: 0.5rem;">';
                    html += '<button class="btn btn-sm" onclick="copyKubernetes()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button>';
                    html += '<button class="btn btn-sm" onclick="downloadKubernetes()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button>';
                    html += '<button class="btn btn-sm" onclick="shareKubernetesUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button>';
                    html += '</div>';
                    
                    window.lastKubernetesYaml = yamlContent;
                    window.lastResourceType = formData.resourceType || 'Pod';
                    
                    $('#output').html(html);
                    $('#resultPlaceholder').hide();
                    $('#resultContent').show();
                }
                
                showToast('Data loaded from shared link!');
            } catch (e) {
                console.error('Error loading from URL:', e);
                showToast('Error loading shared data');
            }
        }
    }
    
    // Load from URL on page load
    loadFromUrl();
</script>

<hr>

<div class="sharethis-inline-share-buttons"></div>

<%@ include file="footer_adsense.jsp"%>

<hr>
<h2 class="mt-4">Try Other Convertor</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="kube.jsp">Kubertes Spec Generate(Pods/svc)</a></li>
            <li><a href="dc.jsp">Docker Compose Generator</a></li>
            <li><a href="dc1.jsp">Docker run to Docker Compose Conversion</a></li>
            <li><a href="dc2.jsp">Docker Compose to docker run Conversion</a></li>
            <li><a href="kube1.jsp">Docker Compose to Kubernetes conversion</a></li>
            <li><a href="kube2.jsp">Kubernetes to Docker compose conversion</a></li>
            <li><a href="jsonparser.jsp">JSON-2-YAML Convertor</a></li>
            <li><a href="yamlparser.jsp">YAML-2-JSON Convertor</a></li>
            <li><a href="qrcodegen.jsp">QR Code generate</a></li>
            <li><a href="hexdump.jsp">Online Hexdump Generate</a></li>
            <li><a href="diff.jsp">Compare text differences</a></li>
            <li><a href="UrlEncodeDecodeFunctions.jsp">URL Encoders/Decoders</a></li>
            <li><a href="HexToStringFunctions.jsp">Hex To String Conversion</a></li>
            <li><a href="HexToStringFunctions.jsp">String To Hex Conversion</a></li>
            <li><a href="base64Hex.jsp">Base64 To Hex (ViceVersa)</a></li>
            <li><a href="Base64Functions.jsp">Base64 Encode/Decode</a></li>
            <li><a href="base64image.jsp">Base64 Image Converter(data:image/png)</a></li>
            <li><a href="StringFunctions.jsp">Various String Functions</a></li>
        </ul>
    </div>
</div>

<hr>
<h2 class="mt-4">Kubernetes Topic </h2>
<div>
    <ul>
        <li>
            <a href="docs/ansible-kube-install.jsp">kubernetes install on using ansible</a>
        </li>
        <li>
            <a href="docs/kube-install.jsp">kube install on in centos7/ubuntu7</a>
        </li>
        <li>
            <a href="docs/kube-dash.jsp">kubernetes Dashbaord Setup</a>
        </li>
        <li>
            <a href="docs/kube-pods.jsp">Pod,Cluster,Deploy,ReplicaSet Light Dive</a>
        </li>
        <li>
            <a href="docs/kube-nginx.jsp">kubernetes secure nginx deployment</a>
        </li>
        <li>
            <a href="docs/kube-ports.jsp">kubernetes Port, Targetport and NodePort</a>
        </li>
        <li>
            <a href="docs/kube-namespaces.jsp">kubernetes Namespace</a>
        </li>
        <li>
            <a href="docs/kube-auth.jsp">kubenetes Auth,Authorization,Admission</a>
        </li>
        <li>
            <a href="docs/kube-rbac.jsp">kubernetes Role-Based Access Control</a>
        </li>
        <li>
            <a href="docs/CVE-2018-1002105.jsp">Kubernetes Privilege Escalation Vulnerability</a>
        </li>
        <li>
            <a href="docs/prometheus-dashboard.jsp">Prometheus Dashboard Access</a>
        </li>
        <li>
            <a href="docs/kube-mysql.jsp">Kubernetes mysql installation</a>
        </li>
        <li>
            <a href="docs/kube-jenkins.jsp">Kubernetes Jenkins installation</a>
        </li>
        <li>
            <a href="docs/podman-jenkins.jsp">Podman Jenkins installation</a>
        </li>
        <li>
            <a href="docs/kube-mariadb.jsp">Kubernetes mariadb installation</a>
        </li>
        <li>
            <a href="docs/kube-wordpress.jsp">Kubernetes wordpress installation</a>
        </li>
        <li>
            <a href="docs/kube-drupal.jsp">Kubernetes drupal installation</a>
        </li>
        <li>
            <a href="docs/kube-traefik.jsp">Kubernetes traefik installation</a>
        </li>

        <li>
            <a href="docs/kube-traefik2.jsp">Kubernetes Ingress traefik </a>
        </li>

        <li>
            <a href="docs/kube-debug.jsp">kubernetes service external ip pending ?</a>
        </li>

        <li>
            <a href="docs/kube-Istio.jsp">Service Mesh With Istio</a>
        </li>

        <li>
            <a href="docs/kube-externalname.jsp">Access SVC in Another Namespaces</a>
        </li>

        <li>
            <a href="docs/kube-java.jsp">kubernetes Java client example</a>
        </li>

        <li>
            <a href="docs/kube-lets.jsp">kubernetes letsencrypt deploy wild card certificate</a>
        </li>

        <li>
            <a href="docs/docker-install.jsp">Right Way to Install Docker</a>
        </li>

        <li>
            <a href="docs/docker-privaterepo.jsp">Docker Private repo with SSL and AUTH</a>
        </li>

        <li>
            <a href="docs/docker-baseimage.jsp">Creating Docker Base Image</a>
        </li>

        <li>
            <a href="docs/containers.jsp">Container Runtime (RUNC,RKT,CRI-O,Conatinerd) </a>
        </li>

        <li>
            <a href="docs/podman-install.jsp">Podman Install on Ubuntu/Debian</a>
        </li>
    </ul>
</div>


<hr>


<%@ include file="thanks.jsp"%>
<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
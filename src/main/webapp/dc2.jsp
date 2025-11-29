<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Docker Compose to Run Command Converter Online – Free | 8gwifi.org</title>
    <meta name="description" content="Free online tool to convert docker-compose.yml files to Docker run commands. Transform Docker Compose configurations into equivalent docker run commands automatically.">
    <meta name="keywords" content="docker compose to run, docker compose to docker run, convert docker compose to run command, docker compose to command, docker run command generator from compose, docker compose converter">
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/dc2.jsp" />

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
{
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Docker Compose to Run Command Converter",
        "description": "Free online tool to convert docker-compose.yml files to Docker run commands. Automatically transforms Docker Compose configurations into equivalent docker run commands.",
        "url": "https://8gwifi.org/dc2.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
        "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
        "datePublished": "2020-03-05",
        "dateModified": "2025-01-28"
}
</script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "How do I convert Docker Compose to Docker run command?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Paste your docker-compose.yml file into the input field and click 'Generate docker run'. The tool automatically parses all services, ports, volumes, environment variables, and other configurations from your Docker Compose file and converts them into equivalent docker run commands."
            }
        },{
            "@type": "Question",
            "name": "What Docker Compose fields are supported?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The converter supports most Docker Compose fields including: image, container_name, ports, volumes, environment, networks, depends_on, restart, privileged, dns, dns_search, labels, devices, tmpfs, ulimits, logging, and more."
            }
        },{
            "@type": "Question",
            "name": "Why convert docker-compose.yml to docker run?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Converting to docker run commands is useful for understanding what Docker Compose does under the hood, debugging issues, running containers manually, or when you need a single command instead of a compose file."
            }
        },{
            "@type": "Question",
            "name": "Can I convert multi-service compose files?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes! The converter processes all services in your docker-compose.yml file and generates separate docker run commands for each service, making it easy to see the equivalent commands for each container."
            }
        },{
            "@type": "Question",
            "name": "What version of Docker Compose is supported?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The converter supports Docker Compose file format versions 1, 2, and 3, including version 3.x syntax with deploy configurations and other advanced features."
            }
        }]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #10b981;
            --theme-secondary: #059669;
            --theme-gradient: linear-gradient(135deg, #10b981 0%, #059669 100%);
            --theme-light: #ecfdf5;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(16, 185, 129, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(16, 185, 129, 0.25);
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
        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
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
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.2);
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
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="devops-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">Docker Compose to Run Command Converter</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-file-code"></i> Compose File</span>
            <span class="info-badge"><i class="fas fa-exchange-alt"></i> Converter</span>
            <span class="info-badge"><i class="fas fa-terminal"></i> Docker Run</span>
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
                <h5><i class="fas fa-file-code me-2"></i>Docker Compose File</h5>
            </div>
            <div class="card-body">
<form id="form" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="GENERATE_DC_RUN_2_DC">

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-code me-1"></i>Paste Docker Compose YAML</div>
                        <textarea class="form-control" name="dockerrun" id="dockerrun" rows="15" placeholder="version: '3'\nservices:\n  nginx:\n    image: nginx:latest\n    ports:\n      - '80:80'" style="font-family: 'Courier New', monospace; font-size: 0.85rem;">version: "3.7"
services:

  redis:
    image: redis:alpine
    ports:
      - "6379"
    networks:
      - frontend
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure

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

  result:
    image: dockersamples/examplevotingapp_result:before
    ports:
      - "5001:80"
    networks:
      - backend
    depends_on:
      - db
    deploy:
      replicas: 1
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure

  worker:
    image: dockersamples/examplevotingapp_worker
    networks:
      - frontend
      - backend
    deploy:
      mode: replicated
      replicas: 1
      labels: [APP=VOTING]
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
        window: 120s
      placement:
        constraints: [node.role == manager]

  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    stop_grace_period: 1m30s
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]

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
                        <i class="fas fa-magic me-2"></i>Generate docker run commands
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-terminal me-2"></i>Generated Docker Run Commands</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-arrow-left fa-2x text-muted mb-2"></i>
                        <p class="text-muted mb-0">Paste a docker-compose.yml file and click Generate to create docker run commands</p>
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
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Docker Compose to Run Command Conversion</h5>
    </div>
    <div class="card-body">
        <h6>What is Docker Compose to Run Command Conversion?</h6>
        <p>This tool automatically converts Docker Compose YAML files into equivalent Docker run commands. Instead of manually translating each service configuration, the converter parses your docker-compose.yml file and generates the corresponding docker run commands for each service.</p>

        <h6 class="mt-4">Docker Compose to Docker Run Mapping</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Docker Compose Field</th>
                    <th>Docker Run Flag</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>ports</code></td>
                    <td><code>-p, --publish</code></td>
                    <td>Port mappings</td>
                </tr>
                <tr>
                    <td><code>volumes</code></td>
                    <td><code>-v, --volume</code></td>
                    <td>Volume mounts</td>
                </tr>
                <tr>
                    <td><code>environment</code></td>
                    <td><code>-e, --env</code></td>
                    <td>Environment variables</td>
                </tr>
                <tr>
                    <td><code>container_name</code></td>
                    <td><code>--name</code></td>
                    <td>Container name</td>
                </tr>
                <tr>
                    <td><code>restart</code></td>
                    <td><code>--restart</code></td>
                    <td>Restart policy</td>
                </tr>
                <tr>
                    <td><code>dns</code></td>
                    <td><code>--dns</code></td>
                    <td>DNS servers</td>
                </tr>
                <tr>
                    <td><code>networks</code></td>
                    <td><code>--network</code></td>
                    <td>Network configuration</td>
                </tr>
                <tr>
                    <td><code>privileged</code></td>
                    <td><code>--privileged</code></td>
                    <td>Privileged mode</td>
                </tr>
                <tr>
                    <td><code>labels</code></td>
                    <td><code>--label</code></td>
                    <td>Container labels</td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">Example Conversion</h6>
<div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>docker-compose.yml</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>version: '3'
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "8080:80"
    volumes:
      - /data:/usr/share/nginx/html
    environment:
      NGINX_HOST: localhost
    restart: unless-stopped</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Generated Docker Run Command</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>docker run -d \
  --name nginx \
  -p 8080:80 \
  -v /data:/usr/share/nginx/html \
  -e NGINX_HOST=localhost \
  --restart unless-stopped \
  nginx:latest</code></pre>
            </div>
        </div>

        <h6 class="mt-4">Use Cases</h6>
        <ul>
            <li><strong>Understanding:</strong> See what Docker Compose does under the hood</li>
            <li><strong>Debugging:</strong> Test individual services with docker run</li>
            <li><strong>Manual Execution:</strong> Run containers without Docker Compose</li>
            <li><strong>Documentation:</strong> Document exact commands for each service</li>
            <li><strong>Migration:</strong> Convert compose files to run commands for scripts</li>
            <li><strong>Learning:</strong> Understand the relationship between Compose and run</li>
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
                <p>Convert docker run commands to docker-compose.yml</p>
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
                    <i class="fas fa-share-alt"></i> Share Docker Run Commands
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
                        <li><strong>Docker Run Commands:</strong> The generated docker run commands</li>
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
                    <i class="fas fa-info-circle"></i> Anyone with this link can view and download the Docker run commands.
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

function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function copyDockerRun() {
    var commandContent = window.lastDockerRunCommand || '';
    
    if (!commandContent) {
        var hashOutput = $('#output pre, #output .hash-output');
        if (hashOutput.length > 0) {
            commandContent = hashOutput.text();
        } else {
            showToast('Nothing to copy');
            return;
        }
    }
    
    if (commandContent && commandContent.trim()) {
        var tempTextarea = $('<textarea>').val(commandContent).appendTo('body').css({
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

function downloadDockerRun() {
    var commandContent = window.lastDockerRunCommand || '';
    
    if (!commandContent) {
        var hashOutput = $('#output pre, #output .hash-output');
        if (hashOutput.length > 0) {
            commandContent = hashOutput.text();
        } else {
            showToast('No Docker run command to download');
            return;
        }
    }
    
    if (commandContent && commandContent.trim()) {
        var brand = '8gwifi';
        var filename = 'docker-run-commands';
        var today = new Date();
        var dateStr = today.getFullYear() + '-' + 
                     String(today.getMonth() + 1).padStart(2, '0') + '-' + 
                     String(today.getDate()).padStart(2, '0');
        var downloadFilename = brand + '-' + filename + '-' + dateStr + '.sh';
        
        var blob = new Blob([commandContent], { type: 'text/plain' });
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
        showToast('No Docker run command to download');
    }
}

function shareUrl() {
    var dockerComposeFile = $('#dockerrun').val() || '';
    var dockerRunCommand = window.lastDockerRunCommand || '';
    
    if (!dockerRunCommand) {
        var hashOutput = $('#output pre, #output .hash-output');
        if (hashOutput.length > 0) {
            dockerRunCommand = hashOutput.text();
        } else {
            showToast('No Docker run command to share');
            return;
        }
    }
    
    if (!dockerRunCommand || !dockerRunCommand.trim()) {
        showToast('No Docker run command to share');
        return;
    }
    
    // Collect form data for sharing
    var formData = {
        dockerComposeFile: dockerComposeFile,
        dockerRunCommand: dockerRunCommand
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
                $('#dockerrun').val(formData.dockerComposeFile);
            }
            
            // Display docker run command if available
            if (formData.dockerRunCommand) {
                var commandContent = formData.dockerRunCommand;
                var html = '<div class="result-label"><i class="fas fa-terminal me-1"></i>docker run commands (from shared link)</div>';
                html += '<pre class="hash-output" style="max-height: 500px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                html += escapeHtml(commandContent);
                html += '</pre>';
                html += '<div class="d-flex mt-2" style="gap: 0.5rem;">';
                html += '<button class="btn btn-sm" onclick="copyDockerRun()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button>';
                html += '<button class="btn btn-sm" onclick="downloadDockerRun()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button>';
                html += '<button class="btn btn-sm" onclick="shareUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button>';
                html += '</div>';
                
                window.lastDockerRunCommand = commandContent;
                
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

$(document).ready(function() {
    $('#generatedc').click(function (event) {
        $('#form').delay(200).submit();
    });

    $('#form').submit(function (event) {
        event.preventDefault();
        
        var dockerComposeFile = $('#dockerrun').val().trim();
        if (!dockerComposeFile) {
            showToast('Please enter a Docker Compose file');
            return;
        }
        
        // Show loading state
        $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x text-primary mb-2"></i><p class="text-muted">Converting docker-compose.yml...</p></div>');
        $('#resultPlaceholder').show();
        $('#resultContent').hide();
        
        $.ajax({
            type: "POST",
            url: "DockerFunctionality",
            data: $("#form").serialize(),
            dataType: "text",
            success: function(response) {
                try {
                    var data = typeof response === 'string' ? JSON.parse(response) : response;
                    
                    if (!data.success) {
                        $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>' + (data.errorMessage || 'Error converting file') + '</p></div>');
                        $('#resultPlaceholder').show();
                        $('#resultContent').hide();
                        showToast(data.errorMessage || 'Error converting Docker Compose file');
                        return;
                    }
                    
                    var commandContent = data.dockerComposeYaml || data.dockerRunCommand || '';
                    
                    if (!commandContent) {
                        $('#resultPlaceholder').html('<div class="text-center text-warning"><i class="fas fa-exclamation-triangle fa-2x mb-2"></i><p>No docker run command generated</p></div>');
                        $('#resultPlaceholder').show();
                        $('#resultContent').hide();
                        return;
                    }
                    
                    // Create formatted display
                    var html = '';
                    
                    // Show original docker compose file if available in response
                    if (data.dockerComposeYaml && data.dockerComposeYaml !== commandContent) {
                        // If dockerComposeYaml is different, it might be the original file
                        // Otherwise, dockerComposeYaml contains the command
                    }
                    
                    html += '<div class="result-label"><i class="fas fa-terminal me-1"></i>docker run commands</div>';
                    html += '<pre class="hash-output" style="max-height: 500px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                    html += escapeHtml(commandContent);
                    html += '</pre>';
                    html += '<div class="d-flex mt-2" style="gap: 0.5rem;">';
                    html += '<button class="btn btn-sm" onclick="copyDockerRun()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button>';
                    html += '<button class="btn btn-sm" onclick="downloadDockerRun()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button>';
                    html += '<button class="btn btn-sm" onclick="shareUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button>';
                    html += '</div>';
                    
                    window.lastDockerRunCommand = commandContent;
                    window.lastDockerComposeFile = dockerComposeFile;
                    
                    $('#output').html(html);
                    $('#resultPlaceholder').hide();
                    $('#resultContent').show();
                    
                    showToast('Docker run commands generated successfully!');
                } catch (e) {
                    // Fallback for HTML response (backward compatibility)
                    $('#resultPlaceholder').hide();
                    $('#resultContent').show();
                    $('#output').html(response);
                    
                    if ($('#output textarea').length > 0) {
                        $('#output textarea').addClass('hash-output');
                        var commandText = $('#output textarea').val();
                        window.lastDockerRunCommand = commandText;
                        $('#output textarea').after('<div class="d-flex mt-2" style="gap: 0.5rem;"><button class="btn btn-sm" onclick="copyDockerRun()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button><button class="btn btn-sm" onclick="downloadDockerRun()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button><button class="btn btn-sm" onclick="shareUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button></div>');
                    }
                    
                    showToast('Docker run commands generated successfully!');
                }
            },
            error: function(xhr, status, error) {
                var errorMsg = 'Error converting file. Please try again.';
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
    loadFromUrl();
});
</script>
</div>
<%@ include file="body-close.jsp"%>

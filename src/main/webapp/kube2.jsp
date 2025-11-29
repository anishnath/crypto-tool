<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Kubernetes to Docker Compose Converter Online – Free | 8gwifi.org</title>
    <meta name="description" content="Free online tool to convert Kubernetes resources to Docker Compose files. Generate docker-compose.yml from Pods, Deployments, StatefulSets, and ReplicationControllers.">
    <meta name="keywords" content="kubernetes to docker compose, kubernetes to compose, k8s to docker compose, kubernetes pod to compose, kubernetes deployment to compose">
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/kube2.jsp" />

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Kubernetes to Docker Compose Converter",
        "description": "Free online tool to convert Kubernetes resources to Docker Compose files. Generate docker-compose.yml from Pods, Deployments, StatefulSets, and ReplicationControllers.",
        "url": "https://8gwifi.org/kube2.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
        "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
        "datePublished": "2020-03-17",
        "dateModified": "2025-01-28"
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "How do I convert Kubernetes to Docker Compose?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Paste your Kubernetes YAML (Pod, Deployment, StatefulSet, or ReplicationController) into the input field and click 'Generate Docker Compose'. The tool automatically parses containers, ports, volumes, environment variables, and other configurations from your Kubernetes manifest and converts them into a docker-compose.yml file."
            }
        },{
            "@type": "Question",
            "name": "What Kubernetes resources are supported?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The converter supports Pods, Deployments, StatefulSets, ReplicationControllers, and Services. It extracts container specifications, ports, volumes, environment variables, and other configurations from these resources and maps them to Docker Compose equivalents."
            }
        },{
            "@type": "Question",
            "name": "Why convert Kubernetes to Docker Compose?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Converting Kubernetes manifests to Docker Compose is useful for local development, testing, CI/CD pipelines, or when you need a simpler orchestration solution. Docker Compose is easier to run locally and doesn't require a Kubernetes cluster, making it ideal for development environments."
            }
        },{
            "@type": "Question",
            "name": "What Kubernetes features are converted?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The converter handles containers, images, ports, volumes (PersistentVolumeClaims), environment variables (ConfigMaps/Secrets), restart policies, resource limits, and basic networking. Advanced Kubernetes features like Services, Ingress, and RBAC are simplified or mapped to Docker Compose equivalents."
            }
        },{
            "@type": "Question",
            "name": "Can I convert multi-container Pods?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes! The converter processes all containers in a Pod and creates separate services in the docker-compose.yml file. Each container becomes a service, maintaining their relationships and shared configurations like volumes and networks."
            }
        }]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #ec4899;
            --theme-secondary: #db2777;
            --theme-gradient: linear-gradient(135deg, #ec4899 0%, #db2777 100%);
            --theme-light: #fdf2f8;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(236, 72, 153, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(236, 72, 153, 0.25);
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
            box-shadow: 0 2px 8px rgba(236, 72, 153, 0.2);
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

            function copyDockerCompose() {
                var composeContent = window.lastDockerComposeYaml || '';
                
                if (!composeContent) {
                    var hashOutput = $('#output pre, #output .hash-output, #output textarea');
                    if (hashOutput.length > 0) {
                        composeContent = hashOutput.first().text() || hashOutput.first().val();
                    } else {
                        showToast('Nothing to copy');
                        return;
                    }
                }
                
                if (composeContent && composeContent.trim()) {
                    var tempTextarea = $('<textarea>').val(composeContent).appendTo('body').css({
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
                var composeContent = window.lastDockerComposeYaml || '';
                
                if (!composeContent) {
                    var hashOutput = $('#output pre, #output .hash-output, #output textarea');
                    if (hashOutput.length > 0) {
                        composeContent = hashOutput.first().text() || hashOutput.first().val();
                    } else {
                        showToast('No Docker Compose file to download');
                        return;
                    }
                }
                
                if (composeContent && composeContent.trim()) {
                    var brand = '8gwifi';
                    var filename = 'docker-compose';
                    var today = new Date();
                    var dateStr = today.getFullYear() + '-' + 
                                 String(today.getMonth() + 1).padStart(2, '0') + '-' + 
                                 String(today.getDate()).padStart(2, '0');
                    var downloadFilename = brand + '-' + filename + '-' + dateStr + '.yaml';
                    
                    var blob = new Blob([composeContent], { type: 'text/yaml' });
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
                    showToast('No Docker Compose file to download');
                }
            }

            function shareKubernetesUrl() {
                var kubernetesManifest = $('#kubestuff').val() || '';
                var composeContent = window.lastDockerComposeYaml || '';
                
                if (!composeContent) {
                    var hashOutput = $('#output pre, #output .hash-output, #output textarea');
                    if (hashOutput.length > 0) {
                        composeContent = hashOutput.first().text() || hashOutput.first().val();
                    } else {
                        showToast('No Docker Compose file to share');
                        return;
                    }
                }
                
                if (!composeContent || !composeContent.trim()) {
                    showToast('No Docker Compose file to share');
                    return;
                }
                
                var formData = {
                    kubernetesManifest: kubernetesManifest,
                    dockerComposeFile: composeContent
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
                $('#resultPlaceholder').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x text-primary mb-2"></i><p class="text-muted">Converting to Docker Compose...</p></div>');
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
                                showToast(data.errorMessage || 'Error converting to Docker Compose');
                                return;
                            }
                            
                            var composeContent = data.dockerComposeFile || '';
                            
                            if (!composeContent) {
                                $('#resultPlaceholder').html('<div class="text-center text-warning"><i class="fas fa-exclamation-triangle fa-2x mb-2"></i><p>No Docker Compose file generated</p></div>');
                                $('#resultPlaceholder').show();
                                $('#resultContent').hide();
                                return;
                            }
                            
                            // Store for copy/download/share
                            window.lastDockerComposeYaml = composeContent;
                            window.lastKubernetesManifest = data.kubernetesManifest || '';
                            
                            // Create formatted display
                            var html = '<div class="result-label"><i class="fab fa-docker me-1"></i>docker-compose.yml</div>';
                            html += '<pre class="hash-output" style="max-height: 500px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                            html += escapeHtml(composeContent);
                            html += '</pre>';
                            html += '<div class="d-flex mt-2" style="gap: 0.5rem;">';
                            html += '<button class="btn btn-sm" onclick="copyDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button>';
                            html += '<button class="btn btn-sm" onclick="downloadDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button>';
                            html += '<button class="btn btn-sm" onclick="shareKubernetesUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button>';
                            html += '</div>';
                            
                            $('#output').html(html);
                            $('#resultPlaceholder').hide();
                            $('#resultContent').show();
                            showToast('Docker Compose file generated successfully!');
                        } catch (e) {
                            // Fallback for HTML response (backward compatibility)
                            $('#output').empty();
                            $('#output').append(response);
                            $('#resultPlaceholder').hide();
                            $('#resultContent').show();
                            showToast('Docker Compose file generated successfully!');
                        }
                    },
                    error: function() {
                        $('#resultPlaceholder').html('<div class="text-center text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>Error converting. Please try again.</p></div>');
                        $('#resultPlaceholder').show();
                        $('#resultContent').hide();
                        showToast('Error converting to Docker Compose');
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
        <h1 class="h4 mb-0">Kubernetes to Docker Compose Converter</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-cube"></i> Kubernetes</span>
            <span class="info-badge"><i class="fas fa-exchange-alt"></i> Converter</span>
            <span class="info-badge"><i class="fab fa-docker"></i> Compose</span>
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
                <h5><i class="fas fa-cube me-2"></i>Kubernetes Resources</h5>
            </div>
            <div class="card-body">
                <form id="form" method="POST">
                    <input type="hidden" name="methodName" id="methodName" value="KUBE_2_COMPOSE">

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-code me-1"></i>Paste Kubernetes YAML</div>
                        <textarea class="form-control" name="kubestuff" id="kubestuff" rows="15" placeholder="apiVersion: v1\nkind: Pod\nmetadata:\n  name: nginx" style="font-family: 'Courier New', monospace; font-size: 0.85rem;">
---
apiVersion: v1
kind: Pod
metadata:
  annotations:
    generated: by 8gwifi.org
  labels:
    app: nginx
    env: staging
  name: demo
  namespace: default
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: demo
    ports:
    - containerPort: 80
      name: http
      protocol: TCP
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  terminationGracePeriodSeconds: 0

#This is Deployment Configuration Kube definition
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  annotations:
    com.example.empty-label: com.example.empty-label
    generated.by: 8gwifi.org
    com.example.number: '42'
    com.example.description: Accounting webapp
  labels:
    app: demo.25
  name: deployment.name.84
  namespace: default
spec:
  replicas: 6
  revisionHistoryLimit: 1
  selector:
    matchLabels:
      app: demo.25
  template:
    metadata:
      labels:
        app: demo.25
      namespace: default
    spec:
      containers:
      - command:
        - /code/entrypoint.sh
        - -p
        - '3000'
        env:
        - name: RACK_ENV
          value: development
        - name: SHOW
          value: 'true'
        - name: SESSION_SECRET
        - name: BAZ
          value: '3'
        envFrom:
          configMapRef:
            name: env_file_from_configmap_4
        image: redis
        imagePullPolicy: IfNotPresent
        livenessProbe:
          exec:
            command:
            - echo
            - '"hello world"'
          failureThreshold: 3
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        name: my-web-container
        ports:
        - containerPort: 3000
          name: portname.0
          protocol: tcp
        - containerPort: 8000
          name: portname.2
          protocol: tcp
        - containerPort: 22
          name: portname.4
          protocol: tcp
        securityContext:
          capabilities:
            add:
            - ALL
            drop:
            - NET_ADMIN
            - SYS_ADMIN
          privileged: true
          runAsGroup: 1000
          runAsUser: 1000
          seLinuxOptions:
            level: s0:c100,c200
            type: svirt_apache_t
        stdin: true
        tty: true
        volumeDevices:
        - devicePath: /dev/ttyUSB0
          name: mydevice0
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: pvo.0
        - mountPath: /var/lib/mysql
          name: pvo.1
        - mountPath: /code
          name: pvo.2
        - mountPath: /var/www/html
          name: pvo.3
        - mountPath: /etc/configs/
          name: pvo.4
          readOnly: true
        - mountPath: /var/lib/mysql
          name: pvo.5
        - mountPath: /run
          name: pvotmpfs_0
        - mountPath: /tmp
          name: pvotmpfs_1
        workingDir: /code
      dnsConfig:
        nameservers:
        - 8.8.8.8
        - 9.9.9.9
        searches:
        - dc1.example.com
        - dc2.example.com
      hostAliases:
      - hostnames:
        - somehost
        ip: 162.242.195.82
      - hostnames:
        - otherhost
        ip: 50.31.209.229
      hostPID: true
      hostname: foo
      nodeSelector:
        node: foo
      restartPolicy: OnFailure
      subdomain: foo.com
      terminationGracePeriodSeconds: 30
      volumes:
      - name: pvo.1
        persistentVolumeClaim:
          claimName: claimname.0
      - name: pvo.2
        persistentVolumeClaim:
          claimName: claimname.1
      - name: pvo.3
        persistentVolumeClaim:
          claimName: claimname.2
      - name: pvo.4
        persistentVolumeClaim:
          claimName: claimname.3
      - name: pvo.5
        persistentVolumeClaim:
          claimName: claimname.4
      - hostPath:
          path: /dev/ttyUSB0
        name: mydevice0
      - emptyDir:
          medium: Memory
        name: pvotmpfs_0
      - emptyDir:
          medium: Memory
        name: pvotmpfs_1</textarea>
                        <small class="text-muted d-block mt-2" style="font-size: 0.75rem;">
                            <i class="fas fa-info-circle me-1"></i>Paste your Kubernetes YAML (Pod, Deployment, StatefulSet, etc.)
                        </small>
                    </div>

                    <button type="button" class="btn w-100" id="generatedc" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-magic me-2"></i>Generate Docker Compose
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fab fa-docker me-2"></i>Generated Docker Compose File</h5>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-arrow-left fa-2x text-muted mb-2"></i>
                        <p class="text-muted mb-0">Paste Kubernetes YAML and click Generate to create docker-compose.yml</p>
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
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Kubernetes to Docker Compose Conversion</h5>
    </div>
    <div class="card-body">
        <h6>What is Kubernetes to Docker Compose Conversion?</h6>
        <p>This tool automatically converts Kubernetes resource manifests into Docker Compose YAML format. Instead of manually translating each container specification, volume, and configuration, the converter parses your Kubernetes YAML and generates a complete docker-compose.yml file.</p>

        <h6 class="mt-4">Kubernetes to Docker Compose Mapping</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Kubernetes</th>
                    <th>Docker Compose Equivalent</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>Pod/Deployment</code></td>
                    <td><code>services</code></td>
                    <td>Container definitions</td>
                </tr>
                <tr>
                    <td><code>spec.containers[].image</code></td>
                    <td><code>image</code></td>
                    <td>Container image</td>
                </tr>
                <tr>
                    <td><code>spec.containers[].ports</code></td>
                    <td><code>ports</code></td>
                    <td>Port mappings</td>
                </tr>
                <tr>
                    <td><code>PersistentVolumeClaim</code></td>
                    <td><code>volumes</code></td>
                    <td>Persistent storage</td>
                </tr>
                <tr>
                    <td><code>ConfigMap/Secret</code></td>
                    <td><code>environment</code></td>
                    <td>Environment variables</td>
                </tr>
                <tr>
                    <td><code>Service</code></td>
                    <td><code>networks</code></td>
                    <td>Network connectivity</td>
                </tr>
                <tr>
                    <td><code>restartPolicy</code></td>
                    <td><code>restart</code></td>
                    <td>Restart behavior</td>
                </tr>
                <tr>
                    <td><code>resources.limits</code></td>
                    <td><code>deploy.resources</code></td>
                    <td>Resource constraints</td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">Example Conversion</h6>
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Kubernetes Deployment</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
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
            <div class="col-md-6">
                <p class="small mb-1"><strong>Generated docker-compose.yml</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>version: '3'
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    environment:
      NGINX_HOST: localhost</code></pre>
            </div>
        </div>

        <h6 class="mt-4">Use Cases</h6>
        <ul>
            <li><strong>Local Development:</strong> Run Kubernetes workloads locally with Docker Compose</li>
            <li><strong>CI/CD Pipelines:</strong> Test container configurations without a Kubernetes cluster</li>
            <li><strong>Migration:</strong> Move from Kubernetes to Docker Compose for simpler deployments</li>
            <li><strong>Learning:</strong> Understand the relationship between Kubernetes and Docker Compose</li>
            <li><strong>Testing:</strong> Validate container configurations before deploying to Kubernetes</li>
            <li><strong>Documentation:</strong> Provide Docker Compose examples alongside Kubernetes manifests</li>
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
            <a href="kube1.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt me-1"></i>Compose to Kubernetes</h6>
                <p>Convert Docker Compose to Kubernetes</p>
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
                        <li><strong>Kubernetes YAML:</strong> The original Kubernetes manifest you pasted</li>
                        <li><strong>Docker Compose File:</strong> The generated docker-compose.yml</li>
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
                
                // Populate Kubernetes YAML
                if (formData.kubernetesManifest) {
                    $('#kubestuff').val(formData.kubernetesManifest);
                }
                
                // Display Docker Compose file if available
                if (formData.dockerComposeFile) {
                    var composeContent = formData.dockerComposeFile;
                    var html = '<div class="result-label"><i class="fab fa-docker me-1"></i>docker-compose.yml (from shared link)</div>';
                    html += '<pre class="hash-output" style="max-height: 500px; overflow-y: auto; font-size: 0.85rem; padding: 1rem; margin: 0; white-space: pre-wrap; word-wrap: break-word;">';
                    html += escapeHtml(composeContent);
                    html += '</pre>';
                    html += '<div class="d-flex mt-2" style="gap: 0.5rem;">';
                    html += '<button class="btn btn-sm" onclick="copyDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-copy me-1"></i>Copy</button>';
                    html += '<button class="btn btn-sm" onclick="downloadDockerCompose()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-download me-1"></i>Download</button>';
                    html += '<button class="btn btn-sm" onclick="shareKubernetesUrl()" style="background: var(--theme-gradient); color: white; flex: 1;"><i class="fas fa-share-alt me-1"></i>Share</button>';
                    html += '</div>';
                    
                    window.lastDockerComposeYaml = composeContent;
                    
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
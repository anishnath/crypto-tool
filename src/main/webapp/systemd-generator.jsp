<!DOCTYPE html>
<html>

<head>
    <title>Systemd Service Generator Online – Advanced & Free | 8gwifi.org</title>
    <meta name="description"
        content="Create hardened Systemd service and timer files online. Advanced features: Security hardening (PrivateTmp, ProtectSystem), Dependencies (Requires/After), and Cron-like timers. Free DevOps tool.">
    <meta name="keywords"
        content="systemd generator, systemd service file, linux service generator, systemd timer generator, systemd hardening, devops tools">
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Advanced Systemd Generator",
      "description": "Professional tool to generate secure Linux service and timer units.",
      "url": "https://8gwifi.org/systemd-generator.jsp",
      "applicationCategory": "DevOpsApplication",
      "operatingSystem": "Linux",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
      "author": {"@type": "Person", "name": "Anish Nath", "url": "https://8gwifi.org"},
      "datePublished": "2024-01-15",
      "dateModified": "2025-11-29"
    }
    </script>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "What is the difference between a Service and a Timer?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "A Service unit (.service) defines how to start and manage a process. A Timer unit (.timer) schedules when that service should run, acting as a modern replacement for Cron jobs."
          }
        },
        {
          "@type": "Question",
          "name": "Why should I use Security Hardening options?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Options like 'PrivateTmp' and 'ProtectSystem' sandbox your service, limiting the damage if the service is compromised. It's a best practice for production environments."
          }
        }
      ]
    }
    </script>
        <style>
            :root {
                --theme-primary: #dc2626;
                --theme-secondary: #ef4444;
                --theme-gradient: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
                --theme-light: #fef2f2;
            }

            .tool-card {
                border: none;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            }

            .card-header-custom {
                background: var(--theme-gradient);
                color: white;
                font-weight: 600;
            }

            .form-section {
                background-color: var(--theme-light);
                padding: 1rem;
                border-radius: 0.5rem;
                margin-bottom: 1rem;
            }

            .form-section-title {
                color: var(--theme-primary);
                font-weight: 700;
                margin-bottom: 1rem;
                display: flex;
                align-items: center;
            }

            .config-preview {
                background: #1e293b;
                color: #e2e8f0;
                padding: 1rem;
                border-radius: 4px;
                font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
                font-size: 0.85rem;
                white-space: pre-wrap;
                min-height: 300px;
                border: 1px solid #334155;
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
                background-color: var(--theme-light);
                color: var(--theme-primary);
                padding: 0.25rem 0.5rem;
                border-radius: 4px;
                font-size: 0.75rem;
                font-weight: 600;
                margin-right: 0.5rem;
            }

            .sticky-preview {
                position: sticky;
                top: 80px;
            }
        </style>
</head>

<%@ include file="body-script.jsp" %>
    <%@ include file="devops-tools-navbar.jsp" %>

        <div class="container-fluid px-lg-5 mt-4">

            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 mb-0">Systemd Service Generator</h1>
                    <div class="mt-2">
                        <span class="info-badge"><i class="fas fa-shield-alt"></i> Hardened Security</span>
                        <span class="info-badge"><i class="fas fa-clock"></i> Timer/Cron Support</span>
                        <span class="info-badge"><i class="fas fa-project-diagram"></i> Dependency Mgmt</span>
                    </div>
                </div>
                <div class="eeat-badge">
                    <i class="fas fa-user-check"></i>
                    <span>Anish Nath</span>
                </div>
            </div>

            <div class="row">
                <!-- Left Column: Inputs -->
                <div class="col-lg-5">
                    <div class="card tool-card mb-4">
                        <div class="card-header card-header-custom">
                            <i class="fas fa-cogs mr-2"></i> Service Configuration
                        </div>
                        <div class="card-body">
                            <form id="systemdForm">

                                <!-- Basic Info -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-info-circle mr-2"></i> Basic Info
                                    </div>
                                    <div class="form-group">
                                        <label>Service Name</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="serviceName" value="myapp">
                                            <div class="input-group-append">
                                                <span class="input-group-text">.service</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Description</label>
                                        <input type="text" class="form-control" id="description"
                                            value="My Application Service">
                                    </div>
                                    <div class="form-group">
                                        <label>Command (ExecStart)</label>
                                        <input type="text" class="form-control" id="execStart"
                                            value="/usr/bin/python3 /opt/app/main.py">
                                    </div>
                                </div>

                                <!-- Execution Context -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-user-cog mr-2"></i> Execution Context
                                    </div>
                                    <div class="form-row">
                                        <div class="col">
                                            <label>User</label>
                                            <input type="text" class="form-control form-control-sm" id="user"
                                                value="root">
                                        </div>
                                        <div class="col">
                                            <label>Group</label>
                                            <input type="text" class="form-control form-control-sm" id="group"
                                                value="root">
                                        </div>
                                    </div>
                                    <div class="form-group mt-2">
                                        <label>Working Directory</label>
                                        <input type="text" class="form-control" id="workingDir" value="/opt/app">
                                    </div>
                                    <div class="form-group">
                                        <label>Restart Policy</label>
                                        <select class="form-control" id="restartPolicy">
                                            <option value="always">Always</option>
                                            <option value="on-failure">On Failure</option>
                                            <option value="no">No</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Security Hardening -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-shield-alt mr-2"></i> Security Hardening
                                    </div>
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" class="custom-control-input" id="privateTmp">
                                        <label class="custom-control-label" for="privateTmp">PrivateTmp (Isolate
                                            /tmp)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" class="custom-control-input" id="protectSystem">
                                        <label class="custom-control-label" for="protectSystem">ProtectSystem (Read-only
                                            /usr)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" class="custom-control-input" id="protectHome">
                                        <label class="custom-control-label" for="protectHome">ProtectHome (Hide
                                            /home)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" class="custom-control-input" id="noNewPrivileges">
                                        <label class="custom-control-label" for="noNewPrivileges">NoNewPrivileges
                                            (Prevent sudo)</label>
                                    </div>
                                </div>

                                <!-- Timer / Cron -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <i class="fas fa-clock mr-2"></i> Timer (Cron Replacement)
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableTimer">
                                        <label class="custom-control-label" for="enableTimer">Generate .timer
                                            file</label>
                                    </div>
                                    <div class="collapse" id="timerSettings">
                                        <div class="form-group">
                                            <label>OnCalendar Schedule</label>
                                            <input type="text" class="form-control" id="onCalendar"
                                                value="*-*-* 00:00:00">
                                            <small class="text-muted">Format: DayOfWeek Year-Month-Day
                                                Hour:Minute:Second</small>
                                        </div>
                                    </div>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Preview -->
                <div class="col-lg-7">
                    <div class="sticky-preview">

                        <!-- Service File -->
                        <div class="card tool-card mb-3">
                            <div
                                class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                                <span class="mb-0" id="previewFilename">myapp.service</span>
                                <button class="btn btn-sm btn-light text-dark" onclick="copyService()">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                            </div>
                            <div class="card-body p-0">
                                <div id="serviceOutput" class="config-preview"></div>
                            </div>
                        </div>

                        <!-- Timer File -->
                        <div class="card tool-card mb-3 collapse" id="timerCard">
                            <div
                                class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                                <span class="mb-0" id="previewTimername">myapp.timer</span>
                                <button class="btn btn-sm btn-light text-dark" onclick="copyTimer()">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                            </div>
                            <div class="card-body p-0">
                                <div id="timerOutput" class="config-preview"></div>
                            </div>
                        </div>

                        <!-- Instructions -->
                        <div class="card tool-card mt-4">
                            <div class="card-header bg-light">
                                <h5 class="mb-0"><i class="fas fa-terminal mr-2"></i>Installation</h5>
                            </div>
                            <div class="card-body">
                                <ol class="pl-3 mb-0">
                                    <li>Save file to
                                        <code>/etc/systemd/system/<span class="filename-display">myapp.service</span></code>
                                    </li>
                                    <li id="timerInstruction" class="d-none">Save timer to
                                        <code>/etc/systemd/system/<span class="filename-display">myapp.timer</span></code>
                                    </li>
                                    <li>Reload systemd: <code>sudo systemctl daemon-reload</code></li>
                                    <li>Start service:
                                        <code>sudo systemctl start <span class="filename-display">myapp</span></code>
                                    </li>
                                    <li>Enable on boot:
                                        <code>sudo systemctl enable <span class="filename-display">myapp</span></code>
                                    </li>
                                </ol>
                            </div>
                        </div>

                        <!-- Share URL Modal -->
                        <div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
                            <div class="modal-dialog modal-lg" role="document">
                                <div class="modal-content">
                                    <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                                        <h5 class="modal-title">
                                            <i class="fas fa-share-alt"></i> Share Configuration
                                        </h5>
                                        <button type="button" class="close text-white" data-dismiss="modal">
                                            <span>&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="input-group mb-3">
                                            <input type="text" class="form-control" id="shareUrlText" readonly>
                                            <div class="input-group-append">
                                                <button class="btn btn-success" id="copyShareUrl">
                                                    <i class="fas fa-copy"></i> Copy
                                                </button>
                                            </div>
                                        </div>
                                        <p class="text-muted small mb-0">
                                            <i class="fas fa-info-circle"></i> Anyone with this link can view this
                                            configuration.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-3 text-right">
                            <%@ include file="footer_adsense.jsp" %>
                        </div>
                    </div>
                </div>
            </div>


        </div>

        <script>
            function generateConfig() {
                const name = document.getElementById('serviceName').value || 'myapp';
                const desc = document.getElementById('description').value;
                const exec = document.getElementById('execStart').value;
                const user = document.getElementById('user').value;
                const group = document.getElementById('group').value;
                const dir = document.getElementById('workingDir').value;
                const restart = document.getElementById('restartPolicy').value;

                // Hardening
                const privateTmp = document.getElementById('privateTmp').checked;
                const protectSystem = document.getElementById('protectSystem').checked;
                const protectHome = document.getElementById('protectHome').checked;
                const noNewPrivileges = document.getElementById('noNewPrivileges').checked;

                // Timer
                const enableTimer = document.getElementById('enableTimer').checked;
                const onCalendar = document.getElementById('onCalendar').value;

                // Update filenames
                document.getElementById('previewFilename').textContent = name + '.service';
                document.getElementById('previewTimername').textContent = name + '.timer';
                document.querySelectorAll('.filename-display').forEach(el => el.textContent = name);

                // Generate Service
                let config = `[Unit]
Description=${desc}
After=network.target

[Service]
User=${user}
Group=${group}
WorkingDirectory=${dir}
ExecStart=${exec}
Restart=${restart}
`;

                if (privateTmp) config += `PrivateTmp=true\n`;
                if (protectSystem) config += `ProtectSystem=full\n`;
                if (protectHome) config += `ProtectHome=true\n`;
                if (noNewPrivileges) config += `NoNewPrivileges=true\n`;

                config += `
[Install]
WantedBy=multi-user.target`;

                document.getElementById('serviceOutput').textContent = config;

                // Generate Timer
                if (enableTimer) {
                    let timerConfig = `[Unit]
Description=Timer for ${desc}

[Timer]
OnCalendar=${onCalendar}
Unit=${name}.service

[Install]
WantedBy=timers.target`;
                    document.getElementById('timerOutput').textContent = timerConfig;
                    $('#timerCard').collapse('show');
                    $('#timerInstruction').removeClass('d-none');
                } else {
                    $('#timerCard').collapse('hide');
                    $('#timerInstruction').addClass('d-none');
                }
            }

            // Event Listeners
            const inputs = document.querySelectorAll('input, select, textarea');
            inputs.forEach(input => input.addEventListener('input', generateConfig));
            inputs.forEach(input => input.addEventListener('change', generateConfig));

            document.getElementById('enableTimer').addEventListener('change', function () {
                if (this.checked) {
                    $('#timerSettings').collapse('show');
                } else {
                    $('#timerSettings').collapse('hide');
                }
                generateConfig();
            });

            function copyService() {
                const text = document.getElementById('serviceOutput').textContent;
                navigator.clipboard.writeText(text).then(() => {
                    // Toast logic here
                });
            }

            function copyTimer() {
                const text = document.getElementById('timerOutput').textContent;
                navigator.clipboard.writeText(text).then(() => {
                    // Toast logic here
                });
            }
            // Initialize
            loadFromUrl();

            function shareUrl() {
                const formData = {
                    serviceName: document.getElementById('serviceName').value,
                    description: document.getElementById('description').value,
                    execStart: document.getElementById('execStart').value,
                    user: document.getElementById('user').value,
                    group: document.getElementById('group').value,
                    workingDir: document.getElementById('workingDir').value,
                    restartPolicy: document.getElementById('restartPolicy').value,

                    // Hardening
                    privateTmp: document.getElementById('privateTmp').checked,
                    protectSystem: document.getElementById('protectSystem').checked,
                    protectHome: document.getElementById('protectHome').checked,
                    noNewPrivileges: document.getElementById('noNewPrivileges').checked,

                    // Timer
                    enableTimer: document.getElementById('enableTimer').checked,
                    onCalendar: document.getElementById('onCalendar').value
                };

                try {
                    const jsonData = JSON.stringify(formData);
                    const base64Encoded = btoa(unescape(encodeURIComponent(jsonData)));
                    const urlEncoded = encodeURIComponent(base64Encoded);
                    const shareUrl = window.location.origin + window.location.pathname + '?data=' + urlEncoded;

                    document.getElementById('shareUrlText').value = shareUrl;
                    $('#shareUrlModal').modal('show');
                } catch (e) {
                    console.error('Error generating share URL:', e);
                }
            }

            function loadFromUrl() {
                const urlParams = new URLSearchParams(window.location.search);
                const dataParam = urlParams.get('data');

                if (dataParam) {
                    try {
                        const base64Decoded = decodeURIComponent(dataParam);
                        const jsonData = decodeURIComponent(escape(atob(base64Decoded)));
                        const formData = JSON.parse(jsonData);

                        document.getElementById('serviceName').value = formData.serviceName || 'myapp';
                        document.getElementById('description').value = formData.description || 'My Application Service';
                        document.getElementById('execStart').value = formData.execStart || '/usr/bin/python3 /opt/myapp/main.py';
                        document.getElementById('user').value = formData.user || 'www-data';
                        document.getElementById('group').value = formData.group || 'www-data';
                        document.getElementById('workingDir').value = formData.workingDir || '/opt/myapp';
                        document.getElementById('restartPolicy').value = formData.restartPolicy || 'always';

                        document.getElementById('privateTmp').checked = formData.privateTmp || false;
                        document.getElementById('protectSystem').checked = formData.protectSystem || false;
                        document.getElementById('protectHome').checked = formData.protectHome || false;
                        document.getElementById('noNewPrivileges').checked = formData.noNewPrivileges || false;

                        document.getElementById('enableTimer').checked = formData.enableTimer || false;
                        if (formData.enableTimer) $('#timerSettings').collapse('show');
                        document.getElementById('onCalendar').value = formData.onCalendar || '*-*-* 00:00:00';

                    } catch (e) {
                        console.error('Error loading from URL:', e);
                    }
                }
                generateConfig();
            }

            // Copy share URL button
            document.getElementById('copyShareUrl').addEventListener('click', function () {
                const shareUrl = document.getElementById('shareUrlText').value;
                navigator.clipboard.writeText(shareUrl).then(() => {
                    const btn = this;
                    const originalText = btn.innerHTML;
                    btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                    btn.classList.remove('btn-success');
                    btn.classList.add('btn-dark');
                    setTimeout(function () {
                        btn.innerHTML = originalText;
                        btn.classList.remove('btn-dark');
                        btn.classList.add('btn-success');
                    }, 2000);
                });
            });

            // Initial Run
            generateConfig();
        </script>

        <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="footer_adsense.jsp" %>
            <%@ include file="thanks.jsp" %>
                <hr>
                <%@ include file="addcomments.jsp" %>
                    </div>
                    <%@ include file="body-close.jsp" %>
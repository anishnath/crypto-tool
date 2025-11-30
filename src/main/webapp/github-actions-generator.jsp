<!DOCTYPE html>
<html>

<head>
    <title>GitHub Actions Workflow Generator – Matrix Builds & Deployments | 8gwifi.org</title>
    <meta name="description"
        content="Generate GitHub Actions workflows with matrix builds, caching, artifacts, and deployment configurations. Free CI/CD pipeline generator for GitHub.">
    <meta name="keywords"
        content="github actions, ci/cd, workflow generator, matrix build, github pipeline, continuous integration">
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {"@context":"https://schema.org","@type":"WebApplication","name":"GitHub Actions Generator","description":"Generate production-ready GitHub Actions workflows.","url":"https://8gwifi.org/github-actions-generator.jsp","author":{"@type":"Person","name":"Anish Nath"},"datePublished":"2025-01-15"}
    </script>
        <style>
            :root {
                --theme-primary: #4f46e5;
                --theme-secondary: #4b5563;
                --theme-gradient: linear-gradient(135deg, #4b5563 0%, #4f46e5 100%);
                --theme-light: #e0e7ff
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
                margin-bottom: 1rem
            }

            .code-preview {
                background: #1e293b;
                color: #e2e8f0;
                padding: 1rem;
                border-radius: 4px;
                font-family: monospace;
                font-size: .85rem;
                white-space: pre-wrap;
                min-height: 500px;
                max-height: 700px;
                overflow-y: auto
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
        </style>
</head>
<%@ include file="body-script.jsp" %>
    <%@ include file="devops-tools-navbar.jsp" %>

        <div class="container-fluid px-lg-5 mt-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 mb-0">GitHub Actions Workflow Generator</h1>
                </div>
                <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
            </div>

            <div class="row">
                <div class="col-lg-5">
                    <div class="card tool-card mb-4">
                        <div class="card-header card-header-custom"><i class="fab fa-github mr-2"></i> Workflow
                            Configuration</div>
                        <div class="card-body">
                            <form id="workflowForm">
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-info"></i> Basic Settings</div>
                                    <div class="form-group">
                                        <label>Workflow Name</label>
                                        <input type="text" class="form-control" id="workflowName"
                                            value="CI/CD Pipeline">
                                    </div>
                                    <div class="form-group">
                                        <label>Language/Framework</label>
                                        <select class="form-control" id="language">
                                            <option value="node">Node.js</option>
                                            <option value="python">Python</option>
                                            <option value="java">Java</option>
                                            <option value="go">Go</option>
                                            <option value="dotnet">.NET</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-bolt"></i> Triggers</div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="triggerPush" checked>
                                        <label class="custom-control-label" for="triggerPush">Push</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="triggerPR" checked>
                                        <label class="custom-control-label" for="triggerPR">Pull Request</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="triggerSchedule">
                                        <label class="custom-control-label" for="triggerSchedule">Schedule
                                            (Cron)</label>
                                    </div>
                                    <div id="scheduleInput" style="display:none">
                                        <input type="text" class="form-control mt-2" id="cronExpression"
                                            value="0 0 * * *" placeholder="0 0 * * *">
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-th"></i> Matrix Strategy</div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableMatrix" checked>
                                        <label class="custom-control-label" for="enableMatrix">Enable Matrix
                                            Builds</label>
                                    </div>
                                    <div id="matrixSettings">
                                        <label>OS Selection</label>
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input matrix-os" id="osUbuntu"
                                                value="ubuntu-latest" checked>
                                            <label class="custom-control-label" for="osUbuntu">Ubuntu</label>
                                        </div>
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input matrix-os" id="osWindows"
                                                value="windows-latest">
                                            <label class="custom-control-label" for="osWindows">Windows</label>
                                        </div>
                                        <div class="custom-control custom-checkbox mb-3">
                                            <input type="checkbox" class="custom-control-input matrix-os" id="osMacos"
                                                value="macos-latest">
                                            <label class="custom-control-label" for="osMacos">macOS</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-folder"></i> Advanced Features
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableCaching" checked>
                                        <label class="custom-control-label" for="enableCaching">Dependency
                                            Caching</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableArtifacts">
                                        <label class="custom-control-label" for="enableArtifacts">Upload
                                            Artifacts</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableDocker">
                                        <label class="custom-control-label" for="enableDocker">Docker Build &
                                            Push</label>
                                    </div>
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" class="custom-control-input" id="enableDeploy">
                                        <label class="custom-control-label" for="enableDeploy">Deploy to Cloud</label>
                                    </div>
                                    <div id="deploySettings" style="display:none" class="mt-2">
                                        <select class="form-control" id="deployTarget">
                                            <option value="vercel">Vercel</option>
                                            <option value="netlify">Netlify</option>
                                            <option value="aws">AWS</option>
                                            <option value="azure">Azure</option>
                                        </select>
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
                                <span><i class="fab fa-github mr-2"></i> .github/workflows/main.yml</span>
                                <div>
                                    <button class="btn btn-sm btn-outline-light mr-2" onclick="shareUrl()"><i
                                            class="fas fa-share-alt"></i> Share</button>
                                    <button class="btn btn-sm btn-light text-dark" onclick="copyWorkflow()"><i
                                            class="fas fa-copy"></i> Copy</button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <pre id="workflowOutput" class="code-preview mb-0"></pre>
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

        <script>
            const presets = {
                'node-ci': {
                    workflowName: 'Node.js CI',
                    language: 'node',
                    triggerPush: true,
                    triggerPR: true,
                    enableMatrix: true,
                    enableCaching: true,
                    enableArtifacts: false,
                    enableDocker: false,
                    enableDeploy: false,
                    selectedOS: ['ubuntu-latest']
                },
                'python-test': {
                    workflowName: 'Python Tests',
                    language: 'python',
                    triggerPush: true,
                    triggerPR: true,
                    enableMatrix: true,
                    enableCaching: true,
                    enableArtifacts: false,
                    enableDocker: false,
                    enableDeploy: false,
                    selectedOS: ['ubuntu-latest', 'windows-latest']
                },
                'docker-build': {
                    workflowName: 'Docker Build & Push',
                    language: 'node',
                    triggerPush: true,
                    triggerPR: false,
                    enableMatrix: false,
                    enableCaching: false,
                    enableArtifacts: false,
                    enableDocker: true,
                    enableDeploy: false,
                    selectedOS: ['ubuntu-latest']
                },
                'deploy-vercel': {
                    workflowName: 'Deploy to Vercel',
                    language: 'node',
                    triggerPush: true,
                    triggerPR: false,
                    enableMatrix: false,
                    enableCaching: true,
                    enableArtifacts: true,
                    enableDocker: false,
                    enableDeploy: true,
                    selectedOS: ['ubuntu-latest']
                }
            };

            function loadPreset(presetName) {
                const preset = presets[presetName];
                if (!preset) return;

                document.getElementById('workflowName').value = preset.workflowName;
                document.getElementById('language').value = preset.language;
                document.getElementById('triggerPush').checked = preset.triggerPush;
                document.getElementById('triggerPR').checked = preset.triggerPR;
                document.getElementById('enableMatrix').checked = preset.enableMatrix;
                document.getElementById('enableCaching').checked = preset.enableCaching;
                document.getElementById('enableArtifacts').checked = preset.enableArtifacts;
                document.getElementById('enableDocker').checked = preset.enableDocker;
                document.getElementById('enableDeploy').checked = preset.enableDeploy;
                document.getElementById('enableDeploy').dispatchEvent(new Event('change'));

                document.querySelectorAll('.matrix-os').forEach(cb => cb.checked = false);
                if (preset.selectedOS) {
                    preset.selectedOS.forEach(os => {
                        const cb = document.querySelector(`.matrix-os[value="${os}"]`);
                        if (cb) cb.checked = true;
                    });
                }

                generateWorkflow();
            }

            const langConfig = {
                node: { setup: 'node', version: '[16, 18, 20]', cacheKey: 'npm', cachePath: '~/.npm', install: 'npm ci', test: 'npm test', build: 'npm run build' },
                python: { setup: 'python', version: '[3.9, 3.10, 3.11, 3.12]', cacheKey: 'pip', cachePath: '~/.cache/pip', install: 'pip install -r requirements.txt', test: 'pytest', build: '' },
                java: { setup: 'java', version: '[17, 21]', cacheKey: 'maven', cachePath: '~/.m2', install: 'mvn install -DskipTests', test: 'mvn test', build: 'mvn package' },
                go: { setup: 'go', version: '[1.20, 1.21]', cacheKey: 'go', cachePath: '~/go/pkg/mod', install: 'go mod download', test: 'go test ./...', build: 'go build -v ./...' },
                dotnet: { setup: 'dotnet', version: '[6.0, 7.0, 8.0]', cacheKey: 'nuget', cachePath: '~/.nuget/packages', install: 'dotnet restore', test: 'dotnet test', build: 'dotnet build' }
            };

            function generateWorkflow() {
                const name = document.getElementById('workflowName').value;
                const lang = document.getElementById('language').value;
                const config = langConfig[lang];
                const enableMatrix = document.getElementById('enableMatrix').checked;
                const enableCaching = document.getElementById('enableCaching').checked;
                const enableArtifacts = document.getElementById('enableArtifacts').checked;
                const enableDocker = document.getElementById('enableDocker').checked;
                const enableDeploy = document.getElementById('enableDeploy').checked;
                const deployTarget = document.getElementById('deployTarget').value;

                let yml = `name: ${name}\n\n`;
                yml += `on:\n`;
                if (document.getElementById('triggerPush').checked) yml += `  push:\n    branches: [ main, develop ]\n`;
                if (document.getElementById('triggerPR').checked) yml += `  pull_request:\n    branches: [ main ]\n`;
                if (document.getElementById('triggerSchedule').checked) {
                    yml += `  schedule:\n    - cron: '${document.getElementById('cronExpression').value}'\n`;
                }
                yml += `  workflow_dispatch:\n\n`;

                yml += `jobs:\n  build:\n`;

                const selectedOS = Array.from(document.querySelectorAll('.matrix-os:checked')).map(cb => cb.value);
                if (enableMatrix && selectedOS.length > 0) {
                    yml += `    strategy:\n      matrix:\n`;
                    yml += `        os: [${selectedOS.join(', ')}]\n`;
                    yml += `        ${config.setup}-version: ${config.version}\n`;
                    yml += `    runs-on: \${{ matrix.os }}\n\n`;
                } else {
                    yml += `    runs-on: ubuntu-latest\n\n`;
                }

                yml += `    steps:\n`;
                yml += `    - uses: actions/checkout@v4\n\n`;

                const version = enableMatrix ? `\${{ matrix.${config.setup}-version }}` : config.version.replace('[', '').replace(']', '').split(',')[0].trim();
                yml += `    - name: Setup ${config.setup}\n      uses: actions/setup-${config.setup}@v${config.setup === 'node' ? '4' : '5'}\n      with:\n        ${config.setup}-version: ${version}\n\n`;

                if (enableCaching) {
                    yml += `    - name: Cache dependencies\n      uses: actions/cache@v3\n      with:\n        path: ${config.cachePath}\n        key: \${{ runner.os }}-${config.cacheKey}-\${{ hashFiles('**/package*.json') }}\n        restore-keys: |\n          \${{ runner.os }}-${config.cacheKey}-\n\n`;
                }

                yml += `    - name: Install dependencies\n      run: ${config.install}\n\n`;

                yml += `    - name: Run tests\n      run: ${config.test}\n\n`;

                if (config.build) {
                    yml += `    - name: Build\n      run: ${config.build}\n\n`;
                }

                if (enableArtifacts) {
                    yml += `    - name: Upload artifacts\n      uses: actions/upload-artifact@v4\n      with:\n        name: build-artifacts\n        path: dist/\n\n`;
                }

                if (enableDocker) {
                    yml += `  docker:\n    runs-on: ubuntu-latest\n    needs: build\n    steps:\n`;
                    yml += `    - uses: actions/checkout@v4\n`;
                    yml += `    - name: Build Docker Image\n      run: docker build -t myapp:latest .\n`;
                    yml += `    - name: Push to Registry\n      run: |\n        echo "\${{ secrets.DOCKER_PASSWORD }}" | docker login -u "\${{ secrets.DOCKER_USERNAME }}" --password-stdin\n        docker push myapp:latest\n\n`;
                }

                if (enableDeploy) {
                    yml += `  deploy:\n    runs-on: ubuntu-latest\n    needs: build\n    steps:\n`;
                    yml += `    - uses: actions/checkout@v4\n`;
                    if (deployTarget === 'vercel') {
                        yml += `    - uses: amondnet/vercel-action@v25\n      with:\n        vercel-token: \${{ secrets.VERCEL_TOKEN }}\n        vercel-org-id: \${{ secrets.VERCEL_ORG_ID }}\n        vercel-project-id: \${{ secrets.VERCEL_PROJECT_ID }}\n`;
                    }
                }

                document.getElementById('workflowOutput').textContent = yml;
            }

            document.getElementById('triggerSchedule').addEventListener('change', function () {
                document.getElementById('scheduleInput').style.display = this.checked ? 'block' : 'none';
            });

            document.getElementById('enableDeploy').addEventListener('change', function () {
                document.getElementById('deploySettings').style.display = this.checked ? 'block' : 'none';
            });

            document.querySelectorAll('input, select').forEach(el => {
                el.addEventListener('input', generateWorkflow);
                el.addEventListener('change', generateWorkflow);
            });

            function copyWorkflow() {
                navigator.clipboard.writeText(document.getElementById('workflowOutput').textContent).then(() => {
                    const btn = document.querySelector('.btn-light');
                    const orig = btn.innerHTML;
                    btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                    setTimeout(() => btn.innerHTML = orig, 2000);
                });
            }

            function shareUrl() {
                const formData = {
                    workflowName: document.getElementById('workflowName').value,
                    language: document.getElementById('language').value,
                    triggerPush: document.getElementById('triggerPush').checked,
                    triggerPR: document.getElementById('triggerPR').checked,
                    triggerSchedule: document.getElementById('triggerSchedule').checked,
                    cronExpression: document.getElementById('cronExpression').value,
                    enableMatrix: document.getElementById('enableMatrix').checked,
                    enableCaching: document.getElementById('enableCaching').checked,
                    enableArtifacts: document.getElementById('enableArtifacts').checked,
                    enableDocker: document.getElementById('enableDocker').checked,
                    enableDeploy: document.getElementById('enableDeploy').checked,
                    deployTarget: document.getElementById('deployTarget').value,
                    selectedOS: Array.from(document.querySelectorAll('.matrix-os:checked')).map(cb => cb.value)
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
                        if (formData.selectedOS) {
                            formData.selectedOS.forEach(os => {
                                const cb = document.querySelector(`.matrix-os[value="${os}"]`);
                                if (cb) cb.checked = true;
                            });
                        }
                        generateWorkflow();
                    } catch (e) {
                        console.error('Error loading:', e);
                        generateWorkflow();
                    }
                } else {
                    generateWorkflow();
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
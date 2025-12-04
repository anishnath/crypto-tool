<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <title>GitLab CI/CD Pipeline Generator – Docker, Auto DevOps & Security – Free | 8gwifi.org</title>
    <meta name="description"
        content="Generate GitLab CI/CD pipelines with Docker-in-Docker, caching, artifacts, and security scanning. Free .gitlab-ci.yml generator.">
    <link rel="canonical" href="https://8gwifi.org/gitlab-ci-generator.jsp" />
    <meta property="og:type" content="website" />
    <meta property="og:title" content="GitLab CI/CD Pipeline Generator – Docker & Deployments" />
    <meta property="og:description" content="Create robust .gitlab-ci.yml with stages, caching, artifacts, Docker runners, and deployments. Free, no signup." />
    <meta property="og:url" content="https://8gwifi.org/gitlab-ci-generator.jsp" />
    <meta property="og:site_name" content="8gwifi.org" />
    <meta property="og:image" content="https://8gwifi.org/images/site/gitlab-ci.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="GitLab CI/CD Pipeline Generator – Docker & Deployments" />
    <meta name="twitter:description" content="Create robust .gitlab-ci.yml with stages, caching, artifacts, Docker runners, and deployments. Free, no signup." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/gitlab-ci.png" />
    <meta name="keywords" content="gitlab ci, gitlab pipeline, ci/cd, gitlab-ci.yml, docker in docker, auto devops, gitlab cache, gitlab artifacts">
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {"@context":"https://schema.org","@type":"WebApplication","name":"GitLab CI/CD Generator","description":"Generate production-ready GitLab CI/CD pipelines.","url":"https://8gwifi.org/gitlab-ci-generator.jsp","author":{"@type":"Person","name":"Anish Nath"},"datePublished":"2025-01-15","dateModified":"2025-12-01"}
    </script>
        <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question","name": "How do I use Docker runners?","acceptedAnswer": {"@type": "Answer","text": "Select Docker integration; the generator configures image/services and optional DinD."}},
    {"@type": "Question","name": "How do I cache dependencies?","acceptedAnswer": {"@type": "Answer","text": "Enable caching with keys per job or language to reduce pipeline times."}},
    {"@type": "Question","name": "Can I deploy to environments?","acceptedAnswer": {"@type": "Answer","text": "Yes. Add environment jobs with manual approvals and environment URLs as needed."}}
  ]
}
        </script>
        <style>
            :root {
                --theme-primary: #a855f7;
                --theme-secondary: #f97316;
                --theme-gradient: linear-gradient(135deg, #f97316 0%, #a855f7 100%);
                --theme-light: #fdf4ff
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
                    <h1 class="h3 mb-0">GitLab CI/CD Pipeline Generator</h1>
                </div>
                <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
            </div>

            <div class="row">
                <div class="col-lg-5">
                    <div class="card tool-card mb-4">
                        <div class="card-header card-header-custom"><i class="fab fa-gitlab mr-2"></i> Pipeline
                            Configuration</div>
                        <div class="card-body">
                            <form id="pipelineForm">
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-info"></i> Basic Settings</div>
                                    <div class="form-group">
                                        <label>Language/Framework</label>
                                        <select class="form-control" id="language">
                                            <option value="node">Node.js</option>
                                            <option value="python">Python</option>
                                            <option value="java">Java</option>
                                            <option value="go">Go</option>
                                            <option value="dotnet">.NET</option>
                                            <option value="docker">Docker</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Default Image</label>
                                        <input type="text" class="form-control" id="defaultImage" value="node:20">
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-layer-group"></i> Stages</div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input stage-check" id="stageBuild"
                                            value="build" checked>
                                        <label class="custom-control-label" for="stageBuild">Build</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input stage-check" id="stageTest"
                                            value="test" checked>
                                        <label class="custom-control-label" for="stageTest">Test</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input stage-check" id="stageDeploy"
                                            value="deploy">
                                        <label class="custom-control-label" for="stageDeploy">Deploy</label>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fab fa-docker"></i> Docker Integration
                                    </div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableDinD">
                                        <label class="custom-control-label" for="enableDinD">Docker-in-Docker
                                            (DinD)</label>
                                    </div>
                                    <div id="dindSettings" style="display:none">
                                        <div class="form-group">
                                            <label>Registry</label>
                                            <input type="text" class="form-control" id="dockerRegistry"
                                                value="$CI_REGISTRY">
                                        </div>
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="pushToRegistry"
                                                checked>
                                            <label class="custom-control-label" for="pushToRegistry">Push to Container
                                                Registry</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-database"></i> Caching & Artifacts
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableCaching" checked>
                                        <label class="custom-control-label" for="enableCaching">Enable Caching</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableArtifacts"
                                            checked>
                                        <label class="custom-control-label" for="enableArtifacts">Save Artifacts</label>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-shield-alt"></i> Security Scanning
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableSAST">
                                        <label class="custom-control-label" for="enableSAST">SAST (Static
                                            Analysis)</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="enableDependency">
                                        <label class="custom-control-label" for="enableDependency">Dependency
                                            Scanning</label>
                                    </div>
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" class="custom-control-input" id="enableContainer">
                                        <label class="custom-control-label" for="enableContainer">Container
                                            Scanning</label>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-rocket"></i> Deployment</div>
                                    <div class="custom-control custom-switch mb-3">
                                        <input type="checkbox" class="custom-control-input" id="enableEnvDeploy">
                                        <label class="custom-control-label" for="enableEnvDeploy">Environment
                                            Deployment</label>
                                    </div>
                                    <div id="envSettings" style="display:none">
                                        <div class="form-group">
                                            <label>Environment Name</label>
                                            <input type="text" class="form-control" id="envName" value="production">
                                        </div>
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="manualDeploy"
                                                checked>
                                            <label class="custom-control-label" for="manualDeploy">Manual
                                                Deployment</label>
                                        </div>
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
                                <span><i class="fab fa-gitlab mr-2"></i> .gitlab-ci.yml</span>
                                <div>
                                    <button class="btn btn-sm btn-outline-light mr-2" onclick="shareUrl()"><i
                                            class="fas fa-share-alt"></i> Share</button>
                                    <button class="btn btn-sm btn-light text-dark" onclick="copyPipeline()"><i
                                            class="fas fa-copy"></i> Copy</button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <pre id="pipelineOutput" class="code-preview mb-0"></pre>
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
                'node-pipeline': {
                    language: 'node',
                    defaultImage: 'node:20',
                    enableDinD: false,
                    enableCaching: true,
                    enableArtifacts: true,
                    enableSAST: false,
                    enableDependency: false,
                    enableContainer: false,
                    enableEnvDeploy: false,
                    selectedStages: ['build', 'test']
                },
                'docker-k8s': {
                    language: 'docker',
                    defaultImage: 'docker:latest',
                    enableDinD: true,
                    pushToRegistry: true,
                    enableCaching: false,
                    enableArtifacts: false,
                    enableSAST: false,
                    enableDependency: false,
                    enableContainer: true,
                    enableEnvDeploy: true,
                    envName: 'production',
                    manualDeploy: true,
                    selectedStages: ['build', 'deploy']
                },
                'python-test': {
                    language: 'python',
                    defaultImage: 'python:3.12',
                    enableDinD: false,
                    enableCaching: true,
                    enableArtifacts: false,
                    enableSAST: false,
                    enableDependency: true,
                    enableContainer: false,
                    enableEnvDeploy: false,
                    selectedStages: ['build', 'test']
                },
                'security-scan': {
                    language: 'node',
                    defaultImage: 'node:20',
                    enableDinD: true,
                    enableCaching: true,
                    enableArtifacts: false,
                    enableSAST: true,
                    enableDependency: true,
                    enableContainer: true,
                    enableEnvDeploy: false,
                    selectedStages: ['build', 'test']
                }
            };

            function loadPreset(presetName) {
                const preset = presets[presetName];
                if (!preset) return;

                document.getElementById('language').value = preset.language;
                document.getElementById('language').dispatchEvent(new Event('change'));

                setTimeout(() => {
                    document.getElementById('defaultImage').value = preset.defaultImage;
                    document.getElementById('enableDinD').checked = preset.enableDinD;
                    document.getElementById('enableDinD').dispatchEvent(new Event('change'));
                    if (preset.pushToRegistry !== undefined) {
                        document.getElementById('pushToRegistry').checked = preset.pushToRegistry;
                    }
                    document.getElementById('enableCaching').checked = preset.enableCaching;
                    document.getElementById('enableArtifacts').checked = preset.enableArtifacts;
                    document.getElementById('enableSAST').checked = preset.enableSAST;
                    document.getElementById('enableDependency').checked = preset.enableDependency;
                    document.getElementById('enableContainer').checked = preset.enableContainer;
                    document.getElementById('enableEnvDeploy').checked = preset.enableEnvDeploy;
                    document.getElementById('enableEnvDeploy').dispatchEvent(new Event('change'));
                    if (preset.envName) {
                        document.getElementById('envName').value = preset.envName;
                    }
                    if (preset.manualDeploy !== undefined) {
                        document.getElementById('manualDeploy').checked = preset.manualDeploy;
                    }

                    document.querySelectorAll('.stage-check').forEach(cb => cb.checked = false);
                    if (preset.selectedStages) {
                        preset.selectedStages.forEach(stage => {
                            const cb = document.querySelector(`.stage-check[value="${stage}"]`);
                            if (cb) cb.checked = true;
                        });
                    }

                    generatePipeline();
                }, 100);
            }

            const langConfig = {
                node: { image: 'node:20', cache: ['node_modules/'], install: 'npm ci', test: 'npm test', build: 'npm run build' },
                python: { image: 'python:3.12', cache: ['.pip'], install: 'pip install -r requirements.txt', test: 'pytest', build: '' },
                java: { image: 'maven:3.9-openjdk-21', cache: ['.m2/repository'], install: 'mvn install -DskipTests', test: 'mvn test', build: 'mvn package' },
                go: { image: 'golang:1.21', cache: ['/go/pkg/mod'], install: 'go mod download', test: 'go test ./...', build: 'go build' },
                dotnet: { image: 'mcr.microsoft.com/dotnet/sdk:8.0', cache: ['.nuget/'], install: 'dotnet restore', test: 'dotnet test', build: 'dotnet build' },
                docker: { image: 'docker:latest', cache: [], install: '', test: '', build: 'docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .' }
            };

            function generatePipeline() {
                const lang = document.getElementById('language').value;
                const config = langConfig[lang];
                const defaultImage = document.getElementById('defaultImage').value || config.image;
                const enableDinD = document.getElementById('enableDinD').checked;
                const enableCaching = document.getElementById('enableCaching').checked;
                const enableArtifacts = document.getElementById('enableArtifacts').checked;
                const enableSAST = document.getElementById('enableSAST').checked;
                const enableDependency = document.getElementById('enableDependency').checked;
                const enableContainer = document.getElementById('enableContainer').checked;
                const enableEnvDeploy = document.getElementById('enableEnvDeploy').checked;
                const envName = document.getElementById('envName').value;
                const manualDeploy = document.getElementById('manualDeploy').checked;

                const selectedStages = Array.from(document.querySelectorAll('.stage-check:checked')).map(cb => cb.value);

                let yml = `# Generated by 8gwifi.org GitLab CI/CD Generator\n`;
                yml += `# Date: ${new Date().toISOString()}\n\n`;

                yml += `image: ${defaultImage}\n\n`;

                if (selectedStages.length > 0) {
                    yml += `stages:\n`;
                    selectedStages.forEach(stage => {
                        yml += `  - ${stage}\n`;
                    });
                    yml += `\n`;
                }

                if (enableDinD) {
                    yml += `services:\n  - docker:dind\n\n`;
                    yml += `variables:\n  DOCKER_HOST: tcp://docker:2376\n  DOCKER_TLS_CERTDIR: "/certs"\n  DOCKER_TLS_VERIFY: 1\n  DOCKER_CERT_PATH: "$DOCKER_TLS_CERTDIR/client"\n\n`;
                }

                if (enableCaching && config.cache.length > 0) {
                    yml += `cache:\n  paths:\n`;
                    config.cache.forEach(path => {
                        yml += `    - ${path}\n`;
                    });
                    yml += `\n`;
                }

                if (selectedStages.includes('build') && config.build) {
                    yml += `build:\n  stage: build\n  script:\n`;
                    if (config.install) yml += `    - ${config.install}\n`;
                    yml += `    - ${config.build}\n`;
                    if (enableArtifacts) {
                        yml += `  artifacts:\n    paths:\n      - dist/\n      - build/\n    expire_in: 1 week\n`;
                    }
                    yml += `\n`;
                }

                if (selectedStages.includes('test') && config.test) {
                    yml += `test:\n  stage: test\n  script:\n`;
                    if (config.install && !selectedStages.includes('build')) yml += `    - ${config.install}\n`;
                    yml += `    - ${config.test}\n`;
                    yml += `  coverage: '/TOTAL.*\\s+(\\d+%)$/'\n\n`;
                }

                if (enableDinD && enableContainer) {
                    yml += `docker_build:\n  stage: build\n  script:\n`;
                    yml += `    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY\n`;
                    yml += `    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .\n`;
                    if (document.getElementById('pushToRegistry').checked) {
                        yml += `    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA\n`;
                        yml += `    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $CI_REGISTRY_IMAGE:latest\n`;
                        yml += `    - docker push $CI_REGISTRY_IMAGE:latest\n`;
                    }
                    yml += `\n`;
                }

                if (enableSAST) {
                    yml += `include:\n  - template: Security/SAST.gitlab-ci.yml\n\n`;
                }
                if (enableDependency) {
                    yml += `include:\n  - template: Security/Dependency-Scanning.gitlab-ci.yml\n\n`;
                }
                if (enableContainer) {
                    yml += `include:\n  - template: Security/Container-Scanning.gitlab-ci.yml\n\n`;
                }

                if (enableEnvDeploy && selectedStages.includes('deploy')) {
                    yml += `deploy_${envName}:\n  stage: deploy\n  script:\n`;
                    yml += `    - echo "Deploying to ${envName}"\n`;
                    yml += `    - # Add your deployment commands here\n`;
                    yml += `  environment:\n    name: ${envName}\n    url: https://example.com\n`;
                    if (manualDeploy) {
                        yml += `  when: manual\n`;
                    }
                    yml += `  only:\n    - main\n`;
                }

                document.getElementById('pipelineOutput').textContent = yml;
            }

            document.getElementById('enableDinD').addEventListener('change', function () {
                document.getElementById('dindSettings').style.display = this.checked ? 'block' : 'none';
                generatePipeline();
            });

            document.getElementById('enableEnvDeploy').addEventListener('change', function () {
                document.getElementById('envSettings').style.display = this.checked ? 'block' : 'none';
                generatePipeline();
            });

            document.getElementById('language').addEventListener('change', function () {
                const config = langConfig[this.value];
                document.getElementById('defaultImage').value = config.image;
                generatePipeline();
            });

            document.querySelectorAll('input, select').forEach(el => {
                el.addEventListener('input', generatePipeline);
                el.addEventListener('change', generatePipeline);
            });

            function copyPipeline() {
                navigator.clipboard.writeText(document.getElementById('pipelineOutput').textContent).then(() => {
                    const btn = document.querySelector('.btn-light');
                    const orig = btn.innerHTML;
                    btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                    setTimeout(() => btn.innerHTML = orig, 2000);
                });
            }

            function shareUrl() {
                const formData = {
                    language: document.getElementById('language').value,
                    defaultImage: document.getElementById('defaultImage').value,
                    enableDinD: document.getElementById('enableDinD').checked,
                    dockerRegistry: document.getElementById('dockerRegistry').value,
                    pushToRegistry: document.getElementById('pushToRegistry').checked,
                    enableCaching: document.getElementById('enableCaching').checked,
                    enableArtifacts: document.getElementById('enableArtifacts').checked,
                    enableSAST: document.getElementById('enableSAST').checked,
                    enableDependency: document.getElementById('enableDependency').checked,
                    enableContainer: document.getElementById('enableContainer').checked,
                    enableEnvDeploy: document.getElementById('enableEnvDeploy').checked,
                    envName: document.getElementById('envName').value,
                    manualDeploy: document.getElementById('manualDeploy').checked,
                    selectedStages: Array.from(document.querySelectorAll('.stage-check:checked')).map(cb => cb.value)
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
                        if (formData.selectedStages) {
                            formData.selectedStages.forEach(stage => {
                                const cb = document.querySelector(`.stage-check[value="${stage}"]`);
                                if (cb) cb.checked = true;
                            });
                        }
                        generatePipeline();
                    } catch (e) {
                        console.error('Error loading:', e);
                        generatePipeline();
                    }
                } else {
                    generatePipeline();
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

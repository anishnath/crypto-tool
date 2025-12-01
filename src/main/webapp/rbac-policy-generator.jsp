<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Kubernetes RBAC Policy Generator – Role, ClusterRole, Binding | 8gwifi.org</title>
        <meta name="description"
            content="Generate Kubernetes RBAC policies visually. Create Roles, ClusterRoles, and Bindings without writing YAML. Free online K8s security tool.">
        <meta name="keywords"
            content="kubernetes rbac generator, k8s role generator, clusterrole builder, rbac policy, kubernetes security, yaml generator">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Kubernetes RBAC Policy Generator",
      "description": "Generate Kubernetes RBAC policies visually. Create Roles, ClusterRoles, and Bindings without writing YAML.",
      "url": "https://8gwifi.org/rbac-policy-generator.jsp",
      "applicationCategory": "DeveloperApplication",
      "operatingSystem": "Any",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      },
      "datePublished": "2025-02-01",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Visual Rule Builder",
        "Role vs ClusterRole Support",
        "Automatic Binding Generation",
        "Real-time YAML Preview"
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

                .rule-item {
                    background: white;
                    border: 1px solid #dee2e6;
                    border-radius: 8px;
                    padding: 1rem;
                    margin-bottom: 0.75rem;
                    position: relative;
                }

                .rule-actions {
                    position: absolute;
                    top: 10px;
                    right: 10px;
                }

                .verb-checkbox {
                    margin-right: 10px;
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
            </style>
    </head>
    <%@ include file="body-script.jsp" %>
        <%@ include file="devops-tools-navbar.jsp" %>

            <div class="container-fluid px-lg-5 mt-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">Kubernetes RBAC Policy Generator</h1>
                        <p class="text-muted mb-0">Visually build Roles, ClusterRoles, and Bindings</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <!-- Preset Templates -->
                <div class="card tool-card mb-4">
                    <div class="card-body">
                        <h6 class="mb-3"><i class="fas fa-magic"></i> Quick Start Presets</h6>
                        <div class="d-flex flex-wrap">
                            <button class="btn btn-outline-primary preset-btn" onclick="loadPreset('view-only')">
                                <i class="fas fa-eye"></i> View Only
                            </button>
                            <button class="btn btn-outline-danger preset-btn" onclick="loadPreset('admin')">
                                <i class="fas fa-user-shield"></i> Cluster Admin
                            </button>
                            <button class="btn btn-outline-success preset-btn" onclick="loadPreset('ci-cd')">
                                <i class="fas fa-robot"></i> CI/CD Deployer
                            </button>
                            <button class="btn btn-outline-info preset-btn" onclick="loadPreset('log-reader')">
                                <i class="fas fa-file-alt"></i> Log Reader
                            </button>
                            <button class="btn btn-outline-warning preset-btn" onclick="loadPreset('secret-manager')">
                                <i class="fas fa-key"></i> Secret Manager
                            </button>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-sliders-h mr-2"></i> Policy
                                Configuration</div>
                            <div class="card-body" style="max-height: 800px; overflow-y: auto;">
                                <form id="rbacForm">
                                    <!-- Basic Configuration -->
                                    <div class="form-section">
                                        <div class="form-section-title"><i class="fas fa-info-circle"></i> Metadata
                                        </div>
                                        <div class="form-group">
                                            <label>Kind</label>
                                            <div class="btn-group btn-group-toggle w-100" data-toggle="buttons">
                                                <label class="btn btn-outline-primary active"
                                                    onclick="updateKind('Role')">
                                                    <input type="radio" name="kind" value="Role" checked> Role
                                                    (Namespaced)
                                                </label>
                                                <label class="btn btn-outline-primary"
                                                    onclick="updateKind('ClusterRole')">
                                                    <input type="radio" name="kind" value="ClusterRole"> ClusterRole
                                                    (Global)
                                                </label>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Name</label>
                                                    <input type="text" class="form-control" id="policyName"
                                                        value="my-role">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group" id="namespaceGroup">
                                                    <label>Namespace</label>
                                                    <input type="text" class="form-control" id="namespace"
                                                        value="default">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Rules -->
                                    <div class="form-section">
                                        <div class="form-section-title"><i class="fas fa-list-ul"></i> Permissions
                                            (Rules)</div>
                                        <div id="rulesContainer">
                                            <!-- Rules will be added here -->
                                        </div>
                                        <button type="button"
                                            class="btn btn-outline-primary btn-block btn-sm dashed-border"
                                            onclick="addRule()">
                                            <i class="fas fa-plus"></i> Add Rule
                                        </button>
                                    </div>

                                    <!-- Subjects -->
                                    <div class="form-section">
                                        <div class="form-section-title"><i class="fas fa-users"></i> Subjects (Who)
                                        </div>
                                        <div id="subjectsContainer">
                                            <!-- Subjects will be added here -->
                                        </div>
                                        <button type="button"
                                            class="btn btn-outline-primary btn-block btn-sm dashed-border"
                                            onclick="addSubject()">
                                            <i class="fas fa-plus"></i> Add Subject
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="sticky-preview">
                            <div class="card tool-card mb-3">
                                <div class="card-header bg-white p-0">
                                    <ul class="nav tab-preview" role="tablist">
                                        <li class="nav-item">
                                            <a class="nav-link active" data-toggle="tab" href="#roleTab">Role /
                                                ClusterRole</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" data-toggle="tab" href="#bindingTab">Binding</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body p-0">
                                    <div class="tab-content">
                                        <div id="roleTab" class="tab-pane fade show active">
                                            <pre id="roleOutput" class="code-preview mb-0"></pre>
                                        </div>
                                        <div id="bindingTab" class="tab-pane fade">
                                            <pre id="bindingOutput" class="code-preview mb-0"></pre>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer bg-light d-flex justify-content-end">
                                    <button class="btn btn-sm btn-outline-dark mr-2" onclick="copyYAML()"><i
                                            class="fas fa-copy"></i> Copy</button>
                                    <button class="btn btn-sm btn-primary" onclick="downloadYAML()"><i
                                            class="fas fa-download"></i> Download</button>
                                </div>
                            </div>

                            <div class="card tool-card bg-light">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-lightbulb"></i> Explain this Policy</h6>
                                    <p id="policyExplanation" class="text-muted small mb-0">
                                        Add rules to see a natural language explanation of what this policy allows.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card tool-card">
                            <div class="card-body">
                                <h5 class="card-title mb-4"><i class="fas fa-question-circle"></i> Frequently Asked
                                    Questions</h5>
                                <div class="accordion" id="faqAccordion">
                                    <div class="card">
                                        <div class="card-header" id="headingOne">
                                            <h2 class="mb-0">
                                                <button class="btn btn-link btn-block text-left" type="button"
                                                    data-toggle="collapse" data-target="#collapseOne">
                                                    What is the difference between Role and ClusterRole?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseOne" class="collapse show" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                <strong>Role</strong> is namespaced. It grants permissions within a
                                                specific namespace (e.g., reading pods in 'dev').<br>
                                                <strong>ClusterRole</strong> is cluster-wide. It grants permissions
                                                across all namespaces (e.g., reading nodes) or can be used as a template
                                                for Roles.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header" id="headingTwo">
                                            <h2 class="mb-0">
                                                <button class="btn btn-link btn-block text-left collapsed" type="button"
                                                    data-toggle="collapse" data-target="#collapseTwo">
                                                    How do I apply these policies?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseTwo" class="collapse" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                Save the generated YAML to a file (e.g., <code>rbac.yaml</code>) and
                                                run:
                                                <pre class="bg-light p-2 mt-2 rounded">kubectl apply -f rbac.yaml</pre>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                let rules = [];
                let subjects = [];
                let ruleCounter = 0;
                let subjectCounter = 0;
                let currentKind = 'Role';

                const commonResources = [
                    { name: 'pods', group: '' },
                    { name: 'services', group: '' },
                    { name: 'configmaps', group: '' },
                    { name: 'secrets', group: '' },
                    { name: 'deployments', group: 'apps' },
                    { name: 'statefulsets', group: 'apps' },
                    { name: 'daemonsets', group: 'apps' },
                    { name: 'jobs', group: 'batch' },
                    { name: 'cronjobs', group: 'batch' },
                    { name: 'ingresses', group: 'networking.k8s.io' },
                    { name: 'nodes', group: '' },
                    { name: 'namespaces', group: '' },
                    { name: 'serviceaccounts', group: '' },
                    { name: 'roles', group: 'rbac.authorization.k8s.io' },
                    { name: 'rolebindings', group: 'rbac.authorization.k8s.io' }
                ];

                const verbs = ['get', 'list', 'watch', 'create', 'update', 'patch', 'delete', 'deletecollection'];

                document.addEventListener('DOMContentLoaded', function () {
                    addRule(); // Start with one empty rule
                    addSubject(); // Start with one empty subject
                    generateYAML();

                    document.getElementById('policyName').addEventListener('input', generateYAML);
                    document.getElementById('namespace').addEventListener('input', generateYAML);
                });

                function updateKind(kind) {
                    currentKind = kind;
                    const nsGroup = document.getElementById('namespaceGroup');
                    if (kind === 'ClusterRole') {
                        nsGroup.style.display = 'none';
                    } else {
                        nsGroup.style.display = 'block';
                    }
                    generateYAML();
                }

                function addRule() {
                    const id = ++ruleCounter;
                    rules.push({
                        id: id,
                        resources: [],
                        apiGroups: [],
                        verbs: []
                    });
                    renderRules();
                    generateYAML();
                }

                function removeRule(id) {
                    rules = rules.filter(r => r.id !== id);
                    renderRules();
                    generateYAML();
                }

                function renderRules() {
                    const container = document.getElementById('rulesContainer');
                    container.innerHTML = '';
                    rules.forEach((rule, index) => {
                        const div = document.createElement('div');
                        div.className = 'rule-item';
                        div.innerHTML = `
                        <div class="rule-actions">
                            <button class="btn btn-sm btn-danger" onclick="removeRule(${rule.id})"><i class="fas fa-trash"></i></button>
                        </div>
                        <h6 class="mb-3">Rule #${index + 1}</h6>
                        <div class="form-group">
                            <label class="small font-weight-bold">Resources</label>
                            <select class="form-control form-control-sm" multiple onchange="updateRuleResources(${rule.id}, this)">
                                ${commonResources.map(r => `<option value="${r.name}" data-group="${r.group}" ${rule.resources.includes(r.name) ? 'selected' : ''}>${r.name} (${r.group || 'core'})</option>`).join('')}
                                <option value="*" ${rule.resources.includes('*') ? 'selected' : ''}>* (All Resources)</option>
                            </select>
                            <small class="text-muted">Hold Ctrl/Cmd to select multiple</small>
                        </div>
                        <div class="form-group">
                            <label class="small font-weight-bold">Verbs</label>
                            <div class="d-flex flex-wrap">
                                ${verbs.map(v => `
                                    <div class="custom-control custom-checkbox verb-checkbox">
                                        <input type="checkbox" class="custom-control-input" id="verb_${rule.id}_${v}" 
                                               value="${v}" ${rule.verbs.includes(v) ? 'checked' : ''} 
                                               onchange="updateRuleVerbs(${rule.id}, this)">
                                        <label class="custom-control-label" for="verb_${rule.id}_${v}">${v}</label>
                                    </div>
                                `).join('')}
                                <div class="custom-control custom-checkbox verb-checkbox">
                                    <input type="checkbox" class="custom-control-input" id="verb_${rule.id}_all" 
                                           value="*" ${rule.verbs.includes('*') ? 'checked' : ''} 
                                           onchange="updateRuleVerbs(${rule.id}, this)">
                                    <label class="custom-control-label" for="verb_${rule.id}_all">* (All)</label>
                                </div>
                            </div>
                        </div>
                    `;
                        container.appendChild(div);
                    });
                }

                function updateRuleResources(id, select) {
                    const rule = rules.find(r => r.id === id);
                    const selectedOptions = Array.from(select.selectedOptions);
                    rule.resources = selectedOptions.map(opt => opt.value);

                    // Auto-populate API groups based on selected resources
                    const groups = new Set();
                    selectedOptions.forEach(opt => {
                        if (opt.value === '*') {
                            groups.add('*');
                        } else {
                            const group = opt.getAttribute('data-group');
                            groups.add(group);
                        }
                    });
                    rule.apiGroups = Array.from(groups);
                    generateYAML();
                }

                function updateRuleVerbs(id, checkbox) {
                    const rule = rules.find(r => r.id === id);
                    if (checkbox.checked) {
                        if (checkbox.value === '*') {
                            rule.verbs = ['*'];
                        } else {
                            rule.verbs = rule.verbs.filter(v => v !== '*'); // Remove * if specific verb added
                            rule.verbs.push(checkbox.value);
                        }
                    } else {
                        rule.verbs = rule.verbs.filter(v => v !== checkbox.value);
                    }
                    renderRules(); // Re-render to update checkboxes (e.g. uncheck * if needed)
                    generateYAML();
                }

                function addSubject() {
                    const id = ++subjectCounter;
                    subjects.push({ id: id, kind: 'User', name: 'alice', namespace: 'default' });
                    renderSubjects();
                    generateYAML();
                }

                function removeSubject(id) {
                    subjects = subjects.filter(s => s.id !== id);
                    renderSubjects();
                    generateYAML();
                }

                function renderSubjects() {
                    const container = document.getElementById('subjectsContainer');
                    container.innerHTML = '';
                    subjects.forEach((sub, index) => {
                        const div = document.createElement('div');
                        div.className = 'rule-item';
                        div.innerHTML = `
                        <div class="rule-actions">
                            <button class="btn btn-sm btn-danger" onclick="removeSubject(${sub.id})"><i class="fas fa-trash"></i></button>
                        </div>
                        <div class="row">
                            <div class="col-4">
                                <label class="small font-weight-bold">Kind</label>
                                <select class="form-control form-control-sm" onchange="updateSubject(${sub.id}, 'kind', this.value)">
                                    <option ${sub.kind === 'User' ? 'selected' : ''}>User</option>
                                    <option ${sub.kind === 'Group' ? 'selected' : ''}>Group</option>
                                    <option ${sub.kind === 'ServiceAccount' ? 'selected' : ''}>ServiceAccount</option>
                                </select>
                            </div>
                            <div class="col-8">
                                <label class="small font-weight-bold">Name</label>
                                <input type="text" class="form-control form-control-sm" value="${sub.name}" oninput="updateSubject(${sub.id}, 'name', this.value)">
                            </div>
                        </div>
                        ${sub.kind === 'ServiceAccount' ? `
                        <div class="row mt-2">
                            <div class="col-12">
                                <label class="small font-weight-bold">Namespace</label>
                                <input type="text" class="form-control form-control-sm" value="${sub.namespace}" oninput="updateSubject(${sub.id}, 'namespace', this.value)">
                            </div>
                        </div>` : ''}
                    `;
                        container.appendChild(div);
                    });
                }

                function updateSubject(id, field, value) {
                    const sub = subjects.find(s => s.id === id);
                    sub[field] = value;
                    if (field === 'kind') renderSubjects(); // Re-render to show/hide namespace
                    generateYAML();
                }

                function generateYAML() {
                    const name = document.getElementById('policyName').value;
                    const namespace = document.getElementById('namespace').value;

                    // 1. Generate Role/ClusterRole
                    let roleYaml = `apiVersion: rbac.authorization.k8s.io/v1\nkind: ${currentKind}\nmetadata:\n  name: ${name}\n`;
                    if (currentKind === 'Role') {
                        roleYaml += `  namespace: ${namespace}\n`;
                    }
                    roleYaml += `rules:\n`;

                    rules.forEach(rule => {
                        if (rule.resources.length > 0 && rule.verbs.length > 0) {
                            roleYaml += `- apiGroups: [${rule.apiGroups.map(g => `"${g}"`).join(', ')}]\n`;
                            roleYaml += `  resources: [${rule.resources.map(r => `"${r}"`).join(', ')}]\n`;
                            roleYaml += `  verbs: [${rule.verbs.map(v => `"${v}"`).join(', ')}]\n`;
                        }
                    });

                    document.getElementById('roleOutput').textContent = roleYaml;

                    // 2. Generate Binding
                    const bindingKind = currentKind === 'ClusterRole' ? 'ClusterRoleBinding' : 'RoleBinding';
                    let bindingYaml = `apiVersion: rbac.authorization.k8s.io/v1\nkind: ${bindingKind}\nmetadata:\n  name: ${name}-binding\n`;
                    if (currentKind === 'Role') {
                        bindingYaml += `  namespace: ${namespace}\n`;
                    }
                    bindingYaml += `subjects:\n`;
                    subjects.forEach(sub => {
                        bindingYaml += `- kind: ${sub.kind}\n  name: ${sub.name}\n  apiGroup: rbac.authorization.k8s.io\n`;
                        if (sub.kind === 'ServiceAccount') {
                            bindingYaml = bindingYaml.replace('apiGroup: rbac.authorization.k8s.io\n', ''); // SA doesn't have apiGroup
                            bindingYaml += `  namespace: ${sub.namespace}\n`;
                        }
                    });
                    bindingYaml += `roleRef:\n  kind: ${currentKind}\n  name: ${name}\n  apiGroup: rbac.authorization.k8s.io\n`;

                    document.getElementById('bindingOutput').textContent = bindingYaml;

                    // 3. Generate Explanation
                    generateExplanation();
                }

                function generateExplanation() {
                    const name = document.getElementById('policyName').value;
                    let text = `This policy <strong>${name}</strong> allows subjects to:<ul>`;

                    rules.forEach(rule => {
                        if (rule.resources.length > 0 && rule.verbs.length > 0) {
                            const rText = rule.resources.includes('*') ? 'all resources' : rule.resources.join(', ');
                            const vText = rule.verbs.includes('*') ? 'perform any action' : `perform <strong>${rule.verbs.join(', ')}</strong>`;
                            text += `<li>${vText} on <strong>${rText}</strong>.</li>`;
                        }
                    });
                    text += '</ul>';
                    document.getElementById('policyExplanation').innerHTML = text;
                }

                function loadPreset(name) {
                    rules = [];
                    subjects = [];
                    ruleCounter = 0;
                    subjectCounter = 0;

                    if (name === 'view-only') {
                        currentKind = 'Role';
                        rules.push({ id: 1, resources: ['*'], apiGroups: ['*'], verbs: ['get', 'list', 'watch'] });
                        subjects.push({ id: 1, kind: 'User', name: 'jane', namespace: 'default' });
                    } else if (name === 'admin') {
                        currentKind = 'ClusterRole';
                        rules.push({ id: 1, resources: ['*'], apiGroups: ['*'], verbs: ['*'] });
                        subjects.push({ id: 1, kind: 'Group', name: 'system:masters', namespace: 'default' });
                    } else if (name === 'ci-cd') {
                        currentKind = 'Role';
                        rules.push({ id: 1, resources: ['deployments', 'services', 'ingresses'], apiGroups: ['apps', '', 'networking.k8s.io'], verbs: ['get', 'list', 'watch', 'create', 'update', 'patch'] });
                        subjects.push({ id: 1, kind: 'ServiceAccount', name: 'ci-runner', namespace: 'default' });
                    } else if (name === 'log-reader') {
                        currentKind = 'Role';
                        rules.push({ id: 1, resources: ['pods', 'pods/log'], apiGroups: [''], verbs: ['get', 'list', 'watch'] });
                        subjects.push({ id: 1, kind: 'User', name: 'developer', namespace: 'default' });
                    } else if (name === 'secret-manager') {
                        currentKind = 'Role';
                        rules.push({ id: 1, resources: ['secrets'], apiGroups: [''], verbs: ['get', 'list', 'create', 'update', 'delete'] });
                        subjects.push({ id: 1, kind: 'ServiceAccount', name: 'vault-agent', namespace: 'default' });
                    }

                    // Update UI
                    const kindRadios = document.getElementsByName('kind');
                    for (let radio of kindRadios) {
                        if (radio.value === currentKind) {
                            radio.checked = true;
                            radio.parentElement.classList.add('active');
                        } else {
                            radio.parentElement.classList.remove('active');
                        }
                    }
                    updateKind(currentKind);
                    renderRules();
                    renderSubjects();
                    generateYAML();
                }

                function copyYAML() {
                    const activeTab = document.querySelector('.tab-preview .nav-link.active');
                    const targetId = activeTab.getAttribute('href').substring(1) + 'Output';
                    const content = document.getElementById(targetId).textContent;

                    navigator.clipboard.writeText(content).then(() => {
                        alert('Copied to clipboard!');
                    });
                }

                function downloadYAML() {
                    const activeTab = document.querySelector('.tab-preview .nav-link.active');
                    const targetId = activeTab.getAttribute('href').substring(1) + 'Output';
                    const content = document.getElementById(targetId).textContent;
                    const name = document.getElementById('policyName').value;

                    const blob = new Blob([content], { type: 'text/yaml' });
                    const link = document.createElement('a');
                    link.href = URL.createObjectURL(blob);
                    link.download = `${name}.yaml`;
                    link.click();
                }
            </script>

            <div class="sharethis-inline-share-buttons"></div>
            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="thanks.jsp" %>
                    <hr>
                    <%@ include file="addcomments.jsp" %>
                        </div>
                        <%@ include file="body-close.jsp" %>

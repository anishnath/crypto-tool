<!DOCTYPE html>
<html>

<head>
    <title>Chmod Calculator Online – Advanced Permissions | 8gwifi.org</title>
    <meta name="description"
        content="Advanced Linux Permissions Calculator. Support for SUID, SGID, Sticky Bit (4-digit octal). Convert rwxr-xr-x to 755. Recursive chmod generator. Free DevOps tool.">
    <meta name="keywords"
        content="chmod calculator, linux permissions, suid calculator, sgid calculator, sticky bit, chmod recursive, octal to symbolic">
    <%@ include file="header-script.jsp" %>
        <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Advanced Chmod Calculator",
      "description": "Professional Linux permissions calculator with SUID/SGID support.",
      "url": "https://8gwifi.org/chmod-calculator.jsp",
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
          "name": "What is the 4th digit in chmod (e.g., 4755)?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The first digit represents special flags: 4 for SUID (Set User ID), 2 for SGID (Set Group ID), and 1 for the Sticky Bit. These are often used for executables (SUID) or shared directories (Sticky Bit)."
          }
        },
        {
          "@type": "Question",
          "name": "What is the difference between 755 and 777?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "755 gives the owner full control, but others can only read and execute. 777 gives EVERYONE full control (read/write/execute), which is a major security risk and should rarely be used."
          }
        }
      ]
    }
    </script>
        <style>
            :root {
                --theme-primary: #059669;
                --theme-secondary: #10b981;
                --theme-gradient: linear-gradient(135deg, #059669 0%, #10b981 100%);
                --theme-light: #ecfdf5;
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

            .permission-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 8px;
                text-align: center;
            }

            .permission-header {
                font-weight: 600;
                padding: 8px;
                background: var(--theme-light);
                color: var(--theme-primary);
                border-radius: 4px;
                font-size: 0.9rem;
            }

            .permission-cell {
                padding: 12px;
                border: 1px solid #e5e7eb;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .permission-cell:hover {
                background: #f3f4f6;
            }

            .permission-cell.active {
                background: var(--theme-light);
                border-color: var(--theme-primary);
                color: var(--theme-primary);
            }

            .result-box {
                font-size: 2.5rem;
                font-family: 'Monaco', monospace;
                text-align: center;
                letter-spacing: 2px;
                border: 2px solid var(--theme-primary);
                color: var(--theme-primary);
                font-weight: bold;
            }

            .command-preview {
                background: #1f2937;
                color: #10b981;
                padding: 1rem;
                border-radius: 4px;
                font-family: monospace;
                font-size: 1.1rem;
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
        </style>
</head>

<%@ include file="body-script.jsp" %>
    <%@ include file="devops-tools-navbar.jsp" %>
        <%@ include file="footer_adsense.jsp" %>

            <div class="container-fluid px-lg-5 mt-4">

                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">Advanced Chmod Calculator</h1>
                        <div class="mt-2">
                            <span class="info-badge"><i class="fas fa-calculator"></i> Octal & Symbolic</span>
                            <span class="info-badge"><i class="fas fa-shield-alt"></i> SUID/SGID Support</span>
                            <span class="info-badge"><i class="fas fa-folder-tree"></i> Recursive Mode</span>
                        </div>
                    </div>
                    <div class="eeat-badge">
                        <i class="fas fa-user-check"></i>
                        <span>Anish Nath</span>
                    </div>
                </div>

                <div class="row">
                    <!-- Left Column: Calculator -->
                    <div class="col-lg-7">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom">
                                <i class="fas fa-th mr-2"></i> Permission Matrix
                            </div>
                            <div class="card-body">

                                <!-- Special Bits -->
                                <div class="mb-4 p-3 bg-light rounded">
                                    <h6 class="text-muted mb-2 text-uppercase small font-weight-bold">Special Flags</h6>
                                    <div class="d-flex justify-content-between">
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input" id="suid"
                                                onchange="toggleSpecial(4)">
                                            <label class="custom-control-label" for="suid">Set UID (4)</label>
                                        </div>
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input" id="sgid"
                                                onchange="toggleSpecial(2)">
                                            <label class="custom-control-label" for="sgid">Set GID (2)</label>
                                        </div>
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input" id="sticky"
                                                onchange="toggleSpecial(1)">
                                            <label class="custom-control-label" for="sticky">Sticky Bit (1)</label>
                                        </div>
                                    </div>
                                </div>

                                <!-- Main Grid -->
                                <div class="permission-grid mb-4">
                                    <!-- Headers -->
                                    <div></div>
                                    <div class="permission-header">Owner</div>
                                    <div class="permission-header">Group</div>
                                    <div class="permission-header">Public</div>

                                    <!-- Read -->
                                    <div class="permission-header text-left pl-3 bg-white text-dark">Read (4)</div>
                                    <div class="permission-cell" data-role="owner" data-perm="4"
                                        onclick="togglePerm(this)">
                                        <i class="far fa-square fa-lg"></i>
                                    </div>
                                    <div class="permission-cell" data-role="group" data-perm="4"
                                        onclick="togglePerm(this)">
                                        <i class="far fa-square fa-lg"></i>
                                    </div>
                                    <div class="permission-cell" data-role="public" data-perm="4"
                                        onclick="togglePerm(this)">
                                        <i class="far fa-square fa-lg"></i>
                                    </div>

                                    <!-- Write -->
                                    <div class="permission-header text-left pl-3 bg-white text-dark">Write (2)</div>
                                    <div class="permission-cell" data-role="owner" data-perm="2"
                                        onclick="togglePerm(this)">
                                        <i class="far fa-square fa-lg"></i>
                                    </div>
                                    <div class="permission-cell" data-role="group" data-perm="2"
                                        onclick="togglePerm(this)">
                                        <i class="far fa-square fa-lg"></i>
                                    </div>
                                    <div class="permission-cell" data-role="public" data-perm="2"
                                        onclick="togglePerm(this)">
                                        <i class="far fa-square fa-lg"></i>
                                    </div>

                                    <!-- Execute -->
                                    <div class="permission-header text-left pl-3 bg-white text-dark">Execute (1)</div>
                                    <div class="permission-cell" data-role="owner" data-perm="1"
                                        onclick="togglePerm(this)">
                                        <i class="far fa-square fa-lg"></i>
                                    </div>
                                    <div class="permission-cell" data-role="group" data-perm="1"
                                        onclick="togglePerm(this)">
                                        <i class="far fa-square fa-lg"></i>
                                    </div>
                                    <div class="permission-cell" data-role="public" data-perm="1"
                                        onclick="togglePerm(this)">
                                        <i class="far fa-square fa-lg"></i>
                                    </div>
                                </div>

                                <!-- Options -->
                                <div class="form-row align-items-center">
                                    <div class="col-auto">
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="recursive"
                                                onchange="updateCommand()">
                                            <label class="custom-control-label" for="recursive">Recursive (-R)</label>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <input type="text" class="form-control form-control-sm" id="filename"
                                            placeholder="filename or /path/to/dir" value="filename"
                                            oninput="updateCommand()">
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Results -->
                    <div class="col-lg-5">
                        <div class="card tool-card mb-4">
                            <div class="card-header bg-dark text-white">
                                <i class="fas fa-terminal mr-2"></i> Result
                            </div>
                            <div class="card-body text-center">
                                <div class="form-group">
                                    <label class="text-muted small text-uppercase font-weight-bold">Octal Value</label>
                                    <input type="text" class="form-control result-box" id="octalInput" value="0755"
                                        maxlength="4">
                                </div>

                                <div class="form-group">
                                    <label class="text-muted small text-uppercase font-weight-bold">Symbolic
                                        Value</label>
                                    <input type="text" class="form-control text-center font-weight-bold"
                                        id="symbolicInput" value="-rwxr-xr-x" readonly
                                        style="font-family: monospace; font-size: 1.2rem;">
                                </div>

                                <div class="command-preview mt-4 text-left" id="commandOutput">
                                    chmod 0755 filename
                                </div>

                                <button class="btn btn-success btn-block mt-3" onclick="copyCommand()">
                                    <i class="fas fa-copy mr-2"></i> Copy Command
                                </button>
                                <button class="btn btn-outline-primary btn-block mt-2" onclick="shareUrl()">
                                    <i class="fas fa-share-alt mr-2"></i> Share Configuration
                                </button>
                            </div>
                        </div>

                        <!-- Presets -->
                        <div class="card tool-card">
                            <div class="card-header bg-light">
                                <h6 class="mb-0"><i class="fas fa-bookmark mr-2"></i>Quick Presets</h6>
                            </div>
                            <div class="card-body">
                                <div class="btn-group-vertical w-100">
                                    <button class="btn btn-outline-secondary text-left mb-2" onclick="setPreset('755')">
                                        <strong>755</strong> - Web Server / Directories (rwxr-xr-x)
                                    </button>
                                    <button class="btn btn-outline-secondary text-left mb-2" onclick="setPreset('644')">
                                        <strong>644</strong> - Standard Files (rw-r--r--)
                                    </button>
                                    <button class="btn btn-outline-secondary text-left mb-2" onclick="setPreset('600')">
                                        <strong>600</strong> - Private Keys / Secrets (rw-------)
                                    </button>
                                    <button class="btn btn-outline-secondary text-left mb-2" onclick="setPreset('400')">
                                        <strong>400</strong> - Read Only (r--------)
                                    </button>
                                    <button class="btn btn-outline-danger text-left" onclick="setPreset('777')">
                                        <strong>777</strong> - Full Access (Dangerous!)
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Educational Content -->
                <div class="row mb-5">
                    <div class="col-12">
                        <div class="card tool-card">
                            <div class="card-header bg-light">
                                <h5 class="mb-0"><i class="fas fa-graduation-cap mr-2"></i>Understanding Linux
                                    Permissions
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>The 4 Digits Explained</h6>
                                        <p>Permissions are often represented by 3 or 4 octal digits (e.g.,
                                            <code>0755</code>).
                                        </p>
                                        <ul>
                                            <li><strong>1st Digit (Special):</strong> SUID (4) + SGID (2) + Sticky (1).
                                            </li>
                                            <li><strong>2nd Digit (Owner):</strong> Permissions for the file owner.</li>
                                            <li><strong>3rd Digit (Group):</strong> Permissions for the file's group.
                                            </li>
                                            <li><strong>4th Digit (Public):</strong> Permissions for everyone else.</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>Symbolic Notation</h6>
                                        <table class="table table-sm table-bordered">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th>Symbol</th>
                                                    <th>Meaning</th>
                                                    <th>Value</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><code>r</code></td>
                                                    <td>Read</td>
                                                    <td>4</td>
                                                </tr>
                                                <tr>
                                                    <td><code>w</code></td>
                                                    <td>Write</td>
                                                    <td>2</td>
                                                </tr>
                                                <tr>
                                                    <td><code>x</code></td>
                                                    <td>Execute</td>
                                                    <td>1</td>
                                                </tr>
                                                <tr>
                                                    <td><code>s</code></td>
                                                    <td>SUID/SGID</td>
                                                    <td>-</td>
                                                </tr>
                                                <tr>
                                                    <td><code>t</code></td>
                                                    <td>Sticky Bit</td>
                                                    <td>-</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Share URL Modal -->
                <div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                                <h5 class="modal-title">
                                    <i class="fas fa-share-alt"></i> Share Permissions
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
                                    <i class="fas fa-info-circle"></i> Anyone with this link can view this permission
                                    set.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>


            </div>

            <script>
                const state = {
                    special: 0,
                    owner: 0,
                    group: 0,
                    public: 0
                };

                function updateUI() {
                    // Update Grid
                    document.querySelectorAll('.permission-cell').forEach(cell => {
                        const role = cell.dataset.role;
                        const val = parseInt(cell.dataset.perm);
                        const isActive = (state[role] & val) === val;

                        if (isActive) {
                            cell.classList.add('active');
                            cell.innerHTML = '<i class="fas fa-check-square fa-lg"></i>';
                        } else {
                            cell.classList.remove('active');
                            cell.innerHTML = '<i class="far fa-square fa-lg"></i>';
                        }
                    });

                    // Update Special Checkboxes
                    document.getElementById('suid').checked = (state.special & 4) === 4;
                    document.getElementById('sgid').checked = (state.special & 2) === 2;
                    document.getElementById('sticky').checked = (state.special & 1) === 1;

                    // Update Octal
                    const octal = '' + state.special + state.owner + state.group + state.public;
                    document.getElementById('octalInput').value = octal;

                    // Update Symbolic
                    document.getElementById('symbolicInput').value = getSymbolicString();

                    updateCommand();
                }

                function getSymbolicString() {
                    let s = '';

                    // Owner
                    s += (state.owner & 4) ? 'r' : '-';
                    s += (state.owner & 2) ? 'w' : '-';
                    if (state.special & 4) {
                        s += (state.owner & 1) ? 's' : 'S';
                    } else {
                        s += (state.owner & 1) ? 'x' : '-';
                    }

                    // Group
                    s += (state.group & 4) ? 'r' : '-';
                    s += (state.group & 2) ? 'w' : '-';
                    if (state.special & 2) {
                        s += (state.group & 1) ? 's' : 'S';
                    } else {
                        s += (state.group & 1) ? 'x' : '-';
                    }

                    // Public
                    s += (state.public & 4) ? 'r' : '-';
                    s += (state.public & 2) ? 'w' : '-';
                    if (state.special & 1) {
                        s += (state.public & 1) ? 't' : 'T';
                    } else {
                        s += (state.public & 1) ? 'x' : '-';
                    }

                    return s;
                }

                function updateCommand() {
                    const octal = document.getElementById('octalInput').value;
                    const filename = document.getElementById('filename').value || 'filename';
                    const recursive = document.getElementById('recursive').checked;

                    let cmd = 'chmod ';
                    if (recursive) cmd += '-R ';
                    cmd += octal + ' ' + filename;

                    document.getElementById('commandOutput').textContent = cmd;
                }

                function togglePerm(element) {
                    const role = element.dataset.role;
                    const val = parseInt(element.dataset.perm);

                    if ((state[role] & val) === val) {
                        state[role] -= val;
                    } else {
                        state[role] += val;
                    }
                    updateUI();
                }

                function toggleSpecial(val) {
                    if ((state.special & val) === val) {
                        state.special -= val;
                    } else {
                        state.special += val;
                    }
                    updateUI();
                }

                function setPreset(octalStr) {
                    // Handle 3 or 4 digit octal
                    let s = 0, o = 0, g = 0, p = 0;

                    if (octalStr.length === 3) {
                        o = parseInt(octalStr.charAt(0));
                        g = parseInt(octalStr.charAt(1));
                        p = parseInt(octalStr.charAt(2));
                    } else if (octalStr.length === 4) {
                        s = parseInt(octalStr.charAt(0));
                        o = parseInt(octalStr.charAt(1));
                        g = parseInt(octalStr.charAt(2));
                        p = parseInt(octalStr.charAt(3));
                    }

                    state.special = s;
                    state.owner = o;
                    state.group = g;
                    state.public = p;
                    updateUI();
                }

                document.getElementById('octalInput').addEventListener('input', function (e) {
                    const val = e.target.value;
                    if (val.length === 3 || val.length === 4) {
                        setPreset(val);
                    }
                });

                function copyCommand() {
                    const text = document.getElementById('commandOutput').textContent;
                    navigator.clipboard.writeText(text).then(() => {
                        // Simple toast
                        const btn = document.querySelector('.btn-success');
                        const original = btn.innerHTML;
                        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                        setTimeout(() => btn.innerHTML = original, 2000);
                    });
                }

                // Initialize
                loadFromUrl();

                function shareUrl() {
                    const formData = {
                        octal: document.getElementById('octalInput').value,
                        filename: document.getElementById('filename').value,
                        recursive: document.getElementById('recursive').checked
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

                            if (formData.octal) setPreset(formData.octal);
                            if (formData.filename) document.getElementById('filename').value = formData.filename;
                            if (formData.recursive !== undefined) document.getElementById('recursive').checked = formData.recursive;

                        } catch (e) {
                            console.error('Error loading from URL:', e);
                            setPreset('0755'); // Fallback
                        }
                    } else {
                        setPreset('0755');
                    }
                    updateCommand();
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
            </script>

            <div class="sharethis-inline-share-buttons"></div>
            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="thanks.jsp" %>
                    <hr>
                    <%@ include file="addcomments.jsp" %>
                        </div>
                        <%@ include file="body-close.jsp" %>
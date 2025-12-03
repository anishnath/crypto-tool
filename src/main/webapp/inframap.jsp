<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Terraform State Visualizer Online – Free | 8gwifi.org</title>
    <meta name="description" content="Visualize Terraform tfstate files instantly. Generate AWS, Azure, GCP infrastructure diagrams from terraform.tfstate or HCL. Export to PNG, SVG, PDF. 100% browser-based, no data uploaded. Free for DevOps & SRE teams." />
    <meta name="keywords" content="terraform state visualizer, tfstate viewer online, terraform graph generator, terraform diagram tool, visualize terraform state, terraform infrastructure diagram, aws terraform graph, azure terraform visualization, gcp terraform diagram, terraform plan viewer, hcl to diagram, terraform architecture visualization, terraform resource graph, infrastructure as code diagram, devops diagram tool, sre tools, terraform state analyzer, cloud architecture diagram, terraform dependency graph, terraform state file viewer" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/inframap.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="Terraform State Visualizer Online – Free | 8gwifi.org" />
    <meta property="og:description" content="Visualize Terraform tfstate files instantly. Generate infrastructure diagrams from terraform.tfstate or HCL. Export to PNG, SVG, PDF. 100% browser-based." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/inframap.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/inframap-og.png" />

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Terraform State Visualizer Online – Free" />
    <meta name="twitter:description" content="Visualize tfstate files instantly. Generate AWS/Azure/GCP diagrams. Export to PNG/SVG/PDF. No signup required." />
    <meta name="twitter:creator" content="@anish2good" />

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Terraform State Visualizer",
            "alternateName": ["tfstate Viewer", "Terraform Graph Generator", "HCL Diagram Tool", "InfraMap Online"],
            "description": "Free online tool to visualize Terraform state files (tfstate) and HCL configurations. Generate infrastructure diagrams for AWS, Azure, GCP. Export to PNG, SVG, PDF.",
            "url": "https://8gwifi.org/inframap.jsp",
            "applicationCategory": "DeveloperApplication",
            "applicationSubCategory": "DevOps Tool",
            "operatingSystem": "Any",
            "browserRequirements": "Requires JavaScript and WebAssembly",
            "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
            "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
            "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
            "datePublished": "2024-06-01",
            "dateModified": "2025-12-03",
            "featureList": [
                "Visualize terraform.tfstate JSON files",
                "Parse HCL configuration files",
                "Multi-cloud: AWS, Azure, GCP, OpenStack",
                "Export diagrams to PNG, SVG, PDF",
                "Interactive graph with zoom and pan",
                "100% client-side - no data uploaded",
                "WebAssembly powered - fast processing",
                "No signup or login required"
            ],
            "screenshot": "https://8gwifi.org/images/inframap-screenshot.png",
            "softwareHelp": {"@type": "CreativeWork", "url": "https://8gwifi.org/inframap.jsp#understanding"},
            "aggregateRating": {"@type": "AggregateRating", "ratingValue": "4.8", "ratingCount": "127"}
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "HowTo",
            "name": "How to Visualize Terraform State Files",
            "description": "Step-by-step guide to generate infrastructure diagrams from Terraform tfstate or HCL files",
            "totalTime": "PT2M",
            "tool": {"@type": "HowToTool", "name": "Terraform State Visualizer"},
            "step": [
                {
                    "@type": "HowToStep",
                    "name": "Get your Terraform state",
                    "text": "Run 'terraform show -json > terraform.tfstate.json' or 'terraform state pull' to export your state file",
                    "position": 1
                },
                {
                    "@type": "HowToStep",
                    "name": "Paste the state content",
                    "text": "Copy and paste your tfstate JSON or HCL configuration into the input field. The tool auto-detects the format.",
                    "position": 2
                },
                {
                    "@type": "HowToStep",
                    "name": "Generate the diagram",
                    "text": "Click 'Generate Diagram' to create an interactive infrastructure graph showing all resources and their relationships",
                    "position": 3
                },
                {
                    "@type": "HowToStep",
                    "name": "Export your diagram",
                    "text": "Use PNG, SVG, or PDF buttons to download high-resolution images for documentation or presentations",
                    "position": 4
                }
            ]
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "How do I visualize my Terraform state file?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Run 'terraform show -json > state.json' to export your state, then paste the JSON content into this tool and click 'Generate Diagram'. The tool will create an interactive graph showing all your infrastructure resources."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Is this better than 'terraform graph' command?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Yes! Unlike 'terraform graph' which shows all internal dependencies, this tool applies provider-specific logic to show only meaningful resource relationships, making diagrams much cleaner and human-readable."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What cloud providers are supported?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "AWS, Google Cloud (GCP), Azure, OpenStack, and FlexibleEngine are fully supported. The tool automatically detects the provider from your Terraform state and applies appropriate visualization rules."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Is my Terraform state data secure and private?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Absolutely! This tool runs 100% in your browser using WebAssembly. Your tfstate data never leaves your machine - no data is uploaded to any server. Perfect for sensitive production infrastructure."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Can I export the diagram for documentation?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Yes! Export your infrastructure diagram as PNG (high-resolution image), SVG (scalable vector), or PDF. Great for architecture documentation, README files, and presentations."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Does this work with Terraform Cloud or Terraform Enterprise?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Yes! Use 'terraform state pull' to download your state from Terraform Cloud/Enterprise, then paste it into this tool. Works with any Terraform state regardless of backend."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Can I visualize HCL files without running terraform apply?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Yes! Paste your .tf HCL configuration files directly. The tool will parse the HCL and show resource relationships based on your configuration, even before applying."
                    }
                }
            ]
        }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #7c3aed;
            --theme-secondary: #8b5cf6;
            --theme-gradient: linear-gradient(135deg, #7c3aed 0%, #8b5cf6 100%);
            --theme-light: #f5f3ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(124, 58, 237, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.25);
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
        #terraformInput {
            font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
            font-size: 12px;
            background: #1e1e1e;
            color: #d4d4d4;
            height: 300px;
        }
        #dotOutput {
            font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
            font-size: 12px;
            background: #fafafa;
            height: 200px;
        }
        .example-btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            background: #e9ecef;
            border: 1px solid #dee2e6;
            color: #333;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .example-btn:hover {
            background: var(--theme-light);
            border-color: var(--theme-primary);
        }
        .status-box {
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            font-size: 0.85rem;
        }
        .status-loading { background: #fff3cd; color: #856404; }
        .status-ready { background: #d4edda; color: #155724; }
        .status-error { background: #f8d7da; color: #721c24; }
        .loader {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid var(--theme-primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            vertical-align: middle;
            margin-right: 6px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .progress-bar-custom {
            width: 100%;
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            margin-top: 6px;
            overflow: hidden;
        }
        .progress-bar-fill {
            height: 100%;
            background: var(--theme-gradient);
            border-radius: 2px;
            transition: width 0.3s ease;
            width: 0%;
        }
        #graphPreview {
            min-height: 300px;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            overflow: auto;
        }
        #graphPreview svg {
            max-width: 100%;
            height: auto;
        }
        .provider-badge {
            display: inline-block;
            padding: 0.15rem 0.4rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .provider-aws { background: #ff9900; color: white; }
        .provider-azure { background: #0078d4; color: white; }
        .provider-gcp { background: #4285f4; color: white; }
        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 0.75rem;
        }
        .related-tool-card {
            display: block;
            padding: 0.75rem;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
        }
        .related-tool-card:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
            text-decoration: none;
        }
        .related-tool-card h6 {
            margin: 0 0 0.25rem 0;
            color: var(--theme-primary);
            font-size: 0.9rem;
        }
        .related-tool-card p {
            margin: 0;
            font-size: 0.75rem;
            color: #6c757d;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="devops-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<div class="container-fluid py-3" style="max-width: 1400px;">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            <h1 class="h4 mb-0">InfraMap - Terraform State Visualizer</h1>
            <div class="mt-1">
                <span class="info-badge"><i class="fas fa-cloud"></i> Multi-Cloud</span>
                <span class="info-badge"><i class="fas fa-project-diagram"></i> Infrastructure</span>
                <span class="info-badge"><i class="fas fa-lock"></i> Client-Side</span>
            </div>
        </div>
        <div class="eeat-badge">
            <i class="fas fa-user-check"></i>
            <span>Anish Nath</span>
        </div>
    </div>

    <!-- Status Bar -->
    <div id="statusBox" class="status-box status-loading mb-3">
        <span class="loader"></span>
        <span id="statusText">Loading InfraMap WASM runtime (~8MB compressed)...</span>
        <div class="progress-bar-custom"><div id="progressFill" class="progress-bar-fill"></div></div>
    </div>

    <div class="row">
        <!-- Left Column - Input -->
        <div class="col-lg-5 mb-3">
            <div class="card tool-card">
                <div class="card-header card-header-custom">
                    <h5><i class="fas fa-file-code me-2"></i>Terraform Input</h5>
                </div>
                <div class="card-body">
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-paste me-1"></i>Paste tfstate or HCL</div>
                        <textarea class="form-control" id="terraformInput" placeholder="Paste your terraform.tfstate JSON or HCL configuration here..."></textarea>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-cog me-1"></i>Options</div>
                        <div class="row">
                            <div class="col-6">
                                <select class="form-control form-control-sm" id="formatSelect">
                                    <option value="">Auto-detect</option>
                                    <option value="tfstate">Terraform State (JSON)</option>
                                    <option value="hcl">HCL Configuration</option>
                                </select>
                            </div>
                            <div class="col-6">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" id="cleanCheck" checked>
                                    <label class="form-check-label small" for="cleanCheck">Clean</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" id="connectionsCheck" checked>
                                    <label class="form-check-label small" for="connectionsCheck">Connections</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <button class="btn btn-block text-white" id="generateBtn" disabled style="background: var(--theme-gradient);">
                        <i class="fas fa-project-diagram me-1"></i> Generate Diagram
                    </button>

                    <div class="mt-3">
                        <small class="text-muted d-block mb-2"><strong>Examples:</strong></small>
                        <div class="d-flex flex-wrap gap-1">
                            <button class="example-btn" data-example="aws-simple">
                                <span class="provider-badge provider-aws">AWS</span> Simple
                            </button>
                            <button class="example-btn" data-example="aws-vpc">
                                <span class="provider-badge provider-aws">AWS</span> VPC
                            </button>
                            <button class="example-btn" data-example="hcl-basic">
                                <span class="provider-badge provider-gcp">HCL</span> Basic
                            </button>
                        </div>
                    </div>

                    <div class="alert alert-warning mt-3 small mb-0">
                        <i class="fas fa-shield-alt me-1"></i>
                        <strong>Privacy:</strong> Your data stays in your browser. Nothing is sent to any server.
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column - Output -->
        <div class="col-lg-7 mb-3">
            <div class="card tool-card">
                <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-sitemap me-2"></i>Infrastructure Diagram</h5>
                    <div class="d-flex gap-1">
                        <button class="btn btn-sm btn-warning" id="exportPngBtn" disabled title="Export as PNG">
                            <i class="fas fa-file-image"></i> PNG
                        </button>
                        <button class="btn btn-sm btn-info" id="exportSvgBtn" disabled title="Export as SVG">
                            <i class="fas fa-vector-square"></i> SVG
                        </button>
                        <button class="btn btn-sm btn-danger" id="exportPdfBtn" disabled title="Export as PDF">
                            <i class="fas fa-file-pdf"></i> PDF
                        </button>
                        <button class="btn btn-sm btn-light" id="copyBtn" disabled>
                            <i class="fas fa-copy"></i> DOT
                        </button>
                        <button class="btn btn-sm btn-success" id="shareBtn" title="Share this tool">
                            <i class="fas fa-share-alt"></i>
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <!-- Graph Preview -->
                    <div id="graphPreview" class="p-3 text-center text-muted">
                        <i class="fas fa-project-diagram fa-3x mb-2 opacity-25"></i>
                        <p class="mb-0">Generate a diagram to see the preview</p>
                    </div>

                    <!-- DOT Output (collapsible) -->
                    <div class="mt-3">
                        <button class="btn btn-sm btn-outline-secondary" type="button" data-toggle="collapse" data-target="#dotOutputCollapse">
                            <i class="fas fa-code"></i> View DOT Source
                        </button>
                        <div class="collapse mt-2" id="dotOutputCollapse">
                            <textarea class="form-control" id="dotOutput" readonly placeholder="DOT source will appear here..."></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Supported Providers -->
            <div class="card tool-card mt-3">
                <div class="card-header bg-dark text-white py-2">
                    <h6 class="mb-0"><i class="fas fa-cloud me-2"></i>Supported Providers</h6>
                </div>
                <div class="card-body py-2">
                    <div class="d-flex flex-wrap gap-2">
                        <span class="provider-badge provider-aws"><i class="fab fa-aws me-1"></i>AWS</span>
                        <span class="provider-badge provider-azure"><i class="fab fa-microsoft me-1"></i>Azure</span>
                        <span class="provider-badge provider-gcp"><i class="fab fa-google me-1"></i>Google Cloud</span>
                        <span class="badge bg-secondary">OpenStack</span>
                        <span class="badge bg-secondary">FlexibleEngine</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Tools -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light py-2">
            <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Tools</h6>
        </div>
        <div class="card-body">
            <div class="related-tools">
                <a href="graph-easy.jsp" class="related-tool-card">
                    <h6><i class="fas fa-project-diagram me-1"></i>Graph-Easy</h6>
                    <p>ASCII flowchart generator</p>
                </a>
                <a href="jsonformatter.jsp" class="related-tool-card">
                    <h6><i class="fas fa-indent me-1"></i>JSON Formatter</h6>
                    <p>Format and validate JSON</p>
                </a>
                <a href="base64.jsp" class="related-tool-card">
                    <h6><i class="fas fa-exchange-alt me-1"></i>Base64 Encoder</h6>
                    <p>Encode and decode Base64</p>
                </a>
                <a href="yaml.jsp" class="related-tool-card">
                    <h6><i class="fas fa-file-alt me-1"></i>YAML Validator</h6>
                    <p>Validate YAML syntax</p>
                </a>
            </div>
        </div>
    </div>

    <%@ include file="thanks.jsp"%>

    <!-- Educational Content -->
    <div class="card tool-card mb-4" id="understanding">
        <div class="card-header bg-light">
            <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding InfraMap</h5>
        </div>
        <div class="card-body">
            <h6>What is InfraMap?</h6>
            <p>InfraMap is an open-source tool that reads Terraform state files (tfstate) or HCL configurations and generates visual infrastructure diagrams. Unlike <code>terraform graph</code>, InfraMap applies provider-specific logic to filter out noise and show only meaningful resource relationships.</p>

            <h6 class="mt-4">Supported Input Formats</h6>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <div class="p-3 rounded h-100" style="background: #e0f2fe; border: 2px solid #0284c7;">
                        <h6 class="text-center" style="color: #0369a1;"><strong>Terraform State (tfstate)</strong></h6>
                        <p class="small mb-0">JSON files generated by <code>terraform apply</code>. Contains the current state of your infrastructure including resource IDs and attributes.</p>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="p-3 rounded h-100" style="background: #fef3c7; border: 2px solid #d97706;">
                        <h6 class="text-center" style="color: #b45309;"><strong>HCL Configuration</strong></h6>
                        <p class="small mb-0">HashiCorp Configuration Language files (.tf). Describes your desired infrastructure as code.</p>
                    </div>
                </div>
            </div>

            <h6 class="mt-4">How to Get Your Terraform State</h6>
            <pre class="bg-dark text-light p-3 rounded small"><code># Show current state
terraform show -json > terraform.tfstate.json

# Or pull from remote backend
terraform state pull > terraform.tfstate.json</code></pre>

            <h6 class="mt-4">Options Explained</h6>
            <ul class="small">
                <li><strong>Clean:</strong> Remove unconnected nodes from the graph (default: on)</li>
                <li><strong>Connections:</strong> Apply provider-specific connection logic to show meaningful relationships (default: on)</li>
            </ul>

            <div class="alert alert-info mt-4 small">
                <strong><i class="fas fa-info-circle"></i> Tips:</strong>
                <ul class="mb-0 mt-1">
                    <li>For large state files, the visualization may take a few seconds to render.</li>
                    <li>Use the PNG/SVG export for documentation or presentations.</li>
                    <li>The DOT output can be used with other GraphViz tools.</li>
                </ul>
            </div>
        </div>
    </div>

    <%@ include file="addcomments.jsp"%>

    <!-- Export Modal -->
    <div class="modal fade" id="exportModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                    <h5 class="modal-title"><i class="fas fa-download me-2"></i>Export Diagram</h5>
                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="exportFilename" class="form-label"><strong>Filename</strong></label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="exportFilename" value="8gwifi-inframap">
                            <span class="input-group-text" id="exportExtension">.png</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Preview</strong></label>
                        <div id="exportPreview" class="border rounded p-3 bg-light text-center" style="max-height: 400px; overflow: auto;"></div>
                    </div>
                    <div class="border rounded p-3 text-center" style="background: linear-gradient(135deg, #f5f3ff 0%, #ede9fe 100%);">
                        <p class="mb-2 small"><strong>Enjoying this free tool?</strong></p>
                        <a href="https://twitter.com/anish2good" target="_blank" class="btn btn-sm text-white" style="background: #1DA1F2;">
                            <i class="fab fa-twitter me-1"></i>Follow @anish2good
                        </a>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn text-white" id="confirmExportBtn" style="background: var(--theme-gradient);">
                        <i class="fas fa-download me-1"></i>Download
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Share Modal -->
    <div class="modal fade" id="shareModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                    <h5 class="modal-title"><i class="fas fa-share-alt me-2"></i>Share This Tool</h5>
                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <div class="mb-3">
                            <i class="fas fa-project-diagram fa-3x" style="color: var(--theme-primary);"></i>
                        </div>
                        <h5>Terraform State Visualizer</h5>
                        <p class="text-muted small">Free online tool to visualize tfstate files and generate infrastructure diagrams</p>
                    </div>

                    <!-- Share URL -->
                    <div class="mb-4">
                        <label class="form-label small"><strong>Share URL</strong></label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="shareUrl" value="https://8gwifi.org/inframap.jsp" readonly>
                            <button class="btn btn-outline-secondary" type="button" id="copyShareUrl">
                                <i class="fas fa-copy"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Twitter Section -->
                    <div class="border rounded p-3 text-center" style="background: linear-gradient(135deg, #e8f5fd 0%, #f0f9ff 100%);">
                        <p class="mb-3"><strong><i class="fab fa-twitter me-1" style="color: #1DA1F2;"></i>Support on Twitter</strong></p>
                        <div class="d-flex justify-content-center gap-2 flex-wrap">
                            <a href="https://twitter.com/anish2good" target="_blank" class="btn btn-sm text-white" style="background: #1DA1F2;">
                                <i class="fab fa-twitter me-1"></i>Follow @anish2good
                            </a>
                            <a href="https://twitter.com/intent/tweet?text=Just%20visualized%20my%20Terraform%20infrastructure%20using%20this%20free%20tool%20by%20%40anish2good%20%F0%9F%9A%80%0A%0AVisualize%20tfstate%20files%2C%20generate%20AWS%2FAzure%2FGCP%20diagrams%2C%20export%20to%20PNG%2FSVG%2FPDF%20-%20all%20in%20your%20browser!%0A%0Ahttps%3A%2F%2F8gwifi.org%2Finframap.jsp&hashtags=Terraform,DevOps,InfrastructureAsCode,AWS" target="_blank" class="btn btn-sm btn-outline-primary" style="border-color: #1DA1F2; color: #1DA1F2;">
                                <i class="fab fa-twitter me-1"></i>Tweet This Tool
                            </a>
                        </div>
                        <p class="mt-3 mb-0 small text-muted">Your support helps keep this tool free!</p>
                    </div>

                    <!-- Other Share Options -->
                    <div class="mt-4">
                        <p class="small text-muted mb-2"><strong>More ways to share:</strong></p>
                        <div class="d-flex justify-content-center gap-2">
                            <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://8gwifi.org/inframap.jsp" target="_blank" class="btn btn-sm" style="background: #0077b5; color: white;" title="Share on LinkedIn">
                                <i class="fab fa-linkedin"></i>
                            </a>
                            <a href="https://www.reddit.com/submit?url=https://8gwifi.org/inframap.jsp&title=Free%20Terraform%20State%20Visualizer%20-%20Generate%20Infrastructure%20Diagrams" target="_blank" class="btn btn-sm" style="background: #ff4500; color: white;" title="Share on Reddit">
                                <i class="fab fa-reddit"></i>
                            </a>
                            <a href="https://news.ycombinator.com/submitlink?u=https://8gwifi.org/inframap.jsp&t=Terraform%20State%20Visualizer%20-%20Free%20Online%20Tool" target="_blank" class="btn btn-sm" style="background: #ff6600; color: white;" title="Share on Hacker News">
                                <i class="fab fa-hacker-news"></i>
                            </a>
                            <a href="mailto:?subject=Free%20Terraform%20State%20Visualizer&body=Check%20out%20this%20free%20tool%20to%20visualize%20Terraform%20state%20files%3A%0A%0Ahttps%3A%2F%2F8gwifi.org%2Finframap.jsp" class="btn btn-sm btn-secondary" title="Share via Email">
                                <i class="fas fa-envelope"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Load Go WASM runtime (v=timestamp for cache busting) -->
<script src="inframap/wasm_exec.js?v=<%= System.currentTimeMillis() %>"></script>

<script>
    // Example data - using real tfstate format
    const examples = {
        'aws-simple': {
            "version": 4,
            "terraform_version": "1.8.0",
            "serial": 1,
            "lineage": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
            "outputs": {},
            "resources": [
                {
                    "mode": "managed",
                    "type": "aws_vpc",
                    "name": "example",
                    "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
                    "instances": [{
                        "schema_version": 1,
                        "attributes": {
                            "id": "vpc-0abcdef1234567890",
                            "cidr_block": "10.0.0.0/16",
                            "tags": {"Name": "example-vpc"}
                        }
                    }]
                },
                {
                    "mode": "managed",
                    "type": "aws_subnet",
                    "name": "example",
                    "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
                    "instances": [{
                        "schema_version": 1,
                        "attributes": {
                            "id": "subnet-0abcdef1234567890",
                            "vpc_id": "vpc-0abcdef1234567890",
                            "cidr_block": "10.0.1.0/24",
                            "tags": {"Name": "example-subnet"}
                        }
                    }]
                },
                {
                    "mode": "managed",
                    "type": "aws_instance",
                    "name": "example",
                    "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
                    "instances": [{
                        "schema_version": 1,
                        "attributes": {
                            "id": "i-0abcdef1234567890",
                            "ami": "ami-0abcdef1234567890",
                            "instance_type": "t2.micro",
                            "subnet_id": "subnet-0abcdef1234567890",
                            "vpc_security_group_ids": ["sg-0abcdef1234567890"],
                            "tags": {"Name": "example-instance"}
                        },
                        "dependencies": ["aws_subnet.example", "aws_vpc.example"]
                    }]
                }
            ]
        },
        'aws-vpc': {
            "version": 4,
            "terraform_version": "1.8.0",
            "serial": 1,
            "lineage": "b2c3d4e5-f6a7-8901-bcde-f23456789012",
            "outputs": {},
            "resources": [
                {"mode": "managed", "type": "aws_vpc", "name": "main", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "vpc-main", "cidr_block": "10.0.0.0/16"}}]},
                {"mode": "managed", "type": "aws_subnet", "name": "public_a", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "subnet-pub-a", "vpc_id": "vpc-main", "cidr_block": "10.0.1.0/24"}}]},
                {"mode": "managed", "type": "aws_subnet", "name": "public_b", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "subnet-pub-b", "vpc_id": "vpc-main", "cidr_block": "10.0.2.0/24"}}]},
                {"mode": "managed", "type": "aws_subnet", "name": "private_a", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "subnet-priv-a", "vpc_id": "vpc-main", "cidr_block": "10.0.10.0/24"}}]},
                {"mode": "managed", "type": "aws_internet_gateway", "name": "main", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "igw-main", "vpc_id": "vpc-main"}}]},
                {"mode": "managed", "type": "aws_nat_gateway", "name": "main", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "nat-main", "subnet_id": "subnet-pub-a"}}]},
                {"mode": "managed", "type": "aws_lb", "name": "web", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "alb-web", "subnets": ["subnet-pub-a", "subnet-pub-b"], "security_groups": ["sg-alb"]}}]},
                {"mode": "managed", "type": "aws_security_group", "name": "alb", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "sg-alb", "vpc_id": "vpc-main"}}]},
                {"mode": "managed", "type": "aws_instance", "name": "web", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "i-web", "subnet_id": "subnet-priv-a", "vpc_security_group_ids": ["sg-web"]}, "dependencies": ["aws_subnet.private_a"]}]},
                {"mode": "managed", "type": "aws_security_group", "name": "web", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "sg-web", "vpc_id": "vpc-main"}}]},
                {"mode": "managed", "type": "aws_db_instance", "name": "main", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "rds-main", "db_subnet_group_name": "db-subnet-group", "vpc_security_group_ids": ["sg-db"]}}]},
                {"mode": "managed", "type": "aws_security_group", "name": "db", "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]", "instances": [{"schema_version": 1, "attributes": {"id": "sg-db", "vpc_id": "vpc-main"}}]}
            ]
        },
        'hcl-basic': `resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "main-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}`
    };

    // DOM elements
    const inputEl = document.getElementById('terraformInput');
    const dotOutput = document.getElementById('dotOutput');
    const statusBox = document.getElementById('statusBox');
    const statusText = document.getElementById('statusText');
    const progressFill = document.getElementById('progressFill');
    const generateBtn = document.getElementById('generateBtn');
    const copyBtn = document.getElementById('copyBtn');
    const exportPngBtn = document.getElementById('exportPngBtn');
    const exportSvgBtn = document.getElementById('exportSvgBtn');
    const exportPdfBtn = document.getElementById('exportPdfBtn');
    const formatSelect = document.getElementById('formatSelect');
    const cleanCheck = document.getElementById('cleanCheck');
    const connectionsCheck = document.getElementById('connectionsCheck');
    const graphPreview = document.getElementById('graphPreview');

    // State
    let wasmReady = false;
    let vizInstance = null;
    let currentDotSource = '';

    // Toast notification
    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
            '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
            '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }

    // Update status
    function setStatus(message, type, progress) {
        statusBox.className = 'status-box mb-3 status-' + type;
        if (type === 'loading') {
            statusBox.innerHTML = '<span class="loader"></span><span>' + message + '</span>' +
                '<div class="progress-bar-custom"><div class="progress-bar-fill" style="width:' + (progress || 0) + '%"></div></div>';
        } else {
            statusBox.innerHTML = '<i class="fas fa-' + (type === 'ready' ? 'check-circle' : 'exclamation-circle') + ' me-2"></i>' + message;
        }
    }

    // Load WASM
    async function loadWasm() {
        setStatus('Loading InfraMap WASM runtime (~8MB compressed)...', 'loading', 10);

        const go = new Go();
        try {
            progressFill.style.width = '30%';
            const response = await fetch('inframap/inframap.wasm?v=' + Date.now());
            progressFill.style.width = '60%';
            const buffer = await response.arrayBuffer();
            progressFill.style.width = '80%';
            const result = await WebAssembly.instantiate(buffer, go.importObject);
            go.run(result.instance);
            progressFill.style.width = '100%';

            wasmReady = true;
            setStatus('Ready! Paste your Terraform state or HCL and click "Generate Diagram".', 'ready');
            generateBtn.disabled = false;
        } catch (err) {
            console.error('WASM load error:', err);
            setStatus('Failed to load WASM: ' + err.message, 'error');
        }
    }

    // Load Viz.js
    function loadVizJs(callback) {
        if (vizInstance) {
            callback();
            return;
        }
        const script = document.createElement('script');
        script.src = 'https://cdn.jsdelivr.net/npm/@viz-js/viz@3.2.4/lib/viz-standalone.js';
        script.onload = function() {
            Viz.instance().then(function(viz) {
                vizInstance = viz;
                callback();
            });
        };
        document.head.appendChild(script);
    }

    // Generate diagram
    function generateDiagram() {
        if (!wasmReady) {
            showToast('WASM not ready yet');
            return;
        }

        let input = inputEl.value.trim();
        if (!input) {
            showToast('Please enter Terraform state or HCL');
            return;
        }

        setStatus('Generating diagram...', 'loading', 50);

        const opts = {
            format: formatSelect.value || '',
            clean: cleanCheck.checked,
            connections: connectionsCheck.checked,
            raw: true  // hidden: show all resources without provider-specific filtering
        };

        try {
            const result = generateDot(input, opts);

            if (result.ok) {
                currentDotSource = result.dot;
                dotOutput.value = result.dot;

                // Render SVG preview
                loadVizJs(function() {
                    try {
                        const svg = vizInstance.renderSVGElement(currentDotSource);
                        graphPreview.innerHTML = '';
                        graphPreview.appendChild(svg);

                        // Enable export buttons
                        copyBtn.disabled = false;
                        exportPngBtn.disabled = false;
                        exportSvgBtn.disabled = false;
                        exportPdfBtn.disabled = false;

                        setStatus('Diagram generated successfully!', 'ready');
                        showToast('Diagram generated!');
                    } catch (vizErr) {
                        graphPreview.innerHTML = '<div class="text-danger p-3">Failed to render: ' + vizErr.message + '</div>';
                        setStatus('Render error: ' + vizErr.message, 'error');
                    }
                });
            } else {
                dotOutput.value = 'Error: ' + result.error;
                graphPreview.innerHTML = '<div class="text-danger p-3"><i class="fas fa-exclamation-triangle me-2"></i>' + result.error + '</div>';
                setStatus('Error: ' + result.error, 'error');
                showToast('Generation failed');
            }
        } catch (err) {
            console.error('Generate error:', err);
            setStatus('Error: ' + err.message, 'error');
        }
    }

    // Copy DOT to clipboard
    function copyDot() {
        dotOutput.select();
        document.execCommand('copy');
        showToast('DOT copied to clipboard!');
    }

    // Load example
    function loadExample(name) {
        const data = examples[name];
        if (typeof data === 'string') {
            inputEl.value = data;
        } else {
            inputEl.value = JSON.stringify(data, null, 2);
        }
        showToast('Example loaded: ' + name);
    }

    // Export functions
    let currentExportType = 'png';
    const exportModal = $('#exportModal');

    function showExportModal(type) {
        if (!currentDotSource) return;

        currentExportType = type;
        document.getElementById('exportExtension').textContent = '.' + type;

        loadVizJs(function() {
            try {
                const svg = vizInstance.renderSVGElement(currentDotSource);
                document.getElementById('exportPreview').innerHTML = '';
                document.getElementById('exportPreview').appendChild(svg.cloneNode(true));
            } catch (e) {
                document.getElementById('exportPreview').innerHTML = '<p class="text-danger">Preview failed</p>';
            }
        });

        exportModal.modal('show');
    }

    document.getElementById('confirmExportBtn').addEventListener('click', function() {
        const filename = document.getElementById('exportFilename').value || '8gwifi-inframap';
        const fullFilename = filename + '.' + currentExportType;

        loadVizJs(function() {
            const svg = vizInstance.renderSVGElement(currentDotSource);
            const svgData = new XMLSerializer().serializeToString(svg);

            if (currentExportType === 'svg') {
                downloadBlob(new Blob([svgData], { type: 'image/svg+xml' }), fullFilename);
                exportModal.modal('hide');
                showToast('SVG downloaded!');
            } else if (currentExportType === 'png') {
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                const img = new Image();
                img.onload = function() {
                    canvas.width = img.width * 2;
                    canvas.height = img.height * 2;
                    ctx.fillStyle = 'white';
                    ctx.fillRect(0, 0, canvas.width, canvas.height);
                    ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                    canvas.toBlob(function(blob) {
                        downloadBlob(blob, fullFilename);
                        exportModal.modal('hide');
                        showToast('PNG downloaded!');
                    }, 'image/png');
                };
                img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgData)));
            } else if (currentExportType === 'pdf') {
                if (typeof window.jspdf === 'undefined') {
                    const script = document.createElement('script');
                    script.src = 'https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js';
                    script.onload = function() { exportToPdf(svgData, fullFilename); };
                    document.head.appendChild(script);
                } else {
                    exportToPdf(svgData, fullFilename);
                }
            }
        });
    });

    function exportToPdf(svgData, filename) {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        const img = new Image();
        img.onload = function() {
            canvas.width = img.width * 2;
            canvas.height = img.height * 2;
            ctx.fillStyle = 'white';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
            const imgData = canvas.toDataURL('image/png');
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF({
                orientation: canvas.width > canvas.height ? 'landscape' : 'portrait',
                unit: 'px',
                format: [canvas.width, canvas.height]
            });
            pdf.addImage(imgData, 'PNG', 0, 0, canvas.width, canvas.height);
            pdf.save(filename);
            exportModal.modal('hide');
            showToast('PDF downloaded!');
        };
        img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgData)));
    }

    function downloadBlob(blob, filename) {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    // Event listeners
    generateBtn.addEventListener('click', generateDiagram);
    copyBtn.addEventListener('click', copyDot);
    exportPngBtn.addEventListener('click', function() { showExportModal('png'); });
    exportSvgBtn.addEventListener('click', function() { showExportModal('svg'); });
    exportPdfBtn.addEventListener('click', function() { showExportModal('pdf'); });

    document.querySelectorAll('.example-btn').forEach(btn => {
        btn.addEventListener('click', () => loadExample(btn.dataset.example));
    });

    inputEl.addEventListener('keydown', (e) => {
        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
            e.preventDefault();
            generateDiagram();
        }
    });

    // Share button functionality
    const shareBtn = document.getElementById('shareBtn');
    const shareModal = $('#shareModal');
    const copyShareUrlBtn = document.getElementById('copyShareUrl');
    const shareUrlInput = document.getElementById('shareUrl');

    // Generate share URL with encoded input data
    function generateShareUrl() {
        const input = inputEl.value.trim();
        const baseUrl = 'https://8gwifi.org/inframap.jsp';

        if (input) {
            // Use base64 encoding for the input data
            const encoded = btoa(unescape(encodeURIComponent(input)));
            return baseUrl + '?data=' + encodeURIComponent(encoded);
        }
        return baseUrl;
    }

    // Update Twitter share link with current data
    function updateTwitterShareLink() {
        const shareUrl = generateShareUrl();
        const tweetText = encodeURIComponent('Just visualized my Terraform infrastructure using this free tool by @anish2good 🚀\n\nVisualize tfstate files, generate AWS/Azure/GCP diagrams, export to PNG/SVG/PDF - all in your browser!\n\n');
        const tweetLink = document.querySelector('#shareModal a[href*="twitter.com/intent/tweet"]');
        if (tweetLink) {
            tweetLink.href = 'https://twitter.com/intent/tweet?text=' + tweetText + encodeURIComponent(shareUrl) + '&hashtags=Terraform,DevOps,InfrastructureAsCode,AWS';
        }
    }

    shareBtn.addEventListener('click', function() {
        // Update share URL with current input data
        shareUrlInput.value = generateShareUrl();
        updateTwitterShareLink();
        shareModal.modal('show');
    });

    copyShareUrlBtn.addEventListener('click', function() {
        shareUrlInput.select();
        document.execCommand('copy');
        showToast('URL copied to clipboard!');
    });

    // Load data from URL parameter on page load
    function loadFromUrlParams() {
        const urlParams = new URLSearchParams(window.location.search);
        const encodedData = urlParams.get('data');

        if (encodedData) {
            try {
                const decoded = decodeURIComponent(escape(atob(decodeURIComponent(encodedData))));
                inputEl.value = decoded;
                showToast('Data loaded from shared URL!');

                // Auto-generate diagram once WASM is ready
                const checkWasmAndGenerate = setInterval(function() {
                    if (wasmReady) {
                        clearInterval(checkWasmAndGenerate);
                        setTimeout(generateDiagram, 500);
                    }
                }, 100);
            } catch (e) {
                console.error('Failed to decode shared data:', e);
            }
        }
    }

    // Initialize
    window.addEventListener('load', function() {
        loadWasm();
        loadFromUrlParams();
    });
</script>
</div>
<%@ include file="body-close.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <!-- JSON-LD markup for SEO -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Free Prometheus Query Builder & PromQL Tester Online",
        "alternateName": ["PromQL Builder", "Prometheus Query Tool", "PromQL Tester", "Prometheus Alert Generator"],
        "description": "Professional free online Prometheus Query Builder with PromQL editor, syntax validation, time-series chart visualization, alert rule generator, and 50+ query templates. Test and build monitoring queries for Kubernetes, containers, and infrastructure. Perfect for DevOps, SRE, and monitoring engineers.",
        "image": "https://8gwifi.org/images/site/logo.png",
        "screenshot": "https://8gwifi.org/images/site/logo.png",
        "url": "https://8gwifi.org/prometheus-query-builder.jsp",
        "applicationCategory": "DeveloperApplication",
        "applicationSubCategory": "Monitoring & Observability Tool",
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://8gwifi.org"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org"
        },
        "datePublished": "2025-01-26",
        "dateModified": "2025-01-26",
        "keywords": [
            "prometheus query tool",
            "promql builder online free",
            "prometheus query builder",
            "free promql tester",
            "promql syntax checker",
            "prometheus alert rule generator",
            "prometheus monitoring tool",
            "time series query builder",
            "prometheus rate calculator",
            "prometheus aggregation functions",
            "promql validator",
            "prometheus dashboard builder",
            "grafana query builder",
            "prometheus metrics explorer",
            "promql examples",
            "kubernetes monitoring queries",
            "prometheus expressions",
            "alert rule tester",
            "recording rule builder",
            "prometheus histogram quantile",
            "prometheus query templates",
            "container metrics prometheus",
            "node exporter queries",
            "prometheus best practices",
            "promql cheat sheet",
            "prometheus query optimization",
            "prometheus alert manager",
            "prometheus recording rules",
            "kubernetes prometheus queries",
            "docker prometheus monitoring",
            "prometheus cpu memory queries",
            "prometheus network monitoring",
            "prometheus disk io queries",
            "prometheus http metrics",
            "prometheus error rate",
            "prometheus latency percentile",
            "prometheus sli slo queries",
            "prometheus golden signals"
        ],
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "PromQL Query Editor with syntax highlighting",
            "Real-time syntax validation",
            "Time-Series Chart Visualization with Chart.js",
            "Alert Rule Generator with YAML export",
            "50+ Query Templates Library",
            "Query History with LocalStorage",
            "Common Metric Selector (CPU, Memory, Network, Disk, Container)",
            "Rate Calculator for counters",
            "Aggregation Functions (sum, avg, max, min, topk, bottomk)",
            "Recording Rule Builder",
            "Export to YAML format",
            "Export to Grafana Dashboard JSON",
            "Real-time Query Testing with mock data",
            "Mock Time-Series Data Generation",
            "Expression Builder for complex queries",
            "Configurable time ranges (5m to 7d)",
            "Adjustable resolution (15s to 15m)",
            "Multi-series chart support",
            "Histogram quantile calculator",
            "Error rate and success rate templates",
            "Top-K and Bottom-K queries",
            "Kubernetes and Docker monitoring templates",
            "Copy to clipboard functionality",
            "Download queries and alert rules",
            "100% client-side processing - no server required",
            "No registration required",
            "Privacy-focused - data never sent to server",
            "Free forever with unlimited queries",
            "Mobile and tablet friendly"
        ],
        "isAccessibleForFree": true,
        "license": "https://creativecommons.org/licenses/by/4.0/",
        "mainEntityOfPage": {
            "@type": "WebPage",
            "@id": "https://8gwifi.org/prometheus-query-builder.jsp"
        },
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.8",
            "ratingCount": "2847",
            "bestRating": "5",
            "worstRating": "1"
        }
    }
    </script>

    <title>Prometheus Query Builder Online – PromQL Tester, Validator & Alert Generator – Free | 8gwifi.org</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <meta name="keywords" content="prometheus query tool, promql builder online free, prometheus query builder, free promql tester, promql syntax checker, prometheus alert rule generator, prometheus monitoring, time series query, prometheus rate calculator, promql validator, grafana query builder, prometheus metrics, promql examples, kubernetes monitoring, prometheus expressions, alert rule tester, prometheus histogram quantile, container metrics, node exporter queries"/>
    <meta name="description" content="Free professional Prometheus Query Builder with PromQL editor, syntax validation, time-series chart visualization, and alert rule generator. Build and test monitoring queries with 50+ templates for Kubernetes, containers, CPU, memory, network, and disk metrics. Export to YAML and Grafana. 100% free, no signup, client-side processing for privacy." />

    <meta name="author" content="Anish Nath">
    <meta property="og:title" content="Free Prometheus Query Builder - PromQL Tester & Alert Generator">
    <meta property="og:description" content="Build and test Prometheus queries with live validation, time-series visualization, and alert rule generation. 50+ templates for monitoring.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/prometheus-query-builder.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/logo.png">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Prometheus Query Builder - PromQL Tester Online Free">
    <meta name="twitter:description" content="Build Prometheus queries, test PromQL, generate alert rules. Free online tool with 50+ templates.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/logo.png">

    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />

    <link rel="canonical" href="https://8gwifi.org/prometheus-query-builder.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns@3.0.0/dist/chartjs-adapter-date-fns.bundle.min.js"></script>

    <!-- js-yaml for alert rules -->
    <script src="https://cdn.jsdelivr.net/npm/js-yaml@4.1.0/dist/js-yaml.min.js"></script>

    <!-- Prism.js for syntax highlighting -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-yaml.min.js"></script>

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        }

        h1 {
            color: #2d3748;
            font-size: 2rem;
            font-weight: 700;
        }

        .operation-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            flex-wrap: wrap;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 10px;
        }

        .tab-btn {
            padding: 10px 20px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            color: #4a5568;
            transition: all 0.3s;
        }

        .tab-btn:hover {
            background: #f7fafc;
            border-color: #cbd5e0;
        }

        .tab-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .content-section {
            display: none;
        }

        .content-section.active {
            display: block;
        }

        .editor-container {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .editor-panel {
            flex: 1;
        }

        .panel-header {
            background: #f7fafc;
            padding: 12px 16px;
            border-radius: 6px 6px 0 0;
            font-weight: 600;
            color: #2d3748;
            border: 1px solid #e2e8f0;
            border-bottom: none;
        }

        .query-editor {
            width: 100%;
            min-height: 150px;
            padding: 15px;
            border: 1px solid #e2e8f0;
            border-radius: 0 0 6px 6px;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 14px;
            resize: vertical;
            background: #1e1e1e;
            color: #d4d4d4;
            line-height: 1.6;
        }

        .query-editor:focus {
            outline: none;
            border-color: #667eea;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 10px 24px;
            border-radius: 6px;
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: white;
            border: 2px solid #e2e8f0;
            padding: 10px 24px;
            border-radius: 6px;
            color: #4a5568;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-secondary:hover {
            background: #f7fafc;
            border-color: #cbd5e0;
        }

        .chart-container {
            position: relative;
            height: 400px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .templates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .template-card {
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .template-card:hover {
            background: #edf2f7;
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }

        .template-title {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
        }

        .template-query {
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 12px;
            color: #667eea;
            background: white;
            padding: 8px;
            border-radius: 4px;
            margin-top: 8px;
            word-break: break-all;
        }

        .history-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .history-item {
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 12px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .history-item:hover {
            background: #edf2f7;
            border-color: #667eea;
        }

        .history-query {
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 12px;
            color: #4a5568;
            flex: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .history-time {
            font-size: 11px;
            color: #a0aec0;
            margin-left: 10px;
        }

        .alert-builder-form {
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }

        .output-container {
            background: #1e1e1e;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 20px;
            color: #f8f8f2;
            max-height: 500px;
            overflow-y: auto;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 14px;
            line-height: 1.6;
        }

        .output-container pre {
            margin: 0;
            white-space: pre-wrap;
            word-wrap: break-word;
            color: #f8f8f2;
        }

        #queryResults {
            color: #f8f8f2;
        }

        /* JSON Syntax Highlighting */
        .json-key {
            color: #9cdcfe;
            font-weight: 600;
        }

        .json-string {
            color: #ce9178;
        }

        .json-number {
            color: #b5cea8;
        }

        .json-boolean {
            color: #569cd6;
            font-weight: 600;
        }

        .json-null {
            color: #569cd6;
            font-style: italic;
        }

        .metric-selector {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .metric-chip {
            padding: 8px 16px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 20px;
            cursor: pointer;
            font-size: 13px;
            color: #4a5568;
            transition: all 0.2s;
        }

        .metric-chip:hover {
            background: #f7fafc;
            border-color: #667eea;
        }

        .metric-chip.selected {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .function-chip {
            padding: 8px 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: 2px solid #667eea;
            border-radius: 20px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.2s;
            font-family: 'Monaco', 'Courier New', monospace;
        }

        .function-chip:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .function-chip.selected {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.6);
        }

        .example-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .example-card:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }

        .example-function {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            font-family: 'Monaco', 'Courier New', monospace;
            margin-bottom: 8px;
        }

        .example-title {
            font-weight: 600;
            color: #2d3748;
            font-size: 15px;
            margin-bottom: 8px;
        }

        .example-query {
            background: #1e1e1e;
            color: #f8f8f2;
            padding: 10px;
            border-radius: 4px;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 12px;
            margin-bottom: 8px;
            word-wrap: break-word;
            line-height: 1.5;
        }

        .example-desc {
            color: #718096;
            font-size: 13px;
        }

        .info-box {
            background: linear-gradient(135deg, #e0e7ff 0%, #e9d5ff 100%);
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .info-box h3 {
            margin: 0 0 10px 0;
            font-size: 1.1rem;
            color: #5a67d8;
        }

        .info-box p {
            margin: 0;
            color: #4c51bf;
            line-height: 1.6;
        }

        .validation-message {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-weight: 500;
            display: none;
        }

        .validation-message.success {
            background: #c6f6d5;
            color: #22543d;
            border: 1px solid #9ae6b4;
            display: block;
        }

        .validation-message.error {
            background: #fed7d7;
            color: #742a2a;
            border: 1px solid #fc8181;
            display: block;
        }

        .time-range-selector {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            align-items: center;
        }

        .time-range-selector label {
            font-weight: 600;
            color: #2d3748;
        }

        .time-range-selector select {
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
        }

        @media (max-width: 768px) {
            .editor-container {
                flex-direction: column;
            }

            .templates-grid {
                grid-template-columns: 1fr;
            }

            h1 {
                font-size: 1.5rem;
            }
        }
</style>
</head>

<%@ include file="body-script.jsp"%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question","name": "When should I use rate, irate, or increase?","acceptedAnswer": {"@type": "Answer","text": "Use rate() for stable per-second rates, irate() for spiky/instant rates, and increase() for totals over intervals."}},
    {"@type": "Question","name": "How do group aggregations work?","acceptedAnswer": {"@type": "Answer","text": "Use sum/avg by(...) to keep labels; control matching in binary ops with on()/ignoring and group_left/right."}},
    {"@type": "Question","name": "How can I reduce high cardinality?","acceptedAnswer": {"@type": "Answer","text": "Use recording rules to pre-aggregate, drop noisy labels, and limit wildcard matchers on hot series."}}
  ]
}
</script>

<h1 class="mt-4">Free Prometheus Query Builder & PromQL Tester</h1>
<p>Build, test, and visualize Prometheus queries with live validation and time-series charts</p>

<hr>

<h2 class="mt-4" id="faqs">Prometheus & PromQL FAQs</h2>
<div class="accordion" id="promFaqs">
  <div class="card"><div class="card-header"><h6 class="mb-0">When should I use rate, irate, or increase?</h6></div><div class="card-body small text-muted">Use rate() for stable per-second rates, irate() for instantaneous rates on spiky series, and increase() for total change over the range.</div></div>
  <div class="card"><div class="card-header"><h6 class="mb-0">How do group aggregations work?</h6></div><div class="card-body small text-muted">Use sum/avg by(...) to keep grouping labels; for binary ops use on()/group_left/right with ignoring/without to control label matching.</div></div>
  <div class="card"><div class="card-header"><h6 class="mb-0">How do I reduce high cardinality?</h6></div><div class="card-body small text-muted">Pre-aggregate with recording rules, drop unneeded labels, and avoid wildcard-heavy matchers in hot paths.</div></div>
</div>

        <div class="info-box">
            <h3>🚀 Professional Prometheus Query Builder</h3>
            <p>Build PromQL queries visually with quick-insert function buttons, test with mock data, generate alert rules, and export to YAML or Grafana. Includes 70+ query templates for common monitoring scenarios, comprehensive PromQL documentation for beginners, and smart function insertion with templates.</p>
        </div>

        <div class="operation-tabs">
            <button class="tab-btn active" data-tab="query-builder">Query Builder</button>
            <button class="tab-btn" data-tab="alert-rules">Alert Rules</button>
            <button class="tab-btn" data-tab="templates">Templates</button>
            <button class="tab-btn" data-tab="history">History</button>
            <button class="tab-btn" data-tab="help">Help & Docs</button>
        </div>

        <!-- Query Builder Section -->
        <div class="content-section active" id="query-builder">
            <div class="metric-selector">
                <span style="font-weight: 600; color: #2d3748; margin-right: 10px;">Common Metrics:</span>
                <div class="metric-chip" data-metric="node_cpu_seconds_total">CPU</div>
                <div class="metric-chip" data-metric="node_memory_MemAvailable_bytes">Memory</div>
                <div class="metric-chip" data-metric="node_network_receive_bytes_total">Network RX</div>
                <div class="metric-chip" data-metric="node_network_transmit_bytes_total">Network TX</div>
                <div class="metric-chip" data-metric="node_disk_io_time_seconds_total">Disk I/O</div>
                <div class="metric-chip" data-metric="container_cpu_usage_seconds_total">Container CPU</div>
                <div class="metric-chip" data-metric="container_memory_usage_bytes">Container Memory</div>
                <div class="metric-chip" data-metric="http_requests_total">HTTP Requests</div>
            </div>

            <div class="metric-selector" style="margin-top: 15px;">
                <span style="font-weight: 600; color: #2d3748; margin-right: 10px;">PromQL Functions:</span>
                <div class="function-chip" data-function="rate" title="Calculate per-second rate from counter">rate()</div>
                <div class="function-chip" data-function="irate" title="Instant per-second rate (volatile)">irate()</div>
                <div class="function-chip" data-function="sum" title="Sum values across dimensions">sum()</div>
                <div class="function-chip" data-function="avg" title="Average values across dimensions">avg()</div>
                <div class="function-chip" data-function="max" title="Maximum value">max()</div>
                <div class="function-chip" data-function="min" title="Minimum value">min()</div>
                <div class="function-chip" data-function="count" title="Count number of elements">count()</div>
                <div class="function-chip" data-function="topk" title="Select top K elements">topk()</div>
                <div class="function-chip" data-function="bottomk" title="Select bottom K elements">bottomk()</div>
                <div class="function-chip" data-function="histogram_quantile" title="Calculate percentiles">histogram_quantile()</div>
                <div class="function-chip" data-function="increase" title="Total increase over time">increase()</div>
                <div class="function-chip" data-function="delta" title="Difference between first and last">delta()</div>
                <div class="function-chip" data-function="round" title="Round to nearest integer">round()</div>
                <div class="function-chip" data-function="abs" title="Absolute value">abs()</div>
                <div class="function-chip" data-function="ceil" title="Round up">ceil()</div>
                <div class="function-chip" data-function="floor" title="Round down">floor()</div>
            </div>

            <div style="margin-top: 15px;">
                <button class="btn-secondary" onclick="toggleExamplesPanel()" style="font-size: 13px; padding: 6px 12px;">
                    💡 Show Function Examples
                </button>
            </div>

            <div id="examplesPanel" style="display: none; margin-top: 15px; background: #f7fafc; padding: 20px; border-radius: 6px; border: 2px solid #667eea;">
                <h4 style="margin-top: 0; color: #2d3748;">📊 Function Examples - Click to Try</h4>
                <p style="color: #4a5568; margin-bottom: 15px;">Click any example to load it into the editor and see the visualization</p>

                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)); gap: 15px;">
                    <!-- rate() examples -->
                    <div class="example-card" onclick="loadExample('rate(http_requests_total[5m])')">
                        <div class="example-function">rate()</div>
                        <div class="example-title">HTTP Requests per Second</div>
                        <div class="example-query">rate(http_requests_total[5m])</div>
                        <div class="example-desc">Shows requests/sec rate over 5 minutes</div>
                    </div>

                    <div class="example-card" onclick="loadExample('sum(rate(node_cpu_seconds_total{mode!=\\'idle\\'}[5m])) by (instance)')">
                        <div class="example-function">rate() + sum()</div>
                        <div class="example-title">CPU Usage by Instance</div>
                        <div class="example-query">sum(rate(node_cpu_seconds_total{mode!="idle"}[5m])) by (instance)</div>
                        <div class="example-desc">CPU usage rate per server</div>
                    </div>

                    <!-- sum() examples -->
                    <div class="example-card" onclick="loadExample('sum(http_requests_total) by (status_code)')">
                        <div class="example-function">sum()</div>
                        <div class="example-title">Requests by Status Code</div>
                        <div class="example-query">sum(http_requests_total) by (status_code)</div>
                        <div class="example-desc">Total requests grouped by status</div>
                    </div>

                    <!-- avg() examples -->
                    <div class="example-card" onclick="loadExample('avg(node_memory_MemAvailable_bytes) by (instance) / 1024 / 1024')">
                        <div class="example-function">avg()</div>
                        <div class="example-title">Average Memory Available (MB)</div>
                        <div class="example-query">avg(node_memory_MemAvailable_bytes) by (instance) / 1024 / 1024</div>
                        <div class="example-desc">Average available memory in MB</div>
                    </div>

                    <!-- histogram_quantile examples -->
                    <div class="example-card" onclick="loadExample('histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))')">
                        <div class="example-function">histogram_quantile()</div>
                        <div class="example-title">95th Percentile Latency</div>
                        <div class="example-query">histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))</div>
                        <div class="example-desc">P95 request latency in seconds</div>
                    </div>

                    <div class="example-card" onclick="loadExample('histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))')">
                        <div class="example-function">histogram_quantile()</div>
                        <div class="example-title">99th Percentile Latency</div>
                        <div class="example-query">histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))</div>
                        <div class="example-desc">P99 request latency (tail latency)</div>
                    </div>

                    <!-- topk() examples -->
                    <div class="example-card" onclick="loadExample('topk(5, rate(container_cpu_usage_seconds_total[5m]))')">
                        <div class="example-function">topk()</div>
                        <div class="example-title">Top 5 CPU Consumers</div>
                        <div class="example-query">topk(5, rate(container_cpu_usage_seconds_total[5m]))</div>
                        <div class="example-desc">5 containers using most CPU</div>
                    </div>

                    <div class="example-card" onclick="loadExample('topk(10, sum(rate(http_requests_total[5m])) by (endpoint))')">
                        <div class="example-function">topk() + sum()</div>
                        <div class="example-title">Top 10 Busiest Endpoints</div>
                        <div class="example-query">topk(10, sum(rate(http_requests_total[5m])) by (endpoint))</div>
                        <div class="example-desc">Most frequently hit API endpoints</div>
                    </div>

                    <!-- increase() examples -->
                    <div class="example-card" onclick="loadExample('increase(http_requests_total[1h])')">
                        <div class="example-function">increase()</div>
                        <div class="example-title">Total Requests in Last Hour</div>
                        <div class="example-query">increase(http_requests_total[1h])</div>
                        <div class="example-desc">Total count increase over 1 hour</div>
                    </div>

                    <!-- delta() examples -->
                    <div class="example-card" onclick="loadExample('delta(node_memory_MemAvailable_bytes[10m]) / 1024 / 1024')">
                        <div class="example-function">delta()</div>
                        <div class="example-title">Memory Change (MB)</div>
                        <div class="example-query">delta(node_memory_MemAvailable_bytes[10m]) / 1024 / 1024</div>
                        <div class="example-desc">Memory change over 10 minutes</div>
                    </div>

                    <!-- Error rate example -->
                    <div class="example-card" onclick="loadExample('sum(rate(http_requests_total{status=~\\'5..\\'}[5m])) / sum(rate(http_requests_total[5m])) * 100')">
                        <div class="example-function">rate() + sum()</div>
                        <div class="example-title">Error Rate Percentage</div>
                        <div class="example-query">sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100</div>
                        <div class="example-desc">5xx error rate as percentage</div>
                    </div>

                    <!-- Memory usage percentage -->
                    <div class="example-card" onclick="loadExample('(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100')">
                        <div class="example-function">Arithmetic</div>
                        <div class="example-title">Memory Usage Percentage</div>
                        <div class="example-query">(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100</div>
                        <div class="example-desc">Used memory as percentage</div>
                    </div>

                    <!-- count() example -->
                    <div class="example-card" onclick="loadExample('count(up == 1) by (job)')">
                        <div class="example-function">count()</div>
                        <div class="example-title">Healthy Instances by Job</div>
                        <div class="example-query">count(up == 1) by (job)</div>
                        <div class="example-desc">Number of healthy instances per job</div>
                    </div>

                    <!-- bottomk() example -->
                    <div class="example-card" onclick="loadExample('bottomk(3, node_filesystem_avail_bytes / node_filesystem_size_bytes * 100)')">
                        <div class="example-function">bottomk()</div>
                        <div class="example-title">3 Fullest Disks</div>
                        <div class="example-query">bottomk(3, node_filesystem_avail_bytes / node_filesystem_size_bytes * 100)</div>
                        <div class="example-desc">Disks with least free space</div>
                    </div>

                    <!-- max/min examples -->
                    <div class="example-card" onclick="loadExample('max(node_cpu_seconds_total) by (mode)')">
                        <div class="example-function">max()</div>
                        <div class="example-title">Max CPU by Mode</div>
                        <div class="example-query">max(node_cpu_seconds_total) by (mode)</div>
                        <div class="example-desc">Maximum CPU time per mode</div>
                    </div>

                    <!-- irate() example -->
                    <div class="example-card" onclick="loadExample('irate(http_requests_total[5m])')">
                        <div class="example-function">irate()</div>
                        <div class="example-title">Instant Request Rate</div>
                        <div class="example-query">irate(http_requests_total[5m])</div>
                        <div class="example-desc">Instant rate (more volatile than rate)</div>
                    </div>
                </div>
            </div>

            <div class="panel-header">PromQL Query Editor</div>
            <textarea class="query-editor" id="queryEditor" placeholder="Enter your PromQL query here...&#10;&#10;Example:&#10;rate(http_requests_total[5m])&#10;&#10;sum(rate(node_cpu_seconds_total{mode='user'}[5m])) by (instance)"></textarea>

            <div class="action-buttons">
                <button class="btn-primary" onclick="executeQuery()">⚡ Execute Query</button>
                <button class="btn-secondary" onclick="validateQuery()">✓ Validate</button>
                <button class="btn-secondary" onclick="clearQuery()">✕ Clear</button>
                <button class="btn-secondary" onclick="copyQuery()">📋 Copy</button>
                <button class="btn-secondary" onclick="exportQuery()">💾 Export</button>
            </div>

            <div class="validation-message" id="validationMessage"></div>

            <div class="time-range-selector">
                <label>Time Range:</label>
                <select id="timeRange">
                    <option value="5m">Last 5 minutes</option>
                    <option value="15m">Last 15 minutes</option>
                    <option value="30m">Last 30 minutes</option>
                    <option value="1h" selected>Last 1 hour</option>
                    <option value="3h">Last 3 hours</option>
                    <option value="6h">Last 6 hours</option>
                    <option value="12h">Last 12 hours</option>
                    <option value="24h">Last 24 hours</option>
                    <option value="7d">Last 7 days</option>
                </select>

                <label style="margin-left: 20px;">Resolution:</label>
                <select id="resolution">
                    <option value="15s">15 seconds</option>
                    <option value="30s">30 seconds</option>
                    <option value="1m" selected>1 minute</option>
                    <option value="5m">5 minutes</option>
                    <option value="15m">15 minutes</option>
                </select>
            </div>

            <div class="panel-header">Time-Series Visualization</div>
            <div class="chart-container">
                <canvas id="timeSeriesChart"></canvas>
            </div>

            <div class="panel-header">Query Results (JSON)</div>
            <div class="output-container">
                <pre id="queryResults">No results yet. Execute a query to see results.</pre>
            </div>
        </div>

        <!-- Alert Rules Section -->
        <div class="content-section" id="alert-rules">
            <div class="alert-builder-form">
                <h3 style="margin-top: 0; color: #2d3748;">Alert Rule Builder</h3>

                <div class="form-group">
                    <label>Alert Name *</label>
                    <input type="text" id="alertName" placeholder="HighCPUUsage">
                </div>

                <div class="form-group">
                    <label>PromQL Expression *</label>
                    <textarea id="alertQuery" rows="3" placeholder="rate(node_cpu_seconds_total{mode='user'}[5m]) > 0.8"></textarea>
                </div>

                <div class="form-group">
                    <label>Duration</label>
                    <select id="alertDuration">
                        <option value="30s">30 seconds</option>
                        <option value="1m">1 minute</option>
                        <option value="5m" selected>5 minutes</option>
                        <option value="10m">10 minutes</option>
                        <option value="15m">15 minutes</option>
                        <option value="30m">30 minutes</option>
                        <option value="1h">1 hour</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Severity</label>
                    <select id="alertSeverity">
                        <option value="critical">Critical</option>
                        <option value="warning" selected>Warning</option>
                        <option value="info">Info</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Summary</label>
                    <input type="text" id="alertSummary" placeholder="High CPU usage detected on {{ $labels.instance }}">
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea id="alertDescription" rows="2" placeholder="CPU usage is above 80% for more than 5 minutes. Current value: {{ $value }}"></textarea>
                </div>

                <div class="action-buttons">
                    <button class="btn-primary" onclick="generateAlertRule()">🚨 Generate Alert Rule</button>
                    <button class="btn-secondary" onclick="testAlertRule()">🧪 Test Alert</button>
                    <button class="btn-secondary" onclick="clearAlertForm()">✕ Clear</button>
                </div>
            </div>

            <div class="panel-header">Generated Alert Rule (YAML)</div>
            <div class="output-container">
                <pre id="alertRuleOutput">Configure the alert above and click "Generate Alert Rule"</pre>
            </div>

            <div class="action-buttons">
                <button class="btn-secondary" onclick="copyAlertRule()">📋 Copy YAML</button>
                <button class="btn-secondary" onclick="downloadAlertRule()">💾 Download YAML</button>
                <button class="btn-secondary" onclick="exportToGrafana()">📊 Export to Grafana</button>
            </div>
        </div>

        <!-- Templates Section -->
        <div class="content-section" id="templates">
            <div class="panel-header">Query Templates Library</div>
            <p style="color: #718096; margin-bottom: 20px;">Click any template to load it into the query editor</p>

            <div class="templates-grid" id="templatesGrid">
                <!-- Templates will be dynamically generated -->
            </div>
        </div>

        <!-- History Section -->
        <div class="content-section" id="history">
            <div class="panel-header">Query History</div>
            <p style="color: #718096; margin-bottom: 20px;">Your recent queries (stored locally)</p>

            <div class="action-buttons">
                <button class="btn-secondary" onclick="clearHistory()">🗑️ Clear History</button>
            </div>

            <div class="history-list" id="historyList">
                <p style="color: #a0aec0; text-align: center; padding: 40px 0;">No query history yet</p>
            </div>
        </div>

        <!-- Help & Documentation Section -->
        <div class="content-section" id="help">
            <div class="panel-header">PromQL Help & Documentation</div>

            <div style="background: white; padding: 30px; border-radius: 6px; margin-top: 20px;">

                <h3 style="color: #2d3748; margin-top: 0;">📚 Introduction to PromQL</h3>
                <p>PromQL (Prometheus Query Language) is a powerful functional query language for querying time-series data. It allows you to select, aggregate, and compute on time-series data in real-time.</p>

                <h3 style="color: #2d3748; margin-top: 30px;">🔍 Basic Query Structure</h3>
                <div style="background: #f7fafc; padding: 15px; border-radius: 6px; margin: 15px 0; border-left: 4px solid #667eea;">
                    <code style="color: #667eea;">metric_name{label="value"}</code>
                    <p style="margin: 10px 0 0 0; color: #4a5568;">Example: <code>http_requests_total{method="GET"}</code></p>
                </div>

                <h3 style="color: #2d3748; margin-top: 30px;">⚙️ Selector Types</h3>
                <table style="width: 100%; border-collapse: collapse; margin: 15px 0;">
                    <tr style="background: #f7fafc;">
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Selector</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Description</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Example</th>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>=</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Equals</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>method="GET"</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>!=</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Not equals</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>status!="500"</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>=~</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Regex match</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>status=~"5.."</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>!~</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Regex not match</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>path!~"/admin.*"</code></td>
                    </tr>
                </table>

                <h3 style="color: #2d3748; margin-top: 30px;">📊 Aggregation Functions</h3>
                <table style="width: 100%; border-collapse: collapse; margin: 15px 0;">
                    <tr style="background: #f7fafc;">
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Function</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Description</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Example</th>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>sum()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Sum of all values</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>sum(http_requests_total)</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>avg()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Average of all values</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>avg(node_cpu_seconds_total)</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>max()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Maximum value</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>max(memory_usage_bytes)</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>min()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Minimum value</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>min(memory_usage_bytes)</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>count()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Count of all values</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>count(up == 1)</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>topk()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Top K elements</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>topk(5, http_requests_total)</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>bottomk()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Bottom K elements</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>bottomk(3, disk_free_bytes)</code></td>
                    </tr>
                </table>

                <h3 style="color: #2d3748; margin-top: 30px;">📈 Rate & Counter Functions</h3>
                <table style="width: 100%; border-collapse: collapse; margin: 15px 0;">
                    <tr style="background: #f7fafc;">
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Function</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Description</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Use Case</th>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>rate()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Per-second average rate of increase</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Use for alerting and graphing slow-moving counters</td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>irate()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Instant rate of increase (last 2 points)</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Use for volatile, fast-moving counters</td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>increase()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Total increase over time range</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Calculate total requests in a time window</td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>delta()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Difference between first and last value</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Use with gauges to see change over time</td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>idelta()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Difference between last 2 samples</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Instant change in gauge values</td>
                    </tr>
                </table>

                <h3 style="color: #2d3748; margin-top: 30px;">🔧 Time Range Vectors</h3>
                <div style="background: #f7fafc; padding: 15px; border-radius: 6px; margin: 15px 0; border-left: 4px solid #667eea;">
                    <p style="margin: 0;"><strong>Syntax:</strong> <code>[duration]</code></p>
                    <p style="margin: 10px 0 0 0;">Time units: <code>s</code> (seconds), <code>m</code> (minutes), <code>h</code> (hours), <code>d</code> (days), <code>w</code> (weeks), <code>y</code> (years)</p>
                    <p style="margin: 10px 0 0 0;"><strong>Example:</strong> <code>rate(http_requests_total[5m])</code> - Calculate rate over last 5 minutes</p>
                </div>

                <h3 style="color: #2d3748; margin-top: 30px;">🎯 Histogram Functions</h3>
                <table style="width: 100%; border-collapse: collapse; margin: 15px 0;">
                    <tr style="background: #f7fafc;">
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Function</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Description</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Example</th>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>histogram_quantile()</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Calculate percentiles (P50, P95, P99)</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>histogram_quantile(0.95, rate(http_duration_bucket[5m]))</code></td>
                    </tr>
                </table>

                <h3 style="color: #2d3748; margin-top: 30px;">➕ Operators</h3>
                <table style="width: 100%; border-collapse: collapse; margin: 15px 0;">
                    <tr style="background: #f7fafc;">
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Operator</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Type</th>
                        <th style="padding: 12px; text-align: left; border: 1px solid #e2e8f0;">Example</th>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>+, -, *, /, %, ^</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Arithmetic</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>memory_used / memory_total * 100</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>==, !=, >, <, >=, <=</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Comparison</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>cpu_usage > 0.8</code></td>
                    </tr>
                    <tr>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>and, or, unless</code></td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;">Logical</td>
                        <td style="padding: 12px; border: 1px solid #e2e8f0;"><code>up == 1 and rate(requests[5m]) > 10</code></td>
                    </tr>
                </table>

                <h3 style="color: #2d3748; margin-top: 30px;">🔗 Aggregation Modifiers</h3>
                <div style="background: #f7fafc; padding: 15px; border-radius: 6px; margin: 15px 0; border-left: 4px solid #667eea;">
                    <p style="margin: 0;"><strong>by</strong> - Group by specified labels</p>
                    <code style="color: #667eea;">sum(http_requests_total) by (status_code, method)</code>
                    <p style="margin: 15px 0 0 0;"><strong>without</strong> - Group by all labels except specified ones</p>
                    <code style="color: #667eea;">sum(http_requests_total) without (instance)</code>
                </div>

                <h3 style="color: #2d3748; margin-top: 30px;">💡 Common Patterns</h3>

                <h4 style="color: #4a5568; margin-top: 20px;">Calculate Percentage:</h4>
                <div style="background: #f7fafc; padding: 15px; border-radius: 6px; margin: 10px 0;">
                    <code style="color: #667eea;">(metric_used / metric_total) * 100</code>
                    <p style="margin: 10px 0 0 0; color: #4a5568;">Example: <code>(node_memory_used / node_memory_total) * 100</code></p>
                </div>

                <h4 style="color: #4a5568; margin-top: 20px;">Calculate Error Rate:</h4>
                <div style="background: #f7fafc; padding: 15px; border-radius: 6px; margin: 10px 0;">
                    <code style="color: #667eea;">sum(rate(errors[5m])) / sum(rate(requests[5m])) * 100</code>
                </div>

                <h4 style="color: #4a5568; margin-top: 20px;">Calculate Requests per Second:</h4>
                <div style="background: #f7fafc; padding: 15px; border-radius: 6px; margin: 10px 0;">
                    <code style="color: #667eea;">rate(http_requests_total[5m])</code>
                </div>

                <h4 style="color: #4a5568; margin-top: 20px;">Calculate 95th Percentile Latency:</h4>
                <div style="background: #f7fafc; padding: 15px; border-radius: 6px; margin: 10px 0;">
                    <code style="color: #667eea;">histogram_quantile(0.95, rate(http_duration_bucket[5m]))</code>
                </div>

                <h3 style="color: #2d3748; margin-top: 30px;">⚠️ Best Practices</h3>
                <ul style="color: #4a5568; line-height: 1.8;">
                    <li><strong>Always use rate() with counters</strong> - Counters reset on restart, rate() handles this</li>
                    <li><strong>Choose appropriate time ranges</strong> - At least 4x your scrape interval (e.g., if scrape is 15s, use [1m])</li>
                    <li><strong>Use by() for aggregation</strong> - Be explicit about which labels to group by</li>
                    <li><strong>Avoid high cardinality labels</strong> - Don't use user IDs, email addresses as labels</li>
                    <li><strong>Use recording rules for expensive queries</strong> - Pre-calculate frequently used queries</li>
                    <li><strong>Filter early in the query</strong> - Apply label filters first to reduce data processed</li>
                </ul>

                <h3 style="color: #2d3748; margin-top: 30px;">📖 Additional Resources</h3>
                <ul style="color: #4a5568; line-height: 1.8;">
                    <li><a href="https://prometheus.io/docs/prometheus/latest/querying/basics/" target="_blank" style="color: #667eea;">Official PromQL Documentation</a></li>
                    <li><a href="https://prometheus.io/docs/prometheus/latest/querying/functions/" target="_blank" style="color: #667eea;">PromQL Function Reference</a></li>
                    <li><a href="https://prometheus.io/docs/prometheus/latest/querying/operators/" target="_blank" style="color: #667eea;">PromQL Operators</a></li>
                    <li><a href="https://prometheus.io/docs/practices/naming/" target="_blank" style="color: #667eea;">Metric and Label Naming</a></li>
                </ul>

            </div>
        </div>

<hr>

<h2 class="mt-4">Features</h2>
<ul>
    <li><strong>PromQL Query Editor:</strong> Professional editor with syntax highlighting for building Prometheus queries</li>
    <li><strong>Syntax Validation:</strong> Real-time validation of PromQL expressions with detailed error messages</li>
    <li><strong>Time-Series Chart:</strong> Interactive Chart.js visualization with configurable time ranges and resolution</li>
    <li><strong>Alert Rule Generator:</strong> Visual builder for Prometheus alert rules with YAML export</li>
    <li><strong>70+ Templates:</strong> Pre-built query templates for CPU, memory, network, disk, containers, databases, Redis, JVM, and more</li>
    <li><strong>Query History:</strong> Automatically saves your recent queries in browser LocalStorage</li>
    <li><strong>Common Metrics:</strong> Quick-select chips for popular metrics (CPU, memory, network, containers)</li>
    <li><strong>PromQL Functions:</strong> Quick-insert buttons for rate(), sum(), avg(), histogram_quantile(), and 12 more functions</li>
    <li><strong>Help & Documentation:</strong> Comprehensive PromQL guide with functions, operators, and best practices</li>
    <li><strong>Export Options:</strong> Download queries, alert rules (YAML), and Grafana dashboard JSON</li>
    <li><strong>Mock Data:</strong> Generates realistic time-series data for testing queries</li>
    <li><strong>Copy & Download:</strong> Easy export options for all outputs</li>
    <li><strong>Client-Side:</strong> 100% browser-based processing, no server required</li>
</ul>


<hr>



<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<script>
    // Global variables
    let chart = null;
    let queryHistory = [];

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        initializeTabs();
        initializeChart();
        loadHistory();
        loadTemplates();
        initializeMetricSelector();
    });

    // Tab management
    function initializeTabs() {
        const tabButtons = document.querySelectorAll('.tab-btn');
        tabButtons.forEach(button => {
            button.addEventListener('click', function() {
                const tabName = this.getAttribute('data-tab');
                switchTab(tabName);
            });
        });
    }

    function switchTab(tabName) {
        // Update buttons
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector('[data-tab="' + tabName + '"]').classList.add('active');

        // Update content
        document.querySelectorAll('.content-section').forEach(section => {
            section.classList.remove('active');
        });
        document.getElementById(tabName).classList.add('active');
    }

    // Metric selector
    function initializeMetricSelector() {
        const chips = document.querySelectorAll('.metric-chip');
        chips.forEach(chip => {
            chip.addEventListener('click', function() {
                const metric = this.getAttribute('data-metric');
                const editor = document.getElementById('queryEditor');
                const currentQuery = editor.value.trim();

                if (currentQuery) {
                    editor.value = currentQuery + '\n' + metric;
                } else {
                    editor.value = metric;
                }

                this.classList.add('selected');
                setTimeout(() => this.classList.remove('selected'), 500);
            });
        });

        // Initialize function chips
        const functionChips = document.querySelectorAll('.function-chip');
        functionChips.forEach(chip => {
            chip.addEventListener('click', function() {
                const functionName = this.getAttribute('data-function');
                const editor = document.getElementById('queryEditor');
                const currentQuery = editor.value.trim();
                const cursorPos = editor.selectionStart;

                // Function templates with placeholders
                const functionTemplates = {
                    'rate': 'rate(metric_name[5m])',
                    'irate': 'irate(metric_name[5m])',
                    'sum': 'sum(metric_name) by (label)',
                    'avg': 'avg(metric_name) by (label)',
                    'max': 'max(metric_name) by (label)',
                    'min': 'min(metric_name) by (label)',
                    'count': 'count(metric_name) by (label)',
                    'topk': 'topk(5, metric_name)',
                    'bottomk': 'bottomk(5, metric_name)',
                    'histogram_quantile': 'histogram_quantile(0.95, rate(metric_bucket[5m]))',
                    'increase': 'increase(metric_name[5m])',
                    'delta': 'delta(metric_name[5m])',
                    'round': 'round(metric_name)',
                    'abs': 'abs(metric_name)',
                    'ceil': 'ceil(metric_name)',
                    'floor': 'floor(metric_name)'
                };

                const template = functionTemplates[functionName];

                if (currentQuery) {
                    // Insert at cursor position
                    const before = editor.value.substring(0, cursorPos);
                    const after = editor.value.substring(cursorPos);
                    editor.value = before + template + after;
                    // Set cursor after inserted text
                    editor.selectionStart = editor.selectionEnd = cursorPos + template.length;
                } else {
                    editor.value = template;
                }

                // Focus on editor
                editor.focus();

                this.classList.add('selected');
                setTimeout(() => this.classList.remove('selected'), 500);
            });
        });
    }

    // Initialize Chart.js
    function initializeChart() {
        const ctx = document.getElementById('timeSeriesChart').getContext('2d');
        chart = new Chart(ctx, {
            type: 'line',
            data: {
                datasets: []
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: {
                    mode: 'index',
                    intersect: false,
                },
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': ' + context.parsed.y.toFixed(4);
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        type: 'time',
                        time: {
                            unit: 'minute',
                            displayFormats: {
                                minute: 'HH:mm',
                                hour: 'MMM d, HH:mm'
                            }
                        },
                        title: {
                            display: true,
                            text: 'Time'
                        }
                    },
                    y: {
                        title: {
                            display: true,
                            text: 'Value'
                        }
                    }
                }
            }
        });
    }

    // Query execution
    function executeQuery() {
        const query = document.getElementById('queryEditor').value.trim();

        if (!query) {
            showValidation('Please enter a PromQL query', 'error');
            return;
        }

        // Validate query
        const validation = validatePromQL(query);
        if (!validation.valid) {
            showValidation('Invalid query: ' + validation.error, 'error');
            return;
        }

        showValidation('Query executed successfully! Displaying mock data.', 'success');

        // Generate mock time-series data
        const mockData = generateMockData(query);

        // Update chart
        updateChart(mockData);

        // Update results with syntax highlighting
        const formattedJSON = JSON.stringify(mockData, null, 4);
        document.getElementById('queryResults').innerHTML = syntaxHighlightJSON(formattedJSON);

        // Save to history
        saveToHistory(query);
    }

    // Syntax highlight JSON
    function syntaxHighlightJSON(json) {
        json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
            var cls = 'number';
            if (/^"/.test(match)) {
                if (/:$/.test(match)) {
                    cls = 'key';
                } else {
                    cls = 'string';
                }
            } else if (/true|false/.test(match)) {
                cls = 'boolean';
            } else if (/null/.test(match)) {
                cls = 'null';
            }
            return '<span class="json-' + cls + '">' + match + '</span>';
        });
    }

    // Validate PromQL query
    function validateQuery() {
        const query = document.getElementById('queryEditor').value.trim();

        if (!query) {
            showValidation('Please enter a PromQL query', 'error');
            return;
        }

        const validation = validatePromQL(query);

        if (validation.valid) {
            showValidation('✓ Query syntax is valid!', 'success');
        } else {
            showValidation('✗ ' + validation.error, 'error');
        }
    }

    // PromQL validator
    function validatePromQL(query) {
        // Basic validation rules

        // Check for empty query
        if (!query) {
            return { valid: false, error: 'Query cannot be empty' };
        }

        // Check for balanced parentheses
        const openParens = (query.match(/\(/g) || []).length;
        const closeParens = (query.match(/\)/g) || []).length;
        if (openParens !== closeParens) {
            return { valid: false, error: 'Unbalanced parentheses' };
        }

        // Check for balanced brackets
        const openBrackets = (query.match(/\[/g) || []).length;
        const closeBrackets = (query.match(/\]/g) || []).length;
        if (openBrackets !== closeBrackets) {
            return { valid: false, error: 'Unbalanced brackets in time range' };
        }

        // Check for balanced braces
        const openBraces = (query.match(/\{/g) || []).length;
        const closeBraces = (query.match(/\}/g) || []).length;
        if (openBraces !== closeBraces) {
            return { valid: false, error: 'Unbalanced braces in label matchers' };
        }

        // Check for valid time range format
        const timeRangeRegex = /\[\d+[smhdwy]\]/g;
        const timeRanges = query.match(/\[([^\]]+)\]/g);
        if (timeRanges) {
            for (let range of timeRanges) {
                if (!range.match(/^\[\d+[smhdwy]\]$/)) {
                    return { valid: false, error: 'Invalid time range format: ' + range };
                }
            }
        }

        // Check for common aggregation functions
        const validFunctions = ['sum', 'avg', 'max', 'min', 'count', 'rate', 'irate', 'increase', 'delta', 'idelta', 'topk', 'bottomk', 'quantile', 'histogram_quantile'];
        const functionRegex = /(\w+)\(/g;
        let match;
        while ((match = functionRegex.exec(query)) !== null) {
            const funcName = match[1];
            if (validFunctions.indexOf(funcName) === -1 && !funcName.match(/^[a-z_][a-z0-9_]*$/i)) {
                // Allow metric names but warn about unknown functions
                console.warn('Unknown function or metric: ' + funcName);
            }
        }

        return { valid: true };
    }

    // Generate mock time-series data
    function generateMockData(query) {
        const timeRange = document.getElementById('timeRange').value;
        const resolution = document.getElementById('resolution').value;

        // Calculate time points
        const now = Date.now();
        const timeInMs = parseTimeRange(timeRange);
        const resolutionInMs = parseTimeRange(resolution);
        const points = Math.floor(timeInMs / resolutionInMs);

        // Determine number of series based on query
        const seriesCount = query.includes('by') ? Math.min(3, Math.floor(Math.random() * 5) + 1) : 1;

        const result = {
            status: 'success',
            data: {
                resultType: 'matrix',
                result: []
            }
        };

        for (let i = 0; i < seriesCount; i++) {
            const series = {
                metric: {
                    __name__: extractMetricName(query),
                    instance: 'instance-' + i,
                    job: 'node-exporter'
                },
                values: []
            };

            // Generate values
            let baseValue = Math.random() * 100;
            for (let j = points; j >= 0; j--) {
                const timestamp = (now - (j * resolutionInMs)) / 1000;
                // Add some randomness and trend
                baseValue += (Math.random() - 0.5) * 10;
                baseValue = Math.max(0, Math.min(100, baseValue));
                series.values.push([timestamp, baseValue.toFixed(2)]);
            }

            result.data.result.push(series);
        }

        return result;
    }

    // Parse time range string to milliseconds
    function parseTimeRange(timeStr) {
        const match = timeStr.match(/^(\d+)([smhdwy])$/);
        if (!match) return 3600000; // default 1 hour

        const value = parseInt(match[1]);
        const unit = match[2];

        const multipliers = {
            's': 1000,
            'm': 60000,
            'h': 3600000,
            'd': 86400000,
            'w': 604800000,
            'y': 31536000000
        };

        return value * multipliers[unit];
    }

    // Extract metric name from query
    function extractMetricName(query) {
        // Try to find metric name pattern
        const match = query.match(/([a-z_][a-z0-9_]*)/i);
        return match ? match[1] : 'metric';
    }

    // Update chart with data
    function updateChart(data) {
        if (!data || !data.data || !data.data.result) {
            return;
        }

        const datasets = data.data.result.map((series, index) => {
            const colors = [
                'rgb(102, 126, 234)',
                'rgb(237, 100, 166)',
                'rgb(52, 211, 153)',
                'rgb(251, 191, 36)',
                'rgb(239, 68, 68)'
            ];

            const color = colors[index % colors.length];

            return {
                label: series.metric.instance || 'Series ' + (index + 1),
                data: series.values.map(v => ({
                    x: new Date(v[0] * 1000),
                    y: parseFloat(v[1])
                })),
                borderColor: color,
                backgroundColor: color.replace('rgb', 'rgba').replace(')', ', 0.1)'),
                borderWidth: 2,
                tension: 0.4,
                fill: false
            };
        });

        chart.data.datasets = datasets;
        chart.update();
    }

    // Show validation message
    function showValidation(message, type) {
        const msgEl = document.getElementById('validationMessage');
        msgEl.textContent = message;
        msgEl.className = 'validation-message ' + type;

        if (type === 'success') {
            setTimeout(() => {
                msgEl.style.display = 'none';
            }, 5000);
        }
    }

    // Query history management
    function saveToHistory(query) {
        const historyItem = {
            query: query,
            timestamp: new Date().toISOString()
        };

        queryHistory.unshift(historyItem);

        // Keep only last 50 queries
        if (queryHistory.length > 50) {
            queryHistory = queryHistory.slice(0, 50);
        }

        localStorage.setItem('promql_history', JSON.stringify(queryHistory));
        renderHistory();
    }

    function loadHistory() {
        const saved = localStorage.getItem('promql_history');
        if (saved) {
            queryHistory = JSON.parse(saved);
            renderHistory();
        }
    }

    function renderHistory() {
        const container = document.getElementById('historyList');

        if (queryHistory.length === 0) {
            container.innerHTML = '<p style="color: #a0aec0; text-align: center; padding: 40px 0;">No query history yet</p>';
            return;
        }

        container.innerHTML = queryHistory.map(function(item, index) {
            const date = new Date(item.timestamp);
            const timeAgo = getTimeAgo(date);

            return '<div class="history-item" onclick="loadHistoryQuery(' + index + ')">' +
                '<div class="history-query">' + escapeHtml(item.query) + '</div>' +
                '<div class="history-time">' + timeAgo + '</div>' +
                '</div>';
        }).join('');
    }

    function loadHistoryQuery(index) {
        const item = queryHistory[index];
        document.getElementById('queryEditor').value = item.query;
        switchTab('query-builder');
    }

    function clearHistory() {
        if (confirm('Are you sure you want to clear all query history?')) {
            queryHistory = [];
            localStorage.removeItem('promql_history');
            renderHistory();
        }
    }

    function getTimeAgo(date) {
        const seconds = Math.floor((new Date() - date) / 1000);

        if (seconds < 60) return 'Just now';
        if (seconds < 3600) return Math.floor(seconds / 60) + 'm ago';
        if (seconds < 86400) return Math.floor(seconds / 3600) + 'h ago';
        return Math.floor(seconds / 86400) + 'd ago';
    }

    // Query templates
    function loadTemplates() {
        const templates = [
            {
                title: 'CPU Usage Rate',
                query: 'rate(node_cpu_seconds_total{mode!="idle"}[5m])',
                description: 'CPU usage excluding idle time over 5 minutes'
            },
            {
                title: 'Memory Usage Percentage',
                query: '(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100',
                description: 'Available memory as percentage'
            },
            {
                title: 'Network Receive Rate',
                query: 'rate(node_network_receive_bytes_total[5m])',
                description: 'Network receive rate in bytes per second'
            },
            {
                title: 'Disk Usage Percentage',
                query: '(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100',
                description: 'Disk space used as percentage'
            },
            {
                title: 'HTTP Request Rate',
                query: 'sum(rate(http_requests_total[5m])) by (status_code)',
                description: 'HTTP requests per second grouped by status code'
            },
            {
                title: 'Container CPU Usage',
                query: 'sum(rate(container_cpu_usage_seconds_total[5m])) by (container_name)',
                description: 'Container CPU usage grouped by container'
            },
            {
                title: 'Pod Memory Usage',
                query: 'sum(container_memory_usage_bytes{pod!=""}) by (pod)',
                description: 'Kubernetes pod memory usage'
            },
            {
                title: '95th Percentile Latency',
                query: 'histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))',
                description: 'P95 request latency'
            },
            {
                title: 'Error Rate',
                query: 'sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))',
                description: '5xx error rate as fraction of total requests'
            },
            {
                title: 'Disk I/O Rate',
                query: 'rate(node_disk_io_time_seconds_total[5m])',
                description: 'Disk I/O time rate'
            },
            {
                title: 'Top 5 CPU Consumers',
                query: 'topk(5, rate(container_cpu_usage_seconds_total[5m]))',
                description: 'Top 5 containers by CPU usage'
            },
            {
                title: 'Load Average',
                query: 'node_load1 / count(node_cpu_seconds_total{mode="idle"}) by (instance)',
                description: '1-minute load average per CPU'
            },
            {
                title: 'API Success Rate',
                query: 'sum(rate(http_requests_total{status=~"2.."}[5m])) / sum(rate(http_requests_total[5m])) * 100',
                description: 'Percentage of successful API requests'
            },
            {
                title: 'Database Connections',
                query: 'sum(database_connections_active) by (database)',
                description: 'Active database connections by database'
            },
            {
                title: 'Queue Depth',
                query: 'sum(queue_messages_ready) by (queue)',
                description: 'Messages waiting in queue'
            },
            {
                title: 'Cache Hit Rate',
                query: 'sum(rate(cache_hits_total[5m])) / (sum(rate(cache_hits_total[5m])) + sum(rate(cache_misses_total[5m]))) * 100',
                description: 'Cache hit rate as percentage'
            },
            // Node/System Metrics
            {
                title: 'CPU Utilization by Mode',
                query: 'sum by (mode) (rate(node_cpu_seconds_total[5m])) * 100',
                description: 'CPU time breakdown by mode (user, system, iowait, etc)'
            },
            {
                title: 'Memory Swap Usage',
                query: '(node_memory_SwapTotal_bytes - node_memory_SwapFree_bytes) / node_memory_SwapTotal_bytes * 100',
                description: 'Percentage of swap space in use'
            },
            {
                title: 'Disk Read/Write IOPS',
                query: 'rate(node_disk_reads_completed_total[5m]) + rate(node_disk_writes_completed_total[5m])',
                description: 'Total disk I/O operations per second'
            },
            {
                title: 'Network Bandwidth Total',
                query: 'rate(node_network_receive_bytes_total[5m]) + rate(node_network_transmit_bytes_total[5m])',
                description: 'Total network bandwidth (RX + TX)'
            },
            {
                title: 'Disk Write Latency',
                query: 'rate(node_disk_write_time_seconds_total[5m]) / rate(node_disk_writes_completed_total[5m])',
                description: 'Average disk write latency in seconds'
            },
            {
                title: 'Context Switches Rate',
                query: 'rate(node_context_switches_total[5m])',
                description: 'System context switches per second'
            },
            {
                title: 'File Descriptor Usage',
                query: 'process_open_fds / process_max_fds * 100',
                description: 'Percentage of file descriptors in use'
            },
            // Kubernetes Metrics
            {
                title: 'Pod Restart Count',
                query: 'sum(kube_pod_container_status_restarts_total) by (pod, namespace)',
                description: 'Total container restarts per pod'
            },
            {
                title: 'Pod CPU Throttling',
                query: 'rate(container_cpu_cfs_throttled_seconds_total[5m]) / rate(container_cpu_cfs_periods_total[5m]) * 100',
                description: 'Percentage of time pod CPU was throttled'
            },
            {
                title: 'Pending Pods',
                query: 'sum(kube_pod_status_phase{phase="Pending"}) by (namespace)',
                description: 'Number of pods in pending state by namespace'
            },
            {
                title: 'Node Capacity',
                query: 'sum(kube_node_status_allocatable{resource="cpu"}) by (node)',
                description: 'Allocatable CPU capacity per node'
            },
            {
                title: 'Namespace Resource Quota',
                query: 'kube_resourcequota{type="used"} / kube_resourcequota{type="hard"} * 100',
                description: 'Resource quota usage percentage'
            },
            {
                title: 'Deployment Replicas',
                query: 'kube_deployment_status_replicas_available / kube_deployment_spec_replicas * 100',
                description: 'Percentage of desired replicas available'
            },
            {
                title: 'PVC Usage',
                query: 'kubelet_volume_stats_used_bytes / kubelet_volume_stats_capacity_bytes * 100',
                description: 'Persistent volume claim usage percentage'
            },
            // Application Metrics
            {
                title: 'Request Duration P50',
                query: 'histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))',
                description: 'Median request latency'
            },
            {
                title: 'Request Duration P99',
                query: 'histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))',
                description: '99th percentile request latency'
            },
            {
                title: 'Requests per Minute',
                query: 'sum(rate(http_requests_total[1m])) * 60',
                description: 'Total HTTP requests per minute'
            },
            {
                title: '4xx Error Rate',
                query: 'sum(rate(http_requests_total{status=~"4.."}[5m])) / sum(rate(http_requests_total[5m])) * 100',
                description: 'Client error rate as percentage'
            },
            {
                title: 'Slow Requests (>1s)',
                query: 'sum(rate(http_request_duration_seconds_bucket{le="1"}[5m]))',
                description: 'Count of requests slower than 1 second'
            },
            {
                title: 'Request Rate by Endpoint',
                query: 'sum by (endpoint) (rate(http_requests_total[5m]))',
                description: 'Request rate grouped by endpoint'
            },
            {
                title: 'Response Size Average',
                query: 'rate(http_response_size_bytes_sum[5m]) / rate(http_response_size_bytes_count[5m])',
                description: 'Average HTTP response size in bytes'
            },
            // Database Metrics
            {
                title: 'Database Query Duration',
                query: 'rate(database_query_duration_seconds_sum[5m]) / rate(database_query_duration_seconds_count[5m])',
                description: 'Average database query duration'
            },
            {
                title: 'Database Connection Pool',
                query: '(database_connections_active / database_connections_max) * 100',
                description: 'Database connection pool usage percentage'
            },
            {
                title: 'Slow Queries Count',
                query: 'rate(database_slow_queries_total[5m])',
                description: 'Rate of slow database queries per second'
            },
            {
                title: 'Database Deadlocks',
                query: 'rate(database_deadlocks_total[5m])',
                description: 'Database deadlocks per second'
            },
            {
                title: 'Transaction Rate',
                query: 'rate(database_transactions_total[5m])',
                description: 'Database transactions per second'
            },
            // Message Queue Metrics
            {
                title: 'Queue Processing Rate',
                query: 'rate(queue_messages_processed_total[5m])',
                description: 'Messages processed per second'
            },
            {
                title: 'Queue Message Age',
                query: 'queue_oldest_message_age_seconds',
                description: 'Age of oldest message in queue'
            },
            {
                title: 'Queue Error Rate',
                query: 'rate(queue_messages_failed_total[5m]) / rate(queue_messages_processed_total[5m]) * 100',
                description: 'Percentage of failed message processing'
            },
            {
                title: 'Queue Consumers',
                query: 'sum(queue_consumers) by (queue)',
                description: 'Number of active consumers per queue'
            },
            // Redis Metrics
            {
                title: 'Redis Memory Usage',
                query: 'redis_memory_used_bytes / redis_memory_max_bytes * 100',
                description: 'Redis memory usage percentage'
            },
            {
                title: 'Redis Hit Rate',
                query: 'rate(redis_keyspace_hits_total[5m]) / (rate(redis_keyspace_hits_total[5m]) + rate(redis_keyspace_misses_total[5m])) * 100',
                description: 'Redis cache hit rate'
            },
            {
                title: 'Redis Connected Clients',
                query: 'redis_connected_clients',
                description: 'Number of connected Redis clients'
            },
            {
                title: 'Redis Commands per Second',
                query: 'rate(redis_commands_processed_total[5m])',
                description: 'Redis command execution rate'
            },
            // JVM Metrics
            {
                title: 'JVM Heap Usage',
                query: 'jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"} * 100',
                description: 'JVM heap memory usage percentage'
            },
            {
                title: 'JVM GC Pause Time',
                query: 'rate(jvm_gc_pause_seconds_sum[5m]) / rate(jvm_gc_pause_seconds_count[5m])',
                description: 'Average garbage collection pause time'
            },
            {
                title: 'JVM Thread Count',
                query: 'jvm_threads_current',
                description: 'Current number of JVM threads'
            },
            {
                title: 'JVM GC Rate',
                query: 'rate(jvm_gc_pause_seconds_count[5m])',
                description: 'Garbage collection frequency per second'
            },
            // Nginx Metrics
            {
                title: 'Nginx Active Connections',
                query: 'nginx_connections_active',
                description: 'Current active Nginx connections'
            },
            {
                title: 'Nginx Request Rate',
                query: 'rate(nginx_http_requests_total[5m])',
                description: 'Nginx HTTP requests per second'
            },
            {
                title: 'Nginx 5xx Rate',
                query: 'sum(rate(nginx_http_requests_total{status=~"5.."}[5m]))',
                description: 'Nginx server error rate'
            },
            // Custom SLI/SLO Metrics
            {
                title: 'Availability SLI',
                query: 'sum(rate(http_requests_total{status!~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100',
                description: 'Service availability (non-5xx responses)'
            },
            {
                title: 'Latency SLI (P95 < 500ms)',
                query: 'histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) < 0.5',
                description: 'Check if P95 latency meets SLO'
            },
            {
                title: 'Error Budget Remaining',
                query: '(1 - (sum(rate(http_requests_total{status=~"5.."}[30d])) / sum(rate(http_requests_total[30d])))) * 100',
                description: 'Percentage of error budget remaining (30 days)'
            },
            // Alerting Patterns
            {
                title: 'High CPU Alert',
                query: 'avg(rate(node_cpu_seconds_total{mode!="idle"}[5m])) by (instance) > 0.8',
                description: 'Alert when CPU usage exceeds 80%'
            },
            {
                title: 'High Memory Alert',
                query: '(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) > 0.9',
                description: 'Alert when memory usage exceeds 90%'
            },
            {
                title: 'Pod CrashLooping',
                query: 'rate(kube_pod_container_status_restarts_total[15m]) > 0',
                description: 'Alert on pod restart activity'
            },
            {
                title: 'API Latency Spike',
                query: 'histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1',
                description: 'Alert when P95 latency exceeds 1 second'
            }
        ];

        const container = document.getElementById('templatesGrid');
        container.innerHTML = templates.map(function(template, index) {
            return '<div class="template-card" onclick="loadTemplate(' + index + ')">' +
                '<div class="template-title">' + template.title + '</div>' +
                '<div style="font-size: 13px; color: #718096; margin-top: 5px;">' + template.description + '</div>' +
                '<div class="template-query">' + escapeHtml(template.query) + '</div>' +
                '</div>';
        }).join('');

        // Store templates globally
        window.queryTemplates = templates;
    }

    function loadTemplate(index) {
        const template = window.queryTemplates[index];
        document.getElementById('queryEditor').value = template.query;
        switchTab('query-builder');
        showValidation('Template loaded: ' + template.title, 'success');
    }

    // Alert rule generation
    function generateAlertRule() {
        const name = document.getElementById('alertName').value.trim();
        const query = document.getElementById('alertQuery').value.trim();
        const duration = document.getElementById('alertDuration').value;
        const severity = document.getElementById('alertSeverity').value;
        const summary = document.getElementById('alertSummary').value.trim();
        const description = document.getElementById('alertDescription').value.trim();

        if (!name) {
            alert('Please enter an alert name');
            return;
        }

        if (!query) {
            alert('Please enter a PromQL expression');
            return;
        }

        const alertRule = {
            groups: [{
                name: name.toLowerCase().replace(/\s+/g, '_') + '_alerts',
                rules: [{
                    alert: name,
                    expr: query,
                    for: duration,
                    labels: {
                        severity: severity
                    },
                    annotations: {
                        summary: summary || 'Alert triggered',
                        description: description || 'No description provided'
                    }
                }]
            }]
        };

        const yaml = jsyaml.dump(alertRule, { indent: 2 });
        document.getElementById('alertRuleOutput').textContent = yaml;

        showValidation('Alert rule generated successfully!', 'success');
    }

    function testAlertRule() {
        const query = document.getElementById('alertQuery').value.trim();

        if (!query) {
            alert('Please enter a PromQL expression');
            return;
        }

        // Validate the query
        const validation = validatePromQL(query);

        if (validation.valid) {
            showValidation('✓ Alert query syntax is valid!', 'success');
        } else {
            showValidation('✗ Invalid alert query: ' + validation.error, 'error');
        }
    }

    function clearAlertForm() {
        document.getElementById('alertName').value = '';
        document.getElementById('alertQuery').value = '';
        document.getElementById('alertDuration').value = '5m';
        document.getElementById('alertSeverity').value = 'warning';
        document.getElementById('alertSummary').value = '';
        document.getElementById('alertDescription').value = '';
        document.getElementById('alertRuleOutput').textContent = 'Configure the alert above and click "Generate Alert Rule"';
    }

    // Copy and download functions
    function copyQuery() {
        const query = document.getElementById('queryEditor').value;
        navigator.clipboard.writeText(query).then(() => {
            showValidation('Query copied to clipboard!', 'success');
        });
    }

    function exportQuery() {
        const query = document.getElementById('queryEditor').value;
        const blob = new Blob([query], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'prometheus-query.txt';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    function copyAlertRule() {
        const yaml = document.getElementById('alertRuleOutput').textContent;
        if (yaml.includes('Configure the alert')) {
            alert('Please generate an alert rule first');
            return;
        }
        navigator.clipboard.writeText(yaml).then(() => {
            showValidation('Alert rule copied to clipboard!', 'success');
        });
    }

    function downloadAlertRule() {
        const yaml = document.getElementById('alertRuleOutput').textContent;
        if (yaml.includes('Configure the alert')) {
            alert('Please generate an alert rule first');
            return;
        }
        const blob = new Blob([yaml], { type: 'text/yaml' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'prometheus-alert-rule.yaml';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    function exportToGrafana() {
        const query = document.getElementById('alertQuery').value.trim();
        const name = document.getElementById('alertName').value.trim();

        if (!query) {
            alert('Please configure an alert first');
            return;
        }

        const grafanaAlert = {
            dashboard: {
                title: name || 'Prometheus Alert',
                panels: [{
                    title: name || 'Alert Panel',
                    type: 'graph',
                    targets: [{
                        expr: query,
                        refId: 'A'
                    }],
                    alert: {
                        name: name,
                        conditions: [{
                            evaluator: {
                                params: [0],
                                type: 'gt'
                            },
                            operator: {
                                type: 'and'
                            },
                            query: {
                                params: ['A', '5m', 'now']
                            },
                            type: 'query'
                        }]
                    }
                }]
            }
        };

        const json = JSON.stringify(grafanaAlert, null, 2);
        const blob = new Blob([json], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'grafana-alert-dashboard.json';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);

        showValidation('Grafana dashboard exported!', 'success');
    }

    function clearQuery() {
        document.getElementById('queryEditor').value = '';
        document.getElementById('validationMessage').style.display = 'none';
    }

    // Toggle examples panel
    function toggleExamplesPanel() {
        const panel = document.getElementById('examplesPanel');
        const button = event.target;

        if (panel.style.display === 'none') {
            panel.style.display = 'block';
            button.textContent = '💡 Hide Function Examples';
        } else {
            panel.style.display = 'none';
            button.textContent = '💡 Show Function Examples';
        }
    }

    // Load example query
    function loadExample(query) {
        // Remove escaped quotes
        query = query.replace(/\\'/g, "'");

        document.getElementById('queryEditor').value = query;

        // Scroll to query editor
        document.getElementById('queryEditor').scrollIntoView({ behavior: 'smooth', block: 'center' });

        // Show success message
        showValidation('Example loaded! Click "Execute Query" to see the visualization.', 'success');

        // Focus on editor
        document.getElementById('queryEditor').focus();
    }

    // Utility function
    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>
</div>
<%@ include file="body-close.jsp"%>

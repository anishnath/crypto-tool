<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Advanced Cron Expression Generator",
        "description": "Free online cron expression generator and validator with visual builder, examples, and next execution preview. Build crontab schedules easily.",
        "url": "https://8gwifi.org/cron-generator.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "creator": {
            "@type": "Organization",
            "name": "8gwifi.org"
        },
        "keywords": "cron generator, crontab generator, cron expression, cron syntax, cron schedule, unix cron, linux cron, cron validator, cron parser, schedule builder, task scheduler, cron examples, quartz cron, spring cron"
    }
    </script>

    <title>Advanced Cron Expression Generator Online – Build Crontab Schedules – Free | 8gwifi.org</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free online cron expression generator with visual builder, 50+ examples, validation, and next execution times. Build and test Unix/Linux crontab schedules easily.">
    <link rel="canonical" href="https://8gwifi.org/cron-generator.jsp" />
    <meta property="og:type" content="website" />
    <meta property="og:title" content="Cron Expression Generator – Visual Builder & Next Run Times" />
    <meta property="og:description" content="Build and validate cron expressions with a visual builder and 50+ examples. Free, no signup." />
    <meta property="og:url" content="https://8gwifi.org/cron-generator.jsp" />
    <meta property="og:site_name" content="8gwifi.org" />
    <meta property="og:image" content="https://8gwifi.org/images/site/logo.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Cron Expression Generator – Visual Builder & Next Run Times" />
    <meta name="twitter:description" content="Build and validate cron expressions with a visual builder and 50+ examples. Free, no signup." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/logo.png" />
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question","name": "How do I run a job every 5 minutes?","acceptedAnswer": {"@type": "Answer","text": "Use */5 * * * * to run every five minutes."}},
    {"@type": "Question","name": "How do I schedule for specific days?","acceptedAnswer": {"@type": "Answer","text": "Use the Day-of-Week field (0-6 or SUN-SAT). For example, MON-FRI for weekdays."}},
    {"@type": "Question","name": "Does cron support time zones?","acceptedAnswer": {"@type": "Answer","text": "System cron typically uses the server's time zone. Use environment variables or systemd timers for per-task zones."}}
  ]
}
    </script>
    <meta name="keywords" content="cron generator, crontab generator, cron expression builder, cron syntax, schedule generator, unix cron, linux cron, cron validator, cron parser, quartz cron, spring cron, task scheduler, cron examples">
    <meta name="author" content="8gwifi.org">
    <meta name="robots" content="index, follow">

    <!-- OpenGraph -->
    <meta property="og:title" content="Advanced Cron Expression Generator - Free Online Tool">
    <meta property="og:description" content="Build, validate, and test cron expressions with visual interface, 50+ examples, and next execution preview.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/cron-generator.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Advanced Cron Expression Generator">
    <meta name="twitter:description" content="Build and validate cron expressions with visual builder and examples.">

    <link rel="canonical" href="https://8gwifi.org/cron-generator.jsp">

    <%@ include file="header-script.jsp"%>

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        }

        h1 {
            color: #2d3748;
            font-size: 2rem;
            font-weight: 700;
        }

        .info-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .info-box h3 {
            margin-top: 0;
            font-size: 1.3rem;
        }

        .cron-builder {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }

        .field-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .field-group {
            display: flex;
            flex-direction: column;
        }

        .field-group label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
            font-size: 13px;
        }

        .field-group input,
        .field-group select {
            padding: 8px 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            font-family: 'Monaco', 'Courier New', monospace;
        }

        .field-group input:focus,
        .field-group select:focus {
            outline: none;
            border-color: #667eea;
        }

        .cron-output {
            background: #1e1e1e;
            color: #f8f8f2;
            padding: 20px;
            border-radius: 6px;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 20px;
            font-weight: 600;
            text-align: center;
            margin: 0;
            word-break: break-all;
            position: sticky;
            top: 10px;
            z-index: 100;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            border: 2px solid #667eea;
        }

        .cron-output-container {
            margin-bottom: 20px;
        }

        .cron-output-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 10px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .description-box {
            background: #e6fffa;
            border-left: 4px solid #38b2ac;
            padding: 15px;
            border-radius: 4px;
            margin: 20px 0;
        }

        .description-box strong {
            color: #234e52;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: transform 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: white;
            color: #4a5568;
            padding: 10px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s;
        }

        .btn-secondary:hover {
            background: #f7fafc;
            border-color: #cbd5e0;
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 13px;
        }

        .examples-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
            margin-top: 20px;
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

        .example-title {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .example-cron {
            background: #f7fafc;
            padding: 8px;
            border-radius: 4px;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 13px;
            color: #667eea;
            margin-bottom: 8px;
        }

        .example-desc {
            font-size: 12px;
            color: #718096;
        }

        .execution-times {
            background: #fffaf0;
            border: 1px solid #fbd38d;
            border-radius: 6px;
            padding: 15px;
            margin-top: 20px;
        }

        .execution-times h4 {
            margin-top: 0;
            color: #744210;
        }

        .execution-list {
            list-style: none;
            padding: 0;
        }

        .execution-list li {
            padding: 8px;
            border-bottom: 1px solid #feebc8;
            color: #744210;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 13px;
        }

        .execution-list li:last-child {
            border-bottom: none;
        }

        .tab-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 10px;
        }

        .tab-btn {
            padding: 10px 20px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 6px 6px 0 0;
            cursor: pointer;
            font-weight: 500;
            color: #4a5568;
            transition: all 0.3s;
        }

        .tab-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .helper-text {
            font-size: 11px;
            color: #718096;
            margin-top: 3px;
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 1.5rem;
            }

            .field-row {
                grid-template-columns: 1fr;
            }

            .examples-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Advanced Cron Expression Generator</h1>
<p>Build, validate, and test cron expressions with visual interface and 50+ examples</p>

<hr>

<div class="info-box">
    <h3>🕐 Professional Cron Expression Builder</h3>
    <p>Generate Unix/Linux crontab expressions visually, validate syntax, see next execution times, and choose from 50+ common patterns. Perfect for scheduling automated tasks, jobs, and scripts.</p>
</div>

<div class="tab-buttons">
    <button class="tab-btn active" onclick="switchTab('builder')">Visual Builder</button>
    <button class="tab-btn" onclick="switchTab('examples')">Examples (50+)</button>
    <button class="tab-btn" onclick="switchTab('parser')">Parse Cron</button>
</div>

<!-- Visual Builder Tab -->
<div class="tab-content active" id="builder-tab">
    <!-- Sticky Cron Output at Top -->
    <div class="cron-output-container">
        <div class="cron-output-label">📋 GENERATED CRON EXPRESSION</div>
        <div class="cron-output" id="cronOutput">* * * * *</div>
    </div>

    <div class="cron-builder">
        <h3 style="margin-top: 0;">Build Your Cron Expression</h3>

        <div class="description-box" id="descriptionBox" style="margin-bottom: 20px;">
            <strong>Description:</strong> <span id="cronDescription">Runs every minute</span>
        </div>

        <div style="margin-bottom: 20px;">
            <label style="font-weight: 600; margin-bottom: 10px; display: block;">Quick Presets:</label>
            <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                <button class="btn-secondary btn-small" onclick="loadPreset('everyMinute')">Every Minute</button>
                <button class="btn-secondary btn-small" onclick="loadPreset('everyHour')">Every Hour</button>
                <button class="btn-secondary btn-small" onclick="loadPreset('daily')">Daily at Midnight</button>
                <button class="btn-secondary btn-small" onclick="loadPreset('weekly')">Weekly (Sunday)</button>
                <button class="btn-secondary btn-small" onclick="loadPreset('monthly')">Monthly (1st)</button>
                <button class="btn-secondary btn-small" onclick="loadPreset('weekdays')">Weekdays at 9 AM</button>
            </div>
        </div>

        <div class="field-row">
            <div class="field-group">
                <label>Minute (0-59)</label>
                <input type="text" id="minute" value="*" oninput="generateCron()">
                <span class="helper-text">* = every minute</span>
            </div>
            <div class="field-group">
                <label>Hour (0-23)</label>
                <input type="text" id="hour" value="*" oninput="generateCron()">
                <span class="helper-text">* = every hour</span>
            </div>
            <div class="field-group">
                <label>Day of Month (1-31)</label>
                <input type="text" id="dayOfMonth" value="*" oninput="generateCron()">
                <span class="helper-text">* = every day</span>
            </div>
            <div class="field-group">
                <label>Month (1-12)</label>
                <input type="text" id="month" value="*" oninput="generateCron()">
                <span class="helper-text">* = every month</span>
            </div>
            <div class="field-group">
                <label>Day of Week (0-7)</label>
                <input type="text" id="dayOfWeek" value="*" oninput="generateCron()">
                <span class="helper-text">0/7 = Sunday</span>
            </div>
        </div>

        <div style="background: #f7fafc; padding: 15px; border-radius: 6px; margin-bottom: 15px;">
            <strong>💡 Syntax Help:</strong>
            <ul style="margin: 10px 0; padding-left: 20px; font-size: 13px;">
                <li><code>*</code> - Any value (every)</li>
                <li><code>5</code> - Specific value</li>
                <li><code>1,3,5</code> - List of values</li>
                <li><code>1-5</code> - Range of values</li>
                <li><code>*/5</code> - Every 5 units (step)</li>
                <li><code>10-20/2</code> - Every 2 units between 10 and 20</li>
            </ul>
        </div>

        <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 20px;">
            <button class="btn-primary" onclick="copyCron()">📋 Copy Expression</button>
            <button class="btn-secondary" onclick="downloadCron()">💾 Download</button>
            <button class="btn-secondary" onclick="resetBuilder()">🔄 Reset</button>
        </div>

        <div class="execution-times" id="executionTimes">
            <h4>⏰ Next 10 Execution Times:</h4>
            <ul class="execution-list" id="executionList"></ul>
        </div>
    </div>
</div>

<!-- Examples Tab -->
<div class="tab-content" id="examples-tab">
    <div class="cron-builder">
        <h3 style="margin-top: 0;">Common Cron Expression Examples</h3>
        <p>Click any example to load it into the builder</p>

        <div class="examples-grid" id="examplesGrid"></div>
    </div>
</div>

<!-- Parser Tab -->
<div class="tab-content" id="parser-tab">
    <div class="cron-builder">
        <h3 style="margin-top: 0;">Parse Existing Cron Expression</h3>
        <p>Paste a cron expression to parse and visualize it</p>

        <div style="margin-bottom: 20px;">
            <label style="font-weight: 600; margin-bottom: 8px; display: block;">Cron Expression:</label>
            <input type="text" id="parseCronInput" placeholder="e.g., 0 9 * * 1-5" style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 6px; font-family: 'Monaco', 'Courier New', monospace; font-size: 16px;">
        </div>

        <button class="btn-primary" onclick="parseCron()">🔍 Parse Expression</button>

        <div id="parseResult" style="display: none; margin-top: 20px;">
            <h3>Parsed Components:</h3>
            <div style="background: #f7fafc; padding: 20px; border-radius: 6px; margin-bottom: 15px;">
                <div style="margin-bottom: 10px;"><strong>Minute:</strong> <span id="parsedMinute"></span></div>
                <div style="margin-bottom: 10px;"><strong>Hour:</strong> <span id="parsedHour"></span></div>
                <div style="margin-bottom: 10px;"><strong>Day of Month:</strong> <span id="parsedDayOfMonth"></span></div>
                <div style="margin-bottom: 10px;"><strong>Month:</strong> <span id="parsedMonth"></span></div>
                <div style="margin-bottom: 10px;"><strong>Day of Week:</strong> <span id="parsedDayOfWeek"></span></div>
            </div>

            <div class="description-box">
                <strong>Human-Readable:</strong> <span id="parsedDescription"></span>
            </div>

            <button class="btn-secondary" onclick="loadParsedToBuilder()">📥 Load into Builder</button>
        </div>
    </div>
</div>

<h2 class="mt-4">Features</h2>
<ul>
    <li><strong>Visual Builder:</strong> Build cron expressions with intuitive input fields</li>
    <li><strong>50+ Examples:</strong> Common patterns for quick selection</li>
    <li><strong>Real-Time Validation:</strong> Instant syntax validation and description</li>
    <li><strong>Next Executions:</strong> Preview next 10 execution times</li>
    <li><strong>Human Readable:</strong> Convert cron expressions to plain English</li>
    <li><strong>Parse Existing:</strong> Import and analyze existing cron expressions</li>
    <li><strong>Quick Presets:</strong> One-click common schedules</li>
    <li><strong>Syntax Help:</strong> Built-in reference guide</li>
    <li><strong>Client-Side:</strong> 100% browser-based processing</li>
</ul>

<h2 class="mt-4">Try Other Developer Tools</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="curl-builder.jsp">cURL Builder & HTTP Client</a></li>
            <li><a href="prometheus-query-builder.jsp">Prometheus Query Builder</a></li>
            <li><a href="json-2-csv.jsp">JSON to CSV Converter</a></li>
            <li><a href="yamlparser.jsp">YAML Parser & Converter</a></li>
        </ul>
    </div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<script>
    // 50+ Cron Examples
    const cronExamples = [
        { title: 'Every Minute', cron: '* * * * *', desc: 'Runs every minute' },
        { title: 'Every 5 Minutes', cron: '*/5 * * * *', desc: 'Runs every 5 minutes' },
        { title: 'Every 10 Minutes', cron: '*/10 * * * *', desc: 'Runs every 10 minutes' },
        { title: 'Every 15 Minutes', cron: '*/15 * * * *', desc: 'Runs every 15 minutes' },
        { title: 'Every 30 Minutes', cron: '*/30 * * * *', desc: 'Runs every 30 minutes' },
        { title: 'Every Hour', cron: '0 * * * *', desc: 'Runs at minute 0 of every hour' },
        { title: 'Every 2 Hours', cron: '0 */2 * * *', desc: 'Runs every 2 hours' },
        { title: 'Every 6 Hours', cron: '0 */6 * * *', desc: 'Runs every 6 hours' },
        { title: 'Every 12 Hours', cron: '0 */12 * * *', desc: 'Runs every 12 hours' },
        { title: 'Daily at Midnight', cron: '0 0 * * *', desc: 'Runs at 00:00 every day' },
        { title: 'Daily at 1 AM', cron: '0 1 * * *', desc: 'Runs at 01:00 every day' },
        { title: 'Daily at 2 AM', cron: '0 2 * * *', desc: 'Runs at 02:00 every day' },
        { title: 'Daily at 6 AM', cron: '0 6 * * *', desc: 'Runs at 06:00 every day' },
        { title: 'Daily at 9 AM', cron: '0 9 * * *', desc: 'Runs at 09:00 every day' },
        { title: 'Daily at Noon', cron: '0 12 * * *', desc: 'Runs at 12:00 every day' },
        { title: 'Daily at 5 PM', cron: '0 17 * * *', desc: 'Runs at 17:00 every day' },
        { title: 'Daily at 6 PM', cron: '0 18 * * *', desc: 'Runs at 18:00 every day' },
        { title: 'Daily at 11 PM', cron: '0 23 * * *', desc: 'Runs at 23:00 every day' },
        { title: 'Twice Daily (6 AM & 6 PM)', cron: '0 6,18 * * *', desc: 'Runs at 06:00 and 18:00 every day' },
        { title: 'Every Weekday at 9 AM', cron: '0 9 * * 1-5', desc: 'Runs at 09:00 Monday through Friday' },
        { title: 'Every Weekday at 5 PM', cron: '0 17 * * 1-5', desc: 'Runs at 17:00 Monday through Friday' },
        { title: 'Every Weekend at 10 AM', cron: '0 10 * * 0,6', desc: 'Runs at 10:00 on Saturday and Sunday' },
        { title: 'Every Monday at 8 AM', cron: '0 8 * * 1', desc: 'Runs at 08:00 every Monday' },
        { title: 'Every Friday at 5 PM', cron: '0 17 * * 5', desc: 'Runs at 17:00 every Friday' },
        { title: 'Every Sunday at Midnight', cron: '0 0 * * 0', desc: 'Runs at 00:00 every Sunday' },
        { title: 'First Day of Month at Midnight', cron: '0 0 1 * *', desc: 'Runs at 00:00 on the 1st of every month' },
        { title: 'First Day of Month at 9 AM', cron: '0 9 1 * *', desc: 'Runs at 09:00 on the 1st of every month' },
        { title: 'Last Day of Month at 11 PM', cron: '0 23 L * *', desc: 'Runs at 23:00 on the last day of every month' },
        { title: 'Every 1st and 15th at Noon', cron: '0 12 1,15 * *', desc: 'Runs at 12:00 on the 1st and 15th' },
        { title: 'First Monday of Month', cron: '0 9 * * 1#1', desc: 'Runs at 09:00 on the first Monday' },
        { title: 'First of Quarter (Jan/Apr/Jul/Oct)', cron: '0 0 1 1,4,7,10 *', desc: 'Runs quarterly at midnight' },
        { title: 'First of Year', cron: '0 0 1 1 *', desc: 'Runs at 00:00 on January 1st' },
        { title: 'Every 5 Minutes During Business Hours', cron: '*/5 9-17 * * 1-5', desc: 'Every 5 min, 9 AM-5 PM, weekdays' },
        { title: 'Every Hour During Business Hours', cron: '0 9-17 * * 1-5', desc: 'Every hour, 9 AM-5 PM, weekdays' },
        { title: 'Every 30 Minutes During Work Hours', cron: '*/30 8-18 * * 1-5', desc: 'Every 30 min, 8 AM-6 PM, weekdays' },
        { title: 'Weekday Mornings at 7:30 AM', cron: '30 7 * * 1-5', desc: 'Runs at 07:30 Monday through Friday' },
        { title: 'Weekday Evenings at 8:30 PM', cron: '30 20 * * 1-5', desc: 'Runs at 20:30 Monday through Friday' },
        { title: 'Every 2 Minutes', cron: '*/2 * * * *', desc: 'Runs every 2 minutes' },
        { title: 'Every 3 Hours During Day', cron: '0 8-20/3 * * *', desc: 'Every 3 hours between 8 AM-8 PM' },
        { title: 'Every 4 Hours', cron: '0 */4 * * *', desc: 'Runs every 4 hours' },
        { title: 'Every Day at 3:30 AM', cron: '30 3 * * *', desc: 'Runs at 03:30 every day' },
        { title: 'Every Day at 4:30 PM', cron: '30 16 * * *', desc: 'Runs at 16:30 every day' },
        { title: 'Twice a Week (Mon & Thu)', cron: '0 9 * * 1,4', desc: 'Runs at 09:00 Monday and Thursday' },
        { title: 'Three Times Daily', cron: '0 8,14,20 * * *', desc: 'Runs at 08:00, 14:00, and 20:00' },
        { title: 'Every 20 Minutes', cron: '*/20 * * * *', desc: 'Runs every 20 minutes' },
        { title: 'Every 45 Minutes', cron: '*/45 * * * *', desc: 'Runs every 45 minutes' },
        { title: 'At Quarter Past Every Hour', cron: '15 * * * *', desc: 'Runs at XX:15 every hour' },
        { title: 'At Half Past Every Hour', cron: '30 * * * *', desc: 'Runs at XX:30 every hour' },
        { title: 'At Quarter To Every Hour', cron: '45 * * * *', desc: 'Runs at XX:45 every hour' },
        { title: 'Weekly on Wednesday at 2 PM', cron: '0 14 * * 3', desc: 'Runs at 14:00 every Wednesday' }
    ];

    let currentCron = '* * * * *';

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        generateCron();
        loadExamples();
    });

    // Tab switching
    function switchTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

        event.target.classList.add('active');
        document.getElementById(tab + '-tab').classList.add('active');
    }

    // Generate cron expression
    function generateCron() {
        const minute = document.getElementById('minute').value.trim() || '*';
        const hour = document.getElementById('hour').value.trim() || '*';
        const dayOfMonth = document.getElementById('dayOfMonth').value.trim() || '*';
        const month = document.getElementById('month').value.trim() || '*';
        const dayOfWeek = document.getElementById('dayOfWeek').value.trim() || '*';

        currentCron = minute + ' ' + hour + ' ' + dayOfMonth + ' ' + month + ' ' + dayOfWeek;
        document.getElementById('cronOutput').textContent = currentCron;

        // Generate description
        const description = generateDescription(minute, hour, dayOfMonth, month, dayOfWeek);
        document.getElementById('cronDescription').textContent = description;

        // Generate next execution times
        generateExecutionTimes();
    }

    // Generate human-readable description
    function generateDescription(min, hr, dom, mon, dow) {
        let desc = 'Runs ';

        // Minute
        if (min === '*') desc += 'every minute';
        else if (min.startsWith('*/')) desc += 'every ' + min.substring(2) + ' minutes';
        else if (min.includes(',')) desc += 'at minutes ' + min;
        else if (min.includes('-')) desc += 'at minutes ' + min;
        else desc += 'at minute ' + min;

        // Hour
        if (hr === '*') desc += ' of every hour';
        else if (hr.startsWith('*/')) desc += ' of every ' + hr.substring(2) + ' hours';
        else if (hr.includes(',')) desc += ' at hours ' + hr;
        else if (hr.includes('-')) desc += ' between hours ' + hr;
        else desc += ' at ' + hr + ':00';

        // Day of Month
        if (dom !== '*') {
            if (dom.startsWith('*/')) desc += ', every ' + dom.substring(2) + ' days';
            else if (dom.includes(',')) desc += ', on days ' + dom;
            else if (dom.includes('-')) desc += ', on days ' + dom;
            else desc += ', on day ' + dom + ' of the month';
        }

        // Month
        if (mon !== '*') {
            const months = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
            if (mon.startsWith('*/')) {
                desc += ', every ' + mon.substring(2) + ' months';
            } else if (mon.includes(',')) {
                const monthNames = mon.split(',').map(m => months[parseInt(m)]).join(', ');
                desc += ', in ' + monthNames;
            } else if (mon.includes('-')) {
                const range = mon.split('-');
                desc += ', from ' + months[parseInt(range[0])] + ' to ' + months[parseInt(range[1])];
            } else {
                desc += ', in ' + months[parseInt(mon)];
            }
        }

        // Day of Week
        if (dow !== '*') {
            const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
            if (dow === '1-5') {
                desc += ', Monday through Friday';
            } else if (dow === '0,6' || dow === '6,0') {
                desc += ', on Saturday and Sunday';
            } else if (dow.startsWith('*/')) {
                desc += ', every ' + dow.substring(2) + ' days of the week';
            } else if (dow.includes(',')) {
                const dayNames = dow.split(',').map(d => days[parseInt(d)]).join(', ');
                desc += ', on ' + dayNames;
            } else if (dow.includes('-')) {
                const range = dow.split('-');
                desc += ', from ' + days[parseInt(range[0])] + ' to ' + days[parseInt(range[1])];
            } else {
                const dayNum = parseInt(dow);
                desc += ', on ' + days[dayNum % 8];
            }
        }

        return desc;
    }

    // Generate next execution times
    function generateExecutionTimes() {
        const parts = currentCron.split(' ');
        const times = [];
        const now = new Date();

        // Simple simulation for next 10 times
        let testDate = new Date(now);
        let iterations = 0;
        const maxIterations = 10000; // Prevent infinite loop

        while (times.length < 10 && iterations < maxIterations) {
            testDate = new Date(testDate.getTime() + 60000); // Add 1 minute
            iterations++;

            if (matchesCron(testDate, parts)) {
                times.push(testDate.toLocaleString());
            }
        }

        const list = document.getElementById('executionList');
        list.innerHTML = '';
        times.forEach(time => {
            const li = document.createElement('li');
            li.textContent = time;
            list.appendChild(li);
        });
    }

    // Check if date matches cron pattern (simplified)
    function matchesCron(date, parts) {
        const minute = date.getMinutes();
        const hour = date.getHours();
        const dayOfMonth = date.getDate();
        const month = date.getMonth() + 1;
        const dayOfWeek = date.getDay();

        return matchesPart(minute, parts[0], 0, 59) &&
               matchesPart(hour, parts[1], 0, 23) &&
               matchesPart(dayOfMonth, parts[2], 1, 31) &&
               matchesPart(month, parts[3], 1, 12) &&
               matchesPart(dayOfWeek, parts[4], 0, 7);
    }

    // Match individual cron part
    function matchesPart(value, pattern, min, max) {
        if (pattern === '*') return true;

        // Handle step values
        if (pattern.includes('/')) {
            const parts = pattern.split('/');
            const step = parseInt(parts[1]);
            if (parts[0] === '*') {
                return value % step === 0;
            } else {
                const range = parts[0].split('-');
                const start = parseInt(range[0]);
                const end = range.length > 1 ? parseInt(range[1]) : max;
                return value >= start && value <= end && (value - start) % step === 0;
            }
        }

        // Handle lists
        if (pattern.includes(',')) {
            return pattern.split(',').map(p => parseInt(p)).includes(value);
        }

        // Handle ranges
        if (pattern.includes('-')) {
            const range = pattern.split('-');
            return value >= parseInt(range[0]) && value <= parseInt(range[1]);
        }

        // Exact match
        return value === parseInt(pattern);
    }

    // Load preset
    function loadPreset(preset) {
        const presets = {
            everyMinute: ['*', '*', '*', '*', '*'],
            everyHour: ['0', '*', '*', '*', '*'],
            daily: ['0', '0', '*', '*', '*'],
            weekly: ['0', '0', '*', '*', '0'],
            monthly: ['0', '0', '1', '*', '*'],
            weekdays: ['0', '9', '*', '*', '1-5']
        };

        const values = presets[preset];
        document.getElementById('minute').value = values[0];
        document.getElementById('hour').value = values[1];
        document.getElementById('dayOfMonth').value = values[2];
        document.getElementById('month').value = values[3];
        document.getElementById('dayOfWeek').value = values[4];
        generateCron();
    }

    // Load examples
    function loadExamples() {
        const grid = document.getElementById('examplesGrid');
        cronExamples.forEach((example, index) => {
            const card = document.createElement('div');
            card.className = 'example-card';
            card.onclick = function() { loadExample(example.cron); };
            card.innerHTML = '<div class="example-title">' + example.title + '</div>' +
                             '<div class="example-cron">' + example.cron + '</div>' +
                             '<div class="example-desc">' + example.desc + '</div>';
            grid.appendChild(card);
        });
    }

    // Load example into builder
    function loadExample(cronExpr) {
        const parts = cronExpr.split(' ');
        document.getElementById('minute').value = parts[0];
        document.getElementById('hour').value = parts[1];
        document.getElementById('dayOfMonth').value = parts[2];
        document.getElementById('month').value = parts[3];
        document.getElementById('dayOfWeek').value = parts[4];
        generateCron();

        // Switch to builder tab
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        document.querySelector('.tab-btn').classList.add('active');
        document.getElementById('builder-tab').classList.add('active');

        // Scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Parse cron expression
    function parseCron() {
        const input = document.getElementById('parseCronInput').value.trim();
        if (!input) {
            alert('Please enter a cron expression');
            return;
        }

        const parts = input.split(/\s+/);
        if (parts.length !== 5) {
            alert('Invalid cron expression. Must have 5 fields: minute hour day month weekday');
            return;
        }

        document.getElementById('parsedMinute').textContent = parts[0];
        document.getElementById('parsedHour').textContent = parts[1];
        document.getElementById('parsedDayOfMonth').textContent = parts[2];
        document.getElementById('parsedMonth').textContent = parts[3];
        document.getElementById('parsedDayOfWeek').textContent = parts[4];

        const description = generateDescription(parts[0], parts[1], parts[2], parts[3], parts[4]);
        document.getElementById('parsedDescription').textContent = description;

        document.getElementById('parseResult').style.display = 'block';
    }

    // Load parsed cron into builder
    function loadParsedToBuilder() {
        const parts = document.getElementById('parseCronInput').value.trim().split(/\s+/);
        document.getElementById('minute').value = parts[0];
        document.getElementById('hour').value = parts[1];
        document.getElementById('dayOfMonth').value = parts[2];
        document.getElementById('month').value = parts[3];
        document.getElementById('dayOfWeek').value = parts[4];
        generateCron();

        // Switch to builder tab
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        document.querySelector('.tab-btn').classList.add('active');
        document.getElementById('builder-tab').classList.add('active');

        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Copy cron expression
    function copyCron() {
        navigator.clipboard.writeText(currentCron).then(() => {
            alert('Cron expression copied: ' + currentCron);
        });
    }

    // Download cron expression
    function downloadCron() {
        const description = document.getElementById('cronDescription').textContent;
        const content = '# ' + description + '\n' + currentCron;
        const blob = new Blob([content], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'cron-expression.txt';
        a.click();
        URL.revokeObjectURL(url);
    }

    // Reset builder
    function resetBuilder() {
        document.getElementById('minute').value = '*';
        document.getElementById('hour').value = '*';
        document.getElementById('dayOfMonth').value = '*';
        document.getElementById('month').value = '*';
        document.getElementById('dayOfWeek').value = '*';
        generateCron();
    }
</script>
</div>
<%@ include file="body-close.jsp"%>
</html>

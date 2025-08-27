<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Socket.IO Client Tester - Real-time WebSocket Testing Tool</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="keywords" content="socket.io client, websocket tester, real-time communication, socket testing, websocket client, socket.io testing, network tools, real-time messaging" />
    <meta name="description" content="Online Socket.IO client tester supporting 1.x, 2.x, 3.x, and 4.x clients with dynamic loading, custom events, transports, namespaces, and comprehensive logging. Test real-time WebSocket connections instantly." />
    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
    <!-- Open Graph Meta Tags -->
    <meta property="og:type" content="website" />
    <meta property="og:title" content="Socket.IO Client Tester - Real-time WebSocket Testing Tool" />
    <meta property="og:description" content="Test Socket.IO connections with multiple client versions, custom events, transports, and real-time logging. Perfect for developers testing WebSocket applications." />
    <meta property="og:url" content="https://8gwifi.org/socket-io-client.jsp" />
    <meta property="og:site_name" content="8gwifi.org" />
    
    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Socket.IO Client Tester - Real-time WebSocket Testing Tool" />
    <meta name="twitter:description" content="Test Socket.IO connections with multiple client versions, custom events, transports, and real-time logging." />
    
    <%@ include file="header-script.jsp"%>
    
    <!-- JSON-LD Structured Data for SEO -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Socket.IO Client Tester",
        "description": "Comprehensive Socket.IO client testing tool supporting multiple client versions (1.x, 2.x, 3.x, 4.x) with dynamic loading, custom events, transports, namespaces, and real-time logging capabilities.",
        "url": "https://8gwifi.org/socket-io-client.jsp",
        "applicationCategory": "NetworkTool",
        "operatingSystem": "Web Browser",
        "browserRequirements": "Requires JavaScript. Requires HTML5. Supports WebSocket connections.",
        "featureList": [
            "Multi-version Socket.IO client support (1.x, 2.x, 3.x, 4.x)",
            "Dynamic client loading from CDN",
            "Custom event emission and listening",
            "Transport selection (WebSocket, Polling)",
            "Namespace and path configuration",
            "Query parameter support",
            "Real-time connection logging",
            "Connection status monitoring",
            "Event listener management",
            "JSON and text data support"
        ],
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "creator": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "keywords": "socket.io client, websocket tester, real-time communication, socket testing, websocket client, socket.io testing, network tools, real-time messaging, websocket debugging, socket.io debugging",
        "about": {
            "@type": "Thing",
            "name": "Real-time WebSocket Testing",
            "description": "Socket.IO Client Tester provides comprehensive testing capabilities for real-time WebSocket applications, supporting multiple client versions and extensive configuration options."
        },
        "audience": {
            "@type": "Audience",
            "audienceType": "Web Developers, Full-stack Developers, DevOps Engineers, Network Administrators, Real-time Application Developers"
        },
        "softwareVersion": "4.7.5, 3.1.3, 2.4.0, 1.7.4",
        "applicationSubCategory": "WebSocket Testing Tool",
        "screenshot": "https://8gwifi.org/webapp/images/site/socket-io-client.png",
        "downloadUrl": "https://8gwifi.org/socket-io-client.jsp",
        "installUrl": "https://8gwifi.org/socket-io-client.jsp",
        "softwareHelp": "https://8gwifi.org/socket-io-client.jsp#usage",
        "mainEntity": {
            "@type": "WebPage",
            "name": "Socket.IO Client Testing Guide",
            "description": "Complete guide to testing Socket.IO connections with multiple client versions and configurations."
        }
    }
    </script>
</head>

<%@ include file="body-script.jsp"%>

<!-- Compact Network Tools Navigation Bar -->
<%@ include file="network-tools-navbar.jsp"%>

<h1 class="mt-4">Socket.IO Client Tester</h1>
<hr>
<p class="text-muted">Connect to any Socket.IO server, choose client version, set transports, namespace, query params, and send/receive events.</p>

<div class="card mb-3">
    <div class="card-body">
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label>Server URL</label>
                    <input type="text" id="serverUrl" class="form-control" 
						   placeholder="https://yourdomain.com or wss://yourdomain.com" 
						   value="" required>
					<small class="form-text text-muted">
						<strong>Production:</strong> Use your deployed Socket.IO server URL (e.g., <code>https://yourdomain.com</code>).
						<strong>Development:</strong> Use your local development server (e.g., <code>http://localhost:8080</code>).
					</small>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label>Client Version</label>
                    <select class="form-control" id="clientVersion">
                        <option value="4.7.5" selected>4.7.5 (latest 4.x)</option>
                        <option value="3.1.3">3.1.3 (3.x)</option>
                        <option value="2.4.0">2.4.0 (2.x)</option>
                        <option value="1.7.4">1.7.4 (1.x)</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-3">
                <div class="form-group">
                    <label>Namespace (optional)</label>
                    <input type="text" class="form-control" id="namespace" placeholder="/chat">
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group">
                    <label>Path</label>
                    <input type="text" class="form-control" id="path" value="/socket.io">
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group">
                    <label>Transports</label>
                    <select class="form-control" id="transports" multiple>
                        <option value="websocket" selected>websocket</option>
                        <option value="polling">polling</option>
                    </select>
                    <small class="text-muted">Hold Ctrl/Cmd to multi-select</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group">
                    <label>With Credentials</label>
                    <select class="form-control" id="withCredentials">
                        <option value="false" selected>false</option>
                        <option value="true">true</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-3">
                <div class="form-group">
                    <label>Timeout (ms)</label>
                    <input type="number" class="form-control" id="timeout" value="10000">
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group">
                    <label>Reconnection</label>
                    <select class="form-control" id="reconnection">
                        <option value="true" selected>true</option>
                        <option value="false">false</option>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label>Query Params (key=value, comma separated)</label>
                    <input type="text" class="form-control" id="queryParams" placeholder="token=abc123, room=test">
                </div>
            </div>
        </div>

        <div class="mb-2">
            <button class="btn btn-success" id="connectBtn">Connect</button>
            <button class="btn btn-secondary" id="disconnectBtn" disabled>Disconnect</button>
            <span id="statusBadge" class="badge badge-secondary ml-2">Disconnected</span>
        </div>
    </div>
</div>

<div class="card mb-3">
    <div class="card-header">Send Event</div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <label>Event Name</label>
                    <input type="text" id="emitEvent" class="form-control" placeholder="message" value="message">
                </div>
            </div>
            <div class="col-md-8">
                <div class="form-group">
                    <label>Data (JSON or text)</label>
                    <input type="text" id="emitData" class="form-control" placeholder='{"hello":"world"}' value='{"text":"Hello from client","user":"TestUser"}'>
                </div>
            </div>
        </div>
        <button class="btn btn-primary" id="emitBtn" disabled>Emit</button>
    </div>
</div>

<div class="card mb-3">
    <div class="card-header">Listen to Events</div>
    <div class="card-body">
        <div class="form-inline mb-2">
            <input type="text" id="onEvent" class="form-control mr-2" placeholder="event name e.g. message">
            <button class="btn btn-outline-primary" id="addListenerBtn">Add Listener</button>
        </div>
        <div id="listeners" class="small text-muted"></div>
    </div>
</div>

<div class="card">
    <div class="card-header">Logs</div>
    <div class="card-body">
        <pre id="log" style="height:300px; overflow:auto; background:#0b1021; color:#d6e6ff; padding:10px; border-radius:6px;">Ready.</pre>
    </div>
</div>

<hr>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="socketiotester">Socket.IO Client Tester</h2>

<p><strong>Socket.IO Client Tester</strong> is a comprehensive tool for testing real-time WebSocket connections with multiple Socket.IO client versions. Whether you're developing real-time applications, debugging WebSocket connections, or testing different Socket.IO server configurations, this tool provides everything you need.</p>

<p>This tool is particularly useful for:</p>
<ul>
    <li><strong><em>Testing Socket.IO server connections</em></strong></li>
    <li><strong><em>Debugging real-time communication issues</em></strong></li>
    <li><strong><em>Comparing different Socket.IO client versions</em></strong></li>
    <li><strong><em>Testing custom events and data transmission</em></strong></li>
    <li><strong><em>Validating transport configurations</em></strong></li>
</ul>

<hr>

<h2 class="mt-4" id="features">Key Features</h2>

<div class="row">
    <div class="col-md-6">
        <h5>Client Version Support</h5>
        <ul>
            <li><strong>Socket.IO 4.x:</strong> Latest version with modern features</li>
            <li><strong>Socket.IO 3.x:</strong> Stable version with broad compatibility</li>
            <li><strong>Socket.IO 2.x:</strong> Legacy version support</li>
            <li><strong>Socket.IO 1.x:</strong> Classic version for older applications</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h5>Connection Options</h5>
        <ul>
            <li><strong>Transport Selection:</strong> WebSocket and Polling support</li>
            <li><strong>Namespace Support:</strong> Test specific Socket.IO namespaces</li>
            <li><strong>Custom Paths:</strong> Configure custom Socket.IO paths</li>
            <li><strong>Query Parameters:</strong> Add authentication tokens and metadata</li>
        </ul>
    </div>
</div>

<hr>

<h2 class="mt-4" id="usage">How to Use</h2>

<div class="row">
    <div class="col-md-6">
        <h5>1. Connection Setup</h5>
        <ol>
            <li>Enter your Socket.IO server URL (e.g., <code>https://api.yourdomain.com</code>)</li>
            <li>Select the appropriate client version</li>
            <li>Configure transport options (WebSocket/Polling)</li>
            <li>Set namespace and path if needed</li>
            <li>Click "Connect" to establish connection</li>
        </ol>
    </div>
    <div class="col-md-6">
        <h5>2. Event Testing</h5>
        <ol>
            <li>Use "Send Event" to emit custom events</li>
            <li>Add listeners for specific events</li>
            <li>Monitor real-time logs for all activity</li>
            <li>Test different data formats (JSON/Text)</li>
        </ol>
    </div>
</div>

<hr>

<h2 class="mt-4" id="commonuse">Common Use Cases</h2>

<table id="tablePreview" class="table table-bordered">
    <thead>
    <tr>
        <th>Use Case</th>
        <th>Description</th>
        <th>Example</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td><strong>Development Testing</strong></td>
        <td>Test Socket.IO servers during development</td>
        <td>Connect to your development server and test events</td>
    </tr>
    <tr>
        <td><strong>Production Debugging</strong></td>
        <td>Debug real-time issues in production</td>
        <td>Test live WebSocket connections and monitor logs</td>
    </tr>
    <tr>
        <td><strong>Version Compatibility</strong></td>
        <td>Test different Socket.IO client versions</td>
        <td>Compare 2.x vs 4.x client behavior</td>
    </tr>
    <tr>
        <td><strong>Transport Testing</strong></td>
        <td>Validate WebSocket and polling fallbacks</td>
        <td>Test connection stability across different transports</td>
    </tr>
    </tbody>
</table>

<hr>

<h2 class="mt-4" id="message-logging">Message Logging & Event Handling</h2>

<p><strong>Message Logging</strong> automatically captures and displays all messages received from the Socket.IO server. The tool provides comprehensive logging for both built-in events and custom events.</p>

<div class="row">
    <div class="col-md-6">
        <h5>Automatically Logged Events</h5>
        <ul>
            <li><strong>📨 message:</strong> Standard message events</li>
            <li><strong>💬 chat message:</strong> Chat application messages</li>
            <li><strong>🔔 notification:</strong> Server notifications</li>
            <li><strong>🔄 update:</strong> Data updates</li>
            <li><strong>📊 data:</strong> General data events</li>
            <li><strong>📡 Custom Events:</strong> Any events you add listeners for</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h5>Logging Features</h5>
        <ul>
            <li><strong>Real-time Display:</strong> Messages appear instantly in the log</li>
            <li><strong>Event Categorization:</strong> Different icons for different event types</li>
            <li><strong>Data Formatting:</strong> JSON data is properly formatted</li>
            <li><strong>Auto-scroll:</strong> Log automatically scrolls to show new messages</li>
            <li><strong>Console Logging:</strong> Detailed logs in browser console</li>
        </ul>
    </div>
</div>

<h5>How to Monitor Messages:</h5>
<ol>
    <li><strong>Connect</strong> to your Socket.IO server</li>
    <li><strong>Watch the Logs</strong> section for incoming messages</li>
    <li><strong>Add Custom Listeners</strong> for specific events you want to monitor</li>
    <li><strong>Check Browser Console</strong> for detailed debugging information</li>
</ol>

<hr>

<h2 class="mt-4" id="production-best-practices">Production Deployment Best Practices</h2>

<p><strong>For Production Use</strong>, always use proper domain names and SSL certificates to ensure secure, reliable WebSocket connections.</p>

<div class="row">
    <div class="col-md-6">
        <h5>Domain Configuration</h5>
        <ul>
            <li><strong>Use Real Domains:</strong> <code>https://yourdomain.com</code> instead of localhost</li>
            <li><strong>SSL Certificates:</strong> Always use HTTPS/WSS for production</li>
            <li><strong>Subdomain Strategy:</strong> Consider <code>socket.yourdomain.com</code> for WebSocket services</li>
            <li><strong>CDN Integration:</strong> Use CDN for improved global performance</li>
            <li><strong>DNS Configuration:</strong> Proper A/AAAA records for your domain</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h5>Security Considerations</h5>
        <ul>
            <li><strong>CORS Configuration:</strong> Allow only trusted domains</li>
            <li><strong>Authentication:</strong> Implement proper user authentication</li>
            <li><strong>Rate Limiting:</strong> Prevent abuse and DDoS attacks</li>
            <li><strong>Input Validation:</strong> Sanitize all incoming data</li>
            <li><strong>Monitoring:</strong> Track connection health and errors</li>
        </ul>
    </div>
</div>

<h5>Recommended Production URLs:</h5>
<ul>
    <li><code>https://api.yourdomain.com</code> - Main API endpoint</li>
    <li><code>wss://socket.yourdomain.com</code> - Dedicated WebSocket server</li>
    <li><code>https://realtime.yourdomain.com</code> - Real-time services</li>
    <li><code>https://chat.yourdomain.com</code> - Chat application server</li>
</ul>

<hr>

<h2 class="mt-4" id="troubleshooting">Troubleshooting Connection Issues</h2>

<div class="alert alert-info">
    <h6><strong>Common Connection Problems & Solutions:</strong></h6>
    <ul class="mb-0">
        <li><strong>CORS Errors:</strong> Ensure your Socket.IO server allows connections from 8gwifi.org</li>
        <li><strong>Mixed Content:</strong> Use WSS:// for HTTPS sites, WS:// for HTTP sites</li>
        <li><strong>Localhost Issues:</strong> Localhost connections only work in development environments</li>
        <li><strong>Server Accessibility:</strong> Verify your server is accessible from the internet</li>
        <li><strong>Firewall/Proxy:</strong> Check if corporate firewalls are blocking WebSocket connections</li>
    </ul>
</div>

<h5>Production Deployment Checklist:</h5>
<ol>
    <li><strong>Server URL:</strong> Use your production domain (e.g., <code>wss://yourdomain.com</code>)</li>
    <li><strong>CORS Configuration:</strong> Allow <code>https://8gwifi.org</code> in your server's CORS settings</li>
    <li><strong>SSL Certificate:</strong> Ensure your production server has valid SSL certificates</li>
    <li><strong>Network Access:</strong> Verify your server is accessible from external networks</li>
    <li><strong>Socket.IO Version:</strong> Match client and server versions for compatibility</li>
</ol>

<h5>Test Servers for Development:</h5>
<ul>
    <li><code>https://socket.io</code> - Official Socket.IO demo server</li>
    <li><code>wss://echo.websocket.org</code> - WebSocket echo server</li>
    <li><code>wss://ws.postman-echo.com/raw</code> - Postman WebSocket echo</li>
    <li><code>https://yourdomain.com</code> - Your production Socket.IO server</li>
    <li><code>https://api.yourdomain.com</code> - Your production API server</li>
</ul>

<h5>URL Format Examples:</h5>
<div class="row">
    <div class="col-md-6">
        <h6>Development (Local):</h6>
        <ul>
            <li><code>http://localhost:8080</code> - Local development server</li>
            <li><code>http://127.0.0.1:8080</code> - Alternative localhost format</li>
            <li><code>http://dev.yourdomain.com</code> - Development subdomain</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h6>Production (Deployed):</h6>
        <ul>
            <li><code>https://yourdomain.com</code> - Main production domain</li>
            <li><code>wss://yourdomain.com</code> - Secure WebSocket connection</li>
            <li><code>https://api.yourdomain.com</code> - Production API server</li>
            <li><code>https://socket.yourdomain.com</code> - Dedicated Socket.IO server</li>
        </ul>
    </div>
</div>

<hr>

<%@ include file="addcomments.jsp"%>
</div>

<script>
var socket = null;
var currentScript = null;
var loadedVersion = null;

function logLine(type, message, obj) {
    var ts = new Date().toISOString();
    var line = `[${ts}] ${type}: ${message}`;
    if (obj !== undefined) {
        try { line += "\n" + JSON.stringify(obj, null, 2); } catch (e) { line += "\n" + String(obj); }
    }
    var logEl = document.getElementById('log');
    logEl.textContent += "\n" + line;
    logEl.scrollTop = logEl.scrollHeight;
    // Also log to console for debugging
    console.log(`[${type}] ${message}`, obj);
}

function buildClientCdn(version) {
    if (version.startsWith('4.')) return 'https://cdn.jsdelivr.net/npm/socket.io-client@' + version + '/dist/socket.io.min.js';
    if (version.startsWith('3.')) return 'https://cdn.jsdelivr.net/npm/socket.io-client@' + version + '/dist/socket.io.min.js';
    if (version.startsWith('2.')) return 'https://cdn.jsdelivr.net/npm/socket.io-client@' + version + '/dist/socket.io.min.js';
    if (version.startsWith('1.')) return 'https://cdnjs.cloudflare.com/ajax/libs/socket.io/' + version + '/socket.io.min.js';
    return null;
}

function loadClient(version) {
    return new Promise(function(resolve, reject) {
        var url = buildClientCdn(version);
        if (!url) return reject('Unsupported version: ' + version);
        if (loadedVersion === version && window.io) return resolve();
        if (currentScript) {
            currentScript.parentNode.removeChild(currentScript);
            currentScript = null;
            try { delete window.io; } catch(e) { window.io = undefined; }
        }
        var s = document.createElement('script');
        s.src = url;
        s.async = false;
        s.onload = function(){ loadedVersion = version; logLine('client', 'Loaded Socket.IO client ' + version + ' (' + url + ')'); resolve(); };
        s.onerror = function(){ reject('Failed to load client from ' + url); };
        document.head.appendChild(s);
        currentScript = s;
    });
}

function parseQueryParams(str) {
    var result = {};
    if (!str) return result;
    str.split(',').forEach(function(pair){
        var p = pair.trim(); if (!p) return;
        var idx = p.indexOf('=');
        if (idx === -1) { result[p] = true; return; }
        var k = p.slice(0, idx).trim();
        var v = p.slice(idx+1).trim();
        result[k] = v;
    });
    return result;
}

function connect() {
    var url = document.getElementById('serverUrl').value.trim();
    var ns = document.getElementById('namespace').value.trim();
    var path = document.getElementById('path').value.trim() || '/socket.io';
    var transportsSel = Array.from(document.getElementById('transports').selectedOptions).map(function(o){return o.value;});
    var withCreds = document.getElementById('withCredentials').value === 'true';
    var timeout = parseInt(document.getElementById('timeout').value || '10000', 10);
    var reconnection = document.getElementById('reconnection').value === 'true';
    var q = parseQueryParams(document.getElementById('queryParams').value);
    var version = document.getElementById('clientVersion').value;

    if (!url) { 
        alert('Please enter server URL'); 
        return; 
    }

    // Validate URL format
    if (!url.startsWith('http://') && !url.startsWith('https://') && !url.startsWith('ws://') && !url.startsWith('wss://')) {
        alert('Please enter a valid URL starting with http://, https://, ws://, or wss://');
        return;
    }

    // Check for localhost vs production
    var isLocalhost = url.includes('localhost') || url.includes('127.0.0.1');
    if (isLocalhost && window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
        logLine('info', 'ℹ️ Connecting to localhost from production. Ensure your local server is accessible.');
        logLine('info', '   For production use, consider using your deployed domain instead.');
    }

    logLine('debug', 'Connection parameters:', {
        url: url,
        namespace: ns,
        path: path,
        transports: transportsSel,
        withCredentials: withCreds,
        timeout: timeout,
        reconnection: reconnection,
        query: q,
        version: version,
        isLocalhost: isLocalhost
    });

    loadClient(version)
        .then(function(){
            var target = url + (ns ? ns : '');
            var opts = {
                path: path,
                transports: transportsSel.length ? transportsSel : ['websocket','polling'],
                withCredentials: withCreds,
                timeout: timeout,
                reconnection: reconnection,
                query: q
            };
            logLine('connect', 'Connecting to ' + target, opts);
            console.log('Creating Socket.IO connection with options:', opts);
            
            socket = window.io(target, opts);
            logLine('debug', 'Socket object created:', socket);

            document.getElementById('connectBtn').disabled = true;
            document.getElementById('disconnectBtn').disabled = false;
            document.getElementById('emitBtn').disabled = false;
            document.getElementById('statusBadge').className = 'badge badge-warning';
            document.getElementById('statusBadge').innerText = 'Connecting...';

            socket.on('connect', function(){
                logLine('connect', 'Connected with id ' + socket.id);
                logLine('debug', 'Socket state after connect:', {
                    id: socket.id,
                    connected: socket.connected,
                    disconnected: socket.disconnected
                });
                document.getElementById('statusBadge').className = 'badge badge-success';
                document.getElementById('statusBadge').innerText = 'Connected';
            });
            
            socket.on('disconnect', function(reason){
                logLine('disconnect', 'Disconnected', {reason: reason});
                document.getElementById('statusBadge').className = 'badge badge-secondary';
                document.getElementById('statusBadge').innerText = 'Disconnected';
                document.getElementById('connectBtn').disabled = false;
                document.getElementById('disconnectBtn').disabled = true;
                document.getElementById('emitBtn').disabled = true;
            });
            
            socket.on('connect_error', function(err){ 
                logLine('error', 'connect_error', err && (err.message || err)); 
                console.error('Socket connection error:', err);
                
                // Provide helpful error messages for common issues
                var errorMsg = err && err.message ? err.message : 'Unknown connection error';
                if (errorMsg.includes('websocket error') || errorMsg.includes('WebSocket is closed')) {
                    logLine('error', '⚠️ Connection failed. This usually means:');
                    logLine('error', '   • The server is not accessible from this domain');
                    logLine('error', '   • CORS policy is blocking the connection');
                    logLine('error', '   • The server URL is incorrect or server is down');
                    logLine('error', '   • Mixed content (HTTPS trying to connect to HTTP)');
                }
                
                // Reset UI state
                document.getElementById('statusBadge').className = 'badge badge-danger';
                document.getElementById('statusBadge').innerText = 'Connection Failed';
                document.getElementById('connectBtn').disabled = false;
                document.getElementById('disconnectBtn').disabled = true;
                document.getElementById('emitBtn').disabled = true;
            });
            
            socket.on('reconnect_attempt', function(){ logLine('info', 'reconnect_attempt'); });
            socket.on('reconnect_failed', function(){ logLine('error', 'reconnect_failed'); });
            socket.on('message', function(data){ 
                logLine('event:message', '📨 Received message:', data); 
                console.log('📨 Received message event:', data);
            });
            
            // Enhanced event logging for common Socket.IO events
            socket.on('chat message', function(data) {
                logLine('event:chat', '💬 Chat message received:', data);
                console.log('💬 Chat message:', data);
            });
            
            socket.on('notification', function(data) {
                logLine('event:notification', '🔔 Notification received:', data);
                console.log('🔔 Notification:', data);
            });
            
            socket.on('update', function(data) {
                logLine('event:update', '🔄 Update received:', data);
                console.log('🔄 Update:', data);
            });
            
            socket.on('data', function(data) {
                logLine('event:data', '📊 Data received:', data);
                console.log('📊 Data:', data);
            });
            
            // Catch-all event listener for any other events
            if (socket.onAny) {
                socket.onAny(function(eventName, ...args) {
                    if (!['connect', 'disconnect', 'connect_error', 'reconnect_attempt', 'reconnect_failed', 'reconnect', 'reconnect_error', 'error', 'message', 'chat message', 'notification', 'update', 'data'].includes(eventName)) {
                        logLine('event:' + eventName, '📡 Event received:', args);
                        console.log('📡 Event received:', eventName, args);
                    }
                });
            } else {
                logLine('info', 'onAny not available in this Socket.IO version. Add custom listeners for specific events.');
            }
            
            // Add more debugging events
            socket.on('error', function(err) {
                logLine('error', 'Socket error event', err);
                console.error('Socket error event:', err);
            });
            
            socket.on('reconnect', function(attemptNumber) {
                logLine('info', 'Reconnected after ' + attemptNumber + ' attempts');
            });
            
            socket.on('reconnect_error', function(err) {
                logLine('error', 'Reconnection error', err);
            });
        })
        .catch(function(err){ 
            logLine('error', String(err)); 
            console.error('Connection setup error:', err);
            alert(err); 
        });
}

function disconnect() {
    try { 
        if (socket) { 
            logLine('debug', 'Disconnecting socket:', socket.id);
            socket.close(); 
            socket = null; 
        } 
    } catch(e) {
        logLine('error', 'Error during disconnect:', e);
    }
}

function emitEvent() {
    logLine('debug', 'emitEvent called, socket state:', {
        socket: socket,
        connected: socket ? socket.connected : false,
        id: socket ? socket.id : null
    });
    
    if (!socket) { 
        logLine('error', 'No socket available');
        alert('Not connected'); 
        return; 
    }
    
    if (!socket.connected) {
        logLine('error', 'Socket not connected');
        alert('Socket not connected');
        return;
    }
    
    var ev = document.getElementById('emitEvent').value.trim() || 'message';
    var raw = document.getElementById('emitData').value.trim() || 'Hello from client';
    var data = raw;
    
    // Validate event name
    if (!ev || ev.length === 0) {
        ev = 'message';
        logLine('debug', 'Using default event name: message');
    }
    
    try { 
        if (raw.trim()) {
            data = JSON.parse(raw); 
            logLine('debug', 'Parsed JSON data successfully');
        }
    } catch(e) {
        logLine('debug', 'Data is not valid JSON, using as string');
    }
    
    logLine('emit', 'Sending event: ' + ev + ' with data:', data);
    console.log('Emitting event:', ev, 'with data:', data);
    
    try {
        var result = socket.emit(ev, data);
        logLine('debug', 'Emit result:', result);
        
        // Add to log immediately
        var sentMessageElement = document.createElement('div');
        sentMessageElement.textContent = '✅ Sent: ' + ev + ' - ' + (typeof data === 'string' ? data : JSON.stringify(data));
        document.getElementById('log').appendChild(sentMessageElement);
        
        // Clear input
        document.getElementById('emitData').value = '';
        
        logLine('success', 'Event "' + ev + '" emitted successfully');
    } catch (emitError) {
        logLine('error', 'Error emitting event:', emitError);
        console.error('Emit error:', emitError);
        alert('Error sending event: ' + emitError.message);
    }
}

function addListener() {
    if (!socket) { 
        logLine('error', 'No socket available for listener');
        alert('Connect first'); 
        return; 
    }
    
    var ev = document.getElementById('onEvent').value.trim();
    if (!ev) { 
        alert('Enter event name'); 
        return; 
    }
    
    // Check if listener already exists
    if (socket.hasListeners && socket.hasListeners(ev)) {
        logLine('warning', 'Listener already exists for event: ' + ev);
        alert('Listener already exists for this event');
        return;
    }
    
    logLine('debug', 'Adding listener for event:', ev);
    
    socket.on(ev, function(payload){ 
        logLine('event:'+ev, '📡 Custom event received:', payload); 
        console.log('📡 Custom event received:', ev, 'with payload:', payload);
        
        // Add visual feedback in the log
        var eventElement = document.createElement('div');
        eventElement.innerHTML = '<span style="color: #28a745;">📡</span> <strong>' + ev + ':</strong> ' + 
                               (typeof payload === 'string' ? payload : JSON.stringify(payload, null, 2));
        eventElement.style.marginBottom = '5px';
        eventElement.style.padding = '5px';
        eventElement.style.backgroundColor = '#f8f9fa';
        eventElement.style.borderRadius = '3px';
        document.getElementById('log').appendChild(eventElement);
        
        // Auto-scroll to bottom
        document.getElementById('log').scrollTop = document.getElementById('log').scrollHeight;
    });
    
    var listeners = document.getElementById('listeners');
    var badge = document.createElement('span');
    badge.className = 'badge badge-info mr-1 mb-1';
    badge.textContent = ev;
    badge.style.cursor = 'pointer';
    badge.title = 'Click to remove listener';
    
    // Add remove functionality
    badge.onclick = function() {
        if (socket) {
            socket.off(ev);
            logLine('info', 'Removed listener for event: ' + ev);
            this.remove();
        }
    };
    
    listeners.appendChild(badge);
    document.getElementById('onEvent').value = '';
    
    logLine('success', '✅ Listener added for event: ' + ev);
}

// Bind buttons
(document.getElementById('connectBtn')).addEventListener('click', connect);
(document.getElementById('disconnectBtn')).addEventListener('click', disconnect);
(document.getElementById('emitBtn')).addEventListener('click', emitEvent);
(document.getElementById('addListenerBtn')).addEventListener('click', addListener);

// Add some helpful debugging info
logLine('info', 'Socket.IO Client Tester loaded. Check browser console for detailed logs.');
console.log('Socket.IO Client Tester initialized. Socket object will be created on connection.');
</script>

<%@ include file="body-close.jsp"%>

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
                    <input type="text" class="form-control" id="serverUrl" placeholder="https://example.com:3000">
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
            <li>Enter your Socket.IO server URL (e.g., <code>https://example.com:3000</code>)</li>
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
        <td>Connect to <code>localhost:3000</code> and test events</td>
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

<h2 class="mt-4" id="troubleshooting">Troubleshooting</h2>

<div class="alert alert-info">
    <h6><strong>Common Connection Issues:</strong></h6>
    <ul class="mb-0">
        <li><strong>CORS Errors:</strong> Ensure your server allows connections from this domain</li>
        <li><strong>Transport Issues:</strong> Try switching between WebSocket and Polling</li>
        <li><strong>Path Mismatch:</strong> Verify the Socket.IO path matches your server configuration</li>
        <li><strong>Version Compatibility:</strong> Use the client version that matches your server</li>
    </ul>
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

function loadClient(version, customUrl) {
    return new Promise(function(resolve, reject) {
        var url = (customUrl && customUrl.trim().length > 0) ? customUrl.trim() : buildClientCdn(version);
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
    var customUrl = document.getElementById('customClientUrl').value;

    if (!url) { alert('Please enter server URL'); return; }

    logLine('debug', 'Connection parameters:', {
        url: url,
        namespace: ns,
        path: path,
        transports: transportsSel,
        withCredentials: withCreds,
        timeout: timeout,
        reconnection: reconnection,
        query: q,
        version: version
    });

    loadClient(version, customUrl)
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
            });
            
            socket.on('reconnect_attempt', function(){ logLine('info', 'reconnect_attempt'); });
            socket.on('reconnect_failed', function(){ logLine('error', 'reconnect_failed'); });
            socket.on('message', function(data){ logLine('event:message', 'received', data); });
            
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
    
    logLine('debug', 'Adding listener for event:', ev);
    
    socket.on(ev, function(payload){ 
        logLine('event:'+ev, 'received', payload); 
        console.log('Received event:', ev, 'with payload:', payload);
    });
    
    var listeners = document.getElementById('listeners');
    var badge = document.createElement('span');
    badge.className = 'badge badge-info mr-1';
    badge.textContent = ev;
    listeners.appendChild(badge);
    document.getElementById('onEvent').value = '';
    
    logLine('success', 'Listener added for event: ' + ev);
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

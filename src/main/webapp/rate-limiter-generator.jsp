<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>API Rate Limiter Generator – Cloudflare, Redis, Nginx | DDoS Protection | 8gwifi.org</title>
        <meta name="description"
            content="Free API rate limiter generator for Cloudflare Workers, Redis, Nginx, Kong, Express.js. Token bucket, sliding window algorithms. Stop DDoS attacks, prevent API abuse, implement API throttling.">
        <meta name="keywords"
            content="cloudflare rate limit, cloudflare workers rate limiting, api rate limiting, ddos protection, token bucket algorithm, sliding window rate limit, redis rate limiter, nginx rate limit, api throttling, prevent api abuse, cloudflare ddos, rate limit api, api gateway rate limiting">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "API Rate Limiter Generator",
      "description": "Generate production-ready rate limiting configurations for Redis, Nginx, Kong, Express.js, and Spring Boot with multiple algorithms.",
      "url": "https://8gwifi.org/rate-limiter-generator.jsp",
      "applicationCategory": "DeveloperApplication",
      "operatingSystem": "Any",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      },
      "datePublished": "2025-12-01",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Cloudflare Workers Rate Limiting",
        "Token Bucket Algorithm",
        "Sliding Window Algorithm",
        "Redis Lua Scripts",
        "Nginx Configuration",
        "Express.js Middleware",
        "DDoS Protection"
      ]
    }
    </script>
            <style>
                :root {
                    --theme-primary: #0f1689;
                    --theme-secondary: #6366f1;
                    --theme-gradient: linear-gradient(135deg, #0f1689 0%, #6366f1 100%);
                    --theme-light: #eef2ff;
                    --color-redis: #dc2626;
                    --color-nginx: #10b981;
                    --color-kong: #3b82f6;
                    --color-express: #fbbf24;
                    --color-spring: #22c55e;
                    --color-cloudflare: #f38020;
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
                    min-height: 400px;
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

                .backend-selector {
                    border-bottom: 2px solid #dee2e6;
                    margin-bottom: 1.5rem;
                }

                .backend-selector .nav-link {
                    border: none;
                    color: #6c757d;
                    font-weight: 500;
                    padding: 0.75rem 1.5rem;
                    cursor: pointer;
                    transition: all 0.3s ease
                }

                .backend-selector .nav-link:hover {
                    color: var(--theme-secondary);
                    background-color: rgba(99, 102, 241, 0.1)
                }

                .backend-selector .nav-link.active {
                    color: var(--theme-primary);
                    border-bottom: 3px solid var(--theme-primary);
                    background-color: transparent
                }

                .info-badge {
                    display: inline-block;
                    padding: 0.25rem 0.6rem;
                    border-radius: 12px;
                    font-size: 0.75rem;
                    font-weight: 600;
                    margin-left: 0.5rem;
                }

                .badge-redis {
                    background: #fee2e2;
                    color: #991b1b;
                }

                .badge-nginx {
                    background: #d1fae5;
                    color: #065f46;
                }

                .badge-kong {
                    background: #dbeafe;
                    color: #1e40af;
                }

                .badge-express {
                    background: #fef3c7;
                    color: #92400e;
                }

                .badge-spring {
                    background: #dcfce7;
                    color: #166534;
                }

                .badge-cloudflare {
                    background: #fff3e0;
                    color: #e65100;
                }
            </style>
    </head>
    <%@ include file="body-script.jsp" %>
        <%@ include file="devops-tools-navbar.jsp" %>

            <div class="container-fluid px-lg-5 mt-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-0">API Rate Limiter Generator</h1>
                        <p class="text-muted mb-0">Token Bucket, Sliding Window, Redis, Nginx & More</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
                </div>

                <!-- Preset Templates -->
                <div class="card tool-card mb-4">
                    <div class="card-body">
                        <h6 class="mb-3"><i class="fas fa-magic"></i> Quick Start Presets</h6>
                        <div class="d-flex flex-wrap">
                            <button class="btn btn-outline-primary preset-btn" onclick="loadPreset('public-api')">
                                <i class="fas fa-globe"></i> Public API
                            </button>
                            <button class="btn btn-outline-info preset-btn" onclick="loadPreset('authenticated')">
                                <i class="fas fa-user-shield"></i> Authenticated API
                            </button>
                            <button class="btn btn-outline-success preset-btn" onclick="loadPreset('internal')">
                                <i class="fas fa-network-wired"></i> Internal Service
                            </button>
                            <button class="btn btn-outline-warning preset-btn" onclick="loadPreset('free-tier')">
                                <i class="fas fa-gift"></i> Free Tier
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Backend Selector -->
                <ul class="nav backend-selector" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#redisBackend"
                            onclick="switchBackend('redis')">
                            <i class="fas fa-database"></i> Redis
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#nginxBackend" onclick="switchBackend('nginx')">
                            <i class="fas fa-server"></i> Nginx
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#kongBackend" onclick="switchBackend('kong')">
                            <i class="fas fa-gateway"></i> Kong
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#expressBackend" onclick="switchBackend('express')">
                            <i class="fab fa-node-js"></i> Express.js
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#springBackend" onclick="switchBackend('spring')">
                            <i class="fas fa-leaf"></i> Spring Boot
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#cloudflareBackend"
                            onclick="switchBackend('cloudflare')">
                            <i class="fas fa-cloud"></i> Cloudflare
                        </a>
                    </li>
                </ul>

                <div class="row mt-4">
                    <div class="col-lg-6">
                        <div class="card tool-card mb-4">
                            <div class="card-header card-header-custom"><i class="fas fa-cog mr-2"></i> Configuration
                            </div>
                            <div class="card-body" style="max-height: 800px; overflow-y: auto;">
                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-tachometer-alt"></i> Rate Limiting
                                        Algorithm</div>
                                    <div class="form-group">
                                        <label>Algorithm</label>
                                        <select class="form-control" id="algorithm">
                                            <option value="token-bucket">Token Bucket (Allows Bursts)</option>
                                            <option value="sliding-window">Sliding Window (Smooth Distribution)</option>
                                            <option value="fixed-window">Fixed Window (Simple)</option>
                                            <option value="leaky-bucket">Leaky Bucket (Constant Rate)</option>
                                        </select>
                                        <small class="text-muted" id="algorithmDesc">Allows bursts while maintaining
                                            average rate</small>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-sliders-h"></i> Rate Limits</div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Requests</label>
                                                <input type="number" class="form-control" id="requestLimit" value="100"
                                                    min="1">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Per</label>
                                                <select class="form-control" id="timeWindow">
                                                    <option value="second">Second</option>
                                                    <option value="minute" selected>Minute</option>
                                                    <option value="hour">Hour</option>
                                                    <option value="day">Day</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="burstGroup">
                                        <label>Burst Allowance</label>
                                        <input type="number" class="form-control" id="burstSize" value="150" min="1">
                                        <small class="text-muted">Maximum requests in a burst (Token Bucket
                                            only)</small>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-key"></i> Identification Key</div>
                                    <div class="form-group">
                                        <label>Rate Limit By</label>
                                        <select class="form-control" id="keyStrategy">
                                            <option value="ip">IP Address</option>
                                            <option value="user-id">User ID (Authenticated)</option>
                                            <option value="api-key">API Key</option>
                                            <option value="header">Custom Header</option>
                                        </select>
                                    </div>
                                    <div class="form-group" id="customHeaderGroup" style="display:none">
                                        <label>Header Name</label>
                                        <input type="text" class="form-control" id="customHeader" value="X-API-Key">
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><i class="fas fa-exclamation-triangle"></i> Error
                                        Handling</div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="includeHeaders" checked>
                                        <label class="custom-control-label" for="includeHeaders">Include Rate Limit
                                            Headers</label>
                                    </div>
                                    <div class="custom-control custom-switch mb-2">
                                        <input type="checkbox" class="custom-control-input" id="includeRetryAfter"
                                            checked>
                                        <label class="custom-control-label" for="includeRetryAfter">Include Retry-After
                                            Header</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="sticky-preview">
                            <div class="card tool-card mb-3">
                                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-code"></i> Generated Configuration</span>
                                    <span id="backendBadge" class="info-badge badge-redis">Redis Lua</span>
                                </div>
                                <div class="card-body p-0">
                                    <pre id="codeOutput" class="code-preview mb-0"></pre>
                                </div>
                                <div class="card-footer bg-light d-flex justify-content-end">
                                    <button class="btn btn-sm btn-outline-dark mr-2" onclick="copyCode()"><i
                                            class="fas fa-copy"></i> Copy</button>
                                    <button class="btn btn-sm btn-primary" onclick="downloadCode()"><i
                                            class="fas fa-download"></i> Download</button>
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
                                                    What's the difference between Token Bucket and Sliding Window?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseOne" class="collapse show" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                <strong>Token Bucket</strong> allows bursts (e.g., 150 requests at once
                                                when limit is 100/min) and refills tokens at a constant rate. Great for
                                                APIs that need to handle short bursts.<br><br>
                                                <strong>Sliding Window</strong> distributes requests smoothly over time.
                                                If limit is 100/min, it calculates an average over the last minute.
                                                Better for preventing sudden spikes.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header" id="headingTwo">
                                            <h2 class="mb-0">
                                                <button class="btn btn-link btn-block text-left collapsed" type="button"
                                                    data-toggle="collapse" data-target="#collapseTwo">
                                                    When should I use Redis vs Nginx for rate limiting?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseTwo" class="collapse" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                <strong>Redis</strong>: Best for distributed systems with multiple
                                                backend servers. Maintains state across all instances. Ideal for
                                                user-based limiting.<br><br>
                                                <strong>Nginx</strong>: Best for simple IP-based limiting at the edge.
                                                Very fast, low latency. Good for protecting against DDoS. Limited to
                                                IP-based keys.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header" id="headingThree">
                                            <h2 class="mb-0">
                                                <button class="btn btn-link btn-block text-left collapsed" type="button"
                                                    data-toggle="collapse" data-target="#collapseThree">
                                                    What are good rate limits for a public API?
                                                </button>
                                            </h2>
                                        </div>
                                        <div id="collapseThree" class="collapse" data-parent="#faqAccordion">
                                            <div class="card-body">
                                                <strong>Public/Unauthenticated</strong>: 100 req/min per IP (prevents
                                                abuse while allowing legitimate use)<br>
                                                <strong>Authenticated/Free Tier</strong>: 1000 req/hour per user<br>
                                                <strong>Paid/Premium</strong>: 10,000+ req/hour per user<br>
                                                <strong>Internal/Service-to-Service</strong>: 10,000+ req/min (high
                                                trust)
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
                let currentBackend = 'redis';

                const algorithmDescriptions = {
                    'token-bucket': 'Allows bursts while maintaining average rate. Refills tokens at constant rate.',
                    'sliding-window': 'Smooths out request distribution. Calculates average over rolling time period.',
                    'fixed-window': 'Simple time-based limits. Resets counter at fixed intervals.',
                    'leaky-bucket': 'Constant outflow rate. Queues overflow requests for processing.'
                };

                document.addEventListener('DOMContentLoaded', function () {
                    generateCode();

                    // Event listeners for real-time updates
                    ['requestLimit', 'burstSize', 'customHeader'].forEach(id => {
                        const el = document.getElementById(id);
                        if (el) el.addEventListener('input', generateCode);
                    });

                    ['algorithm', 'timeWindow', 'keyStrategy'].forEach(id => {
                        const el = document.getElementById(id);
                        if (el) el.addEventListener('change', generateCode);
                    });

                    ['includeHeaders', 'includeRetryAfter'].forEach(id => {
                        document.getElementById(id).addEventListener('change', generateCode);
                    });

                    document.getElementById('algorithm').addEventListener('change', function () {
                        const algo = this.value;
                        document.getElementById('algorithmDesc').textContent = algorithmDescriptions[algo];

                        // Show/hide burst allowance based on algorithm
                        const burstGroup = document.getElementById('burstGroup');
                        burstGroup.style.display = (algo === 'token-bucket') ? 'block' : 'none';

                        generateCode();
                    });

                    document.getElementById('keyStrategy').addEventListener('change', function () {
                        const customHeaderGroup = document.getElementById('customHeaderGroup');
                        customHeaderGroup.style.display = (this.value === 'header') ? 'block' : 'none';
                        generateCode();
                    });
                });

                function switchBackend(backend) {
                    currentBackend = backend;

                    const badges = {
                        'redis': { text: 'Redis Lua', class: 'badge-redis' },
                        'nginx': { text: 'Nginx Config', class: 'badge-nginx' },
                        'kong': { text: 'Kong Plugin', class: 'badge-kong' },
                        'express': { text: 'Express.js', class: 'badge-express' },
                        'spring': { text: 'Spring Boot', class: 'badge-spring' },
                        'cloudflare': { text: 'Cloudflare Workers', class: 'badge-cloudflare' }
                    };

                    const badge = document.getElementById('backendBadge');
                    badge.textContent = badges[backend].text;
                    badge.className = 'info-badge ' + badges[backend].class;

                    generateCode();
                }

                function generateCode() {
                    const algorithm = document.getElementById('algorithm').value;
                    const requestLimit = parseInt(document.getElementById('requestLimit').value);
                    const timeWindow = document.getElementById('timeWindow').value;
                    const burstSize = parseInt(document.getElementById('burstSize').value);
                    const keyStrategy = document.getElementById('keyStrategy').value;
                    const customHeader = document.getElementById('customHeader').value;
                    const includeHeaders = document.getElementById('includeHeaders').checked;
                    const includeRetryAfter = document.getElementById('includeRetryAfter').checked;

                    let code = '';

                    if (currentBackend === 'redis') {
                        code = generateRedisCode(algorithm, requestLimit, timeWindow, burstSize, keyStrategy, includeHeaders);
                    } else if (currentBackend === 'nginx') {
                        code = generateNginxCode(requestLimit, timeWindow, keyStrategy);
                    } else if (currentBackend === 'kong') {
                        code = generateKongCode(requestLimit, timeWindow, keyStrategy);
                    } else if (currentBackend === 'express') {
                        code = generateExpressCode(algorithm, requestLimit, timeWindow, keyStrategy, customHeader);
                    } else if (currentBackend === 'spring') {
                        code = generateSpringCode(algorithm, requestLimit, timeWindow);
                    } else if (currentBackend === 'cloudflare') {
                        code = generateCloudflareCode(algorithm, requestLimit, timeWindow, keyStrategy);
                    }

                    document.getElementById('codeOutput').textContent = code;
                }

                function generateRedisCode(algorithm, limit, window, burst, keyStrategy) {
                    const windowSeconds = getWindowInSeconds(window);
                    const keyStrategyComment = keyStrategy === 'ip' ? 'IP Address' :
                        keyStrategy === 'user-id' ? 'User ID' :
                            keyStrategy === 'api-key' ? 'API Key' : 'Custom Header';
                    const keyExample = keyStrategy === 'ip' ? "'rate:ip:' + clientIP" :
                        keyStrategy === 'user-id' ? "'rate:user:' + userId" :
                            keyStrategy === 'api-key' ? "'rate:key:' + apiKey" : "'rate:custom:' + customValue";

                    if (algorithm === 'token-bucket') {
                        return `-- Redis Lua Script: Token Bucket Algorithm
-- ${limit} requests per ${window} with ${burst} burst capacity
                            keyStrategy === 'api-key' ? 'request.headers.get("X-API-Key") || request.headers.get("CF-Connecting-IP")' :
                                'request.headers.get("X-Custom-Key") || request.headers.get("CF-Connecting-IP")';

                    if (algorithm === 'token-bucket' || algorithm === 'sliding-window') {
                        return `// Cloudflare Workers Rate Limiting
                        // ${limit} requests per ${window}
                        // Algorithm: ${algorithm}

                        export default {
                            async fetch(request, env) {
                                const key = ${ keyStrategyCode };
                                const rateLimitKey = \`rate_limit:\${key}\`;
    
    // Use Cloudflare KV for rate limiting state
    const now = Date.now();
    const windowMs = ${windowSeconds * 1000};
    
    try {
      // Get current state from KV
      const stateJson = await env.RATE_LIMIT_KV.get(rateLimitKey);
      let state = stateJson ? JSON.parse(stateJson) : { count: 0, resetTime: now + windowMs };
      
      // Reset window if expired
      if (now > state.resetTime) {
        state = { count: 0, resetTime: now + windowMs };
      }
      
      // Check rate limit
      if (state.count >= ${limit}) {
        const retryAfter = Math.ceil((state.resetTime - now) / 1000);
        
        return new Response(JSON.stringify({
          error: 'Too many requests',
          message: 'Rate limit exceeded',
          limit: ${limit},
          window: '${window}',
          retryAfter: retryAfter
        }), {
          status: 429,
          headers: {
            'Content-Type': 'application/json',
            'X-RateLimit-Limit': '${limit}',
            'X-RateLimit-Remaining': '0',
            'X-RateLimit-Reset': state.resetTime.toString(),
            'Retry-After': retryAfter.toString()
          }
        });
      }
      
      // Increment counter
      state.count++;
      await env.RATE_LIMIT_KV.put(rateLimitKey, JSON.stringify(state), {
        expirationTtl: ${windowSeconds * 2}
      });
      
      // Forward request to origin
      const response = await fetch(request);
      const newResponse = new Response(response.body, response);
      
      // Add rate limit headers
      newResponse.headers.set('X-RateLimit-Limit', '${limit}');
      newResponse.headers.set('X-RateLimit-Remaining', (${limit} - state.count).toString());
      newResponse.headers.set('X-RateLimit-Reset', state.resetTime.toString());
      
      return newResponse;
      
    } catch (error) {
      // On error, allow request but log
      console.error('Rate limiting error:', error);
      return fetch(request);
    }
  }
};

// Setup:
// 1. Create KV namespace: wrangler kv:namespace create "RATE_LIMIT_KV"
// 2. Add to wrangler.toml:
//    kv_namespaces = [
//      { binding = "RATE_LIMIT_KV", id = "your-kv-id" }
//    ]
// 3. Deploy: wrangler deploy`;
                            } else {
                                return `// Cloudflare Workers Rate Limiting (Fixed Window)
// ${limit} requests per ${window}

export default {
  async fetch(request, env) {
    const key = ${keyStrategyCode};
    const rateLimitKey = \`rate_limit:\${key}\`;
    
    // Use Cloudflare Durable Objects or KV
    const now = Math.floor(Date.now() / 1000);
    const windowKey = \`\${rateLimitKey}:\${Math.floor(now / ${windowSeconds})}\`;
    
    try {
      const count = await env.RATE_LIMIT_KV.get(windowKey);
      const currentCount = count ? parseInt(count) : 0;
      
      if (currentCount >= ${limit}) {
        return new Response(JSON.stringify({
          error: 'Rate limit exceeded',
          limit: ${limit},
          window: '${window}'
        }), {
          status: 429,
          headers: {
            'Content-Type': 'application/json',
            'X-RateLimit-Limit': '${limit}',
            'X-RateLimit-Remaining': '0',
            'Retry-After': '${windowSeconds}'
          }
        });
      }
      
      // Increment counter
      await env.RATE_LIMIT_KV.put(windowKey, (currentCount + 1).toString(), {
        expirationTtl: ${windowSeconds * 2}
      });
      
      // Forward to origin
      const response = await fetch(request);
      const newResponse = new Response(response.body, response);
      newResponse.headers.set('X-RateLimit-Limit', '${limit}');
      newResponse.headers.set('X-RateLimit-Remaining', (${limit} - currentCount - 1).toString());
      
      return newResponse;
    } catch (error) {
      console.error('Rate limiting error:', error);
      return fetch(request);
    }
  }
};`;
                            }
                        }

                        function getWindowInSeconds(window) {
                            const windows = {
                                'second': 1,
                                'minute': 60,
                                'hour': 3600,
                                'day': 86400
                            };
                            return windows[window];
                        }

                        function loadPreset(name) {
                            if (name === 'public-api') {
                                document.getElementById('requestLimit').value = '100';
                                document.getElementById('timeWindow').value = 'minute';
                                document.getElementById('burstSize').value = '150';
                                document.getElementById('keyStrategy').value = 'ip';
                                document.getElementById('algorithm').value = 'token-bucket';
                            } else if (name === 'authenticated') {
                                document.getElementById('requestLimit').value = '1000';
                                document.getElementById('timeWindow').value = 'hour';
                                document.getElementById('burstSize').value = '1200';
                                document.getElementById('keyStrategy').value = 'user-id';
                                document.getElementById('algorithm').value = 'sliding-window';
                            } else if (name === 'internal') {
                                document.getElementById('requestLimit').value = '10000';
                                document.getElementById('timeWindow').value = 'minute';
                                document.getElementById('burstSize').value = '15000';
                                document.getElementById('keyStrategy').value = 'api-key';
                                document.getElementById('algorithm').value = 'token-bucket';
                            } else if (name === 'free-tier') {
                                document.getElementById('requestLimit').value = '50';
                                document.getElementById('timeWindow').value = 'hour';
                                document.getElementById('burstSize').value = '60';
                                document.getElementById('keyStrategy').value = 'user-id';
                                document.getElementById('algorithm').value = 'fixed-window';
                            }

                            generateCode();
                        }

                        function copyCode() {
                            const content = document.getElementById('codeOutput').textContent;
                            navigator.clipboard.writeText(content).then(() => {
                                alert('Copied to clipboard!');
                            });
                        }

                        function downloadCode() {
                            const content = document.getElementById('codeOutput').textContent;
                            const blob = new Blob([content], { type: 'text/plain' });
                            const link = document.createElement('a');
                            link.href = URL.createObjectURL(blob);

                            const extensions = {
                                'redis': 'lua',
                                'nginx': 'conf',
                                'kong': 'yaml',
                                'express': 'js',
                                'spring': 'java',
                                'cloudflare': 'js'
                            };

                            link.download = `rate-limiter.${extensions[currentBackend]}`;
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

    </html>
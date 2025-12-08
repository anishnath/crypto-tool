<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reset Cache & Service Worker</title>
        <style>
            body {
                font-family: system-ui, sans-serif;
                padding: 2rem;
                max-width: 600px;
                margin: 0 auto;
                line-height: 1.5;
            }

            .status {
                padding: 1rem;
                border-radius: 8px;
                background: #f3f4f6;
                margin-top: 1rem;
                font-family: monospace;
            }

            .success {
                color: #059669;
            }

            .error {
                color: #dc2626;
            }

            button {
                padding: 0.75rem 1.5rem;
                background: #2563eb;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 1rem;
            }

            button:hover {
                background: #1d4ed8;
            }
        </style>
    </head>

    <body>
        <h1>Reset Cache & Service Worker</h1>
        <p>This tool will unregister all Service Workers and clear the Cache Storage API to fix loading issues.</p>

        <button onclick="resetEverything()">Reset Everything</button>

        <div id="log" class="status">Waiting for action...</div>

        <script>
            function log(msg, type = '') {
                const el = document.getElementById('log');
                const line = document.createElement('div');
                line.textContent = '> ' + msg;
                if (type) line.className = type;
                el.appendChild(line);
            }

            async function resetEverything() {
                document.getElementById('log').innerHTML = '';
                log('Starting reset process...');

                // 1. Unregister Service Workers
                if ('serviceWorker' in navigator) {
                    try {
                        const registrations = await navigator.serviceWorker.getRegistrations();
                        if (registrations.length === 0) {
                            log('No Service Workers found.');
                        } else {
                            for (const registration of registrations) {
                                const result = await registration.unregister();
                                log(`Unregistered Service Worker: ${registration.scope} (${result ? 'Success' : 'Failed'})`, result ? 'success' : 'error');
                            }
                        }
                    } catch (e) {
                        log('Error unregistering Service Workers: ' + e.message, 'error');
                    }
                } else {
                    log('Service Workers not supported in this browser.');
                }

                // 2. Clear Cache Storage
                if ('caches' in window) {
                    try {
                        const keys = await caches.keys();
                        if (keys.length === 0) {
                            log('No Caches found.');
                        } else {
                            for (const key of keys) {
                                const result = await caches.delete(key);
                                log(`Deleted Cache: ${key} (${result ? 'Success' : 'Failed'})`, result ? 'success' : 'error');
                            }
                        }
                    } catch (e) {
                        log('Error clearing Caches: ' + e.message, 'error');
                    }
                }

                log('Reset complete. Please reload the problematic page.', 'success');
            }

            // Auto-run on load for convenience
            window.onload = resetEverything;
        </script>
    </body>

    </html>
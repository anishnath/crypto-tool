/**
 * Record algorithm visualization steps as an animated GIF.
 */
(function (global) {
    'use strict';

    var MAX_FRAMES = 250;
    var GIF_QUALITY = 10;
    var HTML2CANVAS_CDNS = [
        'https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js',
        'https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js'
    ];

    var gifJsLoaded = false;
    var workerBlobUrl = null;
    var html2canvasFn = null;
    var recording = false;
    var assetBaseCache = null;

    // Same-origin /modern/js/vendor/ path, derived from this script's own <src>
    // (avoids any dependency on JSP-injected globals or external CDNs).
    function assetBase() {
        if (assetBaseCache) return assetBaseCache;
        var s = document.querySelector('script[src*="oc-viz-recorder.js"]');
        if (s && s.src) {
            assetBaseCache = s.src.replace(/viz\/oc-viz-recorder\.js.*$/, 'vendor/');
        } else {
            assetBaseCache = 'modern/js/vendor/';
        }
        return assetBaseCache;
    }

    function getHtml2CanvasFn() {
        if (typeof html2canvasFn === 'function') return html2canvasFn;
        var g = global.html2canvas;
        if (typeof g === 'function') return g;
        if (g && typeof g.default === 'function') return g.default;
        return null;
    }

    // Monaco's AMD loader defines a global `define` (with .amd). gif.js / html2canvas are
    // UMD: they'd register as anonymous AMD modules instead of setting window.GIF /
    // window.html2canvas — which both breaks the global AND throws "Can only have one
    // anonymous define call per script file". Suppress `define` while a UMD script runs so
    // it takes the browser-global branch. Ref-counted so concurrent loads don't race.
    var amdDepth = 0;
    var amdSavedDefine;
    function suppressAmd() {
        if (amdDepth++ === 0) {
            amdSavedDefine = global.define;
            if (typeof global.define !== 'undefined') {
                try { global.define = undefined; } catch (e) { /* ignore */ }
            }
        }
    }
    function restoreAmd() {
        if (--amdDepth <= 0) {
            amdDepth = 0;
            if (typeof amdSavedDefine !== 'undefined') {
                try { global.define = amdSavedDefine; } catch (e) { /* ignore */ }
            }
        }
    }

    function loadScript(src) {
        return new Promise(function (resolve, reject) {
            var s = document.createElement('script');
            s.src = src;
            s.async = true;
            // No crossOrigin: same-origin vendor files don't need it, and setting it on a
            // CDN script can fail when a non-CORS copy is already cached.
            suppressAmd();
            s.onload = function () { restoreAmd(); resolve(); };
            s.onerror = function () { restoreAmd(); reject(new Error('Failed to load ' + src)); };
            document.head.appendChild(s);
        });
    }

    function loadHtml2CanvasFromScript(cdnIndex) {
        cdnIndex = cdnIndex || 0;
        if (cdnIndex >= HTML2CANVAS_CDNS.length) {
            return Promise.reject(new Error('Failed to load html2canvas from CDN'));
        }
        return loadScript(HTML2CANVAS_CDNS[cdnIndex]).then(function () {
            var fn = getHtml2CanvasFn();
            if (fn) {
                html2canvasFn = fn;
                return fn;
            }
            return loadHtml2CanvasFromScript(cdnIndex + 1);
        }).catch(function (err) {
            if (cdnIndex + 1 < HTML2CANVAS_CDNS.length) {
                return loadHtml2CanvasFromScript(cdnIndex + 1);
            }
            return Promise.reject(err);
        });
    }

    function loadHtml2CanvasEsm() {
        return import('https://esm.sh/html2canvas@1.4.1').then(function (mod) {
            var fn = mod.default || mod.html2canvas || mod;
            if (typeof fn !== 'function') {
                throw new Error('html2canvas ESM export is not a function');
            }
            html2canvasFn = fn;
            global.html2canvas = fn;
            return fn;
        });
    }

    function loadHtml2Canvas() {
        var existing = getHtml2CanvasFn();
        if (existing) {
            html2canvasFn = existing;
            return Promise.resolve(existing);
        }
        // Local vendor copy first; fall back to CDN / ESM only if it's missing.
        return loadScript(assetBase() + 'html2canvas.min.js').then(function () {
            var fn = getHtml2CanvasFn();
            if (fn) { html2canvasFn = fn; return fn; }
            throw new Error('local html2canvas missing');
        }).catch(function () {
            return loadHtml2CanvasFromScript(0);
        }).catch(function () {
            return loadHtml2CanvasEsm();
        }).then(function (fn) {
            if (typeof fn !== 'function') {
                throw new Error('html2canvas is not available after load');
            }
            return fn;
        });
    }

    function loadGifJs() {
        if (gifJsLoaded && workerBlobUrl) {
            return Promise.resolve(global.GIF);
        }
        // Local vendor copy; the worker is loaded directly as a same-origin URL
        // (no fetch+blob needed, which removes a common failure point).
        return loadScript(assetBase() + 'gif.js').then(function () {
            if (typeof global.GIF !== 'function') {
                throw new Error('GIF encoder failed to load');
            }
            gifJsLoaded = true;
            workerBlobUrl = assetBase() + 'gif.worker.js';
            return global.GIF;
        });
    }

    function wait(ms) {
        return new Promise(function (resolve) { setTimeout(resolve, ms); });
    }

    function pickStepIndices(total) {
        if (total <= 0) return [];
        if (total <= MAX_FRAMES) {
            var all = [];
            for (var i = 0; i < total; i++) all.push(i);
            return all;
        }
        var indices = [];
        for (var j = 0; j < MAX_FRAMES; j++) {
            indices.push(Math.floor(j * (total - 1) / (MAX_FRAMES - 1)));
        }
        return indices;
    }

    // Source-URL badge baked into every frame, so a shared GIF shows where it came from.
    function drawWatermark(ctx, w, h, brand) {
        var url = brand || '8gwifi.org';
        var domain = url.split('/')[0];
        var rest = url.slice(domain.length);
        ctx.save();
        var fs = Math.max(13, Math.round(h * 0.024));
        ctx.font = '600 ' + fs + 'px ui-monospace, SFMono-Regular, Menlo, Monaco, monospace';
        var padX = Math.round(fs * 0.7);
        var padY = Math.round(fs * 0.5);
        var tw = ctx.measureText(url).width;
        var bw = tw + padX * 2;
        var bh = fs + padY * 2;
        var bx = w - bw - Math.round(fs * 0.6);
        var by = h - bh - Math.round(fs * 0.6);
        ctx.fillStyle = 'rgba(15, 15, 20, 0.78)';
        if (ctx.roundRect) {
            ctx.beginPath();
            ctx.roundRect(bx, by, bw, bh, Math.round(bh * 0.3));
            ctx.fill();
        } else {
            ctx.fillRect(bx, by, bw, bh);
        }
        ctx.textAlign = 'left';
        ctx.textBaseline = 'middle';
        var ty = by + bh / 2;
        ctx.fillStyle = '#a5b4fc';            // brand domain
        ctx.fillText(domain, bx + padX, ty);
        ctx.fillStyle = '#e5e7eb';            // /online-…-compiler path
        ctx.fillText(rest, bx + padX + ctx.measureText(domain).width, ty);
        ctx.restore();
    }

    function captureElement(h2c, el, brand) {
        if (typeof h2c !== 'function') {
            return Promise.reject(new Error('html2canvas is not a function'));
        }
        return h2c(el, {
            scale: 2,
            backgroundColor: '#1a1a1a',
            useCORS: true,
            logging: false
        }).then(function (canvas) {
            var ctx = canvas.getContext('2d');
            drawWatermark(ctx, canvas.width, canvas.height, brand);
            return canvas;
        });
    }

    /**
     * @param {object} opts
     * @param {HTMLElement} opts.captureEl - DOM root to snapshot (step card + stage)
     * @param {object} opts.player - OcViz player instance
     * @param {number} opts.stepCount
     * @param {function(string|null)} opts.onStatus
     * @param {string} [opts.filename]
     */
    function recordGif(opts) {
        if (recording) return Promise.resolve();
        if (!opts || !opts.captureEl || !opts.player) {
            return Promise.reject(new Error('Nothing to record.'));
        }
        var stepCount = opts.stepCount || opts.player.getCount();
        if (!stepCount) {
            return Promise.reject(new Error('Run Visualize first — no steps to record.'));
        }

        recording = true;
        var onStatus = opts.onStatus || function () {};
        var frameDelay = typeof opts.frameDelayMs === 'number'
            ? opts.frameDelayMs
            : (opts.player.getSpeedMs ? opts.player.getSpeedMs() : 300);

        onStatus('Loading encoder…');

        return Promise.all([loadGifJs(), loadHtml2Canvas()]).then(function (results) {
            var GIF = results[0];
            var h2c = results[1];
            if (typeof h2c !== 'function') {
                throw new Error('html2canvas failed to load');
            }
            if (typeof GIF !== 'function') {
                throw new Error('GIF encoder failed to load');
            }
            opts.player.pause();
            switchModalTabSafe(opts);
            onStatus('Capturing frames…');

            var indices = pickStepIndices(stepCount);
            if (stepCount > MAX_FRAMES) {
                onStatus('Capturing frames… (' + indices.length + ' sampled from ' + stepCount + ' steps)');
            }

            var frames = [];
            var chain = Promise.resolve();
            indices.forEach(function (idx, i) {
                chain = chain.then(function () {
                    opts.player.goTo(idx);
                    return wait(80).then(function () {
                        return captureElement(h2c, opts.captureEl, opts.brand);
                    }).then(function (canvas) {
                        frames.push(canvas);
                        onStatus('Capturing frames… ' + (i + 1) + ' / ' + indices.length);
                    });
                });
            });

            return chain.then(function () {
                if (!frames.length) {
                    throw new Error('No frames captured.');
                }
                onStatus('Encoding GIF… (' + frames.length + ' frames)');

                var w = frames[0].width;
                var h = frames[0].height;
                var gif = new GIF({
                    workers: 2,
                    quality: GIF_QUALITY,
                    width: w,
                    height: h,
                    workerScript: workerBlobUrl
                });

                frames.forEach(function (frame, fi) {
                    var delay = fi === frames.length - 1 ? Math.max(frameDelay, 600) : frameDelay;
                    gif.addFrame(frame, { delay: delay, copy: true });
                });

                return new Promise(function (resolve, reject) {
                    gif.on('progress', function (p) {
                        onStatus('Encoding GIF… ' + Math.round(p * 100) + '%');
                    });
                    gif.on('finished', function (blob) {
                        var url = URL.createObjectURL(blob);
                        var a = document.createElement('a');
                        a.href = url;
                        a.download = opts.filename || ('algorithm-viz-' + Date.now() + '.gif');
                        document.body.appendChild(a);
                        a.click();
                        a.remove();
                        setTimeout(function () { URL.revokeObjectURL(url); }, 2000);
                        resolve(blob);
                    });
                    gif.on('abort', function () { reject(new Error('GIF encoding aborted')); });
                    gif.render();
                });
            });
        }).finally(function () {
            recording = false;
            onStatus(null);
        });
    }

    function switchModalTabSafe(opts) {
        if (typeof opts.ensureStageTab === 'function') {
            opts.ensureStageTab();
        }
    }

    function isRecording() {
        return recording;
    }

    global.OcViz = global.OcViz || {};
    global.OcViz.recordGif = recordGif;
    global.OcViz.isVizRecording = isRecording;
}(typeof window !== 'undefined' ? window : this));

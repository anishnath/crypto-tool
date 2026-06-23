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

    function getHtml2CanvasFn() {
        if (typeof html2canvasFn === 'function') return html2canvasFn;
        var g = global.html2canvas;
        if (typeof g === 'function') return g;
        if (g && typeof g.default === 'function') return g.default;
        return null;
    }

    function loadScript(src) {
        return new Promise(function (resolve, reject) {
            var s = document.createElement('script');
            s.src = src;
            s.async = true;
            s.crossOrigin = 'anonymous';
            s.onload = function () { resolve(); };
            s.onerror = function () { reject(new Error('Failed to load ' + src)); };
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
        return loadHtml2CanvasFromScript(0).catch(function () {
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
        return loadScript('https://cdn.jsdelivr.net/npm/gif.js@0.2.0/dist/gif.js').then(function () {
            gifJsLoaded = true;
            return fetch('https://cdn.jsdelivr.net/npm/gif.js@0.2.0/dist/gif.worker.js')
                .then(function (r) { return r.blob(); })
                .then(function (blob) {
                    workerBlobUrl = URL.createObjectURL(blob);
                    return global.GIF;
                });
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

    function drawWatermark(ctx, w, h) {
        var mark = '8gwifi.org';
        ctx.save();
        ctx.font = '500 11px ui-monospace, monospace';
        ctx.textAlign = 'right';
        ctx.textBaseline = 'bottom';
        var tw = ctx.measureText(mark).width;
        ctx.fillStyle = 'rgba(0,0,0,0.45)';
        ctx.fillRect(w - tw - 14, h - 20, tw + 10, 16);
        ctx.fillStyle = '#e5e7eb';
        ctx.fillText(mark, w - 9, h - 7);
        ctx.restore();
    }

    function captureElement(h2c, el) {
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
            drawWatermark(ctx, canvas.width, canvas.height);
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
                        return captureElement(h2c, opts.captureEl);
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

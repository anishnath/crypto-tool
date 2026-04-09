/* NN Animation GIF Export
   Captures SVG animation frames and compiles into animated GIF
   Uses gif.js library (loaded from CDN on demand) */

'use strict';

var NNGifExport = (function() {

    var gifJsLoaded = false;
    var workerBlobUrl = null;  // blob URL for the worker (avoids CORS)
    var recording = false;
    var frames = [];
    var captureInterval = null;
    var canvasEl = null;

    var FPS = 15;
    var QUALITY = 10; // gif.js quality: 1 = best, 20 = fastest
    var MAX_FRAMES = 300; // safety cap (~20 seconds at 15fps)

    function loadGifJs(callback) {
        if (gifJsLoaded && workerBlobUrl) { callback(); return; }

        var s = document.createElement('script');
        s.src = 'https://cdn.jsdelivr.net/npm/gif.js@0.2.0/dist/gif.js';
        s.onload = function() {
            gifJsLoaded = true;
            // Fetch worker script as blob to avoid CORS Worker restriction
            fetch('https://cdn.jsdelivr.net/npm/gif.js@0.2.0/dist/gif.worker.js')
                .then(function(r) { return r.blob(); })
                .then(function(blob) {
                    workerBlobUrl = URL.createObjectURL(blob);
                    callback();
                })
                .catch(function() {
                    alert('Failed to load GIF worker. Check your connection.');
                });
        };
        s.onerror = function() {
            alert('Failed to load GIF library. Check your connection.');
        };
        document.head.appendChild(s);
    }

    function startRecording(containerEl) {
        if (recording) return;

        var svgEl = containerEl.querySelector('svg');
        var canvasTarget = containerEl.querySelector('canvas');

        if (!svgEl && !canvasTarget) {
            alert('No visualization to record.');
            return;
        }

        recording = true;
        frames = [];
        updateRecordButton(true);

        if (canvasTarget) {
            // Three.js canvas — direct frame capture
            captureInterval = setInterval(function() {
                if (!recording || frames.length >= MAX_FRAMES) {
                    stopRecording(containerEl);
                    return;
                }
                // Clone canvas data + watermark
                var tempCanvas = document.createElement('canvas');
                tempCanvas.width = canvasTarget.width;
                tempCanvas.height = canvasTarget.height;
                var ctx = tempCanvas.getContext('2d');
                ctx.drawImage(canvasTarget, 0, 0);
                NNExport.addCanvasWatermark(ctx, tempCanvas.width, tempCanvas.height);
                frames.push(tempCanvas);
            }, 1000 / FPS);
        } else {
            // SVG — render to canvas each frame
            var w = svgEl.clientWidth || svgEl.getAttribute('width') || 800;
            var h = svgEl.clientHeight || svgEl.getAttribute('height') || 600;

            canvasEl = document.createElement('canvas');
            canvasEl.width = w;
            canvasEl.height = h;

            captureInterval = setInterval(function() {
                if (!recording || frames.length >= MAX_FRAMES) {
                    stopRecording(containerEl);
                    return;
                }
                captureSVGFrame(svgEl, canvasEl, function(frameCanvas) {
                    if (frameCanvas) frames.push(frameCanvas);
                });
            }, 1000 / FPS);
        }
    }

    function captureSVGFrame(svgEl, canvas, callback) {
        var serializer = new XMLSerializer();
        var clone = svgEl.cloneNode(true);
        clone.setAttribute('xmlns', 'http://www.w3.org/2000/svg');

        // Inline key styles for correct rendering
        var allEls = clone.querySelectorAll('*');
        var origEls = svgEl.querySelectorAll('*');
        for (var i = 0; i < Math.min(allEls.length, origEls.length); i++) {
            var cs = window.getComputedStyle(origEls[i]);
            var style = '';
            ['fill', 'stroke', 'stroke-width', 'stroke-opacity', 'opacity', 'r', 'cx', 'cy', 'transform'].forEach(function(prop) {
                var val = cs.getPropertyValue(prop);
                if (val && val !== 'none' && val !== 'auto') style += prop + ':' + val + ';';
            });
            if (style) allEls[i].setAttribute('style', (allEls[i].getAttribute('style') || '') + style);
        }

        var data = serializer.serializeToString(clone);
        var blob = new Blob([data], {type: 'image/svg+xml;charset=utf-8'});
        var url = URL.createObjectURL(blob);

        var img = new Image();
        img.onload = function() {
            var tempCanvas = document.createElement('canvas');
            tempCanvas.width = canvas.width;
            tempCanvas.height = canvas.height;
            var ctx = tempCanvas.getContext('2d');
            ctx.fillStyle = '#ffffff';
            ctx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);
            ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
            NNExport.addCanvasWatermark(ctx, tempCanvas.width, tempCanvas.height);
            URL.revokeObjectURL(url);
            callback(tempCanvas);
        };
        img.onerror = function() {
            URL.revokeObjectURL(url);
            callback(null);
        };
        img.src = url;
    }

    function stopRecording(containerEl) {
        recording = false;
        if (captureInterval) { clearInterval(captureInterval); captureInterval = null; }
        updateRecordButton(false);

        if (frames.length === 0) {
            alert('No frames captured. Play an animation first, then record.');
            return;
        }

        compileGif(containerEl);
    }

    function compileGif(containerEl) {
        var statusEl = document.getElementById('nn-gif-status');
        if (statusEl) {
            statusEl.style.display = 'block';
            statusEl.textContent = 'Compiling GIF... (' + frames.length + ' frames)';
        }

        loadGifJs(function() {
            var w = frames[0].width;
            var h = frames[0].height;

            var gif = new GIF({
                workers: 2,
                quality: QUALITY,
                width: w,
                height: h,
                workerScript: workerBlobUrl
            });

            frames.forEach(function(frame) {
                gif.addFrame(frame, {delay: Math.round(1000 / FPS), copy: true});
            });

            gif.on('finished', function(blob) {
                if (statusEl) statusEl.style.display = 'none';
                var url = URL.createObjectURL(blob);
                var a = document.createElement('a');
                a.href = url;
                a.download = NNExport.makeFilename('nn-anim', 'gif');
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
                frames = [];
            });

            gif.on('progress', function(p) {
                if (statusEl) {
                    statusEl.textContent = 'Compiling GIF... ' + Math.round(p * 100) + '%';
                }
            });

            gif.render();
        });
    }

    function toggle(containerEl) {
        if (recording) {
            stopRecording(containerEl);
        } else {
            startRecording(containerEl);
        }
    }

    function isRecording() { return recording; }

    function updateRecordButton(isRec) {
        var btn = document.getElementById('nn-record-btn');
        if (!btn) return;
        if (isRec) {
            btn.innerHTML = '<span class="nn-rec-dot nn-rec-active"></span> Stop Recording';
            btn.classList.add('nn-recording');
        } else {
            btn.innerHTML = '<span class="nn-rec-dot"></span> Record GIF';
            btn.classList.remove('nn-recording');
        }
    }

    return {
        toggle: toggle,
        isRecording: isRecording
    };

})();

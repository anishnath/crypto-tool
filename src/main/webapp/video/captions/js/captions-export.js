/**
 * Auto-Captions export module (ffmpeg.wasm burn-in).
 *
 * Exposes:
 *   window.CaptionExport(opts)        – start a render
 *   window.CaptionExportCancel()      – cancel the running render
 *
 * opts:
 *   {
 *     file:    File,                  – original video (stays local)
 *     chunks:  [{start,end,words[]}], – caption lines
 *     words:   [...]                  – full flat word list (unused today, kept for future)
 *     style:   {font,fontSize,color,hlColor,outline,outlineWidth,shadow,uppercase,maxWords,position,highlight},
 *     video:   HTMLVideoElement,       – source of intrinsic width/height
 *     ui: {
 *       setState(name),                – 'empty'|'loading'|'editor'|'exporting'
 *       host:    HTMLElement,          – AIProgressBar mount
 *       meta:    HTMLElement,          – small status text under the bar
 *       error:   HTMLElement,          – error banner
 *       onDone:  fn()                  – called after the MP4 download triggers
 *     }
 *   }
 *
 * ffmpeg.wasm is loaded from /js/ffmpeg/ (already bundled for video-trim.jsp).
 * We reuse the exact same init pattern as video_code.js for consistency.
 */
(function () {
    'use strict';

    var ffmpeg = null;          // the created FFmpeg instance
    var running = false;
    var cancelRequested = false;
    var progressBar = null;
    var fontBytes = null;       // cached DejaVuSans.ttf bytes

    // libass inside ffmpeg.wasm has NO system fonts and no fontconfig. If the
    // ASS script names a font the filter can't locate, libass silently skips
    // rendering — captions show up in the browser preview (uses the OS's own
    // font fallback) but the exported MP4 is blank. The fix: bundle DejaVu Sans
    // (shipped at /fonts/DejaVuSans.ttf for video-trim.jsp watermarks) into
    // the ffmpeg virtual FS before each render and point libass at it.
    var FONT_FILE = 'DejaVuSans.ttf';
    var ASS_FONT_NAME = 'DejaVu Sans';

    // Font sources tried in order. CDN first so we don't burn server bandwidth
    // on an 800 KB TTF every first-time visitor. cdnjs and jsDelivr both send
    // `Cross-Origin-Resource-Policy: cross-origin`, which is required because
    // this page is served with `COEP: require-corp`.
    //
    // Same-origin is kept as a safety net for air-gapped deployments or if a
    // CDN is blocked (corporate proxies, country-level restrictions).
    var FONT_SOURCES = [
        'https://cdnjs.cloudflare.com/ajax/libs/dejavu/2.37/ttf/DejaVuSans.ttf',
        'https://cdn.jsdelivr.net/gh/dejavu-fonts/dejavu-fonts-ttf@2.37/ttf/DejaVuSans.ttf'
    ];
    function sameOriginFontUrl() {
        var ctxMeta = document.querySelector('meta[name="ctx"]');
        var ctx = ctxMeta ? (ctxMeta.getAttribute('content') || '') : '';
        if (ctx && ctx.slice(-1) !== '/') ctx += '/';
        if (!ctx) ctx = '/';
        return window.location.origin + ctx + 'fonts/DejaVuSans.ttf';
    }

    function fetchFontBytes() {
        if (fontBytes) return Promise.resolve(fontBytes);
        var urls = FONT_SOURCES.concat([sameOriginFontUrl()]);
        var tryNext = function (i) {
            if (i >= urls.length) {
                return Promise.reject(new Error('Couldn\'t load the caption style. Check your internet connection and try again.'));
            }
            return fetch(urls[i], { mode: 'cors', cache: 'force-cache' })
                .then(function (r) {
                    if (!r.ok) throw new Error('HTTP ' + r.status);
                    return r.arrayBuffer();
                })
                .catch(function (err) {
                    console.warn('[captions] font source failed:', urls[i],
                                 err && err.message ? err.message : err);
                    return tryNext(i + 1);
                });
        };
        return tryNext(0).then(function (buf) {
            fontBytes = new Uint8Array(buf);
            return fontBytes;
        });
    }

    // ffmpeg.wasm's internal Web Worker resolves relative URLs against a blob
    // origin, which falls back to file:// (blocked by the browser). We must
    // hand it a fully-qualified absolute URL.
    //
    // Using the <meta name="ctx"> tag (server-authoritative) is safer than
    // parsing location.pathname: the pathname heuristic in video_code.js only
    // works for depth-1 URLs. Our page is at /video/captions/ (depth 2+).
    function resolveCorePath() {
        var ctxMeta = document.querySelector('meta[name="ctx"]');
        var ctx = ctxMeta ? (ctxMeta.getAttribute('content') || '') : '';
        if (ctx && ctx.slice(-1) !== '/') ctx += '/';
        if (!ctx) ctx = '/';
        return window.location.origin + ctx + 'js/ffmpeg/ffmpeg-core.js';
    }

    // ── Lazy-load + initialise ffmpeg.wasm ───────────────────────────
    function initFFmpeg(onProgress) {
        if (ffmpeg) return Promise.resolve(ffmpeg);
        if (typeof FFmpeg === 'undefined' || !FFmpeg.createFFmpeg) {
            return Promise.reject(new Error('Caption engine failed to load. Please refresh the page and try again.'));
        }
        onProgress && onProgress('Warming up the caption engine…');
        ffmpeg = FFmpeg.createFFmpeg({
            corePath: resolveCorePath(),
            log: false,
            progress: function (p) {
                // p.ratio ∈ [0,1]; we'll translate that to the progress bar
                if (progressBar && typeof p.ratio === 'number' && p.ratio > 0 && p.ratio <= 1) {
                    progressBar.setExternal && progressBar.setExternal(p.ratio);
                    // AIProgressBar doesn't expose setExternal by default — fall back by
                    // setting width manually via its internal .aipb-fill element.
                    var fill = progressBar.el && progressBar.el.querySelector('.aipb-fill');
                    if (fill) { fill.style.width = Math.round(p.ratio * 100) + '%'; }
                }
            }
        });
        return ffmpeg.load().then(function () { return ffmpeg; });
    }

    // ── ASS script generation ────────────────────────────────────────
    // We output an Advanced SubStation Alpha (.ass) file. libass (bundled with
    // ffmpeg.wasm) handles per-word karaoke timing via \k tags and supports
    // coloured highlights. Keeping the script format identical to what pro
    // video tools use means the exported MP4 matches our canvas preview
    // pixel-for-pixel in structure (layout, timing, word grouping).
    function buildAss(chunks, style, videoW, videoH) {
        // Always force the bundled font — style.font may request "Anton" /
        // "Inter" etc. which libass cannot resolve inside the wasm sandbox.
        // Stylistic differences (size, weight, case, colour, highlight) still
        // come through via the ASS style block and dialogue text.
        var fontName = ASS_FONT_NAME;
        var primary = toAssColor(style.color);
        var secondary = toAssColor(style.hlColor || style.color);
        var outline = toAssColor(style.outline || '#000000');

        // Alignment: 2 = bottom-centre, 5 = top-centre, 8 = middle-centre
        var align = style.position === 'top' ? 8 : (style.position === 'middle' ? 5 : 2);
        var fontSizeAss = Math.max(20, Math.round(style.fontSize * videoH / 720));
        var outlineW = style.outlineWidth || 0;
        var bold = Number(style.weight) >= 700 ? -1 : 0;

        var header = [
            '[Script Info]',
            'ScriptType: v4.00+',
            'PlayResX: ' + videoW,
            'PlayResY: ' + videoH,
            'ScaledBorderAndShadow: yes',
            '',
            '[V4+ Styles]',
            'Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding',
            'Style: Default,' + fontName + ',' + fontSizeAss + ',' + primary + ',' + secondary + ',' + outline + ',&H80000000,' + bold + ',0,0,0,100,100,0,0,1,' + outlineW + ',' + (style.shadow ? 1 : 0) + ',' + align + ',40,40,60,1',
            '',
            '[Events]',
            'Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text'
        ].join('\n') + '\n';

        var events = chunks.map(function (chunk) {
            return renderChunkEvent(chunk, style);
        }).join('\n');

        return header + events + '\n';
    }

    // One ASS dialogue event per chunk.  With karaoke highlight we emit \k tags
    // that switch the secondary colour to the primary word-by-word.
    function renderChunkEvent(chunk, style) {
        var start = assTime(chunk.start);
        var end   = assTime(chunk.end + 0.05);
        var textCase = style.uppercase ? function (s) { return s.toUpperCase(); } : function (s) { return s; };

        var payload;
        if (style.highlight === 'off') {
            payload = chunk.words.map(function (w) { return textCase((w.word || '').trim()); }).join(' ');
        } else if (style.highlight === 'karaoke' || style.highlight === 'pop') {
            // Both modes use \kf (karaoke fill) timing so the highlight colour
            // sweeps across each word. libass renders this cleanly.
            payload = chunk.words.map(function (w) {
                var dur = Math.max(1, Math.round((w.end - w.start) * 100)); // centiseconds
                return '{\\kf' + dur + '}' + textCase((w.word || '').trim());
            }).join(' ');
        } else {
            payload = chunk.words.map(function (w) { return textCase((w.word || '').trim()); }).join(' ');
        }

        return 'Dialogue: 0,' + start + ',' + end + ',Default,,0,0,0,,' + payload;
    }

    // 0:00:00.00 format required by ASS
    function assTime(sec) {
        if (sec < 0) sec = 0;
        var h = Math.floor(sec / 3600);
        var m = Math.floor((sec % 3600) / 60);
        var s = Math.floor(sec % 60);
        var cs = Math.floor((sec - Math.floor(sec)) * 100);
        return h + ':' + pad(m) + ':' + pad(s) + '.' + pad(cs);
    }
    function pad(n) { return (n < 10 ? '0' : '') + n; }

    // '#RRGGBB' → '&HAABBGGRR' (ASS uses AABBGGRR)
    function toAssColor(hex) {
        if (!hex) return '&H00FFFFFF';
        hex = hex.replace('#', '');
        if (hex.length === 3) hex = hex[0]+hex[0]+hex[1]+hex[1]+hex[2]+hex[2];
        var r = hex.slice(0, 2), g = hex.slice(2, 4), b = hex.slice(4, 6);
        return ('&H00' + b + g + r).toUpperCase();
    }

    function primaryFont(fontStack) {
        // Pull the first quoted family name, e.g. "Anton" from `"Anton", "Bebas Neue", ...`
        var m = fontStack.match(/"([^"]+)"/);
        return m ? m[1] : 'Arial';
    }

    // ── Main export function exposed on window ───────────────────────
    window.CaptionExport = function (opts) {
        if (running) return;
        running = true;
        cancelRequested = false;

        var file  = opts.file;
        var chunks = opts.chunks || [];
        var style  = opts.style;
        var video  = opts.video;
        var ui     = opts.ui || {};

        if (!file || !chunks.length) {
            showErr(ui.error, 'Nothing to export yet. Upload a video first.');
            running = false;
            return;
        }

        ui.setState && ui.setState('exporting');
        clearErr(ui.error);
        metaText(ui.meta, 'Getting ready…');

        startExportProgress(ui.host);

        // 1. Read the video into the ffmpeg virtual FS.
        // 2. Build an ASS script from chunks + style.
        // 3. Run the burn-in command.
        // 4. Pull the output MP4 as a Blob and download it.
        var inputName  = 'input.' + (file.name.split('.').pop() || 'mp4');
        var outputName = 'output.mp4';
        var assName    = 'captions.ass';

        var videoW = video.videoWidth  || 1280;
        var videoH = video.videoHeight || 720;

        initFFmpeg(function (msg) { metaText(ui.meta, msg); })
            .then(function () {
                if (cancelRequested) throw new Error('Cancelled');
                metaText(ui.meta, 'Preparing caption style…');
                return fetchFontBytes();
            })
            .then(function (fontBuf) {
                // Write the font into the ffmpeg virtual FS so libass can find it.
                // The filename matches the font's internal family name so
                // `fontsdir=.` + `Fontname: DejaVu Sans` resolve correctly.
                try { ffmpeg.FS('writeFile', FONT_FILE, fontBuf); } catch (e) {}
                if (cancelRequested) throw new Error('Cancelled');
                metaText(ui.meta, 'Reading your video…');
                return file.arrayBuffer();
            })
            .then(function (buf) {
                ffmpeg.FS('writeFile', inputName, new Uint8Array(buf));
                var ass = buildAss(chunks, style, videoW, videoH);
                ffmpeg.FS('writeFile', assName, new TextEncoder().encode(ass));
                metaText(ui.meta, 'Adding captions to your video…');
                if (cancelRequested) throw new Error('Cancelled');
                // fontsdir=. tells libass to look in the ffmpeg FS root (where
                // we wrote DejaVuSans.ttf) so the ASS style's Fontname resolves.
                // -c:a aac (re-encode) is safer than -c:a copy — some source
                // codecs (Opus in WebM) don't drop into MP4 containers cleanly.
                return ffmpeg.run(
                    '-i', inputName,
                    '-vf', 'subtitles=' + assName + ':fontsdir=.',
                    '-c:v', 'libx264',
                    '-preset', 'ultrafast',
                    '-crf', '23',
                    '-c:a', 'aac',
                    '-b:a', '128k',
                    '-movflags', '+faststart',
                    outputName
                );
            })
            .then(function () {
                if (cancelRequested) throw new Error('Cancelled');
                var data = ffmpeg.FS('readFile', outputName);
                var blob = new Blob([data.buffer], { type: 'video/mp4' });
                // Clean up FS to free memory for the next run. Keep the font
                // in place — fontBytes stays cached so we don't re-fetch it.
                try { ffmpeg.FS('unlink', inputName); } catch (e) {}
                try { ffmpeg.FS('unlink', outputName); } catch (e) {}
                try { ffmpeg.FS('unlink', assName); } catch (e) {}
                stopExportProgress(true);
                triggerDownload(blob, file.name);
                metaText(ui.meta, 'All done — your download should be starting now.');
                setTimeout(function () { ui.onDone && ui.onDone(); running = false; }, 1500);
            })
            .catch(function (err) {
                stopExportProgress(false);
                if (err && err.message === 'Cancelled') {
                    metaText(ui.meta, 'Cancelled.');
                } else {
                    showErr(ui.error, (err && err.message) ? err.message : String(err));
                    metaText(ui.meta, '');
                }
                running = false;
            });
    };

    window.CaptionExportCancel = function () {
        cancelRequested = true;
        if (ffmpeg && typeof ffmpeg.exit === 'function') {
            try { ffmpeg.exit(); } catch (e) {}
            ffmpeg = null; // next export re-initialises
        }
    };

    // ── Helpers ──────────────────────────────────────────────────────
    // ui.error may be either a DOM node (inline banner, old shape) or an
    // object with a `.show(msg)` method (new modal-backed shape from
    // captions.js). Supporting both keeps this module decoupled.
    function showErr(target, msg) {
        if (!target) return;
        if (typeof target.show === 'function') { target.show(msg); return; }
        target.textContent = msg;
        target.classList.add('active');
    }
    function clearErr(target) {
        if (!target) return;
        if (typeof target.show === 'function') return;  // modal hides itself on dismiss
        target.textContent = '';
        target.classList.remove('active');
    }
    function metaText(node, msg) { if (node) node.textContent = msg || ''; }

    function startExportProgress(host) {
        if (!host || typeof window.AIProgressBar === 'undefined') return;
        // The ffmpeg progress callback writes directly to .aipb-fill (see initFFmpeg).
        // We still mount the bar so the DOM chrome renders (label row, time, etc.).
        progressBar = window.AIProgressBar.attach(host, {
            estimatedMs: 180000, // 3 min guess; ffmpeg overrides .aipb-fill width live
            phases: [
                { pct: 5,  ms: 1000,   label: 'Getting ready...' },
                { pct: 15, ms: 6000,   label: 'Reading your video...' },
                { pct: 30, ms: 20000,  label: 'Adding captions...' },
                { pct: 80, ms: 120000, label: 'Saving your video...' },
                { pct: 92, ms: 170000, label: 'Almost done...' }
            ]
        });
        progressBar.start();
    }
    function stopExportProgress(success) { if (progressBar) progressBar.stop(success); }

    function triggerDownload(blob, originalName) {
        var base = (originalName || 'video').replace(/\.[^.]+$/, '');
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = base + '-captioned.mp4';
        document.body.appendChild(a);
        a.click();
        setTimeout(function () { URL.revokeObjectURL(url); a.remove(); }, 500);
    }
})();

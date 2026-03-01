/**
 * Steganography Tool - Core Module
 * State management, UI orchestration, event binding
 */
(function() {
'use strict';

var R = window.StegoRender;
var E = window.StegoEngine;
var IG = window.StegoImageGen;
var F = window.StegoForensic;

// State
var state = {
    mode: 'encode',
    encodeSubTab: 'message', // 'message' or 'file'
    encodeImageData: null,
    decodeImageData: null,
    analyzeImageData: null,
    encodeCanvas: null,
    decodeCanvas: null,
    analyzeCanvas: null,
    maxCapacity: 0,
    currentFile: null,
    embedFile: null, // file to embed (File object)
    embedFileBytes: null, // ArrayBuffer of file to embed
    lastBlobUrl: null,
    lastFileBlobUrl: null,
    extractedMessage: '',
    forensicResults: [],
    // Batch 1: Variable bit depth
    bitDepthMode: 'at',  // 'at' or 'with'
    bitDepth: 0,         // 0-7
    decodeBitDepthMode: 'at',
    decodeBitDepth: 0,
    // Batch 2: Compression is already handled via checkbox
    // Batch 3: Audio steganography
    medium: 'image',     // 'image' or 'audio'
    audioBuffer: null,
    audioFileName: null,
    decodeAudioBuffer: null,
    decodeAudioFileName: null,
    // Batch 4: Reed-Solomon
    rsEnabled: false,
    rsParityLevel: 1     // 1=low(16), 2=medium(32), 3=high(48)
};

/* ===== DOM Helpers ===== */
function $(id) { return document.getElementById(id); }

/* ===== Mode Switching ===== */
function switchMode(mode) {
    state.mode = mode;
    var modes = ['encode', 'decode', 'analyze'];
    var resultContent = $('sg-result-content');

    for (var i = 0; i < modes.length; i++) {
        var btn = $('sg-mode-' + modes[i]);
        var panel = $('sg-' + modes[i] + '-panel');
        if (btn) {
            if (modes[i] === mode) {
                btn.classList.add('sg-active');
            } else {
                btn.classList.remove('sg-active');
            }
        }
        if (panel) {
            if (modes[i] === mode) {
                panel.classList.add('sg-panel-active');
            } else {
                panel.classList.remove('sg-panel-active');
            }
        }
    }
    R.showEmpty(resultContent);
    updateToolbar();
}

/* ===== Encode Sub-Tab Switching ===== */
function switchEncodeSubTab(tab) {
    state.encodeSubTab = tab;
    var msgTab = $('sg-subtab-message');
    var fileTab = $('sg-subtab-file');
    var msgPanel = $('sg-encode-message-panel');
    var filePanel = $('sg-encode-file-panel');

    if (tab === 'message') {
        if (msgTab) msgTab.classList.add('sg-active');
        if (fileTab) fileTab.classList.remove('sg-active');
        if (msgPanel) msgPanel.style.display = 'block';
        if (filePanel) filePanel.style.display = 'none';
    } else {
        if (fileTab) fileTab.classList.add('sg-active');
        if (msgTab) msgTab.classList.remove('sg-active');
        if (filePanel) filePanel.style.display = 'block';
        if (msgPanel) msgPanel.style.display = 'none';
    }
}

/* ===== Image Processing ===== */
function processUploadedImage(file, target) {
    if (!file || !file.type.match('image.*')) {
        ToolUtils.showToast('Please select an image file (PNG, JPEG, or BMP)', 2500);
        return;
    }

    var reader = new FileReader();
    reader.onload = function(e) {
        var img = new Image();
        img.onload = function() {
            var canvas = document.createElement('canvas');
            canvas.width = img.width;
            canvas.height = img.height;
            var ctx = canvas.getContext('2d');
            ctx.drawImage(img, 0, 0);
            var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

            if (target === 'encode') {
                state.encodeCanvas = canvas;
                state.encodeImageData = imageData;
                state.currentFile = file;
                state.maxCapacity = E.calculateCapacity(img.width * img.height, state.bitDepthMode, state.bitDepth);
                showEncodePreview(file.name, img.width, img.height, canvas.toDataURL());
            } else if (target === 'analyze') {
                state.analyzeCanvas = canvas;
                state.analyzeImageData = imageData;
                showAnalyzePreview(file.name, img.width, img.height, canvas.toDataURL());
            } else {
                state.decodeCanvas = canvas;
                state.decodeImageData = imageData;
                showDecodePreview(file.name, img.width, img.height, canvas.toDataURL());
            }
        };
        img.src = e.target.result;
    };
    reader.readAsDataURL(file);
}

function showEncodePreview(filename, w, h, dataUrl) {
    var previewCanvas = $('sg-encode-preview-canvas');
    var previewImg = new Image();
    previewImg.onload = function() {
        previewCanvas.width = previewImg.width;
        previewCanvas.height = previewImg.height;
        previewCanvas.getContext('2d').drawImage(previewImg, 0, 0);
    };
    previewImg.src = dataUrl;

    $('sg-encode-image-info').innerHTML = R.renderImageInfo(filename, w, h, state.maxCapacity);
    $('sg-encode-source').classList.add('sg-hidden');
    $('sg-encode-preview').classList.add('sg-visible');
    $('sg-encode-btn').disabled = false;

    var meter = $('sg-capacity-container');
    meter.classList.add('sg-visible');
    updateCapacity();
}

function showDecodePreview(filename, w, h, dataUrl) {
    var previewCanvas = $('sg-decode-preview-canvas');
    var previewImg = new Image();
    previewImg.onload = function() {
        previewCanvas.width = previewImg.width;
        previewCanvas.height = previewImg.height;
        previewCanvas.getContext('2d').drawImage(previewImg, 0, 0);
    };
    previewImg.src = dataUrl;

    $('sg-decode-image-info').innerHTML = R.renderImageInfo(filename, w, h, null);
    $('sg-decode-source').classList.add('sg-hidden');
    $('sg-decode-preview').classList.add('sg-visible');
    $('sg-decode-password-section').style.display = 'block';
    $('sg-decode-btn').disabled = false;
    var forensicBtn = $('sg-forensic-btn');
    if (forensicBtn) forensicBtn.disabled = false;
}

function showAnalyzePreview(filename, w, h, dataUrl) {
    var previewCanvas = $('sg-analyze-preview-canvas');
    var previewImg = new Image();
    previewImg.onload = function() {
        previewCanvas.width = previewImg.width;
        previewCanvas.height = previewImg.height;
        previewCanvas.getContext('2d').drawImage(previewImg, 0, 0);
    };
    previewImg.src = dataUrl;

    $('sg-analyze-image-info').innerHTML = R.renderImageInfo(filename, w, h, null);
    $('sg-analyze-source').classList.add('sg-hidden');
    $('sg-analyze-preview').classList.add('sg-visible');
    $('sg-analyze-btn').disabled = false;
}

/* ===== Load Image from URL ===== */
function loadImageFromUrl(url, target) {
    url = (url || '').trim();
    if (!url) {
        ToolUtils.showToast('Please enter an image URL', 2500);
        return;
    }

    var errorEl = $(target === 'encode' ? 'sg-encode-url-error' : 'sg-decode-url-error');
    var fetchBtn = $(target === 'encode' ? 'sg-encode-url-btn' : 'sg-decode-url-btn');
    if (errorEl) { errorEl.textContent = ''; errorEl.classList.remove('sg-visible'); }
    if (fetchBtn) { fetchBtn.disabled = true; fetchBtn.textContent = 'Loading...'; }

    var img = new Image();
    img.crossOrigin = 'anonymous';

    img.onload = function() {
        var canvas = document.createElement('canvas');
        canvas.width = img.width;
        canvas.height = img.height;
        var ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0);

        try {
            var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        } catch (e) {
            if (errorEl) {
                errorEl.textContent = 'CORS blocked: the server does not allow cross-origin access to this image.';
                errorEl.classList.add('sg-visible');
            }
            if (fetchBtn) { fetchBtn.disabled = false; fetchBtn.textContent = 'Fetch'; }
            return;
        }

        var filename = url.split('/').pop().split('?')[0] || 'remote-image';

        if (target === 'encode') {
            state.encodeCanvas = canvas;
            state.encodeImageData = imageData;
            state.currentFile = null;
            state.maxCapacity = E.calculateCapacity(img.width * img.height, state.bitDepthMode, state.bitDepth);
            showEncodePreview(filename, img.width, img.height, canvas.toDataURL());
        } else {
            state.decodeCanvas = canvas;
            state.decodeImageData = imageData;
            showDecodePreview(filename, img.width, img.height, canvas.toDataURL());
        }

        if (fetchBtn) { fetchBtn.disabled = false; fetchBtn.textContent = 'Fetch'; }
    };

    img.onerror = function() {
        if (errorEl) {
            errorEl.textContent = 'Failed to load image. Check the URL and ensure it points to a valid image.';
            errorEl.classList.add('sg-visible');
        }
        if (fetchBtn) { fetchBtn.disabled = false; fetchBtn.textContent = 'Fetch'; }
    };

    img.src = url;
}

/* ===== Image Generation ===== */
function generateCoverImage(type) {
    var result = IG.generate(type, 800, 600);
    state.encodeCanvas = result.canvas;
    state.encodeImageData = result.imageData;
    state.maxCapacity = E.calculateCapacity(800 * 600, state.bitDepthMode, state.bitDepth);
    state.currentFile = null;

    // Highlight active card
    var cards = document.querySelectorAll('.sg-gen-card');
    for (var i = 0; i < cards.length; i++) {
        cards[i].classList.remove('sg-gen-active');
        if (cards[i].getAttribute('data-type') === type) {
            cards[i].classList.add('sg-gen-active');
        }
    }

    showEncodePreview('Generated (' + type + ')', 800, 600, result.dataUrl);
}

/* ===== Auto-Upscale Canvas ===== */
function upscaleCanvas(requiredBytes) {
    var dims = E.calculateRequiredDimensions(requiredBytes, state.encodeCanvas.width, state.encodeCanvas.height);
    if (dims.width === state.encodeCanvas.width && dims.height === state.encodeCanvas.height) {
        return; // already sufficient
    }
    var newCanvas = document.createElement('canvas');
    newCanvas.width = dims.width;
    newCanvas.height = dims.height;
    var ctx = newCanvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;
    ctx.drawImage(state.encodeCanvas, 0, 0, dims.width, dims.height);
    var newImageData = ctx.getImageData(0, 0, dims.width, dims.height);
    state.encodeCanvas = newCanvas;
    state.encodeImageData = newImageData;
    state.maxCapacity = E.calculateCapacity(dims.width * dims.height, state.bitDepthMode, state.bitDepth);
    ToolUtils.showToast('Cover image auto-scaled to ' + dims.width + 'x' + dims.height + ' to fit payload', 3000);
}

/* ===== Medium Switching ===== */
function switchMedium(medium) {
    state.medium = medium;
    var imgBtn = $('sg-medium-image');
    var audBtn = $('sg-medium-audio');
    if (imgBtn) imgBtn.classList.toggle('sg-active', medium === 'image');
    if (audBtn) audBtn.classList.toggle('sg-active', medium === 'audio');

    // Toggle image/audio panels visibility
    var imgPanels = document.querySelectorAll('.sg-image-only');
    var audPanels = document.querySelectorAll('.sg-audio-only');
    for (var i = 0; i < imgPanels.length; i++) imgPanels[i].style.display = medium === 'image' ? '' : 'none';
    for (var j = 0; j < audPanels.length; j++) audPanels[j].style.display = medium === 'audio' ? '' : 'none';
}

/* ===== Audio Processing ===== */
function processUploadedAudio(file, target) {
    if (!file) return;
    var A = window.StegoAudio;
    if (!A) { ToolUtils.showToast('Audio steganography module not loaded', 2500); return; }

    var reader = new FileReader();
    reader.onload = function(e) {
        var buffer = e.target.result;
        try {
            var info = A.parseWAV(buffer);
        } catch (err) {
            ToolUtils.showToast('Invalid WAV file: ' + err.message, 3000);
            return;
        }
        var capacity = A.getWAVCapacity(buffer, state.bitDepth, state.bitDepthMode);
        if (target === 'encode') {
            state.audioBuffer = buffer;
            state.audioFileName = file.name;
            state.maxCapacity = capacity;
            var infoEl = $('sg-encode-audio-info');
            if (infoEl) infoEl.innerHTML = R.renderAudioInfo(file.name, info.sampleRate, info.bitsPerSample, info.numChannels, info.duration, capacity);
            var previewEl = $('sg-encode-audio-preview');
            if (previewEl) previewEl.classList.add('sg-visible');
            var sourceEl = $('sg-encode-audio-source');
            if (sourceEl) sourceEl.classList.add('sg-hidden');
            $('sg-encode-btn').disabled = false;
            var meter = $('sg-capacity-container');
            if (meter) meter.classList.add('sg-visible');
            updateCapacity();
        } else {
            state.decodeAudioBuffer = buffer;
            state.decodeAudioFileName = file.name;
            var dinfoEl = $('sg-decode-audio-info');
            if (dinfoEl) dinfoEl.innerHTML = R.renderAudioInfo(file.name, info.sampleRate, info.bitsPerSample, info.numChannels, info.duration, capacity);
            var dpreviewEl = $('sg-decode-audio-preview');
            if (dpreviewEl) dpreviewEl.classList.add('sg-visible');
            var dsourceEl = $('sg-decode-audio-source');
            if (dsourceEl) dsourceEl.classList.add('sg-hidden');
            $('sg-decode-btn').disabled = false;
        }
    };
    reader.readAsArrayBuffer(file);
}

/* ===== Recalculate capacity when depth changes ===== */
function recalcCapacity() {
    if (state.medium === 'audio' && state.audioBuffer) {
        var A = window.StegoAudio;
        if (A) state.maxCapacity = A.getWAVCapacity(state.audioBuffer, state.bitDepth, state.bitDepthMode);
    } else if (state.encodeImageData) {
        state.maxCapacity = E.calculateCapacity(state.encodeImageData.width * state.encodeImageData.height, state.bitDepthMode, state.bitDepth);
    }
    var infoEl = $('sg-encode-image-info');
    if (infoEl && state.encodeImageData) {
        infoEl.innerHTML = R.renderImageInfo(
            state.currentFile ? state.currentFile.name : 'Generated',
            state.encodeImageData.width,
            state.encodeImageData.height,
            state.maxCapacity
        );
    }
    updateCapacity();
}

/* ===== RS Parity Bytes ===== */
function getRSParityBytes() {
    var levels = [16, 32, 48];
    return levels[state.rsParityLevel - 1] || 32;
}

/* ===== Encode ===== */
function encodeMessage() {
    // Audio encode path
    if (state.medium === 'audio') {
        encodeAudioMessage();
        return;
    }

    var message = $('sg-message-input').value;
    if (!message) { ToolUtils.showToast('Please enter a message to hide', 2500); return; }
    if (!state.encodeImageData) { ToolUtils.showToast('Please upload or generate an image first', 2500); return; }

    var messageLength = new Blob([message]).size;
    if (messageLength > state.maxCapacity) {
        upscaleCanvas(messageLength);
    }

    var resultContent = $('sg-result-content');
    R.showLoading(resultContent);
    $('sg-encode-btn').disabled = true;

    var password = $('sg-encode-password').value;
    var useCompression = $('sg-encode-compression').checked;
    var depth = state.bitDepth;
    var depthMode = state.bitDepthMode;

    var processPromise;
    if (password) {
        processPromise = E.encryptAES(message, password);
    } else {
        if (useCompression) {
            processPromise = E.compressDeflate(message).then(function(compressed) {
                // Convert Uint8Array to Latin-1 string for LSB embedding
                var str = '';
                for (var i = 0; i < compressed.length; i++) str += String.fromCharCode(compressed[i]);
                return btoa(str);
            });
        } else {
            processPromise = Promise.resolve(message);
        }
    }

    processPromise.then(function(processedMessage) {
        // Apply RS if enabled
        var RS = window.StegoRS;
        if (state.rsEnabled && RS) {
            var msgBytes = new TextEncoder().encode(processedMessage);
            var protected_ = RS.rsProtect(msgBytes, getRSParityBytes());
            // Prefix with RS flag byte 0x03 + 1 byte parity level
            var flagged = new Uint8Array(2 + protected_.length);
            flagged[0] = 0x03; // RS flag
            flagged[1] = state.rsParityLevel;
            flagged.set(protected_, 2);
            // btoa-encode to make binary data ASCII-safe for TextEncoder
            var latin1 = '';
            for (var i = 0; i < flagged.length; i++) latin1 += String.fromCharCode(flagged[i]);
            processedMessage = 'RS:' + btoa(latin1);
        }

        var encodedData;
        if (depth === 0 && depthMode === 'at') {
            encodedData = E.encodeLSB(state.encodeImageData, processedMessage);
        } else if (depthMode === 'at') {
            encodedData = E.encodeLSBAtDepth(state.encodeImageData, processedMessage, depth);
        } else {
            encodedData = E.encodeLSBWithDepth(state.encodeImageData, processedMessage, depth);
        }
        var tempCanvas = document.createElement('canvas');
        tempCanvas.width = state.encodeCanvas.width;
        tempCanvas.height = state.encodeCanvas.height;
        tempCanvas.getContext('2d').putImageData(encodedData, 0, 0);

        tempCanvas.toBlob(function(blob) {
            if (state.lastBlobUrl) URL.revokeObjectURL(state.lastBlobUrl);
            var url = URL.createObjectURL(blob);
            state.lastBlobUrl = url;
            var filename = 'stego-' + Date.now() + '.png';

            resultContent.innerHTML = R.renderEncodeSuccess(url, filename);

            var rc = $('sg-result-canvas');
            if (rc) {
                rc.width = tempCanvas.width;
                rc.height = tempCanvas.height;
                rc.getContext('2d').putImageData(encodedData, 0, 0);
            }

            updateToolbar();
            ToolUtils.showToast('Message hidden successfully!', 2500);
        }, 'image/png');
    }).catch(function(err) {
        resultContent.innerHTML = R.renderError('Encoding Failed', err.message, [
            'Check that the message is not too large',
            'Try a larger cover image',
            'Ensure the image was loaded correctly'
        ]);
        $('sg-encode-btn').disabled = false;
    });
}

/* ===== Audio Encode ===== */
function encodeAudioMessage() {
    var A = window.StegoAudio;
    if (!A) { ToolUtils.showToast('Audio module not loaded', 2500); return; }
    var message = $('sg-message-input').value;
    if (!message) { ToolUtils.showToast('Please enter a message', 2500); return; }
    if (!state.audioBuffer) { ToolUtils.showToast('Please upload a WAV file', 2500); return; }

    var resultContent = $('sg-result-content');
    R.showLoading(resultContent);
    $('sg-encode-btn').disabled = true;

    setTimeout(function() {
        try {
            var encodedBuffer = A.encodeWAV(state.audioBuffer, message, state.bitDepth, state.bitDepthMode);
            var blob = new Blob([encodedBuffer], { type: 'audio/wav' });
            if (state.lastBlobUrl) URL.revokeObjectURL(state.lastBlobUrl);
            var url = URL.createObjectURL(blob);
            state.lastBlobUrl = url;
            var filename = 'stego-' + Date.now() + '.wav';
            resultContent.innerHTML = R.renderAudioEncodeSuccess(url, filename);
            updateToolbar();
            ToolUtils.showToast('Message hidden in audio!', 2500);
        } catch (err) {
            resultContent.innerHTML = R.renderError('Audio Encoding Failed', err.message, [
                'Message may be too large for this WAV file',
                'Ensure the file is a valid PCM WAV'
            ]);
        }
        $('sg-encode-btn').disabled = false;
    }, 100);
}

/* ===== Audio Decode ===== */
function decodeAudioMessage() {
    var A = window.StegoAudio;
    if (!A) { ToolUtils.showToast('Audio module not loaded', 2500); return; }
    if (!state.decodeAudioBuffer) { ToolUtils.showToast('Please upload a WAV file', 2500); return; }

    var resultContent = $('sg-result-content');
    R.showLoading(resultContent);
    $('sg-decode-btn').disabled = true;

    setTimeout(function() {
        try {
            var decoded = A.decodeWAV(state.decodeAudioBuffer, state.decodeBitDepth, state.decodeBitDepthMode);
            showDecodedText(decoded, resultContent);
        } catch (err) {
            resultContent.innerHTML = R.renderError('Audio Decoding Failed', err.message, [
                'No hidden message found in this WAV file',
                'Check bit depth settings match encoding'
            ]);
        }
        $('sg-decode-btn').disabled = false;
    }, 100);
}

/* ===== Encode File ===== */
function encodeFile() {
    if (!state.encodeImageData) { ToolUtils.showToast('Please upload or generate an image first', 2500); return; }
    if (!state.embedFile || !state.embedFileBytes) { ToolUtils.showToast('Please select a file to embed', 2500); return; }

    var resultContent = $('sg-result-content');
    R.showLoading(resultContent);
    $('sg-encode-btn').disabled = true;

    var password = $('sg-encode-password').value;
    var fileBytes = new Uint8Array(state.embedFileBytes);
    var filename = state.embedFile.name;

    // Auto-upscale if file won't fit
    var filenameByteLen = new TextEncoder().encode(filename).length;
    var neededBytes = 1 + 1 + filenameByteLen + fileBytes.length;
    if (neededBytes > state.maxCapacity) {
        upscaleCanvas(neededBytes);
    }

    var depth = state.bitDepth;
    var depthMode = state.bitDepthMode;

    setTimeout(function() {
        try {
            var encodedData;
            if (password) {
                var binary = '';
                for (var i = 0; i < fileBytes.length; i++) binary += String.fromCharCode(fileBytes[i]);
                var fileB64 = btoa(binary);
                E.encryptAES(fileB64, password).then(function(encrypted) {
                    var payload = filename + '\x00' + encrypted;
                    var edata;
                    if (depth === 0 && depthMode === 'at') {
                        edata = E.encodeLSB(state.encodeImageData, '\x02' + payload);
                    } else if (depthMode === 'at') {
                        edata = E.encodeLSBAtDepth(state.encodeImageData, '\x02' + payload, depth);
                    } else {
                        edata = E.encodeLSBWithDepth(state.encodeImageData, '\x02' + payload, depth);
                    }
                    finishEncode(edata, resultContent);
                }).catch(function(err) {
                    resultContent.innerHTML = R.renderError('Encoding Failed', err.message, ['Encryption error']);
                    $('sg-encode-btn').disabled = false;
                });
                return;
            }
            if (depth === 0 && depthMode === 'at') {
                encodedData = E.encodeLSBFile(state.encodeImageData, fileBytes, filename);
            } else if (depthMode === 'at') {
                encodedData = E.encodeLSBFileAtDepth(state.encodeImageData, fileBytes, filename, depth);
            } else {
                encodedData = E.encodeLSBFileWithDepth(state.encodeImageData, fileBytes, filename, depth);
            }
            finishEncode(encodedData, resultContent);
        } catch (err) {
            resultContent.innerHTML = R.renderError('Encoding Failed', err.message, [
                'The file may be too large for this image',
                'Try a larger cover image'
            ]);
            $('sg-encode-btn').disabled = false;
        }
    }, 100);
}

function finishEncode(encodedData, resultContent) {
    var tempCanvas = document.createElement('canvas');
    tempCanvas.width = state.encodeCanvas.width;
    tempCanvas.height = state.encodeCanvas.height;
    tempCanvas.getContext('2d').putImageData(encodedData, 0, 0);

    tempCanvas.toBlob(function(blob) {
        if (state.lastBlobUrl) URL.revokeObjectURL(state.lastBlobUrl);
        var url = URL.createObjectURL(blob);
        state.lastBlobUrl = url;
        var filename = 'stego-' + Date.now() + '.png';

        resultContent.innerHTML = R.renderEncodeSuccess(url, filename);

        var rc = $('sg-result-canvas');
        if (rc) {
            rc.width = tempCanvas.width;
            rc.height = tempCanvas.height;
            rc.getContext('2d').putImageData(encodedData, 0, 0);
        }

        updateToolbar();
        ToolUtils.showToast('Data hidden successfully!', 2500);
    }, 'image/png');
}

/* ===== Decode ===== */

/**
 * Try a single decode strategy: optional atob, then optional XOR decrypt.
 * Returns { text, ratio } or null if it fails.
 */
function tryDecodeStrategy(raw, useAtob, password, useByteXor) {
    try {
        var step1 = raw;
        if (useAtob) {
            step1 = atob(raw);
        }
        var step2 = step1;
        if (password) {
            step2 = useByteXor
                ? E.xorDecryptBytes(step1, password)
                : E.xorEncrypt(step1, password);
        }
        var ratio = E.printableRatio(step2);
        return { text: step2, ratio: ratio };
    } catch (e) {
        return null;
    }
}

function decodeMessage() {
    // Audio decode path
    if (state.medium === 'audio') {
        decodeAudioMessage();
        return;
    }

    if (!state.decodeImageData) { ToolUtils.showToast('Please upload an image to decode', 2500); return; }

    var resultContent = $('sg-result-content');
    R.showLoading(resultContent);
    $('sg-decode-btn').disabled = true;

    var depth = state.decodeBitDepth;
    var depthMode = state.decodeBitDepthMode;

    setTimeout(function() {
        try {
            // First try new payload format (file detection)
            var payload = null;
            try {
                if (depth === 0 && depthMode === 'at') {
                    payload = E.decodeLSBPayload(state.decodeImageData);
                } else if (depthMode === 'at') {
                    payload = E.decodeLSBPayloadAtDepth(state.decodeImageData, depth);
                } else {
                    payload = E.decodeLSBPayloadWithDepth(state.decodeImageData, depth);
                }
            } catch(e) {}

            if (payload && payload.type === 'file') {
                var blob = new Blob([payload.data]);
                if (state.lastFileBlobUrl) URL.revokeObjectURL(state.lastFileBlobUrl);
                var blobUrl = URL.createObjectURL(blob);
                state.lastFileBlobUrl = blobUrl;
                resultContent.innerHTML = R.renderFileDecodeSuccess(payload.filename, payload.data.length, blobUrl);
                $('sg-decode-btn').disabled = false;
                ToolUtils.showToast('File extracted!', 2500);
                return;
            }

            var raw;
            if (depth === 0 && depthMode === 'at') {
                raw = E.decodeLSB(state.decodeImageData);
            } else if (depthMode === 'at') {
                raw = E.decodeLSBAtDepth(state.decodeImageData, depth);
            } else {
                raw = E.decodeLSBWithDepth(state.decodeImageData, depth);
            }
            if (!raw) throw new Error('No hidden message found');

            // Check for RS prefix
            var RS = window.StegoRS;
            if (RS && raw.indexOf('RS:') === 0) {
                var b64 = raw.substring(3);
                var latin1 = atob(b64);
                var flagged = new Uint8Array(latin1.length);
                for (var ri = 0; ri < latin1.length; ri++) flagged[ri] = latin1.charCodeAt(ri);
                if (flagged[0] === 0x03 && flagged.length > 2) {
                    var parityLevel = flagged[1];
                    var parityBytes = [16, 32, 48][parityLevel - 1] || 32;
                    var rsData = flagged.slice(2);
                    var recovered = RS.rsUnprotect(rsData, parityBytes);
                    raw = new TextDecoder().decode(recovered);
                }
            }

            var password = $('sg-decode-password').value;

            if (password) {
                E.decryptAES(raw, password).then(function(decrypted) {
                    showDecodedText(decrypted, resultContent);
                }).catch(function() {
                    fallbackXorDecode(raw, password, resultContent);
                });
                return;
            }

            // Try deflate decompression first (compressed messages are btoa-encoded)
            try {
                var decoded64 = atob(raw);
                var deflateBytes = new Uint8Array(decoded64.length);
                for (var di = 0; di < decoded64.length; di++) deflateBytes[di] = decoded64.charCodeAt(di);
                if (deflateBytes[0] === 0x00 || deflateBytes[0] === 0x01) {
                    E.decompressDeflate(deflateBytes).then(function(decompressed) {
                        if (E.printableRatio(decompressed) > 0.7) {
                            showDecodedText(decompressed, resultContent);
                        } else {
                            fallbackXorDecode(raw, '', resultContent);
                        }
                    }).catch(function() {
                        fallbackXorDecode(raw, '', resultContent);
                    });
                    return;
                }
            } catch(e) {}

            // Plain text: check if readable directly
            if (E.printableRatio(raw) >= 0.7) {
                showDecodedText(raw, resultContent);
                return;
            }

            // Legacy fallback for old btoa/xor formats
            fallbackXorDecode(raw, '', resultContent);

        } catch (err) {
            resultContent.innerHTML = R.renderError('Decoding Failed', err.message, [
                'No hidden message was found in this image',
                'The image may have been modified or compressed after encoding',
                'Try entering the correct password if one was used',
                'Check bit depth settings match the encoding'
            ]);
            $('sg-decode-btn').disabled = false;
        }
    }, 100);
}

function fallbackXorDecode(raw, password, resultContent) {
    var candidates = [];
    var r;

    if (password) {
        r = tryDecodeStrategy(raw, true, password, true);
        if (r) candidates.push(r);
        r = tryDecodeStrategy(raw, true, password, false);
        if (r) candidates.push(r);
        r = tryDecodeStrategy(raw, false, password, true);
        if (r) candidates.push(r);
        r = tryDecodeStrategy(raw, false, password, false);
        if (r) candidates.push(r);
    }
    r = tryDecodeStrategy(raw, true, '', false);
    if (r) candidates.push(r);
    r = tryDecodeStrategy(raw, false, '', false);
    if (r) candidates.push(r);

    // Also try deflate decompression if the raw looks like base64
    try {
        var decoded64 = atob(raw);
        var bytes = new Uint8Array(decoded64.length);
        for (var k = 0; k < decoded64.length; k++) bytes[k] = decoded64.charCodeAt(k);
        if (bytes[0] === 0x00 || bytes[0] === 0x01) {
            E.decompressDeflate(bytes).then(function(decompressed) {
                var ratio = E.printableRatio(decompressed);
                if (ratio > 0.7) {
                    showDecodedText(decompressed, resultContent);
                    return;
                }
                finishFallback(candidates, resultContent);
            }).catch(function() {
                finishFallback(candidates, resultContent);
            });
            return;
        }
    } catch(e) {}

    finishFallback(candidates, resultContent);
}

function finishFallback(candidates, resultContent) {
    var best = null;
    for (var i = 0; i < candidates.length; i++) {
        if (!best || candidates[i].ratio > best.ratio) {
            best = candidates[i];
        }
    }

    if (!best || best.text.length === 0) {
        resultContent.innerHTML = R.renderError('Decoding Failed', 'No readable message could be extracted', [
            'No hidden message was found in this image',
            'The password may be incorrect',
            'The encoding format may not be compatible'
        ]);
        $('sg-decode-btn').disabled = false;
        return;
    }

    if (best.ratio < 0.7) {
        resultContent.innerHTML = R.renderError(
            'Possible Decoding Issue',
            'A message was found but it does not appear to be readable text (' + Math.round(best.ratio * 100) + '% printable).',
            [
                'The password may be incorrect',
                'The message may have been encoded with a different tool',
                'The image may have been modified after encoding'
            ]
        );
        $('sg-decode-btn').disabled = false;
        return;
    }

    showDecodedText(best.text, resultContent);
}

function showDecodedText(text, resultContent) {
    state.extractedMessage = text;
    resultContent.innerHTML = R.renderDecodeSuccess(text);

    var copyBtn = $('sg-copy-msg-btn');
    if (copyBtn) {
        copyBtn.addEventListener('click', function() {
            ToolUtils.copyToClipboard(state.extractedMessage);
        });
    }

    updateToolbar();
    $('sg-decode-btn').disabled = false;
    ToolUtils.showToast('Message extracted!', 2500);
}

/* ===== Forensic Decode ===== */
function forensicDecode() {
    if (!state.decodeImageData) { ToolUtils.showToast('Please upload an image to scan', 2500); return; }

    var resultContent = $('sg-result-content');
    $('sg-forensic-btn').disabled = true;
    $('sg-decode-btn').disabled = true;
    state.forensicResults = [];

    resultContent.innerHTML = R.renderForensicProgress(0, F.CONFIGS.length, 0);

    F.runForensicScan(
        state.decodeImageData,
        function onProgress(current, total, foundCount) {
            resultContent.innerHTML = R.renderForensicProgress(current, total, foundCount);
        },
        function onComplete(results, elapsedMs) {
            state.forensicResults = results;
            resultContent.innerHTML = R.renderForensicResults(results, F.CONFIGS.length, elapsedMs);
            $('sg-forensic-btn').disabled = false;
            $('sg-decode-btn').disabled = false;

            // Bind copy buttons
            var copyBtns = resultContent.querySelectorAll('.sg-forensic-copy-btn');
            for (var i = 0; i < copyBtns.length; i++) {
                copyBtns[i].addEventListener('click', function() {
                    var idx = parseInt(this.getAttribute('data-index'), 10);
                    if (state.forensicResults[idx]) {
                        ToolUtils.copyToClipboard(state.forensicResults[idx].text);
                    }
                });
            }

            // Bind expand/collapse buttons
            var expandBtns = resultContent.querySelectorAll('.sg-forensic-expand-btn');
            for (var j = 0; j < expandBtns.length; j++) {
                expandBtns[j].addEventListener('click', function() {
                    var card = this.closest('.sg-forensic-card');
                    var preview = card.querySelector('.sg-forensic-preview');
                    var full = card.querySelector('.sg-forensic-full');
                    if (full) {
                        var isExpanded = !full.classList.contains('sg-hidden');
                        full.classList.toggle('sg-hidden');
                        preview.classList.toggle('sg-hidden');
                        this.textContent = isExpanded ? 'Expand' : 'Collapse';
                    }
                });
            }

            if (results.length > 0) {
                ToolUtils.showToast('Forensic scan found ' + results.length + ' result(s)', 2500);
            }
        }
    );
}

/* ===== Analyze / Bit Plane ===== */
function analyzeBitPlane() {
    if (!state.analyzeImageData) { ToolUtils.showToast('Please upload an image to analyze', 2500); return; }

    var channelSel = $('sg-bitplane-channel');
    var planeSel = $('sg-bitplane-plane');
    var channel = parseInt(channelSel.value, 10);
    var plane = parseInt(planeSel.value, 10);

    var resultContent = $('sg-result-content');
    var bitPlaneData = E.extractBitPlane(state.analyzeImageData, channel, plane);

    resultContent.innerHTML = R.renderBitPlaneResult(channel, plane, state.analyzeImageData.width, state.analyzeImageData.height);

    var canvas = $('sg-bitplane-canvas');
    if (canvas) {
        canvas.width = bitPlaneData.width;
        canvas.height = bitPlaneData.height;
        canvas.getContext('2d').putImageData(bitPlaneData, 0, 0);
    }
}

function resetAnalyze() {
    state.analyzeImageData = null;
    state.analyzeCanvas = null;

    var fileInput = $('sg-analyze-file');
    if (fileInput) fileInput.value = '';
    var source = $('sg-analyze-source');
    if (source) source.classList.remove('sg-hidden');
    var preview = $('sg-analyze-preview');
    if (preview) preview.classList.remove('sg-visible');
    var analyzeBtn = $('sg-analyze-btn');
    if (analyzeBtn) analyzeBtn.disabled = true;

    R.showEmpty($('sg-result-content'));
}

/* ===== File Embed Upload ===== */
function handleEmbedFile(file) {
    if (!file) return;
    state.embedFile = file;
    var reader = new FileReader();
    reader.onload = function(e) {
        state.embedFileBytes = e.target.result;
        var infoEl = $('sg-embed-file-info');
        if (infoEl) {
            infoEl.innerHTML = '<strong>' + E.escapeHtml(file.name) + '</strong> (' + E.formatBytes(file.size) + ')';
            infoEl.style.display = 'block';
        }
        // Capacity check removed — encodeFile() will auto-upscale if needed
    };
    reader.readAsArrayBuffer(file);
}

/* ===== Capacity Meter ===== */
function updateCapacity() {
    var messageEl = $('sg-message-input');
    var meterEl = $('sg-capacity-meter');
    if (!messageEl || !meterEl) return;

    var message = messageEl.value;
    var used = new Blob([message]).size;
    meterEl.innerHTML = R.renderCapacityMeter(used, state.maxCapacity);
}

/* ===== Reset ===== */
function resetEncode() {
    state.encodeImageData = null;
    state.encodeCanvas = null;
    state.maxCapacity = 0;
    state.currentFile = null;
    state.embedFile = null;
    state.embedFileBytes = null;
    state.audioBuffer = null;
    state.audioFileName = null;
    if (state.lastBlobUrl) { URL.revokeObjectURL(state.lastBlobUrl); state.lastBlobUrl = null; }

    var encFile = $('sg-encode-file');
    if (encFile) encFile.value = '';
    var msgInput = $('sg-message-input');
    if (msgInput) msgInput.value = '';
    var encPwd = $('sg-encode-password');
    if (encPwd) encPwd.value = '';
    var compressionEl = $('sg-encode-compression');
    if (compressionEl) compressionEl.checked = true;
    var encSource = $('sg-encode-source');
    if (encSource) encSource.classList.remove('sg-hidden');
    var encPreview = $('sg-encode-preview');
    if (encPreview) encPreview.classList.remove('sg-visible');
    var capContainer = $('sg-capacity-container');
    if (capContainer) capContainer.classList.remove('sg-visible');
    var encBtn = $('sg-encode-btn');
    if (encBtn) encBtn.disabled = true;

    // Reset audio preview
    var audSource = $('sg-encode-audio-source');
    if (audSource) audSource.classList.remove('sg-hidden');
    var audPreview = $('sg-encode-audio-preview');
    if (audPreview) audPreview.classList.remove('sg-visible');

    var embedFileInput = $('sg-embed-file-input');
    if (embedFileInput) embedFileInput.value = '';
    var embedInfo = $('sg-embed-file-info');
    if (embedInfo) { embedInfo.innerHTML = ''; embedInfo.style.display = 'none'; }

    var cards = document.querySelectorAll('.sg-gen-card');
    for (var i = 0; i < cards.length; i++) cards[i].classList.remove('sg-gen-active');

    R.showEmpty($('sg-result-content'));
    updateToolbar();
}

function resetDecode() {
    state.decodeImageData = null;
    state.decodeCanvas = null;
    state.extractedMessage = '';

    $('sg-decode-file').value = '';
    $('sg-decode-password').value = '';
    $('sg-decode-source').classList.remove('sg-hidden');
    $('sg-decode-preview').classList.remove('sg-visible');
    $('sg-decode-password-section').style.display = 'none';
    $('sg-decode-btn').disabled = true;
    var forensicBtn = $('sg-forensic-btn');
    if (forensicBtn) forensicBtn.disabled = true;
    state.forensicResults = [];

    R.showEmpty($('sg-result-content'));
    updateToolbar();
}

/* ===== Toolbar ===== */
function updateToolbar() {
    var toolbar = $('sg-toolbar');
    if (!toolbar) return;

    var hasResult = $('sg-result-content') &&
        ($('sg-result-content').querySelector('.sg-result-message') !== null);

    var downloadBtn = $('sg-toolbar-download');
    var copyBtn = $('sg-toolbar-copy');

    if (downloadBtn) downloadBtn.style.display = (state.mode === 'encode' && state.lastBlobUrl && hasResult) ? '' : 'none';
    if (copyBtn) copyBtn.style.display = (state.mode === 'decode' && state.extractedMessage && hasResult) ? '' : 'none';
}

/* ===== Download ===== */
function downloadResult(url, filename) {
    var a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.click();
}

/* ===== Password Toggle ===== */
function togglePassword(inputId, btn) {
    var input = $(inputId);
    if (!input) return;
    if (input.type === 'password') {
        input.type = 'text';
        btn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>';
    } else {
        input.type = 'password';
        btn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>';
    }
}

/* ===== FAQ ===== */
function toggleFaq(btn) {
    var item = btn.parentElement;
    var isOpen = item.classList.contains('open');
    // Close all
    var items = document.querySelectorAll('.faq-item');
    for (var i = 0; i < items.length; i++) items[i].classList.remove('open');
    // Toggle
    if (!isOpen) item.classList.add('open');
}

/* ===== Upload Zone Helpers ===== */
function setupUploadZone(zoneId, fileInputId, target) {
    var zone = $(zoneId);
    var fileInput = $(fileInputId);
    if (!zone || !fileInput) return;

    zone.addEventListener('click', function() { fileInput.click(); });

    fileInput.addEventListener('change', function() {
        if (fileInput.files && fileInput.files[0]) {
            processUploadedImage(fileInput.files[0], target);
        }
    });

    zone.addEventListener('dragover', function(e) {
        e.preventDefault();
        zone.classList.add('sg-drag-over');
    });
    zone.addEventListener('dragleave', function() {
        zone.classList.remove('sg-drag-over');
    });
    zone.addEventListener('drop', function(e) {
        e.preventDefault();
        zone.classList.remove('sg-drag-over');
        if (e.dataTransfer.files && e.dataTransfer.files[0]) {
            processUploadedImage(e.dataTransfer.files[0], target);
        }
    });
}

/* ===== Init ===== */
function init() {
    // Mode toggle (3 modes)
    var modeButtons = ['encode', 'decode', 'analyze'];
    for (var m = 0; m < modeButtons.length; m++) {
        (function(mode) {
            var btn = $('sg-mode-' + mode);
            if (btn) btn.addEventListener('click', function() { switchMode(mode); });
        })(modeButtons[m]);
    }

    // Encode sub-tabs
    var msgSubTab = $('sg-subtab-message');
    if (msgSubTab) msgSubTab.addEventListener('click', function() { switchEncodeSubTab('message'); });
    var fileSubTab = $('sg-subtab-file');
    if (fileSubTab) fileSubTab.addEventListener('click', function() { switchEncodeSubTab('file'); });

    // Upload zones
    setupUploadZone('sg-encode-upload-zone', 'sg-encode-file', 'encode');
    setupUploadZone('sg-decode-upload-zone', 'sg-decode-file', 'decode');
    setupUploadZone('sg-analyze-upload-zone', 'sg-analyze-file', 'analyze');

    // File embed upload zone
    var embedZone = $('sg-embed-upload-zone');
    var embedInput = $('sg-embed-file-input');
    if (embedZone && embedInput) {
        embedZone.addEventListener('click', function() { embedInput.click(); });
        embedInput.addEventListener('change', function() {
            if (embedInput.files && embedInput.files[0]) handleEmbedFile(embedInput.files[0]);
        });
        embedZone.addEventListener('dragover', function(e) { e.preventDefault(); embedZone.classList.add('sg-drag-over'); });
        embedZone.addEventListener('dragleave', function() { embedZone.classList.remove('sg-drag-over'); });
        embedZone.addEventListener('drop', function(e) {
            e.preventDefault();
            embedZone.classList.remove('sg-drag-over');
            if (e.dataTransfer.files && e.dataTransfer.files[0]) handleEmbedFile(e.dataTransfer.files[0]);
        });
    }

    // URL fetch buttons
    var encUrlBtn = $('sg-encode-url-btn');
    if (encUrlBtn) encUrlBtn.addEventListener('click', function() {
        loadImageFromUrl($('sg-encode-url').value, 'encode');
    });
    var encUrlInput = $('sg-encode-url');
    if (encUrlInput) encUrlInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') { e.preventDefault(); loadImageFromUrl(this.value, 'encode'); }
    });

    var decUrlBtn = $('sg-decode-url-btn');
    if (decUrlBtn) decUrlBtn.addEventListener('click', function() {
        loadImageFromUrl($('sg-decode-url').value, 'decode');
    });
    var decUrlInput = $('sg-decode-url');
    if (decUrlInput) decUrlInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') { e.preventDefault(); loadImageFromUrl(this.value, 'decode'); }
    });

    // Generator cards
    var genCards = document.querySelectorAll('.sg-gen-card');
    for (var i = 0; i < genCards.length; i++) {
        genCards[i].addEventListener('click', function() {
            var type = this.getAttribute('data-type');
            generateCoverImage(type);
        });
    }

    // Medium toggle
    var medImgBtn = $('sg-medium-image');
    if (medImgBtn) medImgBtn.addEventListener('click', function() { switchMedium('image'); });
    var medAudBtn = $('sg-medium-audio');
    if (medAudBtn) medAudBtn.addEventListener('click', function() { switchMedium('audio'); });

    // Audio upload zones
    var encAudZone = $('sg-encode-audio-zone');
    var encAudInput = $('sg-encode-audio-file');
    if (encAudZone && encAudInput) {
        encAudZone.addEventListener('click', function() { encAudInput.click(); });
        encAudInput.addEventListener('change', function() {
            if (encAudInput.files && encAudInput.files[0]) processUploadedAudio(encAudInput.files[0], 'encode');
        });
        encAudZone.addEventListener('dragover', function(e) { e.preventDefault(); encAudZone.classList.add('sg-drag-over'); });
        encAudZone.addEventListener('dragleave', function() { encAudZone.classList.remove('sg-drag-over'); });
        encAudZone.addEventListener('drop', function(e) {
            e.preventDefault(); encAudZone.classList.remove('sg-drag-over');
            if (e.dataTransfer.files && e.dataTransfer.files[0]) processUploadedAudio(e.dataTransfer.files[0], 'encode');
        });
    }
    var decAudZone = $('sg-decode-audio-zone');
    var decAudInput = $('sg-decode-audio-file');
    if (decAudZone && decAudInput) {
        decAudZone.addEventListener('click', function() { decAudInput.click(); });
        decAudInput.addEventListener('change', function() {
            if (decAudInput.files && decAudInput.files[0]) processUploadedAudio(decAudInput.files[0], 'decode');
        });
        decAudZone.addEventListener('dragover', function(e) { e.preventDefault(); decAudZone.classList.add('sg-drag-over'); });
        decAudZone.addEventListener('dragleave', function() { decAudZone.classList.remove('sg-drag-over'); });
        decAudZone.addEventListener('drop', function(e) {
            e.preventDefault(); decAudZone.classList.remove('sg-drag-over');
            if (e.dataTransfer.files && e.dataTransfer.files[0]) processUploadedAudio(e.dataTransfer.files[0], 'decode');
        });
    }

    // Bit depth controls (encode)
    var encDepthMode = $('sg-encode-depth-mode');
    if (encDepthMode) encDepthMode.addEventListener('change', function() {
        state.bitDepthMode = this.value;
        recalcCapacity();
    });
    var encDepthVal = $('sg-encode-depth-value');
    if (encDepthVal) encDepthVal.addEventListener('change', function() {
        state.bitDepth = parseInt(this.value, 10);
        recalcCapacity();
    });

    // Bit depth controls (decode)
    var decDepthMode = $('sg-decode-depth-mode');
    if (decDepthMode) decDepthMode.addEventListener('change', function() {
        state.decodeBitDepthMode = this.value;
    });
    var decDepthVal = $('sg-decode-depth-value');
    if (decDepthVal) decDepthVal.addEventListener('change', function() {
        state.decodeBitDepth = parseInt(this.value, 10);
    });

    // RS controls
    var rsCheckbox = $('sg-encode-rs');
    if (rsCheckbox) rsCheckbox.addEventListener('change', function() {
        state.rsEnabled = this.checked;
        var rsOpts = $('sg-rs-options');
        if (rsOpts) rsOpts.style.display = this.checked ? 'block' : 'none';
        recalcCapacity();
    });
    var rsLevel = $('sg-encode-rs-level');
    if (rsLevel) rsLevel.addEventListener('change', function() {
        state.rsParityLevel = parseInt(this.value, 10);
        recalcCapacity();
    });

    // Message input - live capacity
    var msgInput = $('sg-message-input');
    if (msgInput) {
        msgInput.addEventListener('input', function() { updateCapacity(); });
    }

    // Action buttons
    var encBtn = $('sg-encode-btn');
    if (encBtn) encBtn.addEventListener('click', function() {
        if (state.encodeSubTab === 'file') {
            encodeFile();
        } else {
            encodeMessage();
        }
    });

    var decBtn = $('sg-decode-btn');
    if (decBtn) decBtn.addEventListener('click', function() { decodeMessage(); });

    var forensicBtn = $('sg-forensic-btn');
    if (forensicBtn) forensicBtn.addEventListener('click', function() { forensicDecode(); });

    var analyzeBtn = $('sg-analyze-btn');
    if (analyzeBtn) analyzeBtn.addEventListener('click', function() { analyzeBitPlane(); });

    // Bit plane control live updates
    var bpChannel = $('sg-bitplane-channel');
    var bpPlane = $('sg-bitplane-plane');
    if (bpChannel) bpChannel.addEventListener('change', function() { if (state.analyzeImageData) analyzeBitPlane(); });
    if (bpPlane) bpPlane.addEventListener('change', function() { if (state.analyzeImageData) analyzeBitPlane(); });

    // Change image links
    var changeEnc = $('sg-change-encode');
    if (changeEnc) changeEnc.addEventListener('click', function() { resetEncode(); });

    var changeDec = $('sg-change-decode');
    if (changeDec) changeDec.addEventListener('click', function() { resetDecode(); });

    var changeAnalyze = $('sg-change-analyze');
    if (changeAnalyze) changeAnalyze.addEventListener('click', function() { resetAnalyze(); });

    // Password toggles
    var encPwdToggle = $('sg-enc-pwd-toggle');
    if (encPwdToggle) encPwdToggle.addEventListener('click', function() { togglePassword('sg-encode-password', this); });

    var decPwdToggle = $('sg-dec-pwd-toggle');
    if (decPwdToggle) decPwdToggle.addEventListener('click', function() { togglePassword('sg-decode-password', this); });

    // Toolbar buttons
    var tbDownload = $('sg-toolbar-download');
    if (tbDownload) tbDownload.addEventListener('click', function() {
        if (state.lastBlobUrl) downloadResult(state.lastBlobUrl, 'stego-' + Date.now() + '.png');
    });

    var tbCopy = $('sg-toolbar-copy');
    if (tbCopy) tbCopy.addEventListener('click', function() {
        if (state.extractedMessage) ToolUtils.copyToClipboard(state.extractedMessage);
    });

    // Set initial state
    R.showEmpty($('sg-result-content'));
    updateToolbar();
}

// Run on DOMContentLoaded
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

// Export
window.StegoCore = {
    switchMode: switchMode,
    switchEncodeSubTab: switchEncodeSubTab,
    switchMedium: switchMedium,
    encodeMessage: encodeMessage,
    encodeFile: encodeFile,
    decodeMessage: decodeMessage,
    encodeAudioMessage: encodeAudioMessage,
    decodeAudioMessage: decodeAudioMessage,
    resetEncode: resetEncode,
    resetDecode: resetDecode,
    resetAnalyze: resetAnalyze,
    analyzeBitPlane: analyzeBitPlane,
    downloadResult: downloadResult,
    loadImageFromUrl: loadImageFromUrl,
    toggleFaq: toggleFaq,
    forensicDecode: forensicDecode
};

})();

// Advanced Video Editor (Updated for "no server" mode)

const { createFFmpeg, fetchFile } = FFmpeg;
let ffmpeg;
let watermarkFontReady = false;
const WATERMARK_FONT_NAME = 'DejaVuSans.ttf';
let overlayWatermarkActive = false;
const WATERMARK_IMAGE_NAME = 'wm.png';

async function ensureWatermarkFont() {
  if (watermarkFontReady) return;
  // Try same-origin first, then CDN fallback
  const { origin, pathname } = window.location;
  const parts = pathname.split('/').filter(Boolean);
  const context = parts.length ? `/${parts[0]}/` : '/';
  const candidates = [
    // Context-aware same-origin URL (works under WAR context path)
    origin + context + 'fonts/DejaVuSans.ttf',
    // Fallback absolute root (may 404 if app not at root)
    origin + '/fonts/DejaVuSans.ttf',
    // CDN fallback
    'https://cdnjs.cloudflare.com/ajax/libs/dejavu/2.37/ttf/DejaVuSans.ttf'
  ];
  for (const url of candidates) {
    try {
      const res = await fetch(url, { mode: 'cors' });
      if (!res.ok) throw new Error(`Fetch failed: ${url}`);
      const buf = new Uint8Array(await res.arrayBuffer());
      ffmpeg.FS('writeFile', WATERMARK_FONT_NAME, buf);
      watermarkFontReady = true;
      console.log('Watermark font loaded from', url);
      return;
    } catch (e) {
      console.warn('Watermark font not available at', url);
    }
  }
  console.warn('No watermark font available; will use overlay fallback if needed.');
}

function base64ToBytes(b64){
  const bin = atob(b64);
  const len = bin.length;
  const bytes = new Uint8Array(len);
  for (let i=0;i<len;i++) bytes[i] = bin.charCodeAt(i);
  return bytes;
}

async function createWatermarkImage(text){
  const padding = 8;
  const font = '24px sans-serif';
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  ctx.font = font;
  const metrics = ctx.measureText(text);
  const textW = Math.ceil(metrics.width);
  const textH = 28; // approx for 24px font
  canvas.width = textW + padding*2;
  canvas.height = textH + padding*2;
  // Draw box
  ctx.fillStyle = 'rgba(0,0,0,0.5)';
  ctx.fillRect(0,0,canvas.width,canvas.height);
  // Draw text
  ctx.font = font;
  ctx.fillStyle = '#ffffff';
  ctx.textBaseline = 'top';
  ctx.fillText(text, padding, padding);
  // Get PNG bytes
  const dataUrl = canvas.toDataURL('image/png');
  const b64 = dataUrl.split(',')[1];
  return base64ToBytes(b64);
}

// DOM Elements
const videoUploader = document.getElementById('video-upload');
const uploaderPanel = document.getElementById('uploader-panel');
const editorElement = document.getElementById('editor');
const videoPlayer = document.getElementById('video-player');
const startTimeInput = document.getElementById('start-time');
const endTimeInput = document.getElementById('end-time');
const trimBtn = document.getElementById('trim-btn');
const outputSection = document.getElementById('output');
const outputVideo = document.getElementById('output-video');
const downloadLink = document.getElementById('download-link');
const message = document.getElementById('message');
const logMessage = document.getElementById('log-message');

// Advanced feature elements
const videoQuality = document.getElementById('video-quality');
const outputFormat = document.getElementById('output-format');
const videoSpeed = document.getElementById('video-speed');
const videoRotate = document.getElementById('video-rotate');
const videoScale = document.getElementById('video-scale');
const extractAudio = document.getElementById('extract-audio');
const muteVideo = document.getElementById('mute-video');
const addWatermark = document.getElementById('add-watermark');
const watermarkText = document.getElementById('watermark-text');
const useOverlayWatermark = document.getElementById('use-overlay-watermark');
const watermarkPosition = document.getElementById('watermark-position');
const watermarkX = document.getElementById('watermark-x');
const watermarkY = document.getElementById('watermark-y');
const videoCodec = document.getElementById('video-codec');
const audioBitrate = document.getElementById('audio-bitrate');
const videoFps = document.getElementById('video-fps');
const progressBar = document.getElementById('progress-fill');
const progressText = document.getElementById('progress-text');
const progressSection = document.getElementById('progress');
const videoInfo = document.getElementById('video-info');
const multiTrimBtn = document.getElementById('multi-trim-btn');
const trimSegments = document.getElementById('trim-segments');
const addSegmentBtn = document.getElementById('add-segment-btn');

let originalVideoFile = null;
let segmentCounter = 0;
let segments = [];
let inputObjectUrl = null;

// Initialize FFmpeg
const resolveCorePath = () => {
    const { origin, pathname } = window.location;
    // Derive Java webapp context path (first segment), e.g. /mywebapp2_war_exploded/
    const parts = pathname.split('/').filter(Boolean);
    const context = parts.length ? `/${parts[0]}/` : '/';
    return origin + context + 'js/ffmpeg/ffmpeg-core.js';
};

const initializeFFmpeg = async () => {
    // Basic capability checks
    try {
        if (typeof WebAssembly === 'undefined') {
            alert('This browser does not support WebAssembly. Please use a modern browser (Chrome, Edge, Firefox).');
            return;
        }
        if (!('SharedArrayBuffer' in window) || !self.crossOriginIsolated) {
            alert('This browser/tab is not configured for high‑performance video processing. Please use a modern browser with cross‑origin isolation enabled.');
            return;
        }
    } catch (_) {}

    ffmpeg = createFFmpeg({
        log: true,
        corePath: resolveCorePath(),
        progress: ({ ratio }) => {
            if (progressBar && progressSection) {
                progressSection.classList.remove('hidden');
                const percentage = Math.round(ratio * 100);
                progressBar.style.width = percentage + '%';
                if (progressText) {
                    progressText.textContent = `Processing: ${percentage}%`;
                }
            }
        }
    });
    if (message) message.textContent = 'Loading ffmpeg-core.js...';
    try {
        await ffmpeg.load();
        // Hide the message panel on success; do not show extra text
        if (message) message.classList.add('hidden');
        if (videoUploader && videoUploader.parentElement) {
            videoUploader.parentElement.style.display = 'block'; // Show uploader
        }
    } catch (e) {
        console.error('FFmpeg load failed', e);
        alert('Unable to load FFmpeg in this browser. Please try a modern Chromium or Firefox browser.');
        return;
    }
};

// Format bytes to human readable
function formatBytes(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

// Format seconds to HH:MM:SS
function formatTime(seconds) {
    const h = Math.floor(seconds / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = Math.floor(seconds % 60);
    return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
}

// Display video information
function displayVideoInfo(file, video) {
    if (!videoInfo) return;

    const info = `
        <div class="video-info-grid">
            <div><strong>Filename:</strong> ${file.name}</div>
            <div><strong>Size:</strong> ${formatBytes(file.size)}</div>
            <div><strong>Duration:</strong> ${formatTime(video.duration)}</div>
            <div><strong>Resolution:</strong> ${video.videoWidth} × ${video.videoHeight}</div>
            <div><strong>Format:</strong> ${file.type || 'Unknown'}</div>
        </div>
    `;
    videoInfo.innerHTML = info;
    videoInfo.classList.remove('hidden');
}

// Handle video file selection
videoUploader.addEventListener('change', (event) => {
    originalVideoFile = event.target.files[0];
    if (originalVideoFile) {
        const fileURL = URL.createObjectURL(originalVideoFile);
        try { if (inputObjectUrl) { URL.revokeObjectURL(inputObjectUrl); } } catch(_){}
        inputObjectUrl = fileURL;
        videoPlayer.src = fileURL;
        editorElement.classList.remove('hidden');
        message.classList.add('hidden');
        if (uploaderPanel) uploaderPanel.style.display = 'none';

        // Set default end time based on video duration
        videoPlayer.addEventListener('loadedmetadata', () => {
            const duration = videoPlayer.duration;
            endTimeInput.value = duration;
            endTimeInput.max = duration;
            startTimeInput.max = duration;

            // Display video info
            displayVideoInfo(originalVideoFile, videoPlayer);
        });
    }
});

// Update video player when seeking
if (startTimeInput) {
    startTimeInput.addEventListener('input', () => {
        if (videoPlayer && !videoPlayer.paused) {
            videoPlayer.currentTime = parseFloat(startTimeInput.value);
        }
    });
}

// Add segment for multi-trim
if (addSegmentBtn) {
    addSegmentBtn.addEventListener('click', () => {
        const start = parseFloat(startTimeInput.value) || 0;
        const end = parseFloat(endTimeInput.value) || 5;

        if (start >= end) {
            alert('End time must be greater than start time.');
            return;
        }

        const segmentId = segmentCounter++;
        segments.push({ id: segmentId, start, end });

        const segmentDiv = document.createElement('div');
        segmentDiv.className = 'segment-item';
        segmentDiv.id = `segment-${segmentId}`;
        segmentDiv.innerHTML = `
            <span>Segment ${segmentId + 1}: ${formatTime(start)} - ${formatTime(end)}</span>
            <button onclick="removeSegment(${segmentId})" class="btn-remove">Remove</button>
        `;

        if (trimSegments) {
            trimSegments.appendChild(segmentDiv);
        }
    });
}

// Remove segment
window.removeSegment = function(segmentId) {
    segments = segments.filter(s => s.id !== segmentId);
    const segmentDiv = document.getElementById(`segment-${segmentId}`);
    if (segmentDiv) {
        segmentDiv.remove();
    }
};

// Build FFmpeg command based on options
function buildFFmpegCommand(inputFile, outputFile) {
    const commands = ['-i', inputFile];

    const startTime = parseFloat(startTimeInput.value) || 0;
    const endTime = parseFloat(endTimeInput.value) || 5;
    const duration = endTime - startTime;

    // Trim
    commands.push('-ss', String(startTime), '-t', String(duration));

    const quality = videoQuality ? videoQuality.value : 'medium';
    let selectedCodec = videoCodec ? videoCodec.value : 'copy';

    // Collect filters to a single chain to avoid overriding
    const vFilters = [];
    const aFilters = [];

    // Speed (video/audio)
    if (videoSpeed && videoSpeed.value !== '1') {
        const speed = parseFloat(videoSpeed.value);
        vFilters.push(`setpts=${1/speed}*PTS`);
        if (!muteVideo || !muteVideo.checked) {
            aFilters.push(`atempo=${speed}`);
        }
    }

    // Rotation
    if (videoRotate && videoRotate.value !== '0') {
        const rotation = videoRotate.value;
        if (rotation === '90') {
            vFilters.push('transpose=1');
        } else if (rotation === '180') {
            vFilters.push('transpose=2,transpose=2');
        } else if (rotation === '270') {
            vFilters.push('transpose=2');
        }
    }

    // Scale/Resolution
    if (videoScale && videoScale.value !== 'original') {
        vFilters.push(`scale=${videoScale.value}`);
    }

    // FPS
    if (videoFps && videoFps.value !== 'original') {
        vFilters.push(`fps=${videoFps.value}`);
    }

    // Helper to compute watermark x,y expressions
    const computeWatermarkXY = (type) => { // type: 'drawtext' | 'overlay'
        const pos = watermarkPosition ? watermarkPosition.value : 'tl';
        const xVal = parseInt(watermarkX && watermarkX.value || '10', 10) || 10;
        const yVal = parseInt(watermarkY && watermarkY.value || '10', 10) || 10;
        if (type === 'drawtext') {
            switch (pos) {
                case 'tl': return { x: `${xVal}`, y: `${yVal}` };
                case 'tr': return { x: `w-text_w-${xVal}`, y: `${yVal}` };
                case 'bl': return { x: `${xVal}`, y: `h-text_h-${yVal}` };
                case 'br': return { x: `w-text_w-${xVal}`, y: `h-text_h-${yVal}` };
                case 'center': return { x: `(w-text_w)/2`, y: `(h-text_h)/2` };
                case 'custom': return { x: `${xVal}`, y: `${yVal}` };
                default: return { x: '10', y: '10' };
            }
        } else {
            // overlay filter uses main_w/main_h and overlay_w/overlay_h
            switch (pos) {
                case 'tl': return { x: `${xVal}`, y: `${yVal}` };
                case 'tr': return { x: `main_w-overlay_w-${xVal}`, y: `${yVal}` };
                case 'bl': return { x: `${xVal}`, y: `main_h-overlay_h-${yVal}` };
                case 'br': return { x: `main_w-overlay_w-${xVal}`, y: `main_h-overlay_h-${yVal}` };
                case 'center': return { x: `(main_w-overlay_w)/2`, y: `(main_h-overlay_h)/2` };
                case 'custom': return { x: `${xVal}`, y: `${yVal}` };
                default: return { x: '10', y: '10' };
            }
        }
    };

    // Watermark
    if (addWatermark && addWatermark.checked && watermarkText && watermarkText.value) {
        if (watermarkFontReady && !overlayWatermarkActive) {
            const text = watermarkText.value.replace(/'/g, "\\'");
            const fontOpt = `fontfile='/${WATERMARK_FONT_NAME}':`;
            const xy = computeWatermarkXY('drawtext');
            vFilters.push(`drawtext=${fontOpt}text='${text}':fontsize=24:fontcolor=white:x=${xy.x}:y=${xy.y}:box=1:boxcolor=black@0.5`);
        }
        // else: overlayWatermarkActive will handle via filter_complex
    }

    const hasVideoFilters = vFilters.length > 0;

    // If filters are applied, we cannot stream-copy video
    if ((hasVideoFilters || overlayWatermarkActive) && selectedCodec === 'copy') {
        // Choose a sensible default based on format (fallback libx264)
        const fmt = outputFormat ? outputFormat.value : 'mp4';
        selectedCodec = fmt === 'webm' ? 'libvpx-vp9' : 'libx264';
    }

    // Video codec and quality
    if (selectedCodec === 'copy') {
        commands.push('-c:v', 'copy');
    } else {
        commands.push('-c:v', selectedCodec);
        if (quality === 'high') {
            commands.push('-crf', '18');
        } else if (quality === 'medium') {
            commands.push('-crf', '23');
        } else {
            commands.push('-crf', '28');
        }
    }

    // Apply video filters (single chain) or overlay watermark via filter_complex
    if (overlayWatermarkActive) {
        // Add watermark image as second input
        commands.push('-i', WATERMARK_IMAGE_NAME);
        const xy = computeWatermarkXY('overlay');
        const chain = hasVideoFilters
            ? `[0:v]${vFilters.join(',')}[v0];[v0][1:v]overlay=${xy.x}:${xy.y}[vout]`
            : `[0:v][1:v]overlay=${xy.x}:${xy.y}[vout]`;
        commands.push('-filter_complex', chain, '-map', '[vout]');
        // we'll map audio below
    } else if (hasVideoFilters) {
        commands.push('-vf', vFilters.join(','));
    }

    // Audio handling
    if (muteVideo && muteVideo.checked) {
        commands.push('-an');
    } else if (extractAudio && extractAudio.checked) {
        commands.push('-vn');
        const audioBitrateVal = audioBitrate ? audioBitrate.value : '128k';
        commands.push('-b:a', audioBitrateVal);
    } else {
        // Keep audio and apply filters if any
        commands.push('-c:a', 'aac');
        const audioBitrateVal = audioBitrate ? audioBitrate.value : '128k';
        commands.push('-b:a', audioBitrateVal);
        if (aFilters.length > 0) {
            commands.push('-filter:a', aFilters.join(','));
        }
        // If using overlay (filter_complex), ensure we include audio stream
        if (overlayWatermarkActive) {
            commands.push('-map', '0:a?');
        }
    }

    commands.push(outputFile);
    return commands;
}

// Handle Trim Button Click
trimBtn.addEventListener('click', async () => {
    if (!originalVideoFile) {
        alert('Please select a video file first.');
        return;
    }

    const startTime = parseFloat(startTimeInput.value);
    const endTime = parseFloat(endTimeInput.value);

    if (startTime >= endTime) {
        alert('End time must be greater than start time.');
        return;
    }

    // Validate watermark text if enabled
    if (addWatermark && addWatermark.checked) {
        if (!watermarkText || !watermarkText.value || !watermarkText.value.trim()) {
            alert('Please enter watermark text or disable watermark option.');
            return;
        }
    }

    // Disable button and show processing message
    trimBtn.disabled = true;
    trimBtn.textContent = 'Processing...';
    logMessage.textContent = 'Starting video processing. This may take some time...';

    if (progressSection) {
        progressSection.classList.remove('hidden');
    }

    try {
        // Watermark: respect force-overlay toggle; else prefer font, fallback to overlay
        overlayWatermarkActive = false;
        if (addWatermark && addWatermark.checked) {
            const forceOverlay = useOverlayWatermark && useOverlayWatermark.checked;
            const textVal = (watermarkText && watermarkText.value) ? watermarkText.value : '';
            if (forceOverlay) {
                if (textVal) {
                    const pngBytes = await createWatermarkImage(textVal);
                    try { ffmpeg.FS('writeFile', WATERMARK_IMAGE_NAME, pngBytes); overlayWatermarkActive = true; } catch(e) { console.warn('Failed to write watermark image', e); }
                }
            } else {
                await ensureWatermarkFont();
                if (!watermarkFontReady && textVal) {
                    const pngBytes = await createWatermarkImage(textVal);
                    try { ffmpeg.FS('writeFile', WATERMARK_IMAGE_NAME, pngBytes); overlayWatermarkActive = true; } catch(e) { console.warn('Failed to write watermark image', e); }
                }
            }
        }
        // Write the file to FFmpeg's virtual file system
        ffmpeg.FS('writeFile', originalVideoFile.name, await fetchFile(originalVideoFile));

        // Determine output format
        const format = outputFormat ? outputFormat.value : 'mp4';
        const outputFileName = `output.${format}`;

        // Build FFmpeg command
        const commands = buildFFmpegCommand(originalVideoFile.name, outputFileName);

        // Run the FFmpeg command
        await ffmpeg.run(...commands);

        // Read the result from the virtual file system (guard if missing)
        let data;
        try { data = ffmpeg.FS('readFile', outputFileName); }
        catch(e){ throw new Error(`Output not created (${outputFileName}). Check selected options or filters.`); }

        // Determine MIME type
        let mimeType = 'video/mp4';
        if (extractAudio && extractAudio.checked) {
            mimeType = 'audio/mpeg';
        } else if (format === 'webm') {
            mimeType = 'video/webm';
        } else if (format === 'avi') {
            mimeType = 'video/avi';
        }

        // Create a URL for the processed video
        const videoBlob = new Blob([data.buffer], { type: mimeType });
        const videoUrl = URL.createObjectURL(videoBlob);

        // Display the output video and download link
        if (extractAudio && extractAudio.checked) {
            outputVideo.style.display = 'none';
            const audioPlayer = document.createElement('audio');
            audioPlayer.controls = true;
            audioPlayer.src = videoUrl;
            audioPlayer.style.width = '100%';
            outputSection.querySelector('div[style*="text-align: center"]').prepend(audioPlayer);
        } else {
            outputVideo.src = videoUrl;
            outputVideo.style.display = 'block';
        }

        downloadLink.href = videoUrl;
        downloadLink.download = `processed-${Date.now()}.${format}`;

        outputSection.classList.remove('hidden');
        downloadLink.classList.remove('hidden');
        logMessage.textContent = 'Processing complete!';

        // Show output file size
        if (videoInfo) {
            const sizeInfo = document.createElement('div');
            sizeInfo.className = 'alert alert-success';
            sizeInfo.style.marginTop = '15px';
            sizeInfo.innerHTML = `
                <span>✓</span>
                <div><strong>Success!</strong> Output size: ${formatBytes(data.buffer.byteLength)}</div>
            `;
            videoInfo.appendChild(sizeInfo);
        }

    } catch (error) {
        console.error(error);
        logMessage.textContent = 'An error occurred during processing: ' + error.message;
    } finally {
        // Re-enable the button
        trimBtn.disabled = false;
        trimBtn.textContent = 'Process Video';
        if (progressSection) {
            setTimeout(() => progressSection.classList.add('hidden'), 2000);
        }
    }
});

// Handle Multi-Trim Button Click
if (multiTrimBtn) {
    multiTrimBtn.addEventListener('click', async () => {
        if (!originalVideoFile) {
            alert('Please select a video file first.');
            return;
        }
        if (segments.length === 0) {
            alert('Please add at least one segment.');
            return;
        }

        multiTrimBtn.disabled = true;
        multiTrimBtn.textContent = 'Processing...';
        logMessage.textContent = 'Processing multiple segments...';

        try {
            ffmpeg.FS('writeFile', originalVideoFile.name, await fetchFile(originalVideoFile));

            const outputFiles = [];

            for (let i = 0; i < segments.length; i++) {
                const segment = segments[i];
                const duration = segment.end - segment.start;
                const outputFile = `segment-${i}.mp4`;

                logMessage.textContent = `Processing segment ${i + 1} of ${segments.length}...`;

                await ffmpeg.run(
                    '-i', originalVideoFile.name,
                    '-ss', String(segment.start),
                    '-t', String(duration),
                    '-c:v', 'libx264',
                    '-c:a', 'aac',
                    outputFile
                );

                outputFiles.push(outputFile);
            }

            // Create concat file
            const concatContent = outputFiles.map(f => `file '${f}'`).join('\n');
            ffmpeg.FS('writeFile', 'concat.txt', new TextEncoder().encode(concatContent));

            // Concatenate all segments
            logMessage.textContent = 'Merging segments...';
            await ffmpeg.run('-f', 'concat', '-safe', '0', '-i', 'concat.txt', '-c', 'copy', 'final-output.mp4');

            const data = ffmpeg.FS('readFile', 'final-output.mp4');
            const videoBlob = new Blob([data.buffer], { type: 'video/mp4' });
            const videoUrl = URL.createObjectURL(videoBlob);

            outputVideo.src = videoUrl;
            downloadLink.href = videoUrl;
            downloadLink.download = `multi-trim-${Date.now()}.mp4`;

            outputSection.classList.remove('hidden');
            downloadLink.classList.remove('hidden');
            logMessage.textContent = 'All segments processed and merged!';

        } catch (error) {
            console.error(error);
            logMessage.textContent = 'Error processing segments: ' + error.message;
        } finally {
            multiTrimBtn.disabled = false;
            multiTrimBtn.textContent = 'Process Multiple Segments';
        }
    });
}


// Toggle watermark text field
if (addWatermark) {
    addWatermark.addEventListener('change', () => {
        const watermarkGroup = document.getElementById('watermark-group');
        if (watermarkGroup) {
            watermarkGroup.style.display = addWatermark.checked ? 'block' : 'none';
        }
    });
}

// Start the application
initializeFFmpeg();

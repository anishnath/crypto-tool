// Video Resizer & Cropper Tool (Simplified Canvas-based version)
// Uses Canvas API for client-side video resizing without FFmpeg

let originalVideo = null;
let processedVideoBlob = null;
let currentAspectRatio = null;
let isAspectRatioLocked = true;
let currentQuality = 'medium';
let currentFormat = 'webm'; // 'webm' or 'mp4'
let mediaRecorder = null;
let recordedChunks = [];

// Quality settings (bitrate in bps)
const qualitySettings = {
  low: 2500000,    // 2.5 Mbps
  medium: 5000000, // 5 Mbps
  high: 8000000    // 8 Mbps
};

// Social media presets
const presets = {
  'instagram-reel': { width: 1080, height: 1920, name: 'Instagram Reel (9:16)' },
  'tiktok': { width: 1080, height: 1920, name: 'TikTok (9:16)' },
  'youtube-short': { width: 1080, height: 1920, name: 'YouTube Short (9:16)' },
  'instagram-story': { width: 1080, height: 1920, name: 'Instagram Story (9:16)' },
  'instagram-post': { width: 1080, height: 1080, name: 'Instagram Post (1:1)' },
  'youtube': { width: 1920, height: 1080, name: 'YouTube (16:9)' },
  'facebook': { width: 1280, height: 720, name: 'Facebook (16:9)' },
  'twitter': { width: 1280, height: 720, name: 'Twitter (16:9)' }
};

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
  setupEventListeners();
  checkBrowserSupport();
});

// Check browser support
function checkBrowserSupport() {
  if (!('MediaRecorder' in window)) {
    console.warn('MediaRecorder API not supported');
    alert('Your browser does not support video processing. Please use Chrome, Firefox, or Safari.');
  }
}

// Setup event listeners
function setupEventListeners() {
  const videoInput = document.getElementById('videoInput');
  const uploadArea = document.getElementById('uploadArea');

  // File input change
  videoInput.addEventListener('change', handleVideoUpload);

  // Drag and drop
  uploadArea.addEventListener('dragover', (e) => {
    e.preventDefault();
    uploadArea.classList.add('dragover');
  });

  uploadArea.addEventListener('dragleave', () => {
    uploadArea.classList.remove('dragover');
  });

  uploadArea.addEventListener('drop', (e) => {
    e.preventDefault();
    uploadArea.classList.remove('dragover');
    const file = e.dataTransfer.files[0];
    if (file && file.type.startsWith('video/')) {
      handleVideoFile(file);
    }
  });
}

// Handle video upload
function handleVideoUpload(event) {
  const file = event.target.files[0];
  if (file) {
    handleVideoFile(file);
  }
}

// Handle video file
async function handleVideoFile(file) {
  // Validate file type
  if (!file.type.startsWith('video/')) {
    alert('Please upload a valid video file.');
    return;
  }

  // Validate file size (500MB limit)
  if (file.size > 500 * 1024 * 1024) {
    alert('File size exceeds 500MB limit. Please choose a smaller file.');
    return;
  }

  // Store original video
  originalVideo = file;

  // Display video
  const videoElement = document.getElementById('originalVideo');
  const videoURL = URL.createObjectURL(file);
  videoElement.src = videoURL;
  videoElement.style.display = 'block';

  // Hide welcome screen
  document.getElementById('welcomeScreen').style.display = 'none';

  // Wait for metadata to load
  videoElement.addEventListener('loadedmetadata', function() {
    const duration = formatDuration(videoElement.duration);
    const width = videoElement.videoWidth;
    const height = videoElement.videoHeight;

    // Calculate aspect ratio
    currentAspectRatio = width / height;

    // Update UI
    document.getElementById('originalDimensions').textContent = `${width}x${height}px`;
    document.getElementById('videoDuration').textContent = duration;
    document.getElementById('fileSize').textContent = formatFileSize(file.size);
    document.getElementById('newDimensions').textContent = `${width}x${height}px`;

    // Show controls
    document.getElementById('presetsSection').style.display = 'block';
    document.getElementById('controlsSection').style.display = 'block';
    document.getElementById('videoInfo').style.display = 'block';
    document.getElementById('actionButtons').style.display = 'flex';
    document.getElementById('videoStatus').textContent = 'Ready to process';

    // Set default dimensions
    document.getElementById('widthSlider').value = width;
    document.getElementById('widthInput').value = width;
    document.getElementById('heightSlider').value = height;
    document.getElementById('heightInput').value = height;
  }, { once: true });
}

// Apply preset
function applyPreset(presetKey) {
  const preset = presets[presetKey];
  if (!preset) return;

  // Update dimensions
  document.getElementById('widthSlider').value = preset.width;
  document.getElementById('widthInput').value = preset.width;
  document.getElementById('heightSlider').value = preset.height;
  document.getElementById('heightInput').value = preset.height;
  document.getElementById('newDimensions').textContent = `${preset.width}x${preset.height}px`;

  // Calculate new aspect ratio
  currentAspectRatio = preset.width / preset.height;
  isAspectRatioLocked = true;
  document.getElementById('aspectRatioLock').checked = true;

  // Update UI
  document.getElementById('videoStatus').textContent = `Preset: ${preset.name}`;

  // Highlight active preset
  document.querySelectorAll('.preset-btn').forEach(btn => btn.classList.remove('active'));
  event.target.closest('.preset-btn').classList.add('active');
}

// Update width
function updateWidth(value) {
  const width = parseInt(value);
  document.getElementById('widthSlider').value = width;
  document.getElementById('widthInput').value = width;

  if (isAspectRatioLocked && currentAspectRatio) {
    const height = Math.round(width / currentAspectRatio);
    document.getElementById('heightSlider').value = height;
    document.getElementById('heightInput').value = height;
    document.getElementById('newDimensions').textContent = `${width}x${height}px`;
  } else {
    const height = document.getElementById('heightInput').value;
    document.getElementById('newDimensions').textContent = `${width}x${height}px`;
  }
}

// Update height
function updateHeight(value) {
  const height = parseInt(value);
  document.getElementById('heightSlider').value = height;
  document.getElementById('heightInput').value = height;

  if (isAspectRatioLocked && currentAspectRatio) {
    const width = Math.round(height * currentAspectRatio);
    document.getElementById('widthSlider').value = width;
    document.getElementById('widthInput').value = width;
    document.getElementById('newDimensions').textContent = `${width}x${height}px`;
  } else {
    const width = document.getElementById('widthInput').value;
    document.getElementById('newDimensions').textContent = `${width}x${height}px`;
  }
}

// Toggle aspect ratio lock
function toggleAspectRatio() {
  isAspectRatioLocked = document.getElementById('aspectRatioLock').checked;

  if (isAspectRatioLocked) {
    const width = parseInt(document.getElementById('widthInput').value);
    const height = parseInt(document.getElementById('heightInput').value);
    currentAspectRatio = width / height;
  }
}

// Set quality
function setQuality(quality) {
  currentQuality = quality;

  // Update UI
  document.querySelectorAll('.quality-btn').forEach(btn => btn.classList.remove('active'));
  event.target.classList.add('active');
}

// Set output format
function setFormat(format) {
  currentFormat = format;

  // Update UI
  document.querySelectorAll('.format-btn').forEach(btn => btn.classList.remove('active'));
  event.target.classList.add('active');
}

// Process video using Canvas
async function processVideo() {
  if (!originalVideo) {
    alert('Please upload a video first.');
    return;
  }

  // Get target dimensions
  const targetWidth = parseInt(document.getElementById('widthInput').value);
  const targetHeight = parseInt(document.getElementById('heightInput').value);

  // Validate dimensions
  if (targetWidth < 240 || targetHeight < 240 || targetWidth > 1920 || targetHeight > 1920) {
    alert('Invalid dimensions. Width and height must be between 240px and 1920px.');
    return;
  }

  try {
    // Disable process button
    const processBtn = document.getElementById('processBtn');
    processBtn.disabled = true;
    processBtn.textContent = 'Processing...';

    // Show processing overlay
    showProcessingOverlay('Preparing video...');

    // Create video element for processing
    const video = document.createElement('video');
    video.src = URL.createObjectURL(originalVideo);
    video.muted = true;

    await new Promise((resolve, reject) => {
      video.onloadedmetadata = resolve;
      video.onerror = reject;
    });

    // Create canvas
    const canvas = document.createElement('canvas');
    canvas.width = targetWidth;
    canvas.height = targetHeight;
    const ctx = canvas.getContext('2d');

    // Calculate scaling and positioning
    const sourceAspect = video.videoWidth / video.videoHeight;
    const targetAspect = targetWidth / targetHeight;

    let drawWidth, drawHeight, offsetX, offsetY;

    if (sourceAspect > targetAspect) {
      // Source is wider
      drawHeight = targetHeight;
      drawWidth = targetHeight * sourceAspect;
      offsetX = (targetWidth - drawWidth) / 2;
      offsetY = 0;
    } else {
      // Source is taller
      drawWidth = targetWidth;
      drawHeight = targetWidth / sourceAspect;
      offsetX = 0;
      offsetY = (targetHeight - drawHeight) / 2;
    }

    updateProcessingStatus('Processing video frames...');

    // Setup media recorder
    const stream = canvas.captureStream(30); // 30 FPS

    // Get audio from original video if available
    try {
      const audioContext = new AudioContext();
      const source = audioContext.createMediaElementSource(video);
      const destination = audioContext.createMediaStreamDestination();
      source.connect(destination);

      // Combine video and audio streams
      destination.stream.getAudioTracks().forEach(track => stream.addTrack(track));
    } catch (e) {
      console.warn('Could not extract audio:', e);
    }

    const bitrate = qualitySettings[currentQuality];
    let mimeType = 'video/webm;codecs=vp9';
    let actualFormat = 'webm';

    // Try different mime types based on format preference and browser support
    if (currentFormat === 'mp4') {
      if (MediaRecorder.isTypeSupported('video/mp4')) {
        mimeType = 'video/mp4';
        actualFormat = 'mp4';
      } else if (MediaRecorder.isTypeSupported('video/webm;codecs=h264')) {
        mimeType = 'video/webm;codecs=h264';
        actualFormat = 'webm';
        console.warn('MP4 not supported, using WebM with H.264 codec');
      } else {
        console.warn('MP4 not supported, falling back to WebM VP9');
        mimeType = 'video/webm;codecs=vp9';
        actualFormat = 'webm';
      }
    } else {
      // WebM format
      if (!MediaRecorder.isTypeSupported(mimeType)) {
        mimeType = 'video/webm;codecs=vp8';
      }
      if (!MediaRecorder.isTypeSupported(mimeType)) {
        mimeType = 'video/webm';
      }
      actualFormat = 'webm';
    }

    // Store the actual format for download
    window.actualVideoFormat = actualFormat;

    // Notify user if format was changed
    if (currentFormat === 'mp4' && actualFormat === 'webm') {
      updateProcessingStatus('Note: Your browser doesn\'t support MP4 recording. Using WebM format instead.');
    }

    const options = {
      mimeType: mimeType,
      videoBitsPerSecond: bitrate
    };

    recordedChunks = [];
    mediaRecorder = new MediaRecorder(stream, options);

    mediaRecorder.ondataavailable = (event) => {
      if (event.data.size > 0) {
        recordedChunks.push(event.data);
      }
    };

    mediaRecorder.onstop = () => {
      // Use the actual format that was recorded
      const finalFormat = window.actualVideoFormat || 'webm';
      const mimeTypeForBlob = finalFormat === 'mp4' ? 'video/mp4' : 'video/webm';
      processedVideoBlob = new Blob(recordedChunks, { type: mimeTypeForBlob });

      // Hide processing overlay
      hideProcessingOverlay();

      // Show download button
      document.getElementById('downloadBtn').style.display = 'block';
      processBtn.textContent = '✨ Resize & Crop Video';
      processBtn.disabled = false;

      // Update status with actual format
      const formatMsg = finalFormat === 'mp4' ? 'MP4' : 'WebM';
      document.getElementById('videoStatus').textContent = `Processing complete! (${formatMsg} format)`;

      // Clean up
      URL.revokeObjectURL(video.src);
      video.pause();
      video.src = '';

      // Alert with format info
      const alertMsg = currentFormat === 'mp4' && finalFormat === 'webm'
        ? 'Video processed successfully in WebM format (MP4 not supported by your browser). Click "Download Video" to save.'
        : `Video processed successfully in ${formatMsg} format! Click "Download Video" to save.`;
      alert(alertMsg);
    };

    // Start recording
    mediaRecorder.start(100); // Collect data every 100ms

    // Play and draw video
    video.play();

    const drawFrame = () => {
      if (!video.paused && !video.ended) {
        // Clear canvas with black background
        ctx.fillStyle = '#000000';
        ctx.fillRect(0, 0, targetWidth, targetHeight);

        // Draw video frame
        ctx.drawImage(video, offsetX, offsetY, drawWidth, drawHeight);

        // Update progress
        const progress = Math.round((video.currentTime / video.duration) * 100);
        updateProgress(progress);
        updateProcessingStatus(`Processing: ${progress}% complete`);

        requestAnimationFrame(drawFrame);
      } else {
        // Video ended, stop recording
        mediaRecorder.stop();
      }
    };

    drawFrame();

  } catch (error) {
    console.error('Error processing video:', error);
    hideProcessingOverlay();
    document.getElementById('processBtn').disabled = false;
    document.getElementById('processBtn').textContent = '✨ Resize & Crop Video';

    alert('Failed to process video: ' + (error.message || 'Unknown error'));
  }
}

// Download video
function downloadVideo() {
  if (!processedVideoBlob) {
    alert('No processed video available. Please process the video first.');
    return;
  }

  const url = URL.createObjectURL(processedVideoBlob);
  const a = document.createElement('a');
  a.href = url;

  // Generate filename based on dimensions and actual format with 8gwifi.org prefix
  const width = document.getElementById('widthInput').value;
  const height = document.getElementById('heightInput').value;
  // Use the actual format that was recorded, not what was requested
  const actualFormat = window.actualVideoFormat || 'webm';
  const extension = actualFormat === 'mp4' ? 'mp4' : 'webm';
  a.download = `8gwifi.org-resized_${width}x${height}_${Date.now()}.${extension}`;

  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

// Reset tool
function resetTool() {
  // Stop recording if active
  if (mediaRecorder && mediaRecorder.state !== 'inactive') {
    mediaRecorder.stop();
  }

  // Clear video
  originalVideo = null;
  processedVideoBlob = null;
  recordedChunks = [];

  // Reset video element
  const videoElement = document.getElementById('originalVideo');
  videoElement.src = '';
  videoElement.style.display = 'none';

  // Show welcome screen
  document.getElementById('welcomeScreen').style.display = 'block';

  // Hide sections
  document.getElementById('presetsSection').style.display = 'none';
  document.getElementById('controlsSection').style.display = 'none';
  document.getElementById('videoInfo').style.display = 'none';
  document.getElementById('actionButtons').style.display = 'none';
  document.getElementById('downloadBtn').style.display = 'none';

  // Reset file input
  document.getElementById('videoInput').value = '';

  // Reset aspect ratio lock
  isAspectRatioLocked = true;
  document.getElementById('aspectRatioLock').checked = true;

  // Reset quality
  currentQuality = 'medium';
  document.querySelectorAll('.quality-btn').forEach(btn => btn.classList.remove('active'));
  document.querySelectorAll('.quality-btn')[1].classList.add('active'); // Medium is default

  // Reset presets
  document.querySelectorAll('.preset-btn').forEach(btn => btn.classList.remove('active'));

  // Reset status
  document.getElementById('videoStatus').textContent = '';
}

// Show processing overlay
function showProcessingOverlay(message) {
  document.getElementById('processingOverlay').style.display = 'flex';
  document.getElementById('processingText').textContent = message;
  document.getElementById('progressBar').style.width = '0%';
  document.getElementById('progressText').textContent = '0%';
}

// Update processing status
function updateProcessingStatus(message) {
  document.getElementById('processingStatus').textContent = message;
}

// Update progress
function updateProgress(percent) {
  document.getElementById('progressBar').style.width = percent + '%';
  document.getElementById('progressText').textContent = percent + '%';
}

// Hide processing overlay
function hideProcessingOverlay() {
  document.getElementById('processingOverlay').style.display = 'none';
}

// Helper: Format file size
function formatFileSize(bytes) {
  if (bytes < 1024) return bytes + ' B';
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB';
  if (bytes < 1024 * 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
  return (bytes / (1024 * 1024 * 1024)).toFixed(2) + ' GB';
}

// Helper: Format duration
function formatDuration(seconds) {
  const hrs = Math.floor(seconds / 3600);
  const mins = Math.floor((seconds % 3600) / 60);
  const secs = Math.floor(seconds % 60);

  if (hrs > 0) {
    return `${hrs}:${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }
  return `${mins}:${secs.toString().padStart(2, '0')}`;
}

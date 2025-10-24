// Video Resizer & Cropper Tool
// Uses FFmpeg.wasm for client-side video processing

let originalVideo = null;
let processedVideoBlob = null;
let ffmpeg = null;
let ffmpegLoaded = false;
let currentAspectRatio = null;
let isAspectRatioLocked = true;
let currentQuality = 'medium';

// Quality settings
const qualitySettings = {
  low: { crf: 28, preset: 'faster' },
  medium: { crf: 23, preset: 'medium' },
  high: { crf: 18, preset: 'slow' }
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
  loadFFmpeg();
});

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

// Load FFmpeg
async function loadFFmpeg() {
  try {
    // Check if FFmpeg is available
    if (typeof FFmpeg === 'undefined' || typeof FFmpeg.createFFmpeg === 'undefined') {
      console.error('FFmpeg library not loaded');
      setTimeout(loadFFmpeg, 500); // Retry after 500ms
      return;
    }

    const { createFFmpeg } = FFmpeg;
    ffmpeg = createFFmpeg({
      log: true,
      progress: ({ ratio }) => {
        const percent = Math.round(ratio * 100);
        updateProgress(percent);
      }
    });

    console.log('FFmpeg instance created successfully');
  } catch (error) {
    console.error('Failed to create FFmpeg instance:', error);
  }
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
  });
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

// Process video
async function processVideo() {
  if (!originalVideo) {
    alert('Please upload a video first.');
    return;
  }

  // Check if FFmpeg is available
  if (!ffmpeg) {
    alert('Video processing library is not loaded. Please refresh the page and try again.');
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
    showProcessingOverlay('Initializing FFmpeg...');

    // Load FFmpeg if not already loaded
    if (!ffmpegLoaded) {
      updateProcessingStatus('Loading video processing library (first time only)...');
      await ffmpeg.load();
      ffmpegLoaded = true;
      console.log('FFmpeg loaded successfully');
    }

    // Update status
    updateProcessingStatus('Reading video file...');

    // Write video to FFmpeg filesystem
    const videoData = await readFileAsUint8Array(originalVideo);
    const inputFileName = 'input.mp4';
    const outputFileName = 'output.mp4';
    ffmpeg.FS('writeFile', inputFileName, videoData);

    // Get quality settings
    const quality = qualitySettings[currentQuality];

    // Update status
    updateProcessingStatus('Resizing and cropping video...');

    // Run FFmpeg command
    // Scale and crop video while maintaining quality
    await ffmpeg.run(
      '-i', inputFileName,
      '-vf', `scale=${targetWidth}:${targetHeight}:force_original_aspect_ratio=decrease,pad=${targetWidth}:${targetHeight}:(ow-iw)/2:(oh-ih)/2`,
      '-c:v', 'libx264',
      '-crf', quality.crf.toString(),
      '-preset', quality.preset,
      '-c:a', 'aac',
      '-b:a', '128k',
      '-movflags', '+faststart',
      outputFileName
    );

    // Update status
    updateProcessingStatus('Finalizing output...');

    // Read processed video
    const processedData = ffmpeg.FS('readFile', outputFileName);
    processedVideoBlob = new Blob([processedData.buffer], { type: 'video/mp4' });

    // Clean up FFmpeg filesystem
    ffmpeg.FS('unlink', inputFileName);
    ffmpeg.FS('unlink', outputFileName);

    // Hide processing overlay
    hideProcessingOverlay();

    // Show download button
    document.getElementById('downloadBtn').style.display = 'block';
    processBtn.textContent = '✨ Resize & Crop Video';
    processBtn.disabled = false;
    document.getElementById('videoStatus').textContent = 'Processing complete!';

    // Show success message
    alert('Video processed successfully! Click "Download Video" to save.');

  } catch (error) {
    console.error('Error processing video:', error);
    hideProcessingOverlay();
    document.getElementById('processBtn').disabled = false;
    document.getElementById('processBtn').textContent = '✨ Resize & Crop Video';

    // Provide more specific error message
    let errorMsg = 'Failed to process video. ';
    if (error.message && error.message.includes('SharedArrayBuffer')) {
      errorMsg += 'Your browser does not support the required features. Please use a modern browser like Chrome, Firefox, or Safari.';
    } else if (error.message) {
      errorMsg += error.message;
    } else {
      errorMsg += 'Please try again with a different file or settings.';
    }
    alert(errorMsg);
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

  // Generate filename based on dimensions
  const width = document.getElementById('widthInput').value;
  const height = document.getElementById('heightInput').value;
  a.download = `resized_${width}x${height}_${Date.now()}.mp4`;

  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

// Reset tool
function resetTool() {
  // Clear video
  originalVideo = null;
  processedVideoBlob = null;

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

// Helper: Read file as Uint8Array
function readFileAsUint8Array(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = (e) => resolve(new Uint8Array(e.target.result));
    reader.onerror = reject;
    reader.readAsArrayBuffer(file);
  });
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

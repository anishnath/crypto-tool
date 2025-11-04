// Timeline Editor for Video Trimmer
// Professional frame-by-frame editing with visual timeline

let timelineState = {
    duration: 0,
    currentTime: 0,
    inPoint: 0,
    outPoint: 0,
    fps: 30,
    isDraggingHandle: false,
    isDraggingInMarker: false,
    isDraggingOutMarker: false
};

// Timeline DOM elements
const timelineTrack = document.getElementById('timeline-track');
const timelineHandle = document.getElementById('timeline-handle');
const timelineProgress = document.getElementById('timeline-progress');
const timelineInMarker = document.getElementById('timeline-in-marker');
const timelineOutMarker = document.getElementById('timeline-out-marker');
const timelineSelection = document.getElementById('timeline-selection');
const currentTimeDisplay = document.getElementById('current-time-display');
const durationDisplay = document.getElementById('duration-display');
const waveformCanvas = document.getElementById('waveform-canvas');
const timelineTicks = document.getElementById('timeline-ticks');

// Control buttons
const frameBackBtn = document.getElementById('frame-back');
const playPauseBtn = document.getElementById('play-pause');
const frameForwardBtn = document.getElementById('frame-forward');
const setInBtn = document.getElementById('set-in');
const setOutBtn = document.getElementById('set-out');
const goToInBtn = document.getElementById('go-to-in');
const goToOutBtn = document.getElementById('go-to-out');

// Initialize timeline when video loads
function initializeTimeline(video) {
    timelineState.duration = video.duration;
    timelineState.outPoint = video.duration;
    endTimeInput.value = video.duration;

    // Detect FPS from video if possible (default to 30)
    timelineState.fps = 30;

    // Draw waveform
    drawWaveform();

    // Generate time ticks
    generateTimeTicks();

    // Update timeline display
    updateTimeline();
}

// Draw audio waveform on canvas
function drawWaveform() {
    if (!waveformCanvas) return;

    const ctx = waveformCanvas.getContext('2d');
    const width = waveformCanvas.width = waveformCanvas.offsetWidth;
    const height = waveformCanvas.height = waveformCanvas.offsetHeight;

    // Clear canvas
    ctx.fillStyle = '#2d3748';
    ctx.fillRect(0, 0, width, height);

    // Draw fake waveform (in real implementation, extract actual audio data)
    ctx.strokeStyle = '#667eea';
    ctx.lineWidth = 1;
    ctx.beginPath();

    const bars = 100;
    const barWidth = width / bars;

    for (let i = 0; i < bars; i++) {
        const x = i * barWidth;
        const amplitude = Math.random() * 0.6 + 0.2;
        const barHeight = height * amplitude;
        const y = (height - barHeight) / 2;

        ctx.fillStyle = `rgba(102, 126, 234, ${amplitude})`;
        ctx.fillRect(x, y, barWidth - 1, barHeight);
    }
}

// Generate time tick marks
function generateTimeTicks() {
    if (!timelineTicks || !timelineState.duration) return;

    timelineTicks.innerHTML = '';
    const tickCount = 10;
    const interval = timelineState.duration / tickCount;

    for (let i = 0; i <= tickCount; i++) {
        const time = i * interval;
        const tick = document.createElement('span');
        tick.className = 'timeline-tick';
        tick.textContent = formatTime(time);
        timelineTicks.appendChild(tick);
    }
}

// Update timeline visual elements
function updateTimeline() {
    const videoPlayer = document.getElementById('video-player');
    if (!videoPlayer || !timelineState.duration) return;

    const currentPercent = (timelineState.currentTime / timelineState.duration) * 100;
    const inPercent = (timelineState.inPoint / timelineState.duration) * 100;
    const outPercent = (timelineState.outPoint / timelineState.duration) * 100;

    // Update handle position
    if (timelineHandle) {
        timelineHandle.style.left = `${currentPercent}%`;
    }

    // Update progress bar
    if (timelineProgress) {
        timelineProgress.style.width = `${currentPercent}%`;
    }

    // Update in/out markers
    if (timelineInMarker) {
        timelineInMarker.style.left = `${inPercent}%`;
    }

    if (timelineOutMarker) {
        timelineOutMarker.style.left = `${outPercent}%`;
    }

    // Update selection area
    if (timelineSelection) {
        timelineSelection.style.left = `${inPercent}%`;
        timelineSelection.style.width = `${outPercent - inPercent}%`;
    }

    // Update time display
    if (currentTimeDisplay) {
        currentTimeDisplay.textContent = formatTime(timelineState.currentTime);
    }

    // Update duration display
    if (durationDisplay) {
        const duration = timelineState.outPoint - timelineState.inPoint;
        durationDisplay.textContent = `${duration.toFixed(2)}s`;
    }
}

// Video time update handler
function onVideoTimeUpdate() {
    const videoPlayer = document.getElementById('video-player');
    if (!videoPlayer) return;
    timelineState.currentTime = videoPlayer.currentTime;
    updateTimeline();
}

// Frame-by-frame navigation
function goToNextFrame() {
    const videoPlayer = document.getElementById('video-player');
    if (!videoPlayer) return;
    const frameDuration = 1 / timelineState.fps;
    videoPlayer.currentTime = Math.min(videoPlayer.currentTime + frameDuration, timelineState.duration);
    timelineState.currentTime = videoPlayer.currentTime;
    updateTimeline();
}

function goToPreviousFrame() {
    const videoPlayer = document.getElementById('video-player');
    if (!videoPlayer) return;
    const frameDuration = 1 / timelineState.fps;
    videoPlayer.currentTime = Math.max(videoPlayer.currentTime - frameDuration, 0);
    timelineState.currentTime = videoPlayer.currentTime;
    updateTimeline();
}

// Play/Pause toggle
function togglePlayPause() {
    const videoPlayer = document.getElementById('video-player');
    if (!videoPlayer) return;

    if (videoPlayer.paused) {
        videoPlayer.play();
        if (playPauseBtn) playPauseBtn.textContent = '⏸ Pause';
    } else {
        videoPlayer.pause();
        if (playPauseBtn) playPauseBtn.textContent = '▶ Play';
    }
}

// Set in/out points
function setInPoint() {
    const videoPlayer = document.getElementById('video-player');
    if (!videoPlayer) return;
    timelineState.inPoint = videoPlayer.currentTime;
    startTimeInput.value = timelineState.inPoint;
    updateTimeline();
}

function setOutPoint() {
    const videoPlayer = document.getElementById('video-player');
    if (!videoPlayer) return;
    timelineState.outPoint = videoPlayer.currentTime;
    endTimeInput.value = timelineState.outPoint;
    updateTimeline();
}

// Go to in/out points
function goToIn() {
    const videoPlayer = document.getElementById('video-player');
    if (!videoPlayer) return;
    videoPlayer.currentTime = timelineState.inPoint;
    timelineState.currentTime = timelineState.inPoint;
    updateTimeline();
}

function goToOut() {
    const videoPlayer = document.getElementById('video-player');
    if (!videoPlayer) return;
    videoPlayer.currentTime = timelineState.outPoint;
    timelineState.currentTime = timelineState.outPoint;
    updateTimeline();
}

// Timeline click/drag handling
function handleTimelineClick(e) {
    const videoPlayer = document.getElementById('video-player');
    if (!timelineTrack || !videoPlayer) return;

    const rect = timelineTrack.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const percent = x / rect.width;
    const newTime = percent * timelineState.duration;

    videoPlayer.currentTime = newTime;
    timelineState.currentTime = newTime;
    updateTimeline();
}

function handleTimelineDragStart(e, type) {
    e.stopPropagation();

    if (type === 'handle') {
        timelineState.isDraggingHandle = true;
    } else if (type === 'in') {
        timelineState.isDraggingInMarker = true;
    } else if (type === 'out') {
        timelineState.isDraggingOutMarker = true;
    }

    document.addEventListener('mousemove', handleTimelineDrag);
    document.addEventListener('mouseup', handleTimelineDragEnd);
}

function handleTimelineDrag(e) {
    const videoPlayer = document.getElementById('video-player');
    if (!timelineTrack || !videoPlayer) return;

    const rect = timelineTrack.getBoundingClientRect();
    const x = Math.max(0, Math.min(e.clientX - rect.left, rect.width));
    const percent = x / rect.width;
    const newTime = percent * timelineState.duration;

    if (timelineState.isDraggingHandle) {
        videoPlayer.currentTime = newTime;
        timelineState.currentTime = newTime;
    } else if (timelineState.isDraggingInMarker) {
        timelineState.inPoint = Math.min(newTime, timelineState.outPoint - 0.1);
        startTimeInput.value = timelineState.inPoint;
    } else if (timelineState.isDraggingOutMarker) {
        timelineState.outPoint = Math.max(newTime, timelineState.inPoint + 0.1);
        endTimeInput.value = timelineState.outPoint;
    }

    updateTimeline();
}

function handleTimelineDragEnd() {
    timelineState.isDraggingHandle = false;
    timelineState.isDraggingInMarker = false;
    timelineState.isDraggingOutMarker = false;

    document.removeEventListener('mousemove', handleTimelineDrag);
    document.removeEventListener('mouseup', handleTimelineDragEnd);
}

// Keyboard shortcuts
function handleKeyboardShortcuts(e) {
    // Ignore if typing in input field
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
        return;
    }

    switch(e.key) {
        case ' ':
            e.preventDefault();
            togglePlayPause();
            break;
        case 'ArrowLeft':
            e.preventDefault();
            goToPreviousFrame();
            break;
        case 'ArrowRight':
            e.preventDefault();
            goToNextFrame();
            break;
        case 'i':
        case 'I':
            e.preventDefault();
            if (e.shiftKey) {
                goToIn();
            } else {
                setInPoint();
            }
            break;
        case 'o':
        case 'O':
            e.preventDefault();
            if (e.shiftKey) {
                goToOut();
            } else {
                setOutPoint();
            }
            break;
    }
}

// Sync inputs with timeline
function syncInputsWithTimeline() {
    if (startTimeInput) {
        startTimeInput.addEventListener('input', () => {
            timelineState.inPoint = parseFloat(startTimeInput.value) || 0;
            updateTimeline();
        });
    }

    if (endTimeInput) {
        endTimeInput.addEventListener('input', () => {
            timelineState.outPoint = parseFloat(endTimeInput.value) || timelineState.duration;
            updateTimeline();
        });
    }
}

// Initialize timeline editor
function setupTimelineEditor() {
    // Button event listeners
    if (frameBackBtn) frameBackBtn.addEventListener('click', goToPreviousFrame);
    if (frameForwardBtn) frameForwardBtn.addEventListener('click', goToNextFrame);
    if (playPauseBtn) playPauseBtn.addEventListener('click', togglePlayPause);
    if (setInBtn) setInBtn.addEventListener('click', setInPoint);
    if (setOutBtn) setOutBtn.addEventListener('click', setOutPoint);
    if (goToInBtn) goToInBtn.addEventListener('click', goToIn);
    if (goToOutBtn) goToOutBtn.addEventListener('click', goToOut);

    // Timeline interaction
    if (timelineTrack) {
        timelineTrack.addEventListener('click', handleTimelineClick);
    }

    if (timelineHandle) {
        timelineHandle.addEventListener('mousedown', (e) => handleTimelineDragStart(e, 'handle'));
    }

    if (timelineInMarker) {
        timelineInMarker.addEventListener('mousedown', (e) => handleTimelineDragStart(e, 'in'));
    }

    if (timelineOutMarker) {
        timelineOutMarker.addEventListener('mousedown', (e) => handleTimelineDragStart(e, 'out'));
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', handleKeyboardShortcuts);

    // Video time updates
    if (videoPlayer) {
        videoPlayer.addEventListener('timeupdate', onVideoTimeUpdate);
        videoPlayer.addEventListener('loadedmetadata', () => {
            initializeTimeline(videoPlayer);
        });
    }

    // Sync inputs
    syncInputsWithTimeline();
}

// Call setup when video is loaded
{
    const vp = document.getElementById('video-player');
    if (vp && vp.readyState >= 1) {
        initializeTimeline(vp);
    }
}

// Export for external use
window.timelineEditor = {
    initialize: initializeTimeline,
    update: updateTimeline,
    setup: setupTimelineEditor
};

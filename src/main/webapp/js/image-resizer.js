// Image Resizer - 8gwifi.org
(function () {
  const images = []; // Store image data
  const MAX_FILES = 10;
  const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB

  const uploadArea = document.getElementById('uploadArea');
  const fileInput = document.getElementById('fileInput');
  const imageGrid = document.getElementById('imageGrid');
  const batchActions = document.getElementById('batchActions');
  const presetsSection = document.getElementById('presetsSection');

  // Social Media Presets
  const PRESETS = {
    'Instagram': [
      { name: 'Post (Square)', width: 1080, height: 1080, icon: '📷' },
      { name: 'Post (Portrait)', width: 1080, height: 1350, icon: '📱' },
      { name: 'Story/Reels', width: 1080, height: 1920, icon: '📹' }
    ],
    'Facebook': [
      { name: 'Cover Photo', width: 820, height: 312, icon: '🖼️' },
      { name: 'Post Image', width: 1200, height: 630, icon: '📄' },
      { name: 'Profile Picture', width: 180, height: 180, icon: '👤' }
    ],
    'Twitter/X': [
      { name: 'Header', width: 1500, height: 500, icon: '🐦' },
      { name: 'Post Image', width: 1200, height: 675, icon: '💬' }
    ],
    'LinkedIn': [
      { name: 'Cover Photo', width: 1584, height: 396, icon: '💼' },
      { name: 'Post Image', width: 1200, height: 627, icon: '📊' }
    ],
    'YouTube': [
      { name: 'Thumbnail', width: 1280, height: 720, icon: '🎬' },
      { name: 'Channel Art', width: 2560, height: 1440, icon: '🎨' }
    ],
    'Web': [
      { name: 'Blog Header', width: 1200, height: 630, icon: '📝' },
      { name: 'Website Banner', width: 1920, height: 500, icon: '🌐' },
      { name: 'Thumbnail', width: 300, height: 300, icon: '🔲' }
    ]
  };

  // Initialize presets
  function initPresets() {
    const presetGrid = document.getElementById('presetGrid');
    presetGrid.innerHTML = '';

    Object.keys(PRESETS).forEach(platform => {
      PRESETS[platform].forEach(preset => {
        const btn = document.createElement('button');
        btn.className = 'preset-btn';
        btn.onclick = () => applyPreset(preset.width, preset.height);
        btn.innerHTML = `
          <strong>${preset.icon} ${platform}</strong>
          <small>${preset.name}<br>${preset.width}×${preset.height}px</small>
        `;
        presetGrid.appendChild(btn);
      });
    });
  }

  // Drag and drop events
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
    const files = Array.from(e.dataTransfer.files).filter(f => f.type.startsWith('image/'));
    handleFiles(files);
  });

  // File input change
  fileInput.addEventListener('change', (e) => {
    handleFiles(Array.from(e.target.files));
  });

  // Click to upload
  uploadArea.addEventListener('click', (e) => {
    if (e.target.tagName !== 'BUTTON') {
      fileInput.click();
    }
  });

  function handleFiles(files) {
    if (images.length >= MAX_FILES) {
      alert(`Maximum ${MAX_FILES} files allowed!`);
      return;
    }

    const remainingSlots = MAX_FILES - images.length;
    const filesToProcess = files.slice(0, remainingSlots);

    filesToProcess.forEach(file => {
      if (file.size > MAX_FILE_SIZE) {
        alert(`${file.name} is too large. Max size is 10MB.`);
        return;
      }

      const reader = new FileReader();
      reader.onload = (e) => {
        const img = new Image();
        img.onload = () => {
          const imageData = {
            id: Date.now() + Math.random(),
            file: file,
            originalSrc: e.target.result,
            originalWidth: img.width,
            originalHeight: img.height,
            newWidth: img.width,
            newHeight: img.height,
            mode: 'pixels', // 'pixels' or 'percentage'
            percentage: 100,
            aspectRatioLocked: true,
            quality: 92, // Quality 0-100
            outputFormat: file.type // Output format
          };
          images.push(imageData);
          renderImageCard(imageData);
          updateBatchActionsVisibility();
        };
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    });
  }

  function renderImageCard(imageData) {
    const card = document.createElement('div');
    card.className = 'image-card';
    card.style.position = 'relative';
    card.id = `card-${imageData.id}`;

    card.innerHTML = `
      <button class="remove-btn" onclick="removeImage(${imageData.id})" title="Remove">&times;</button>
      <img src="${imageData.originalSrc}" class="image-preview" alt="Preview">
      <div class="image-controls">
        <div class="file-info">
          <strong>${imageData.file.name}</strong><br>
          Original: ${imageData.originalWidth} × ${imageData.originalHeight}px
        </div>

        <div class="mode-switch mt-2">
          <button onclick="switchMode(${imageData.id}, 'pixels')" class="active" id="mode-pixels-${imageData.id}">Pixels</button>
          <button onclick="switchMode(${imageData.id}, 'percentage')" id="mode-percentage-${imageData.id}">Percentage</button>
        </div>

        <div class="aspect-ratio-toggle">
          <div class="form-check">
            <input class="form-check-input" type="checkbox" id="aspect-${imageData.id}" checked onchange="toggleAspectRatio(${imageData.id})">
            <label class="form-check-label small" for="aspect-${imageData.id}">
              🔒 Lock aspect ratio
            </label>
          </div>
        </div>

        <div id="controls-${imageData.id}">
          ${renderControls(imageData)}
        </div>

        <div class="dimension-info mt-2" id="info-${imageData.id}">
          New size: ${imageData.newWidth} × ${imageData.newHeight}px
        </div>

        <!-- Format Converter -->
        <div class="format-section">
          <label class="form-label small mb-1"><strong>Output Format</strong></label>
          <select class="form-select form-select-sm" id="format-${imageData.id}" onchange="updateFormat(${imageData.id}, this.value)">
            <option value="image/jpeg" ${imageData.outputFormat === 'image/jpeg' ? 'selected' : ''}>JPG</option>
            <option value="image/png" ${imageData.outputFormat === 'image/png' ? 'selected' : ''}>PNG</option>
            <option value="image/webp" ${imageData.outputFormat === 'image/webp' ? 'selected' : ''}>WEBP</option>
          </select>
        </div>

        <!-- Quality Slider -->
        <div class="quality-section">
          <label class="form-label small mb-1"><strong>Quality: <span id="quality-val-${imageData.id}">${imageData.quality}%</span></strong></label>
          <input type="range" class="form-range" min="10" max="100" value="${imageData.quality}"
            oninput="updateQuality(${imageData.id}, this.value)" id="quality-${imageData.id}">
          <small class="text-muted" id="size-est-${imageData.id}">Est. size: calculating...</small>
        </div>

        <button class="btn btn-primary btn-sm btn-download" onclick="downloadImage(${imageData.id})">
          Download ${imageData.outputFormat.split('/')[1].toUpperCase()}
        </button>
      </div>
    `;

    imageGrid.appendChild(card);
  }

  function renderControls(imageData) {
    if (imageData.mode === 'pixels') {
      return `
        <div class="slider-group">
          <label>Width (px)</label>
          <div class="slider-container">
            <input type="range" min="1" max="${imageData.originalWidth * 2}" value="${imageData.newWidth}"
              oninput="updateDimension(${imageData.id}, 'width', this.value)" class="form-range">
            <input type="number" min="1" value="${imageData.newWidth}"
              onchange="updateDimension(${imageData.id}, 'width', this.value)" class="form-control form-control-sm">
          </div>
        </div>
        <div class="slider-group">
          <label>Height (px)</label>
          <div class="slider-container">
            <input type="range" min="1" max="${imageData.originalHeight * 2}" value="${imageData.newHeight}"
              oninput="updateDimension(${imageData.id}, 'height', this.value)" class="form-range">
            <input type="number" min="1" value="${imageData.newHeight}"
              onchange="updateDimension(${imageData.id}, 'height', this.value)" class="form-control form-control-sm">
          </div>
        </div>
      `;
    } else {
      return `
        <div class="slider-group">
          <label>Scale (%)</label>
          <div class="slider-container">
            <input type="range" min="1" max="200" value="${imageData.percentage}"
              oninput="updatePercentage(${imageData.id}, this.value)" class="form-range">
            <input type="number" min="1" max="200" value="${imageData.percentage}"
              onchange="updatePercentage(${imageData.id}, this.value)" class="form-control form-control-sm">
          </div>
        </div>
      `;
    }
  }

  window.switchMode = function(id, mode) {
    const imageData = images.find(img => img.id === id);
    if (!imageData) return;

    imageData.mode = mode;

    // Update button states
    document.getElementById(`mode-pixels-${id}`).classList.toggle('active', mode === 'pixels');
    document.getElementById(`mode-percentage-${id}`).classList.toggle('active', mode === 'percentage');

    // Re-render controls
    document.getElementById(`controls-${id}`).innerHTML = renderControls(imageData);
  };

  window.toggleAspectRatio = function(id) {
    const imageData = images.find(img => img.id === id);
    if (!imageData) return;
    imageData.aspectRatioLocked = document.getElementById(`aspect-${id}`).checked;
  };

  window.updateDimension = function(id, dimension, value) {
    const imageData = images.find(img => img.id === id);
    if (!imageData) return;

    value = parseInt(value);
    if (isNaN(value) || value < 1) return;

    if (dimension === 'width') {
      imageData.newWidth = value;
      if (imageData.aspectRatioLocked) {
        imageData.newHeight = Math.round((value / imageData.originalWidth) * imageData.originalHeight);
      }
    } else {
      imageData.newHeight = value;
      if (imageData.aspectRatioLocked) {
        imageData.newWidth = Math.round((value / imageData.originalHeight) * imageData.originalWidth);
      }
    }

    // Update percentage based on new dimensions
    imageData.percentage = Math.round((imageData.newWidth / imageData.originalWidth) * 100);

    // Re-render controls to update all values
    document.getElementById(`controls-${id}`).innerHTML = renderControls(imageData);
    updateInfo(id);
  };

  window.updatePercentage = function(id, value) {
    const imageData = images.find(img => img.id === id);
    if (!imageData) return;

    value = parseInt(value);
    if (isNaN(value) || value < 1) return;

    imageData.percentage = value;
    imageData.newWidth = Math.round((value / 100) * imageData.originalWidth);
    imageData.newHeight = Math.round((value / 100) * imageData.originalHeight);

    updateInfo(id);
  };

  function updateInfo(id) {
    const imageData = images.find(img => img.id === id);
    if (!imageData) return;

    const fileSize = estimateFileSize(imageData);
    document.getElementById(`info-${id}`).innerHTML = `
      New size: ${imageData.newWidth} × ${imageData.newHeight}px<br>
      <small>Est. file size: ${fileSize}</small>
    `;
  }

  function estimateFileSize(imageData) {
    const originalSize = imageData.file.size;
    const scaleFactor = (imageData.newWidth * imageData.newHeight) / (imageData.originalWidth * imageData.originalHeight);
    const qualityFactor = (imageData.quality / 100);
    const estimatedSize = originalSize * scaleFactor * qualityFactor;

    // Update quality section estimate
    if (document.getElementById(`size-est-${imageData.id}`)) {
      let sizeStr;
      if (estimatedSize < 1024) sizeStr = estimatedSize.toFixed(0) + ' B';
      else if (estimatedSize < 1024 * 1024) sizeStr = (estimatedSize / 1024).toFixed(1) + ' KB';
      else sizeStr = (estimatedSize / (1024 * 1024)).toFixed(1) + ' MB';
      document.getElementById(`size-est-${imageData.id}`).textContent = `Est. size: ${sizeStr}`;
    }

    if (estimatedSize < 1024) return estimatedSize.toFixed(0) + ' B';
    if (estimatedSize < 1024 * 1024) return (estimatedSize / 1024).toFixed(1) + ' KB';
    return (estimatedSize / (1024 * 1024)).toFixed(1) + ' MB';
  }

  window.removeImage = function(id) {
    const index = images.findIndex(img => img.id === id);
    if (index > -1) {
      images.splice(index, 1);
      document.getElementById(`card-${id}`).remove();
      updateBatchActionsVisibility();
    }
  };

  window.clearAll = function() {
    if (confirm('Remove all images?')) {
      images.length = 0;
      imageGrid.innerHTML = '';
      updateBatchActionsVisibility();
    }
  };

  function updateBatchActionsVisibility() {
    batchActions.style.display = images.length > 0 ? 'block' : 'none';
    presetsSection.style.display = images.length > 0 ? 'block' : 'none';
  }

  // Apply preset dimensions to all images
  window.applyPreset = function(width, height) {
    if (images.length === 0) return;

    images.forEach(imageData => {
      imageData.newWidth = width;
      imageData.newHeight = height;
      imageData.aspectRatioLocked = false;
      imageData.percentage = Math.round((width / imageData.originalWidth) * 100);

      // Update checkbox
      document.getElementById(`aspect-${imageData.id}`).checked = false;

      // Re-render controls
      document.getElementById(`controls-${imageData.id}`).innerHTML = renderControls(imageData);
      updateInfo(imageData.id);
    });

    alert(`All images resized to ${width}×${height}px!`);
  };

  // Update output format
  window.updateFormat = function(id, format) {
    const imageData = images.find(img => img.id === id);
    if (!imageData) return;

    imageData.outputFormat = format;
    updateInfo(id);
  };

  // Update quality slider
  window.updateQuality = function(id, quality) {
    const imageData = images.find(img => img.id === id);
    if (!imageData) return;

    imageData.quality = parseInt(quality);
    document.getElementById(`quality-val-${id}`).textContent = quality + '%';
    updateInfo(id);
  };

  window.applyBatchSettings = function() {
    const width = parseInt(document.getElementById('batchWidth').value);
    const height = parseInt(document.getElementById('batchHeight').value);
    const lockRatio = document.getElementById('batchAspectRatio').checked;

    if (isNaN(width) && isNaN(height)) {
      alert('Please enter width or height');
      return;
    }

    images.forEach(imageData => {
      if (!isNaN(width)) {
        imageData.newWidth = width;
        if (lockRatio) {
          imageData.newHeight = Math.round((width / imageData.originalWidth) * imageData.originalHeight);
        } else if (!isNaN(height)) {
          imageData.newHeight = height;
        }
      } else if (!isNaN(height)) {
        imageData.newHeight = height;
        if (lockRatio) {
          imageData.newWidth = Math.round((height / imageData.originalHeight) * imageData.originalWidth);
        }
      }

      imageData.percentage = Math.round((imageData.newWidth / imageData.originalWidth) * 100);
      imageData.aspectRatioLocked = lockRatio;

      // Update checkbox
      document.getElementById(`aspect-${imageData.id}`).checked = lockRatio;

      // Re-render controls
      document.getElementById(`controls-${imageData.id}`).innerHTML = renderControls(imageData);
      updateInfo(imageData.id);
    });

    alert('Settings applied to all images!');
  };

  window.downloadImage = function(id) {
    const imageData = images.find(img => img.id === id);
    if (!imageData) return;

    resizeAndDownload(imageData);
  };

  function resizeAndDownload(imageData) {
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');

    canvas.width = imageData.newWidth;
    canvas.height = imageData.newHeight;

    const img = new Image();
    img.onload = () => {
      ctx.drawImage(img, 0, 0, imageData.newWidth, imageData.newHeight);

      // Use selected format and quality
      const format = imageData.outputFormat;
      const quality = imageData.quality / 100; // Convert to 0-1 range

      canvas.toBlob((blob) => {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        const extension = format.split('/')[1];
        a.href = url;
        a.download = `8gwifi.org-resized-${imageData.newWidth}x${imageData.newHeight}-${Date.now()}.${extension}`;
        a.click();
        URL.revokeObjectURL(url);
      }, format, quality);
    };
    img.src = imageData.originalSrc;
  }

  window.downloadAll = async function() {
    if (images.length === 0) return;

    const zip = new JSZip();
    const promises = [];

    images.forEach((imageData, index) => {
      const promise = new Promise((resolve) => {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');

        canvas.width = imageData.newWidth;
        canvas.height = imageData.newHeight;

        const img = new Image();
        img.onload = () => {
          ctx.drawImage(img, 0, 0, imageData.newWidth, imageData.newHeight);

          const format = imageData.outputFormat;
          const quality = imageData.quality / 100;

          canvas.toBlob((blob) => {
            const extension = format.split('/')[1];
            const filename = `resized-${imageData.newWidth}x${imageData.newHeight}-${index + 1}.${extension}`;
            zip.file(filename, blob);
            resolve();
          }, format, quality);
        };
        img.src = imageData.originalSrc;
      });
      promises.push(promise);
    });

    // Wait for all images to be processed
    await Promise.all(promises);

    // Generate ZIP file
    zip.generateAsync({ type: 'blob' }).then((content) => {
      const url = URL.createObjectURL(content);
      const a = document.createElement('a');
      a.href = url;
      a.download = `8gwifi.org-resized-images-${Date.now()}.zip`;
      a.click();
      URL.revokeObjectURL(url);
    });
  };

  // Initialize presets on page load
  window.addEventListener('DOMContentLoaded', () => {
    initPresets();
  });
})();

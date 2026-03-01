/* hexdump-core.js — IDE-style orchestrator: state + events
   Depends: window.HexEngine, window.HexRender, window.HexExport, window.HexEditor, window.HexAnalyzer */
(function() {
    'use strict';

    var E = window.HexEngine;
    var R = window.HexRender;
    var X = window.HexExport;
    var Ed = window.HexEditor;
    var A = window.HexAnalyzer;

    // ===== State =====
    var state = {
        data: null,
        fileName: '',
        format: 'hex',
        bytesPerLine: 16,
        grouping: 1,
        showAscii: true,
        showOffset: true,
        searchMatches: [],
        searchPatternLen: 0,
        selectedByte: -1,
        editMode: false,
        nibbleBuffer: '',    // partial typed input for current byte (e.g. "A" waiting for second nibble)
        analysis: null       // HexAnalyzer result
    };

    // ===== DOM References =====
    var els = {};

    function $(id) { return document.getElementById(id); }

    function init() {
        // Cache DOM refs
        els.hexDisplay = $('hx-hex-display');
        els.statsPanel = $('hx-stats-panel');
        els.byteInfoPanel = $('hx-byte-info-panel');
        els.fileInput = $('hx-file-input');
        els.textInput = $('hx-text-input');
        els.hexInput = $('hx-hex-input');
        els.searchInput = $('hx-search-input');
        els.matchCount = $('hx-match-count');
        els.gotoInput = $('hx-goto-input');
        els.bytesPerLine = $('hx-bytes-per-line');
        els.byteGrouping = $('hx-byte-grouping');
        els.showAscii = $('hx-show-ascii');
        els.showOffset = $('hx-show-offset');
        els.inspector = $('hx-inspector');
        els.statusBar = $('hx-status-bar');
        els.toolbar = $('hx-toolbar');

        // Format toggle (pills)
        wireFormatToggle();

        // Full-page drag & drop
        wireFullPageDrop();

        // File input (Open button)
        var openBtn = $('hx-open-btn');
        if (openBtn) {
            openBtn.addEventListener('click', function() {
                if (els.fileInput) els.fileInput.click();
            });
        }
        if (els.fileInput) {
            els.fileInput.addEventListener('change', function(e) {
                var file = e.target.files[0];
                if (file) processFile(file);
            });
        }

        // Popovers (Text / Hex paste)
        wirePopovers();

        // Text input button
        var textBtn = $('hx-text-btn');
        if (textBtn) {
            textBtn.addEventListener('click', function() {
                processTextInput();
                closeAllPopovers();
            });
        }

        // Hex input button
        var hexBtn = $('hx-hex-btn');
        if (hexBtn) {
            hexBtn.addEventListener('click', function() {
                processHexInput();
                closeAllPopovers();
            });
        }

        // Settings
        if (els.bytesPerLine) els.bytesPerLine.addEventListener('change', function() {
            state.bytesPerLine = parseInt(this.value, 10);
            updateDisplay();
            updateStatusBar();
        });
        if (els.byteGrouping) els.byteGrouping.addEventListener('change', function() {
            state.grouping = parseInt(this.value, 10);
            updateDisplay();
        });
        if (els.showAscii) els.showAscii.addEventListener('change', function() {
            state.showAscii = this.checked;
            updateDisplay();
        });
        if (els.showOffset) els.showOffset.addEventListener('change', function() {
            state.showOffset = this.checked;
            updateDisplay();
        });

        // Search
        if (els.searchInput) {
            var searchTimer = null;
            els.searchInput.addEventListener('input', function() {
                clearTimeout(searchTimer);
                searchTimer = setTimeout(doSearch, 300);
            });
        }

        // Go to offset
        var gotoBtn = $('hx-goto-btn');
        if (gotoBtn) {
            gotoBtn.addEventListener('click', goToOffset);
        }
        if (els.gotoInput) {
            els.gotoInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') goToOffset();
            });
        }

        // Byte click delegation
        if (els.hexDisplay) {
            els.hexDisplay.addEventListener('click', function(e) {
                var byteEl = e.target.closest('.hx-byte[data-index]');
                if (!byteEl) return;
                var idx = parseInt(byteEl.getAttribute('data-index'), 10);
                if (isNaN(idx) || !state.data || idx >= state.data.length) return;

                // Cancel any in-progress nibble input
                cancelNibble();

                selectByte(idx);
            });
        }

        // Toolbar action buttons
        wireToolbar();

        // Export dropdown menu
        wireExportMenu();

        // Inspector toggle
        wireInspectorToggle();

        // Structure panel toggle
        wireStructureToggle();

        // Edit mode
        wireEditMode();

        // Keyboard shortcuts
        wireKeyboard();

        // Check URL params
        checkUrlParams();

        // Initial status bar
        updateStatusBar();
    }

    // ===== Format Toggle (pills) =====
    function wireFormatToggle() {
        var btns = document.querySelectorAll('.hx-format-pill');
        for (var i = 0; i < btns.length; i++) {
            btns[i].addEventListener('click', function() {
                var fmt = this.getAttribute('data-format');
                state.format = fmt;
                for (var j = 0; j < btns.length; j++) btns[j].classList.remove('active');
                this.classList.add('active');
                cancelNibble();
                updateDisplay();
                updateStatusBar();
            });
        }
    }

    // ===== Full-Page Drag & Drop =====
    function wireFullPageDrop() {
        var overlay = $('hx-drop-overlay');
        if (!overlay) return;

        var dragCounter = 0;

        document.addEventListener('dragenter', function(e) {
            e.preventDefault();
            dragCounter++;
            if (dragCounter === 1) {
                overlay.classList.add('visible');
            }
        });

        document.addEventListener('dragleave', function(e) {
            e.preventDefault();
            dragCounter--;
            if (dragCounter <= 0) {
                dragCounter = 0;
                overlay.classList.remove('visible');
            }
        });

        document.addEventListener('dragover', function(e) {
            e.preventDefault();
        });

        document.addEventListener('drop', function(e) {
            e.preventDefault();
            dragCounter = 0;
            overlay.classList.remove('visible');
            var file = e.dataTransfer && e.dataTransfer.files[0];
            if (file) processFile(file);
        });
    }

    // ===== Popovers =====
    function wirePopovers() {
        var textBtn = $('hx-paste-text-btn');
        var hexBtn = $('hx-paste-hex-btn');
        var textPop = $('hx-text-popover');
        var hexPop = $('hx-hex-popover');

        if (textBtn && textPop) {
            textBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                var isOpen = textPop.classList.contains('visible');
                closeAllPopovers();
                if (!isOpen) {
                    positionPopover(textPop, textBtn);
                    textPop.classList.add('visible');
                    var ta = textPop.querySelector('textarea');
                    if (ta) ta.focus();
                }
            });
        }

        if (hexBtn && hexPop) {
            hexBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                var isOpen = hexPop.classList.contains('visible');
                closeAllPopovers();
                if (!isOpen) {
                    positionPopover(hexPop, hexBtn);
                    hexPop.classList.add('visible');
                    var ta = hexPop.querySelector('textarea');
                    if (ta) ta.focus();
                }
            });
        }

        // Close on click outside
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.hx-popover') && !e.target.closest('#hx-paste-text-btn') && !e.target.closest('#hx-paste-hex-btn')) {
                closeAllPopovers();
            }
        });
    }

    function positionPopover(popover, anchor) {
        var rect = anchor.getBoundingClientRect();
        popover.style.position = 'fixed';
        popover.style.top = (rect.bottom + 4) + 'px';
        popover.style.left = Math.max(8, rect.left) + 'px';
    }

    function closeAllPopovers() {
        var pops = document.querySelectorAll('.hx-popover');
        for (var i = 0; i < pops.length; i++) pops[i].classList.remove('visible');
        var menu = $('hx-export-menu');
        if (menu) menu.classList.remove('visible');
    }

    // ===== Export Dropdown Menu =====
    function wireExportMenu() {
        var btn = $('hx-export-btn');
        var menu = $('hx-export-menu');
        if (!btn || !menu) return;

        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            var isOpen = menu.classList.contains('visible');
            closeAllPopovers();
            if (!isOpen) {
                menu.classList.add('visible');
            }
        });

        document.addEventListener('click', function(e) {
            if (!e.target.closest('#hx-export-menu') && !e.target.closest('#hx-export-btn')) {
                menu.classList.remove('visible');
            }
        });
    }

    // ===== Inspector Toggle =====
    function wireInspectorToggle() {
        var btn = $('hx-inspector-toggle');
        if (!btn || !els.inspector) return;

        btn.addEventListener('click', function() {
            var hidden = els.inspector.classList.toggle('hidden');
            btn.classList.toggle('active', !hidden);
        });
    }

    // ===== Keyboard Shortcuts =====
    function wireKeyboard() {
        document.addEventListener('keydown', function(e) {
            // Don't intercept when focus is in an input/textarea/select
            var tag = e.target.tagName;
            if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') return;

            // Ctrl+O: open file
            if ((e.ctrlKey || e.metaKey) && e.key === 'o') {
                e.preventDefault();
                if (els.fileInput) els.fileInput.click();
                return;
            }
            // Ctrl+Z: undo
            if ((e.ctrlKey || e.metaKey) && e.key === 'z' && !e.shiftKey) {
                if (state.editMode && Ed.canUndo()) {
                    e.preventDefault();
                    cancelNibble();
                    performUndo();
                    return;
                }
            }
            // Ctrl+Y or Ctrl+Shift+Z: redo
            if ((e.ctrlKey || e.metaKey) && (e.key === 'y' || (e.key === 'z' && e.shiftKey) || (e.key === 'Z' && e.shiftKey))) {
                if (state.editMode && Ed.canRedo()) {
                    e.preventDefault();
                    cancelNibble();
                    performRedo();
                    return;
                }
            }
            // Ctrl+F: focus search
            if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
                if (els.searchInput) {
                    e.preventDefault();
                    els.searchInput.focus();
                    els.searchInput.select();
                }
                return;
            }
            // Ctrl+G: focus goto
            if ((e.ctrlKey || e.metaKey) && e.key === 'g') {
                if (els.gotoInput) {
                    e.preventDefault();
                    els.gotoInput.focus();
                    els.gotoInput.select();
                }
                return;
            }
            // Don't process other shortcuts if Ctrl/Meta held
            if (e.ctrlKey || e.metaKey) return;

            // Escape: cancel nibble or close popovers
            if (e.key === 'Escape') {
                if (state.nibbleBuffer) {
                    cancelNibble();
                } else {
                    closeAllPopovers();
                }
                return;
            }

            // Arrow key navigation (always works when a byte is selected)
            if (state.selectedByte >= 0 && state.data) {
                var navIdx = -1;
                if (e.key === 'ArrowRight' || (e.key === 'Tab' && !e.shiftKey)) {
                    navIdx = state.selectedByte + 1;
                } else if (e.key === 'ArrowLeft' || (e.key === 'Tab' && e.shiftKey)) {
                    navIdx = state.selectedByte - 1;
                } else if (e.key === 'ArrowDown') {
                    navIdx = state.selectedByte + state.bytesPerLine;
                } else if (e.key === 'ArrowUp') {
                    navIdx = state.selectedByte - state.bytesPerLine;
                }
                if (navIdx >= 0 && navIdx < state.data.length) {
                    e.preventDefault();
                    cancelNibble();
                    selectByte(navIdx);
                    R.scrollToOffset(els.hexDisplay, navIdx, state.bytesPerLine);
                    return;
                } else if (e.key === 'Tab' || e.key.startsWith('Arrow')) {
                    e.preventDefault();
                    return;
                }
            }

            // Direct typing — only in edit mode with a selected byte
            if (state.editMode && state.selectedByte >= 0 && state.data && e.key.length === 1) {
                var ch = e.key;
                if (isValidChar(ch, state.format)) {
                    e.preventDefault();
                    handleNibbleInput(ch);
                    return;
                }
            }

            // Backspace in edit mode — delete nibble buffer or go to previous byte
            if (e.key === 'Backspace' && state.editMode && state.selectedByte >= 0) {
                e.preventDefault();
                if (state.nibbleBuffer) {
                    state.nibbleBuffer = state.nibbleBuffer.slice(0, -1);
                    updateNibbleDisplay();
                } else if (state.selectedByte > 0) {
                    selectByte(state.selectedByte - 1);
                    R.scrollToOffset(els.hexDisplay, state.selectedByte, state.bytesPerLine);
                }
                return;
            }

            // Delete key — delete byte at cursor
            if (e.key === 'Delete' && state.editMode && state.selectedByte >= 0 && state.data) {
                e.preventDefault();
                cancelNibble();
                var idx = state.selectedByte;
                Ed.deleteByte(idx);
                syncDataFromEditor();
                if (idx >= state.data.length && state.data.length > 0) idx = state.data.length - 1;
                state.selectedByte = state.data.length > 0 ? idx : -1;
                updateDisplay();
                updateStatusBar();
                return;
            }
        });
    }

    // ===== Select Byte =====
    function selectByte(idx) {
        // Deselect previous
        var prev = els.hexDisplay.querySelectorAll('.hx-byte.selected, .hx-byte.editing');
        for (var i = 0; i < prev.length; i++) {
            prev[i].classList.remove('selected');
            prev[i].classList.remove('editing');
        }

        state.selectedByte = idx;
        state.nibbleBuffer = '';

        var byteEl = els.hexDisplay.querySelector('.hx-byte[data-index="' + idx + '"]');
        if (byteEl) {
            byteEl.classList.add('selected');
            if (state.editMode) byteEl.classList.add('editing');
        }

        // Update inspector
        if (state.data && idx >= 0 && idx < state.data.length) {
            R.renderInspectorByteInfo(els.byteInfoPanel, state.data[idx], idx);
            // Show region info if analysis available
            renderByteRegionInfo(idx);
        }
        updateStatusBar();
    }

    // ===== Nibble Input System =====
    function isValidChar(ch, fmt) {
        switch (fmt) {
            case 'hex': return /^[0-9a-fA-F]$/.test(ch);
            case 'dec': return /^[0-9]$/.test(ch);
            case 'oct': return /^[0-7]$/.test(ch);
            case 'bin': return /^[01]$/.test(ch);
            default:    return false;
        }
    }

    function getMaxChars(fmt) {
        switch (fmt) {
            case 'bin': return 8;
            case 'oct': return 3;
            case 'dec': return 3;
            default:    return 2; // hex
        }
    }

    function handleNibbleInput(ch) {
        var maxChars = getMaxChars(state.format);
        state.nibbleBuffer += ch.toUpperCase();

        updateNibbleDisplay();

        // Check if we have a complete byte
        if (state.nibbleBuffer.length >= maxChars) {
            commitNibble();
        }
    }

    function updateNibbleDisplay() {
        var byteEl = els.hexDisplay.querySelector('.hx-byte[data-index="' + state.selectedByte + '"]');
        if (!byteEl) return;

        if (state.nibbleBuffer) {
            // Show partial input — pad with underscores for remaining chars
            var maxChars = getMaxChars(state.format);
            var display = state.nibbleBuffer;
            while (display.length < maxChars) display += '_';
            byteEl.textContent = display;
            byteEl.classList.add('editing');
        } else {
            // Restore original display
            byteEl.textContent = E.formatByte(state.data[state.selectedByte], state.format);
            if (!state.editMode) byteEl.classList.remove('editing');
        }
    }

    function commitNibble() {
        if (!state.nibbleBuffer || state.selectedByte < 0) return;

        var val = Ed.parseByte(state.nibbleBuffer, state.format);
        if (val >= 0) {
            Ed.setByte(state.selectedByte, val);
            syncDataFromEditor();
            // Refresh display to show modified marker
            R.updateData(els.hexDisplay, state.data, Ed.getModifiedIndices());
            R.renderInspectorByteInfo(els.byteInfoPanel, state.data[state.selectedByte], state.selectedByte);
            updateStatusBar();

            // Auto-advance to next byte
            var nextIdx = state.selectedByte + 1;
            if (nextIdx < state.data.length) {
                setTimeout(function() {
                    selectByte(nextIdx);
                    R.scrollToOffset(els.hexDisplay, nextIdx, state.bytesPerLine);
                }, 20);
            } else {
                state.nibbleBuffer = '';
            }
        } else {
            // Invalid — flash the byte red briefly
            var byteEl = els.hexDisplay.querySelector('.hx-byte[data-index="' + state.selectedByte + '"]');
            if (byteEl) {
                byteEl.style.background = '#ef4444';
                setTimeout(function() { byteEl.style.background = ''; }, 300);
            }
            state.nibbleBuffer = '';
            updateNibbleDisplay();
        }
    }

    function cancelNibble() {
        if (state.nibbleBuffer && state.selectedByte >= 0) {
            state.nibbleBuffer = '';
            updateNibbleDisplay();
        }
        state.nibbleBuffer = '';
    }

    // ===== Update Status Bar =====
    function updateStatusBar() {
        var fileEl = $('hx-status-file');
        var sizeEl = $('hx-status-size');
        var offsetEl = $('hx-status-offset');
        var formatEl = $('hx-status-format');

        // File type badge
        var typeEl = $('hx-status-filetype');
        if (typeEl) {
            if (state.analysis && state.analysis.fileType) {
                typeEl.textContent = state.analysis.icon + ' ' + state.analysis.fileType;
                typeEl.classList.remove('hidden');
            } else {
                typeEl.classList.add('hidden');
            }
        }

        if (fileEl) fileEl.textContent = state.fileName || 'No file loaded';
        if (sizeEl) sizeEl.textContent = state.data ? E.formatFileSize(state.data.length) : '0 B';
        if (offsetEl) {
            if (state.selectedByte >= 0 && state.data) {
                offsetEl.textContent = '0x' + ('0000' + state.selectedByte.toString(16).toUpperCase()).slice(-4);
            } else {
                offsetEl.textContent = '-';
            }
        }
        if (formatEl) {
            var fmtNames = { hex: 'Hex', dec: 'Decimal', oct: 'Octal', bin: 'Binary' };
            formatEl.textContent = fmtNames[state.format] || 'Hex';
        }

        // Modified indicator
        var modEl = $('hx-modified-indicator');
        if (modEl) {
            if (Ed && state.data && Ed.isModified()) {
                modEl.textContent = 'Modified (' + Ed.getEditCount() + ' edits)';
                modEl.classList.remove('hidden');
            } else {
                modEl.classList.add('hidden');
            }
        }

        // Update undo/redo button states
        updateEditButtons();
    }

    // ===== Process File =====
    function processFile(file) {
        state.fileName = file.name;
        var reader = new FileReader();
        reader.onload = function(e) {
            state.data = new Uint8Array(e.target.result);
            onDataLoaded();
        };
        reader.readAsArrayBuffer(file);
    }

    // ===== Process Text Input =====
    function processTextInput() {
        var text = els.textInput ? els.textInput.value : '';
        if (!text) return;

        state.fileName = 'text-input';
        var encoder = new TextEncoder();
        state.data = encoder.encode(text);
        onDataLoaded();
    }

    // ===== Process Hex Input =====
    function processHexInput() {
        var hex = els.hexInput ? els.hexInput.value : '';
        if (!hex) return;

        state.fileName = 'hex-input';
        state.data = E.parseHexInput(hex);
        if (state.data.length === 0) return;
        onDataLoaded();
    }

    // ===== On Data Loaded =====
    function onDataLoaded() {
        // Init editor with data
        Ed.init(state.data);

        // Run binary structure analysis
        if (A && A.analyze) {
            try {
                state.analysis = A.analyze(state.data);
            } catch (e) {
                state.analysis = null;
            }
        } else {
            state.analysis = null;
        }

        updateDisplay();

        // Stats — render in inspector panel
        var stats = E.calculateStats(state.data);
        R.renderInspectorStats(els.statsPanel, stats);

        // Reset byte info
        if (els.byteInfoPanel) {
            els.byteInfoPanel.innerHTML = '<div class="hx-inspector-title">Byte Inspector</div><div class="hx-inspector-empty">Click a byte to inspect</div>';
        }

        // Render structure panel
        renderStructurePanel();

        // Clear search
        state.searchMatches = [];
        state.selectedByte = -1;
        state.nibbleBuffer = '';
        if (els.matchCount) els.matchCount.textContent = '';

        // Update status bar
        updateStatusBar();
    }

    // ===== Update Display =====
    function updateDisplay() {
        if (!state.data || !els.hexDisplay) return;
        R.renderHexDump(els.hexDisplay, state.data, {
            format: state.format,
            bytesPerLine: state.bytesPerLine,
            grouping: state.grouping,
            showAscii: state.showAscii,
            showOffset: state.showOffset,
            modifiedSet: Ed ? Ed.getModifiedIndices() : null,
            regionMap: state.analysis ? state.analysis.regionMap : null
        });

        // Re-apply highlights if any
        if (state.searchMatches.length > 0) {
            setTimeout(function() {
                R.highlightBytes(els.hexDisplay, state.searchMatches, state.searchPatternLen);
            }, 50);
        }
    }

    // ===== Search =====
    function doSearch() {
        R.clearHighlights(els.hexDisplay);
        state.searchMatches = [];
        state.searchPatternLen = 0;

        var pattern = els.searchInput ? els.searchInput.value.trim() : '';
        if (!pattern || !state.data) {
            if (els.matchCount) els.matchCount.innerHTML = '';
            return;
        }

        // Parse hex pattern
        var tokens = pattern.split(/\s+/);
        var patternBytes = [];
        for (var i = 0; i < tokens.length; i++) {
            var val = parseInt(tokens[i], 16);
            if (!isNaN(val) && val >= 0 && val <= 255) patternBytes.push(val);
        }
        if (patternBytes.length === 0) {
            if (els.matchCount) els.matchCount.innerHTML = '';
            return;
        }

        state.searchPatternLen = patternBytes.length;
        state.searchMatches = E.searchPattern(state.data, patternBytes);

        if (els.matchCount) {
            els.matchCount.textContent = state.searchMatches.length + (state.searchMatches.length !== 1 ? ' matches' : ' match');
        }

        if (state.searchMatches.length > 0) {
            R.highlightBytes(els.hexDisplay, state.searchMatches, patternBytes.length);
            R.scrollToOffset(els.hexDisplay, state.searchMatches[0], state.bytesPerLine);
        }

        updateStatusBar();
    }

    // ===== Go To Offset =====
    function goToOffset() {
        var val = els.gotoInput ? els.gotoInput.value.trim() : '';
        if (!val || !state.data) return;

        var offset = parseInt(val, 16);
        if (isNaN(offset) || offset < 0 || offset >= state.data.length) return;

        R.scrollToOffset(els.hexDisplay, offset, state.bytesPerLine);
    }

    // ===== Toolbar =====
    function wireToolbar() {
        var copyBtn = $('hx-copy-btn');
        var dlBtn = $('hx-download-btn');
        var cBtn = $('hx-export-c');
        var pyBtn = $('hx-export-python');
        var goBtn = $('hx-export-go');
        var rustBtn = $('hx-export-rust');

        if (copyBtn) copyBtn.addEventListener('click', function() {
            if (!state.data) return;
            var text = X.buildPlainText(state.data, state);
            X.copyToClipboard(text, function(ok) {
                showToast(ok ? 'Hex dump copied!' : 'Copy failed');
            });
        });

        if (dlBtn) dlBtn.addEventListener('click', function() {
            if (!state.data) return;
            var text = X.buildPlainText(state.data, state);
            X.downloadFile(text, '8gwifi.org-hexdump-' + (state.fileName || 'output') + '.txt');
        });

        if (cBtn) cBtn.addEventListener('click', function() {
            if (!state.data) return;
            var name = state.fileName.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9_]/g, '_') || 'data';
            var code = E.exportAsC(state.data, name);
            X.downloadFile(code, '8gwifi.org-' + name + '.c');
            closeAllPopovers();
        });

        if (pyBtn) pyBtn.addEventListener('click', function() {
            if (!state.data) return;
            var name = state.fileName.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9_]/g, '_') || 'data';
            var code = E.exportAsPython(state.data, name);
            X.downloadFile(code, '8gwifi.org-' + name + '.py');
            closeAllPopovers();
        });

        if (goBtn) goBtn.addEventListener('click', function() {
            if (!state.data) return;
            var name = state.fileName.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9_]/g, '_') || 'data';
            var code = E.exportAsGo(state.data, name);
            X.downloadFile(code, '8gwifi.org-' + name + '.go');
            closeAllPopovers();
        });

        if (rustBtn) rustBtn.addEventListener('click', function() {
            if (!state.data) return;
            var name = state.fileName.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9_]/g, '_') || 'data';
            var code = E.exportAsRust(state.data, name);
            X.downloadFile(code, '8gwifi.org-' + name + '.rs');
            closeAllPopovers();
        });
    }

    // ===== Edit Mode =====
    function wireEditMode() {
        var editBtn = $('hx-edit-toggle');
        var undoBtn = $('hx-undo-btn');
        var redoBtn = $('hx-redo-btn');
        var insertBtn = $('hx-insert-btn');
        var deleteBtn = $('hx-delete-btn');
        var saveBinBtn = $('hx-save-binary-btn');

        if (editBtn) {
            editBtn.addEventListener('click', function() {
                state.editMode = !state.editMode;
                editBtn.classList.toggle('edit-active', state.editMode);
                if (!state.editMode) {
                    cancelNibble();
                    // Remove editing class from all bytes
                    var eds = els.hexDisplay.querySelectorAll('.hx-byte.editing');
                    for (var i = 0; i < eds.length; i++) eds[i].classList.remove('editing');
                } else if (state.selectedByte >= 0) {
                    // Show cursor on selected byte
                    var byteEl = els.hexDisplay.querySelector('.hx-byte[data-index="' + state.selectedByte + '"]');
                    if (byteEl) byteEl.classList.add('editing');
                }
                updateEditButtons();
                updateStatusBar();
            });
        }

        if (undoBtn) undoBtn.addEventListener('click', function() { performUndo(); });
        if (redoBtn) redoBtn.addEventListener('click', function() { performRedo(); });

        if (insertBtn) {
            insertBtn.addEventListener('click', function() {
                if (!state.editMode || !state.data) return;
                cancelNibble();
                var idx = state.selectedByte >= 0 ? state.selectedByte + 1 : state.data.length;
                Ed.insertByte(idx, 0x00);
                syncDataFromEditor();
                state.selectedByte = idx;
                updateDisplay();
                updateStatusBar();
                R.scrollToOffset(els.hexDisplay, idx, state.bytesPerLine);
                setTimeout(function() { selectByte(idx); }, 30);
            });
        }

        if (deleteBtn) {
            deleteBtn.addEventListener('click', function() {
                if (!state.editMode || !state.data || state.selectedByte < 0) return;
                cancelNibble();
                var idx = state.selectedByte;
                Ed.deleteByte(idx);
                syncDataFromEditor();
                if (idx >= state.data.length && state.data.length > 0) idx = state.data.length - 1;
                state.selectedByte = state.data.length > 0 ? idx : -1;
                updateDisplay();
                updateStatusBar();
                if (state.selectedByte >= 0) {
                    setTimeout(function() { selectByte(state.selectedByte); }, 30);
                }
            });
        }

        if (saveBinBtn) {
            saveBinBtn.addEventListener('click', function() {
                if (!state.data || !Ed.isModified()) return;
                var name = state.fileName || 'edited-file';
                X.downloadBinary(Ed.getData(), name);
            });
        }
    }

    function updateEditButtons() {
        var undoBtn = $('hx-undo-btn');
        var redoBtn = $('hx-redo-btn');
        var insertBtn = $('hx-insert-btn');
        var deleteBtn = $('hx-delete-btn');
        var saveBinBtn = $('hx-save-binary-btn');

        var hasData = !!state.data;
        var inEdit = state.editMode && hasData;

        if (undoBtn) undoBtn.disabled = !(inEdit && Ed.canUndo());
        if (redoBtn) redoBtn.disabled = !(inEdit && Ed.canRedo());
        if (insertBtn) insertBtn.disabled = !inEdit;
        if (deleteBtn) deleteBtn.disabled = !(inEdit && state.selectedByte >= 0);
        if (saveBinBtn) saveBinBtn.disabled = !(hasData && Ed.isModified());
    }

    function performUndo() {
        if (!Ed.canUndo()) return;
        cancelNibble();
        Ed.undo();
        syncDataFromEditor();
        updateDisplay();
        updateStatusBar();
        if (state.selectedByte >= 0) {
            setTimeout(function() { selectByte(state.selectedByte); }, 30);
        }
    }

    function performRedo() {
        if (!Ed.canRedo()) return;
        cancelNibble();
        Ed.redo();
        syncDataFromEditor();
        updateDisplay();
        updateStatusBar();
        if (state.selectedByte >= 0) {
            setTimeout(function() { selectByte(state.selectedByte); }, 30);
        }
    }

    function syncDataFromEditor() {
        state.data = Ed.getData();
    }

    // ===== Structure Panel Toggle =====
    function wireStructureToggle() {
        var btn = $('hx-structure-toggle');
        var panel = $('hx-structure-panel');
        if (!btn || !panel) return;

        btn.addEventListener('click', function() {
            var hidden = panel.classList.toggle('hidden');
            btn.classList.toggle('active', !hidden);
        });
    }

    // ===== Render Structure Panel =====
    function renderStructurePanel() {
        var panel = $('hx-structure-panel');
        if (!panel) return;

        if (!state.analysis || !state.analysis.fileType) {
            panel.innerHTML = '<div class="hx-inspector-title">Structure Map</div><div class="hx-inspector-empty">Load a recognized file to view structure</div>';
            return;
        }

        var a = state.analysis;
        var html = '<div class="hx-inspector-title">Structure Map</div>';

        // File type badge
        html += '<div class="hx-structure-file-type">';
        html += '<span class="hx-structure-icon">' + a.icon + '</span> ';
        html += '<strong>' + a.fileType + '</strong>';
        if (state.data) {
            html += ' <span class="hx-structure-size">' + E.formatFileSize(state.data.length) + '</span>';
        }
        html += '</div>';

        // Region list
        html += '<div class="hx-structure-regions">';
        var summary = a.summary;
        for (var i = 0; i < summary.length; i++) {
            var reg = summary[i];
            html += '<div class="hx-structure-region" data-offset="' + reg.start + '">';
            html += '<div class="hx-structure-region-header">';
            html += '<span class="hx-structure-region-color hx-region-' + reg.color + '"></span>';
            html += '<span class="hx-structure-region-label">' + reg.label + '</span>';
            html += '<span class="hx-structure-region-range">' + formatRange(reg.start, reg.end) + '</span>';
            html += '</div>';
            if (reg.fields && reg.fields.length > 0) {
                html += '<div class="hx-structure-region-fields">';
                for (var f = 0; f < reg.fields.length; f++) {
                    html += '<div class="hx-structure-field">' + reg.fields[f] + '</div>';
                }
                html += '</div>';
            }
            html += '</div>';
        }
        html += '</div>';

        // Legend
        html += '<div class="hx-structure-legend">';
        var legendItems = [
            ['magic', 'Magic'], ['header', 'Header'], ['metadata', 'Metadata'],
            ['compressed', 'Compressed'], ['checksum', 'CRC'], ['string', 'String'],
            ['index', 'Index'], ['padding', 'Padding']
        ];
        for (var li = 0; li < legendItems.length; li++) {
            html += '<span class="hx-legend-item"><span class="hx-legend-swatch hx-region-' + legendItems[li][0] + '"></span>' + legendItems[li][1] + '</span>';
        }
        html += '</div>';

        panel.innerHTML = html;

        // Wire click handlers for scrolling
        var regionEls = panel.querySelectorAll('.hx-structure-region[data-offset]');
        for (var r = 0; r < regionEls.length; r++) {
            regionEls[r].addEventListener('click', function() {
                var offset = parseInt(this.getAttribute('data-offset'), 10);
                if (!isNaN(offset) && els.hexDisplay) {
                    R.scrollToOffset(els.hexDisplay, offset, state.bytesPerLine);
                    selectByte(offset);
                }
            });
        }
    }

    function formatRange(start, end) {
        return '0x' + start.toString(16).toUpperCase() + '\u2013' + '0x' + end.toString(16).toUpperCase();
    }

    // ===== Byte Region Info (in inspector) =====
    function renderByteRegionInfo(idx) {
        var regionPanel = $('hx-region-info-panel');
        if (!regionPanel) return;

        if (!state.analysis || !state.analysis.regionMap) {
            regionPanel.innerHTML = '';
            return;
        }

        var reg = state.analysis.regionMap.get(idx);
        if (!reg) {
            regionPanel.innerHTML = '<div class="hx-inspector-title">Region</div><div class="hx-inspector-empty">No structure data for this byte</div>';
            return;
        }

        var html = '<div class="hx-inspector-title">Region</div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Type</span><span class="hx-inspector-value"><span class="hx-region-badge hx-region-' + reg.color + '">' + reg.type + '</span></span></div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Label</span><span class="hx-inspector-value">' + reg.label + '</span></div>';
        html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Range</span><span class="hx-inspector-value">' + formatRange(reg.start, reg.end) + '</span></div>';
        if (reg.description) {
            html += '<div class="hx-inspector-row"><span class="hx-inspector-label">Info</span><span class="hx-inspector-value" style="font-size:0.6875rem;word-break:break-word;">' + reg.description + '</span></div>';
        }
        if (reg.fields && reg.fields.length > 0) {
            for (var f = 0; f < reg.fields.length; f++) {
                html += '<div class="hx-inspector-row" style="padding-left:0.25rem;"><span class="hx-inspector-value" style="font-size:0.6875rem;">' + reg.fields[f] + '</span></div>';
            }
        }
        regionPanel.innerHTML = html;
    }

    // ===== Toast =====
    function showToast(msg) {
        var toast = document.createElement('div');
        toast.textContent = msg;
        toast.style.cssText = 'position:fixed;bottom:2rem;left:50%;transform:translateX(-50%);background:#059669;color:#fff;padding:0.625rem 1.25rem;border-radius:0.5rem;font-size:0.875rem;font-weight:500;z-index:9999;box-shadow:0 4px 12px rgba(0,0,0,0.2);opacity:0;transition:opacity 0.3s;';
        document.body.appendChild(toast);
        requestAnimationFrame(function() { toast.style.opacity = '1'; });
        setTimeout(function() {
            toast.style.opacity = '0';
            setTimeout(function() { document.body.removeChild(toast); }, 300);
        }, 2000);
    }

    // ===== URL Params =====
    function checkUrlParams() {
        var params = new URLSearchParams(window.location.search);
        var d = params.get('d');
        if (d && /^[0-9a-fA-F]+$/.test(d) && d.length >= 2 && d.length <= 4096) {
            state.data = E.parseHexInput(d);
            state.fileName = 'url-data';
            if (state.data.length > 0) {
                var f = params.get('f');
                if (f && ['hex', 'dec', 'oct', 'bin'].indexOf(f) !== -1) {
                    state.format = f;
                    var fmtBtns = document.querySelectorAll('.hx-format-pill');
                    for (var i = 0; i < fmtBtns.length; i++) {
                        fmtBtns[i].classList.toggle('active', fmtBtns[i].getAttribute('data-format') === f);
                    }
                }
                var bpl = params.get('bpl');
                if (bpl) {
                    var bplVal = parseInt(bpl, 10);
                    if ([8, 16, 24, 32].indexOf(bplVal) !== -1) {
                        state.bytesPerLine = bplVal;
                        if (els.bytesPerLine) els.bytesPerLine.value = bplVal;
                    }
                }
                onDataLoaded();
            }
        }
    }

    // ===== FAQ Toggle =====
    window.toggleHxFaq = function(btn) {
        var item = btn.parentElement;
        if (!item) return;
        var isOpen = item.classList.contains('open');
        var allItems = document.querySelectorAll('.hx-faq-item');
        for (var i = 0; i < allItems.length; i++) allItems[i].classList.remove('open');
        if (!isOpen) item.classList.add('open');
    };

    // ===== Boot =====
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();

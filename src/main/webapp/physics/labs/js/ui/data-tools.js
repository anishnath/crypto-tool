/**
 * Data Tools — Export CSV, Screenshot, Live Readout
 *
 * Adds data collection and export capabilities for lab reports.
 */

/**
 * Build the data tools panel: Export CSV, Screenshot, Live Readout.
 *
 * @param {HTMLElement} containerEl — where to append
 * @param {object} sim — sim definition (vars, energy)
 * @param {SimRunner} runner — for state access
 * @param {HTMLCanvasElement} simCanvas — for screenshot
 * @param {object} opts — { allCanvases: [canvas1, canvas2, ...], canvasArea: HTMLElement }
 * @returns {{ updateReadout: function, clearBuffer: function }}
 */
export function buildDataTools(containerEl, sim, runner, simCanvas, opts = {}) {
  const section = document.createElement('div');
  section.className = 'lab-data-tools';

  // ─── Live Readout ───
  const readout = document.createElement('div');
  readout.className = 'data-readout';
  readout.textContent = 'Paused — no data';
  section.appendChild(readout);

  // ─── Button Row ───
  const btnRow = document.createElement('div');
  btnRow.className = 'data-btn-row';

  // Export CSV
  const csvBtn = document.createElement('button');
  csvBtn.className = 'data-btn';
  csvBtn.textContent = 'Export CSV';
  csvBtn.title = 'Download simulation data as CSV for Excel/Sheets';
  csvBtn.addEventListener('click', () => exportCSV(sim, runner, dataBuffer));
  btnRow.appendChild(csvBtn);

  // Screenshot
  const shotBtn = document.createElement('button');
  shotBtn.className = 'data-btn';
  shotBtn.textContent = 'Screenshot';
  shotBtn.title = 'Download visible canvases (sim + graph) as PNG';
  shotBtn.addEventListener('click', () => {
    const allCanvases = opts.allCanvases || [simCanvas];
    screenshotComposite(allCanvases, sim.slug);
  });
  btnRow.appendChild(shotBtn);

  section.appendChild(btnRow);
  containerEl.appendChild(section);

  // ─── Data Buffer (collects rows for CSV) ───
  const dataBuffer = [];
  const maxRows = 5000;

  function updateReadout(state, params) {
    if (!state) { readout.textContent = 'No data'; return; }

    // Collect data row
    const t = runner.getTime();
    const row = { t };
    const varEntries = Object.entries(sim.vars).filter(([, v]) => v.index >= 0);
    for (const [name, def] of varEntries) {
      row[name] = state[def.index];
    }
    if (sim.energy) {
      const e = sim.energy(state, params);
      row.KE = e.kinetic;
      row.PE = e.potential;
      row.Total = e.total;
    }
    dataBuffer.push(row);
    if (dataBuffer.length > maxRows) dataBuffer.shift();

    // Update readout text
    const parts = [];
    parts.push('t=' + t.toFixed(2) + 's');
    for (const [name, def] of varEntries) {
      if (name === 'time') continue;
      const val = state[def.index];
      parts.push((def.symbol || name) + '=' + val.toFixed(3));
    }
    if (sim.energy) {
      const e = sim.energy(state, params);
      parts.push('KE=' + e.kinetic.toFixed(2));
      parts.push('PE=' + e.potential.toFixed(2));
    }
    readout.textContent = parts.join('  ');
  }

  function clearBuffer() {
    dataBuffer.length = 0;
  }

  return { updateReadout, clearBuffer };
}

// ─── CSV Export ───
function exportCSV(sim, runner, buffer) {
  if (buffer.length === 0) {
    if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No data to export — run the simulation first', 2000, 'error');
    return;
  }

  // Build header
  const keys = Object.keys(buffer[0]);
  const header = keys.join(',');

  // Build rows
  const rows = buffer.map(row => keys.map(k => {
    const v = row[k];
    return typeof v === 'number' ? v.toFixed(6) : String(v);
  }).join(','));

  const csv = header + '\n' + rows.join('\n');
  const filename = (sim.slug || 'simulation') + '-data.csv';

  if (typeof ToolUtils !== 'undefined' && ToolUtils.downloadFile) {
    ToolUtils.downloadFile(csv, { filename, mimeType: 'text/csv', toastMessage: 'Downloaded ' + filename });
  } else {
    // Fallback download
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url; a.download = filename;
    document.body.appendChild(a); a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }
}

// ─── Screenshot (composites all visible canvases side-by-side) ───
function screenshotComposite(canvases, slug) {
  // Filter to only visible canvases (display !== 'none' and has dimensions)
  const visible = canvases.filter(c => {
    if (!c) return false;
    // Check if canvas or its parent wrapper is hidden
    const wrap = c.closest('.lab-canvas-wrap');
    if (wrap && wrap.style.display === 'none') return false;
    const panel = c.closest('.lab-graph-panel');
    if (panel && panel.style.display === 'none') return false;
    if (c.style.display === 'none') return false;
    return c.width > 0 && c.height > 0;
  });

  if (visible.length === 0) return;

  if (visible.length === 1) {
    // Single canvas — direct download
    visible[0].toBlob((blob) => {
      if (!blob) return;
      downloadBlob(blob, (slug || 'simulation') + '-screenshot.png');
    }, 'image/png');
    return;
  }

  // Multiple visible canvases — composite side-by-side
  const totalW = visible.reduce((s, c) => s + c.width, 0) + (visible.length - 1) * 4;
  const maxH = Math.max(...visible.map(c => c.height));
  const comp = document.createElement('canvas');
  comp.width = totalW;
  comp.height = maxH;
  const ctx = comp.getContext('2d');

  // Dark background
  ctx.fillStyle = '#0E1420';
  ctx.fillRect(0, 0, totalW, maxH);

  // Draw each canvas
  let x = 0;
  for (const c of visible) {
    ctx.drawImage(c, x, 0);
    x += c.width + 4;
  }

  comp.toBlob((blob) => {
    if (!blob) return;
    downloadBlob(blob, (slug || 'simulation') + '-screenshot.png');
  }, 'image/png');
}

function downloadBlob(blob, filename) {
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a); a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
  if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Screenshot saved', 2000, 'success');
}

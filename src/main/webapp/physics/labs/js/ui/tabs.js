/**
 * TabSwitcher — generates tab buttons.
 *
 * Layout: Sim tab = canvas full width.
 * Phase/Time/Energy tabs = sim canvas (left) + graph canvas (right) side-by-side.
 */

export class TabSwitcher {
  /**
   * @param {HTMLElement} containerEl — where to append the tab bar
   * @param {string[]} tabs — e.g. ['sim','phase','time','energy']
   * @param {object} opts
   * @param {HTMLElement} opts.canvasArea — the .lab-canvas-area container
   * @param {Object<string, HTMLElement>} opts.graphCanvases — { phase: canvas, time: canvas, energy: canvas }
   */
  constructor(containerEl, tabs, opts = {}) {
    this.tabs = tabs;
    this.canvasArea = opts.canvasArea || null;
    this.graphCanvases = opts.graphCanvases || {};
    this.active = tabs[0];
    this._callbacks = [];
    this._buttons = {};

    const bar = document.createElement('div');
    bar.className = 'lab-tabs';

    const dots = { sim: '#8B5CF6', phase: '#06B6D4', time: '#10B981', energy: '#F59E0B', well: '#EC4899' };

    tabs.forEach(name => {
      const btn = document.createElement('button');
      btn.className = 'lab-tab' + (name === this.active ? ' active' : '');
      btn.dataset.tab = name;
      btn.innerHTML = '<span class="tab-dot" style="background:' + (dots[name] || '#8B5CF6') + '"></span>' +
        name.charAt(0).toUpperCase() + name.slice(1);
      btn.addEventListener('click', () => this.setActive(name));
      bar.appendChild(btn);
      this._buttons[name] = btn;
    });

    containerEl.appendChild(bar);
    this._applyLayout();
  }

  setActive(name) {
    if (!this.tabs.includes(name)) return;
    this.active = name;

    for (const [n, btn] of Object.entries(this._buttons)) {
      btn.classList.toggle('active', n === name);
    }
    this._applyLayout();
    this._callbacks.forEach(fn => fn(name));

    try { sessionStorage.setItem('lab-active-tab', name); } catch {}
  }

  _applyLayout() {
    const isSim = this.active === 'sim';

    // Toggle split mode on canvas area
    if (this.canvasArea) {
      this.canvasArea.classList.toggle('split', !isSim);
    }

    // Show the correct graph canvas, hide others
    for (const [name, el] of Object.entries(this.graphCanvases)) {
      if (el) el.style.display = name === this.active ? '' : 'none';
    }
  }

  onSwitch(fn) { this._callbacks.push(fn); }

  restoreFromSession() {
    try {
      const saved = sessionStorage.getItem('lab-active-tab');
      if (saved && this.tabs.includes(saved)) this.setActive(saved);
    } catch {}
  }
}

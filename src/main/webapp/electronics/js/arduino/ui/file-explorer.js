/**
 * FileExplorer — sidebar UI for managing sketch files.
 *
 * Features:
 *  - File list with active highlight
 *  - Click to switch files
 *  - New file button (prompts for name)
 *  - Delete button (with confirmation)
 *  - Rename (double-click filename)
 *  - Modified dot indicator
 */

export class FileExplorer {
  /**
   * @param {HTMLElement} container - sidebar container element
   * @param {import('./file-manager.js').FileManager} fileManager
   */
  constructor(container, fileManager) {
    this.container = container;
    this.fileManager = fileManager;

    this._build();
    this.refresh();

    // Listen for file changes
    const origOnChange = fileManager.onChange;
    fileManager.onChange = () => {
      if (origOnChange) origOnChange();
      this.refresh();
    };
  }

  /** Refresh the file list UI */
  refresh() {
    this._fileList.innerHTML = '';
    const fm = this.fileManager;

    for (let i = 0; i < fm.files.length; i++) {
      const file = fm.files[i];
      const row = document.createElement('div');
      row.className = 'ard-fe-file' + (i === fm.activeIndex ? ' active' : '');

      // File icon
      const icon = document.createElement('span');
      icon.className = 'ard-fe-icon';
      icon.textContent = file.name.endsWith('.ino') ? '\u25B6' : file.name.endsWith('.h') ? 'H' : file.name.endsWith('.json') ? 'J' : 'C';
      row.appendChild(icon);

      // Filename
      const nameEl = document.createElement('span');
      nameEl.className = 'ard-fe-name';
      nameEl.textContent = file.name;
      row.appendChild(nameEl);

      // Modified dot
      if (file.modified) {
        const dot = document.createElement('span');
        dot.className = 'ard-fe-modified';
        row.appendChild(dot);
      }

      // Delete button (not for sketch.ino)
      if (i > 0) {
        const del = document.createElement('button');
        del.className = 'ard-fe-delete';
        del.textContent = '\u00D7';
        del.title = 'Delete ' + file.name;
        del.addEventListener('click', (e) => {
          e.stopPropagation();
          if (confirm('Delete ' + file.name + '?')) {
            fm.deleteFile(i);
          }
        });
        row.appendChild(del);
      }

      // Click to switch
      row.addEventListener('click', () => fm.switchTo(i));

      // Double-click to rename (not sketch.ino)
      if (i > 0) {
        row.addEventListener('dblclick', (e) => {
          e.preventDefault();
          const newName = prompt('Rename ' + file.name + ' to:', file.name);
          if (newName && newName !== file.name) {
            const err = fm.renameFile(i, newName);
            if (err) alert(err);
          }
        });
      }

      this._fileList.appendChild(row);
    }

    // Also refresh the file tabs bar in the editor
    this._refreshTabs();
  }

  _build() {
    this.container.innerHTML = '';

    // Header
    const header = document.createElement('div');
    header.className = 'ard-fe-header';
    header.innerHTML = '<span>WORKSPACE</span>';

    const newBtn = document.createElement('button');
    newBtn.className = 'ard-fe-new';
    newBtn.textContent = '+';
    newBtn.title = 'New file';
    newBtn.addEventListener('click', () => {
      const name = prompt('New filename (e.g. helpers.h, utils.cpp):');
      if (!name) return;
      const err = this.fileManager.createFile(name);
      if (err) alert(err);
    });
    header.appendChild(newBtn);

    this.container.appendChild(header);

    // File list
    this._fileList = document.createElement('div');
    this._fileList.className = 'ard-fe-list';
    this.container.appendChild(this._fileList);
  }

  _refreshTabs() {
    // Update the file tabs bar in the editor panel
    const tabsEl = document.getElementById('fileTabs');
    if (!tabsEl) return;

    tabsEl.innerHTML = '';
    const fm = this.fileManager;

    for (let i = 0; i < fm.files.length; i++) {
      const file = fm.files[i];
      const tab = document.createElement('div');
      tab.className = 'ard-file-tab' + (i === fm.activeIndex ? ' active' : '');

      const name = document.createElement('span');
      name.className = 'ard-file-tab-name';
      name.textContent = file.name;
      tab.appendChild(name);

      if (file.modified) {
        const dot = document.createElement('span');
        dot.className = 'ard-file-tab-modified';
        tab.appendChild(dot);
      }

      if (i > 0) {
        const close = document.createElement('span');
        close.className = 'ard-file-tab-close';
        close.textContent = '\u00D7';
        close.addEventListener('click', (e) => {
          e.stopPropagation();
          if (file.modified && !confirm('Close ' + file.name + ' with unsaved changes?')) return;
          fm.deleteFile(i);
        });
        tab.appendChild(close);
      }

      tab.addEventListener('click', () => fm.switchTo(i));
      tabsEl.appendChild(tab);
    }
  }
}

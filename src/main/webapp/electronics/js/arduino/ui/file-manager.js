/**
 * FileManager — manages multiple sketch files in the editor.
 *
 * Features:
 *  - Create / rename / delete files
 *  - Track modified state per file
 *  - Active file switching (updates Monaco editor)
 *  - Compile: exports all files as { name, content } array
 *
 * File rules (from API spec):
 *  - Exactly one sketch.ino (main file, always present)
 *  - Valid names: ^[a-zA-Z0-9][a-zA-Z0-9_.-]{0,62}\.[a-zA-Z0-9]+$
 *  - Max 64 files, 50KB combined
 *  - No duplicate basenames (case-insensitive)
 */

const VALID_NAME = /^[a-zA-Z0-9][a-zA-Z0-9_.-]{0,62}\.[a-zA-Z0-9]+$/;
const MAX_FILES = 64;

export class FileManager {
  /**
   * @param {import('./editor.js').ArduinoEditor} editor - Monaco editor instance
   * @param {function} [onChange] - called when file list changes (for UI refresh)
   */
  constructor(editor, onChange = null) {
    this.editor = editor;
    this.onChange = onChange;

    /** @type {Array<{name: string, content: string, modified: boolean}>} */
    this.files = [
      { name: 'sketch.ino', content: '', modified: false },
    ];

    this.activeIndex = 0;
  }

  /** Get the active file */
  get activeFile() { return this.files[this.activeIndex]; }

  /** Get file count */
  get count() { return this.files.length; }

  /** Initialize with editor's current code */
  init() {
    this.files[0].content = this.editor.getCode();
  }

  /** Switch to a file by index */
  switchTo(index) {
    if (index < 0 || index >= this.files.length) return;

    // Save current file content
    this.files[this.activeIndex].content = this.editor.getCode();

    this.activeIndex = index;

    // Load new file into editor
    this.editor.setCode(this.files[index].content);
    if (this.onChange) this.onChange();
  }

  /** Create a new file */
  createFile(name) {
    if (!VALID_NAME.test(name)) return 'Invalid filename';
    if (this.files.length >= MAX_FILES) return 'Maximum 64 files';
    if (this._findByName(name) >= 0) return 'File already exists';

    const ext = name.split('.').pop().toLowerCase();
    let content = '';
    if (ext === 'h') content = '#pragma once\n\n';
    else if (ext === 'cpp') content = '#include "' + name.replace('.cpp', '.h') + '"\n\n';
    else if (ext === 'ino') content = 'void setup() {\n}\n\nvoid loop() {\n}\n';

    this.files.push({ name, content, modified: true });
    this.switchTo(this.files.length - 1);
    return null; // success
  }

  /** Rename a file */
  renameFile(index, newName) {
    if (index === 0) return 'Cannot rename sketch.ino';
    if (!VALID_NAME.test(newName)) return 'Invalid filename';
    if (this._findByName(newName) >= 0) return 'File already exists';

    this.files[index].name = newName;
    this.files[index].modified = true;
    if (this.onChange) this.onChange();
    return null;
  }

  /** Delete a file */
  deleteFile(index) {
    if (index === 0) return 'Cannot delete sketch.ino';
    if (this.files.length <= 1) return 'Must have at least one file';

    this.files.splice(index, 1);
    // Clamp activeIndex and always reload editor content
    const newActive = Math.min(
      index <= this.activeIndex ? Math.max(0, this.activeIndex - 1) : this.activeIndex,
      this.files.length - 1
    );
    this.activeIndex = newActive;
    this.editor.setCode(this.files[newActive].content);
    if (this.onChange) this.onChange();
    return null;
  }

  /** Mark current file as modified */
  markModified() {
    this.files[this.activeIndex].modified = true;
    if (this.onChange) this.onChange();
  }

  /** Mark all files as saved */
  markAllSaved() {
    for (const f of this.files) f.modified = false;
    if (this.onChange) this.onChange();
  }

  /**
   * Export files for compile API.
   * Uses Pattern A if only sketch.ino, Pattern B if multiple files.
   * @returns {{ sketch?: string, files?: Array<{name: string, content: string}> }}
   */
  exportForCompile() {
    // Save current editor content
    this.files[this.activeIndex].content = this.editor.getCode();

    if (this.files.length === 1) {
      // Pattern A: single file, just sketch
      return { sketch: this.files[0].content };
    }

    // Pattern B: everything in files[]
    return {
      files: this.files.map(f => ({ name: f.name, content: f.content })),
    };
  }

  /** Load files from an external source (e.g. URL share) */
  loadFiles(fileList) {
    this.files = fileList.map(f => ({ ...f, modified: false }));
    if (this.files.length === 0) {
      this.files = [{ name: 'sketch.ino', content: '', modified: false }];
    }
    this.activeIndex = 0;
    this.editor.setCode(this.files[0].content);
    if (this.onChange) this.onChange();
  }

  _findByName(name) {
    const lower = name.toLowerCase();
    return this.files.findIndex(f => f.name.toLowerCase() === lower);
  }
}

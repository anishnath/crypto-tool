(function() {
'use strict';

var STORAGE_KEY = 'latex_projects';
var ACTIVE_KEY = 'latex_active_project';
var SAVE_DEBOUNCE = 1000; // 1s after last edit
var saveTimer = null;
var currentProjectId = null;

// ── Storage helpers ──

function getProjects() {
  try {
    var data = localStorage.getItem(STORAGE_KEY);
    return data ? JSON.parse(data) : {};
  } catch (e) {
    return {};
  }
}

function saveProjects(projects) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(projects));
  } catch (e) {
    // localStorage full or blocked
    console.warn('Failed to save to localStorage:', e);
  }
}

function getActiveProjectId() {
  return localStorage.getItem(ACTIVE_KEY) || null;
}

function setActiveProjectId(id) {
  localStorage.setItem(ACTIVE_KEY, id);
}

function generateId() {
  return Date.now().toString(36) + Math.random().toString(36).substr(2, 5);
}

// ── Project CRUD ──

function createProject(name, content) {
  var projects = getProjects();
  var id = generateId();
  projects[id] = {
    id: id,
    name: name || 'Untitled Document',
    content: content || '',
    createdAt: Date.now(),
    updatedAt: Date.now()
  };
  saveProjects(projects);
  return id;
}

function saveCurrentProject() {
  if (!currentProjectId) return;
  var content = typeof window.getEditorContent === 'function' ? window.getEditorContent() : '';
  if (!content) return;

  var projects = getProjects();
  if (!projects[currentProjectId]) return;

  projects[currentProjectId].content = content;
  projects[currentProjectId].updatedAt = Date.now();
  projects[currentProjectId].name = getProjectName();

  // Persist sub-files and uploaded file registry
  if (window.fileContents) projects[currentProjectId].fileContents = window.fileContents;
  if (window.uploadedFiles) projects[currentProjectId].uploadedFiles = window.uploadedFiles;

  saveProjects(projects);

  showSaveIndicator('saved');
}

function loadProject(id) {
  var projects = getProjects();
  var project = projects[id];
  if (!project) return false;

  currentProjectId = id;
  setActiveProjectId(id);

  // Set editor content
  if (typeof window.setEditorContent === 'function') {
    window.setEditorContent(project.content || '');
  }

  // Set project name in titlebar
  setProjectName(project.name);

  // Restore sub-files and uploaded file registry
  if (window.fileContents) {
    // Clear and restore
    for (var k in window.fileContents) delete window.fileContents[k];
    if (project.fileContents) {
      for (var f in project.fileContents) window.fileContents[f] = project.fileContents[f];
    }
  }
  if (window.uploadedFiles) {
    window.uploadedFiles.length = 0;
    if (project.uploadedFiles) {
      for (var i = 0; i < project.uploadedFiles.length; i++) {
        window.uploadedFiles.push(project.uploadedFiles[i]);
      }
    }
  }

  // Rebuild file tree from restored data
  rebuildFileTree(project);

  showSaveIndicator('loaded');
  return true;
}

function rebuildFileTree(project) {
  var fileList = document.getElementById('file-list');
  if (!fileList) return;

  // Clear all except main.tex
  var items = fileList.querySelectorAll('.file-item');
  for (var i = 0; i < items.length; i++) {
    if (items[i].getAttribute('data-file') !== 'main.tex') {
      items[i].remove();
    }
  }

  // Re-add from fileContents (.tex files)
  if (project.fileContents) {
    for (var fname in project.fileContents) {
      if (typeof window.addFileToTree === 'function') {
        window.addFileToTree(fname, false);
      }
    }
  }

  // Re-add uploaded images not in fileContents
  if (project.uploadedFiles) {
    var IMAGE_EXT = /\.(png|jpg|jpeg|gif|svg|eps|pdf)$/i;
    for (var j = 0; j < project.uploadedFiles.length; j++) {
      var uf = project.uploadedFiles[j];
      if (IMAGE_EXT.test(uf.filename) && !(project.fileContents && project.fileContents[uf.filename])) {
        if (typeof window.addFileToTree === 'function') {
          window.addFileToTree(uf.filename, true);
        }
      }
    }
  }
}

function deleteProject(id) {
  var projects = getProjects();
  delete projects[id];
  saveProjects(projects);

  if (currentProjectId === id) {
    currentProjectId = null;
    // Load another project or create new
    var ids = Object.keys(projects);
    if (ids.length > 0) {
      loadProject(ids[0]);
    } else {
      newProject();
    }
  }
}

// ── UI helpers ──

function getProjectName() {
  var el = document.getElementById('project-name');
  return el ? el.textContent : 'Untitled Document';
}

function setProjectName(name) {
  var el = document.getElementById('project-name');
  if (el) el.textContent = name;
  document.title = name + ' - LaTeX Editor';
}

function showSaveIndicator(state) {
  var el = document.getElementById('save-indicator');
  if (!el) return;

  if (state === 'saved') {
    el.textContent = '\u2713 saved';
    el.className = 'save-indicator saved';
  } else if (state === 'saving') {
    el.textContent = 'saving...';
    el.className = 'save-indicator saving';
  } else if (state === 'loaded') {
    el.textContent = '\u2713 loaded';
    el.className = 'save-indicator saved';
  } else if (state === 'dirty') {
    el.textContent = '\u2022 unsaved';
    el.className = 'save-indicator dirty';
  }

  // Fade out after 3s for saved/loaded states
  if (state === 'saved' || state === 'loaded') {
    setTimeout(function() {
      el.className = 'save-indicator';
      el.textContent = '';
    }, 3000);
  }
}

// ── Rename project ──
function renameProject() {
  var currentName = getProjectName();
  var newName = prompt('Project name:', currentName);
  if (newName && newName.trim() && newName !== currentName) {
    setProjectName(newName.trim());
    saveCurrentProject();
  }
}

// ── Project menu ──
function showProjectMenu() {
  var menu = document.getElementById('project-menu');
  if (!menu) return;

  if (menu.classList.contains('visible')) {
    menu.classList.remove('visible');
    return;
  }

  // Populate list
  var list = document.getElementById('pm-list');
  if (!list) return;

  var projects = getProjects();
  var ids = Object.keys(projects).sort(function(a, b) {
    return (projects[b].updatedAt || 0) - (projects[a].updatedAt || 0);
  });

  list.innerHTML = '';

  if (ids.length === 0) {
    var empty = document.createElement('div');
    empty.className = 'pm-empty';
    empty.textContent = 'No saved projects yet';
    list.appendChild(empty);
  } else {
    for (var i = 0; i < ids.length; i++) {
      var p = projects[ids[i]];
      var item = document.createElement('div');
      item.className = 'pm-item' + (ids[i] === currentProjectId ? ' active' : '');
      item.setAttribute('data-id', ids[i]);

      var name = document.createElement('span');
      name.className = 'pm-item-name';
      name.textContent = p.name;

      var time = document.createElement('span');
      time.className = 'pm-item-time';
      time.textContent = formatRelativeTime(p.updatedAt);

      item.appendChild(name);
      item.appendChild(time);

      item.onclick = (function(id) {
        return function() {
          loadProject(id);
          menu.classList.remove('visible');
        };
      })(ids[i]);

      list.appendChild(item);
    }
  }

  menu.classList.add('visible');
}

function newProject() {
  // Save current first
  saveCurrentProject();

  var name = prompt('New project name:', 'Untitled Document');
  if (!name) return;

  var defaultContent = '\\documentclass[12pt, a4paper]{article}\n\n\\usepackage{amsmath, amssymb}\n\\usepackage{geometry}\n\\usepackage{graphicx, hyperref}\n\n\\title{' + name + '}\n\\author{Author Name}\n\\date{\\today}\n\n\\begin{document}\n\\maketitle\n\n\\section{Introduction}\nYour text here.\n\n\\end{document}\n';

  var id = createProject(name, defaultContent);
  loadProject(id);

  // Close menu
  var menu = document.getElementById('project-menu');
  if (menu) menu.classList.remove('visible');
}

function exportProject() {
  if (typeof window.downloadTex === 'function') {
    window.downloadTex();
  }
  var menu = document.getElementById('project-menu');
  if (menu) menu.classList.remove('visible');
}

function deleteCurrentProject() {
  if (!currentProjectId) return;
  var name = getProjectName();
  if (!confirm('Delete "' + name + '"? This cannot be undone.')) return;

  deleteProject(currentProjectId);

  var menu = document.getElementById('project-menu');
  if (menu) menu.classList.remove('visible');
}

function formatRelativeTime(ts) {
  if (!ts) return '';
  var diff = Date.now() - ts;
  var sec = Math.floor(diff / 1000);
  if (sec < 60) return 'just now';
  var min = Math.floor(sec / 60);
  if (min < 60) return min + 'm ago';
  var hr = Math.floor(min / 60);
  if (hr < 24) return hr + 'h ago';
  var days = Math.floor(hr / 24);
  if (days < 30) return days + 'd ago';
  return new Date(ts).toLocaleDateString();
}

// ── Auto-save on editor change ──
function onStorageEditorChange() {
  clearTimeout(saveTimer);
  showSaveIndicator('dirty');
  saveTimer = setTimeout(function() {
    showSaveIndicator('saving');
    saveCurrentProject();
  }, SAVE_DEBOUNCE);
}

// ── Init: restore last project or create first one ──
function initStorage() {
  var projects = getProjects();
  var activeId = getActiveProjectId();

  // Try to restore active project
  if (activeId && projects[activeId]) {
    // Wait for editor to be ready, then load
    waitForEditor(function() {
      loadProject(activeId);
    });
    return;
  }

  // If there are projects but no active, load the most recent
  var ids = Object.keys(projects);
  if (ids.length > 0) {
    ids.sort(function(a, b) {
      return (projects[b].updatedAt || 0) - (projects[a].updatedAt || 0);
    });
    waitForEditor(function() {
      loadProject(ids[0]);
    });
    return;
  }

  // No projects — create initial project from default template after editor inits
  waitForEditor(function() {
    var content = typeof window.getEditorContent === 'function' ? window.getEditorContent() : '';
    var id = createProject('Untitled Document', content);
    currentProjectId = id;
    setActiveProjectId(id);
  });
}

function waitForEditor(callback) {
  if (typeof window.getEditorContent === 'function' && window.editorInstance) {
    callback();
  } else {
    setTimeout(function() { waitForEditor(callback); }, 100);
  }
}

// ── Hook into editor changes ──
// We patch onEditorChange to also trigger storage save
var origOnEditorChange = null;
function hookEditorChange() {
  if (typeof window.onEditorChange === 'function' && !origOnEditorChange) {
    origOnEditorChange = window.onEditorChange;
    window.onEditorChange = function() {
      origOnEditorChange();
      onStorageEditorChange();
    };
  } else {
    setTimeout(hookEditorChange, 200);
  }
}

// Close project menu on outside click
document.addEventListener('click', function(e) {
  var menu = document.getElementById('project-menu');
  if (menu && menu.classList.contains('visible')) {
    if (!menu.contains(e.target) && e.target.id !== 'btn-project-menu') {
      menu.classList.remove('visible');
    }
  }
});

// Save before page unload
window.addEventListener('beforeunload', function() {
  saveCurrentProject();
});

// Expose
window.renameProject = renameProject;
window.showProjectMenu = showProjectMenu;
window.newProject = newProject;
window.exportProject = exportProject;
window.deleteCurrentProject = deleteCurrentProject;

// Init
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', function() {
    initStorage();
    hookEditorChange();
  });
} else {
  initStorage();
  hookEditorChange();
}

})();

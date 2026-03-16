/**
 * export-latex.js — Export TipTap document to LaTeX
 * Walks editor.getJSON(), converts each node type to LaTeX, downloads .tex file
 * Embedded images (image + drawingBlock) are extracted and downloaded as companion .png files
 */
(function () {
    'use strict';

    // LaTeX special chars to escape: \ { } $ & # % _ ^ ~
    function escapeLatex(str) {
        if (!str || typeof str !== 'string') return '';
        return str
            .replace(/\\/g, '\\textbackslash{}')
            .replace(/([{}#$%_^~&])/g, '\\$1')
            .replace(/\n/g, ' ');
    }

    function serializeInline(node, ctx) {
        if (!node) return '';
        if (node.type === 'text') {
            var text = escapeLatex(node.text || '');
            var marks = node.marks || [];
            marks.forEach(function (m) {
                if (m.type === 'bold') text = '\\textbf{' + text + '}';
                else if (m.type === 'italic') text = '\\textit{' + text + '}';
                else if (m.type === 'underline') text = '\\underline{' + text + '}';
                else if (m.type === 'strike') text = '\\sout{' + text + '}';
            });
            return text;
        }
        if (node.type === 'mathInline') {
            var latex = (node.attrs && node.attrs.latex) || '';
            return '$' + latex + '$';
        }
        if (node.type === 'hardBreak') return '\\\\\n';
        return '';
    }

    function serializeBlock(node, ctx) {
        ctx = ctx || {};
        if (!node) return '';
        var type = node.type;
        var content = node.content || [];
        var attrs = node.attrs || {};

        if (type === 'paragraph') {
            var align = attrs.textAlign;
            var inner = content.map(function (n) { return serializeInline(n, ctx); }).join('');
            if (align === 'center') return '\\begin{center}\n' + inner + '\n\\end{center}\n\n';
            if (align === 'right') return '\\begin{flushright}\n' + inner + '\n\\end{flushright}\n\n';
            return inner + '\n\n';
        }

        if (type === 'heading') {
            var level = attrs.level || 1;
            var inner = content.map(function (n) { return serializeInline(n, ctx); }).join('');
            var cmd = level === 1 ? 'section' : (level === 2 ? 'subsection' : 'subsubsection');
            return '\\' + cmd + '{' + inner + '}\n\n';
        }

        if (type === 'bulletList') {
            var items = content.map(function (li) {
                if (li.type !== 'listItem') return '';
                var itemContent = (li.content || []).map(function (n) { return serializeBlock(n, ctx); }).join('').trim();
                return '  \\item ' + itemContent;
            }).filter(Boolean);
            return '\\begin{itemize}\n' + items.join('\n') + '\n\\end{itemize}\n\n';
        }

        if (type === 'orderedList') {
            var oItems = content.map(function (li) {
                if (li.type !== 'listItem') return '';
                var oContent = (li.content || []).map(function (n) { return serializeBlock(n, ctx); }).join('').trim();
                return '  \\item ' + oContent;
            }).filter(Boolean);
            return '\\begin{enumerate}\n' + oItems.join('\n') + '\n\\end{enumerate}\n\n';
        }

        if (type === 'listItem') {
            return content.map(function (n) { return serializeBlock(n, ctx); }).join('');
        }

        if (type === 'blockquote') {
            var bqInner = content.map(function (n) { return serializeBlock(n, ctx); }).join('');
            return '\\begin{quote}\n' + bqInner + '\\end{quote}\n\n';
        }

        if (type === 'mathBlock') {
            var blockLatex = (attrs.latex || '').trim();
            return '\\[' + blockLatex + '\\]\n\n';
        }

        if (type === 'horizontalRule') {
            return '\\noindent\\rule{\\textwidth}{0.4pt}\n\n';
        }

        if (type === 'codeBlock') {
            var code = '';
            content.forEach(function (n) {
                if (n.type === 'text') code += (n.text || '');
            });
            return '\\begin{verbatim}\n' + code + '\n\\end{verbatim}\n\n';
        }

        if (type === 'table') {
            var rows = content.filter(function (n) { return n.type === 'tableRow'; });
            var firstRow = rows[0];
            if (!firstRow || !firstRow.content) return '';
            var colCount = firstRow.content.length;
            var colSpec = colCount ? Array(colCount).join('l') + 'l' : 'l';
            var tableBody = rows.map(function (row) {
                var cells = (row.content || []).map(function (cell) {
                    var cellContent = (cell.content || []).map(function (n) { return serializeBlock(n, ctx); }).join('').trim().replace(/\n/g, ' ');
                    return cellContent;
                });
                return cells.join(' & ') + ' \\\\';
            }).join('\n');
            return '\\begin{center}\n\\begin{tabular}{' + colSpec + '}\n' + tableBody + '\n\\end{tabular}\n\\end{center}\n\n';
        }

        if (type === 'tableRow') {
            var rowCells = (content || []).map(function (cell) {
                return (cell.content || []).map(function (n) { return serializeBlock(n, ctx); }).join('').trim().replace(/\n/g, ' ');
            });
            return rowCells.join(' & ') + ' \\\\';
        }

        if (type === 'tableCell' || type === 'tableHeader') {
            return content.map(function (n) { return serializeBlock(n, ctx); }).join('');
        }

        if (type === 'image') {
            var src = attrs.src || '';
            var w = attrs.width;
            var widthOpt = (w && w < 400) ? 'width=0.5\\textwidth' : 'width=\\textwidth';
            if (src && !src.startsWith('data:')) {
                return '\\includegraphics[' + widthOpt + ']{' + src + '}\n\n';
            }
            if (src && src.startsWith('data:image/')) {
                var imgIdx = ctx.imgCount || 0;
                ctx.imgCount = imgIdx + 1;
                var imgFile;
                if (ctx.uploadedFilenames && ctx.uploadedFilenames[imgIdx]) {
                    imgFile = ctx.uploadedFilenames[imgIdx];
                } else {
                    var imgBase = (ctx.baseName || 'image').replace(/_/g, '-');
                    imgFile = imgBase + '-' + ctx.imgCount + '.png';
                    ctx.imageFiles = ctx.imageFiles || [];
                    ctx.imageFiles.push({ dataUrl: src, filename: imgFile });
                }
                return '\\includegraphics[' + widthOpt + ']{' + imgFile + '}\n\n';
            }
            return '% [Image: no source]\n\n';
        }

        if (type === 'drawingBlock') {
            var imgData = attrs.imageData || '';
            var drawW = attrs.width;
            var drawWidthOpt = (drawW && drawW < 400) ? 'width=0.5\\textwidth' : 'width=\\textwidth';
            if (imgData && imgData.startsWith('data:image/')) {
                var drawIdx = ctx.imgCount || 0;
                ctx.imgCount = drawIdx + 1;
                var drawingFile;
                if (ctx.uploadedFilenames && ctx.uploadedFilenames[drawIdx]) {
                    drawingFile = ctx.uploadedFilenames[drawIdx];
                } else {
                    var drawBase = (ctx.baseName || 'image').replace(/_/g, '-');
                    drawingFile = drawBase + '-' + ctx.imgCount + '.png';
                    ctx.imageFiles = ctx.imageFiles || [];
                    ctx.imageFiles.push({ dataUrl: imgData, filename: drawingFile });
                }
                return '\\includegraphics[' + drawWidthOpt + ']{' + drawingFile + '}\n\n';
            }
            return '% [Drawing: no image data]\n\n';
        }

        // Unknown block: recurse into content
        return content.map(function (n) { return serializeBlock(n, ctx); }).join('');
    }

    function docToLatex(json, docTitle, ctx) {
        ctx = ctx || {};
        if (!json || json.type !== 'doc') return '';
        var content = json.content || [];
        var body = content.map(function (n) { return serializeBlock(n, ctx); }).join('');
        var title = (docTitle || 'Document').trim() || 'Document';
        var escapedTitle = escapeLatex(title);

        return '\\documentclass{article}\n' +
            '\\usepackage[utf8]{inputenc}\n' +
            '\\usepackage{amsmath}\n' +
            '\\usepackage{ulem}\n' +
            '\\usepackage{graphicx}\n' +
            '\\usepackage{hyperref}\n' +
            '\n' +
            '\\title{' + escapedTitle + '}\n' +
            '\\date{\\today}\n' +
            '\n' +
            '\\begin{document}\n' +
            '\\maketitle\n\n' +
            body +
            '\\end{document}\n';
    }

    function downloadFile(blob, filename) {
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    function downloadLatex() {
        var editor = window.MeEditor;
        if (!editor) return;

        var json = editor.getJSON();
        var titleInput = document.querySelector('.me-doc-title-input');
        var docTitle = titleInput ? titleInput.value.trim() : 'document';
        var baseName = docTitle.replace(/[^a-z0-9]/gi, '_') || 'document';
        var texFilename = baseName + '.tex';

        var ctx = { baseName: baseName, imgCount: 0, imageFiles: [] };
        var latex = docToLatex(json, docTitle, ctx);

        // Download embedded images first (with small delay between each), then the .tex
        var imageFiles = ctx.imageFiles || [];
        if (imageFiles.length > 0) {
            // fetch() may not work for data URLs in all browsers; use atob path
            imageFiles.forEach(function (item, i) {
                setTimeout(function () {
                    try {
                        var arr = item.dataUrl.split(',');
                        var mime = (arr[0].match(/:(.*?);/) || [])[1] || 'image/png';
                        var bstr = atob(arr[1] || '');
                        var n = bstr.length;
                        var u8 = new Uint8Array(n);
                        for (var j = 0; j < n; j++) u8[j] = bstr.charCodeAt(j);
                        var blob = new Blob([u8], { type: mime });
                        downloadFile(blob, item.filename);
                    } catch (err) {
                        console.warn('Failed to extract image:', err);
                    }
                }, i * 120);
            });
            setTimeout(function () {
                var blob = new Blob([latex], { type: 'text/plain;charset=utf-8' });
                downloadFile(blob, texFilename);
            }, imageFiles.length * 120 + 50);
        } else {
            var blob = new Blob([latex], { type: 'text/plain;charset=utf-8' });
            downloadFile(blob, texFilename);
        }
    }

    function wireExportButton() {
        var btn = document.querySelector('.me-export-menu-item[data-export="latex"]');
        if (!btn) return;
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            var menu = document.querySelector('.me-export-menu');
            if (menu) menu.classList.remove('show');
            if (window.MeExportAuth && window.MeExportAuth.requireAuthForExport) {
                window.MeExportAuth.requireAuthForExport('latex', downloadLatex);
            } else {
                downloadLatex();
            }
        });
    }

    document.addEventListener('me:editor-ready', wireExportButton);

    window.MeExportLatex = {
        download: downloadLatex,
        docToLatex: docToLatex
    };

})();

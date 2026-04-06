/**
 * code-runner.js — Code execution engine for RunnableCodeBlock
 * TipTap Math Editor
 *
 * Exposes window.MeCodeRunner:
 *   .run(language, code, stdin, outputEl)  -> Promise<void>
 *   .detectLanguage(code)                  -> string | null
 *   .getLanguages()                        -> Promise<string[]>
 */
(function () {
    'use strict';

    var ctx = window.ME_CTX || '';
    var EXECUTE_URL  = ctx + '/OneCompilerFunctionality?action=execute';
    var LANGUAGES_URL = ctx + '/OneCompilerFunctionality?action=languages';

    // =========================================================
    //  Language list cache
    // =========================================================
    var _langCache = null;
    var _langPromise = null;
    var _rawLangData = null;
    var _versionCache = {};

    function getLanguages() {
        if (_langCache) return Promise.resolve(_langCache);
        if (_langPromise) return _langPromise;
        _langPromise = fetch(LANGUAGES_URL)
            .then(function (r) {
                if (!r.ok) throw new Error('HTTP ' + r.status);
                return r.json();
            })
            .then(function (data) {
                _rawLangData = data;
                _langCache = Array.isArray(data) ? data.map(function (l) {
                    return typeof l === 'string' ? l : (l.name || l.language || String(l));
                }) : [];
                // Build version cache from the raw data
                if (Array.isArray(data)) {
                    data.forEach(function (l) {
                        var n = typeof l === 'string' ? l : (l.name || l.language || '');
                        var v = l.default_version || l.version || '';
                        if (n && v) _versionCache[n] = v;
                    });
                }
                return _langCache;
            })
            .catch(function (err) {
                console.warn('[MeCodeRunner] Failed to load languages:', err);
                _langPromise = null;
                return [];
            });
        return _langPromise;
    }

    // Prefetch so dropdown is ready before first use
    getLanguages();

    // =========================================================
    //  Version resolution
    // =========================================================
    function getVersion(language) {
        if (_versionCache[language]) return Promise.resolve(_versionCache[language]);
        return getLanguages().then(function () {
            return _versionCache[language] || '';
        });
    }

    // =========================================================
    //  Language auto-detection (most specific patterns first)
    // =========================================================
    var DETECT_RULES = [
        { lang: 'python',     pattern: /^\s*(def |import |from .+ import|print\(|if __name__|class \w+:)/m },
        { lang: 'rust',       pattern: /^\s*(fn main\(\)|fn \w+\(|let mut |println!|use std::|impl |pub fn|\.unwrap\(\)|::from\(|Vec<)/m },
        { lang: 'typescript', pattern: /^\s*(interface |type \w+ =|: string|: number|: boolean|<T>)/m },
        { lang: 'java',       pattern: /^\s*(public (class|static|void)|System\.out|import java\.|@Override)/m },
        { lang: 'cpp',        pattern: /^\s*(#include\s*<(iostream|vector|string|algorithm)|using namespace std|cout\s*<<|std::)/m },
        { lang: 'c',          pattern: /^\s*(#include\s*<(stdio|stdlib|string)\.h>|printf\(|int main\s*\()/m },
        { lang: 'javascript', pattern: /^\s*(const |var |function |=>|console\.log|require\(|module\.exports)/m },
        { lang: 'go',         pattern: /^\s*(package main|import \(|func main\(\)|fmt\.Print)/m },
        { lang: 'bash',       pattern: /^\s*(#!\/bin\/(bash|sh)|echo |grep |awk |sed |chmod |\$\{)/m },
        { lang: 'ruby',       pattern: /^\s*(def |puts |require |class \w+ < |\.each \{|do \|)/m },
        { lang: 'php',        pattern: /^\s*(<\?php|\$\w+\s*=|echo |function \w+\()/m },
        { lang: 'swift',      pattern: /^\s*(import (Foundation|UIKit)|func |@IBAction|print\(.*\))/m },
        { lang: 'kotlin',     pattern: /^\s*(fun main\(|val |var |println\(|data class )/m },
        { lang: 'r',          pattern: /^\s*(library\(|<-|data\.frame\(|ggplot\()/m },
        { lang: 'haskell',    pattern: /^\s*(main :: IO|import Data\.|module \w+ where)/m },
        { lang: 'sql',        pattern: /^\s*(SELECT |INSERT INTO|CREATE TABLE|UPDATE |DELETE FROM|DROP )/im },
        { lang: 'lua',        pattern: /^\s*(function \w+\(|local |require\(|print\()/m },
        { lang: 'csharp',     pattern: /^\s*(using System|namespace |Console\.Write|static void Main)/m },
        { lang: 'perl',       pattern: /^\s*(use strict|my \$|print |#!.*perl)/m },
        { lang: 'scala',      pattern: /^\s*(object |def main|val |var |println\(|import scala)/m },
    ];

    function detectLanguage(code) {
        if (!code || !code.trim()) return null;
        for (var i = 0; i < DETECT_RULES.length; i++) {
            if (DETECT_RULES[i].pattern.test(code)) {
                return DETECT_RULES[i].lang;
            }
        }
        return null;
    }

    // =========================================================
    //  Output rendering
    // =========================================================
    function escapeHtml(str) {
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    function renderOutput(outputEl, result) {
        var stdout = (result.stdout || result.Stdout || '').replace(/\r\n/g, '\n');
        var stderr = (result.stderr || result.Stderr || '').replace(/\r\n/g, '\n');
        var exitCode = result.exitCode != null ? result.exitCode :
                       result.ExitCode != null ? result.ExitCode : null;

        var html = '';

        if (stdout) {
            html += '<div class="me-rcb-stdout"><pre>' + escapeHtml(stdout) + '</pre></div>';
        }
        if (stderr) {
            html += '<div class="me-rcb-stderr"><pre>' + escapeHtml(stderr) + '</pre></div>';
        }
        if (!stdout && !stderr) {
            html += '<div class="me-rcb-empty">(no output)</div>';
        }
        if (exitCode != null && exitCode !== 0) {
            html += '<div class="me-rcb-exit">Exit code: ' + escapeHtml(String(exitCode)) + '</div>';
        }

        outputEl.innerHTML = html;
        outputEl.classList.remove('me-rcb-running');
    }

    function renderError(outputEl, message) {
        outputEl.innerHTML = '<div class="me-rcb-stderr"><pre>' + escapeHtml(message) + '</pre></div>';
        outputEl.classList.remove('me-rcb-running');
    }

    // =========================================================
    //  Core: run code
    //  filesOrCode: either a string (single file) or
    //               an array of {name, content} (multi-file)
    // =========================================================
    function run(language, filesOrCode, stdin, outputEl) {
        if (!outputEl) return Promise.resolve();

        // Show spinner
        outputEl.innerHTML = '<div class="me-rcb-spinner-wrap">' +
            '<span class="me-rcb-spinner"></span><span>Running...</span></div>';
        outputEl.classList.add('me-rcb-running');
        outputEl.style.display = 'block';

        var controller = new AbortController();
        var timeoutId = setTimeout(function () { controller.abort(); }, 120000);

        // Normalize: string → single file, array → multi-file
        var isMultiFile = Array.isArray(filesOrCode) && filesOrCode.length > 1;
        var isSingleFileArray = Array.isArray(filesOrCode) && filesOrCode.length === 1;

        return getVersion(language).then(function (version) {
            var payload = { language: language };
            if (version) payload.version = version;
            if (stdin) payload.input = stdin;

            if (isMultiFile) {
                // Multi-file: send files array
                payload.files = filesOrCode.map(function (f) {
                    return { name: f.name, content: f.content };
                });
            } else if (isSingleFileArray) {
                // Single file passed as array
                payload.code = filesOrCode[0].content;
            } else {
                // Plain string
                payload.code = filesOrCode;
            }

            return fetch(EXECUTE_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload),
                signal: controller.signal
            });
        }).then(function (response) {
            clearTimeout(timeoutId);
            if (!response.ok) {
                return response.text().then(function (text) {
                    throw new Error('Server error ' + response.status + ': ' + text);
                });
            }
            return response.json();
        }).then(function (result) {
            renderOutput(outputEl, result);
        }).catch(function (err) {
            clearTimeout(timeoutId);
            var msg = err.name === 'AbortError' ? 'Execution timed out (120s)' : (err.message || 'Execution failed');
            renderError(outputEl, msg);
        });
    }

    // =========================================================
    //  Expose global API
    // =========================================================
    window.MeCodeRunner = {
        run: run,
        detectLanguage: detectLanguage,
        getLanguages: getLanguages
    };

})();

/**
 * OneCompiler visualization API client (via servlet proxy).
 */
(function (global) {
    'use strict';

    var TRACER_TYPES = {
        CodeTracer: true,
        Array1DTracer: true,
        Array2DTracer: true,
        MapTracer: true,
        GraphTracer: true,
        CallStackTracer: true,
        LogTracer: true,
        VerticalLayout: true,
        HorizontalLayout: true
    };

    function resolveVizVersion(language, runVersion) {
        if (language === 'java') {
            return '21';
        }
        if (language === 'python') {
            var allowed = ['3.10', '3.11', '3.12'];
            if (runVersion && allowed.indexOf(runVersion) >= 0) {
                return runVersion;
            }
            return '3.10';
        }
        if (language === 'go') {
            return '1.26';
        }
        if (language === 'cpp' || language === 'c++') {
            return 'clang';
        }
        if (language === 'rust') {
            return 'stable';
        }
        if (language === 'rust-ownership') {
            return '0.3.7';
        }
        return runVersion || '';
    }

    function createClient(baseUrl) {
        function get(action, query) {
            var url = baseUrl + '?action=' + encodeURIComponent(action);
            if (query) {
                Object.keys(query).forEach(function (k) {
                    url += '&' + encodeURIComponent(k) + '=' + encodeURIComponent(query[k]);
                });
            }
            return fetch(url).then(function (r) {
                if (!r.ok) {
                    return r.text().then(function (t) {
                        throw new Error(t || ('HTTP ' + r.status));
                    });
                }
                return r.json();
            });
        }

        function postExecute(payload) {
            return fetch(baseUrl + '?action=execute', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            }).then(function (r) {
                return r.text().then(function (text) {
                    var data = null;
                    if (text) {
                        try {
                            data = JSON.parse(text);
                        } catch (e) {
                            throw new Error(text.slice(0, 240) || ('HTTP ' + r.status));
                        }
                    }
                    if (!r.ok || (data && data.error)) {
                        throw new Error((data && data.error) || (data && data.stderr) || text || ('HTTP ' + r.status));
                    }
                    return data || {};
                });
            });
        }

        return {
            getLanguages: function () { return get('languages'); },
            getCapabilities: function () { return get('capabilities'); },
            getLanguageCapabilities: function (lang) {
                return get('language_capabilities', { lang: lang });
            },
            execute: function (opts) {
                var body = {
                    language: opts.language,
                    version: resolveVizVersion(opts.language, opts.version)
                };
                if (opts.files && opts.files.length) {
                    body.files = opts.files;
                } else {
                    body.code = opts.code || '';
                }
                return postExecute(body);
            },
            resolveVizVersion: resolveVizVersion
        };
    }

    global.OcViz = global.OcViz || {};
    global.OcViz.TRACER_TYPES = TRACER_TYPES;
    global.OcViz.createApiClient = createClient;
    global.OcViz.resolveVizVersion = resolveVizVersion;
}(typeof window !== 'undefined' ? window : this));

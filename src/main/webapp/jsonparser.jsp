<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>

	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "JSON Beautifier, Validator, JSON ↔ YAML/XML Converter",
  "url": "https://8gwifi.org/jsonparser.jsp",
  "image": "https://8gwifi.org/images/site/jsonb.png",
  "applicationCategory": "DeveloperApplication",
  "operatingSystem": "Web",
  "browserRequirements": "Requires JavaScript. Works on modern browsers.",
  "author": { "@type": "Person", "name": "Anish Nath" },
  "offers": { "@type": "Offer", "price": "0", "priceCurrency": "USD" },
  "keywords": [
    "json formatter online",
    "json beautifier",
    "validate json online",
    "json to yaml converter",
    "json to xml converter",
    "json diff compare",
    "prettify json",
    "format json"
  ],
  "featureList": [
    "Beautify & minify JSON",
    "Validate JSON",
    "Convert JSON to YAML",
    "Convert JSON to XML",
    "JSON diff/compare"
  ]
}
</script>
<!-- FAQ for rich results -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How do I format and validate JSON online?",
      "acceptedAnswer": {"@type": "Answer", "text": "Paste your JSON and it auto‑formats and validates. Errors are shown instantly. You can also minify, sort keys, and remove nulls."}
    },
    {
      "@type": "Question",
      "name": "Can I convert JSON to YAML or XML?",
      "acceptedAnswer": {"@type": "Answer", "text": "Yes. YAML and XML outputs are generated client‑side instantly and can be copied or downloaded. A server fallback is also available."}
    },
    {
      "@type": "Question",
      "name": "Does this support JSON diff?",
      "acceptedAnswer": {"@type": "Answer", "text": "Yes. Use the Diff tab to compare two JSON documents with a colorized diff."}
    }
  ]
}
</script>
	<title>Free JSON Formatter & Validator – JSON to YAML/XML, Diff</title>
	<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
	<meta name="keywords" content="JSON formatter online, JSON beautifier, validate JSON online, JSON to YAML, JSON to XML, JSON converter, JSON diff compare, prettify JSON, format JSON"/>
	<meta name="description" content="Free online JSON formatter and validator with JSON to YAML/XML conversion and JSON diff compare. Fast, private, and works in your browser." />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

    <style>
        textarea#input { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
        .badge-muted { background:#eef2f7; color:#506690; }
        .output-pre { max-height: 360px; overflow: auto; background:#f8f9fa; border:1px solid #e5e7eb; border-radius:6px; }
        .toolbar .btn { margin-right: .35rem; margin-bottom: .35rem; }
        pre.diff { max-height: 360px; overflow:auto; background:#0f172a; color:#e2e8f0; padding:10px; border-radius:6px; }
        .diff .add { color:#10b981; }
        .diff .rem { color:#ef4444; }
        .diff .ctx { color:#94a3b8; }
        /* Highlight.js line numbers gutter styling */
        .hljs-ln-numbers { text-align: right; color: #9aa4af; border-right: 1px solid #e5e7eb; vertical-align: top; padding-right: 10px; user-select: none; }
        .hljs-ln-code { padding-left: 10px; }
        /* Unify input/output theme */
        .CodeMirror, .CodeMirror pre { background:#f8f9fa; color:#212529; }
        .CodeMirror-gutters { background:#f8f9fa; border-right:1px solid #e5e7eb; }
        #tree-container { background:#f8f9fa; }
    </style>

    <!-- Client-side conversion and tools -->
    <script src="https://cdn.jsdelivr.net/npm/js-yaml@4.1.0/dist/js-yaml.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fast-xml-parser@4.3.6/dist/fast-xml-parser.min.js"></script>
    
    <script src="https://cdn.jsdelivr.net/npm/diff@5.1.0/dist/diff.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/highlightjs-line-numbers.js@2.8.0/dist/highlightjs-line-numbers.min.js"></script>
    <!-- Ensure highlight.js languages are available even if core is slim -->
    <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.9.0/build/languages/json.min.js"></script>
    <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.9.0/build/languages/yaml.min.js"></script>
    <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.9.0/build/languages/xml.min.js"></script>
    <!-- JSONEditor (Tree view) -->
    <link href="https://cdn.jsdelivr.net/npm/jsoneditor@9.10.0/dist/jsoneditor.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jsoneditor@9.10.0/dist/jsoneditor.min.js"></script>
    <!-- CodeMirror (Input editor) -->
    <link href="https://cdn.jsdelivr.net/npm/codemirror@5.65.13/lib/codemirror.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/codemirror@5.65.13/lib/codemirror.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/codemirror@5.65.13/mode/javascript/javascript.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/codemirror@5.65.13/addon/edit/matchbrackets.js"></script>

	<script type="text/javascript">
		$(function() {
			function setStatus(msg, type){
				var $s = $('#status');
				$s.removeClass('alert-success alert-danger alert-info').addClass('alert-'+(type||'info')).text(msg).show();
			}
			function clearStatus(){ $('#status').hide().text(''); }

            function rehl(){
                try {
                    if (window.hljs) {
                        ['#json-pre','#yaml-pre','#xml-pre'].forEach(function(sel){
                            var el = document.querySelector(sel);
                            if (el) {
                                if (hljs.highlightElement) { hljs.highlightElement(el); }
                                else if (hljs.highlightBlock) { hljs.highlightBlock(el); }
                                if (hljs.lineNumbersBlock) { hljs.lineNumbersBlock(el); }
                            }
                        });
                    }
                } catch(e){}
            }

            // Editors
            var cm = null, tree = null, syncing = false;

            function getOptions(){
                return {
                    indent: parseInt($('#opt-indent').val(), 10) || 2,
                    removeNulls: $('#opt-remove-nulls').prop('checked'),
                    sortArrays: $('#opt-sort-arrays').prop('checked'),
                    sortKeys: $('#opt-sort-keys').prop('checked')
                };
            }

			function transform(obj, opts){
				function t(o){
					if (Array.isArray(o)){
						var arr = o.map(t);
						if (opts.sortArrays && arr.every(function(x){ return (typeof x!== 'object' || x===null); })){
							arr.sort();
						}
						return arr;
					}
					if (o && typeof o === 'object'){
						var keys = Object.keys(o);
						if (opts.sortKeys) keys.sort();
						var out = {};
						keys.forEach(function(k){
							var v = t(o[k]);
							if (opts.removeNulls && (v === null || v === undefined)) return;
							out[k] = v;
						});
						return out;
					}
					return o;
				}
				return t(obj);
			}

            function beautifyLocal(){
                try {
                    var raw = cm ? cm.getValue() : $('#input').val();
                    var obj = JSON.parse(raw);
                    var opts = getOptions();
                    var obj2 = transform(obj, opts);
                    var pretty = JSON.stringify(obj2, null, opts.indent);
                    $('#json-pre').text(pretty); rehl();
                    // Client-side YAML/XML conversion
                    try { $('#yaml-pre').text(jsyaml.dump(obj2, { indent: opts.indent })); } catch(e){}
                    try {
                        var builder = new window.XMLBuilder({ ignoreAttributes: false, format: true, indentBy: ' '.repeat(opts.indent) });
                        var xml = builder.build({ root: obj2 });
                        $('#xml-pre').text(xml);
                    } catch(e){}
                    try {
                        if (tree && !syncing) { syncing = true; tree.update(obj2); syncing = false; }
                    } catch(e){}
                    clearStatus();
                    return { ok:true, obj: obj, text: pretty };
                } catch(e){ setStatus('Invalid JSON: '+ e.message, 'danger'); return { ok:false }; }
            }

			function minifyLocal(){
				try { var obj = JSON.parse($('#input').val()); $('#json-pre').text(JSON.stringify(obj)); rehl(); clearStatus(); }
				catch(e){ setStatus('Invalid JSON: '+ e.message, 'danger'); }
			}

			function sortKeys(){
				try { var obj = JSON.parse($('#input').val());
					function sortDeep(o){
						if (Array.isArray(o)) return o.map(sortDeep);
						if (o && typeof o === 'object') { var k = Object.keys(o).sort(); var n={}; k.forEach(function(key){ n[key]=sortDeep(o[key]); }); return n; }
						return o;
					}
					var s = JSON.stringify(sortDeep(obj), null, 2);
					$('#json-pre').text(s); rehl(); clearStatus();
				} catch(e){ setStatus('Invalid JSON: '+ e.message, 'danger'); }
			}

			function copyText(el){ var t = $(el).text(); navigator.clipboard && navigator.clipboard.writeText(t); }
			function downloadText(filename, text){ var a=document.createElement('a'); a.href=URL.createObjectURL(new Blob([text],{type:'text/plain'})); a.download=filename; a.click(); URL.revokeObjectURL(a.href); }

            function requestServer(){
                $('#convertBtn').prop('disabled', true);
                $('#spinner').show();
                $.ajax({ type:'POST', url:'JSONFunctionality', data: $('#form').serialize(), success: function(html){
					try {
						var $tmp = $('<div>').html(html);
						var $tas = $tmp.find('textarea');
						if ($tas.length >= 3) {
							$('#json-pre').text($($tas[0]).text());
							$('#yaml-pre').text($($tas[1]).text());
							$('#xml-pre').text($($tas[2]).text());
						} else if ($tas.length === 2) {
							$('#json-pre').text($($tas[0]).text());
							$('#yaml-pre').text($($tas[1]).text());
						}
						rehl();
						clearStatus();
					} catch(e){ setStatus('Conversion error: '+e.message, 'danger'); }
                }, error: function(){ setStatus('Server error during conversion', 'danger'); }, complete:function(){ $('#spinner').hide(); $('#convertBtn').prop('disabled', false);} });
            }

            // Helpers for Diff (used by auto-update)
            function runDiff(){
                try {
                    var a = JSON.stringify(transform(JSON.parse($('#input').val()||'{}'), getOptions()), null, getOptions().indent);
                    var bTxt = $('#inputB').val(); if (!bTxt) { $('#diffOut').html(''); return; }
                    var b = JSON.stringify(transform(JSON.parse(bTxt), getOptions()), null, getOptions().indent);
                    var parts = Diff.diffLines(a, b);
                    var html = '';
                    parts.forEach(function(p){ var cls = p.added ? 'add' : p.removed ? 'rem' : 'ctx'; html += '<span class="'+cls+'">'+$('<div>').text(p.value).html()+'</span>'; });
                    $('#diffOut').html(html); clearStatus();
                } catch(e){ setStatus('Diff error: '+e.message, 'danger'); }
            }

			$('#beautifyBtn').on('click', function(){ if (beautifyLocal().ok) { /* no-op */ } });
			$('#minifyBtn').on('click', minifyLocal);
			$('#sortBtn').on('click', sortKeys);
			$('#copyJson').on('click', function(){ copyText('#json-pre'); });
			$('#copyYaml').on('click', function(){ copyText('#yaml-pre'); });
			$('#copyXml').on('click', function(){ copyText('#xml-pre'); });
			$('#dlJson').on('click', function(){ downloadText('8gwifi-json.json', $('#json-pre').text()); });
			$('#dlYaml').on('click', function(){ downloadText('8gwifi-json.yaml', $('#yaml-pre').text()); });
			$('#dlXml').on('click', function(){ downloadText('8gwifi-json.xml', $('#xml-pre').text()); });

            $('#convertBtn').on('click', function(e){ e.preventDefault(); var v = beautifyLocal(); if (v.ok) { requestServer(); } });
            $('#convertBtnTop').on('click', function(e){ e.preventDefault(); var v = beautifyLocal(); if (v.ok) { $('#spinnerTop').show(); requestServer(); } });
            // Diff
            $('#diffBtn').on('click', function(){ runDiff(); });

            // Auto-update: beautify and outputs while typing (debounced)
            var updDeb = null, dfDeb = null;
            $('#input').on('input', function(){ clearTimeout(updDeb); updDeb = setTimeout(function(){ beautifyLocal(); runDiff(); }, 300); });
            $('#inputB').on('input', function(){ clearTimeout(dfDeb); dfDeb = setTimeout(runDiff, 300); });
            $('#opt-indent, #opt-sort-keys, #opt-sort-arrays, #opt-remove-nulls').on('change', function(){ beautifyLocal(); runDiff(); });
            // Show/hide Diff editor when switching tabs
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                var target = $(e.target).attr('href'); // e.g., #tab-diff
                if (target === '#tab-diff') {
                    $('#diff-editor').slideDown(150);
                } else {
                    $('#diff-editor').slideUp(150);
                }
            });

            // Init CodeMirror
            try {
                if (window.CodeMirror) {
                    cm = CodeMirror.fromTextArea(document.getElementById('input'), {
                        lineNumbers: true,
                        mode: { name: 'javascript', json: true },
                        matchBrackets: true,
                        tabSize: parseInt($('#opt-indent').val(),10) || 2,
                        indentUnit: parseInt($('#opt-indent').val(),10) || 2,
                        lineWrapping: true,
                        theme: 'default'
                    });
                    cm.on('change', function(){ $('#input').trigger('input'); });
                }
            } catch(e){}

            // Init JSONEditor Tree (editable) and sync back
            try {
                var el = document.getElementById('tree-container');
                if (el && window.JSONEditor) {
                    tree = new JSONEditor(el, { mode: 'tree', mainMenuBar: true, navigationBar: false, statusBar: false });
                    tree.on('change', function(){
                        if (syncing) return;
                        try {
                            var data = tree.get();
                            var pretty = JSON.stringify(data, null, getOptions().indent);
                            syncing = true;
                            if (cm) cm.setValue(pretty); else $('#input').val(pretty);
                            syncing = false;
                            beautifyLocal();
                            runDiff();
                        } catch(e){}
                    });
                }
            } catch(e){}
            // Sync indent change to CodeMirror
            $('#opt-indent').on('change', function(){ if (cm) { var v = parseInt(this.value,10)||2; cm.setOption('tabSize', v); cm.setOption('indentUnit', v); }});
            // Jump to tab links
            $('[data-jump]').on('click', function(e){
                e.preventDefault();
                var id = $(this).data('jump');
                var $tab = $('a[href="#'+id+'"][data-toggle="tab"]');
                if ($tab.length) { $tab.tab('show'); }
                var $outputCard = $(".card:contains('Output')").first();
                if ($outputCard.length) {
                    $('html, body').animate({ scrollTop: $outputCard.offset().top - 80 }, 200);
                }
            });

            // Tree-only toggle
            function applyTreeOnly(){
                var on = $('#toggleTreeOnly').prop('checked');
                var $json = $("a[href='#tab-json'][data-toggle='tab']").closest('li');
                var $yaml = $("a[href='#tab-yaml'][data-toggle='tab']").closest('li');
                var $xml  = $("a[href='#tab-xml'][data-toggle='tab']").closest('li');
                if (on) {
                    $json.hide(); $yaml.hide(); $xml.hide();
                    $('.jump-text').hide();
                    // If current tab is hidden, switch to tree
                    var $active = $('#outTabs .nav-link.active');
                    if ($active.attr('href') !== '#tab-tree') {
                        $("a[href='#tab-tree'][data-toggle='tab']").tab('show');
                    }
                } else {
                    $json.show(); $yaml.show(); $xml.show();
                    $('.jump-text').show();
                }
            }
            $('#toggleTreeOnly').on('change', applyTreeOnly);
            applyTreeOnly();
			$('#clearBtn').on('click', function(){ $('#input').val(''); $('#json-pre,#yaml-pre,#xml-pre').text(''); clearStatus(); });
			$('#fileBtn').on('change', function(e){ var f=e.target.files[0]; if (!f) return; var r=new FileReader(); r.onload=function(){ $('#input').val(r.result); beautifyLocal(); }; r.readAsText(f); });
			$('#sampleBtn').on('click', function(){
				var sample = { employees:{ employee:[ {id:1, firstName:'Tom', lastName:'Cruise'}, {id:2, firstName:'Maria', lastName:'Sharapova'} ] } };
				$('#input').val(JSON.stringify(sample, null, 2)); beautifyLocal();
			});

			// Initial pretty print of default
			beautifyLocal();
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">JSON Beautifier & Converter</h1>
<p class="mb-3">Validate/format JSON and convert to YAML or XML. Paste, upload a file, or try a sample.</p>

<div id="status" class="alert alert-info" style="display:none;"></div>

<!-- Sticky quick actions -->
<div class="sticky-topbar d-flex align-items-center">
    <button type="button" id="convertBtnTop" class="btn btn-success btn-sm">Convert to YAML/XML <span id="spinnerTop" class="spinner-border spinner-border-sm" style="display:none" role="status" aria-hidden="true"></span></button>
    <span class="text-muted small ml-2 mr-2">Jump to:</span>
    <a href="#" class="btn btn-light btn-sm mr-1" data-jump="tab-tree">Tree</a>
    <a href="#" class="btn btn-light btn-sm mr-1 jump-text" data-jump="tab-json">JSON</a>
    <a href="#" class="btn btn-light btn-sm mr-1 jump-text" data-jump="tab-yaml">YAML</a>
    <a href="#" class="btn btn-light btn-sm mr-1 jump-text" data-jump="tab-xml">XML</a>
    <a href="#" class="btn btn-light btn-sm" data-jump="tab-diff">Diff</a>
</div>

<form id="form" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="formatjson">
    <div class="row">
        <div class="col-lg-6 mb-3">
            <div class="card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">Input JSON
                    <div>
                        <label class="btn btn-sm btn-outline-secondary mb-0 mr-1">Open <input id="fileBtn" type="file" accept="application/json,.json,.txt" style="display:none"></label>
                        <button type="button" id="sampleBtn" class="btn btn-sm btn-outline-secondary">Sample</button>
                    </div>
                </div>
                <div class="card-body">
                    <textarea rows="16" class="form-control" name="input" id="input">{"employees":{"employee":[{"id":"1","firstName":"Tom","lastName":"Cruise"},{"id":"2","firstName":"Maria","lastName":"Sharapova"}]}}</textarea>
                    <div id="diff-editor" class="mt-3" style="display:none;">
                        <label class="font-weight-bold">JSON B (for Diff)</label>
                        <textarea rows="8" class="form-control" id="inputB" placeholder="Paste second JSON for comparison (optional)"></textarea>
                    </div>
                </div>
                <div class="card-footer toolbar">
                    <div class="mr-2">
                        <select id="opt-indent" class="custom-select custom-select-sm" style="width:auto; display:inline-block;">
                            <option value="2" selected>Indent: 2</option>
                            <option value="4">Indent: 4</option>
                        </select>
                        <div class="form-check form-check-inline ml-2">
                            <input class="form-check-input" type="checkbox" id="opt-sort-keys"><label class="form-check-label" for="opt-sort-keys">Sort keys</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="opt-sort-arrays"><label class="form-check-label" for="opt-sort-arrays">Sort arrays</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="opt-remove-nulls"><label class="form-check-label" for="opt-remove-nulls">Remove nulls</label>
                        </div>
                    </div>
                    <button type="button" id="beautifyBtn" class="btn btn-primary btn-sm">Validate & Beautify</button>
                    <button type="button" id="minifyBtn" class="btn btn-outline-secondary btn-sm">Minify</button>
                    <button type="button" id="sortBtn" class="btn btn-outline-secondary btn-sm">Sort Keys</button>
                    <button type="button" id="clearBtn" class="btn btn-outline-danger btn-sm">Clear</button>
                    <button type="button" id="convertBtn" class="btn btn-success btn-sm float-right">Convert to YAML/XML <span id="spinner" class="spinner-border spinner-border-sm" style="display:none" role="status" aria-hidden="true"></span></button>
                </div>
            </div>
        </div>

        <div class="col-lg-6 mb-3">
            <div class="card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">Output
                    <div class="d-flex align-items-center">
                        <button type="button" id="copyJson" class="btn btn-sm btn-outline-secondary">Copy JSON</button>
                        <button type="button" id="dlJson" class="btn btn-sm btn-outline-secondary">Download</button>
                        <div class="form-check form-check-inline ml-2">
                            <input class="form-check-input" type="checkbox" id="toggleTreeOnly">
                            <label class="form-check-label" for="toggleTreeOnly">Tree only</label>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <ul class="nav nav-tabs" id="outTabs" role="tablist">
                        <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#tab-tree" role="tab">Tree</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#tab-json" role="tab">JSON</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#tab-yaml" role="tab">YAML</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#tab-xml" role="tab">XML</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#tab-diff" role="tab">Diff</a></li>
                    </ul>
                    <div class="tab-content pt-3">
                        <div class="tab-pane fade show active" id="tab-tree" role="tabpanel">
                            <div id="tree-container" style="height:360px; border:1px solid #e5e7eb; border-radius:6px;"></div>
                        </div>
                        <div class="tab-pane fade" id="tab-json" role="tabpanel">
                            <pre class="output-pre"><code id="json-pre" class="language-json"></code></pre>
                        </div>
                        <div class="tab-pane fade" id="tab-yaml" role="tabpanel">
                            <div class="d-flex justify-content-end mb-2">
                                <button type="button" id="copyYaml" class="btn btn-sm btn-outline-secondary mr-2">Copy</button>
                                <button type="button" id="dlYaml" class="btn btn-sm btn-outline-secondary">Download</button>
                            </div>
                            <pre class="output-pre"><code id="yaml-pre" class="language-yaml"></code></pre>
                        </div>
                        <div class="tab-pane fade" id="tab-xml" role="tabpanel">
                            <div class="d-flex justify-content-end mb-2">
                                <button type="button" id="copyXml" class="btn btn-sm btn-outline-secondary mr-2">Copy</button>
                                <button type="button" id="dlXml" class="btn btn-sm btn-outline-secondary">Download</button>
                            </div>
                            <pre class="output-pre"><code id="xml-pre" class="language-xml"></code></pre>
                        </div>
                        <div class="tab-pane fade" id="tab-diff" role="tabpanel">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="text-muted small">Compare Input JSON (left) vs JSON B (left below)</div>
                                <button type="button" id="diffBtn" class="btn btn-sm btn-outline-secondary">Compare</button>
                            </div>
                            <pre id="diffOut" class="diff"></pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<h2 class="mt-4">Try Other Converters</h2>
<div class="row">
	<div>
		<ul>
			<li><a href="yamlparser.jsp">YAML-2-JSON/XML</a></li>
			<li><a href="xml2json.jsp">XML-2-JSON/YAML</a></li>
			<li><a href="jsonparser.jsp">JSON-2-YAML/XML</a></li>
			<li><a href="json-2-csv.jsp">JSON-2-CSV</a></li>
		</ul>
	</div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Reusable Code Editor Component Parameters: - initialHtml: The initial HTML code to display - initialCss:
        (Optional) Initial CSS code - initialJs: (Optional) Initial JavaScript code - editorId: (Optional) Unique ID for
        this editor instance (default: 'editor1' ) --%>
        <% String initialHtml=request.getParameter("initialHtml"); if (initialHtml==null)
            initialHtml="<!-- Write your HTML here -->" ; String initialCss=request.getParameter("initialCss"); if
            (initialCss==null) initialCss="/* CSS */" ; String initialJs=request.getParameter("initialJs"); if
            (initialJs==null) initialJs="// JavaScript" ; String editorId=request.getParameter("editorId"); if
            (editorId==null) editorId="editor1" ; %>

            <div class="editor-container" id="<%= editorId %>-container">
                <div class="editor-header">
                    <div class="editor-tabs">
                        <div class="editor-tab active" data-tab="html" onclick="switchTab('<%= editorId %>', 'html')">
                            HTML</div>
                        <div class="editor-tab" data-tab="css" onclick="switchTab('<%= editorId %>', 'css')">CSS</div>
                        <div class="editor-tab" data-tab="js" onclick="switchTab('<%= editorId %>', 'js')">JS</div>
                    </div>
                    <div class="editor-actions">
                        <button class="btn btn-secondary btn-sm" onclick="resetCode('<%= editorId %>')">Reset</button>
                        <button class="btn btn-primary btn-sm btn-run" onclick="runCode('<%= editorId %>')">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"
                                style="margin-right: 4px;">
                                <path d="M8 5v14l11-7z" />
                            </svg>
                            Run
                        </button>
                    </div>
                </div>

                <div class="editor-content">
                    <div class="code-pane active" id="<%= editorId %>-html">
                        <textarea id="<%= editorId %>-html-code" class="code-textarea"><%= initialHtml %></textarea>
                    </div>
                    <div class="code-pane" id="<%= editorId %>-css" style="display: none;">
                        <textarea id="<%= editorId %>-css-code" class="code-textarea"><%= initialCss %></textarea>
                    </div>
                    <div class="code-pane" id="<%= editorId %>-js" style="display: none;">
                        <textarea id="<%= editorId %>-js-code" class="code-textarea"><%= initialJs %></textarea>
                    </div>
                </div>

            </div>

            <script>
                // Safety stubs to prevent ReferenceError if user clicks before JS loads
                if (typeof window.runCode === 'undefined') {
                    window.runCode = function () {
                        if (window.TUTORIAL_CORE_LOADED) {
                            console.warn('Tutorial JS loaded but runCode not defined?');
                        } else {
                            console.warn('Tutorial JS not loaded yet');
                        }
                    };
                }
                if (typeof window.switchTab === 'undefined') {
                    window.switchTab = function () { console.warn('Tutorial JS not loaded yet'); };
                }

                // Fix escaped newlines from JSP params (converts literal \n to actual newlines)
                (function () {
                    var textareas = document.querySelectorAll('#<%= editorId %>-container textarea');
                    textareas.forEach(function (ta) {
                        ta.value = ta.value.replace(/\\n/g, '\n').replace(/\\t/g, '\t');
                    });
                })();

                // Initialize editors when the DOM is ready
                // Note: The actual initialization logic should be in tutorial-core.js to avoid duplicate code
                // checking if initEditor exists to avoid errors if tutorial-core.js isn't loaded yet
                if (typeof initEditor === 'function') {
                    initEditor('<%= editorId %>');
                } else {
                    window.addEventListener('load', function () {
                        if (typeof initEditor === 'function') {
                            initEditor('<%= editorId %>');
                        }
                    });
                }
            </script>
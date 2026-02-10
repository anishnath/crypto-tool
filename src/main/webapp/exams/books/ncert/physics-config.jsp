<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.File" %>
<%
    // === Generic Physics Book Configuration ===
    // Wrappers set: bookClass ("class-12", "class-11", "undergraduate", etc.)
    //               bookPart  ("physics-part-1", "physics-part-2", "physics", etc.)
    // This config loads chapter metadata from data/chapters-meta.json

    String bookClass = (String) request.getAttribute("bookClass");
    if (bookClass == null) bookClass = "class-12";

    String bookPart = (String) request.getAttribute("bookPart");
    if (bookPart == null) bookPart = "physics-part-1";

    // Derive display label: "class-12" -> "Class 12", "undergraduate" -> "Undergraduate"
    StringBuilder _clb = new StringBuilder();
    for (String _w : bookClass.replace("-", " ").split(" ")) {
        if (_clb.length() > 0) _clb.append(" ");
        _clb.append(Character.toUpperCase(_w.charAt(0)));
        if (_w.length() > 1) _clb.append(_w.substring(1));
    }
    String bookClassLabel = _clb.toString();

    // Load chapter metadata from chapters-meta.json
    String subject = "Physics";
    String partLabel = "";
    Map<String, String[]> chapterMap = new LinkedHashMap<>();

    try {
        String _metaPath = application.getRealPath("/exams/books/ncert/" + bookClass + "/" + bookPart + "/data/chapters-meta.json");
        File _metaFile = new File(_metaPath);
        if (_metaFile.exists()) {
            BufferedReader _br = new BufferedReader(new FileReader(_metaFile));
            StringBuilder _sb = new StringBuilder();
            String _ln;
            while ((_ln = _br.readLine()) != null) _sb.append(_ln);
            _br.close();
            String _mj = _sb.toString();

            // Extract "subject" value
            int _si = _mj.indexOf("\"subject\"");
            if (_si != -1) {
                int _svs = _mj.indexOf("\"", _si + 9) + 1;
                int _sve = _mj.indexOf("\"", _svs);
                subject = _mj.substring(_svs, _sve);
            }

            // Extract "partLabel" value
            int _pi = _mj.indexOf("\"partLabel\"");
            if (_pi != -1) {
                int _pvs = _mj.indexOf("\"", _pi + 11) + 1;
                int _pve = _mj.indexOf("\"", _pvs);
                partLabel = _mj.substring(_pvs, _pve);
            }

            // Extract chapters array entries
            int _ci = _mj.indexOf("\"chapters\"");
            if (_ci != -1) {
                int _as = _mj.indexOf("[", _ci);
                int _ae = _mj.lastIndexOf("]");
                if (_as != -1 && _ae > _as) {
                    String _cj = _mj.substring(_as, _ae + 1);
                    int _pos = 0;
                    while (_pos < _cj.length()) {
                        int _slugI = _cj.indexOf("\"slug\"", _pos);
                        if (_slugI == -1) break;
                        int _s1 = _cj.indexOf("\"", _slugI + 6) + 1;
                        int _s2 = _cj.indexOf("\"", _s1);
                        String _slug = _cj.substring(_s1, _s2);

                        int _numI = _cj.indexOf("\"num\"", _s2);
                        int _n1 = _cj.indexOf("\"", _numI + 5) + 1;
                        int _n2 = _cj.indexOf("\"", _n1);
                        String _num = _cj.substring(_n1, _n2);

                        int _nameI = _cj.indexOf("\"name\"", _n2);
                        int _nm1 = _cj.indexOf("\"", _nameI + 6) + 1;
                        int _nm2 = _cj.indexOf("\"", _nm1);
                        String _name = _cj.substring(_nm1, _nm2);

                        int _descI = _cj.indexOf("\"desc\"", _nm2);
                        int _d1 = _cj.indexOf("\"", _descI + 6) + 1;
                        int _d2 = _cj.indexOf("\"", _d1);
                        String _desc = _cj.substring(_d1, _d2);

                        chapterMap.put(_slug, new String[]{_num, _name, _desc});
                        _pos = _d2 + 1;
                    }
                }
            }
        }
    } catch (Exception e) {
        // Silently fail - chapterMap may be empty
    }

    // Build combined label: "Class 12 Physics Part 2" or "Class 11 Physics"
    String fullLabel = bookClassLabel + " " + subject;
    if (partLabel != null && !partLabel.isEmpty()) {
        fullLabel += " " + partLabel;
    }

    // Extract chapter slug from URL path
    String requestURI = request.getRequestURI();
    String chapterSlug = "";
    String[] pathParts = requestURI.split("/");
    for (int i = 0; i < pathParts.length; i++) {
        if (bookPart.equals(pathParts[i]) && i + 1 < pathParts.length) {
            chapterSlug = pathParts[i + 1];
            break;
        }
    }
    if (chapterSlug.endsWith("/")) chapterSlug = chapterSlug.substring(0, chapterSlug.length() - 1);
    if (chapterSlug.endsWith(".jsp")) chapterSlug = chapterSlug.substring(0, chapterSlug.length() - 4);
    // Ignore non-chapter path segments
    if ("data".equals(chapterSlug) || "diagrams".equals(chapterSlug)) chapterSlug = "";

    // Look up chapter info
    String[] chapterData = chapterMap.get(chapterSlug);
    String chapterNum = chapterData != null ? chapterData[0] : "";
    String chapterName = chapterData != null ? chapterData[1] : "";
    String chapterMetaDesc = chapterData != null ? chapterData[2] : "";
%>

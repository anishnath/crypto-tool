<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false" %><%@
 page import="java.net.*, java.io.*, java.nio.charset.StandardCharsets" %><%!
  // ── PubChem PUG-REST proxy (CORS bypass + input validation) ──────────────
  // Formula search is asynchronous: the formula endpoint may return a ListKey
  // ("Waiting"); the client then polls the listkey endpoint until it resolves
  // to a PropertyTable or a Fault. This proxy just forwards PubChem's JSON
  // verbatim for two whitelisted endpoints — the client owns the polling loop.
  private static final String PUG = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/";
  private static final String PROPS = "/property/IsomericSMILES,CanonicalSMILES/JSON";

  private String fetch(String urlStr, javax.servlet.http.HttpServletResponse resp) throws IOException {
    HttpURLConnection conn = null;
    try {
      conn = (HttpURLConnection) new URL(urlStr).openConnection();
      conn.setRequestMethod("GET");
      conn.setConnectTimeout(8000);
      conn.setReadTimeout(20000);
      conn.setRequestProperty("Accept", "application/json");
      conn.setRequestProperty("User-Agent", "8gwifi.org-chemistry-tool/1.0 (formula-to-molecule)");
      int code = conn.getResponseCode();
      resp.setStatus(code >= 200 && code < 300 ? 200 : code);
      InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
      if (is == null) return "{\"Fault\":{\"Code\":\"PROXY.Empty\",\"Message\":\"No response body\"}}";
      ByteArrayOutputStream bos = new ByteArrayOutputStream();
      byte[] buf = new byte[8192]; int n;
      while ((n = is.read(buf)) != -1) bos.write(buf, 0, n);
      return new String(bos.toByteArray(), StandardCharsets.UTF_8);
    } finally {
      if (conn != null) conn.disconnect();
    }
  }
%><%
  response.setHeader("Access-Control-Allow-Origin", "*");
  response.setCharacterEncoding("UTF-8");

  String action  = request.getParameter("action");
  String formula = request.getParameter("formula");
  String listkey = request.getParameter("listkey");
  String name    = request.getParameter("name");
  String body;

  try {
    if ("name".equals(action)) {
      // Resolve a substance name → molecular formula + SMILES (for the balancer).
      if (name == null || !name.matches("^[A-Za-z0-9 ()\\[\\],.'\\-]{1,80}$")) {
        response.setStatus(400);
        body = "{\"Fault\":{\"Code\":\"PROXY.BadRequest\",\"Message\":\"Invalid name\"}}";
      } else {
        body = fetch(PUG + "name/" + URLEncoder.encode(name, "UTF-8")
                + "/property/MolecularFormula,IsomericSMILES,CanonicalSMILES/JSON", response);
      }
    } else if ("listkey".equals(action)) {
      if (listkey == null || !listkey.matches("^[0-9]{1,40}$")) {
        response.setStatus(400);
        body = "{\"Fault\":{\"Code\":\"PROXY.BadRequest\",\"Message\":\"Invalid listkey\"}}";
      } else {
        body = fetch(PUG + "listkey/" + listkey + PROPS, response);
      }
    } else { // default: formula search
      if (formula == null || !formula.matches("^[A-Za-z0-9()\\[\\]+\\-]{1,80}$")) {
        response.setStatus(400);
        body = "{\"Fault\":{\"Code\":\"PROXY.BadRequest\",\"Message\":\"Invalid molecular formula\"}}";
      } else {
        body = fetch(PUG + "formula/" + URLEncoder.encode(formula, "UTF-8") + PROPS, response);
      }
    }
  } catch (Exception e) {
    response.setStatus(502);
    body = "{\"Fault\":{\"Code\":\"PROXY.Upstream\",\"Message\":\"PubChem request failed\"}}";
  }
%><%= body %>

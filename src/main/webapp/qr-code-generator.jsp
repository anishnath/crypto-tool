<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QR Code Generator – Free Online QR Maker (PNG/SVG)</title>
    <meta name="description" content="Generate QR codes for text or URLs. Customize size, colors, error correction, and download as PNG or SVG. Free online QR code maker.">
    <meta name="keywords" content="qr code generator, free qr code maker, qr code svg, qr code png, online qr generator">
    <!-- Single JS lib: kjua (supports canvas and SVG) -->
    <script src="https://cdn.jsdelivr.net/npm/kjua@0.9.0/dist/kjua.min.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "QR Code Generator",
      "applicationCategory": "UtilityApplication",
      "description": "Create QR codes for text and URLs with custom colors and sizes. Download as PNG or SVG.",
      "url": "https://8gwifi.org/qr-code-generator.jsp",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">QR Code Generator</h1>
    <p>Enter text or a URL, customize options, and generate a QR code. Download as PNG or SVG for sharing or printing.</p>

    <form id="qr-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="qrText">Text / URL</label>
                            <textarea class="form-control" id="qrText" rows="3" placeholder="https://example.com">https://8gwifi.org</textarea>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="qrSize">Size (px)</label>
                                <input type="number" class="form-control" id="qrSize" value="256" min="120" max="1024">
                            </div>
                            <div class="form-group col-6">
                                <label for="qrMargin">Margin (modules)</label>
                                <input type="number" class="form-control" id="qrMargin" value="2" min="0" max="10">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="qrColor">Foreground</label>
                                <input type="color" class="form-control" id="qrColor" value="#000000">
                            </div>
                            <div class="form-group col-6">
                                <label for="qrBg">Background</label>
                                <input type="color" class="form-control" id="qrBg" value="#ffffff">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="qrEcc">Error Correction</label>
                                <select id="qrEcc" class="form-control">
                                    <option value="L">Low (L)</option>
                                    <option value="M" selected>Medium (M)</option>
                                    <option value="Q">Quartile (Q)</option>
                                    <option value="H">High (H)</option>
                                </select>
                            </div>
                            <div class="form-group col-6">
                                <label for="qrFormat">Format</label>
                                <select id="qrFormat" class="form-control">
                                    <option value="png" selected>PNG (Canvas)</option>
                                    <option value="svg">SVG (Vector)</option>
                                </select>
                            </div>
                        </div>

                        <button type="button" class="btn btn-primary" id="btnGen">Generate</button>
                        <button type="button" class="btn btn-outline-success ml-2" id="btnDownload">Download</button>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Tips:
                    <ul class="mb-0">
                        <li>Use a higher size (e.g., 512 px) for print quality. SVG is best for vectors.</li>
                        <li>Higher error correction (H) is more robust but increases density.</li>
                        <li>Test your QR with a phone camera before publishing.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Preview</div>
                    <div class="card-body text-center">
                        <div id="qrPreview" class="d-inline-block p-2 border rounded"></div>
                        <div class="mt-3">
                            <small class="text-muted">Right-click the image to copy, or use Download.</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
var currentNode = null;
var lastFormat = "png";

function genQR(){
  var text = document.getElementById("qrText").value || "";
  var size = parseInt(document.getElementById("qrSize").value, 10) || 256;
  var margin = parseInt(document.getElementById("qrMargin").value, 10) || 2;
  var color = document.getElementById("qrColor").value || "#000000";
  var bg = document.getElementById("qrBg").value || "#ffffff";
  var ecc = document.getElementById("qrEcc").value || "M";
  var fmt = document.getElementById("qrFormat").value || "png";
  lastFormat = fmt;

  var opts = {
    text: text,
    size: size,
    fill: color,
    back: bg,
    ecLevel: ecc,
    quiet: margin,
    rounded: 0,
    crisp: true,
    render: (fmt === "svg") ? "svg" : "canvas"
  };

  var preview = document.getElementById("qrPreview");
  preview.innerHTML = "";
  currentNode = kjua(opts);
  preview.appendChild(currentNode);
}

function downloadQR(){
  if (!currentNode){ genQR(); }
  var fmt = lastFormat;
  if (fmt === "svg"){
    // Serialize SVG
    var svgEl = currentNode; // kjua returns SVG element when render=svg
    var serializer = new XMLSerializer();
    var svgStr = serializer.serializeToString(svgEl);
    var blob = new Blob([svgStr], {type: "image/svg+xml;charset=utf-8"});
    var url = URL.createObjectURL(blob);
    triggerDownload(url, "qr-code.svg");
  } else {
    // Canvas to PNG
    var canvas = currentNode; // kjua returns canvas element when render=canvas
    var url = canvas.toDataURL("image/png");
    triggerDownload(url, "qr-code.png");
  }
}

function triggerDownload(url, filename){
  var a = document.createElement("a");
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  if (url.startsWith("blob:")) URL.revokeObjectURL(url);
}

document.getElementById("btnGen").addEventListener("click", genQR);
document.getElementById("btnDownload").addEventListener("click", downloadQR);

// Auto-generate on load
genQR();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>

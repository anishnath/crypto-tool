<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Free URL Shortener & Link Analytics (QR) – Short Links, Track Clicks</title>
  <meta name="description" content="Free URL shortener to create short links and track clicks. Link analytics with daily charts, top countries, referrers, and QR codes. No login required.">
  <meta name="keywords" content="url shortener, free url shortener, link shortener, create short link, short url, shorten url online, qr code short link, link analytics, track link clicks, link tracker">
  <!-- Open Graph / Twitter for rich previews -->
  <meta property="og:title" content="Free URL Shortener & Link Analytics (QR) – Short Links, Track Clicks">
  <meta property="og:description" content="Create short links and track clicks with daily charts, countries, referrers, and QR codes. No login required.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/short.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/qrcodegen.png">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Free URL Shortener & Link Analytics (QR)">
  <meta name="twitter:description" content="Create short links and track clicks with daily charts, countries, referrers, and QR codes.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/qrcodegen.png">

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Free URL Shortener & Link Analytics (QR)",
    "applicationCategory": "UtilitiesApplication",
    "url": "https://8gwifi.org/short.jsp",
    "description": "Create short links and track clicks with daily charts, countries, referrers, and QR codes.",
    "offers": {"@type":"Offer","price":"0","priceCurrency":"USD"},
    "keywords": [
      "url shortener",
      "free url shortener",
      "link shortener",
      "create short link",
      "short url",
      "qr code short link",
      "link analytics",
      "track link clicks"
    ],
    "featureList": [
      "Shorten long links",
      "QR code for short link",
      "Daily clicks chart",
      "Top countries",
      "Top referrers"
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": "How do I shorten a URL?",
        "acceptedAnswer": {"@type": "Answer", "text": "Paste your long link, click Shorten URL, then copy the short URL or scan the QR code."}
      },
      {
        "@type": "Question",
        "name": "Is this URL shortener free?",
        "acceptedAnswer": {"@type": "Answer", "text": "Yes, it’s free and does not require login."}
      },
      {
        "@type": "Question",
        "name": "Can I track clicks for my short link?",
        "acceptedAnswer": {"@type": "Answer", "text": "Yes. Enter the short code in Analytics to see all‑time clicks, a 30‑day chart, top countries and referrers."}
      },
      {
        "@type": "Question",
        "name": "Do you provide QR codes?",
        "acceptedAnswer": {"@type": "Answer", "text": "Yes, a QR code is generated for every short link so you can share it offline."}
      }
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "HowTo",
    "name": "How to shorten a URL and view analytics",
    "step": [
      {"@type": "HowToStep", "name": "Paste URL", "text": "Enter a long link that starts with http:// or https://"},
      {"@type": "HowToStep", "name": "Shorten", "text": "Click Shorten URL to create a short link and QR code"},
      {"@type": "HowToStep", "name": "Track", "text": "Use the short code in Analytics to view clicks by day, countries and referrers"}
    ]
  }
  </script>

  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
  <style>
    /* Subtle, modern refinements without changing base layout */
    .toolbar .btn { margin-right:.35rem; margin-bottom:.35rem; }
    .muted { color:#6c757d; }
    .small-label { font-size:.85rem; color:#6c757d; }
    .card { border-radius: 12px; }
    .card-header { background: linear-gradient(180deg,#ffffff,#fafbfc); border-bottom: 1px solid #eef0f3; font-weight: 600; }
    .card.shadow-sm { box-shadow: 0 4px 24px rgba(0,0,0,.05) !important; }
    .btn { border-radius: 999px; }
    .btn-outline-primary { border-color:#6c8bf5; color:#3c5be8; }
    .btn-outline-primary:hover { background:#3c5be8; color:#fff; }
    .btn-primary { background:#3c5be8; border-color:#3c5be8; }
    .kpi { padding:.9rem; border:1px solid #eef0f3; border-radius:10px; background:#f8f9fb; display:flex; flex-direction:column; gap:.15rem; }
    .kpi .val { font-weight:700; font-size:1.05rem; }
    .kpi::before { content: ""; display:block; width:100%; height:3px; border-radius:999px; background:linear-gradient(90deg,#3c5be8,#46c1a1); margin-bottom:.35rem; opacity:.85; }
    .input-group-text { background:#f1f3f8; border-color:#e5e7eb; }
    .form-control { border-color:#e5e7eb; }
    #qrcode canvas { border-radius:8px; box-shadow: 0 4px 16px rgba(0,0,0,.06); }
    table.table th { font-weight:600; color:#4b5563; border-top:0; }
  </style>
</head>
<%@ include file="body-script.jsp"%>

  <h1 class="mb-2">URL Shortener</h1>
  <p class="mb-3">Create short links and track performance. Paste your long URL, shorten, then view clicks over time with top countries and referrers.</p>

  <div class="card mb-3 shadow-sm">
    <div class="card-header">Shorten a URL</div>
    <div class="card-body">
      <div class="form-row align-items-end">
        <div class="form-group col-md-8">
          <label for="longUrl">Long URL</label>
          <div class="input-group input-group-lg">
            <div class="input-group-prepend"><span class="input-group-text">🔗</span></div>
            <input type="url" class="form-control" id="longUrl" placeholder="https://example.com/very/long/link">
          </div>
          <small class="muted">Must start with http:// or https://</small>
        </div>
        <div class="form-group col-md-4">
          <button id="btnShorten" class="btn btn-primary btn-block">Shorten URL</button>
        </div>
      </div>

      <div id="shortResult" class="mt-3" style="display:none;">
        <div class="d-flex align-items-center flex-wrap">
          <div class="mr-3"><strong>Short URL:</strong> <a id="shortLink" href="#" target="_blank" rel="noopener"></a></div>
          <button id="btnCopy" class="btn btn-outline-secondary btn-sm mr-2">Copy</button>
          <button id="btnOpen" class="btn btn-outline-primary btn-sm mr-2">Open</button>
          <button id="btnShare" class="btn btn-outline-success btn-sm mr-2">Share</button>
          <div id="qrcode" class="ml-2"></div>
        </div>
        <small class="muted d-block mt-2">Tip: Use GET to redirect (counts a click). HEAD follows redirect without counting.</small>
      </div>

      <div id="shortErr" class="alert alert-danger mt-3" style="display:none;"></div>
    </div>
  </div>

  <div class="card mb-3 shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">Analytics</div>
    <div class="card-body">
      <div class="form-row">
        <div class="form-group col-sm-4">
          <label for="shortCode">Short Code</label>
          <div class="input-group">
            <div class="input-group-prepend"><span class="input-group-text">#</span></div>
            <input id="shortCode" type="text" class="form-control" placeholder="e.g., abc1234">
          </div>
        </div>
        <div class="form-group col-sm-2">
          <label for="days">Days</label>
          <input id="days" type="number" class="form-control" value="30" min="1" max="365">
        </div>
        <div class="form-group col-sm-3">
          <label for="topCountries">Top Countries</label>
          <div class="input-group">
            <input id="topCountries" type="number" class="form-control" value="5" min="0" max="20">
            <div class="input-group-append"><span class="input-group-text">🌎</span></div>
          </div>
        </div>
        <div class="form-group col-sm-3">
          <label for="topReferrers">Top Referrers</label>
          <div class="input-group">
            <input id="topReferrers" type="number" class="form-control" value="5" min="0" max="20">
            <div class="input-group-append"><span class="input-group-text">↗︎</span></div>
          </div>
        </div>
      </div>
      <div class="toolbar mb-2">
        <button id="btnFetch" class="btn btn-outline-primary btn-sm">Fetch Analytics</button>
      </div>

      <div class="row">
        <div class="col-md-3 mb-3">
          <div class="kpi">
            <div class="small-label">All-time Clicks</div>
            <div id="kpiTotal" class="val">—</div>
          </div>
        </div>
        <div class="col-md-3 mb-3">
          <div class="kpi">
            <div class="small-label">Created At</div>
            <div id="kpiCreated" class="val">—</div>
          </div>
        </div>
        <div class="col-md-3 mb-3">
          <div class="kpi">
            <div class="small-label">Window Clicks</div>
            <div id="kpiWinClicks" class="val">—</div>
          </div>
        </div>
        <div class="col-md-3 mb-3">
          <div class="kpi">
            <div class="small-label">Window Uniques</div>
            <div id="kpiWinUniques" class="val">—</div>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <div class="card-header">Clicks Over Time</div>
        <div class="card-body">
          <canvas id="seriesChart" height="120"></canvas>
        </div>
      </div>

      <div class="row">
        <div class="col-md-6">
          <h5>Top Countries</h5>
          <table class="table table-sm table-striped"><thead><tr><th>Country</th><th>Clicks</th></tr></thead><tbody id="tblCountries"></tbody></table>
        </div>
        <div class="col-md-6">
          <h5>Top Referrers</h5>
          <table class="table table-sm table-striped"><thead><tr><th>Referrer</th><th>Clicks</th></tr></thead><tbody id="tblReferrers"></tbody></table>
        </div>
      </div>

      <div id="anaErr" class="alert alert-danger mt-3" style="display:none;"></div>
    </div>
  </div>

  <script>
    var BASE = 'https://ai-inference.xyz';
    var serChart = null;

    function showErr(id, msg){ var el = document.getElementById(id); el.textContent = msg; el.style.display = msg ? 'block' : 'none'; }
    function clearErr(id){ showErr(id, ''); }

    function isHttpUrl(u){ return /^https?:\/\//i.test(u || ''); }

    function shorten(){
      clearErr('shortErr');
      var url = document.getElementById('longUrl').value.trim();
      if (!isHttpUrl(url)) { showErr('shortErr','Provide a valid http(s) URL'); return; }
      fetch(BASE + '/api/shorten', { method:'POST', headers:{'content-type':'application/json'}, body: JSON.stringify({ url: url }) })
        .then(function(res){ return res.json().catch(function(){ return {}; }).then(function(body){ return { status: res.status, body: body }; }); })
        .then(function(resp){
          if (resp.status === 201 && resp.body && resp.body.short_url){
            var a = document.getElementById('shortLink');
            a.textContent = resp.body.short_url; a.href = resp.body.short_url;
            document.getElementById('shortResult').style.display = 'block';
            // QR
            var qrWrap = document.getElementById('qrcode'); qrWrap.innerHTML = '';
            new QRCode(qrWrap, { text: resp.body.short_url, width: 80, height: 80 });
            // Seed analytics short code
            try {
              var u = document.createElement('a');
              u.href = resp.body.short_url;
              var parts = (u.pathname || '').split('/');
              var code = parts.pop() || parts.pop();
              document.getElementById('shortCode').value = code;
            } catch(e){}
          } else {
            showErr('shortErr', resp.body && resp.body.error ? resp.body.error : 'Shorten failed');
          }
        })
        .catch(function(){ showErr('shortErr','Network error'); });
    }

    function setKpi(id, v){ document.getElementById(id).textContent = v; }

    function fillTable(tbodyId, rows, key, val){
      var tb = document.getElementById(tbodyId); tb.innerHTML = '';
      if (!rows || !rows.length){ tb.innerHTML = '<tr><td colspan="2" class="text-muted">No data</td></tr>'; return; }
      rows.forEach(function(r){ var tr = document.createElement('tr'); tr.innerHTML = '<td>'+ (r[key] || '') +'</td><td>'+ (r[val]||0) +'</td>'; tb.appendChild(tr); });
    }

    function fetchAnalytics(){
      clearErr('anaErr');
      var code = (document.getElementById('shortCode').value || '').trim();
      var days = parseInt(document.getElementById('days').value||'30',10);
      var tc = parseInt(document.getElementById('topCountries').value||'5',10);
      var tr = parseInt(document.getElementById('topReferrers').value||'5',10);
      if (!/^[A-Za-z0-9]{4,12}$/.test(code)){ showErr('anaErr','Enter a valid short code [A-Za-z0-9]{4,12}'); return; }
      var url = BASE + '/api/analytics/' + encodeURIComponent(code) + '?days=' + days + '&top_countries=' + tc + '&top_referrers=' + tr;
      fetch(url, { method:'GET' })
        .then(function(res){ return res.json().catch(function(){ return {}; }).then(function(body){ return { ok: res.ok, body: body }; }); })
        .then(function(resp){
          if (resp.ok){
            var body = resp.body || {};
            setKpi('kpiTotal', body.click_count != null ? body.click_count : '-');
            setKpi('kpiCreated', body.created_at || '-');
            setKpi('kpiWinClicks', body.total_clicks != null ? body.total_clicks : '-');
            setKpi('kpiWinUniques', body.total_unique_clicks != null ? body.total_unique_clicks : '0');
            try {
              var labels = (body.series || []).map(function(p){ return p.day; });
              var clicks = (body.series || []).map(function(p){ return p.clicks; });
              var uniques = (body.series || []).map(function(p){ return p.unique_clicks || 0; });
              if (serChart) serChart.destroy();
              var ctx = document.getElementById('seriesChart').getContext('2d');
              var chartData = {
                labels: labels,
                datasets: [
                  { label: 'Clicks', data: clicks, borderColor: '#1565c0', backgroundColor: 'rgba(21,101,192,0.08)', fill: true, tension: 0.15 },
                  { label: 'Uniques', data: uniques, borderColor: '#2e7d32', backgroundColor: 'rgba(46,125,50,0.08)', fill: true, tension: 0.15 }
                ]
              };
              var chartOptions = {
                responsive: true,
                plugins: { legend: { position: 'top' } },
                scales: { y: { beginAtZero: true } }
              };
              serChart = new Chart(ctx, { type: 'line', data: chartData, options: chartOptions });
            } catch(e){}
            fillTable('tblCountries', body.top_countries, 'country', 'clicks');
            fillTable('tblReferrers', body.top_referrers, 'referrer', 'clicks');
          } else {
            showErr('anaErr', resp.body && resp.body.error ? resp.body.error : 'Analytics fetch failed');
          }
        })
        .catch(function(){ showErr('anaErr','Network error'); });
    }

    document.getElementById('btnShorten').addEventListener('click', function(){ shorten(); });
    document.getElementById('btnOpen').addEventListener('click', function(){ var a=document.getElementById('shortLink'); if (a && a.href) window.open(a.href,'_blank'); });
    document.getElementById('btnCopy').addEventListener('click', function(){ var a=document.getElementById('shortLink'); if (a && a.href && navigator.clipboard) navigator.clipboard.writeText(a.href); });
    document.getElementById('btnShare').addEventListener('click', function(){
      var a = document.getElementById('shortLink');
      var link = a && a.href ? a.href : '';
      if (!link) { showErr('shortErr','Shorten a link first'); return; }
      if (navigator.share) {
        navigator.share({ title: 'Short link', text: 'Check this short link', url: link }).catch(function(){});
      } else if (navigator.clipboard) {
        navigator.clipboard.writeText(link);
      }
    });
    document.getElementById('btnFetch').addEventListener('click', function(){ fetchAnalytics(); });
  </script>

  <div class="sharethis-inline-share-buttons"></div>
  <%@ include file="thanks.jsp"%>

  <hr>
  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>

</div>
<%@ include file="body-close.jsp"%>

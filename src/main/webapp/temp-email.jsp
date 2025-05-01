<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Temporal Email Inbox</title>
  <meta name="description" content="Generate a temporary email address at goodbanners.xyz and view incoming messages in real time.">
  <meta name="keywords" content="temporary email, temp email, disposable email, procmail.xyz, goodbanners.xyz">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="<%= request.getRequestURL() %>">

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website">
  <meta property="og:title" content="Temporal Email Inbox">
  <meta property="og:description" content="Generate a temporary email address at goodbanners.xyz and view incoming messages in real time.">
  <meta property="og:url" content="<%= request.getRequestURL() %>">
  <meta property="og:site_name" content="procmail.xyz">

  <!-- Twitter -->
  <meta name="twitter:card" content="summary">
  <meta name="twitter:title" content="Temporal Email Inbox">
  <meta name="twitter:description" content="Generate a temporary email address at goodbanners.xyz and view incoming messages in real time.">

  <!-- JSON-LD structured data -->
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebPage",
      "name": "Temporal Email Inbox",
      "description": "Generate a temporary email address at goodbanners.xyz and view incoming messages in real time.",
      "url": "<%= request.getRequestURL() %>"
  }
  </script>

  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<div class="container py-4">
  <h1 class="mb-3">Temporal Email Inbox</h1>
  <p class="text-muted">Generate a temporary email address and view incoming messages in real time. Powered by <a href="https://procmail.xyz" target="_blank" rel="noopener noreferrer">procmail.xyz</a>.</p>

  <!-- Email input row -->
  <div class="row mb-4">
    <label for="local" class="col-sm-3 col-form-label fw-bold">Temp email address:</label>
    <div class="col-sm-7">
      <div class="input-group">
        <input type="text" class="form-control" id="local" placeholder="local-part">
        <span class="input-group-text" id="domain">@goodbanners.xyz</span>
        <button class="btn btn-outline-secondary" type="button" id="copyBtn" title="Copy to clipboard">📋</button>
      </div>
      <small class="d-block text-muted fst-italic">Note: choose any name – this becomes your temp email address.</small>
    </div>
  </div>

  <!-- Inbox section -->
  <div class="mb-3 d-flex align-items-center">
    <h2 class="mb-0">Inbox</h2>
    <div class="ms-auto text-muted" id="countdown">Next fetch in: 30s</div>
  </div>
  <div id="inbox" class="position-relative mb-4" style="min-height: 150px;">
    <!-- Spinner -->
    <div id="spinner" class="d-none position-absolute" style="top:10px; right:10px;">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>
    <!-- Accordion messages -->
    <div id="accordionContainer" class="accordion"></div>
    <div id="emptyMsg" class="text-muted">Loading...</div>
  </div>
</div>

<!-- Bootstrap 5 JS Bundle (includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  const FETCH_INTERVAL = 30;
  let countdown = FETCH_INTERVAL;
  let countdownInterval;
  const DOMAIN = '@goodbanners.xyz';

  // Fetch and set initial email
  async function generateEmail() {
    const res = await fetch('https://api.procmail.xyz/generate');
    const fullEmail = (await res.text()).trim();
    const localPart = fullEmail.split('@')[0];
    document.getElementById('local').value = localPart;
  }

  // Copy to clipboard
  function setupCopy() {
    const btn = document.getElementById('copyBtn');
    btn.addEventListener('click', () => {
      const local = document.getElementById('local').value.trim();
      const email = local + DOMAIN;
      navigator.clipboard.writeText(email).then(() => {
        btn.textContent = '✅';
        setTimeout(() => btn.textContent = '📋', 1000);
      });
    });
  }

  // Get the full email address
  function getEmail() {
    return document.getElementById('local').value.trim() + DOMAIN;
  }

  // Render messages in Accordion
  function renderAccordion(messages) {
    const container = document.getElementById('accordionContainer');
    messages.sort((a, b) => new Date(b.ReceivedAt) - new Date(a.ReceivedAt));
    container.innerHTML = '';
    messages.forEach((msg, idx) => {
      const senderMatch = msg.Sender.match(/^(.*)<([^>]+)>/);
      const senderName = senderMatch ? senderMatch[1].trim() : msg.Sender;
      const senderEmail = senderMatch ? senderMatch[2].trim() : '';
      const headingId = 'heading' + idx;
      const collapseId = 'collapse' + idx;
      const isFirst = idx === 0;
      const btnClass = 'accordion-button' + (isFirst ? '' : ' collapsed');
      const collapseClass = 'accordion-collapse collapse' + (isFirst ? ' show' : '');
      const item = document.createElement('div');
      item.className = 'accordion-item';
      item.innerHTML =
              '<h2 class="accordion-header" id="' + headingId + '">' +
              '<button class="' + btnClass + '" type="button" data-bs-toggle="collapse" data-bs-target="#' + collapseId + '" aria-expanded="' + isFirst + '" aria-controls="' + collapseId + '">From: ' + senderName + ' (' + senderEmail + ') — Subject: ' + msg.Subject + '</button></h2>' +
              '<div id="' + collapseId + '" class="' + collapseClass + '" aria-labelledby="' + headingId + '" data-bs-parent="#accordionContainer">' +
              '<div class="accordion-body">' +
              '<p><strong>From:</strong> ' + senderName + ' &lt;' + senderEmail + '&gt;</p>' +
              '<p><strong>Received At:</strong> ' + msg.ReceivedAt + '</p>' +
              '<p><strong>Plain Text:</strong><br><pre>' + msg.PlainTextBody + '</pre></p>' +
              '<p><strong>HTML:</strong><br><div>' + msg.HTMLBody + '</div></p>' +
              '</div></div>';
      container.appendChild(item);
    });
  }

  // Fetch inbox
  async function fetchInbox() {
    const email = getEmail();
    const spinner = document.getElementById('spinner');
    const emptyMsg = document.getElementById('emptyMsg');
    const container = document.getElementById('accordionContainer');
    spinner && spinner.classList.remove('d-none');
    try {
      const res = await fetch('https://api.procmail.xyz/inbox/' + email);
      const data = await res.json();
      if (!data || data.length === 0) {
        container.innerHTML = '';
        emptyMsg.textContent = 'No messages.';
      } else {
        emptyMsg.textContent = '';
        renderAccordion(data);
      }
    } catch (e) {
      container.innerHTML = '';
      emptyMsg.textContent = 'Error: ' + e.message;
    } finally {
      spinner && spinner.classList.add('d-none');
    }
  }

  // Countdown
  function startCountdown() {
    const countdownEl = document.getElementById('countdown');
    clearInterval(countdownInterval);
    countdown = FETCH_INTERVAL;
    countdownEl.textContent = 'Next fetch in: ' + countdown + 's';
    countdownInterval = setInterval(() => {
      countdown--;
      countdownEl.textContent = 'Next fetch in: ' + countdown + 's';
      if (countdown <= 0) clearInterval(countdownInterval);
    }, 1000);
  }

  // Schedule recurring fetches
  async function scheduleFetch() {
    startCountdown(); await fetchInbox();
    setTimeout(scheduleFetch, FETCH_INTERVAL * 1000);
  }

  // Init
  document.addEventListener('DOMContentLoaded', async () => {
    await generateEmail(); setupCopy();
    document.getElementById('emptyMsg').textContent = 'Loading...';
    scheduleFetch();
  });
</script>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>

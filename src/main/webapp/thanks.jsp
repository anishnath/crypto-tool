<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<hr>
<div class="card my-4 thanks-card">
    <div class="card-body">
        <h4 class="card-title mb-3 thanks-title">If This Helped, Support the Project</h4>
        <p class="card-text thanks-text">
            I build and maintain these tools so developers have fast, privacy‑respecting utilities at their fingertips—free, with no sign‑up. If you’d like to support hosting and new features, you can <strong>buy me a coffee</strong> or grab my <strong>9‑book bundle for $9</strong>. Every bit genuinely helps—thank you!
        </p>
        <div class="d-flex flex-wrap" style="gap:.6rem;">
            <a class="btn btn-warning btn-lg" style="border-radius:20px; font-weight:600; color:#212529;" href="https://buymeacoffee.com/8gwifi.org" target="_blank" rel="noopener" aria-label="Buy me a coffee">
                ☕ Buy me a coffee
            </a>
            <a class="btn btn-primary btn-lg thanks-btn" href="https://leanpub.com/b/9book" target="_blank" rel="noopener" aria-label="Get the 9-book bundle on Leanpub">
                📚 Get the 9‑book bundle ($9)
            </a>
        </div>
    </div>
</div>
<p class="text-muted security-note"><em>Any private key value that you enter or we generate is not stored on this site. This tool is served over HTTPS to help ensure private keys cannot be intercepted.</em></p>
<hr>

<style>
.thanks-card {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    border: 1px solid #dee2e6;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    overflow: hidden;
}

.thanks-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: linear-gradient(90deg, #6c757d, #495057, #343a40);
}

.thanks-title {
    color: #495057 !important;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-weight: 600;
    font-size: 1.6rem;
    letter-spacing: 0.3px;
}

.thanks-text {
    color: #6c757d !important;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-size: 1.05rem;
    line-height: 1.6;
    font-weight: 400;
}

.thanks-btn {
    background: linear-gradient(45deg, #495057, #6c757d);
    border: none;
    border-radius: 20px;
    padding: 10px 25px;
    font-weight: 500;
    font-size: 1rem;
    text-transform: none;
    letter-spacing: 0.3px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    transition: all 0.3s ease;
}

.thanks-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    background: linear-gradient(45deg, #343a40, #495057);
}

.security-note {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-size: 0.9rem;
    color: #868e96 !important;
    background: #f8f9fa;
    padding: 12px 15px;
    border-radius: 6px;
    border-left: 3px solid #6c757d;
    margin: 20px 0;
}

.security-note em {
    font-style: normal;
    color: #6c757d;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .thanks-title {
        font-size: 1.4rem;
    }
    
    .thanks-text {
        font-size: 1rem;
    }
    
    .thanks-btn {
        font-size: 0.95rem;
        padding: 8px 20px;
    }
}
</style>
<%--<div><script type="text/javascript" src="https://video.onnetwork.tv/widget/widget_scrolllist.php?widget=1409"></script></div>--%>

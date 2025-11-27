<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>

<!-- Support Section -->
<div class="support-section my-4">
    <div class="card thanks-card">
        <div class="card-body">
            <div class="row align-items-center">
                <!-- Left: Message -->
                <div class="col-lg-7">
                    <div class="d-flex align-items-center mb-2">
                        <span class="support-icon">
                            <i class="fas fa-heart text-danger"></i>
                        </span>
                        <h4 class="thanks-title mb-0">Support This Free Tool</h4>
                    </div>
                    <p class="thanks-text mb-3">
                        Every coffee helps keep the servers running. Every book sale funds the next tool I'm dreaming up.
                        <strong>You're not just supporting a site — you're helping me build what developers actually need.</strong>
                    </p>
                    <div class="stats-row d-flex flex-wrap mb-3">
                        <div class="stat-item">
                            <i class="fas fa-users text-primary"></i>
                            <span>500K+ users</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-tools text-success"></i>
                            <span>200+ tools</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-shield-alt text-info"></i>
                            <span>100% private</span>
                        </div>
                    </div>
                </div>

                <!-- Right: Actions -->
                <div class="col-lg-5">
                    <div class="action-buttons">
                        <a class="btn btn-coffee" href="https://buymeacoffee.com/8gwifi.org" target="_blank" rel="noopener" aria-label="Buy me a coffee">
                            <span class="btn-icon">☕</span>
                            <span class="btn-text">
                                <small>One-time support</small>
                                <strong>Buy me a coffee</strong>
                            </span>
                        </a>
                        <a class="btn btn-books" href="https://leanpub.com/b/9book" target="_blank" rel="noopener" aria-label="Get the 9-book bundle on Leanpub">
                            <span class="btn-icon">📚</span>
                            <span class="btn-text">
                                <small>Learn & support</small>
                                <strong>9-Book Bundle - $9</strong>
                            </span>
                        </a>
                        <a class="btn btn-twitter" href="https://x.com/anish2good" target="_blank" rel="noopener" aria-label="Follow on X">
                            <span class="btn-icon"><i class="fab fa-x-twitter"></i></span>
                            <span class="btn-text">
                                <small>Stay updated</small>
                                <strong>Follow @anish2good</strong>
                            </span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Security Note -->
    <div class="security-note">
        <i class="fas fa-lock"></i>
        <span><strong>Privacy Guarantee:</strong> Private keys you enter or generate are never stored on our servers. All tools are served over HTTPS.</span>
    </div>
</div>

<style>
.support-section {
    font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
}

.thanks-card {
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
    border: none;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    overflow: hidden;
    position: relative;
}

.thanks-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #ff6b6b, #feca57, #48dbfb, #ff9ff3);
}

.support-icon {
    width: 40px;
    height: 40px;
    background: rgba(220, 53, 69, 0.1);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    font-size: 1.2rem;
}

.thanks-title {
    color: #2d3436;
    font-weight: 700;
    font-size: 1.4rem;
    letter-spacing: -0.3px;
}

.thanks-text {
    color: #636e72;
    font-size: 0.95rem;
    line-height: 1.6;
}

.stats-row {
    gap: 1rem;
}

.stat-item {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 0.85rem;
    color: #636e72;
    background: #f1f3f4;
    padding: 4px 12px;
    border-radius: 20px;
}

.stat-item i {
    font-size: 0.8rem;
}

.action-buttons {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.action-buttons .btn {
    display: flex;
    align-items: center;
    padding: 12px 20px;
    border-radius: 12px;
    border: none;
    text-decoration: none;
    transition: all 0.3s ease;
}

.btn-coffee {
    background: linear-gradient(135deg, #ffdd00 0%, #fbb034 100%);
    color: #1a1a1a;
}

.btn-coffee:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(251, 176, 52, 0.4);
    color: #1a1a1a;
}

.btn-books {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #ffffff;
}

.btn-books:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
    color: #ffffff;
}

.btn-twitter {
    background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
    color: #ffffff;
}

.btn-twitter:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
    color: #ffffff;
}

.btn-twitter .btn-icon {
    font-size: 1.4rem;
}

.btn-icon {
    font-size: 1.8rem;
    margin-right: 12px;
    line-height: 1;
}

.btn-text {
    display: flex;
    flex-direction: column;
    text-align: left;
    line-height: 1.3;
}

.btn-text small {
    font-size: 0.7rem;
    opacity: 0.8;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.btn-text strong {
    font-size: 0.95rem;
}

.security-note {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 0.85rem;
    color: #636e72;
    background: linear-gradient(90deg, #e8f5e9, #f1f8f6);
    padding: 12px 16px;
    border-radius: 8px;
    margin-top: 12px;
    border-left: 3px solid #4caf50;
}

.security-note i {
    color: #4caf50;
    font-size: 1rem;
}

/* Responsive */
@media (max-width: 991px) {
    .action-buttons {
        flex-direction: row;
        flex-wrap: wrap;
        margin-top: 1rem;
    }

    .action-buttons .btn {
        flex: 1;
        min-width: 200px;
    }
}

@media (max-width: 576px) {
    .thanks-title {
        font-size: 1.2rem;
    }

    .action-buttons {
        flex-direction: column;
    }

    .action-buttons .btn {
        min-width: 100%;
    }

    .stats-row {
        gap: 0.5rem;
    }

    .stat-item {
        font-size: 0.75rem;
        padding: 3px 10px;
    }
}
</style>

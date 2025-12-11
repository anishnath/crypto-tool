<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Modern Support Section Component
    Replaces old thanks.jsp with modern design
    Placement: Before footer, after content sections
    
    Usage: <%@ include file="modern/components/support-section.jsp" %>
--%>

<section class="support-section-modern" aria-label="Support this free tool">
    <div class="support-card">
        <div class="support-header">
            <div class="support-icon-wrapper">
                <span class="support-icon" aria-hidden="true">❤️</span>
            </div>
            <h2 class="support-title">Support This Free Tool</h2>
        </div>
        
        <p class="support-message">
            Every coffee helps keep the servers running. Every book sale funds the next tool I'm dreaming up.
            <strong>You're not just supporting a site — you're helping me build what developers actually need.</strong>
        </p>
        
        <div class="support-stats">
            <div class="stat-badge">
                <span class="stat-icon" aria-hidden="true">👥</span>
                <span class="stat-text">500K+ users</span>
            </div>
            <div class="stat-badge">
                <span class="stat-icon" aria-hidden="true">🛠️</span>
                <span class="stat-text">200+ tools</span>
            </div>
            <div class="stat-badge">
                <span class="stat-icon" aria-hidden="true">🔒</span>
                <span class="stat-text">100% private</span>
            </div>
        </div>
        
        <div class="support-actions">
            <a href="https://buymeacoffee.com/8gwifi.org" 
               target="_blank" 
               rel="noopener" 
               class="support-btn support-btn-coffee"
               aria-label="Buy me a coffee - one-time support">
                <span class="btn-icon">☕</span>
                <span class="btn-content">
                    <span class="btn-label">One-time support</span>
                    <span class="btn-text">Buy me a coffee</span>
                </span>
            </a>
            
            <a href="https://leanpub.com/b/9book" 
               target="_blank" 
               rel="noopener" 
               class="support-btn support-btn-books"
               aria-label="Get the 9-book bundle on Leanpub - Learn & support">
                <span class="btn-icon">📚</span>
                <span class="btn-content">
                    <span class="btn-label">Learn & support</span>
                    <span class="btn-text">9-Book Bundle - $9</span>
                </span>
            </a>
            
            <a href="https://x.com/anish2good" 
               target="_blank" 
               rel="noopener" 
               class="support-btn support-btn-twitter"
               aria-label="Follow @anish2good on X - Stay updated">
                <span class="btn-icon">𝕏</span>
                <span class="btn-content">
                    <span class="btn-label">Stay updated</span>
                    <span class="btn-text">Follow @anish2good</span>
                </span>
            </a>
        </div>
    </div>
    
    <div class="security-guarantee">
        <span class="security-icon" aria-hidden="true">🔒</span>
        <span class="security-text">
            <strong>Privacy Guarantee:</strong> Private keys you enter or generate are never stored on our servers. All tools are served over HTTPS.
        </span>
    </div>
</section>

<style>
/* Support Section Modern Styles */
.support-section-modern {
    margin: 4rem 0;
    padding: 0 1.5rem;
}

.support-card {
    background: linear-gradient(135deg, var(--bg-primary, #ffffff) 0%, var(--bg-secondary, #f8fafc) 100%);
    border: 2px solid var(--border, #e2e8f0);
    border-radius: var(--radius-xl, 1rem);
    padding: 2.5rem;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    position: relative;
    overflow: hidden;
}

.support-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #ef4444, #f59e0b, #3b82f6, #8b5cf6);
}

.support-header {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin-bottom: 1.5rem;
}

.support-icon-wrapper {
    width: 48px;
    height: 48px;
    background: rgba(239, 68, 68, 0.1);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.support-icon {
    font-size: 1.5rem;
}

.support-title {
    font-size: var(--text-2xl, 1.5rem);
    font-weight: 700;
    color: var(--text-primary, #0f172a);
    margin: 0;
    letter-spacing: -0.02em;
}

.support-message {
    font-size: var(--text-base, 1rem);
    color: var(--text-secondary, #475569);
    line-height: 1.7;
    margin-bottom: 1.5rem;
}

.support-message strong {
    color: var(--text-primary, #0f172a);
    font-weight: 600;
}

.support-stats {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
    margin-bottom: 2rem;
}

.stat-badge {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    background: var(--bg-tertiary, #f1f5f9);
    border-radius: var(--radius-full, 9999px);
    font-size: var(--text-sm, 0.875rem);
    color: var(--text-secondary, #475569);
    font-weight: 500;
}

.stat-icon {
    font-size: 1rem;
}

.support-actions {
    display: grid;
    grid-template-columns: 1fr;
    gap: 1rem;
}

@media (min-width: 768px) {
    .support-actions {
        grid-template-columns: repeat(3, 1fr);
    }
}

.support-btn {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem 1.5rem;
    border-radius: var(--radius-lg, 0.75rem);
    text-decoration: none;
    transition: all 0.3s ease;
    border: none;
    font-family: var(--font-sans);
    position: relative;
    overflow: hidden;
}

.support-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
    transition: left 0.5s ease;
}

.support-btn:hover::before {
    left: 100%;
}

.support-btn-coffee {
    background: linear-gradient(135deg, #ffdd00 0%, #fbb034 100%);
    color: #1a1a1a;
}

.support-btn-coffee:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(251, 176, 52, 0.4);
    color: #1a1a1a;
}

.support-btn-books {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #ffffff;
}

.support-btn-books:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
    color: #ffffff;
}

.support-btn-twitter {
    background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
    color: #ffffff;
}

.support-btn-twitter:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
    color: #ffffff;
}

.btn-icon {
    font-size: 2rem;
    line-height: 1;
    flex-shrink: 0;
}

.btn-content {
    display: flex;
    flex-direction: column;
    text-align: left;
    line-height: 1.3;
}

.btn-label {
    font-size: var(--text-xs, 0.75rem);
    opacity: 0.8;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    font-weight: 500;
}

.btn-text {
    font-size: var(--text-base, 1rem);
    font-weight: 600;
    margin-top: 0.125rem;
}

.security-guarantee {
    display: flex;
    align-items: flex-start;
    gap: 0.75rem;
    margin-top: 1.5rem;
    padding: 1rem 1.25rem;
    background: linear-gradient(90deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05));
    border-radius: var(--radius-md, 0.5rem);
    border-left: 3px solid var(--success, #10b981);
}

.security-icon {
    font-size: 1.25rem;
    flex-shrink: 0;
    margin-top: 0.125rem;
}

.security-text {
    font-size: var(--text-sm, 0.875rem);
    color: var(--text-secondary, #475569);
    line-height: 1.6;
}

.security-text strong {
    color: var(--success, #10b981);
    font-weight: 600;
}

/* Dark Mode */
[data-theme="dark"] .support-card {
    background: linear-gradient(135deg, var(--bg-secondary, #1e293b) 0%, var(--bg-tertiary, #334155) 100%);
    border-color: var(--border, #334155);
}

[data-theme="dark"] .stat-badge {
    background: var(--bg-secondary, #1e293b);
    color: var(--text-muted, #94a3b8);
}

[data-theme="dark"] .security-guarantee {
    background: linear-gradient(90deg, rgba(16, 185, 129, 0.15), rgba(16, 185, 129, 0.08));
}

/* Mobile Responsive */
@media (max-width: 767px) {
    .support-section-modern {
        margin: 3rem 0;
        padding: 0 1rem;
    }
    
    .support-card {
        padding: 2rem 1.5rem;
    }
    
    .support-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
    }
    
    .support-actions {
        grid-template-columns: 1fr;
    }
    
    .support-btn {
        padding: 1rem;
    }
    
    .btn-icon {
        font-size: 1.75rem;
    }
}
</style>


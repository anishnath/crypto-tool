<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Modern Cipher Algorithm Learning Content
    Comprehensive reference guide for 100+ cipher algorithms
--%>

<section class="cipher-learning-section">
    <div class="learning-card">
        <div class="learning-header">
            <h2><i class="fas fa-book"></i> Cipher Algorithm Reference Guide</h2>
            <p class="learning-subtitle">Comprehensive reference for 100+ supported cipher algorithms with specifications, modes, and security recommendations.</p>
        </div>

        <!-- Quick Navigation -->
        <div class="quick-nav">
            <strong><i class="fas fa-compass"></i> Quick Navigation:</strong>
            <div class="nav-pills">
                <a href="#cipher-aes" class="nav-pill">AES</a>
                <a href="#cipher-des" class="nav-pill">DES</a>
                <a href="#cipher-blowfish" class="nav-pill">Blowfish</a>
                <a href="#cipher-twofish" class="nav-pill">Twofish</a>
                <a href="#cipher-camellia" class="nav-pill">Camellia</a>
                <a href="#cipher-chacha" class="nav-pill">ChaCha</a>
                <a href="#cipher-other" class="nav-pill">Other</a>
            </div>
        </div>

        <!-- Accordion for Cipher Details -->
        <div class="cipher-accordion">
            
            <!-- AES -->
            <details class="cipher-item" id="cipher-aes" open>
                <summary class="cipher-summary">
                    <span class="cipher-title">
                        <i class="fas fa-shield-alt"></i> <strong>AES</strong> - Advanced Encryption Standard
                        <span class="badge-success">Recommended</span>
                    </span>
                    <i class="fas fa-chevron-down"></i>
                </summary>
                <div class="cipher-content">
                    <div class="cipher-grid">
                        <div class="cipher-spec">
                            <h6><i class="fas fa-info-circle"></i> Specifications</h6>
                            <table class="spec-table">
                                <tr><td><strong>Key Sizes</strong></td><td>128, 192, 256 bits</td></tr>
                                <tr><td><strong>Block Size</strong></td><td>128 bits</td></tr>
                                <tr><td><strong>Rounds</strong></td><td>10 (AES-128), 12 (AES-192), 14 (AES-256)</td></tr>
                                <tr><td><strong>Structure</strong></td><td>Substitution-Permutation Network</td></tr>
                                <tr><td><strong>Published</strong></td><td>1998 (NIST standard 2001)</td></tr>
                                <tr><td><strong>Designers</strong></td><td>Joan Daemen, Vincent Rijmen</td></tr>
                            </table>
                            <div class="alert-success">
                                <strong><i class="fas fa-check-circle"></i> Security Status:</strong> Highly secure, industry standard. AES-256 recommended for high-security applications.
                            </div>
                        </div>
                        <div class="cipher-modes">
                            <h6><i class="fas fa-cogs"></i> Supported Modes</h6>
                            <table class="modes-table">
                                <thead>
                                    <tr><th>Mode</th><th>Padding</th><th>Security</th></tr>
                                </thead>
                                <tbody>
                                    <tr><td><code>AES/CBC/PKCS5PADDING</code></td><td>PKCS5</td><td><span class="badge-good">Good</span></td></tr>
                                    <tr><td><code>AES/CBC/NOPADDING</code></td><td>None</td><td><span class="badge-warning">Manual</span></td></tr>
                                    <tr><td><code>AES/ECB/PKCS5PADDING</code></td><td>PKCS5</td><td><span class="badge-danger">Not Recommended</span></td></tr>
                                    <tr><td><code>AES/ECB/NOPADDING</code></td><td>None</td><td><span class="badge-danger">Not Recommended</span></td></tr>
                                    <tr><td><code>AES_128/GCM/NOPADDING</code></td><td>None</td><td><span class="badge-best">Best</span></td></tr>
                                    <tr><td><code>AES_192/GCM/NOPADDING</code></td><td>None</td><td><span class="badge-best">Best</span></td></tr>
                                    <tr><td><code>AES_256/GCM/NOPADDING</code></td><td>None</td><td><span class="badge-best">Best</span></td></tr>
                                    <tr><td><code>AES_128/CBC/NOPADDING</code></td><td>None</td><td><span class="badge-good">Good</span></td></tr>
                                    <tr><td><code>AES_128/CFB/NOPADDING</code></td><td>None</td><td><span class="badge-info">Good</span></td></tr>
                                    <tr><td><code>AES_128/OFB/NOPADDING</code></td><td>None</td><td><span class="badge-info">Good</span></td></tr>
                                </tbody>
                            </table>
                            <p class="tip"><i class="fas fa-lightbulb"></i> <strong>Tip:</strong> Use GCM mode for authenticated encryption. CBC mode requires unique IV for each encryption.</p>
                        </div>
                    </div>
                </div>
            </details>

            <!-- DES -->
            <details class="cipher-item" id="cipher-des">
                <summary class="cipher-summary">
                    <span class="cipher-title">
                        <i class="fas fa-lock"></i> <strong>DES</strong> - Data Encryption Standard
                        <span class="badge-danger">Obsolete</span>
                    </span>
                    <i class="fas fa-chevron-down"></i>
                </summary>
                <div class="cipher-content">
                    <div class="cipher-grid">
                        <div class="cipher-spec">
                            <h6><i class="fas fa-info-circle"></i> Specifications</h6>
                            <table class="spec-table">
                                <tr><td><strong>Key Size</strong></td><td>56 bits (+8 parity bits)</td></tr>
                                <tr><td><strong>Block Size</strong></td><td>64 bits</td></tr>
                                <tr><td><strong>Rounds</strong></td><td>16</td></tr>
                                <tr><td><strong>Structure</strong></td><td>Balanced Feistel Network</td></tr>
                                <tr><td><strong>Published</strong></td><td>1975</td></tr>
                                <tr><td><strong>Designer</strong></td><td>IBM</td></tr>
                            </table>
                            <div class="alert-danger">
                                <strong><i class="fas fa-exclamation-triangle"></i> Security Warning:</strong> DES is obsolete and insecure! 56-bit key is too small and can be brute-forced. <strong>Use AES instead.</strong>
                            </div>
                        </div>
                        <div class="cipher-modes">
                            <h6><i class="fas fa-cogs"></i> Supported Modes (Not Recommended)</h6>
                            <table class="modes-table">
                                <tbody>
                                    <tr><td><code>DES/CBC/NOPADDING</code></td></tr>
                                    <tr><td><code>DES/CBC/PKCS5PADDING</code></td></tr>
                                    <tr><td><code>DES/ECB/NOPADDING</code></td></tr>
                                    <tr><td><code>DES/ECB/PKCS5PADDING</code></td></tr>
                                </tbody>
                            </table>
                            <p class="tip"><i class="fas fa-history"></i> <strong>Historical Note:</strong> DES was the federal standard from 1977 to 2001. Superseded by AES.</p>
                        </div>
                    </div>
                </div>
            </details>

            <!-- Triple DES -->
            <details class="cipher-item">
                <summary class="cipher-summary">
                    <span class="cipher-title">
                        <i class="fas fa-lock"></i> <strong>3DES (DESede)</strong> - Triple DES
                        <span class="badge-warning">Legacy</span>
                    </span>
                    <i class="fas fa-chevron-down"></i>
                </summary>
                <div class="cipher-content">
                    <div class="cipher-grid">
                        <div class="cipher-spec">
                            <h6><i class="fas fa-info-circle"></i> Specifications</h6>
                            <table class="spec-table">
                                <tr><td><strong>Key Sizes</strong></td><td>168, 112, 56 bits (3 keying options)</td></tr>
                                <tr><td><strong>Block Size</strong></td><td>64 bits</td></tr>
                                <tr><td><strong>Rounds</strong></td><td>48 DES-equivalent rounds</td></tr>
                                <tr><td><strong>Structure</strong></td><td>Feistel Network</td></tr>
                                <tr><td><strong>Published</strong></td><td>1998 (ANSI X9.52)</td></tr>
                            </table>
                            <div class="alert-warning">
                                <strong><i class="fas fa-info-circle"></i> Status:</strong> Legacy algorithm. More secure than DES but slower. Migrate to AES for new applications.
                            </div>
                        </div>
                        <div class="cipher-modes">
                            <h6><i class="fas fa-cogs"></i> Supported Modes</h6>
                            <table class="modes-table">
                                <tbody>
                                    <tr><td><code>DESEDE/CBC/NOPADDING</code></td></tr>
                                    <tr><td><code>DESEDE/CBC/PKCS5PADDING</code></td></tr>
                                    <tr><td><code>DESEDE/ECB/NOPADDING</code></td></tr>
                                    <tr><td><code>DESEDE/ECB/PKCS5PADDING</code></td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </details>

            <!-- Blowfish -->
            <details class="cipher-item" id="cipher-blowfish">
                <summary class="cipher-summary">
                    <span class="cipher-title">
                        <i class="fas fa-fish"></i> <strong>Blowfish</strong>
                        <span class="badge-info">Secure</span>
                    </span>
                    <i class="fas fa-chevron-down"></i>
                </summary>
                <div class="cipher-content">
                    <div class="cipher-grid">
                        <div class="cipher-spec">
                            <h6><i class="fas fa-info-circle"></i> Specifications</h6>
                            <table class="spec-table">
                                <tr><td><strong>Key Sizes</strong></td><td>32-448 bits (variable)</td></tr>
                                <tr><td><strong>Block Size</strong></td><td>64 bits</td></tr>
                                <tr><td><strong>Rounds</strong></td><td>16</td></tr>
                                <tr><td><strong>Structure</strong></td><td>Feistel Network</td></tr>
                                <tr><td><strong>Published</strong></td><td>1993</td></tr>
                                <tr><td><strong>Designer</strong></td><td>Bruce Schneier</td></tr>
                                <tr><td><strong>Successor</strong></td><td>Twofish</td></tr>
                            </table>
                            <div class="alert-info">
                                <strong><i class="fas fa-check-circle"></i> Security:</strong> Secure algorithm with no known practical attacks. Fast and well-analyzed. Small 64-bit block size may be limitation for large data.
                            </div>
                        </div>
                        <div class="cipher-modes">
                            <h6><i class="fas fa-lightbulb"></i> Key Features</h6>
                            <ul>
                                <li>Variable-length key (flexible security)</li>
                                <li>Fast in software implementation</li>
                                <li>Public domain (no patents)</li>
                                <li>Used in password hashing (bcrypt)</li>
                                <li>Good choice for legacy systems</li>
                            </ul>
                            <p class="tip"><i class="fas fa-info-circle"></i> Blowfish is unpatented and license-free, making it popular for open-source projects.</p>
                        </div>
                    </div>
                </div>
            </details>

            <!-- Twofish -->
            <details class="cipher-item" id="cipher-twofish">
                <summary class="cipher-summary">
                    <span class="cipher-title">
                        <i class="fas fa-shield-alt"></i> <strong>Twofish</strong>
                        <span class="badge-success">Secure</span>
                    </span>
                    <i class="fas fa-chevron-down"></i>
                </summary>
                <div class="cipher-content">
                    <div class="cipher-grid">
                        <div class="cipher-spec">
                            <h6><i class="fas fa-info-circle"></i> Specifications</h6>
                            <table class="spec-table">
                                <tr><td><strong>Key Sizes</strong></td><td>128, 192, 256 bits</td></tr>
                                <tr><td><strong>Block Size</strong></td><td>128 bits</td></tr>
                                <tr><td><strong>Rounds</strong></td><td>16</td></tr>
                                <tr><td><strong>Structure</strong></td><td>Feistel Network</td></tr>
                                <tr><td><strong>Published</strong></td><td>1998</td></tr>
                                <tr><td><strong>Designer</strong></td><td>Bruce Schneier et al.</td></tr>
                                <tr><td><strong>Status</strong></td><td>AES Finalist</td></tr>
                            </table>
                            <div class="alert-success">
                                <strong><i class="fas fa-check-circle"></i> Security:</strong> Highly secure, AES competition finalist. Good alternative to AES with no known vulnerabilities.
                            </div>
                        </div>
                        <div class="cipher-modes">
                            <h6><i class="fas fa-lightbulb"></i> Key Features</h6>
                            <ul>
                                <li>AES finalist (runner-up to Rijndael)</li>
                                <li>128-bit block size (same as AES)</li>
                                <li>Public domain, no patents</li>
                                <li>Key-dependent S-boxes</li>
                                <li>Flexible design for various platforms</li>
                            </ul>
                            <p class="tip"><i class="fas fa-trophy"></i> <strong>AES Competition:</strong> Twofish was one of the five finalists in the AES selection process.</p>
                        </div>
                    </div>
                </div>
            </details>

            <!-- Camellia -->
            <details class="cipher-item" id="cipher-camellia">
                <summary class="cipher-summary">
                    <span class="cipher-title">
                        <i class="fas fa-shield-alt"></i> <strong>Camellia</strong>
                        <span class="badge-success">Secure</span>
                    </span>
                    <i class="fas fa-chevron-down"></i>
                </summary>
                <div class="cipher-content">
                    <div class="cipher-grid">
                        <div class="cipher-spec">
                            <h6><i class="fas fa-info-circle"></i> Specifications</h6>
                            <table class="spec-table">
                                <tr><td><strong>Key Sizes</strong></td><td>128, 192, 256 bits</td></tr>
                                <tr><td><strong>Block Size</strong></td><td>128 bits</td></tr>
                                <tr><td><strong>Rounds</strong></td><td>18 or 24</td></tr>
                                <tr><td><strong>Structure</strong></td><td>Feistel Network</td></tr>
                                <tr><td><strong>Published</strong></td><td>2000</td></tr>
                                <tr><td><strong>Designers</strong></td><td>Mitsubishi Electric, NTT</td></tr>
                                <tr><td><strong>Certification</strong></td><td>CRYPTREC, NESSIE, ISO/IEC</td></tr>
                            </table>
                            <div class="alert-success">
                                <strong><i class="fas fa-check-circle"></i> Security:</strong> Internationally certified. Comparable security to AES. Popular in Japan and Europe.
                            </div>
                        </div>
                        <div class="cipher-modes">
                            <h6><i class="fas fa-lightbulb"></i> Key Features</h6>
                            <ul>
                                <li>Similar performance to AES</li>
                                <li>Strong against differential/linear cryptanalysis</li>
                                <li>Efficient in both software and hardware</li>
                                <li>Derived from E2 and MISTY1</li>
                                <li>Approved by ISO/IEC 18033-3</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </details>

            <!-- ChaCha20 -->
            <details class="cipher-item" id="cipher-chacha">
                <summary class="cipher-summary">
                    <span class="cipher-title">
                        <i class="fas fa-rocket"></i> <strong>ChaCha20</strong>
                        <span class="badge-success">Modern</span>
                    </span>
                    <i class="fas fa-chevron-down"></i>
                </summary>
                <div class="cipher-content">
                    <div class="cipher-grid">
                        <div class="cipher-spec">
                            <h6><i class="fas fa-info-circle"></i> Specifications</h6>
                            <table class="spec-table">
                                <tr><td><strong>Key Size</strong></td><td>256 bits</td></tr>
                                <tr><td><strong>State Size</strong></td><td>512 bits</td></tr>
                                <tr><td><strong>Rounds</strong></td><td>20</td></tr>
                                <tr><td><strong>Structure</strong></td><td>ARX (Add-Rotate-XOR)</td></tr>
                                <tr><td><strong>Published</strong></td><td>2007</td></tr>
                                <tr><td><strong>Designer</strong></td><td>Daniel J. Bernstein</td></tr>
                                <tr><td><strong>Type</strong></td><td>Stream Cipher</td></tr>
                            </table>
                            <div class="alert-success">
                                <strong><i class="fas fa-rocket"></i> Modern Choice:</strong> Fast, secure stream cipher. Used in TLS, SSH, VPN. More efficient than AES in software on CPUs without AES-NI.
                            </div>
                        </div>
                        <div class="cipher-modes">
                            <h6><i class="fas fa-lightbulb"></i> Key Features</h6>
                            <ul>
                                <li>Very fast in software (constant-time)</li>
                                <li>Resistant to timing attacks</li>
                                <li>Used in Google Chrome (TLS)</li>
                                <li>Used in WireGuard VPN</li>
                                <li>Variant of Salsa20</li>
                                <li>eSTREAM portfolio finalist</li>
                            </ul>
                            <p class="tip"><i class="fas fa-star"></i> <strong>Modern Standard:</strong> ChaCha20-Poly1305 is an IETF standard (RFC 7539).</p>
                        </div>
                    </div>
                </div>
            </details>

            <!-- Other Algorithms -->
            <details class="cipher-item" id="cipher-other">
                <summary class="cipher-summary">
                    <span class="cipher-title">
                        <i class="fas fa-list"></i> <strong>Other Supported Algorithms</strong>
                    </span>
                    <i class="fas fa-chevron-down"></i>
                </summary>
                <div class="cipher-content">
                    <div class="other-algorithms-grid">
                        <div>
                            <h6>Stream Ciphers</h6>
                            <ul>
                                <li><strong>Salsa20</strong> - Fast stream cipher by Bernstein</li>
                                <li><strong>HC-128</strong> - eSTREAM finalist</li>
                                <li><strong>HC-256</strong> - eSTREAM finalist</li>
                                <li><strong>Grain v1</strong> - Hardware-oriented</li>
                                <li><strong>Grain-128</strong> - 128-bit key version</li>
                                <li><strong>VMPC</strong> - Variably Modified Permutation</li>
                                <li><strong>RC4</strong> - <span class="badge-danger">Deprecated</span></li>
                            </ul>
                        </div>
                        <div>
                            <h6>Block Ciphers</h6>
                            <ul>
                                <li><strong>Serpent</strong> - AES finalist, very secure</li>
                                <li><strong>ARIA</strong> - Korean standard (similar to AES)</li>
                                <li><strong>SEED</strong> - Korean standard</li>
                                <li><strong>SM4</strong> - Chinese standard</li>
                                <li><strong>GOST 28147-89</strong> - Russian standard</li>
                                <li><strong>Skipjack</strong> - NSA cipher (declassified)</li>
                                <li><strong>TEA/XTEA</strong> - Tiny Encryption Algorithm</li>
                                <li><strong>NOEKEON</strong> - Simple, efficient design</li>
                                <li><strong>Threefish</strong> - 256/512/1024-bit blocks</li>
                            </ul>
                        </div>
                        <div>
                            <h6>Special Purpose</h6>
                            <ul>
                                <li><strong>RC2, RC5, RC6</strong> - Rivest ciphers</li>
                                <li><strong>SHACAL-2</strong> - Based on SHA-2</li>
                                <li><strong>Rijndael</strong> - Original name for AES</li>
                                <li><strong>TNEPRES</strong> - Serpent reversed</li>
                            </ul>
                            <h6 class="mt-3">PBE (Password-Based)</h6>
                            <ul>
                                <li><strong>PBKDF1/PBKDF2</strong> with various ciphers</li>
                                <li>Supports SHA1, SHA256, SHA384, SHA512</li>
                                <li>Combined with AES, DES, RC2, RC4</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </details>

        </div>

        <!-- Comparison Table -->
        <div class="comparison-section">
            <h3><i class="fas fa-table"></i> Quick Comparison</h3>
            <div class="table-responsive">
                <table class="comparison-table">
                    <thead>
                        <tr>
                            <th>Algorithm</th>
                            <th>Key Size</th>
                            <th>Block Size</th>
                            <th>Security</th>
                            <th>Speed</th>
                            <th>Recommendation</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>AES</strong></td>
                            <td>128/192/256-bit</td>
                            <td>128-bit</td>
                            <td><span class="badge-success">Excellent</span></td>
                            <td><span class="badge-success">Fast</span></td>
                            <td><span class="badge-success">Recommended</span></td>
                        </tr>
                        <tr>
                            <td><strong>ChaCha20</strong></td>
                            <td>256-bit</td>
                            <td>Stream</td>
                            <td><span class="badge-success">Excellent</span></td>
                            <td><span class="badge-success">Very Fast</span></td>
                            <td><span class="badge-success">Modern Choice</span></td>
                        </tr>
                        <tr>
                            <td><strong>Twofish</strong></td>
                            <td>128/192/256-bit</td>
                            <td>128-bit</td>
                            <td><span class="badge-success">Excellent</span></td>
                            <td><span class="badge-info">Good</span></td>
                            <td><span class="badge-success">Good Alternative</span></td>
                        </tr>
                        <tr>
                            <td><strong>Camellia</strong></td>
                            <td>128/192/256-bit</td>
                            <td>128-bit</td>
                            <td><span class="badge-success">Excellent</span></td>
                            <td><span class="badge-success">Fast</span></td>
                            <td><span class="badge-success">International Standard</span></td>
                        </tr>
                        <tr>
                            <td><strong>Blowfish</strong></td>
                            <td>32-448-bit</td>
                            <td>64-bit</td>
                            <td><span class="badge-info">Good</span></td>
                            <td><span class="badge-success">Fast</span></td>
                            <td><span class="badge-info">Legacy, Use Twofish</span></td>
                        </tr>
                        <tr>
                            <td><strong>3DES</strong></td>
                            <td>168-bit</td>
                            <td>64-bit</td>
                            <td><span class="badge-warning">Adequate</span></td>
                            <td><span class="badge-warning">Slow</span></td>
                            <td><span class="badge-warning">Legacy Only</span></td>
                        </tr>
                        <tr>
                            <td><strong>DES</strong></td>
                            <td>56-bit</td>
                            <td>64-bit</td>
                            <td><span class="badge-danger">Broken</span></td>
                            <td><span class="badge-info">Fast</span></td>
                            <td><span class="badge-danger">Do Not Use</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Security Recommendations -->
        <div class="security-recommendations">
            <h3><i class="fas fa-shield-alt"></i> Security Recommendations</h3>
            <div class="recommendations-grid">
                <div>
                    <p><strong class="recommended"><i class="fas fa-check-circle"></i> Recommended for Production:</strong></p>
                    <ul>
                        <li>AES-GCM (authenticated encryption)</li>
                        <li>AES-CBC with HMAC</li>
                        <li>ChaCha20-Poly1305</li>
                        <li>Camellia-GCM</li>
                    </ul>
                </div>
                <div>
                    <p><strong class="avoid"><i class="fas fa-times-circle"></i> Avoid in New Designs:</strong></p>
                    <ul>
                        <li>DES (obsolete, broken)</li>
                        <li>3DES (legacy, slow)</li>
                        <li>ECB mode (any cipher)</li>
                        <li>RC4 (broken)</li>
                    </ul>
                </div>
            </div>
        </div>

    </div>
</section>

<style>
/* Cipher Learning Section */
.cipher-learning-section {
    margin: 4rem 0;
}

.learning-card {
    background: var(--bg-primary, #ffffff);
    border: 1px solid var(--border, #e2e8f0);
    border-radius: var(--radius-xl, 1rem);
    padding: 2.5rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.learning-header {
    margin-bottom: 2rem;
    padding-bottom: 1.5rem;
    border-bottom: 2px solid var(--border, #e2e8f0);
}

.learning-header h2 {
    font-size: 1.875rem;
    font-weight: 700;
    color: var(--text-primary, #0f172a);
    margin-bottom: 0.75rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.learning-subtitle {
    font-size: 1rem;
    color: var(--text-secondary, #475569);
    line-height: 1.6;
    margin: 0;
}

/* Quick Navigation */
.quick-nav {
    background: var(--bg-secondary, #f8fafc);
    padding: 1.25rem;
    border-radius: var(--radius-lg, 0.75rem);
    margin-bottom: 2rem;
}

.quick-nav strong {
    display: block;
    margin-bottom: 0.75rem;
    color: var(--text-primary, #0f172a);
    font-size: 0.9375rem;
}

.nav-pills {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
}

.nav-pill {
    padding: 0.5rem 1rem;
    background: var(--primary, #6366f1);
    color: white;
    border-radius: var(--radius-full, 9999px);
    text-decoration: none;
    font-size: 0.875rem;
    font-weight: 500;
    transition: all 0.2s;
}

.nav-pill:hover {
    background: var(--primary-dark, #4f46e5);
    transform: translateY(-1px);
}

/* Cipher Accordion */
.cipher-accordion {
    margin-bottom: 2rem;
}

.cipher-item {
    margin-bottom: 1rem;
    border: 1px solid var(--border, #e2e8f0);
    border-radius: var(--radius-lg, 0.75rem);
    overflow: hidden;
}

.cipher-summary {
    padding: 1.25rem 1.5rem;
    background: var(--bg-secondary, #f8fafc);
    cursor: pointer;
    list-style: none;
    display: flex;
    justify-content: space-between;
    align-items: center;
    transition: background 0.2s;
}

.cipher-summary:hover {
    background: var(--bg-tertiary, #f1f5f9);
}

.cipher-summary::-webkit-details-marker {
    display: none;
}

.cipher-title {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    font-size: 1.0625rem;
}

.cipher-summary i.fa-chevron-down {
    transition: transform 0.3s;
    color: var(--text-muted, #94a3b8);
}

.cipher-item[open] .cipher-summary i.fa-chevron-down {
    transform: rotate(180deg);
}

.cipher-content {
    padding: 1.5rem;
    background: var(--bg-primary, #ffffff);
}

.cipher-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 2rem;
}

@media (min-width: 768px) {
    .cipher-grid {
        grid-template-columns: 1fr 1fr;
    }
}

.cipher-spec h6,
.cipher-modes h6 {
    font-size: 1rem;
    font-weight: 600;
    color: var(--primary, #6366f1);
    margin-bottom: 1rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

/* Tables */
.spec-table,
.modes-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 1rem;
    font-size: 0.875rem;
}

.spec-table td,
.modes-table td {
    padding: 0.625rem;
    border: 1px solid var(--border, #e2e8f0);
}

.spec-table td:first-child {
    font-weight: 600;
    background: var(--bg-secondary, #f8fafc);
    width: 40%;
}

.modes-table thead th {
    background: var(--bg-tertiary, #f1f5f9);
    padding: 0.75rem 0.625rem;
    text-align: left;
    font-weight: 600;
    border: 1px solid var(--border, #e2e8f0);
}

.modes-table code {
    font-family: var(--font-mono, 'JetBrains Mono', monospace);
    font-size: 0.8125rem;
    background: var(--bg-secondary, #f8fafc);
    padding: 0.125rem 0.375rem;
    border-radius: 0.25rem;
}

/* Badges */
.badge-success,
.badge-danger,
.badge-warning,
.badge-info,
.badge-good,
.badge-best {
    padding: 0.25rem 0.625rem;
    border-radius: var(--radius-full, 9999px);
    font-size: 0.75rem;
    font-weight: 600;
    margin-left: 0.5rem;
}

.badge-success {
    background: rgba(16, 185, 129, 0.1);
    color: #10b981;
}

.badge-danger {
    background: rgba(239, 68, 68, 0.1);
    color: #ef4444;
}

.badge-warning {
    background: rgba(245, 158, 11, 0.1);
    color: #f59e0b;
}

.badge-info {
    background: rgba(59, 130, 246, 0.1);
    color: #3b82f6;
}

.badge-good {
    background: rgba(16, 185, 129, 0.1);
    color: #10b981;
}

.badge-best {
    background: rgba(34, 197, 94, 0.15);
    color: #22c55e;
    font-weight: 700;
}

/* Alerts */
.alert-success,
.alert-danger,
.alert-warning,
.alert-info {
    padding: 1rem;
    border-radius: var(--radius-md, 0.5rem);
    margin-top: 1rem;
    font-size: 0.875rem;
    line-height: 1.5;
}

.alert-success {
    background: rgba(16, 185, 129, 0.1);
    border-left: 3px solid #10b981;
    color: #065f46;
}

.alert-danger {
    background: rgba(239, 68, 68, 0.1);
    border-left: 3px solid #ef4444;
    color: #991b1b;
}

.alert-warning {
    background: rgba(245, 158, 11, 0.1);
    border-left: 3px solid #f59e0b;
    color: #92400e;
}

.alert-info {
    background: rgba(59, 130, 246, 0.1);
    border-left: 3px solid #3b82f6;
    color: #1e40af;
}

/* Tip */
.tip {
    margin-top: 1rem;
    padding: 0.75rem;
    background: var(--bg-secondary, #f8fafc);
    border-left: 3px solid var(--primary, #6366f1);
    border-radius: 0 0.5rem 0.5rem 0;
    font-size: 0.875rem;
    color: var(--text-secondary, #475569);
}

.tip i {
    color: var(--primary, #6366f1);
    margin-right: 0.5rem;
}

/* Lists */
.cipher-modes ul,
.other-algorithms-grid ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.cipher-modes ul li,
.other-algorithms-grid ul li {
    padding: 0.5rem 0;
    padding-left: 1.5rem;
    position: relative;
    font-size: 0.875rem;
    line-height: 1.6;
}

.cipher-modes ul li::before,
.other-algorithms-grid ul li::before {
    content: '•';
    position: absolute;
    left: 0.5rem;
    color: var(--primary, #6366f1);
    font-weight: bold;
}

/* Other Algorithms Grid */
.other-algorithms-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 2rem;
}

@media (min-width: 768px) {
    .other-algorithms-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}

.other-algorithms-grid h6 {
    font-size: 1rem;
    font-weight: 600;
    color: var(--text-primary, #0f172a);
    margin-bottom: 1rem;
}

/* Comparison Section */
.comparison-section {
    margin-top: 3rem;
    padding-top: 2rem;
    border-top: 2px solid var(--border, #e2e8f0);
}

.comparison-section h3 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
    color: var(--text-primary, #0f172a);
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.table-responsive {
    overflow-x: auto;
}

.comparison-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.875rem;
}

.comparison-table thead th {
    background: var(--bg-tertiary, #f1f5f9);
    padding: 1rem;
    text-align: left;
    font-weight: 600;
    border: 1px solid var(--border, #e2e8f0);
    color: var(--text-primary, #0f172a);
}

.comparison-table tbody td {
    padding: 0.875rem 1rem;
    border: 1px solid var(--border, #e2e8f0);
}

.comparison-table tbody tr:hover {
    background: var(--bg-secondary, #f8fafc);
}

/* Security Recommendations */
.security-recommendations {
    margin-top: 3rem;
    padding-top: 2rem;
    border-top: 2px solid var(--border, #e2e8f0);
}

.security-recommendations h3 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
    color: var(--text-primary, #0f172a);
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.recommendations-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 2rem;
}

@media (min-width: 768px) {
    .recommendations-grid {
        grid-template-columns: 1fr 1fr;
    }
}

.recommendations-grid > div {
    padding: 1.5rem;
    background: var(--bg-secondary, #f8fafc);
    border-radius: var(--radius-lg, 0.75rem);
}

.recommendations-grid p {
    margin-bottom: 1rem;
    font-size: 0.9375rem;
}

.recommendations-grid .recommended {
    color: #10b981;
}

.recommendations-grid .avoid {
    color: #ef4444;
}

.recommendations-grid ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.recommendations-grid ul li {
    padding: 0.5rem 0;
    padding-left: 1.5rem;
    position: relative;
    font-size: 0.875rem;
}

.recommendations-grid ul li::before {
    content: '✓';
    position: absolute;
    left: 0;
    color: var(--primary, #6366f1);
    font-weight: bold;
}

.recommendations-grid .avoid + ul li::before {
    content: '✗';
    color: #ef4444;
}

/* Dark Mode */
[data-theme="dark"] .learning-card {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
}

[data-theme="dark"] .cipher-summary {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .quick-nav {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .cipher-content {
    background: var(--bg-secondary, #1e293b);
}

[data-theme="dark"] .spec-table td:first-child,
[data-theme="dark"] .modes-table thead th {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .recommendations-grid > div {
    background: var(--bg-tertiary, #334155);
}

/* Responsive */
@media (max-width: 767px) {
    .learning-card {
        padding: 1.5rem;
    }
    
    .learning-header h2 {
        font-size: 1.5rem;
    }
    
    .cipher-grid,
    .other-algorithms-grid,
    .recommendations-grid {
        grid-template-columns: 1fr;
    }
    
    .comparison-table {
        font-size: 0.75rem;
    }
    
    .comparison-table thead th,
    .comparison-table tbody td {
        padding: 0.625rem;
    }
}
</style>


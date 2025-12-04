<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Common NaCl/Libsodium Information Include --%>
<div class="nacl-info-section mt-4">
    <div class="card mb-4">
        <div class="card-header bg-light">
            <h2 class="h5 mb-0">What is NaCl (Networking and Cryptography Library)?</h2>
        </div>
        <div class="card-body">
            <p>NaCl (pronounced "salt") is a high-speed, easy-to-use cryptography library created by <strong>Daniel J. Bernstein</strong>, the mathematician behind Curve25519 and ChaCha20. NaCl focuses on providing secure defaults and avoiding common cryptographic pitfalls.</p>
            <p class="mb-0"><strong>Libsodium</strong> is a portable, cross-platform fork of NaCl with the same API but better packaging and additional algorithms. Most modern applications use libsodium.</p>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-light">
            <h2 class="h5 mb-0">NaCl Cryptographic Primitives</h2>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-sm mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Function</th>
                            <th>Algorithm</th>
                            <th>Purpose</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>crypto_secretbox</code></td>
                            <td>XSalsa20-Poly1305</td>
                            <td>Secret-key authenticated encryption</td>
                        </tr>
                        <tr>
                            <td><code>crypto_box</code></td>
                            <td>Curve25519 + XSalsa20-Poly1305</td>
                            <td>Public-key authenticated encryption</td>
                        </tr>
                        <tr>
                            <td><code>crypto_box_seal</code></td>
                            <td>X25519 + XSalsa20-Poly1305</td>
                            <td>Anonymous public-key encryption</td>
                        </tr>
                        <tr>
                            <td><code>crypto_stream</code></td>
                            <td>XSalsa20</td>
                            <td>Stream cipher (no authentication)</td>
                        </tr>
                        <tr>
                            <td><code>crypto_sign</code></td>
                            <td>Ed25519</td>
                            <td>Digital signatures</td>
                        </tr>
                        <tr>
                            <td><code>crypto_hash</code></td>
                            <td>SHA-512</td>
                            <td>Cryptographic hashing</td>
                        </tr>
                        <tr>
                            <td><code>crypto_auth</code></td>
                            <td>HMAC-SHA-512-256</td>
                            <td>Message authentication</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-light">
            <h2 class="h5 mb-0">Key Sizes & Parameters</h2>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <h6>Secret-key Encryption (secretbox)</h6>
                    <ul class="small mb-3">
                        <li>Key: 32 bytes (256 bits)</li>
                        <li>Nonce: 24 bytes (192 bits)</li>
                        <li>MAC: 16 bytes (128 bits)</li>
                    </ul>
                </div>
                <div class="col-md-6">
                    <h6>Public-key Encryption (box)</h6>
                    <ul class="small mb-3">
                        <li>Public key: 32 bytes</li>
                        <li>Private key: 32 bytes</li>
                        <li>Nonce: 24 bytes</li>
                    </ul>
                </div>
            </div>
            <div class="alert alert-warning small mb-0">
                <strong>Important:</strong> Never reuse a nonce with the same key. The nonce doesn't need to be secret, only unique.
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-light">
            <h2 class="h5 mb-0">NaCl vs Libsodium vs TweetNaCl</h2>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-sm mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Library</th>
                            <th>Language</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>NaCl</strong></td>
                            <td>C</td>
                            <td>Original by D.J. Bernstein. Reference implementation.</td>
                        </tr>
                        <tr>
                            <td><strong>Libsodium</strong></td>
                            <td>C</td>
                            <td>Portable fork of NaCl. Most widely used. Adds AEAD, Argon2, etc.</td>
                        </tr>
                        <tr>
                            <td><strong>TweetNaCl</strong></td>
                            <td>C (100 tweets)</td>
                            <td>Minimal implementation in ~100 tweets. Auditable.</td>
                        </tr>
                        <tr>
                            <td><strong>PyNaCl</strong></td>
                            <td>Python</td>
                            <td>Python bindings to libsodium.</td>
                        </tr>
                        <tr>
                            <td><strong>TweetNaCl.js</strong></td>
                            <td>JavaScript</td>
                            <td>JavaScript port of TweetNaCl for browsers/Node.js.</td>
                        </tr>
                        <tr>
                            <td><strong>Sodium (Go)</strong></td>
                            <td>Go</td>
                            <td><code>golang.org/x/crypto/nacl</code></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-light">
            <h2 class="h5 mb-0">When to Use Each NaCl Function</h2>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <div class="border rounded p-3 h-100">
                        <h6 class="text-primary">Use <code>secretbox</code> when:</h6>
                        <ul class="small mb-0">
                            <li>Both parties share the same secret key</li>
                            <li>Encrypting local data (file encryption)</li>
                            <li>Session encryption after key exchange</li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="border rounded p-3 h-100">
                        <h6 class="text-primary">Use <code>box</code> when:</h6>
                        <ul class="small mb-0">
                            <li>Sender and receiver have key pairs</li>
                            <li>Both parties need to be authenticated</li>
                            <li>Secure messaging between known parties</li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="border rounded p-3 h-100">
                        <h6 class="text-primary">Use <code>sealedbox</code> when:</h6>
                        <ul class="small mb-0">
                            <li>Sender wants to remain anonymous</li>
                            <li>Anonymous tip lines or feedback</li>
                            <li>Only recipient's public key is known</li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="border rounded p-3 h-100">
                        <h6 class="text-primary">Use <code>stream</code> (XSalsa20) when:</h6>
                        <ul class="small mb-0">
                            <li>You need raw stream cipher only</li>
                            <li>Implementing custom protocols</li>
                            <li><strong>Warning:</strong> No authentication!</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-light">
            <h2 class="h5 mb-0">Code Examples</h2>
        </div>
        <div class="card-body">
            <ul class="nav nav-tabs" id="codeExampleTabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="python-tab" data-toggle="tab" href="#python-code" role="tab" aria-controls="python-code" aria-selected="true">Python</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="js-tab" data-toggle="tab" href="#js-code" role="tab" aria-controls="js-code" aria-selected="false">JavaScript</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="go-tab" data-toggle="tab" href="#go-code" role="tab" aria-controls="go-code" aria-selected="false">Go</a>
                </li>
            </ul>
            <div class="tab-content border border-top-0 rounded-bottom p-3" id="codeExampleTabsContent">
                <div class="tab-pane fade show active" id="python-code" role="tabpanel">
<pre class="mb-0"><code># PyNaCl - Secret Box Encryption
from nacl.secret import SecretBox
from nacl.utils import random

key = random(SecretBox.KEY_SIZE)  # 32 bytes
box = SecretBox(key)

# Encrypt
ciphertext = box.encrypt(b"Hello, World!")

# Decrypt
plaintext = box.decrypt(ciphertext)</code></pre>
                </div>
                <div class="tab-pane fade" id="js-code" role="tabpanel">
<pre class="mb-0"><code>// TweetNaCl.js - Secret Box Encryption
const nacl = require('tweetnacl');

const key = nacl.randomBytes(32);
const nonce = nacl.randomBytes(24);
const message = new TextEncoder().encode("Hello, World!");

// Encrypt
const ciphertext = nacl.secretbox(message, nonce, key);

// Decrypt
const plaintext = nacl.secretbox.open(ciphertext, nonce, key);</code></pre>
                </div>
                <div class="tab-pane fade" id="go-code" role="tabpanel">
<pre class="mb-0"><code>// Go - Secret Box Encryption
import "golang.org/x/crypto/nacl/secretbox"

var key [32]byte
var nonce [24]byte
rand.Read(key[:])
rand.Read(nonce[:])

// Encrypt
ciphertext := secretbox.Seal(nil, []byte("Hello"), &nonce, &key)

// Decrypt
plaintext, ok := secretbox.Open(nil, ciphertext, &nonce, &key)</code></pre>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-light">
            <h2 class="h5 mb-0">Security Considerations</h2>
        </div>
        <div class="card-body">
            <ul class="mb-0">
                <li><strong>Nonce reuse:</strong> NEVER reuse a nonce with the same key. This completely breaks security.</li>
                <li><strong>Key management:</strong> Use proper key derivation functions (Argon2, HKDF) for password-based keys.</li>
                <li><strong>Random generation:</strong> Use cryptographically secure random number generators.</li>
                <li><strong>Timing attacks:</strong> NaCl/libsodium functions are designed to be constant-time.</li>
                <li><strong>Memory safety:</strong> Libsodium provides <code>sodium_memzero()</code> to securely clear sensitive data.</li>
            </ul>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-light">
            <h2 class="h5 mb-0">Learn More</h2>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <h6>Official Documentation</h6>
                    <ul class="small">
                        <li><a href="https://doc.libsodium.org/" target="_blank" rel="noopener">Libsodium Documentation</a></li>
                        <li><a href="https://nacl.cr.yp.to/" target="_blank" rel="noopener">NaCl Official Site</a></li>
                        <li><a href="https://pynacl.readthedocs.io/" target="_blank" rel="noopener">PyNaCl Documentation</a></li>
                    </ul>
                </div>
                <div class="col-md-6">
                    <h6>8gwifi.org NaCl Tools</h6>
                    <ul class="small mb-0">
                        <li><a href="naclencdec.jsp">XSalsa20 Stream Cipher</a></li>
                        <li><a href="naclaead.jsp">SecretBox (crypto_secretbox)</a></li>
                        <li><a href="naclboxenc.jsp">Box (crypto_box)</a></li>
                        <li><a href="naclsealboxenc.jsp">SealedBox (crypto_box_seal)</a></li>
                        <li><a href="/docs/go-nacl.jsp">Go NaCl Tutorial</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

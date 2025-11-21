<!-- Cipher Algorithm Reference Guide -->
<div class="card shadow-sm mb-4">
	<div class="card-header bg-primary text-white">
		<h4 class="mb-0"><i class="fas fa-book"></i> Cipher Algorithm Reference Guide</h4>
	</div>
	<div class="card-body">
		<p class="lead">Comprehensive reference for 100+ supported cipher algorithms with specifications, modes, and security recommendations.</p>

		<!-- Quick Navigation -->
		<div class="alert alert-info">
			<strong><i class="fas fa-compass"></i> Quick Navigation:</strong>
			<a href="#aes" class="badge badge-primary ml-2">AES</a>
			<a href="#des" class="badge badge-primary ml-1">DES</a>
			<a href="#blowfish" class="badge badge-primary ml-1">Blowfish</a>
			<a href="#twofish" class="badge badge-primary ml-1">Twofish</a>
			<a href="#camellia" class="badge badge-primary ml-1">Camellia</a>
			<a href="#chacha" class="badge badge-primary ml-1">ChaCha</a>
			<a href="#other" class="badge badge-primary ml-1">Other Ciphers</a>
		</div>

		<!-- Accordion for Cipher Details -->
		<div class="accordion" id="cipherAccordion">

			<!-- AES -->
			<div class="card mb-2" id="aes">
				<div class="card-header" id="headingAES">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100" type="button" data-toggle="collapse" data-target="#collapseAES">
							<span><i class="fas fa-shield-alt text-success"></i> <strong>AES</strong> - Advanced Encryption Standard <span class="badge badge-success ml-2">Recommended</span></span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseAES" class="collapse show" data-parent="#cipherAccordion">
					<div class="card-body">
						<div class="row">
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-info-circle"></i> Specifications</h6>
								<table class="table table-sm table-bordered">
									<tbody>
										<tr><td><strong>Key Sizes</strong></td><td>128, 192, 256 bits</td></tr>
										<tr><td><strong>Block Size</strong></td><td>128 bits</td></tr>
										<tr><td><strong>Rounds</strong></td><td>10 (AES-128), 12 (AES-192), 14 (AES-256)</td></tr>
										<tr><td><strong>Structure</strong></td><td>Substitution-Permutation Network</td></tr>
										<tr><td><strong>Published</strong></td><td>1998 (Adopted as NIST standard 2001)</td></tr>
										<tr><td><strong>Designers</strong></td><td>Joan Daemen, Vincent Rijmen</td></tr>
									</tbody>
								</table>
								<div class="alert alert-success mb-0">
									<strong><i class="fas fa-check-circle"></i> Security Status:</strong> Highly secure, industry standard. AES-256 recommended for high-security applications.
								</div>
							</div>
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-cogs"></i> Supported Modes</h6>
								<div class="table-responsive">
									<table class="table table-sm table-striped">
										<thead class="thead-light">
											<tr><th>Cipher Mode</th><th>Padding</th><th>Security</th></tr>
										</thead>
										<tbody>
											<tr><td><code>AES/CBC/PKCS5PADDING</code></td><td>PKCS5</td><td><span class="badge badge-success">Good</span></td></tr>
											<tr><td><code>AES/CBC/NOPADDING</code></td><td>None</td><td><span class="badge badge-warning">Manual</span></td></tr>
											<tr><td><code>AES/ECB/PKCS5PADDING</code></td><td>PKCS5</td><td><span class="badge badge-danger">Not Recommended</span></td></tr>
											<tr><td><code>AES/ECB/NOPADDING</code></td><td>None</td><td><span class="badge badge-danger">Not Recommended</span></td></tr>
											<tr><td><code>AES_128/GCM/NOPADDING</code></td><td>None</td><td><span class="badge badge-success">Best</span></td></tr>
											<tr><td><code>AES_192/GCM/NOPADDING</code></td><td>None</td><td><span class="badge badge-success">Best</span></td></tr>
											<tr><td><code>AES_256/GCM/NOPADDING</code></td><td>None</td><td><span class="badge badge-success">Best</span></td></tr>
											<tr><td><code>AES_128/CBC/NOPADDING</code></td><td>None</td><td><span class="badge badge-success">Good</span></td></tr>
											<tr><td><code>AES_128/CFB/NOPADDING</code></td><td>None</td><td><span class="badge badge-info">Good</span></td></tr>
											<tr><td><code>AES_128/OFB/NOPADDING</code></td><td>None</td><td><span class="badge badge-info">Good</span></td></tr>
										</tbody>
									</table>
								</div>
								<p class="small text-muted"><i class="fas fa-lightbulb"></i> <strong>Tip:</strong> Use GCM mode for authenticated encryption. CBC mode requires unique IV for each encryption.</p>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- DES -->
			<div class="card mb-2" id="des">
				<div class="card-header" id="headingDES">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseDES">
							<span><i class="fas fa-lock text-danger"></i> <strong>DES</strong> - Data Encryption Standard <span class="badge badge-danger ml-2">Obsolete</span></span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseDES" class="collapse" data-parent="#cipherAccordion">
					<div class="card-body">
						<div class="row">
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-info-circle"></i> Specifications</h6>
								<table class="table table-sm table-bordered">
									<tbody>
										<tr><td><strong>Key Size</strong></td><td>56 bits (+8 parity bits)</td></tr>
										<tr><td><strong>Block Size</strong></td><td>64 bits</td></tr>
										<tr><td><strong>Rounds</strong></td><td>16</td></tr>
										<tr><td><strong>Structure</strong></td><td>Balanced Feistel Network</td></tr>
										<tr><td><strong>Published</strong></td><td>1975</td></tr>
										<tr><td><strong>Designer</strong></td><td>IBM</td></tr>
									</tbody>
								</table>
								<div class="alert alert-danger mb-0">
									<strong><i class="fas fa-exclamation-triangle"></i> Security Warning:</strong> DES is obsolete and insecure! 56-bit key is too small and can be brute-forced. <strong>Use AES instead.</strong>
								</div>
							</div>
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-cogs"></i> Supported Modes (Not Recommended)</h6>
								<table class="table table-sm table-striped">
									<tbody>
										<tr><td><code>DES/CBC/NOPADDING</code></td></tr>
										<tr><td><code>DES/CBC/PKCS5PADDING</code></td></tr>
										<tr><td><code>DES/ECB/NOPADDING</code></td></tr>
										<tr><td><code>DES/ECB/PKCS5PADDING</code></td></tr>
									</tbody>
								</table>
								<p class="small text-muted"><i class="fas fa-history"></i> <strong>Historical Note:</strong> DES was the federal standard from 1977 to 2001. Superseded by AES.</p>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Triple DES (DESede) -->
			<div class="card mb-2">
				<div class="card-header">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseDESede">
							<span><i class="fas fa-lock text-warning"></i> <strong>3DES (DESede)</strong> - Triple DES <span class="badge badge-warning ml-2">Legacy</span></span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseDESede" class="collapse" data-parent="#cipherAccordion">
					<div class="card-body">
						<div class="row">
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-info-circle"></i> Specifications</h6>
								<table class="table table-sm table-bordered">
									<tbody>
										<tr><td><strong>Key Sizes</strong></td><td>168, 112, 56 bits (3 keying options)</td></tr>
										<tr><td><strong>Block Size</strong></td><td>64 bits</td></tr>
										<tr><td><strong>Rounds</strong></td><td>48 DES-equivalent rounds</td></tr>
										<tr><td><strong>Structure</strong></td><td>Feistel Network</td></tr>
										<tr><td><strong>Published</strong></td><td>1998 (ANSI X9.52)</td></tr>
									</tbody>
								</table>
								<div class="alert alert-warning mb-0">
									<strong><i class="fas fa-info-circle"></i> Status:</strong> Legacy algorithm. More secure than DES but slower. Migrate to AES for new applications.
								</div>
							</div>
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-cogs"></i> Supported Modes</h6>
								<table class="table table-sm table-striped">
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
				</div>
			</div>

			<!-- Blowfish -->
			<div class="card mb-2" id="blowfish">
				<div class="card-header">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseBlowfish">
							<span><i class="fas fa-fish text-info"></i> <strong>Blowfish</strong> <span class="badge badge-info ml-2">Secure</span></span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseBlowfish" class="collapse" data-parent="#cipherAccordion">
					<div class="card-body">
						<div class="row">
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-info-circle"></i> Specifications</h6>
								<table class="table table-sm table-bordered">
									<tbody>
										<tr><td><strong>Key Sizes</strong></td><td>32-448 bits (variable)</td></tr>
										<tr><td><strong>Block Size</strong></td><td>64 bits</td></tr>
										<tr><td><strong>Rounds</strong></td><td>16</td></tr>
										<tr><td><strong>Structure</strong></td><td>Feistel Network</td></tr>
										<tr><td><strong>Published</strong></td><td>1993</td></tr>
										<tr><td><strong>Designer</strong></td><td>Bruce Schneier</td></tr>
										<tr><td><strong>Successor</strong></td><td>Twofish</td></tr>
									</tbody>
								</table>
								<div class="alert alert-info mb-0">
									<strong><i class="fas fa-check-circle"></i> Security:</strong> Secure algorithm with no known practical attacks. Fast and well-analyzed. Small 64-bit block size may be limitation for large data.
								</div>
							</div>
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-lightbulb"></i> Key Features</h6>
								<ul class="small">
									<li>Variable-length key (flexible security)</li>
									<li>Fast in software implementation</li>
									<li>Public domain (no patents)</li>
									<li>Used in password hashing (bcrypt)</li>
									<li>Good choice for legacy systems</li>
								</ul>
								<p class="small text-muted mt-3"><i class="fas fa-info-circle"></i> Blowfish is unpatented and license-free, making it popular for open-source projects.</p>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Twofish -->
			<div class="card mb-2" id="twofish">
				<div class="card-header">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseTwofish">
							<span><i class="fas fa-shield-alt text-success"></i> <strong>Twofish</strong> <span class="badge badge-success ml-2">Secure</span></span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseTwofish" class="collapse" data-parent="#cipherAccordion">
					<div class="card-body">
						<div class="row">
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-info-circle"></i> Specifications</h6>
								<table class="table table-sm table-bordered">
									<tbody>
										<tr><td><strong>Key Sizes</strong></td><td>128, 192, 256 bits</td></tr>
										<tr><td><strong>Block Size</strong></td><td>128 bits</td></tr>
										<tr><td><strong>Rounds</strong></td><td>16</td></tr>
										<tr><td><strong>Structure</strong></td><td>Feistel Network</td></tr>
										<tr><td><strong>Published</strong></td><td>1998</td></tr>
										<tr><td><strong>Designer</strong></td><td>Bruce Schneier et al.</td></tr>
										<tr><td><strong>Status</strong></td><td>AES Finalist</td></tr>
									</tbody>
								</table>
								<div class="alert alert-success mb-0">
									<strong><i class="fas fa-check-circle"></i> Security:</strong> Highly secure, AES competition finalist. Good alternative to AES with no known vulnerabilities.
								</div>
							</div>
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-lightbulb"></i> Key Features</h6>
								<ul class="small">
									<li>AES finalist (runner-up to Rijndael)</li>
									<li>128-bit block size (same as AES)</li>
									<li>Public domain, no patents</li>
									<li>Key-dependent S-boxes</li>
									<li>Flexible design for various platforms</li>
								</ul>
								<p class="small text-muted mt-3"><i class="fas fa-trophy"></i> <strong>AES Competition:</strong> Twofish was one of the five finalists in the AES selection process.</p>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Camellia -->
			<div class="card mb-2" id="camellia">
				<div class="card-header">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseCamellia">
							<span><i class="fas fa-shield-alt text-success"></i> <strong>Camellia</strong> <span class="badge badge-success ml-2">Secure</span></span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseCamellia" class="collapse" data-parent="#cipherAccordion">
					<div class="card-body">
						<div class="row">
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-info-circle"></i> Specifications</h6>
								<table class="table table-sm table-bordered">
									<tbody>
										<tr><td><strong>Key Sizes</strong></td><td>128, 192, 256 bits</td></tr>
										<tr><td><strong>Block Size</strong></td><td>128 bits</td></tr>
										<tr><td><strong>Rounds</strong></td><td>18 or 24</td></tr>
										<tr><td><strong>Structure</strong></td><td>Feistel Network</td></tr>
										<tr><td><strong>Published</strong></td><td>2000</td></tr>
										<tr><td><strong>Designers</strong></td><td>Mitsubishi Electric, NTT</td></tr>
										<tr><td><strong>Certification</strong></td><td>CRYPTREC, NESSIE, ISO/IEC</td></tr>
									</tbody>
								</table>
								<div class="alert alert-success mb-0">
									<strong><i class="fas fa-check-circle"></i> Security:</strong> Internationally certified. Comparable security to AES. Popular in Japan and Europe.
								</div>
							</div>
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-lightbulb"></i> Key Features</h6>
								<ul class="small">
									<li>Similar performance to AES</li>
									<li>Strong against differential/linear cryptanalysis</li>
									<li>Efficient in both software and hardware</li>
									<li>Derived from E2 and MISTY1</li>
									<li>Approved by ISO/IEC 18033-3</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- ChaCha20 -->
			<div class="card mb-2" id="chacha">
				<div class="card-header">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseChaCha">
							<span><i class="fas fa-rocket text-success"></i> <strong>ChaCha20</strong> <span class="badge badge-success ml-2">Modern</span></span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseChaCha" class="collapse" data-parent="#cipherAccordion">
					<div class="card-body">
						<div class="row">
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-info-circle"></i> Specifications</h6>
								<table class="table table-sm table-bordered">
									<tbody>
										<tr><td><strong>Key Size</strong></td><td>256 bits</td></tr>
										<tr><td><strong>State Size</strong></td><td>512 bits</td></tr>
										<tr><td><strong>Rounds</strong></td><td>20</td></tr>
										<tr><td><strong>Structure</strong></td><td>ARX (Add-Rotate-XOR)</td></tr>
										<tr><td><strong>Published</strong></td><td>2007</td></tr>
										<tr><td><strong>Designer</strong></td><td>Daniel J. Bernstein</td></tr>
										<tr><td><strong>Type</strong></td><td>Stream Cipher</td></tr>
									</tbody>
								</table>
								<div class="alert alert-success mb-0">
									<strong><i class="fas fa-rocket"></i> Modern Choice:</strong> Fast, secure stream cipher. Used in TLS, SSH, VPN. More efficient than AES in software on CPUs without AES-NI.
								</div>
							</div>
							<div class="col-md-6">
								<h6 class="text-primary"><i class="fas fa-lightbulb"></i> Key Features</h6>
								<ul class="small">
									<li>Very fast in software (constant-time)</li>
									<li>Resistant to timing attacks</li>
									<li>Used in Google Chrome (TLS)</li>
									<li>Used in WireGuard VPN</li>
									<li>Variant of Salsa20</li>
									<li>eSTREAM portfolio finalist</li>
								</ul>
								<p class="small text-muted mt-3"><i class="fas fa-star"></i> <strong>Modern Standard:</strong> ChaCha20-Poly1305 is an IETF standard (RFC 7539).</p>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- CAST5/CAST6 -->
			<div class="card mb-2">
				<div class="card-header">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseCAST">
							<span><i class="fas fa-lock text-info"></i> <strong>CAST5 / CAST6</strong></span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseCAST" class="collapse" data-parent="#cipherAccordion">
					<div class="card-body">
						<h6 class="text-primary">CAST5 (CAST-128)</h6>
						<table class="table table-sm table-bordered mb-3">
							<tbody>
								<tr><td><strong>Key Sizes</strong></td><td>40-128 bits</td></tr>
								<tr><td><strong>Block Size</strong></td><td>64 bits</td></tr>
								<tr><td><strong>Rounds</strong></td><td>12 or 16</td></tr>
								<tr><td><strong>Designers</strong></td><td>Carlisle Adams, Stafford Tavares</td></tr>
							</tbody>
						</table>
						<p class="small text-muted"><i class="fas fa-info-circle"></i> Used in PGP and available in many crypto libraries.</p>
					</div>
				</div>
			</div>

			<!-- IDEA -->
			<div class="card mb-2">
				<div class="card-header">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseIDEA">
							<span><i class="fas fa-lock text-info"></i> <strong>IDEA</strong> - International Data Encryption Algorithm</span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseIDEA" class="collapse" data-parent="#cipherAccordion">
					<div class="card-body">
						<div class="row">
							<div class="col-md-6">
								<table class="table table-sm table-bordered">
									<tbody>
										<tr><td><strong>Key Size</strong></td><td>128 bits</td></tr>
										<tr><td><strong>Block Size</strong></td><td>64 bits</td></tr>
										<tr><td><strong>Rounds</strong></td><td>8.5</td></tr>
										<tr><td><strong>Structure</strong></td><td>Lai-Massey Scheme</td></tr>
										<tr><td><strong>Designers</strong></td><td>Xuejia Lai, James Massey</td></tr>
									</tbody>
								</table>
							</div>
							<div class="col-md-6">
								<p class="small text-muted"><i class="fas fa-history"></i> Used in early versions of PGP. Patented (expired 2012). Replaced by AES in most applications.</p>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Other Stream Ciphers & Modern Algorithms -->
			<div class="card mb-2" id="other">
				<div class="card-header bg-light">
					<h5 class="mb-0">
						<button class="btn btn-link text-left d-flex justify-content-between align-items-center w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseOther">
							<span><i class="fas fa-list"></i> <strong>Other Supported Algorithms</strong></span>
							<i class="fas fa-chevron-down"></i>
						</button>
					</h5>
				</div>
				<div id="collapseOther" class="collapse" data-parent="#cipherAccordion">
					<div class="card-body">
						<div class="row">
							<div class="col-md-4">
								<h6 class="text-primary">Stream Ciphers</h6>
								<ul class="small">
									<li><strong>Salsa20</strong> - Fast stream cipher by Bernstein</li>
									<li><strong>HC-128</strong> - eSTREAM finalist</li>
									<li><strong>HC-256</strong> - eSTREAM finalist</li>
									<li><strong>Grain v1</strong> - Hardware-oriented</li>
									<li><strong>Grain-128</strong> - 128-bit key version</li>
									<li><strong>VMPC</strong> - Variably Modified Permutation</li>
									<li><strong>RC4</strong> - <span class="badge badge-danger">Deprecated</span></li>
								</ul>
							</div>
							<div class="col-md-4">
								<h6 class="text-primary">Block Ciphers</h6>
								<ul class="small">
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
							<div class="col-md-4">
								<h6 class="text-primary">Special Purpose</h6>
								<ul class="small">
									<li><strong>RC2, RC5, RC6</strong> - Rivest ciphers</li>
									<li><strong>SHACAL-2</strong> - Based on SHA-2</li>
									<li><strong>Rijndael</strong> - Original name for AES</li>
									<li><strong>TNEPRES</strong> - Serpent reversed</li>
								</ul>
								<h6 class="text-primary mt-3">PBE (Password-Based)</h6>
								<ul class="small">
									<li><strong>PBKDF1/PBKDF2</strong> with various ciphers</li>
									<li>Supports SHA1, SHA256, SHA384, SHA512</li>
									<li>Combined with AES, DES, RC2, RC4</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>

		<!-- Summary Table -->
		<div class="mt-4">
			<h5><i class="fas fa-table"></i> Quick Comparison</h5>
			<div class="table-responsive">
				<table class="table table-sm table-bordered table-hover">
					<thead class="thead-dark">
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
							<td><span class="badge badge-success">Excellent</span></td>
							<td><span class="badge badge-success">Fast</span></td>
							<td><span class="badge badge-success">Recommended</span></td>
						</tr>
						<tr>
							<td><strong>ChaCha20</strong></td>
							<td>256-bit</td>
							<td>Stream</td>
							<td><span class="badge badge-success">Excellent</span></td>
							<td><span class="badge badge-success">Very Fast</span></td>
							<td><span class="badge badge-success">Modern Choice</span></td>
						</tr>
						<tr>
							<td><strong>Twofish</strong></td>
							<td>128/192/256-bit</td>
							<td>128-bit</td>
							<td><span class="badge badge-success">Excellent</span></td>
							<td><span class="badge badge-info">Good</span></td>
							<td><span class="badge badge-success">Good Alternative</span></td>
						</tr>
						<tr>
							<td><strong>Camellia</strong></td>
							<td>128/192/256-bit</td>
							<td>128-bit</td>
							<td><span class="badge badge-success">Excellent</span></td>
							<td><span class="badge badge-success">Fast</span></td>
							<td><span class="badge badge-success">International Standard</span></td>
						</tr>
						<tr>
							<td><strong>Blowfish</strong></td>
							<td>32-448-bit</td>
							<td>64-bit</td>
							<td><span class="badge badge-info">Good</span></td>
							<td><span class="badge badge-success">Fast</span></td>
							<td><span class="badge badge-info">Legacy, Use Twofish</span></td>
						</tr>
						<tr>
							<td><strong>3DES</strong></td>
							<td>168-bit</td>
							<td>64-bit</td>
							<td><span class="badge badge-warning">Adequate</span></td>
							<td><span class="badge badge-warning">Slow</span></td>
							<td><span class="badge badge-warning">Legacy Only</span></td>
						</tr>
						<tr>
							<td><strong>DES</strong></td>
							<td>56-bit</td>
							<td>64-bit</td>
							<td><span class="badge badge-danger">Broken</span></td>
							<td><span class="badge badge-info">Fast</span></td>
							<td><span class="badge badge-danger">Do Not Use</span></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<!-- Security Recommendations -->
		<div class="alert alert-primary mt-4">
			<h6 class="alert-heading"><i class="fas fa-shield-alt"></i> Security Recommendations</h6>
			<hr>
			<div class="row">
				<div class="col-md-6">
					<p class="mb-2"><strong class="text-success"><i class="fas fa-check-circle"></i> Recommended for Production:</strong></p>
					<ul class="mb-0">
						<li>AES-GCM (authenticated encryption)</li>
						<li>AES-CBC with HMAC</li>
						<li>ChaCha20-Poly1305</li>
						<li>Camellia-GCM</li>
					</ul>
				</div>
				<div class="col-md-6">
					<p class="mb-2"><strong class="text-danger"><i class="fas fa-times-circle"></i> Avoid in New Designs:</strong></p>
					<ul class="mb-0">
						<li>DES (obsolete, broken)</li>
						<li>3DES (legacy, slow)</li>
						<li>ECB mode (any cipher)</li>
						<li>RC4 (broken)</li>
					</ul>
				</div>
			</div>
		</div>

	</div>
</div>

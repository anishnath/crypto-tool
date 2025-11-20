<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
	<title>PGP Packet Dump Online – Free | 8gwifi.org</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Free online PGP packet dump tool. Decode and analyze PGP/GPG public and private keys. Parse OpenPGP (RFC 4880) packets including signatures, keys, and user attributes. Inspect key details and structure.">
	<meta name="keywords" content="pgp packet dump, pgpdump online, decode pgp key, parse pgp packet, pgp key analyzer, openpgp packet inspector, pgp key structure, find pgp key id">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/pgpdump.jsp">
	<meta property="og:title" content="PGP Packet Dump Online – Free | 8gwifi.org">
	<meta property="og:description" content="Free online PGP packet dump tool. Decode and analyze PGP/GPG keys. Parse OpenPGP (RFC 4880) packets and inspect key structure.">
	<meta property="og:image" content="https://8gwifi.org/images/site/pgpdump.png">
	<meta property="og:site_name" content="8gwifi.org">
	<meta property="og:locale" content="en_US">

	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:url" content="https://8gwifi.org/pgpdump.jsp">
	<meta name="twitter:title" content="PGP Packet Dump Online – Free | 8gwifi.org">
	<meta name="twitter:description" content="Free PGP packet dump and key analyzer. Decode OpenPGP keys online.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/pgpdump.png">
	<meta name="twitter:creator" content="@anish2good">

	<%@ include file="header-script.jsp"%>

	<!-- WebApplication Schema -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "PGP Packet Dump Online – Free",
  "description" : "Free online PGP packet dump and analysis tool implementing OpenPGP standard (RFC 4880). Decode and parse PGP/GPG public and private keys. Inspect packet structure, signatures, user IDs, and key attributes.",
  "url" : "https://8gwifi.org/pgpdump.jsp",
  "image" : "https://8gwifi.org/images/site/pgpdump.png",
  "screenshot" : "https://8gwifi.org/images/site/pgpdump.png",
  "applicationCategory" : ["SecurityApplication", "CryptographyApplication", "DeveloperApplication"],
  "applicationSubCategory" : "PGP Key Analysis Tool",
  "browserRequirements" : "Requires JavaScript. Works with Chrome, Firefox, Safari, Edge.",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://x.com/anish2good",
    "jobTitle" : "Security Engineer"
  },
  "datePublished" : "2021-06-04",
  "dateModified" : "2025-11-20",
  "offers" : {
    "@type" : "Offer",
    "price" : "0",
    "priceCurrency" : "USD"
  },
  "featureList" : [
    "Decode PGP/GPG public and private keys",
    "Parse OpenPGP packet structure (RFC 4880)",
    "Analyze signature packets and key packets",
    "Extract key IDs and fingerprints",
    "Inspect user IDs and attributes",
    "ASCII-armor decoding with CRC validation"
  ]
}
	</script>

	<!-- WebPage with Breadcrumb Schema -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "PGP Packet Dump Online – Free",
  "description": "Decode and analyze PGP/GPG keys and packets online using OpenPGP standard.",
  "url": "https://8gwifi.org/pgpdump.jsp",
  "breadcrumb": {
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "https://8gwifi.org/"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": "PGP Tools",
        "item": "https://8gwifi.org/pgpencdec.jsp"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": "PGP Packet Dump",
        "item": "https://8gwifi.org/pgpdump.jsp"
      }
    ]
  }
}
	</script>

	<!-- HowTo Schema -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Dump PGP Packet Information Online",
  "description": "Step-by-step guide to decoding and analyzing PGP/GPG keys using online packet dump tool.",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Paste PGP Key",
      "text": "Paste your PGP public or private key (ASCII-armored format) into the textarea. The key should start with -----BEGIN PGP PUBLIC/PRIVATE KEY BLOCK----- and end with the corresponding END marker.",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Dump Packet Information",
      "text": "Click the 'Dump PGP' button to parse and analyze the key structure. The tool will decode the OpenPGP packet format according to RFC 4880.",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Review Packet Details",
      "text": "Examine the decoded packet information including: key version, algorithm, creation time, key ID, fingerprint, signature packets, user IDs, and other OpenPGP packet details.",
      "position": 3
    }
  ]
}
	</script>

	<style>
		/* CLS optimization */
		#output {
			min-height: 150px;
			transition: all 0.3s ease;
		}
		#output:empty {
			min-height: 0;
		}
		#output > * {
			animation: fadeIn 0.3s ease-in;
		}
		@keyframes fadeIn {
			from { opacity: 0; transform: translateY(10px); }
			to { opacity: 1; transform: translateY(0); }
		}

		/* Loading spinner */
		.dump-loading {
			height: 200px;
			display: flex;
			align-items: center;
			justify-content: center;
			flex-direction: column;
		}

		/* Validation feedback */
		.is-valid-custom {
			border-color: #28a745 !important;
		}
		.is-invalid-custom {
			border-color: #dc3545 !important;
		}
		.validation-feedback {
			display: block;
			margin-top: 0.25rem;
			font-size: 0.875rem;
		}
		.validation-feedback.valid-feedback {
			color: #28a745;
		}
		.validation-feedback.invalid-feedback {
			color: #dc3545;
		}
	</style>

	<script type="text/javascript">
		$(document).ready(function() {
			// Enable tooltips
			$('[data-toggle="tooltip"]').tooltip();

			// Real-time validation for PGP key input
			function validatePGPInput() {
				const $textarea = $('#p_dump');
				const value = $textarea.val().trim();
				const $feedback = $('#p_dumpFeedback');

				if (value.length === 0) {
					$textarea.removeClass('is-valid-custom is-invalid-custom');
					$feedback.html('').removeClass('valid-feedback invalid-feedback');
				} else if ((value.includes('-----BEGIN PGP PUBLIC KEY BLOCK-----') ||
						   value.includes('-----BEGIN PGP PRIVATE KEY BLOCK-----') ||
						   value.includes('-----BEGIN PGP MESSAGE-----') ||
						   value.includes('-----BEGIN PGP SIGNATURE-----')) &&
						  (value.includes('-----END PGP PUBLIC KEY BLOCK-----') ||
						   value.includes('-----END PGP PRIVATE KEY BLOCK-----') ||
						   value.includes('-----END PGP MESSAGE-----') ||
						   value.includes('-----END PGP SIGNATURE-----'))) {
					$textarea.removeClass('is-invalid-custom').addClass('is-valid-custom');
					$feedback.html('<i class="fas fa-check-circle"></i> Valid PGP format detected').removeClass('invalid-feedback').addClass('valid-feedback');
				} else {
					$textarea.removeClass('is-valid-custom').addClass('is-invalid-custom');
					$feedback.html('<i class="fas fa-times-circle"></i> Invalid format. Must contain valid PGP BEGIN/END markers').removeClass('valid-feedback').addClass('invalid-feedback');
				}
			}

			$('#p_dump').on('input', validatePGPInput);
			validatePGPInput(); // Validate on load

			// Form submission
			$('#form').submit(function(event) {
				event.preventDefault();

				const pgpData = $('#p_dump').val().trim();

				// Validate input
				if (!pgpData || pgpData.length === 0) {
					$('#output').html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> <strong>Warning:</strong> Please paste a PGP key or message to analyze.</div>');
					$('html, body').animate({ scrollTop: $('#output').offset().top - 100 }, 400);
					return false;
				}

				// Check for valid PGP markers
				const hasValidMarkers = (pgpData.includes('-----BEGIN PGP') && pgpData.includes('-----END PGP'));
				if (!hasValidMarkers) {
					$('#output').html('<div class="alert alert-danger"><i class="fas fa-times-circle"></i> <strong>Invalid PGP Format:</strong> The input must contain valid PGP BEGIN and END markers. Supported formats:<ul class="mt-2 mb-0"><li>PGP PUBLIC KEY BLOCK</li><li>PGP PRIVATE KEY BLOCK</li><li>PGP MESSAGE</li><li>PGP SIGNATURE</li></ul></div>');
					$('html, body').animate({ scrollTop: $('#output').offset().top - 100 }, 400);
					return false;
				}

				// Show loading state
				$('#output').html('<div class="dump-loading"><div class="spinner-border text-primary" role="status"><span class="sr-only">Analyzing PGP packets...</span></div><p class="mt-3">Decoding PGP packet structure... Please wait.</p></div>');

				// Submit form
				$.ajax({
					type: "POST",
					url: "PGPFunctionality",
					data: $("#form").serialize(),
					success: function(msg) {
						$('#output').empty();
						$('#output').append(msg);

						// Smooth scroll to results
						$('html, body').animate({
							scrollTop: $('#output').offset().top - 100
						}, 400);
					},
					error: function() {
						$('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <strong>Error:</strong> Unable to dump PGP packets. Please try again.</div>');
					}
				});
			});

			// Button click handler
			$('#pgpdump').click(function(event) {
				event.preventDefault();
				$('#form').submit();
			});
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>

<h1 class="mt-4">PGP Packet Dump & Analysis</h1>
<p class="lead text-muted">Decode and analyze OpenPGP packet structure for keys, signatures, and messages</p>
<hr>

<form id="form" class="form-horizontal" method="POST" enctype="application/x-www-form-urlencoded">
	<input type="hidden" name="methodName" id="methodName" value="PGP_DUMP">
	<input type="hidden" name="j_csrf" value="<%=request.getSession().getId() %>">

	<div class="form-group">
		<label for="p_dump">
			<i class="fas fa-file-code text-primary"></i> <strong>PGP Key or Message</strong> <span class="text-danger">*</span>
			<i class="fas fa-info-circle help-icon" data-toggle="tooltip" title="Paste PGP public/private key, message, or signature in ASCII-armored format"></i>
		</label>
		<textarea class="form-control" name="p_dump" id="p_dump" rows="12"
			style="font-family: 'Courier New', monospace; font-size: 12px;"
			placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
TIUSqbkLOEq4COIlzG0fhuruUWBM2+ANazq5jkxLrYmHX4AwA2Q6jvd3xE8B1uVj
qT0TEKyZtmBwesEswUxb+vOwVLdWKXpcySXtIQhoKWAUVzG7e5uEawyXABEBAAG0
BWFuaXNoiJwEEAECAAYFAlojjHkACgkQmCS94uDDx9lHewP/UtsSk3lyj5GnHyoT
HZMz+sUFpFlan7agqHf6pV2Pgdb9OMCVauMwl9bjPY9HSHQg/a3gTQ5qNq9txiI2
4Fso2Q3AR6XcVk2wQxS6prJ9imPi1npXarCwZkEgWLXWLuQLHoxRWHf9olUqeW7P
kwQlJ1K9Ib85pCTvx16DN7QwQv8=
=Qteg
-----END PGP PUBLIC KEY BLOCK-----" required>-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
TIUSqbkLOEq4COIlzG0fhuruUWBM2+ANazq5jkxLrYmHX4AwA2Q6jvd3xE8B1uVj
qT0TEKyZtmBwesEswUxb+vOwVLdWKXpcySXtIQhoKWAUVzG7e5uEawyXABEBAAG0
BWFuaXNoiJwEEAECAAYFAlojjHkACgkQmCS94uDDx9lHewP/UtsSk3lyj5GnHyoT
HZMz+sUFpFlan7agqHf6pV2Pgdb9OMCVauMwl9bjPY9HSHQg/a3gTQ5qNq9txiI2
4Fso2Q3AR6XcVk2wQxS6prJ9imPi1npXarCwZkEgWLXWLuQLHoxRWHf9olUqeW7P
kwQlJ1K9Ib85pCTvx16DN7QwQv8=
=Qteg
-----END PGP PUBLIC KEY BLOCK-----</textarea>
		<div id="p_dumpFeedback" class="validation-feedback"></div>
		<small class="form-text text-muted">Supports public keys, private keys, encrypted messages, and signatures</small>
	</div>

	<div class="form-group">
		<button type="submit" class="btn btn-primary btn-lg" id="pgpdump">
			<i class="fas fa-search"></i> Dump PGP Packets
		</button>
		<button type="button" class="btn btn-outline-secondary btn-lg ml-2" onclick="$('#p_dump').val(''); $('#p_dump').trigger('input'); $('#output').empty();">
			<i class="fas fa-eraser"></i> Clear
		</button>
	</div>
</form>

<div id="output">
	<!-- Results will be displayed here via AJAX -->
</div>

<hr>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>

<!-- E-E-A-T Content for SEO -->
<div class="card my-4 border-info">
	<div class="card-header bg-info text-white">
		<h3 class="mb-0">PGP Packet Dump Explained</h3>
	</div>
	<div class="card-body">
		<h4>What is PGP Packet Dump?</h4>
		<p>PGP packet dump is a process of decoding and analyzing the internal structure of OpenPGP keys and messages. Every PGP key, message, or signature is composed of multiple packets that contain specific information according to the OpenPGP standard (RFC 4880).</p>

		<h4>Packet Types Supported</h4>
		<ul>
			<li><strong>Signature Packets:</strong> Contains digital signature data including signature type, algorithm, hash, and creation time</li>
			<li><strong>Public Key Packets:</strong> Contains public key algorithm, key material, creation time, and expiration</li>
			<li><strong>Secret Key Packets:</strong> Contains private key material (encrypted or unencrypted)</li>
			<li><strong>User ID Packets:</strong> Contains identity information (name, email) associated with the key</li>
			<li><strong>User Attribute Packets:</strong> Contains additional attributes like photos</li>
			<li><strong>Trust Packets:</strong> Contains trust/validity information for keys</li>
		</ul>

		<h4>What Information Can You Extract?</h4>
		<ul>
			<li><strong>Key ID:</strong> Unique identifier for the PGP key (last 8 bytes of fingerprint)</li>
			<li><strong>Fingerprint:</strong> Complete cryptographic hash of the key</li>
			<li><strong>Algorithm:</strong> Encryption algorithm used (RSA, DSA, ECDSA, EdDSA, etc.)</li>
			<li><strong>Key Size:</strong> Bit length of the key (2048, 4096, etc.)</li>
			<li><strong>Creation Date:</strong> When the key was generated</li>
			<li><strong>Expiration Date:</strong> When the key expires (if set)</li>
			<li><strong>User IDs:</strong> All identities associated with the key</li>
		</ul>

		<div class="alert alert-info mt-3">
			<strong>Use Cases:</strong> PGP packet dump is useful for debugging key issues, verifying key properties, extracting key IDs for configuration, understanding key structure, and troubleshooting signature/encryption problems.
		</div>
	</div>
</div>

<div class="card my-4 border-success">
	<div class="card-header bg-success text-white">
		<h3 class="mb-0">Author Credentials & Expertise</h3>
	</div>
	<div class="card-body">
		<p><strong>Created by Anish Nath</strong> - Security Engineer specializing in cryptography and PKI systems.</p>
		<ul>
			<li><strong>Experience:</strong> 15+ years in cybersecurity, cryptographic implementations, and OpenPGP/GPG systems</li>
			<li><strong>Expertise:</strong> Deep understanding of RFC 4880 (OpenPGP), packet structure, key management</li>
			<li><strong>Standards Knowledge:</strong> OpenPGP protocol, PGP message format, ASCII armor encoding</li>
			<li><strong>Contact:</strong> <a href="https://x.com/anish2good" target="_blank">@anish2good on X (Twitter)</a></li>
		</ul>

		<div class="alert alert-info mt-3">
			<strong>Implementation Note:</strong> This tool uses Bouncy Castle cryptographic library for parsing OpenPGP packets according to RFC 4880 specification. All processing happens server-side with no data retention.
		</div>
	</div>
</div>

<div class="card my-4 border-primary">
	<div class="card-header bg-primary text-white">
		<h3 class="mb-0">OpenPGP Packet Format (RFC 4880)</h3>
	</div>
	<div class="card-body">
		<h4>Understanding OpenPGP Packets</h4>
		<p>OpenPGP messages, keys, and signatures are sequences of packets. Each packet has a specific format:</p>

		<h5>Packet Structure</h5>
		<ol>
			<li><strong>Packet Tag:</strong> Identifies the packet type (public key, signature, user ID, etc.)</li>
			<li><strong>Packet Length:</strong> Size of the packet body</li>
			<li><strong>Packet Body:</strong> The actual packet data</li>
		</ol>

		<h5>Common Packet Tags</h5>
		<ul>
			<li><strong>Tag 2:</strong> Signature Packet</li>
			<li><strong>Tag 6:</strong> Public-Key Packet</li>
			<li><strong>Tag 5:</strong> Secret-Key Packet</li>
			<li><strong>Tag 13:</strong> User ID Packet</li>
			<li><strong>Tag 14:</strong> Public-Subkey Packet</li>
			<li><strong>Tag 17:</strong> User Attribute Packet</li>
		</ul>

		<h4>ASCII Armor Format</h4>
		<p>PGP data is often encoded in ASCII armor format for easy transmission via email and text channels. ASCII armor:</p>
		<ul>
			<li>Encodes binary data in Base64</li>
			<li>Adds BEGIN and END markers (e.g., -----BEGIN PGP PUBLIC KEY BLOCK-----)</li>
			<li>Includes CRC24 checksum for data integrity</li>
			<li>May include headers like Version, Comment, etc.</li>
		</ul>

		<h4>Authoritative Sources</h4>
		<ul>
			<li><a href="https://tools.ietf.org/html/rfc4880" target="_blank" rel="noopener">RFC 4880 - OpenPGP Message Format</a> (IETF Standard)</li>
			<li><a href="https://www.openpgp.org/" target="_blank" rel="noopener">OpenPGP.org</a> - Official OpenPGP Working Group</li>
			<li><a href="https://www.gnupg.org/documentation/" target="_blank" rel="noopener">GnuPG Documentation</a> - GNU Privacy Guard Official Docs</li>
		</ul>
	</div>
</div>


<%@ include file="addcomments.jsp"%>

<!-- FAQ Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is PGP packet dump?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "PGP packet dump is the process of decoding and analyzing the internal structure of OpenPGP keys, messages, and signatures. It reveals detailed information about packet types, algorithms, key IDs, fingerprints, creation dates, and other OpenPGP packet data according to RFC 4880 specification."
      }
    },
    {
      "@type": "Question",
      "name": "What information can I extract from a PGP key dump?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "From a PGP key dump you can extract: Key ID (unique identifier), fingerprint (complete hash), encryption algorithm (RSA, DSA, ECDSA), key size (bits), creation and expiration dates, user IDs (names/emails), signature information, and packet structure details. This is useful for debugging, verification, and configuration."
      }
    },
    {
      "@type": "Question",
      "name": "Can I dump both public and private PGP keys?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, this tool can dump both PGP public keys (-----BEGIN PGP PUBLIC KEY BLOCK-----) and private keys (-----BEGIN PGP PRIVATE KEY BLOCK-----). It can also analyze encrypted messages and signature packets. The dump shows packet structure without exposing private key material."
      }
    },
    {
      "@type": "Question",
      "name": "What is ASCII armor in PGP?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "ASCII armor is a Base64 encoding format used to represent binary PGP data as printable ASCII text. It includes BEGIN/END markers (like -----BEGIN PGP PUBLIC KEY BLOCK-----), optional headers, and a CRC24 checksum. ASCII armor makes PGP data safe for email transmission and text-based systems."
      }
    },
    {
      "@type": "Question",
      "name": "How do I find my PGP key ID?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To find your PGP key ID, paste your public or private key into the PGP packet dump tool and click 'Dump PGP Packets'. The output will show your Key ID (last 8 bytes of the fingerprint) along with the full fingerprint, algorithm, and other key details."
      }
    },
    {
      "@type": "Question",
      "name": "What OpenPGP packet types are supported?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "This tool supports dumping these OpenPGP packet types: Signature packets, Public-Key packets, Secret-Key packets, User ID packets, User Attribute packets, Trust packets, Public-Subkey packets, and Secret-Subkey packets. ASCII armor decoding with CRC validation is also supported."
      }
    }
  ]
}
</script>

<!-- Organization Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "8gwifi.org",
  "url": "https://8gwifi.org",
  "logo": "https://8gwifi.org/images/site/logo.png",
  "description": "Free online tools for cryptography, networking, development, and security. Created by security engineers for developers and security professionals.",
  "sameAs": [
    "https://x.com/anish2good",
    "https://github.com/anishnath"
  ],
  "founder": {
    "@type": "Person",
    "name": "Anish Nath",
    "jobTitle": "Security Engineer"
  }
}
</script>

</div>

<%@ include file="body-close.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Comprehensive SEO for Index/Homepage
    Includes all schemas for maximum visibility
--%>

<%
    String baseUrl = "https://8gwifi.org";
    String currentUrl = baseUrl + request.getRequestURI();
%>

<!-- JSON-LD: WebSite Schema with SearchAction -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "8gwifi.org - Free Online Tools",
  "alternateName": "8gwifi.org",
  "url": "<%= baseUrl %>",
  "description": "Comprehensive suite of 200+ free online tools for professionals, students, and developers: Cryptography, Network diagnostics, DevOps, Mathematics, Finance, Chemistry, Data Converters, PKI, Blockchain, and more. All tools are client-side, secure, and require no registration.",
  "logo": {
    "@type": "ImageObject",
    "url": "<%= baseUrl %>/images/site/logo.png",
    "width": 512,
    "height": 512
  },
  "image": "<%= baseUrl %>/images/site/logo.png",
  "sameAs": [
    "https://twitter.com/anish2good"
  ],
  "potentialAction": {
    "@type": "SearchAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "<%= baseUrl %>/index.jsp?q={search_term_string}"
    },
    "query-input": "required name=search_term_string"
  },
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "logo": {
      "@type": "ImageObject",
      "url": "<%= baseUrl %>/images/site/logo.png"
    }
  }
}
</script>

<!-- JSON-LD: ItemList Schema for Tool Categories -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "ItemList",
  "name": "Free Online Tools Categories",
  "description": "List of tool categories available on 8gwifi.org",
  "numberOfItems": 10,
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Security & PKI Tools",
      "description": "SSL/TLS scanners, certificate management, JWT/JWS tools, keystores, and comprehensive security utilities",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "PGP Tools",
      "description": "PGP encryption, decryption, key generation, signing, verification, and comprehensive PGP utilities",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "DevOps & Container Tools",
      "description": "Kubernetes, Docker, Ansible generators and infrastructure automation",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 4,
      "name": "Cryptography Tools",
      "description": "Encryption, decryption, hashing, and digital signature tools",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 5,
      "name": "Network Tools",
      "description": "DNS lookup, port scanner, subnet calculator, and network diagnostics",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 6,
      "name": "Secure File Sharing",
      "description": "Encrypted file transfer, secure pastebin, and temporary email",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 7,
      "name": "Blockchain Tools",
      "description": "Ethereum keys, HD wallets, and blockchain development tools",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 8,
      "name": "Encoders & Converters",
      "description": "Base64, JSON, YAML, XML, CSV converters and encoders",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 9,
      "name": "Finance Calculators",
      "description": "EMI calculator, compound interest, stock profit calculator",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 10,
      "name": "Utility Tools",
      "description": "PDF tools, QR code generator, hex editor, text comparison",
      "url": "<%= baseUrl %>/#tools"
    }
  ]
}
</script>

<!-- JSON-LD: BreadcrumbList Schema for Homepage -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "<%= baseUrl %>"
    }
  ]
}
</script>

<!-- JSON-LD: CollectionPage Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "name": "Free Online Tools",
  "description": "Browse free online tools for professionals, students, and developers organized by category",
  "url": "<%= baseUrl %>",
  "mainEntity": {
    "@type": "ItemList",
    "name": "Top Tools and Pages",
    "description": "Top performing pages on 8gwifi.org",
    "numberOfItems": 45,
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "PGP Encrypt/Decrypt",
        "url": "<%= baseUrl %>/pgpencdec.jsp"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": "SSH Functions",
        "url": "<%= baseUrl %>/sshfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": "TikZ Viewer",
        "url": "<%= baseUrl %>/tikz-viewer.jsp"
      },
      {
        "@type": "ListItem",
        "position": 4,
        "name": "PEM Parser Functions",
        "url": "<%= baseUrl %>/PemParserFunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 5,
        "name": "RSA Sign Verify Functions",
        "url": "<%= baseUrl %>/rsasignverifyfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 6,
        "name": "JWK Convert Functions",
        "url": "<%= baseUrl %>/jwkconvertfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 7,
        "name": "Fernet",
        "url": "<%= baseUrl %>/fernet.jsp"
      },
      {
        "@type": "ListItem",
        "position": 8,
        "name": "RSA Functions",
        "url": "<%= baseUrl %>/rsafunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 9,
        "name": "Cipher Functions",
        "url": "<%= baseUrl %>/CipherFunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 10,
        "name": "JWS Generator",
        "url": "<%= baseUrl %>/jwsgen.jsp"
      },
      {
        "@type": "ListItem",
        "position": 11,
        "name": "PGP File Verify",
        "url": "<%= baseUrl %>/pgpfileverify.jsp"
      },
      {
        "@type": "ListItem",
        "position": 12,
        "name": "PGP File Decrypt",
        "url": "<%= baseUrl %>/pgp-file-decrypt.jsp"
      },
      {
        "@type": "ListItem",
        "position": 13,
        "name": "Lewis Structure Generator",
        "url": "<%= baseUrl %>/lewis-structure-generator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 14,
        "name": "EC Sign Verify",
        "url": "<%= baseUrl %>/ecsignverify.jsp"
      },
      {
        "@type": "ListItem",
        "position": 15,
        "name": "PBKDF",
        "url": "<%= baseUrl %>/pbkdf.jsp"
      },
      {
        "@type": "ListItem",
        "position": 16,
        "name": "JKS Functions",
        "url": "<%= baseUrl %>/jks.jsp"
      },
      {
        "@type": "ListItem",
        "position": 17,
        "name": "JWS Parser",
        "url": "<%= baseUrl %>/jwsparse.jsp"
      },
      {
        "@type": "ListItem",
        "position": 18,
        "name": "Base64 Hex",
        "url": "<%= baseUrl %>/base64Hex.jsp"
      },
      {
        "@type": "ListItem",
        "position": 19,
        "name": "EC Functions",
        "url": "<%= baseUrl %>/ecfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 20,
        "name": "PGP Key Functions",
        "url": "<%= baseUrl %>/pgpkeyfunction.jsp"
      },
      {
        "@type": "ListItem",
        "position": 21,
        "name": "PEM Convert",
        "url": "<%= baseUrl %>/pemconvert.jsp"
      },
      {
        "@type": "ListItem",
        "position": 22,
        "name": "PGP Suite",
        "url": "<%= baseUrl %>/pgp-suite.jsp"
      },
      {
        "@type": "ListItem",
        "position": 23,
        "name": "Homepage",
        "url": "<%= baseUrl %>/index.jsp"
      },
      {
        "@type": "ListItem",
        "position": 24,
        "name": "Certificates Tools",
        "url": "<%= baseUrl %>/certs.jsp"
      },
      {
        "@type": "ListItem",
        "position": 25,
        "name": "PEM Public Key",
        "url": "<%= baseUrl %>/pempublic.jsp"
      },
      {
        "@type": "ListItem",
        "position": 26,
        "name": "Steganography Tool",
        "url": "<%= baseUrl %>/steganography-tool.jsp"
      },
      {
        "@type": "ListItem",
        "position": 27,
        "name": "Neural Network Playground",
        "url": "<%= baseUrl %>/neural_network_playground.jsp"
      },
      {
        "@type": "ListItem",
        "position": 28,
        "name": "JWS Verify",
        "url": "<%= baseUrl %>/jwsverify.jsp"
      },
      {
        "@type": "ListItem",
        "position": 29,
        "name": "PBE",
        "url": "<%= baseUrl %>/pbe.jsp"
      },
      {
        "@type": "ListItem",
        "position": 30,
        "name": "Projectile Motion Simulator",
        "url": "<%= baseUrl %>/projectile-motion-simulator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 31,
        "name": "htpasswd Generator",
        "url": "<%= baseUrl %>/htpasswd.jsp"
      },
      {
        "@type": "ListItem",
        "position": 32,
        "name": "Hexdump",
        "url": "<%= baseUrl %>/hexdump.jsp"
      },
      {
        "@type": "ListItem",
        "position": 33,
        "name": "LaTeX Equation Editor",
        "url": "<%= baseUrl %>/latex-equation-editor.jsp"
      },
      {
        "@type": "ListItem",
        "position": 34,
        "name": "PGP Dump",
        "url": "<%= baseUrl %>/pgpdump.jsp"
      },
      {
        "@type": "ListItem",
        "position": 35,
        "name": "Python Intro Tutorial",
        "url": "<%= baseUrl %>/tutorials/python/intro.jsp"
      },
      {
        "@type": "ListItem",
        "position": 36,
        "name": "Argon2",
        "url": "<%= baseUrl %>/argon2.jsp"
      },
      {
        "@type": "ListItem",
        "position": 37,
        "name": "cURL Functions",
        "url": "<%= baseUrl %>/curlfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 38,
        "name": "JWK Functions",
        "url": "<%= baseUrl %>/jwkfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 39,
        "name": "Password Generator",
        "url": "<%= baseUrl %>/passwdgen.jsp"
      },
      {
        "@type": "ListItem",
        "position": 40,
        "name": "BIP39 Mnemonic",
        "url": "<%= baseUrl %>/bip39-mnemonic.jsp"
      },
      {
        "@type": "ListItem",
        "position": 41,
        "name": "Self Signed Certificate Functions",
        "url": "<%= baseUrl %>/SelfSignCertificateFunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 42,
        "name": "Gradient Descent Visualizer",
        "url": "<%= baseUrl %>/gradient_descent_visualizer.jsp"
      },
      {
        "@type": "ListItem",
        "position": 43,
        "name": "ISBN Validator",
        "url": "<%= baseUrl %>/isbn-validator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 44,
        "name": "Programming Tutorials",
        "url": "<%= baseUrl %>/tutorials/index.jsp"
      },
      {
        "@type": "ListItem",
        "position": 45,
        "name": "Exams and Practice",
        "url": "<%= baseUrl %>/exams/index.jsp"
      }
    ]
  },
  "breadcrumb": {
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "<%= baseUrl %>"
      }
    ]
  }
}
</script>

<!-- JSON-LD: Organization Schema (Enhanced) -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "8gwifi.org",
  "url": "<%= baseUrl %>",
  "logo": {
    "@type": "ImageObject",
    "url": "<%= baseUrl %>/images/site/logo.png",
    "width": 512,
    "height": 512
  },
  "description": "Provider of free online developer tools and utilities",
  "foundingDate": "2020",
  "sameAs": [
    "https://twitter.com/anish2good"
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "Customer Service",
    "url": "<%= baseUrl %>",
    "availableLanguage": "English"
  },
  "knowsAbout": [
    "Cryptography",
    "Network Tools",
    "DevOps",
    "Web Development",
    "Security Tools",
    "Data Encoding",
    "Certificate Management"
  ]
}
</script>

<!-- JSON-LD: FAQPage Schema for Common Questions -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Are all tools on 8gwifi.org free to use?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, all 200+ tools on 8gwifi.org are completely free to use. No registration, no credit card, no limitations."
      }
    },
    {
      "@type": "Question",
      "name": "Is my data secure when using these tools?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, all processing happens client-side in your browser. Your data never leaves your device, ensuring complete privacy and security."
      }
    },
    {
      "@type": "Question",
      "name": "Do I need to register to use the tools?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No registration required. All tools work immediately without any sign-up process. Just open the tool and start using it."
      }
    },
    {
      "@type": "Question",
      "name": "What types of tools are available?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "We offer tools for Cryptography (encryption, hashing), Network diagnostics (DNS, port scanning), DevOps (Kubernetes, Docker), Encoders (Base64, JSON, YAML), PKI/Certificates, Blockchain, File sharing, and Finance calculators."
      }
    },
    {
      "@type": "Question",
      "name": "Can I use these tools offline?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Most tools work offline once the page is loaded, as all processing happens client-side in your browser using JavaScript."
      }
    },
    {
      "@type": "Question",
      "name": "Are the tools suitable for commercial use?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, all tools can be used for commercial purposes. They are provided free of charge with no restrictions on usage."
      }
    }
  ]
}
</script>

<!-- JSON-LD: Service Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Service",
  "serviceType": "Web-based Developer Tools",
  "provider": {
    "@type": "Organization",
    "name": "8gwifi.org"
  },
  "areaServed": "Worldwide",
  "availableChannel": {
    "@type": "ServiceChannel",
    "serviceUrl": "<%= baseUrl %>",
    "serviceType": "Online"
  },
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "url": "<%= baseUrl %>"
  }
}
</script>

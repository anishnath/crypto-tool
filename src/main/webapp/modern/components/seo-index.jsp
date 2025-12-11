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
    "url": "<%= baseUrl %>/images/site/4book.png",
    "width": 512,
    "height": 512
  },
  "image": "<%= baseUrl %>/images/site/4book.png",
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
      "url": "<%= baseUrl %>/images/site/4book.png"
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
  "description": "Browse 200+ free online tools for professionals, students, and developers organized by category",
  "url": "<%= baseUrl %>",
  "mainEntity": {
    "@type": "ItemList",
    "numberOfItems": 331,
    "itemListElement": [
      {
        "@type": "SoftwareApplication",
        "name": "Base64 Encoder/Decoder",
        "url": "<%= baseUrl %>/Base64Functions.jsp",
        "applicationCategory": "Encoder",
        "operatingSystem": "Web Browser",
        "offers": {
          "@type": "Offer",
          "price": "0",
          "priceCurrency": "USD"
        }
      },
      {
        "@type": "SoftwareApplication",
        "name": "RSA Encryption/Decryption",
        "url": "<%= baseUrl %>/rsafunctions.jsp",
        "applicationCategory": "Cryptography",
        "operatingSystem": "Web Browser",
        "offers": {
          "@type": "Offer",
          "price": "0",
          "priceCurrency": "USD"
        }
      },
      {
        "@type": "SoftwareApplication",
        "name": "Cipher Encryption/Decryption",
        "url": "<%= baseUrl %>/CipherFunctions.jsp",
        "applicationCategory": "Cryptography",
        "operatingSystem": "Web Browser",
        "offers": {
          "@type": "Offer",
          "price": "0",
          "priceCurrency": "USD"
        }
      },
      {
        "@type": "SoftwareApplication",
        "name": "PGP Encryption/Decryption",
        "url": "<%= baseUrl %>/pgpencdec.jsp",
        "applicationCategory": "Security",
        "operatingSystem": "Web Browser",
        "offers": {
          "@type": "Offer",
          "price": "0",
          "priceCurrency": "USD"
        }
      },
      {
        "@type": "SoftwareApplication",
        "name": "SSL/TLS Scanner",
        "url": "<%= baseUrl %>/sslscan.jsp",
        "applicationCategory": "Security",
        "operatingSystem": "Web Browser",
        "offers": {
          "@type": "Offer",
          "price": "0",
          "priceCurrency": "USD"
        }
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
    "url": "<%= baseUrl %>/images/site/4book.png",
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


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free Blockchain Address Generator & Validator - ETH BTC SOL" />
        <jsp:param name="toolDescription" value="Instantly generate and validate addresses for Ethereum, Bitcoin, Solana, TRON. Convert units, query RPC nodes, encode ABI calldata. 100% secure client-side — no keys leave your browser." />
        <jsp:param name="toolCategory" value="Blockchain" />
        <jsp:param name="toolUrl" value="ethfunctions.jsp" />
        <jsp:param name="toolKeywords" value="ethereum address generator, bitcoin address generator, solana keypair, tron address, blockchain address validator, wei to eth converter, satoshi to btc, abi encoder decoder, EIP-55 checksum, bech32 address, P2PKH, P2WPKH, taproot address, multi-chain crypto tool, base58check, unit converter crypto, solana rpc client, ethereum rpc query, blockchain rpc tool" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Multi-Chain Address Generation, Address Validation & Detection, Unit Conversion (ETH/BTC/SOL), ABI Encode/Decode, EVM & Solana RPC Client, Client-Side Only" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="College, Professional" />
        <jsp:param name="teaches" value="Blockchain address formats, multi-chain cryptography, EVM unit conversion, ABI encoding, EVM and Solana RPC querying" />
        <jsp:param name="howToSteps" value="Select a blockchain (Ethereum, Bitcoin, Solana, or Tron)|Click Generate to create a new random keypair and address|Use Address Validator to verify any address from any chain|Convert between Wei/Gwei/ETH or Satoshi/BTC units|Query EVM or Solana RPC nodes to check balances, blocks, and transactions|Encode or decode EVM ABI calldata for smart contract interaction" />
        <jsp:param name="faq1q" value="What blockchains does this tool support?" />
        <jsp:param name="faq1a" value="This tool supports Ethereum and all EVM-compatible chains (Polygon, BSC, Arbitrum, Base, Optimism), Bitcoin (P2PKH, SegWit Bech32, Taproot), Solana (Ed25519), and Tron (Base58Check). It also includes a built-in RPC client for querying Ethereum and Solana nodes directly. All operations run 100% in your browser." />
        <jsp:param name="faq2q" value="Is it safe to generate private keys in a browser?" />
        <jsp:param name="faq2a" value="This tool runs entirely client-side. No keys are transmitted to any server. You can verify by checking the Network tab in DevTools. For maximum security, disconnect from the internet after the page loads, or use generated keys only for testing." />
        <jsp:param name="faq3q" value="What is the difference between P2PKH, SegWit, and Taproot Bitcoin addresses?" />
        <jsp:param name="faq3a" value="P2PKH (Pay-to-Public-Key-Hash) addresses start with 1 and are the original Bitcoin address format. SegWit (P2WPKH) addresses start with bc1q and offer lower transaction fees. Taproot (P2TR) addresses start with bc1p, support Schnorr signatures, and enable advanced smart contract capabilities." />
        <jsp:param name="faq4q" value="How does the address validator auto-detect the blockchain?" />
        <jsp:param name="faq4a" value="The validator uses prefix and format heuristics: 0x-prefixed 42-char hex for EVM, Base58Check with version byte analysis for Bitcoin P2PKH/P2SH, bech32/bech32m for SegWit/Taproot, 32-44 char Base58 for Solana, and T-prefixed Base58Check for Tron. It then verifies checksums specific to each format." />
        <jsp:param name="faq5q" value="What is ABI encoding and when do I need it?" />
        <jsp:param name="faq5a" value="ABI (Application Binary Interface) encoding converts human-readable function calls into hexadecimal calldata that the EVM understands. You need it when interacting with smart contracts directly, crafting raw transactions, or debugging contract calls. For example, an ERC-20 transfer encodes the recipient address and amount into a 68-byte hex payload." />
        <jsp:param name="faq6q" value="How are Tron addresses derived from Ethereum keys?" />
        <jsp:param name="faq6a" value="Tron uses the same secp256k1 elliptic curve as Ethereum. A Tron address is derived by taking the raw 20-byte Ethereum address, prepending a 0x41 version byte, computing a double-SHA256 checksum, and encoding with Base58Check. The result always starts with the letter T." />
        <jsp:param name="faq7q" value="What units does the converter support?" />
        <jsp:param name="faq7a" value="For Ethereum: Wei, Gwei, Finney, Szabo, and ETH. For Bitcoin: Satoshi, microBTC, milliBTC, and BTC. For Solana: Lamport and SOL. All conversions happen instantly as you type with full BigNumber precision." />
        <jsp:param name="faq8q" value="What can the built-in RPC client do?" />
        <jsp:param name="faq8a" value="The RPC client queries EVM chains (Ethereum, Polygon, Arbitrum, Base, BSC) and Solana directly from your browser. For EVM: check balances, gas prices, blocks, transactions, and call smart contracts via ABI. For Solana: query slot, block height, accounts, balances, transactions, and rent exemption. Choose a preset chain or enter any custom RPC endpoint URL." />
    </jsp:include>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "ItemList",
      "name": "Supported Blockchains",
      "description": "Blockchain networks supported by the Multi-Chain Blockchain Tools",
      "numberOfItems": 4,
      "itemListElement": [
        { "@type": "ListItem", "position": 1, "item": { "@type": "Thing", "name": "Ethereum", "description": "Decentralized blockchain platform supporting smart contracts and EVM-compatible chains", "sameAs": "https://ethereum.org" } },
        { "@type": "ListItem", "position": 2, "item": { "@type": "Thing", "name": "Bitcoin", "description": "First decentralized cryptocurrency — P2PKH, SegWit Bech32, and Taproot address formats", "sameAs": "https://bitcoin.org" } },
        { "@type": "ListItem", "position": 3, "item": { "@type": "Thing", "name": "Solana", "description": "High-performance blockchain using Ed25519 keypairs and proof-of-history consensus", "sameAs": "https://solana.com" } },
        { "@type": "ListItem", "position": 4, "item": { "@type": "Thing", "name": "Tron", "description": "Smart contract platform using secp256k1 with Base58Check-encoded T-prefix addresses", "sameAs": "https://tron.network" } }
      ]
    }
    </script>

    <style>
        :root{
            --mc-tool:#8b5cf6;--mc-tool-dark:#7c3aed;--mc-gradient:linear-gradient(135deg,#8b5cf6 0%,#a78bfa 100%);--mc-light:rgba(139,92,246,0.1);
            --bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;
            --text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;
            --border:#e2e8f0;--font-sans:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;
            --font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
            --shadow-sm:0 1px 2px rgba(0,0,0,0.05);--shadow-lg:0 10px 15px -3px rgba(0,0,0,0.1);
            --radius-md:0.5rem;--radius-lg:0.75rem;
            --z-dropdown:1000;--z-fixed:1030;--z-modal:1050;
            --header-height-desktop:72px;--header-height-mobile:64px;
            --success:#16a34a;--error:#dc2626;--warning:#f59e0b
        }
        [data-theme="dark"]{--mc-light:rgba(139,92,246,0.15);--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155}
        [data-theme="dark"] body{background:var(--bg-primary);color:var(--text-primary)}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed);background:var(--bg-primary);border-bottom:1px solid var(--border);height:var(--header-height-desktop)}

        /* Shared layout classes */
        .tool-page-header{background:var(--bg-primary);border-bottom:1px solid var(--border);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--mc-light);color:var(--mc-tool-dark)}
        [data-theme="dark"] .tool-badge{color:#c4b5fd}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-muted);margin-top:0.25rem}
        .tool-breadcrumbs a{color:var(--text-secondary);text-decoration:none}
        .tool-breadcrumbs a:hover{text-decoration:underline}
        .tool-description-section{border-bottom:1px solid var(--border);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary)}
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,420px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;display:flex;flex-direction:column}.tool-input-column{order:1}.tool-output-column{order:2;min-height:350px}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-card{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--mc-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem}
        .tool-card-body{padding:1rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary);font-size:0.8125rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-input,.tool-form-select{width:100%;padding:0.5rem 0.75rem;font-family:var(--font-sans);font-size:0.8125rem;border:1.5px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);transition:border-color 0.15s;box-sizing:border-box}
        .tool-form-input:focus,.tool-form-select:focus{outline:none;border-color:var(--mc-tool);box-shadow:0 0 0 3px rgba(139,92,246,0.15)}
        textarea.tool-form-input{font-family:var(--font-mono);resize:vertical}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--mc-gradient)!important;color:#fff;transition:opacity .15s;font-family:var(--font-sans)}
        .tool-action-btn:hover{opacity:0.9}
        .tool-action-btn:disabled{opacity:0.5;cursor:not-allowed}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary);border-bottom:1px solid var(--border);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary);flex:1}
        .tool-result-content{padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted)}
        .tool-empty-state svg{margin-bottom:1rem;opacity:0.4}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary);border-color:var(--border)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary)}

        /* Mode Toggle (4 tabs) */
        .mc-mode-toggle{display:flex;border:1.5px solid var(--border);border-radius:0.5rem;overflow:hidden;margin-bottom:0.625rem}
        .mc-mode-btn{flex:1;padding:0.5rem 0.0625rem;font-size:0.65rem;font-weight:600;border:none;background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans);white-space:nowrap}
        .mc-mode-btn:not(:last-child){border-right:1.5px solid var(--border)}
        .mc-mode-btn.mc-active{background:var(--mc-gradient);color:#fff}
        [data-theme="dark"] .mc-mode-btn{background:var(--bg-secondary);color:var(--text-secondary)}
        [data-theme="dark"] .mc-mode-btn.mc-active{background:var(--mc-gradient);color:#fff}
        .mc-panel{display:none}
        .mc-panel-active{display:block}

        /* Chain selector pills */
        .mc-chain-select{display:flex;gap:0.375rem;margin-bottom:0.875rem;flex-wrap:wrap}
        .mc-chain-pill{padding:0.375rem 0.75rem;font-size:0.75rem;font-weight:600;border:1.5px solid var(--border);border-radius:9999px;background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .mc-chain-pill.mc-active{border-color:var(--mc-tool);background:var(--mc-light);color:var(--mc-tool-dark)}
        [data-theme="dark"] .mc-chain-pill{background:var(--bg-secondary)}
        [data-theme="dark"] .mc-chain-pill.mc-active{color:#c4b5fd}

        /* Network toggle */
        .mc-net-toggle{display:flex;gap:0.375rem;margin-bottom:0.875rem}
        .mc-net-btn{padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border:1px solid var(--border);border-radius:0.375rem;background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .mc-net-btn.mc-active{border-color:var(--mc-tool);background:var(--mc-light);color:var(--mc-tool-dark)}
        [data-theme="dark"] .mc-net-btn{background:var(--bg-secondary)}

        /* Warning box */
        .mc-warning{padding:0.75rem;background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);border-radius:0.5rem;font-size:0.75rem;line-height:1.5;color:#92400e;margin-bottom:0.875rem;display:flex;gap:0.5rem;align-items:flex-start}
        .mc-warning svg{flex-shrink:0;margin-top:1px}
        [data-theme="dark"] .mc-warning{background:rgba(245,158,11,0.12);border-color:rgba(245,158,11,0.25);color:#fbbf24}

        /* Output rows */
        .mc-output-row{margin-bottom:1rem}
        .mc-output-label{font-size:0.75rem;font-weight:600;color:var(--text-secondary);margin-bottom:0.25rem;display:flex;align-items:center;justify-content:space-between}
        .mc-output-value{padding:0.625rem 0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;font-family:var(--font-mono);font-size:0.75rem;color:var(--text-primary);word-break:break-all;line-height:1.5;position:relative}
        [data-theme="dark"] .mc-output-value{background:var(--bg-tertiary)}

        /* Copy button */
        .mc-copy-btn{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.5rem;font-size:0.6875rem;font-weight:500;border:1px solid var(--border);border-radius:0.375rem;background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .mc-copy-btn:hover{border-color:var(--mc-tool);color:var(--mc-tool-dark)}
        .mc-copy-btn.copied{border-color:var(--success);color:var(--success)}
        [data-theme="dark"] .mc-copy-btn{background:var(--bg-secondary)}

        /* Status badges */
        .mc-status{display:inline-flex;align-items:center;gap:0.375rem;padding:0.5rem 0.875rem;border-radius:0.5rem;font-size:0.8125rem;font-weight:600;font-family:var(--font-sans)}
        .mc-status-valid{background:rgba(22,163,74,0.1);color:#16a34a;border:1px solid rgba(22,163,74,0.3)}
        .mc-status-invalid{background:rgba(220,38,38,0.1);color:#dc2626;border:1px solid rgba(220,38,38,0.3)}

        /* Toast */
        .mc-toast{position:fixed;top:1rem;right:1rem;z-index:9999;padding:0.75rem 1rem;border-radius:0.5rem;font-size:0.8125rem;font-weight:500;color:#fff;transform:translateY(-1rem);opacity:0;transition:all 0.3s;font-family:var(--font-sans)}
        .mc-toast.show{transform:translateY(0);opacity:1}
        .mc-toast.success{background:#16a34a}
        .mc-toast.error{background:#dc2626}

        /* Scroll animations */
        .mc-anim{opacity:0;transform:translateY(20px);transition:opacity 0.6s ease-out,transform 0.6s ease-out}
        .mc-visible{opacity:1;transform:translateY(0)}
        .mc-anim-d1{transition-delay:0.1s}
        .mc-anim-d2{transition-delay:0.2s}
        .mc-anim-d3{transition-delay:0.3s}

        /* FAQ */
        .faq-container{display:grid;gap:0.5rem}
        .faq-item{border:1px solid var(--border);border-radius:0.5rem;overflow:hidden}
        .faq-question{width:100%;display:flex;align-items:center;justify-content:space-between;padding:0.875rem 1rem;border:none;background:var(--bg-primary);color:var(--text-primary);font-size:0.875rem;font-weight:500;cursor:pointer;text-align:left;font-family:var(--font-sans)}
        [data-theme="dark"] .faq-question{background:var(--bg-secondary)}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0;margin-left:0.5rem}
        .faq-item.open .faq-chevron{transform:rotate(180deg)}
        .faq-answer{display:none;padding:0 1rem 0.875rem;font-size:0.8125rem;line-height:1.6;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}

        /* Intro animation */
        .mc-intro{padding:1.5rem 1.25rem;text-align:center}
        .mc-intro-icon{display:inline-flex;align-items:center;justify-content:center;width:56px;height:56px;border-radius:50%;background:var(--mc-light);color:var(--mc-tool);margin-bottom:0.75rem;animation:mc-pulse 2s ease-in-out infinite}
        @keyframes mc-pulse{0%,100%{transform:scale(1);opacity:1}50%{transform:scale(1.08);opacity:0.85}}
        .mc-intro-title{font-size:1rem;font-weight:700;color:var(--text-primary);margin:0 0 1.25rem;font-family:var(--font-sans)}
        .mc-intro-steps{display:grid;gap:0.625rem;text-align:left;max-width:400px;margin:0 auto 1.25rem}
        .mc-intro-step{display:flex;gap:0.75rem;align-items:flex-start;padding:0.625rem 0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;opacity:0;transform:translateX(-12px);animation:mc-slideIn 0.4s ease-out forwards;animation-delay:var(--delay)}
        @keyframes mc-slideIn{to{opacity:1;transform:translateX(0)}}
        .mc-intro-num{display:flex;align-items:center;justify-content:center;width:1.5rem;height:1.5rem;border-radius:50%;background:var(--mc-gradient);color:#fff;font-size:0.6875rem;font-weight:700;flex-shrink:0;margin-top:1px}
        .mc-intro-step strong{display:block;font-size:0.8125rem;font-weight:600;color:var(--text-primary);margin-bottom:0.125rem}
        .mc-intro-step span{font-size:0.75rem;line-height:1.5;color:var(--text-secondary)}
        .mc-intro-cta{opacity:0;transform:translateY(8px);animation:mc-fadeUp 0.5s ease-out forwards;animation-delay:var(--delay)}
        @keyframes mc-fadeUp{to{opacity:1;transform:translateY(0)}}
        [data-theme="dark"] .mc-intro-step{background:var(--bg-tertiary)}

        /* Password toggle */
        .mc-pw-wrap{position:relative}
        .mc-pw-wrap input{padding-right:2.25rem;width:100%}
        .mc-pw-toggle{position:absolute;right:0.5rem;top:50%;transform:translateY(-50%);border:none;background:none;color:var(--text-muted);cursor:pointer;padding:0.25rem}
        .mc-pw-toggle:hover{color:var(--text-primary)}

        /* Unit converter grid */
        .mc-unit-grid{display:grid;gap:0.625rem}
        .mc-unit-row{display:flex;align-items:center;gap:0.5rem}
        .mc-unit-row label{min-width:4.5rem;font-size:0.75rem;font-weight:600;color:var(--text-secondary);font-family:var(--font-sans)}
        .mc-unit-row input{flex:1;min-width:0}

        /* Quick preset buttons */
        .mc-presets{display:flex;gap:0.375rem;flex-wrap:wrap;margin-bottom:0.875rem}
        .mc-preset-btn{padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border:1px solid var(--border);border-radius:0.375rem;background:var(--bg-primary);color:var(--text-secondary);cursor:pointer;transition:all 0.15s;font-family:var(--font-sans)}
        .mc-preset-btn:hover{border-color:var(--mc-tool);color:var(--mc-tool-dark);background:var(--mc-light)}
        [data-theme="dark"] .mc-preset-btn{background:var(--bg-secondary)}

        /* ABI function presets */
        .mc-abi-presets{display:flex;gap:0.375rem;flex-wrap:wrap;margin-bottom:0.875rem}

        /* RPC status dot */
        .mc-rpc-status{display:flex;align-items:center;gap:0.5rem;margin-bottom:0.875rem;padding:0.5rem 0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;font-size:0.75rem;color:var(--text-secondary)}
        .mc-rpc-dot{width:8px;height:8px;border-radius:50%;flex-shrink:0}
        .mc-rpc-dot.off{background:#94a3b8}
        .mc-rpc-dot.ok{background:#16a34a}
        .mc-rpc-dot.connecting{background:#f59e0b;animation:mc-rpc-pulse 1s ease-in-out infinite}
        .mc-rpc-dot.err{background:#dc2626}
        @keyframes mc-rpc-pulse{0%,100%{opacity:1}50%{opacity:0.3}}
        [data-theme="dark"] .mc-rpc-status{background:var(--bg-tertiary)}

        /* RPC broadcast danger button */
        .mc-btn-danger{background:linear-gradient(135deg,#dc2626 0%,#ef4444 100%)!important}

        /* Chain pill SVG icons */
        .mc-chain-pill svg{vertical-align:-2px;margin-right:0.25rem;flex-shrink:0}
        .mc-chain-pill{display:inline-flex;align-items:center}
    </style>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
    <link rel="preload" href="https://cdnjs.cloudflare.com/ajax/libs/ethers/6.13.4/ethers.umd.min.js" as="script" crossorigin="anonymous">
    <link rel="preload" href="https://cdn.jsdelivr.net/npm/@solana/web3.js@1.95.3/lib/index.iife.min.js" as="script" crossorigin="anonymous">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body>

<%@ include file="modern/components/nav-header.jsp" %>

<!-- Page Header -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Multi-Chain Blockchain Tools</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/CipherFunctions.jsp">Cryptography</a> /
                Blockchain Tools
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Ethereum</span>
            <span class="tool-badge">Bitcoin</span>
            <span class="tool-badge">Solana</span>
            <span class="tool-badge">Tron</span>
            <span class="tool-badge">100% Client-Side</span>
        </div>
    </div>
</header>

<!-- Description -->
<section class="tool-description-section" style="background:var(--mc-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Generate addresses, validate formats, convert units, query RPC nodes, and encode ABI calldata for <strong>Ethereum</strong>, <strong>Bitcoin</strong>, <strong>Solana</strong>, and <strong>Tron</strong> &mdash; entirely in your browser. Powered by <strong>ethers.js v6</strong>, <strong>noble-secp256k1</strong>, and <strong>Solana web3.js</strong>. No server calls, no data leaves your device.</p>
            <p style="margin-top:0.5rem;font-size:0.8125rem;color:var(--text-muted);">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:-1px;margin-right:0.25rem;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>Zero-trust architecture &mdash; all cryptographic operations execute client-side via audited open-source libraries. Verify in DevTools &gt; Network.
            </p>
        </div>
    </div>
</section>

<!-- Main Layout -->
<main class="tool-page-container">

    <!-- Left Column: Input -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>
                Blockchain Utility Tool
            </div>
            <div class="tool-card-body">

                <!-- Mode Toggle -->
                <div class="mc-mode-toggle">
                    <button type="button" class="mc-mode-btn mc-active" data-mode="address-gen" onclick="EthFunctions.switchMode('address-gen')">Generate</button>
                    <button type="button" class="mc-mode-btn" data-mode="address-validate" onclick="EthFunctions.switchMode('address-validate')">Validate</button>
                    <button type="button" class="mc-mode-btn" data-mode="unit-convert" onclick="EthFunctions.switchMode('unit-convert')">Units</button>
                    <button type="button" class="mc-mode-btn" data-mode="abi-codec" onclick="EthFunctions.switchMode('abi-codec')">ABI</button>
                    <button type="button" class="mc-mode-btn" data-mode="tx-decode" onclick="EthFunctions.switchMode('tx-decode')">Tx</button>
                    <button type="button" class="mc-mode-btn" data-mode="rpc" onclick="EthFunctions.switchMode('rpc')">RPC</button>
                </div>

                <!-- Panel 1: Address Generator -->
                <div class="mc-panel mc-panel-active" id="mc-panel-address-gen">
                    <div class="mc-warning">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                        <span><strong>Security:</strong> Never use browser-generated keys for real funds. Use this for testing and learning only.</span>
                    </div>

                    <div class="tool-form-group">
                        <label class="tool-form-label">Blockchain</label>
                        <div class="mc-chain-select" id="mc-gen-chain">
                            <button type="button" class="mc-chain-pill mc-active" data-chain="evm" onclick="EthFunctions.selectGenChain('evm')">Ethereum/EVM</button>
                            <button type="button" class="mc-chain-pill" data-chain="btc" onclick="EthFunctions.selectGenChain('btc')">Bitcoin</button>
                            <button type="button" class="mc-chain-pill" data-chain="sol" onclick="EthFunctions.selectGenChain('sol')">Solana</button>
                            <button type="button" class="mc-chain-pill" data-chain="tron" onclick="EthFunctions.selectGenChain('tron')">Tron</button>
                        </div>
                    </div>

                    <div id="mc-gen-btc-net" style="display:none">
                        <div class="tool-form-group">
                            <label class="tool-form-label">Network</label>
                            <div class="mc-net-toggle">
                                <button type="button" class="mc-net-btn mc-active" data-net="mainnet" onclick="EthFunctions.selectBtcNet('mainnet')">Mainnet</button>
                                <button type="button" class="mc-net-btn" data-net="testnet" onclick="EthFunctions.selectBtcNet('testnet')">Testnet</button>
                            </div>
                        </div>
                    </div>

                    <button type="button" class="tool-action-btn" onclick="EthFunctions.generateAddress()">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg>
                        Generate Random Address
                    </button>
                </div>

                <!-- Panel 2: Address Validator -->
                <div class="mc-panel" id="mc-panel-address-validate">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Paste any blockchain address</label>
                        <input type="text" class="tool-form-input" id="mc-validate-input" placeholder="0x..., 1..., bc1..., T..., or Solana address" spellcheck="false" style="font-family:var(--font-mono)">
                    </div>
                    <button type="button" class="tool-action-btn" onclick="EthFunctions.validateAddress()">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><polyline points="20 6 9 17 4 12"/></svg>
                        Validate Address
                    </button>
                </div>

                <!-- Panel 3: Unit Converter -->
                <div class="mc-panel" id="mc-panel-unit-convert">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Chain</label>
                        <div class="mc-chain-select" id="mc-unit-chain">
                            <button type="button" class="mc-chain-pill mc-active" data-chain="evm" onclick="EthFunctions.selectUnitChain('evm')">ETH</button>
                            <button type="button" class="mc-chain-pill" data-chain="btc" onclick="EthFunctions.selectUnitChain('btc')">BTC</button>
                            <button type="button" class="mc-chain-pill" data-chain="sol" onclick="EthFunctions.selectUnitChain('sol')">SOL</button>
                        </div>
                    </div>

                    <!-- EVM units -->
                    <div id="mc-units-evm">
                        <div class="mc-presets">
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.presetUnit('evm','1','eth')">1 ETH</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.presetUnit('evm','0.1','eth')">0.1 ETH</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.presetUnit('evm','21000','gwei')">21000 Gwei</button>
                        </div>
                        <div class="mc-unit-grid">
                            <div class="mc-unit-row"><label>Wei</label><input type="text" class="tool-form-input" id="mc-u-wei" oninput="EthFunctions.convertEvm('wei')" placeholder="0"></div>
                            <div class="mc-unit-row"><label>Gwei</label><input type="text" class="tool-form-input" id="mc-u-gwei" oninput="EthFunctions.convertEvm('gwei')" placeholder="0"></div>
                            <div class="mc-unit-row"><label>Szabo</label><input type="text" class="tool-form-input" id="mc-u-szabo" oninput="EthFunctions.convertEvm('szabo')" placeholder="0"></div>
                            <div class="mc-unit-row"><label>Finney</label><input type="text" class="tool-form-input" id="mc-u-finney" oninput="EthFunctions.convertEvm('finney')" placeholder="0"></div>
                            <div class="mc-unit-row"><label>ETH</label><input type="text" class="tool-form-input" id="mc-u-eth" oninput="EthFunctions.convertEvm('eth')" placeholder="0"></div>
                        </div>
                    </div>

                    <!-- BTC units -->
                    <div id="mc-units-btc" style="display:none">
                        <div class="mc-presets">
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.presetUnit('btc','1','btc')">1 BTC</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.presetUnit('btc','0.001','btc')">1 mBTC</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.presetUnit('btc','100000','sat')">100k Sat</button>
                        </div>
                        <div class="mc-unit-grid">
                            <div class="mc-unit-row"><label>Satoshi</label><input type="text" class="tool-form-input" id="mc-u-sat" oninput="EthFunctions.convertBtc('sat')" placeholder="0"></div>
                            <div class="mc-unit-row"><label>&mu;BTC</label><input type="text" class="tool-form-input" id="mc-u-ubtc" oninput="EthFunctions.convertBtc('ubtc')" placeholder="0"></div>
                            <div class="mc-unit-row"><label>mBTC</label><input type="text" class="tool-form-input" id="mc-u-mbtc" oninput="EthFunctions.convertBtc('mbtc')" placeholder="0"></div>
                            <div class="mc-unit-row"><label>BTC</label><input type="text" class="tool-form-input" id="mc-u-btc" oninput="EthFunctions.convertBtc('btc')" placeholder="0"></div>
                        </div>
                    </div>

                    <!-- SOL units -->
                    <div id="mc-units-sol" style="display:none">
                        <div class="mc-presets">
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.presetUnit('sol','1','sol')">1 SOL</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.presetUnit('sol','1000000','lamport')">1M Lamport</button>
                        </div>
                        <div class="mc-unit-grid">
                            <div class="mc-unit-row"><label>Lamport</label><input type="text" class="tool-form-input" id="mc-u-lamport" oninput="EthFunctions.convertSol('lamport')" placeholder="0"></div>
                            <div class="mc-unit-row"><label>SOL</label><input type="text" class="tool-form-input" id="mc-u-sol" oninput="EthFunctions.convertSol('sol')" placeholder="0"></div>
                        </div>
                    </div>
                </div>

                <!-- Panel 5: Transaction Decoder -->
                <div class="mc-panel" id="mc-panel-tx-decode">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Raw Transaction Hex (RLP-encoded)</label>
                        <textarea class="tool-form-input" id="mc-tx-input" rows="5" placeholder="0x02f87001808459682f00850a02ffee00825208946b175474e89094c44da98b954eedeac495271d0f8080c001a0... (signed tx hex)" spellcheck="false" style="font-family:var(--font-mono)"></textarea>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Sample Transactions</label>
                        <div class="mc-presets">
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.txPreset('legacy')">Legacy (Type 0)</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.txPreset('eip1559')">EIP-1559 (Type 2)</button>
                        </div>
                    </div>
                    <button type="button" class="tool-action-btn" onclick="EthFunctions.decodeTx()">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                        Decode Transaction
                    </button>
                </div>

                <!-- Panel 6: RPC Client -->
                <div class="mc-panel" id="mc-panel-rpc">

                    <!-- Connection Status -->
                    <div class="mc-rpc-status">
                        <span class="mc-rpc-dot off" id="mc-rpc-dot"></span>
                        <span id="mc-rpc-status-text">Not connected</span>
                    </div>

                    <!-- RPC Endpoint -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">RPC Endpoint</label>
                        <div class="mc-chain-select" id="mc-rpc-presets">
                            <button type="button" class="mc-chain-pill" data-rpc="eth-mainnet" onclick="EthFunctions.selectRpcPreset('eth-mainnet')"><svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M7 1L2 7l5 3 5-3L7 1z" fill="#627EEA"/><path d="M7 10l-5-3 5 6 5-6-5 3z" fill="#627EEA" opacity="0.6"/></svg>ETH</button>
                            <button type="button" class="mc-chain-pill" data-rpc="sepolia" onclick="EthFunctions.selectRpcPreset('sepolia')"><svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M7 1L2 7l5 3 5-3L7 1z" stroke="#627EEA" stroke-width="1.2" fill="none"/><path d="M7 10l-5-3 5 6 5-6-5 3z" stroke="#627EEA" stroke-width="1.2" fill="none" opacity="0.6"/></svg>Sepolia</button>
                            <button type="button" class="mc-chain-pill" data-rpc="polygon" onclick="EthFunctions.selectRpcPreset('polygon')"><svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M9.5 4.5L7 2 4.5 4.5 2 7l2.5 2.5L7 12l2.5-2.5L12 7 9.5 4.5z" fill="#8247E5"/></svg>Polygon</button>
                            <button type="button" class="mc-chain-pill" data-rpc="arbitrum" onclick="EthFunctions.selectRpcPreset('arbitrum')"><svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M7 2l5 9H2l5-9z" fill="#28A0F0"/><path d="M7 5l2.5 4.5h-5L7 5z" fill="#fff"/></svg>Arbitrum</button>
                            <button type="button" class="mc-chain-pill" data-rpc="base" onclick="EthFunctions.selectRpcPreset('base')"><svg width="14" height="14" viewBox="0 0 14 14" fill="none"><circle cx="7" cy="7" r="5.5" fill="#0052FF"/><text x="7" y="9.5" text-anchor="middle" fill="#fff" font-size="7" font-weight="700" font-family="sans-serif">B</text></svg>Base</button>
                            <button type="button" class="mc-chain-pill" data-rpc="bsc" onclick="EthFunctions.selectRpcPreset('bsc')"><svg width="14" height="14" viewBox="0 0 14 14" fill="none"><rect x="3" y="3" width="8" height="8" rx="1" transform="rotate(45 7 7)" fill="#F3BA2F"/></svg>BSC</button>
                            <button type="button" class="mc-chain-pill" data-rpc="solana-mainnet" onclick="EthFunctions.selectRpcPreset('solana-mainnet')"><svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M2 10.5h8.5L12 9H3.5L2 10.5z" fill="#9945FF"/><path d="M2 3.5h8.5L12 5H3.5L2 3.5z" fill="#14F195"/><path d="M2 7h8.5L12 7H3.5L2 7z" fill="url(#sg)"/><defs><linearGradient id="sg" x1="2" y1="7" x2="12" y2="7"><stop stop-color="#9945FF"/><stop offset="1" stop-color="#14F195"/></linearGradient></defs></svg>Solana</button>
                            <button type="button" class="mc-chain-pill" data-rpc="solana-devnet" onclick="EthFunctions.selectRpcPreset('solana-devnet')"><svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M2 10.5h8.5L12 9H3.5L2 10.5z" stroke="#9945FF" stroke-width="0.8" fill="none"/><path d="M2 3.5h8.5L12 5H3.5L2 3.5z" stroke="#14F195" stroke-width="0.8" fill="none"/><path d="M2 7h8.5L12 7H3.5L2 7z" stroke="#9945FF" stroke-width="0.8" fill="none"/></svg>Sol Dev</button>
                            <button type="button" class="mc-chain-pill" data-rpc="custom" onclick="EthFunctions.selectRpcPreset('custom')"><svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke="currentColor" stroke-width="1.2"><circle cx="7" cy="7" r="2.5"/><path d="M7 1v2M7 11v2M1 7h2M11 7h2M2.8 2.8l1.4 1.4M9.8 9.8l1.4 1.4M11.2 2.8l-1.4 1.4M4.2 9.8l-1.4 1.4"/></svg>Custom</button>
                        </div>
                        <input type="text" class="tool-form-input" id="mc-rpc-url" placeholder="https://eth.llamarpc.com" spellcheck="false" style="font-family:var(--font-mono);font-size:0.75rem;margin-top:0.375rem">
                    </div>

                    <!-- Sub-mode Toggle -->
                    <div class="tool-form-group">
                        <div class="mc-net-toggle">
                            <button type="button" class="mc-net-btn mc-active" id="mc-rpc-sub-query" onclick="EthFunctions.selectRpcSub('query')">Query</button>
                            <button type="button" class="mc-net-btn" id="mc-rpc-sub-contract" onclick="EthFunctions.selectRpcSub('contract')">Contract</button>
                            <button type="button" class="mc-net-btn" id="mc-rpc-sub-broadcast" onclick="EthFunctions.selectRpcSub('broadcast')">Broadcast</button>
                        </div>
                    </div>

                    <!-- Sub-panel: Query -->
                    <div id="mc-rpc-query-panel">
                        <div class="tool-form-group">
                            <label class="tool-form-label">Method</label>
                            <select class="tool-form-select" id="mc-rpc-method" onchange="EthFunctions.rpcMethodChanged()">
                                <option value="eth_blockNumber">eth_blockNumber</option>
                                <option value="eth_chainId">eth_chainId</option>
                                <option value="eth_gasPrice">eth_gasPrice</option>
                                <option value="eth_getBalance">eth_getBalance</option>
                                <option value="eth_getCode">eth_getCode</option>
                                <option value="eth_getTransactionByHash">eth_getTransactionByHash</option>
                                <option value="eth_getTransactionReceipt">eth_getTransactionReceipt</option>
                                <option value="eth_getBlockByNumber">eth_getBlockByNumber</option>
                                <option value="eth_call">eth_call</option>
                            </select>
                        </div>
                        <div id="mc-rpc-params"></div>
                        <div class="mc-presets" id="mc-rpc-quickfill" style="display:none">
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.rpcQuickFill('vitalik')">Vitalik.eth</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.rpcQuickFill('usdt')">USDT Contract</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.rpcQuickFill('uniswap')">Uniswap V2 Router</button>
                        </div>
                        <div class="mc-presets" id="mc-rpc-quickfill-sol" style="display:none">
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.rpcQuickFill('system')">System Program</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.rpcQuickFill('token')">Token Program</button>
                            <button type="button" class="mc-preset-btn" onclick="EthFunctions.rpcQuickFill('wsol')">Wrapped SOL</button>
                        </div>
                        <button type="button" class="tool-action-btn" onclick="EthFunctions.executeRpc()">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                            Execute RPC Call
                        </button>
                    </div>

                    <!-- Sub-panel: Contract Read -->
                    <div id="mc-rpc-contract-panel" style="display:none">
                        <div class="tool-form-group">
                            <label class="tool-form-label">Contract Address</label>
                            <input type="text" class="tool-form-input" id="mc-rpc-contract-addr" placeholder="0xdAC17F958D2ee523a2206206994597C13D831ec7" spellcheck="false" style="font-family:var(--font-mono)">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label">ABI (JSON)</label>
                            <div class="mc-presets" style="margin-bottom:0.375rem">
                                <button type="button" class="mc-preset-btn" onclick="EthFunctions.rpcAbiPreset('erc20')">ERC-20</button>
                                <button type="button" class="mc-preset-btn" onclick="EthFunctions.rpcAbiPreset('erc721')">ERC-721</button>
                            </div>
                            <textarea class="tool-form-input" id="mc-rpc-abi" rows="4" placeholder='[{"inputs":[],"name":"name","outputs":[{"type":"string"}],"stateMutability":"view","type":"function"}]' spellcheck="false" style="font-family:var(--font-mono);font-size:0.6875rem" oninput="EthFunctions.onAbiInput()"></textarea>
                        </div>
                        <div class="tool-form-group" id="mc-rpc-func-group" style="display:none">
                            <label class="tool-form-label">Function</label>
                            <select class="tool-form-select" id="mc-rpc-func-select" onchange="EthFunctions.rpcAbiFuncChanged()"></select>
                        </div>
                        <div id="mc-rpc-func-params"></div>
                        <button type="button" class="tool-action-btn" onclick="EthFunctions.executeContractRead()">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                            Call Contract
                        </button>
                    </div>

                    <!-- Sub-panel: Broadcast -->
                    <div id="mc-rpc-broadcast-panel" style="display:none">
                        <div class="mc-warning">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                            <span><strong>Caution:</strong> Broadcasting a signed transaction is irreversible. This sends a real transaction to the network. Only broadcast transactions you have signed offline and fully understand.</span>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label">Signed Transaction Hex</label>
                            <textarea class="tool-form-input" id="mc-rpc-rawtx" rows="4" placeholder="0x02f873..." spellcheck="false" style="font-family:var(--font-mono)"></textarea>
                        </div>
                        <button type="button" class="tool-action-btn mc-btn-danger" onclick="EthFunctions.broadcastTx()">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><path d="M22 2L11 13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
                            Broadcast Transaction
                        </button>
                    </div>
                </div>

                <!-- Panel 4: ABI Encoder/Decoder -->
                <div class="mc-panel" id="mc-panel-abi-codec">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Mode</label>
                        <div class="mc-net-toggle">
                            <button type="button" class="mc-net-btn mc-active" id="mc-abi-mode-encode" onclick="EthFunctions.selectAbiMode('encode')">Encode</button>
                            <button type="button" class="mc-net-btn" id="mc-abi-mode-decode" onclick="EthFunctions.selectAbiMode('decode')">Decode</button>
                        </div>
                    </div>

                    <!-- ABI Encode -->
                    <div id="mc-abi-encode-panel">
                        <div class="tool-form-group">
                            <label class="tool-form-label">Common Functions</label>
                            <div class="mc-abi-presets">
                                <button type="button" class="mc-preset-btn" onclick="EthFunctions.abiPreset('transfer')">ERC-20 transfer</button>
                                <button type="button" class="mc-preset-btn" onclick="EthFunctions.abiPreset('approve')">ERC-20 approve</button>
                                <button type="button" class="mc-preset-btn" onclick="EthFunctions.abiPreset('balanceOf')">balanceOf</button>
                            </div>
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label">Function Signature</label>
                            <input type="text" class="tool-form-input" id="mc-abi-func" placeholder="transfer(address,uint256)" spellcheck="false" style="font-family:var(--font-mono)">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label">Parameters (one per line)</label>
                            <textarea class="tool-form-input" id="mc-abi-params" rows="3" placeholder="0x742d35Cc6634C0532925a3b844Bc9e7595f2bD18&#10;1000000000000000000" style="font-family:var(--font-mono)"></textarea>
                        </div>
                        <button type="button" class="tool-action-btn" onclick="EthFunctions.encodeAbi()">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                            Encode Calldata
                        </button>
                    </div>

                    <!-- ABI Decode -->
                    <div id="mc-abi-decode-panel" style="display:none">
                        <div class="tool-form-group">
                            <label class="tool-form-label">Function Signature (for decoding)</label>
                            <input type="text" class="tool-form-input" id="mc-abi-decode-func" placeholder="transfer(address,uint256)" spellcheck="false" style="font-family:var(--font-mono)">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label">Hex Calldata</label>
                            <textarea class="tool-form-input" id="mc-abi-decode-data" rows="4" placeholder="0xa9059cbb000000000000000000000000..." spellcheck="false" style="font-family:var(--font-mono)"></textarea>
                        </div>
                        <button type="button" class="tool-action-btn" onclick="EthFunctions.decodeAbi()">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                            Decode Calldata
                        </button>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Center Column: Output -->
    <div class="tool-output-column">
        <div class="tool-card" style="height:100%;">
            <div class="tool-result-header">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
                <h4 id="mc-result-title">Result</h4>
                <div style="display:flex;gap:0.375rem" id="mc-result-actions">
                    <button type="button" class="mc-copy-btn" id="mc-share-btn" onclick="EthFunctions.shareResultUrl()" style="display:none">
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
                        Share
                    </button>
                    <button type="button" class="mc-copy-btn" id="mc-download-btn" onclick="EthFunctions.downloadResult()" style="display:none">
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        Download
                    </button>
                </div>
            </div>
            <div class="tool-result-content" id="mc-result-content">
                <div class="mc-intro" id="mc-intro">
                    <div class="mc-intro-icon">
                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>
                    </div>
                    <h3 class="mc-intro-title">Multi-Chain Blockchain Utilities</h3>
                    <div class="mc-intro-steps">
                        <div class="mc-intro-step" style="--delay:0.3s">
                            <span class="mc-intro-num">1</span>
                            <div>
                                <strong>Generate Addresses</strong>
                                <span>Create random keypairs for ETH, BTC (P2PKH, SegWit, Taproot), Solana, and Tron</span>
                            </div>
                        </div>
                        <div class="mc-intro-step" style="--delay:0.6s">
                            <span class="mc-intro-num">2</span>
                            <div>
                                <strong>Validate Any Address</strong>
                                <span>Paste any blockchain address &mdash; auto-detects chain, verifies checksum, identifies type</span>
                            </div>
                        </div>
                        <div class="mc-intro-step" style="--delay:0.9s">
                            <span class="mc-intro-num">3</span>
                            <div>
                                <strong>Convert Units</strong>
                                <span>Wei &harr; Gwei &harr; ETH, Satoshi &harr; BTC, Lamport &harr; SOL &mdash; instant bidirectional</span>
                            </div>
                        </div>
                        <div class="mc-intro-step" style="--delay:1.2s">
                            <span class="mc-intro-num">4</span>
                            <div>
                                <strong>ABI Encode/Decode</strong>
                                <span>Encode smart contract calldata or decode hex back to human-readable parameters</span>
                            </div>
                        </div>
                        <div class="mc-intro-step" style="--delay:1.5s">
                            <span class="mc-intro-num">5</span>
                            <div>
                                <strong>Decode Transactions</strong>
                                <span>Paste raw signed EVM transaction hex &mdash; decode type, from, to, value, gas, signature fields</span>
                            </div>
                        </div>
                        <div class="mc-intro-step" style="--delay:1.8s">
                            <span class="mc-intro-num">6</span>
                            <div>
                                <strong>Live RPC Queries</strong>
                                <span>Query any EVM chain in real-time: balances, blocks, transactions, contract reads</span>
                            </div>
                        </div>
                    </div>
                    <div class="mc-intro-cta" style="--delay:2.2s">
                        <button type="button" class="tool-action-btn" onclick="EthFunctions.generateAddress()" style="max-width:300px;margin:0 auto;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:middle;margin-right:0.375rem;"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg>
                            Try It &mdash; Generate an ETH Address
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Ads -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

</main>

<!-- Educational Sections -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="mc-anim">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.15rem;font-weight:600;margin:0 0 0.75rem;color:var(--text-primary);">What are Blockchain Addresses?</h2>
        <p style="font-size:0.875rem;line-height:1.7;color:var(--text-secondary);margin:0 0 0.75rem;">A blockchain address is a unique identifier derived from a public key using cryptographic hash functions. Each blockchain uses a different derivation path and encoding scheme, but the core concept is the same: your private key generates a public key, and the public key is hashed and encoded into an address that others can use to send you assets.</p>
        <p style="font-size:0.875rem;line-height:1.7;color:var(--text-secondary);margin:0;"><strong>Ethereum</strong> and other EVM chains use the last 20 bytes of the Keccak-256 hash of the public key, displayed as a <code style="background:var(--bg-secondary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;">0x</code>-prefixed hex string with EIP-55 mixed-case checksum. <strong>Bitcoin</strong> uses SHA-256 followed by RIPEMD-160 (hash160) with Base58Check or Bech32 encoding. <strong>Solana</strong> uses Ed25519 public keys encoded in Base58. <strong>Tron</strong> uses the same secp256k1 curve as Ethereum but encodes addresses with a <code style="background:var(--bg-secondary);padding:0.125rem 0.375rem;border-radius:0.25rem;font-size:0.8125rem;">0x41</code> prefix and Base58Check.</p>
    </div>
</section>

<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="mc-anim mc-anim-d1">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.15rem;font-weight:600;margin:0 0 0.75rem;color:var(--text-primary);">Multi-Chain Address Formats</h2>
        <div style="overflow-x:auto;">
            <table style="width:100%;font-size:0.8125rem;border-collapse:collapse;color:var(--text-secondary);">
                <thead><tr style="border-bottom:2px solid var(--border);text-align:left;">
                    <th style="padding:0.5rem 0.75rem;font-weight:600;color:var(--text-primary);">Chain</th>
                    <th style="padding:0.5rem 0.75rem;font-weight:600;color:var(--text-primary);">Format</th>
                    <th style="padding:0.5rem 0.75rem;font-weight:600;color:var(--text-primary);">Example Prefix</th>
                    <th style="padding:0.5rem 0.75rem;font-weight:600;color:var(--text-primary);">Curve</th>
                </tr></thead>
                <tbody>
                    <tr style="border-bottom:1px solid var(--border);"><td style="padding:0.5rem 0.75rem;">Ethereum/EVM</td><td style="padding:0.5rem 0.75rem;">Hex + EIP-55</td><td style="padding:0.5rem 0.75rem;font-family:var(--font-mono);">0x</td><td style="padding:0.5rem 0.75rem;">secp256k1</td></tr>
                    <tr style="border-bottom:1px solid var(--border);"><td style="padding:0.5rem 0.75rem;">Bitcoin P2PKH</td><td style="padding:0.5rem 0.75rem;">Base58Check</td><td style="padding:0.5rem 0.75rem;font-family:var(--font-mono);">1</td><td style="padding:0.5rem 0.75rem;">secp256k1</td></tr>
                    <tr style="border-bottom:1px solid var(--border);"><td style="padding:0.5rem 0.75rem;">Bitcoin SegWit</td><td style="padding:0.5rem 0.75rem;">Bech32</td><td style="padding:0.5rem 0.75rem;font-family:var(--font-mono);">bc1q</td><td style="padding:0.5rem 0.75rem;">secp256k1</td></tr>
                    <tr style="border-bottom:1px solid var(--border);"><td style="padding:0.5rem 0.75rem;">Bitcoin Taproot</td><td style="padding:0.5rem 0.75rem;">Bech32m</td><td style="padding:0.5rem 0.75rem;font-family:var(--font-mono);">bc1p</td><td style="padding:0.5rem 0.75rem;">secp256k1</td></tr>
                    <tr style="border-bottom:1px solid var(--border);"><td style="padding:0.5rem 0.75rem;">Solana</td><td style="padding:0.5rem 0.75rem;">Base58</td><td style="padding:0.5rem 0.75rem;font-family:var(--font-mono);">(varies)</td><td style="padding:0.5rem 0.75rem;">Ed25519</td></tr>
                    <tr><td style="padding:0.5rem 0.75rem;">Tron</td><td style="padding:0.5rem 0.75rem;">Base58Check</td><td style="padding:0.5rem 0.75rem;font-family:var(--font-mono);">T</td><td style="padding:0.5rem 0.75rem;">secp256k1</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</section>

<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="mc-anim mc-anim-d2">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.15rem;font-weight:600;margin:0 0 0.75rem;color:var(--text-primary);">Security Best Practices</h2>
        <ul style="font-size:0.875rem;line-height:1.8;color:var(--text-secondary);margin:0;padding-left:1.25rem;">
            <li><strong>Never share your private key.</strong> Anyone with your private key has full control over your assets on that chain.</li>
            <li><strong>Use test keys for experimentation.</strong> Generate throwaway keypairs with this tool for learning purposes only.</li>
            <li><strong>Verify client-side operation.</strong> Open your browser Network tab to confirm no data leaves your device.</li>
            <li><strong>Use hardware wallets for real funds.</strong> Browser-based key generation should never be used for storing significant value.</li>
            <li><strong>Validate addresses before sending.</strong> Always double-check chain detection and checksum verification before sending transactions.</li>
        </ul>
    </div>
</section>

<!-- Trust & Authority Section -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="mc-anim mc-anim-d3">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.15rem;font-weight:600;margin:0 0 0.75rem;color:var(--text-primary);">Why Trust This Tool?</h2>
        <div style="display:grid;gap:0.75rem;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));">
            <div style="display:flex;gap:0.625rem;align-items:flex-start;padding:0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--mc-tool)" stroke-width="2" style="flex-shrink:0;margin-top:2px;"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
                <div><strong style="font-size:0.8125rem;color:var(--text-primary);">100% Client-Side</strong><br><span style="font-size:0.75rem;color:var(--text-secondary);">All cryptographic operations run in your browser. No keys or data are transmitted to any server.</span></div>
            </div>
            <div style="display:flex;gap:0.625rem;align-items:flex-start;padding:0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--mc-tool)" stroke-width="2" style="flex-shrink:0;margin-top:2px;"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                <div><strong style="font-size:0.8125rem;color:var(--text-primary);">Open-Source Libraries</strong><br><span style="font-size:0.75rem;color:var(--text-secondary);">Built on audited libraries: ethers.js v6, @noble/secp256k1, @scure/base, and Solana web3.js.</span></div>
            </div>
            <div style="display:flex;gap:0.625rem;align-items:flex-start;padding:0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--mc-tool)" stroke-width="2" style="flex-shrink:0;margin-top:2px;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                <div><strong style="font-size:0.8125rem;color:var(--text-primary);">Verifiable Security</strong><br><span style="font-size:0.75rem;color:var(--text-secondary);">Open your browser DevTools &gt; Network tab to confirm zero outbound requests during operation.</span></div>
            </div>
            <div style="display:flex;gap:0.625rem;align-items:flex-start;padding:0.75rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--mc-tool)" stroke-width="2" style="flex-shrink:0;margin-top:2px;"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                <div><strong style="font-size:0.8125rem;color:var(--text-primary);">Maintained Since 2018</strong><br><span style="font-size:0.75rem;color:var(--text-secondary);">Continuously updated by <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" style="color:var(--mc-tool);text-decoration:none;">Anish Nath</a>, covering the latest address formats and RPC standards.</span></div>
            </div>
        </div>
    </div>
</section>

<!-- FAQ Section -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="mc-anim mc-anim-d3">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Frequently Asked Questions</h3>
        <div class="faq-container">
            <div class="faq-item">
                <button class="faq-question" onclick="EthFunctions.toggleFaq(this)">What blockchains does this tool support?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">This tool supports Ethereum and all EVM-compatible chains (Polygon, BSC, Arbitrum, Base, Optimism), Bitcoin (P2PKH, SegWit P2WPKH, Taproot P2TR), Solana (Ed25519), and Tron (Base58Check). It also includes a built-in RPC client for querying Ethereum and Solana nodes. All operations run entirely in your browser.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthFunctions.toggleFaq(this)">Is it safe to generate private keys in a browser?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">This tool runs 100% client-side. No keys are transmitted to any server. Verify by checking the Network tab in DevTools. For maximum security, disconnect from the internet after loading, or use generated keys only for testing and learning.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthFunctions.toggleFaq(this)">What is the difference between P2PKH, SegWit, and Taproot?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">P2PKH (starts with 1) is the original Bitcoin format. SegWit P2WPKH (starts with bc1q) reduces fees by ~40%. Taproot P2TR (starts with bc1p) uses Schnorr signatures for advanced smart contracts and improved privacy. Modern wallets default to SegWit or Taproot.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthFunctions.toggleFaq(this)">How does address validation auto-detect the chain?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The validator checks prefix patterns: 0x + 40 hex chars = EVM, starts with 1/3 with Base58Check = Bitcoin legacy, bc1q/bc1p = Bitcoin SegWit/Taproot, T + 33 Base58 chars = Tron, and 32-44 Base58 chars = Solana. Checksums are then verified for each detected format.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthFunctions.toggleFaq(this)">What is ABI encoding?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">ABI (Application Binary Interface) encoding converts function calls into hex calldata for the Ethereum Virtual Machine. The first 4 bytes are the function selector (keccak256 hash of the signature), followed by 32-byte ABI-encoded parameters. This tool encodes and decodes calldata for any function signature.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthFunctions.toggleFaq(this)">How are Tron addresses related to Ethereum?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Tron uses the same secp256k1 curve and key derivation as Ethereum. A Tron address is derived by taking the 20-byte Ethereum address, prepending version byte 0x41, computing a double-SHA256 checksum (first 4 bytes), appending it, and encoding with Base58. Every Ethereum keypair has a corresponding Tron address.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthFunctions.toggleFaq(this)">What can the RPC client do?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">The built-in RPC client lets you query EVM chains (Ethereum, Polygon, Arbitrum, Base, BSC) and Solana directly from your browser. For EVM chains you can check balances, gas prices, block data, transaction details, and call smart contracts via ABI. For Solana you can query slot, block height, account info, balances, transactions, and rent exemption. Choose a preset chain or enter any custom RPC endpoint.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="EthFunctions.toggleFaq(this)">Can I use this tool offline?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Yes, for address generation, validation, unit conversion, and ABI encoding/decoding. Once JavaScript libraries have loaded, these features work without network access. RPC queries require a network connection to communicate with blockchain nodes, but no private data is sent &mdash; only public read requests.</div>
            </div>
        </div>
    </div>
</section>

<!-- Related Tools -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="mc-anim mc-anim-d3">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Explore More Blockchain &amp; Cryptography Tools</h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/bip39-mnemonic.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#f59e0b,#f97316);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.75rem;color:#fff;font-weight:700;">BIP39</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">BIP39 Mnemonic Generator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Generate &amp; validate seed phrases in 10 languages</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/blockchain-sign.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#6366f1,#818cf8);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;color:#fff;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                </div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Blockchain Sign</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Sign &amp; verify Ethereum messages (EIP-191)</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/pgpencdec.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#34d399);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.9rem;color:#fff;font-weight:700;">PGP</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">PGP Encryption</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Encrypt, decrypt, sign with PGP keys</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/ecsignverify.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#10b981,#34d399);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.65rem;color:#fff;font-weight:700;">ECDSA</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">ECDSA Key &amp; Signature</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Elliptic curve key generation, sign &amp; verify</p>
                </div>
            </a>
        </div>
    </div>
</section>

<%@ include file="modern/components/support-section.jsp" %>

<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>

<!-- ethers.js v6 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/ethers/6.13.4/ethers.umd.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<!-- Solana web3.js -->
<script src="https://cdn.jsdelivr.net/npm/@solana/web3.js@1.95.3/lib/index.iife.min.js" crossorigin="anonymous"></script>

<!-- Noble/Scure libs for Bitcoin (ESM -> global) -->
<script type="module">
    import * as secp from 'https://cdn.jsdelivr.net/npm/@noble/secp256k1@2.1.0/+esm';
    import { sha256 } from 'https://cdn.jsdelivr.net/npm/@noble/hashes@1.6.1/sha256/+esm';
    import { ripemd160 } from 'https://cdn.jsdelivr.net/npm/@noble/hashes@1.6.1/ripemd160/+esm';
    import { bech32, bech32m, base58check as _b58c } from 'https://cdn.jsdelivr.net/npm/@scure/base@1.2.1/+esm';
    window.NobleBtc = { secp: secp, sha256: sha256, ripemd160: ripemd160, bech32: bech32, bech32m: bech32m, base58check: _b58c(sha256) };
    window.dispatchEvent(new Event('noble-ready'));
</script>

<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>

<script>
var EthFunctions = (function() {
    'use strict';

    var currentMode = 'address-gen';
    var currentGenChain = 'evm';
    var currentBtcNet = 'mainnet';
    var currentUnitChain = 'evm';
    var lastResult = null;
    var nobleReady = false;

    window.addEventListener('noble-ready', function() { nobleReady = true; });

    function $(id) { return document.getElementById(id); }

    function showToast(msg, type) {
        var t = document.createElement('div');
        t.className = 'mc-toast ' + type + ' show';
        t.textContent = msg;
        document.body.appendChild(t);
        setTimeout(function() { t.remove(); }, 3000);
    }

    function copyText(text, btn) {
        navigator.clipboard.writeText(text).then(function() {
            if (btn) {
                btn.classList.add('copied');
                var orig = btn.innerHTML;
                btn.innerHTML = '<svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> Copied';
                setTimeout(function() { btn.classList.remove('copied'); btn.innerHTML = orig; }, 1500);
            }
            showToast('Copied to clipboard', 'success');
        });
    }

    function escapeHtml(s) {
        var d = document.createElement('div');
        d.appendChild(document.createTextNode(String(s)));
        return d.innerHTML;
    }

    function copyBtnHtml(id) {
        return '<button type="button" class="mc-copy-btn" onclick="EthFunctions.copyById(\'' + id + '\',this)">' +
               '<svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>' +
               ' Copy</button>';
    }

    function copyById(id, btn) {
        var el = document.getElementById(id);
        if (el) copyText(el.textContent, btn);
    }

    function bytesToHex(bytes) {
        return Array.from(bytes).map(function(b) { return b.toString(16).padStart(2, '0'); }).join('');
    }

    function hexToBytes(hex) {
        hex = hex.replace(/^0x/, '');
        var bytes = new Uint8Array(hex.length / 2);
        for (var i = 0; i < bytes.length; i++) bytes[i] = parseInt(hex.substr(i * 2, 2), 16);
        return bytes;
    }

    // ==============================
    // MODE SWITCHING
    // ==============================
    function switchMode(mode) {
        currentMode = mode;
        var btns = document.querySelectorAll('.mc-mode-btn');
        for (var i = 0; i < btns.length; i++) {
            btns[i].classList.toggle('mc-active', btns[i].getAttribute('data-mode') === mode);
        }
        var panels = document.querySelectorAll('.mc-panel');
        for (var j = 0; j < panels.length; j++) {
            panels[j].classList.toggle('mc-panel-active', panels[j].id === 'mc-panel-' + mode);
        }
    }

    function selectGenChain(chain) {
        currentGenChain = chain;
        var pills = document.querySelectorAll('#mc-gen-chain .mc-chain-pill');
        for (var i = 0; i < pills.length; i++) pills[i].classList.toggle('mc-active', pills[i].getAttribute('data-chain') === chain);
        $('mc-gen-btc-net').style.display = chain === 'btc' ? '' : 'none';
    }

    function selectBtcNet(net) {
        currentBtcNet = net;
        var btns = document.querySelectorAll('.mc-net-toggle .mc-net-btn');
        for (var i = 0; i < btns.length; i++) btns[i].classList.toggle('mc-active', btns[i].getAttribute('data-net') === net);
    }

    function selectUnitChain(chain) {
        currentUnitChain = chain;
        var pills = document.querySelectorAll('#mc-unit-chain .mc-chain-pill');
        for (var i = 0; i < pills.length; i++) pills[i].classList.toggle('mc-active', pills[i].getAttribute('data-chain') === chain);
        $('mc-units-evm').style.display = chain === 'evm' ? '' : 'none';
        $('mc-units-btc').style.display = chain === 'btc' ? '' : 'none';
        $('mc-units-sol').style.display = chain === 'sol' ? '' : 'none';
    }

    function selectAbiMode(mode) {
        $('mc-abi-mode-encode').classList.toggle('mc-active', mode === 'encode');
        $('mc-abi-mode-decode').classList.toggle('mc-active', mode === 'decode');
        $('mc-abi-encode-panel').style.display = mode === 'encode' ? '' : 'none';
        $('mc-abi-decode-panel').style.display = mode === 'decode' ? '' : 'none';
    }

    // ==============================
    // ADDRESS GENERATOR
    // ==============================
    function generateAddress() {
        try {
            if (currentGenChain === 'evm') generateEvmAddress();
            else if (currentGenChain === 'btc') generateBtcAddress();
            else if (currentGenChain === 'sol') generateSolAddress();
            else if (currentGenChain === 'tron') generateTronAddress();
        } catch (e) {
            showToast('Error: ' + e.message, 'error');
        }
    }

    function generateEvmAddress() {
        var wallet = ethers.Wallet.createRandom();
        var privKey = wallet.privateKey;
        var pubKey = wallet.signingKey.publicKey;
        var address = wallet.address;

        displayGenResult('Ethereum / EVM', [
            { label: 'Private Key', value: privKey, id: 'mc-out-privkey', sensitive: true },
            { label: 'Public Key (uncompressed)', value: pubKey, id: 'mc-out-pubkey' },
            { label: 'Address (EIP-55 Checksum)', value: address, id: 'mc-out-addr', highlight: true },
            { label: 'Compatible Chains', value: 'ETH, Polygon, BSC, Arbitrum, Optimism, Avalanche, Base, etc.', id: 'mc-out-chains' }
        ], 'evm');
    }

    function generateBtcAddress() {
        if (!nobleReady || !window.NobleBtc) {
            showToast('Bitcoin libraries still loading, please wait...', 'error');
            return;
        }
        var nb = window.NobleBtc;
        var privKeyBytes = new Uint8Array(32);
        crypto.getRandomValues(privKeyBytes);
        var privKeyHex = bytesToHex(privKeyBytes);

        // Compressed public key
        var pubKeyBytes = nb.secp.getPublicKey(privKeyBytes, true);
        var pubKeyHex = bytesToHex(pubKeyBytes);

        // Hash160 = RIPEMD160(SHA256(pubkey))
        var hash160 = nb.ripemd160(nb.sha256(pubKeyBytes));

        // P2PKH
        var versionByte = currentBtcNet === 'mainnet' ? 0x00 : 0x6f;
        var versionedHash = new Uint8Array(21);
        versionedHash[0] = versionByte;
        versionedHash.set(hash160, 1);
        var p2pkh = nb.base58check.encode(versionedHash);

        // Bech32 P2WPKH (witness v0)
        var hrp = currentBtcNet === 'mainnet' ? 'bc' : 'tb';
        var words = nb.bech32.toWords(hash160);
        words.unshift(0); // witness version 0
        var bech32Addr = nb.bech32.encode(hrp, words);

        // Taproot P2TR (witness v1, x-only pubkey)
        var xOnlyPubKey = pubKeyBytes.slice(1); // drop the 0x02/0x03 prefix byte
        var trWords = nb.bech32m.toWords(xOnlyPubKey);
        trWords.unshift(1); // witness version 1
        var taprootAddr = nb.bech32m.encode(hrp, trWords);

        displayGenResult('Bitcoin (' + (currentBtcNet === 'mainnet' ? 'Mainnet' : 'Testnet') + ')', [
            { label: 'Private Key (hex)', value: privKeyHex, id: 'mc-out-privkey', sensitive: true },
            { label: 'Public Key (compressed)', value: pubKeyHex, id: 'mc-out-pubkey' },
            { label: 'P2PKH Address (Legacy)', value: p2pkh, id: 'mc-out-p2pkh', highlight: true },
            { label: 'P2WPKH Address (SegWit)', value: bech32Addr, id: 'mc-out-segwit', highlight: true },
            { label: 'P2TR Address (Taproot)', value: taprootAddr, id: 'mc-out-taproot', highlight: true }
        ], 'btc');
    }

    function generateSolAddress() {
        if (typeof solanaWeb3 === 'undefined') {
            showToast('Solana library still loading, please wait...', 'error');
            return;
        }
        var keypair = solanaWeb3.Keypair.generate();
        var pubKey = keypair.publicKey.toBase58();
        var secKey = bytesToHex(keypair.secretKey.slice(0, 32));

        displayGenResult('Solana', [
            { label: 'Private Key (first 32 bytes, hex)', value: secKey, id: 'mc-out-privkey', sensitive: true },
            { label: 'Public Key / Address (Base58)', value: pubKey, id: 'mc-out-addr', highlight: true }
        ], 'sol');
    }

    function generateTronAddress() {
        if (!nobleReady || !window.NobleBtc) {
            showToast('Libraries still loading, please wait...', 'error');
            return;
        }
        var wallet = ethers.Wallet.createRandom();
        var privKey = wallet.privateKey;
        var ethAddr = wallet.address; // 0x...

        // Tron: replace 0x prefix with 0x41 version byte
        var addrBytes = hexToBytes(ethAddr); // 20 bytes
        var versionedAddr = new Uint8Array(21);
        versionedAddr[0] = 0x41;
        versionedAddr.set(addrBytes, 1);

        // Double SHA-256 checksum
        var nb = window.NobleBtc;
        var hash1 = nb.sha256(versionedAddr);
        var hash2 = nb.sha256(hash1);
        var checksum = hash2.slice(0, 4);

        // Base58 encode (versioned + checksum)
        var fullAddr = new Uint8Array(25);
        fullAddr.set(versionedAddr, 0);
        fullAddr.set(checksum, 21);

        // Use base58check encode directly with the versioned addr
        var tronAddr = nb.base58check.encode(versionedAddr);

        displayGenResult('Tron', [
            { label: 'Private Key', value: privKey, id: 'mc-out-privkey', sensitive: true },
            { label: 'Ethereum Address (same keypair)', value: ethAddr, id: 'mc-out-ethaddr' },
            { label: 'Tron Address (Base58Check)', value: tronAddr, id: 'mc-out-addr', highlight: true }
        ], 'tron');
    }

    function displayGenResult(chainLabel, fields, chain) {
        var content = $('mc-result-content');
        $('mc-result-title').textContent = chainLabel + ' Address';

        var html = '<div style="margin-bottom:1rem;"><span class="mc-status mc-status-valid" style="font-size:0.75rem;">' + escapeHtml(chainLabel) + '</span></div>';
        for (var i = 0; i < fields.length; i++) {
            var f = fields[i];
            html += '<div class="mc-output-row">';
            html += '<div class="mc-output-label">' + escapeHtml(f.label) + ' ' + copyBtnHtml(f.id) + '</div>';
            if (f.sensitive) {
                html += '<div class="mc-output-value mc-pw-wrap" id="' + f.id + '-wrap">';
                html += '<span id="' + f.id + '" style="filter:blur(4px);transition:filter 0.2s;cursor:pointer;" onclick="this.style.filter=this.style.filter?\'\':\' blur(4px)\'" title="Click to toggle visibility">' + escapeHtml(f.value) + '</span>';
                html += '</div>';
            } else {
                html += '<div class="mc-output-value" id="' + f.id + '"' + (f.highlight ? ' style="color:var(--mc-tool);font-weight:500"' : '') + '>' + escapeHtml(f.value) + '</div>';
            }
            html += '</div>';
        }

        content.innerHTML = html;
        lastResult = { type: 'generate', chain: chain, chainLabel: chainLabel, fields: fields };
        showResultActions();
        showToast(chainLabel + ' address generated', 'success');
    }

    // ==============================
    // ADDRESS VALIDATOR
    // ==============================
    function validateAddress() {
        var addr = $('mc-validate-input').value.trim();
        if (!addr) { showToast('Please enter an address', 'error'); return; }

        var result = detectAndValidate(addr);
        var content = $('mc-result-content');
        $('mc-result-title').textContent = 'Validation Result';

        var statusHtml;
        if (result.valid) {
            statusHtml = '<div class="mc-status mc-status-valid"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> Valid Address</div>';
        } else {
            statusHtml = '<div class="mc-status mc-status-invalid"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg> Invalid Address</div>';
        }

        var html = '<div class="mc-output-row"><div class="mc-output-label">Status</div>' + statusHtml + '</div>';
        html += '<div class="mc-output-row"><div class="mc-output-label">Input ' + copyBtnHtml('mc-val-input') + '</div><div class="mc-output-value" id="mc-val-input" style="font-family:var(--font-mono)">' + escapeHtml(addr) + '</div></div>';
        html += '<div class="mc-output-row"><div class="mc-output-label">Detected Chain</div><div class="mc-output-value">' + escapeHtml(result.chain || 'Unknown') + '</div></div>';
        html += '<div class="mc-output-row"><div class="mc-output-label">Address Type</div><div class="mc-output-value">' + escapeHtml(result.type || 'Unknown') + '</div></div>';
        if (result.network) {
            html += '<div class="mc-output-row"><div class="mc-output-label">Network</div><div class="mc-output-value">' + escapeHtml(result.network) + '</div></div>';
        }
        if (result.checksummed) {
            html += '<div class="mc-output-row"><div class="mc-output-label">Checksummed Form ' + copyBtnHtml('mc-val-checksum') + '</div><div class="mc-output-value" id="mc-val-checksum" style="color:var(--mc-tool);font-weight:500">' + escapeHtml(result.checksummed) + '</div></div>';
        }
        if (result.details) {
            html += '<div class="mc-output-row"><div class="mc-output-label">Details</div><div class="mc-output-value">' + escapeHtml(result.details) + '</div></div>';
        }

        content.innerHTML = html;
        lastResult = { type: 'validate', address: addr, result: result };
        showResultActions();
        showToast(result.valid ? 'Valid ' + result.chain + ' address' : 'Invalid address', result.valid ? 'success' : 'error');
    }

    function detectAndValidate(addr) {
        // EVM: 0x + 40 hex
        if (/^0x[0-9a-fA-F]{40}$/.test(addr)) {
            var valid = ethers.isAddress(addr);
            var checksummed = '';
            try { checksummed = ethers.getAddress(addr); } catch(e) { /* ignore */ }
            var hasChecksum = addr !== addr.toLowerCase() && addr !== addr.toUpperCase();
            var checksumCorrect = hasChecksum ? (addr === checksummed) : true;
            return {
                valid: valid && checksumCorrect,
                chain: 'Ethereum / EVM',
                type: 'EOA or Contract Address',
                network: 'All EVM chains (ETH, Polygon, BSC, Arbitrum, etc.)',
                checksummed: checksummed,
                details: hasChecksum ? (checksumCorrect ? 'EIP-55 checksum verified' : 'EIP-55 checksum FAILED') : 'No mixed-case checksum (lowercase or uppercase)'
            };
        }

        // Bitcoin Bech32 / Bech32m
        if (/^(bc1|tb1)/i.test(addr)) {
            try {
                var nb = window.NobleBtc;
                if (!nb) return { valid: false, chain: 'Bitcoin', type: 'Bech32/Bech32m', details: 'Noble libraries not loaded' };
                var hrp = addr.toLowerCase().startsWith('bc1') ? 'bc' : 'tb';
                var network = hrp === 'bc' ? 'Mainnet' : 'Testnet';
                var decoded, witnessVer, addrType;
                // Try bech32 first (v0), then bech32m (v1+)
                try {
                    decoded = nb.bech32.decode(addr);
                    var words = nb.bech32.fromWords(decoded.words.slice(1));
                    witnessVer = decoded.words[0];
                    if (witnessVer === 0 && words.length === 20) {
                        addrType = 'P2WPKH (SegWit v0)';
                    } else if (witnessVer === 0 && words.length === 32) {
                        addrType = 'P2WSH (SegWit v0)';
                    } else {
                        addrType = 'SegWit v' + witnessVer;
                    }
                    return { valid: true, chain: 'Bitcoin', type: addrType, network: network };
                } catch(e1) {
                    try {
                        decoded = nb.bech32m.decode(addr);
                        witnessVer = decoded.words[0];
                        var trWords = nb.bech32m.fromWords(decoded.words.slice(1));
                        if (witnessVer === 1 && trWords.length === 32) {
                            addrType = 'P2TR (Taproot, SegWit v1)';
                        } else {
                            addrType = 'SegWit v' + witnessVer;
                        }
                        return { valid: true, chain: 'Bitcoin', type: addrType, network: network };
                    } catch(e2) {
                        return { valid: false, chain: 'Bitcoin', type: 'Bech32/Bech32m', details: 'Invalid checksum or encoding' };
                    }
                }
            } catch(e) {
                return { valid: false, chain: 'Bitcoin', type: 'Bech32', details: e.message };
            }
        }

        // Tron: starts with T, 34 chars
        if (/^T[1-9A-HJ-NP-Za-km-z]{33}$/.test(addr)) {
            try {
                var nb2 = window.NobleBtc;
                if (!nb2) return { valid: false, chain: 'Tron', type: 'Base58Check', details: 'Noble libraries not loaded' };
                var decoded2 = nb2.base58check.decode(addr);
                if (decoded2[0] === 0x41) {
                    return { valid: true, chain: 'Tron', type: 'Tron Address (TRC-20 compatible)', network: 'Tron Mainnet', details: 'Base58Check checksum verified, version byte 0x41' };
                }
                return { valid: false, chain: 'Tron', type: 'Base58Check', details: 'Unexpected version byte: 0x' + decoded2[0].toString(16) };
            } catch(e) {
                return { valid: false, chain: 'Tron', type: 'Base58Check', details: 'Checksum verification failed' };
            }
        }

        // Bitcoin P2PKH (starts with 1) or P2SH (starts with 3)
        if (/^[13][1-9A-HJ-NP-Za-km-z]{25,34}$/.test(addr)) {
            try {
                var nb3 = window.NobleBtc;
                if (!nb3) return { valid: false, chain: 'Bitcoin', type: 'Base58Check', details: 'Noble libraries not loaded' };
                var decoded3 = nb3.base58check.decode(addr);
                var ver = decoded3[0];
                var btcType, btcNet;
                if (ver === 0x00) { btcType = 'P2PKH (Pay-to-Public-Key-Hash)'; btcNet = 'Mainnet'; }
                else if (ver === 0x05) { btcType = 'P2SH (Pay-to-Script-Hash)'; btcNet = 'Mainnet'; }
                else if (ver === 0x6f) { btcType = 'P2PKH (Testnet)'; btcNet = 'Testnet'; }
                else if (ver === 0xc4) { btcType = 'P2SH (Testnet)'; btcNet = 'Testnet'; }
                else { btcType = 'Unknown (version 0x' + ver.toString(16) + ')'; btcNet = 'Unknown'; }
                return { valid: true, chain: 'Bitcoin', type: btcType, network: btcNet, details: 'Base58Check checksum verified' };
            } catch(e) {
                return { valid: false, chain: 'Bitcoin', type: 'Base58Check', details: 'Checksum verification failed' };
            }
        }

        // Solana: Base58, 32-44 chars, no special prefix
        if (/^[1-9A-HJ-NP-Za-km-z]{32,44}$/.test(addr)) {
            try {
                // Verify it's valid Base58 and decodes to 32 bytes
                var bytes = ethers.decodeBase58(addr);
                var hex = bytes.toString(16).padStart(64, '0');
                if (hex.length <= 64) {
                    return { valid: true, chain: 'Solana', type: 'Ed25519 Public Key', network: 'Solana Mainnet/Devnet', details: 'Valid 32-byte Base58-encoded public key' };
                }
                return { valid: false, chain: 'Solana (possible)', type: 'Base58', details: 'Decoded to ' + (hex.length / 2) + ' bytes, expected 32' };
            } catch(e) {
                return { valid: false, chain: 'Unknown', type: 'Unknown', details: 'Could not decode as Base58' };
            }
        }

        return { valid: false, chain: 'Unknown', type: 'Unknown', details: 'Address format not recognized. Supported: EVM (0x...), Bitcoin (1.../3.../bc1.../tb1...), Solana (Base58), Tron (T...)' };
    }

    // ==============================
    // UNIT CONVERTER
    // ==============================
    function convertEvm(from) {
        try {
            var val = $('mc-u-' + from).value.trim();
            if (!val || isNaN(val)) { clearEvmFields(from); return; }

            var weiVal;
            if (from === 'wei') weiVal = BigInt(val);
            else if (from === 'gwei') weiVal = ethers.parseUnits(val, 'gwei');
            else if (from === 'szabo') weiVal = ethers.parseUnits(val, 6);
            else if (from === 'finney') weiVal = ethers.parseUnits(val, 15);
            else if (from === 'eth') weiVal = ethers.parseUnits(val, 'ether');

            if (from !== 'wei') $('mc-u-wei').value = weiVal.toString();
            if (from !== 'gwei') $('mc-u-gwei').value = ethers.formatUnits(weiVal, 'gwei');
            if (from !== 'szabo') $('mc-u-szabo').value = ethers.formatUnits(weiVal, 6);
            if (from !== 'finney') $('mc-u-finney').value = ethers.formatUnits(weiVal, 15);
            if (from !== 'eth') $('mc-u-eth').value = ethers.formatUnits(weiVal, 'ether');
        } catch(e) { /* ignore parse errors while typing */ }
    }

    function clearEvmFields(except) {
        var fields = ['wei', 'gwei', 'szabo', 'finney', 'eth'];
        for (var i = 0; i < fields.length; i++) {
            if (fields[i] !== except) $('mc-u-' + fields[i]).value = '';
        }
    }

    function convertBtc(from) {
        try {
            var val = $('mc-u-' + from).value.trim();
            if (!val || isNaN(val)) { clearBtcFields(from); return; }

            // Work in satoshis (integer)
            var satVal;
            var v = parseFloat(val);
            if (from === 'sat') satVal = Math.round(v);
            else if (from === 'ubtc') satVal = Math.round(v * 100);
            else if (from === 'mbtc') satVal = Math.round(v * 100000);
            else if (from === 'btc') satVal = Math.round(v * 100000000);

            if (from !== 'sat') $('mc-u-sat').value = satVal;
            if (from !== 'ubtc') $('mc-u-ubtc').value = (satVal / 100).toFixed(2).replace(/\.?0+$/, '') || '0';
            if (from !== 'mbtc') $('mc-u-mbtc').value = (satVal / 100000).toFixed(5).replace(/\.?0+$/, '') || '0';
            if (from !== 'btc') $('mc-u-btc').value = (satVal / 100000000).toFixed(8).replace(/\.?0+$/, '') || '0';
        } catch(e) { /* ignore */ }
    }

    function clearBtcFields(except) {
        var fields = ['sat', 'ubtc', 'mbtc', 'btc'];
        for (var i = 0; i < fields.length; i++) {
            if (fields[i] !== except) $('mc-u-' + fields[i]).value = '';
        }
    }

    function convertSol(from) {
        try {
            var val = $('mc-u-' + from).value.trim();
            if (!val || isNaN(val)) { clearSolFields(from); return; }

            var v = parseFloat(val);
            if (from === 'lamport') {
                $('mc-u-sol').value = (v / 1000000000).toFixed(9).replace(/\.?0+$/, '') || '0';
            } else {
                $('mc-u-lamport').value = Math.round(v * 1000000000);
            }
        } catch(e) { /* ignore */ }
    }

    function clearSolFields(except) {
        if (except !== 'lamport') $('mc-u-lamport').value = '';
        if (except !== 'sol') $('mc-u-sol').value = '';
    }

    function presetUnit(chain, value, unit) {
        if (chain === 'evm') {
            $('mc-u-' + unit).value = value;
            convertEvm(unit);
        } else if (chain === 'btc') {
            $('mc-u-' + unit).value = value;
            convertBtc(unit);
        } else if (chain === 'sol') {
            $('mc-u-' + unit).value = value;
            convertSol(unit);
        }
    }

    // ==============================
    // ABI ENCODER / DECODER
    // ==============================
    function abiPreset(name) {
        if (name === 'transfer') {
            $('mc-abi-func').value = 'transfer(address,uint256)';
            $('mc-abi-params').value = '0x742d35Cc6634C0532925a3b844Bc9e7595f2bD18\n1000000000000000000';
        } else if (name === 'approve') {
            $('mc-abi-func').value = 'approve(address,uint256)';
            $('mc-abi-params').value = '0x742d35Cc6634C0532925a3b844Bc9e7595f2bD18\n115792089237316195423570985008687907853269984665640564039457584007913129639935';
        } else if (name === 'balanceOf') {
            $('mc-abi-func').value = 'balanceOf(address)';
            $('mc-abi-params').value = '0x742d35Cc6634C0532925a3b844Bc9e7595f2bD18';
        }
    }

    function parseFuncSig(sig) {
        sig = sig.trim();
        var m = sig.match(/^(\w+)\(([^)]*)\)$/);
        if (!m) throw new Error('Invalid function signature. Use format: functionName(type1,type2)');
        var name = m[1];
        var types = m[2] ? m[2].split(',').map(function(t) { return t.trim(); }) : [];
        return { name: name, types: types, full: name + '(' + types.join(',') + ')' };
    }

    function encodeAbi() {
        try {
            var funcSig = $('mc-abi-func').value.trim();
            var paramsText = $('mc-abi-params').value.trim();
            if (!funcSig) { showToast('Enter a function signature', 'error'); return; }

            var parsed = parseFuncSig(funcSig);
            var params = paramsText ? paramsText.split('\n').map(function(l) { return l.trim(); }).filter(function(l) { return l; }) : [];

            if (params.length !== parsed.types.length) {
                showToast('Expected ' + parsed.types.length + ' parameter(s), got ' + params.length, 'error');
                return;
            }

            // Parse values - convert numeric strings for uint/int types, normalize addresses
            var values = params.map(function(p, i) {
                var t = parsed.types[i];
                if (t === 'address') return ethers.getAddress(p.toLowerCase());
                if (/^u?int/.test(t) && /^\d+$/.test(p)) return BigInt(p);
                if (t === 'bool') return p === 'true' || p === '1';
                return p;
            });

            var selector = ethers.id(parsed.full).slice(0, 10);
            var abiCoder = ethers.AbiCoder.defaultAbiCoder();
            var encoded = abiCoder.encode(parsed.types, values);
            var calldata = selector + encoded.slice(2);

            var content = $('mc-result-content');
            $('mc-result-title').textContent = 'ABI Encode Result';

            content.innerHTML =
                '<div class="mc-output-row"><div class="mc-output-label">Function ' + copyBtnHtml('mc-abi-out-func') + '</div><div class="mc-output-value" id="mc-abi-out-func">' + escapeHtml(parsed.full) + '</div></div>' +
                '<div class="mc-output-row"><div class="mc-output-label">Selector (4 bytes) ' + copyBtnHtml('mc-abi-out-sel') + '</div><div class="mc-output-value" id="mc-abi-out-sel" style="color:var(--mc-tool);font-weight:500">' + escapeHtml(selector) + '</div></div>' +
                '<div class="mc-output-row"><div class="mc-output-label">Encoded Parameters ' + copyBtnHtml('mc-abi-out-params') + '</div><div class="mc-output-value" id="mc-abi-out-params" style="font-size:0.6875rem">' + escapeHtml(encoded) + '</div></div>' +
                '<div class="mc-output-row"><div class="mc-output-label">Full Calldata ' + copyBtnHtml('mc-abi-out-call') + '</div><div class="mc-output-value" id="mc-abi-out-call" style="font-size:0.6875rem;color:var(--mc-tool);font-weight:500">' + escapeHtml(calldata) + '</div></div>' +
                '<div class="mc-output-row"><div class="mc-output-label">Calldata Size</div><div class="mc-output-value">' + ((calldata.length - 2) / 2) + ' bytes</div></div>';

            lastResult = { type: 'abi-encode', func: parsed.full, selector: selector, encoded: encoded, calldata: calldata };
            showResultActions();
            showToast('ABI encoded successfully', 'success');
        } catch(e) {
            showToast('Encode error: ' + e.message, 'error');
        }
    }

    function decodeAbi() {
        try {
            var funcSig = $('mc-abi-decode-func').value.trim();
            var data = $('mc-abi-decode-data').value.trim();
            if (!funcSig) { showToast('Enter a function signature', 'error'); return; }
            if (!data) { showToast('Enter hex calldata', 'error'); return; }

            var parsed = parseFuncSig(funcSig);
            var expectedSelector = ethers.id(parsed.full).slice(0, 10);

            // Strip selector if present
            var paramData = data;
            if (data.length > 10 && data.slice(0, 10) === expectedSelector) {
                paramData = '0x' + data.slice(10);
            } else if (data.startsWith('0x') && data.length > 10) {
                paramData = '0x' + data.slice(10);
            }

            var abiCoder = ethers.AbiCoder.defaultAbiCoder();
            var decoded = abiCoder.decode(parsed.types, paramData);

            var content = $('mc-result-content');
            $('mc-result-title').textContent = 'ABI Decode Result';

            var html = '<div class="mc-output-row"><div class="mc-output-label">Function</div><div class="mc-output-value">' + escapeHtml(parsed.full) + '</div></div>';
            html += '<div class="mc-output-row"><div class="mc-output-label">Expected Selector</div><div class="mc-output-value" style="color:var(--mc-tool);font-weight:500">' + escapeHtml(expectedSelector) + '</div></div>';

            for (var i = 0; i < parsed.types.length; i++) {
                var paramId = 'mc-abi-dec-p' + i;
                html += '<div class="mc-output-row"><div class="mc-output-label">[' + i + '] ' + escapeHtml(parsed.types[i]) + ' ' + copyBtnHtml(paramId) + '</div><div class="mc-output-value" id="' + paramId + '">' + escapeHtml(decoded[i].toString()) + '</div></div>';
            }

            content.innerHTML = html;
            lastResult = { type: 'abi-decode', func: parsed.full, params: parsed.types.map(function(t, i) { return { type: t, value: decoded[i].toString() }; }) };
            showResultActions();
            showToast('ABI decoded successfully', 'success');
        } catch(e) {
            showToast('Decode error: ' + e.message, 'error');
        }
    }

    // ==============================
    // TRANSACTION DECODER
    // ==============================
    var TX_PRESETS = {
        legacy: '0xf86c0a8502540be400825208944bbeeb066ed09b7aed07bf39eee0460dfa261520880de0b6b3a76400008025a028ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa636276a067cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d83',
        eip1559: '0x02f8730180843b9aca00850a02ffee0082520894d8da6bf26964af9d7eed9e03e53415d37aa9604588016345785d8a000080c001a0e68dfaea84cd21e6b2771f8b08e66ef08483e36b75162aa8a0153027a1b2e6d8a0242b5a79af7cfe6a0bb3f782b1696d20afb399e17b0f3cf1be88d25e8c9873a8'
    };

    function txPreset(name) {
        var hex = TX_PRESETS[name];
        if (hex) $('mc-tx-input').value = hex;
    }

    function decodeTx() {
        try {
            var rawHex = $('mc-tx-input').value.trim();
            if (!rawHex) { showToast('Paste a raw transaction hex', 'error'); return; }
            if (!rawHex.startsWith('0x')) rawHex = '0x' + rawHex;

            var tx = ethers.Transaction.from(rawHex);

            var typeLabels = { 0: 'Legacy (Type 0)', 1: 'EIP-2930 (Type 1)', 2: 'EIP-1559 (Type 2)', 3: 'EIP-4844 (Type 3)' };
            var typeLabel = typeLabels[tx.type] || 'Type ' + tx.type;

            var valueWei = tx.value.toString();
            var valueEth = ethers.formatEther(tx.value);

            var content = $('mc-result-content');
            $('mc-result-title').textContent = 'Decoded Transaction';

            var html = '<div style="margin-bottom:1rem;"><span class="mc-status mc-status-valid" style="font-size:0.75rem;">' + escapeHtml(typeLabel) + '</span></div>';

            var fields = [];
            fields.push({ label: 'Transaction Type', value: typeLabel });
            if (tx.chainId !== undefined && tx.chainId !== null) fields.push({ label: 'Chain ID', value: tx.chainId.toString(), id: 'mc-tx-chainid' });
            fields.push({ label: 'Nonce', value: tx.nonce.toString(), id: 'mc-tx-nonce' });

            if (tx.from) fields.push({ label: 'From (recovered)', value: tx.from, id: 'mc-tx-from', highlight: true });
            fields.push({ label: 'To', value: tx.to || '(Contract Creation)', id: 'mc-tx-to', highlight: true });

            fields.push({ label: 'Value (Wei)', value: valueWei, id: 'mc-tx-value-wei' });
            fields.push({ label: 'Value (ETH)', value: valueEth + ' ETH', id: 'mc-tx-value-eth', highlight: true });

            fields.push({ label: 'Gas Limit', value: tx.gasLimit.toString(), id: 'mc-tx-gaslimit' });

            if (tx.type === 2 || tx.type === 1) {
                if (tx.maxPriorityFeePerGas !== null) fields.push({ label: 'Max Priority Fee (Wei)', value: tx.maxPriorityFeePerGas.toString(), id: 'mc-tx-maxpri' });
                if (tx.maxFeePerGas !== null) fields.push({ label: 'Max Fee Per Gas (Wei)', value: tx.maxFeePerGas.toString(), id: 'mc-tx-maxfee' });
            } else {
                if (tx.gasPrice !== null) fields.push({ label: 'Gas Price (Wei)', value: tx.gasPrice.toString(), id: 'mc-tx-gasprice' });
            }

            var dataHex = tx.data || '0x';
            fields.push({ label: 'Data', value: dataHex === '0x' ? '(empty)' : dataHex, id: 'mc-tx-data' });

            if (tx.accessList && tx.accessList.length > 0) {
                fields.push({ label: 'Access List', value: JSON.stringify(tx.accessList, null, 2), id: 'mc-tx-access' });
            }

            // Signature
            if (tx.signature) {
                fields.push({ label: 'Signature v', value: tx.signature.v.toString(), id: 'mc-tx-v' });
                fields.push({ label: 'Signature r', value: tx.signature.r, id: 'mc-tx-r' });
                fields.push({ label: 'Signature s', value: tx.signature.s, id: 'mc-tx-s' });
            }

            for (var i = 0; i < fields.length; i++) {
                var f = fields[i];
                var fid = f.id || ('mc-tx-f' + i);
                html += '<div class="mc-output-row">';
                html += '<div class="mc-output-label">' + escapeHtml(f.label) + (f.id ? ' ' + copyBtnHtml(fid) : '') + '</div>';
                var valStyle = f.highlight ? ' style="color:var(--mc-tool);font-weight:500"' : '';
                if (f.label === 'Data' && dataHex !== '0x' && dataHex.length >= 10) {
                    html += '<div class="mc-output-value" id="' + fid + '" style="font-size:0.6875rem;word-break:break-all">' + escapeHtml(f.value) + '</div>';
                    var selector = dataHex.slice(0, 10);
                    html += '<div style="margin-top:0.375rem;font-size:0.6875rem;color:var(--text-muted);">Selector: <code style="background:var(--bg-secondary);padding:0.125rem 0.375rem;border-radius:0.25rem">' + escapeHtml(selector) + '</code> &mdash; <a href="#" onclick="EthFunctions.switchMode(\'abi-codec\');EthFunctions.selectAbiMode(\'decode\');document.getElementById(\'mc-abi-decode-data\').value=\'' + escapeHtml(dataHex) + '\';return false;" style="color:var(--mc-tool);">Decode with ABI tab</a></div>';
                } else {
                    html += '<div class="mc-output-value" id="' + fid + '"' + valStyle + '>' + escapeHtml(f.value) + '</div>';
                }
                html += '</div>';
            }

            content.innerHTML = html;
            lastResult = { type: 'tx-decode', txType: typeLabel, from: tx.from, to: tx.to, value: valueEth, nonce: tx.nonce.toString() };
            showResultActions();
            showToast('Transaction decoded successfully', 'success');
        } catch(e) {
            showToast('Decode error: ' + e.message, 'error');
        }
    }

    // ==============================
    // RPC CLIENT
    // ==============================
    var RPC_PRESETS = {
        'eth-mainnet': { url: 'https://eth.llamarpc.com',          name: 'Ethereum Mainnet' },
        'sepolia':     { url: 'https://rpc.sepolia.org',           name: 'Sepolia Testnet' },
        'polygon':     { url: 'https://polygon-rpc.com',           name: 'Polygon PoS' },
        'arbitrum':    { url: 'https://arb1.arbitrum.io/rpc',      name: 'Arbitrum One' },
        'base':        { url: 'https://mainnet.base.org',          name: 'Base' },
        'bsc':         { url: 'https://bsc-dataseed1.binance.org', name: 'BNB Smart Chain' }
    };

    var SOLANA_RPC_PRESETS = {
        'solana-mainnet': { url: 'https://api.mainnet-beta.solana.com', name: 'Solana Mainnet' },
        'solana-devnet':  { url: 'https://api.devnet.solana.com',       name: 'Solana Devnet' }
    };

    var WELL_KNOWN_ADDRESSES = {
        vitalik:  '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045',
        usdt:     '0xdAC17F958D2ee523a2206206994597C13D831ec7',
        uniswap:  '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D'
    };

    var SOLANA_WELL_KNOWN = {
        system: '11111111111111111111111111111111',
        token:  'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA',
        wsol:   'So11111111111111111111111111111111111111112'
    };

    var ERC20_READ_ABI = [
        'function name() view returns (string)',
        'function symbol() view returns (string)',
        'function decimals() view returns (uint8)',
        'function totalSupply() view returns (uint256)',
        'function balanceOf(address owner) view returns (uint256)'
    ];

    var ERC721_READ_ABI = [
        'function name() view returns (string)',
        'function symbol() view returns (string)',
        'function totalSupply() view returns (uint256)',
        'function balanceOf(address owner) view returns (uint256)',
        'function ownerOf(uint256 tokenId) view returns (address)',
        'function tokenURI(uint256 tokenId) view returns (string)'
    ];

    var RPC_METHOD_PARAMS = {
        eth_blockNumber: [],
        eth_chainId: [],
        eth_gasPrice: [],
        eth_getBalance: [{ id: 'mc-rpc-p-addr', label: 'Address', placeholder: '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045' }],
        eth_getCode: [{ id: 'mc-rpc-p-addr', label: 'Address', placeholder: '0xdAC17F958D2ee523a2206206994597C13D831ec7' }],
        eth_getTransactionByHash: [{ id: 'mc-rpc-p-hash', label: 'Transaction Hash', placeholder: '0x...' }],
        eth_getTransactionReceipt: [{ id: 'mc-rpc-p-hash', label: 'Transaction Hash', placeholder: '0x...' }],
        eth_getBlockByNumber: [{ id: 'mc-rpc-p-block', label: 'Block Number or Tag', placeholder: 'latest' }],
        eth_call: [
            { id: 'mc-rpc-p-to', label: 'To Address', placeholder: '0xdAC17F958D2ee523a2206206994597C13D831ec7' },
            { id: 'mc-rpc-p-data', label: 'Calldata (hex)', placeholder: '0x06fdde03' }
        ]
    };

    var SOLANA_METHOD_PARAMS = {
        getSlot: [],
        getBlockHeight: [],
        getBalance: [{ id: 'mc-rpc-p-addr', label: 'Address (Base58)', placeholder: 'So11111111111111111111111111111111111111112' }],
        getAccountInfo: [{ id: 'mc-rpc-p-addr', label: 'Address (Base58)', placeholder: 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA' }],
        getTransaction: [{ id: 'mc-rpc-p-sig', label: 'Transaction Signature', placeholder: '5wHu1qwD7q...' }],
        getLatestBlockhash: [],
        getMinimumBalanceForRentExemption: [{ id: 'mc-rpc-p-size', label: 'Data Size (bytes)', placeholder: '0' }]
    };

    var currentRpcChain = 'evm';
    var solanaConnection = null;
    var solanaConnectionUrl = null;
    var currentRpcPreset = null;
    var currentRpcSub = 'query';
    var rpcProvider = null;
    var rpcProviderUrl = null;
    var parsedContractAbi = null;
    var parsedContractFuncs = [];
    var abiInputTimer = null;

    function selectRpcPreset(key) {
        currentRpcPreset = key;
        var pills = document.querySelectorAll('#mc-rpc-presets .mc-chain-pill');
        for (var i = 0; i < pills.length; i++) pills[i].classList.toggle('mc-active', pills[i].getAttribute('data-rpc') === key);

        // Detect chain type
        var wasSolana = currentRpcChain === 'solana';
        var isSolana = key.indexOf('solana-') === 0;
        currentRpcChain = isSolana ? 'solana' : 'evm';

        // Fill URL from preset
        if (key !== 'custom') {
            var preset = isSolana ? SOLANA_RPC_PRESETS[key] : RPC_PRESETS[key];
            if (preset) $('mc-rpc-url').value = preset.url;
        }

        // Reset provider caches
        rpcProvider = null;
        rpcProviderUrl = null;
        solanaConnection = null;
        solanaConnectionUrl = null;
        updateRpcStatus('off', 'Not connected');

        // Repopulate method dropdown if chain type changed
        if (wasSolana !== isSolana) {
            populateMethodDropdown();
        }

        // Show/hide Contract + Broadcast sub-tabs for Solana
        $('mc-rpc-sub-contract').style.display = isSolana ? 'none' : '';
        $('mc-rpc-sub-broadcast').style.display = isSolana ? 'none' : '';
        if (isSolana && currentRpcSub !== 'query') {
            selectRpcSub('query');
        }
    }

    function populateMethodDropdown() {
        var sel = $('mc-rpc-method');
        sel.innerHTML = '';
        if (currentRpcChain === 'solana') {
            var solMethods = Object.keys(SOLANA_METHOD_PARAMS);
            for (var i = 0; i < solMethods.length; i++) {
                var o = document.createElement('option');
                o.value = solMethods[i];
                o.textContent = solMethods[i];
                sel.appendChild(o);
            }
        } else {
            var evmMethods = Object.keys(RPC_METHOD_PARAMS);
            for (var j = 0; j < evmMethods.length; j++) {
                var o2 = document.createElement('option');
                o2.value = evmMethods[j];
                o2.textContent = evmMethods[j];
                sel.appendChild(o2);
            }
        }
        rpcMethodChanged();
    }

    function selectRpcSub(sub) {
        currentRpcSub = sub;
        $('mc-rpc-sub-query').classList.toggle('mc-active', sub === 'query');
        $('mc-rpc-sub-contract').classList.toggle('mc-active', sub === 'contract');
        $('mc-rpc-sub-broadcast').classList.toggle('mc-active', sub === 'broadcast');
        $('mc-rpc-query-panel').style.display = sub === 'query' ? '' : 'none';
        $('mc-rpc-contract-panel').style.display = sub === 'contract' ? '' : 'none';
        $('mc-rpc-broadcast-panel').style.display = sub === 'broadcast' ? '' : 'none';
    }

    function getOrCreateProvider() {
        var url = $('mc-rpc-url').value.trim();
        if (!url) throw new Error('Enter an RPC endpoint URL');
        if (rpcProvider && rpcProviderUrl === url) return rpcProvider;
        rpcProvider = new ethers.JsonRpcProvider(url);
        rpcProviderUrl = url;
        return rpcProvider;
    }

    function updateRpcStatus(state, text) {
        var dot = $('mc-rpc-dot');
        var txt = $('mc-rpc-status-text');
        dot.className = 'mc-rpc-dot ' + state;
        txt.textContent = text;
    }

    function rpcMethodChanged() {
        var method = $('mc-rpc-method').value;
        var paramsMap = currentRpcChain === 'solana' ? SOLANA_METHOD_PARAMS : RPC_METHOD_PARAMS;
        var params = paramsMap[method] || [];
        var container = $('mc-rpc-params');
        var html = '';
        for (var i = 0; i < params.length; i++) {
            var p = params[i];
            html += '<div class="tool-form-group"><label class="tool-form-label">' + escapeHtml(p.label) + '</label>';
            html += '<input type="text" class="tool-form-input" id="' + p.id + '" placeholder="' + escapeHtml(p.placeholder) + '" spellcheck="false" style="font-family:var(--font-mono)"></div>';
        }
        container.innerHTML = html;

        if (currentRpcChain === 'solana') {
            var solNeedsAddr = method === 'getBalance' || method === 'getAccountInfo';
            $('mc-rpc-quickfill').style.display = 'none';
            $('mc-rpc-quickfill-sol').style.display = solNeedsAddr ? '' : 'none';
        } else {
            var needsAddr = method === 'eth_getBalance' || method === 'eth_getCode' || method === 'eth_call';
            $('mc-rpc-quickfill').style.display = needsAddr ? '' : 'none';
            $('mc-rpc-quickfill-sol').style.display = 'none';
        }
    }

    function rpcQuickFill(name) {
        var addrMap = currentRpcChain === 'solana' ? SOLANA_WELL_KNOWN : WELL_KNOWN_ADDRESSES;
        var addr = addrMap[name];
        if (!addr) return;
        var addrField = $('mc-rpc-p-addr') || $('mc-rpc-p-to');
        if (addrField) addrField.value = addr;
    }

    function getOrCreateSolanaConnection() {
        var url = $('mc-rpc-url').value.trim();
        if (!url) throw new Error('Enter an RPC endpoint URL');
        if (solanaConnection && solanaConnectionUrl === url) return solanaConnection;
        solanaConnection = new solanaWeb3.Connection(url);
        solanaConnectionUrl = url;
        return solanaConnection;
    }

    async function executeSolanaRpc() {
        var method = $('mc-rpc-method').value;
        try {
            updateRpcStatus('connecting', 'Connecting...');
            var conn = getOrCreateSolanaConnection();
            var title = '', fields = [];

            if (method === 'getSlot') {
                var slot = await conn.getSlot();
                title = 'Current Slot';
                fields = [{ label: 'Slot', value: slot.toString() }];
            } else if (method === 'getBlockHeight') {
                var height = await conn.getBlockHeight();
                title = 'Block Height';
                fields = [{ label: 'Block Height', value: height.toString() }];
            } else if (method === 'getBalance') {
                var addr = ($('mc-rpc-p-addr') || {}).value || '';
                if (!addr.trim()) { showToast('Enter an address', 'error'); updateRpcStatus('off', 'Not connected'); return; }
                var pubkey = new solanaWeb3.PublicKey(addr.trim());
                var lamports = await conn.getBalance(pubkey);
                title = 'Balance';
                fields = [
                    { label: 'Address', value: addr.trim() },
                    { label: 'Balance (Lamports)', value: lamports.toString() },
                    { label: 'Balance (SOL)', value: (lamports / 1e9).toFixed(9) + ' SOL' }
                ];
            } else if (method === 'getAccountInfo') {
                var acctAddr = ($('mc-rpc-p-addr') || {}).value || '';
                if (!acctAddr.trim()) { showToast('Enter an address', 'error'); updateRpcStatus('off', 'Not connected'); return; }
                var acctKey = new solanaWeb3.PublicKey(acctAddr.trim());
                var info = await conn.getAccountInfo(acctKey);
                title = 'Account Info';
                if (!info) {
                    fields = [{ label: 'Address', value: acctAddr.trim() }, { label: 'Status', value: 'Account not found or has no data' }];
                } else {
                    fields = [
                        { label: 'Address', value: acctAddr.trim() },
                        { label: 'Owner', value: info.owner.toBase58() },
                        { label: 'Lamports', value: info.lamports.toString() },
                        { label: 'Balance (SOL)', value: (info.lamports / 1e9).toFixed(9) + ' SOL' },
                        { label: 'Data Size', value: info.data.length + ' bytes' },
                        { label: 'Executable', value: info.executable ? 'Yes' : 'No' },
                        { label: 'Rent Epoch', value: info.rentEpoch !== undefined ? info.rentEpoch.toString() : 'N/A' }
                    ];
                }
            } else if (method === 'getTransaction') {
                var sig = ($('mc-rpc-p-sig') || {}).value || '';
                if (!sig.trim()) { showToast('Enter a transaction signature', 'error'); updateRpcStatus('off', 'Not connected'); return; }
                var tx = await conn.getTransaction(sig.trim(), { maxSupportedTransactionVersion: 0 });
                title = 'Transaction';
                if (!tx) {
                    fields = [{ label: 'Signature', value: sig.trim() }, { label: 'Status', value: 'Transaction not found' }];
                } else {
                    fields = [
                        { label: 'Signature', value: sig.trim() },
                        { label: 'Slot', value: tx.slot.toString() },
                        { label: 'Fee (Lamports)', value: tx.meta ? tx.meta.fee.toString() : 'N/A' },
                        { label: 'Status', value: tx.meta && tx.meta.err ? 'Failed: ' + JSON.stringify(tx.meta.err) : 'Success' }
                    ];
                    if (tx.transaction && tx.transaction.message) {
                        var signers = tx.transaction.message.staticAccountKeys || tx.transaction.message.accountKeys || [];
                        if (signers.length > 0) {
                            fields.push({ label: 'Fee Payer', value: signers[0].toBase58 ? signers[0].toBase58() : signers[0].toString() });
                        }
                    }
                    if (tx.meta && tx.meta.logMessages && tx.meta.logMessages.length > 0) {
                        fields.push({ label: 'Log Messages', value: tx.meta.logMessages.join('\n') });
                    }
                }
            } else if (method === 'getLatestBlockhash') {
                var bh = await conn.getLatestBlockhash();
                title = 'Latest Blockhash';
                fields = [
                    { label: 'Blockhash', value: bh.blockhash },
                    { label: 'Last Valid Block Height', value: bh.lastValidBlockHeight.toString() }
                ];
            } else if (method === 'getMinimumBalanceForRentExemption') {
                var sizeStr = ($('mc-rpc-p-size') || {}).value || '0';
                var dataSize = parseInt(sizeStr.trim()) || 0;
                var rentLamports = await conn.getMinimumBalanceForRentExemption(dataSize);
                title = 'Minimum Balance for Rent Exemption';
                fields = [
                    { label: 'Data Size', value: dataSize + ' bytes' },
                    { label: 'Minimum Balance (Lamports)', value: rentLamports.toString() },
                    { label: 'Minimum Balance (SOL)', value: (rentLamports / 1e9).toFixed(9) + ' SOL' }
                ];
            }

            updateRpcStatus('ok', 'Connected');
            formatRpcResult(title, fields);
            showToast('Solana RPC call successful', 'success');
        } catch (e) {
            updateRpcStatus('err', 'Error');
            solanaConnection = null;
            solanaConnectionUrl = null;
            showToast('Solana RPC error: ' + e.message, 'error');
        }
    }

    async function executeRpc() {
        if (currentRpcChain === 'solana') { return executeSolanaRpc(); }
        var method = $('mc-rpc-method').value;
        try {
            updateRpcStatus('connecting', 'Connecting...');
            var provider = getOrCreateProvider();

            var title = '', fields = [];

            if (method === 'eth_blockNumber') {
                var bn = await provider.getBlockNumber();
                title = 'Block Number';
                fields = [{ label: 'Block Number', value: bn.toString() }, { label: 'Hex', value: '0x' + bn.toString(16) }];
            } else if (method === 'eth_chainId') {
                var net = await provider.getNetwork();
                title = 'Chain ID';
                fields = [{ label: 'Chain ID', value: net.chainId.toString() }, { label: 'Network Name', value: net.name || 'unknown' }];
            } else if (method === 'eth_gasPrice') {
                var fee = await provider.getFeeData();
                title = 'Gas Price / Fee Data';
                fields = [];
                if (fee.gasPrice !== null && fee.gasPrice !== undefined) {
                    fields.push({ label: 'Gas Price (Wei)', value: fee.gasPrice.toString() });
                    fields.push({ label: 'Gas Price (Gwei)', value: ethers.formatUnits(fee.gasPrice, 'gwei') });
                }
                if (fee.maxFeePerGas !== null && fee.maxFeePerGas !== undefined) {
                    fields.push({ label: 'Max Fee Per Gas (Gwei)', value: ethers.formatUnits(fee.maxFeePerGas, 'gwei') });
                }
                if (fee.maxPriorityFeePerGas !== null && fee.maxPriorityFeePerGas !== undefined) {
                    fields.push({ label: 'Max Priority Fee (Gwei)', value: ethers.formatUnits(fee.maxPriorityFeePerGas, 'gwei') });
                }
            } else if (method === 'eth_getBalance') {
                var addr = ($('mc-rpc-p-addr') || {}).value || '';
                if (!addr.trim()) { showToast('Enter an address', 'error'); updateRpcStatus('off', 'Not connected'); return; }
                var bal = await provider.getBalance(addr.trim());
                title = 'Balance';
                fields = [
                    { label: 'Address', value: addr.trim() },
                    { label: 'Balance (Wei)', value: bal.toString() },
                    { label: 'Balance (ETH)', value: ethers.formatEther(bal) + ' ETH' }
                ];
            } else if (method === 'eth_getCode') {
                var cAddr = ($('mc-rpc-p-addr') || {}).value || '';
                if (!cAddr.trim()) { showToast('Enter an address', 'error'); updateRpcStatus('off', 'Not connected'); return; }
                var code = await provider.getCode(cAddr.trim());
                var isContract = code && code !== '0x';
                title = 'Contract Code';
                fields = [
                    { label: 'Address', value: cAddr.trim() },
                    { label: 'Is Contract', value: isContract ? 'Yes' : 'No (EOA)' },
                    { label: 'Bytecode Size', value: isContract ? ((code.length - 2) / 2) + ' bytes' : '0 bytes' },
                    { label: 'Bytecode', value: code }
                ];
            } else if (method === 'eth_getTransactionByHash') {
                var txHash = ($('mc-rpc-p-hash') || {}).value || '';
                if (!txHash.trim()) { showToast('Enter a transaction hash', 'error'); updateRpcStatus('off', 'Not connected'); return; }
                var tx = await provider.getTransaction(txHash.trim());
                if (!tx) { showToast('Transaction not found', 'error'); updateRpcStatus('ok', 'Connected'); return; }
                title = 'Transaction';
                fields = [
                    { label: 'Hash', value: tx.hash },
                    { label: 'From', value: tx.from },
                    { label: 'To', value: tx.to || '(Contract Creation)' },
                    { label: 'Value (ETH)', value: ethers.formatEther(tx.value) },
                    { label: 'Nonce', value: tx.nonce.toString() },
                    { label: 'Gas Limit', value: tx.gasLimit.toString() },
                    { label: 'Block Number', value: tx.blockNumber !== null ? tx.blockNumber.toString() : 'Pending' },
                    { label: 'Data', value: tx.data || '0x' }
                ];
            } else if (method === 'eth_getTransactionReceipt') {
                var rHash = ($('mc-rpc-p-hash') || {}).value || '';
                if (!rHash.trim()) { showToast('Enter a transaction hash', 'error'); updateRpcStatus('off', 'Not connected'); return; }
                var receipt = await provider.getTransactionReceipt(rHash.trim());
                if (!receipt) { showToast('Receipt not found (tx may be pending)', 'error'); updateRpcStatus('ok', 'Connected'); return; }
                title = 'Transaction Receipt';
                fields = [
                    { label: 'Status', value: receipt.status === 1 ? 'Success' : 'Failed (reverted)' },
                    { label: 'Block Number', value: receipt.blockNumber.toString() },
                    { label: 'Gas Used', value: receipt.gasUsed.toString() },
                    { label: 'Cumulative Gas', value: receipt.cumulativeGasUsed.toString() },
                    { label: 'Logs Count', value: receipt.logs.length.toString() },
                    { label: 'Contract Address', value: receipt.contractAddress || '(none)' }
                ];
            } else if (method === 'eth_getBlockByNumber') {
                var blockTag = ($('mc-rpc-p-block') || {}).value || 'latest';
                blockTag = blockTag.trim();
                var blockParam = blockTag;
                if (/^\d+$/.test(blockTag)) blockParam = parseInt(blockTag);
                var block = await provider.getBlock(blockParam);
                if (!block) { showToast('Block not found', 'error'); updateRpcStatus('ok', 'Connected'); return; }
                title = 'Block #' + block.number;
                fields = [
                    { label: 'Number', value: block.number.toString() },
                    { label: 'Hash', value: block.hash },
                    { label: 'Timestamp', value: block.timestamp + ' (' + new Date(block.timestamp * 1000).toISOString() + ')' },
                    { label: 'Transactions', value: block.transactions.length.toString() },
                    { label: 'Gas Used', value: block.gasUsed.toString() },
                    { label: 'Gas Limit', value: block.gasLimit.toString() },
                    { label: 'Base Fee (Gwei)', value: block.baseFeePerGas ? ethers.formatUnits(block.baseFeePerGas, 'gwei') : 'N/A' },
                    { label: 'Miner', value: block.miner }
                ];
            } else if (method === 'eth_call') {
                var toAddr = ($('mc-rpc-p-to') || {}).value || '';
                var callData = ($('mc-rpc-p-data') || {}).value || '';
                if (!toAddr.trim()) { showToast('Enter a to address', 'error'); updateRpcStatus('off', 'Not connected'); return; }
                var result = await provider.call({ to: toAddr.trim(), data: callData.trim() || '0x' });
                title = 'eth_call Result';
                fields = [
                    { label: 'To', value: toAddr.trim() },
                    { label: 'Data Sent', value: callData.trim() || '0x' },
                    { label: 'Result (hex)', value: result }
                ];
            }

            updateRpcStatus('ok', 'Connected');
            formatRpcResult(title, fields);
            showToast('RPC call successful', 'success');
        } catch (e) {
            updateRpcStatus('err', 'Error');
            rpcProvider = null;
            rpcProviderUrl = null;
            showToast('RPC error: ' + e.message, 'error');
        }
    }

    function formatRpcResult(title, fields) {
        var content = $('mc-result-content');
        $('mc-result-title').textContent = title;

        var html = '<div style="margin-bottom:1rem;"><span class="mc-status mc-status-valid" style="font-size:0.75rem;">' + escapeHtml(title) + '</span></div>';
        for (var i = 0; i < fields.length; i++) {
            var f = fields[i];
            var fid = 'mc-rpc-out-' + i;
            html += '<div class="mc-output-row">';
            html += '<div class="mc-output-label">' + escapeHtml(f.label) + ' ' + copyBtnHtml(fid) + '</div>';
            var val = String(f.value);
            var longVal = val.length > 100;
            html += '<div class="mc-output-value" id="' + fid + '"' + (longVal ? ' style="font-size:0.6875rem;word-break:break-all"' : '') + '>' + escapeHtml(val) + '</div>';
            html += '</div>';
        }

        content.innerHTML = html;
        lastResult = { type: 'rpc-query', title: title, data: fields.map(function(f) { return { label: f.label, value: String(f.value) }; }) };
        showResultActions();
    }

    function rpcAbiPreset(name) {
        var abi;
        if (name === 'erc20') abi = ERC20_READ_ABI;
        else if (name === 'erc721') abi = ERC721_READ_ABI;
        else return;
        $('mc-rpc-abi').value = JSON.stringify(abi, null, 2);
        parseContractAbi();
    }

    function parseContractAbi() {
        try {
            var raw = $('mc-rpc-abi').value.trim();
            if (!raw) { $('mc-rpc-func-group').style.display = 'none'; parsedContractAbi = null; parsedContractFuncs = []; return; }
            var iface = new ethers.Interface(JSON.parse(raw));
            parsedContractAbi = iface;
            parsedContractFuncs = [];

            iface.forEachFunction(function(func) {
                if (func.stateMutability === 'view' || func.stateMutability === 'pure') {
                    parsedContractFuncs.push(func);
                }
            });

            if (parsedContractFuncs.length === 0) {
                $('mc-rpc-func-group').style.display = 'none';
                showToast('No view/pure functions found in ABI', 'error');
                return;
            }

            var sel = $('mc-rpc-func-select');
            sel.innerHTML = '';
            for (var i = 0; i < parsedContractFuncs.length; i++) {
                var fn = parsedContractFuncs[i];
                var opt = document.createElement('option');
                opt.value = i;
                opt.textContent = fn.name + '(' + fn.inputs.map(function(inp) { return inp.type; }).join(', ') + ')';
                sel.appendChild(opt);
            }
            $('mc-rpc-func-group').style.display = '';
            rpcAbiFuncChanged();
        } catch (e) {
            $('mc-rpc-func-group').style.display = 'none';
            parsedContractAbi = null;
            parsedContractFuncs = [];
        }
    }

    function onAbiInput() {
        if (abiInputTimer) clearTimeout(abiInputTimer);
        abiInputTimer = setTimeout(parseContractAbi, 500);
    }

    function rpcAbiFuncChanged() {
        var idx = parseInt($('mc-rpc-func-select').value);
        var func = parsedContractFuncs[idx];
        if (!func) { $('mc-rpc-func-params').innerHTML = ''; return; }

        var html = '';
        for (var i = 0; i < func.inputs.length; i++) {
            var inp = func.inputs[i];
            html += '<div class="tool-form-group"><label class="tool-form-label">' + escapeHtml(inp.name || 'param' + i) + ' (' + escapeHtml(inp.type) + ')</label>';
            html += '<input type="text" class="tool-form-input mc-rpc-func-input" placeholder="' + escapeHtml(inp.type) + '" spellcheck="false" style="font-family:var(--font-mono)"></div>';
        }
        $('mc-rpc-func-params').innerHTML = html;
    }

    async function executeContractRead() {
        try {
            var contractAddr = $('mc-rpc-contract-addr').value.trim();
            if (!contractAddr) { showToast('Enter a contract address', 'error'); return; }
            if (!parsedContractAbi || parsedContractFuncs.length === 0) { showToast('Parse an ABI first', 'error'); return; }

            var idx = parseInt($('mc-rpc-func-select').value);
            var func = parsedContractFuncs[idx];
            if (!func) { showToast('Select a function', 'error'); return; }

            var paramInputs = document.querySelectorAll('#mc-rpc-func-params .mc-rpc-func-input');
            var args = [];
            for (var i = 0; i < paramInputs.length; i++) {
                var val = paramInputs[i].value.trim();
                args.push(val);
            }

            updateRpcStatus('connecting', 'Calling...');
            var provider = getOrCreateProvider();
            var contract = new ethers.Contract(contractAddr, parsedContractAbi, provider);

            var result = await contract[func.name].apply(contract, args);
            updateRpcStatus('ok', 'Connected');

            var fields = [
                { label: 'Contract', value: contractAddr },
                { label: 'Function', value: func.name + '(' + func.inputs.map(function(inp) { return inp.type; }).join(', ') + ')' }
            ];

            // Handle tuple/array results
            if (func.outputs.length === 1) {
                fields.push({ label: 'Result (' + func.outputs[0].type + ')', value: result.toString() });
            } else {
                for (var j = 0; j < func.outputs.length; j++) {
                    var outName = func.outputs[j].name || 'output' + j;
                    fields.push({ label: outName + ' (' + func.outputs[j].type + ')', value: result[j].toString() });
                }
            }

            formatRpcResult('Contract Read: ' + func.name, fields);
            lastResult.type = 'rpc-contract';
            showToast('Contract call successful', 'success');
        } catch (e) {
            updateRpcStatus('err', 'Error');
            rpcProvider = null;
            rpcProviderUrl = null;
            showToast('Contract call error: ' + e.message, 'error');
        }
    }

    async function broadcastTx() {
        try {
            var rawTx = $('mc-rpc-rawtx').value.trim();
            if (!rawTx) { showToast('Enter signed transaction hex', 'error'); return; }
            if (!rawTx.startsWith('0x')) rawTx = '0x' + rawTx;

            updateRpcStatus('connecting', 'Broadcasting...');
            var provider = getOrCreateProvider();
            var txResp = await provider.broadcastTransaction(rawTx);
            updateRpcStatus('ok', 'Connected');

            var fields = [
                { label: 'Transaction Hash', value: txResp.hash },
                { label: 'Status', value: 'Broadcast successful - awaiting confirmation' }
            ];

            formatRpcResult('Transaction Broadcast', fields);
            lastResult.type = 'rpc-broadcast';
            showToast('Transaction broadcast successfully!', 'success');
        } catch (e) {
            updateRpcStatus('err', 'Error');
            rpcProvider = null;
            rpcProviderUrl = null;
            showToast('Broadcast error: ' + e.message, 'error');
        }
    }

    // Initialize RPC param fields on first load
    setTimeout(function() { rpcMethodChanged(); }, 0);

    // ==============================
    // SHARED: DOWNLOAD, SHARE, FAQ
    // ==============================
    function showResultActions() {
        $('mc-download-btn').style.display = '';
        $('mc-share-btn').style.display = '';
    }

    function shareResultUrl() {
        if (!lastResult) { showToast('No result to share', 'error'); return; }
        var shareData = JSON.stringify(lastResult);
        if (window.ToolUtils && ToolUtils.shareResult) {
            ToolUtils.shareResult(shareData, { paramName: 'data', toolName: 'Multi-Chain Blockchain Tools' });
        } else {
            var encoded = btoa(unescape(encodeURIComponent(shareData)));
            var url = window.location.origin + window.location.pathname + '?data=' + encoded + '&enc=base64';
            navigator.clipboard.writeText(url);
            showToast('Share URL copied to clipboard!', 'success');
        }
    }

    function downloadResult() {
        if (!lastResult) { showToast('No result to download', 'error'); return; }
        var lines = ['Multi-Chain Blockchain Tools - ' + (lastResult.type || 'Result')];
        lines.push('Generated: ' + new Date().toISOString());
        lines.push('Tool: https://8gwifi.org/ethfunctions.jsp');
        lines.push('');

        if (lastResult.type === 'generate' && lastResult.fields) {
            lines.push('Chain: ' + lastResult.chainLabel);
            for (var i = 0; i < lastResult.fields.length; i++) {
                lines.push(lastResult.fields[i].label + ': ' + lastResult.fields[i].value);
            }
        } else if (lastResult.type === 'validate') {
            lines.push('Address: ' + lastResult.address);
            lines.push('Valid: ' + lastResult.result.valid);
            lines.push('Chain: ' + (lastResult.result.chain || 'Unknown'));
            lines.push('Type: ' + (lastResult.result.type || 'Unknown'));
        } else if (lastResult.type === 'abi-encode') {
            lines.push('Function: ' + lastResult.func);
            lines.push('Selector: ' + lastResult.selector);
            lines.push('Calldata: ' + lastResult.calldata);
        } else if (lastResult.type === 'abi-decode') {
            lines.push('Function: ' + lastResult.func);
            for (var j = 0; j < lastResult.params.length; j++) {
                lines.push('[' + j + '] ' + lastResult.params[j].type + ': ' + lastResult.params[j].value);
            }
        } else if (lastResult.type === 'tx-decode') {
            lines.push('Type: ' + lastResult.txType);
            lines.push('From: ' + (lastResult.from || 'N/A'));
            lines.push('To: ' + (lastResult.to || 'Contract Creation'));
            lines.push('Value: ' + lastResult.value + ' ETH');
            lines.push('Nonce: ' + lastResult.nonce);
        } else if (lastResult.type && lastResult.type.startsWith('rpc-')) {
            if (lastResult.data) {
                for (var k = 0; k < lastResult.data.length; k++) {
                    lines.push(lastResult.data[k].label + ': ' + lastResult.data[k].value);
                }
            }
        }

        var text = lines.join('\n');
        var filename = 'blockchain-tools-' + lastResult.type + '-' + Date.now() + '.txt';
        if (window.ToolUtils && ToolUtils.downloadAsFile) {
            ToolUtils.downloadAsFile(text, filename, { toolName: 'Multi-Chain Blockchain Tools' });
        } else {
            var blob = new Blob([text], { type: 'text/plain' });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url; a.download = filename; a.click();
            setTimeout(function() { URL.revokeObjectURL(url); }, 100);
            showToast('Downloaded ' + filename, 'success');
        }
    }

    function toggleFaq(btn) {
        var item = btn.parentElement;
        item.classList.toggle('open');
    }

    return {
        switchMode: switchMode,
        selectGenChain: selectGenChain,
        selectBtcNet: selectBtcNet,
        selectUnitChain: selectUnitChain,
        selectAbiMode: selectAbiMode,
        generateAddress: generateAddress,
        validateAddress: validateAddress,
        convertEvm: convertEvm,
        convertBtc: convertBtc,
        convertSol: convertSol,
        presetUnit: presetUnit,
        encodeAbi: encodeAbi,
        decodeAbi: decodeAbi,
        abiPreset: abiPreset,
        decodeTx: decodeTx,
        txPreset: txPreset,
        downloadResult: downloadResult,
        shareResultUrl: shareResultUrl,
        toggleFaq: toggleFaq,
        copyById: copyById,
        selectRpcPreset: selectRpcPreset,
        selectRpcSub: selectRpcSub,
        rpcMethodChanged: rpcMethodChanged,
        rpcQuickFill: rpcQuickFill,
        executeRpc: executeRpc,
        rpcAbiPreset: rpcAbiPreset,
        rpcAbiFuncChanged: rpcAbiFuncChanged,
        executeContractRead: executeContractRead,
        broadcastTx: broadcastTx,
        onAbiInput: onAbiInput,
        executeSolanaRpc: executeSolanaRpc
    };
})();

// Scroll animations
(function(){
    var els = document.querySelectorAll('.mc-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        for (var i = 0; i < els.length; i++) els[i].classList.add('mc-visible');
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        for (var j = 0; j < entries.length; j++) {
            if (entries[j].isIntersecting) {
                entries[j].target.classList.add('mc-visible');
                obs.unobserve(entries[j].target);
            }
        }
    }, { threshold: 0.15 });
    for (var k = 0; k < els.length; k++) obs.observe(els[k]);
})();
</script>

</body>
</html>
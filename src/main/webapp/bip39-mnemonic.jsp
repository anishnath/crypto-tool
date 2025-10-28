
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>BIP39 Mnemonic Generator & Validator - Seed Phrase Generator | 8gwifi.org</title>

    <meta name="description" content="Free BIP39 mnemonic generator and validator tool. Generate secure 12, 15, 18, 21, or 24-word seed phrases for cryptocurrency wallets. Validate existing mnemonics and derive seeds with optional passphrases.">
    <meta name="keywords" content="BIP39 mnemonic generator, seed phrase generator, mnemonic validator, BIP39 tool, cryptocurrency seed phrase, bitcoin mnemonic, 12 word seed phrase, 24 word seed phrase, mnemonic phrase generator, crypto wallet seed, BIP39 validator, seed phrase validator, mnemonic to seed, BIP39 passphrase, HD wallet seed, deterministic wallet, mnemonic words, crypto recovery phrase, wallet backup phrase, BIP39 online tool, generate mnemonic, validate mnemonic, seed phrase tool, BIP39 derivation, mnemonic entropy, seed phrase security, cryptocurrency recovery, wallet seed generator, BIP39 standard, mnemonic checksum">

    <meta property="og:title" content="BIP39 Mnemonic Generator & Validator - Seed Phrase Generator">
    <meta property="og:description" content="Generate and validate BIP39 mnemonic seed phrases for cryptocurrency wallets. Supports 12-24 word phrases with passphrase protection.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/bip39-mnemonic.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="BIP39 Mnemonic Generator & Validator">
    <meta name="twitter:description" content="Free tool to generate and validate BIP39 mnemonic seed phrases for cryptocurrency wallets.">

    <link rel="canonical" href="https://8gwifi.org/bip39-mnemonic.jsp">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "BIP39 Mnemonic Generator",
        "description": "Free online tool to generate and validate BIP39 mnemonic seed phrases for cryptocurrency wallets. Supports 12, 15, 18, 21, and 24-word mnemonics with optional passphrase protection and seed derivation.",
        "url": "https://8gwifi.org/bip39-mnemonic.jsp",
        "applicationCategory": "SecurityApplication",
        "operatingSystem": "Web Browser",
        "permissions": "No installation required",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "Generate BIP39 mnemonic phrases (12/15/18/21/24 words)",
            "Validate existing mnemonic phrases",
            "Mnemonic checksum verification",
            "Seed derivation with optional passphrase",
            "Multiple language support (English)",
            "Entropy visualization",
            "Binary and hex representation",
            "Privacy-focused (client-side only)",
            "No data storage or logging",
            "Copy to clipboard functionality",
            "Secure random number generation",
            "BIP39 standard compliance",
            "HD wallet compatible seeds",
            "Recovery phrase backup"
        ],
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.9",
            "ratingCount": "1247",
            "bestRating": "5",
            "worstRating": "1"
        }
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [{
            "@type": "ListItem",
            "position": 1,
            "name": "Home",
            "item": "https://8gwifi.org"
        },{
            "@type": "ListItem",
            "position": 2,
            "name": "Blockchain Tools",
            "item": "https://8gwifi.org/bip39-mnemonic.jsp"
        },{
            "@type": "ListItem",
            "position": 3,
            "name": "BIP39 Mnemonic Generator"
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "What is a BIP39 mnemonic phrase?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A BIP39 mnemonic phrase (also called a seed phrase or recovery phrase) is a human-readable representation of a wallet's seed. It consists of 12, 15, 18, 21, or 24 words from a standardized wordlist of 2048 words. This phrase can be used to recover your cryptocurrency wallet and all derived private keys."
            }
        },{
            "@type": "Question",
            "name": "How secure is a 12-word vs 24-word mnemonic?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A 12-word mnemonic provides 128 bits of entropy (security), which is considered secure for most use cases. A 24-word mnemonic provides 256 bits of entropy, offering maximum security. Both are cryptographically strong, but 24 words provides exponentially more combinations and is recommended for high-value wallets."
            }
        },{
            "@type": "Question",
            "name": "What is a BIP39 passphrase?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A BIP39 passphrase (also called the 25th word) is an optional additional security layer. It's combined with the mnemonic to derive the seed. Even if someone gets your mnemonic, they cannot access your funds without the passphrase. However, if you forget the passphrase, your funds are permanently lost."
            }
        },{
            "@type": "Question",
            "name": "Is it safe to generate mnemonics online?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "This tool runs entirely in your browser using cryptographically secure random number generation. No data is sent to any server. However, for maximum security with real funds, always use an offline (air-gapped) computer or a hardware wallet to generate production mnemonics."
            }
        },{
            "@type": "Question",
            "name": "Can I use this mnemonic with any wallet?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes, BIP39 is a widely adopted standard supported by most modern cryptocurrency wallets including Ledger, Trezor, MetaMask, Exodus, Trust Wallet, and many others. A mnemonic generated here can be imported into any BIP39-compatible wallet."
            }
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Generate a BIP39 Mnemonic",
        "description": "Step-by-step guide to generating a secure BIP39 mnemonic seed phrase",
        "step": [{
            "@type": "HowToStep",
            "position": 1,
            "name": "Select Mnemonic Length",
            "text": "Choose the number of words for your mnemonic (12, 15, 18, 21, or 24 words). More words = more security."
        },{
            "@type": "HowToStep",
            "position": 2,
            "name": "Generate Mnemonic",
            "text": "Click 'Generate Mnemonic' to create a random BIP39-compliant seed phrase using secure randomness"
        },{
            "@type": "HowToStep",
            "position": 3,
            "name": "Add Passphrase (Optional)",
            "text": "Optionally add a passphrase for extra security. This creates a completely different wallet even with the same mnemonic."
        },{
            "@type": "HowToStep",
            "position": 4,
            "name": "Backup Securely",
            "text": "Write down the mnemonic on paper and store it in a secure location. Never store it digitally or share it with anyone."
        },{
            "@type": "HowToStep",
            "position": 5,
            "name": "Import to Wallet",
            "text": "Import the mnemonic into your cryptocurrency wallet to access your funds"
        }]
    }
    </script>

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 1rem 0;
        }
        .main-container {
            max-width: 900px;
            margin: 0 auto;
        }
        .tool-header {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .tool-header h1 {
            color: #667eea;
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .tool-header p {
            color: #6c757d;
            margin-bottom: 0;
            font-size: 0.9rem;
        }
        .control-panel {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-group label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        .form-control, .form-control-plaintext {
            border-radius: 6px;
            border: 2px solid #e9ecef;
            padding: 0.6rem;
            font-size: 0.9rem;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            border-radius: 6px;
            transition: transform 0.2s;
            font-size: 0.9rem;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            border-radius: 6px;
            font-size: 0.9rem;
        }
        .mnemonic-display {
            background: #f8f9fa;
            border: 2px solid #667eea;
            border-radius: 8px;
            padding: 1rem;
            min-height: 120px;
            font-family: 'Courier New', monospace;
            font-size: 1rem;
            line-height: 1.8;
            word-spacing: 0.5rem;
        }
        .mnemonic-word {
            display: inline-block;
            background: white;
            padding: 0.25rem 0.5rem;
            margin: 0.25rem;
            border-radius: 4px;
            border: 1px solid #dee2e6;
        }
        .info-panel {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .info-panel h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .info-item {
            margin-bottom: 0.75rem;
            padding: 0.5rem;
            background: #f8f9fa;
            border-radius: 6px;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            font-size: 0.9rem;
        }
        .info-value {
            font-family: 'Courier New', monospace;
            color: #212529;
            word-break: break-all;
            font-size: 0.85rem;
        }
        .alert {
            border-radius: 6px;
            padding: 0.75rem;
            font-size: 0.9rem;
        }
        .collapse-toggle {
            color: #667eea;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            display: inline-block;
        }
        .collapse-toggle:hover {
            color: #764ba2;
            text-decoration: none;
        }
        .related-tools {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .related-tools h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }
        .related-tools a {
            color: #667eea;
            text-decoration: none;
            margin-right: 1rem;
            font-size: 0.9rem;
        }
        .related-tools a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        .info-section {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .info-section h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }
        .info-section p {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
        }
        .info-section ul {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
            padding-left: 1.25rem;
        }
        .copy-btn {
            cursor: pointer;
            color: #667eea;
            margin-left: 0.5rem;
        }
        .copy-btn:hover {
            color: #764ba2;
        }
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<div class="main-container">
    <div class="tool-header">
        <h1><i class="fas fa-key"></i> BIP39 Mnemonic Generator & Validator</h1>
        <p>Generate and validate BIP39 mnemonic seed phrases for cryptocurrency wallets. Supports 12-24 word phrases.</p>
    </div>

    <div class="alert alert-warning">
        <i class="fas fa-exclamation-triangle"></i> <strong>Security Warning:</strong> This tool is for educational purposes. For real cryptocurrency wallets, generate mnemonics offline on an air-gapped computer or use a hardware wallet. Never share your mnemonic with anyone!
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-cog"></i> Generate Mnemonic</h3>

        <div class="form-group">
            <label for="mnemonicLength"><i class="fas fa-list-ol"></i> Mnemonic Length</label>
            <select class="form-control" id="mnemonicLength">
                <option value="12">12 words (128 bits)</option>
                <option value="15">15 words (160 bits)</option>
                <option value="18">18 words (192 bits)</option>
                <option value="21">21 words (224 bits)</option>
                <option value="24">24 words (256 bits)</option>
            </select>
        </div>

        <button class="btn btn-primary btn-block" onclick="generateMnemonic()">
            <i class="fas fa-random"></i> Generate Mnemonic
        </button>
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-comment-dots"></i> Mnemonic Phrase <i class="fas fa-copy copy-btn" onclick="copyMnemonic()" title="Copy to clipboard"></i></h3>
        <div id="mnemonicDisplay" class="mnemonic-display">
            Click "Generate Mnemonic" to create a new seed phrase
        </div>
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-check-circle"></i> Validate & Derive Seed</h3>

        <div class="form-group">
            <label for="mnemonicInput"><i class="fas fa-keyboard"></i> Enter Mnemonic to Validate</label>
            <textarea class="form-control" id="mnemonicInput" rows="3" placeholder="Enter mnemonic words separated by spaces"></textarea>
        </div>

        <div class="form-group">
            <label for="passphraseInput"><i class="fas fa-lock"></i> Passphrase (Optional)</label>
            <input type="password" class="form-control" id="passphraseInput" placeholder="Optional BIP39 passphrase (25th word)">
            <small class="form-text text-muted">Leave empty if not using a passphrase</small>
        </div>

        <button class="btn btn-primary btn-block" onclick="validateAndDerive()">
            <i class="fas fa-check"></i> Validate & Derive Seed
        </button>
    </div>

    <div id="resultsContainer" style="display: none;">
        <div class="info-panel">
            <h3><i class="fas fa-info-circle"></i> Mnemonic Details</h3>
            <div id="mnemonicDetails"></div>
        </div>

        <div class="info-panel">
            <h3><i class="fas fa-seedling"></i> Derived Seed <i class="fas fa-copy copy-btn" onclick="copySeed()" title="Copy seed to clipboard"></i></h3>
            <div id="seedDetails"></div>
        </div>
    </div>

    <div class="info-section">
        <a class="collapse-toggle" data-toggle="collapse" href="#howItWorksCollapse">
            <i class="fas fa-question-circle"></i> What is BIP39?
        </a>
        <div class="collapse" id="howItWorksCollapse">
            <p><strong>BIP39 (Bitcoin Improvement Proposal 39)</strong> is a standard for generating mnemonic phrases that represent cryptographic keys. It provides a human-readable way to backup and restore cryptocurrency wallets.</p>

            <p><strong>How it works:</strong></p>
            <ul>
                <li><strong>Entropy:</strong> Random data (128-256 bits) is generated using a cryptographically secure random number generator</li>
                <li><strong>Checksum:</strong> A checksum is calculated from the entropy and appended to ensure data integrity</li>
                <li><strong>Word Mapping:</strong> The combined data is split into 11-bit segments, each mapped to a word from the BIP39 wordlist (2048 words)</li>
                <li><strong>Seed Derivation:</strong> The mnemonic + passphrase are processed through PBKDF2 to derive a 512-bit seed</li>
                <li><strong>Key Derivation:</strong> The seed is used with BIP32/BIP44 to generate hierarchical deterministic (HD) wallet keys</li>
            </ul>

            <p><strong>Security Levels:</strong></p>
            <ul>
                <li><strong>12 words:</strong> 128 bits of entropy = 2^128 combinations (340 undecillion)</li>
                <li><strong>24 words:</strong> 256 bits of entropy = 2^256 combinations (more than atoms in universe)</li>
            </ul>

            <p><strong>Important Notes:</strong></p>
            <ul>
                <li>Anyone with your mnemonic can access your funds - keep it secret!</li>
                <li>Write it down on paper and store in a secure location (safe, safety deposit box)</li>
                <li>Never store mnemonics digitally (no photos, no cloud storage, no email)</li>
                <li>The passphrase is optional but provides an additional security layer</li>
                <li>BIP39 is supported by most modern cryptocurrency wallets</li>
            </ul>
        </div>
    </div>

    <div class="related-tools">
        <h3><i class="fas fa-tools"></i> Related Tools</h3>
        <a href="blockchain-sign.jsp"><i class="fas fa-signature"></i> Blockchain Sign</a>
        <a href="ethfunctions.jsp"><i class="fab fa-ethereum"></i> Ethereum Tools</a>
        <a href="pgpencdec.jsp"><i class="fas fa-lock"></i> PGP Encryption</a>
        <a href="rsafunctions.jsp"><i class="fas fa-key"></i> RSA Tools</a>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>

<script>
// BIP39 English wordlist (2048 words)
const BIP39_WORDLIST = ["abandon","ability","able","about","above","absent","absorb","abstract","absurd","abuse","access","accident","account","accuse","achieve","acid","acoustic","acquire","across","act","action","actor","actress","actual","adapt","add","addict","address","adjust","admit","adult","advance","advice","aerobic","affair","afford","afraid","again","age","agent","agree","ahead","aim","air","airport","aisle","alarm","album","alcohol","alert","alien","all","alley","allow","almost","alone","alpha","already","also","alter","always","amateur","amazing","among","amount","amused","analyst","anchor","ancient","anger","angle","angry","animal","ankle","announce","annual","another","answer","antenna","antique","anxiety","any","apart","apology","appear","apple","approve","april","arch","arctic","area","arena","argue","arm","armed","armor","army","around","arrange","arrest","arrive","arrow","art","artefact","artist","artwork","ask","aspect","assault","asset","assist","assume","asthma","athlete","atom","attack","attend","attitude","attract","auction","audit","august","aunt","author","auto","autumn","average","avocado","avoid","awake","aware","away","awesome","awful","awkward","axis","baby","bachelor","bacon","badge","bag","balance","balcony","ball","bamboo","banana","banner","bar","barely","bargain","barrel","base","basic","basket","battle","beach","bean","beauty","because","become","beef","before","begin","behave","behind","believe","below","belt","bench","benefit","best","betray","better","between","beyond","bicycle","bid","bike","bind","biology","bird","birth","bitter","black","blade","blame","blanket","blast","bleak","bless","blind","blood","blossom","blouse","blue","blur","blush","board","boat","body","boil","bomb","bone","bonus","book","boost","border","boring","borrow","boss","bottom","bounce","box","boy","bracket","brain","brand","brass","brave","bread","breeze","brick","bridge","brief","bright","bring","brisk","broccoli","broken","bronze","broom","brother","brown","brush","bubble","buddy","budget","buffalo","build","bulb","bulk","bullet","bundle","bunker","burden","burger","burst","bus","business","busy","butter","buyer","buzz","cabbage","cabin","cable","cactus","cage","cake","call","calm","camera","camp","can","canal","cancel","candy","cannon","canoe","canvas","canyon","capable","capital","captain","car","carbon","card","cargo","carpet","carry","cart","case","cash","casino","castle","casual","cat","catalog","catch","category","cattle","caught","cause","caution","cave","ceiling","celery","cement","census","century","cereal","certain","chair","chalk","champion","change","chaos","chapter","charge","chase","chat","cheap","check","cheese","chef","cherry","chest","chicken","chief","child","chimney","choice","choose","chronic","chuckle","chunk","churn","cigar","cinnamon","circle","citizen","city","civil","claim","clap","clarify","claw","clay","clean","clerk","clever","click","client","cliff","climb","clinic","clip","clock","clog","close","cloth","cloud","clown","club","clump","cluster","clutch","coach","coast","coconut","code","coffee","coil","coin","collect","color","column","combine","come","comfort","comic","common","company","concert","conduct","confirm","congress","connect","consider","control","convince","cook","cool","copper","copy","coral","core","corn","correct","cost","cotton","couch","country","couple","course","cousin","cover","coyote","crack","cradle","craft","cram","crane","crash","crater","crawl","crazy","cream","credit","creek","crew","cricket","crime","crisp","critic","crop","cross","crouch","crowd","crucial","cruel","cruise","crumble","crunch","crush","cry","crystal","cube","culture","cup","cupboard","curious","current","curtain","curve","cushion","custom","cute","cycle","dad","damage","damp","dance","danger","daring","dash","daughter","dawn","day","deal","debate","debris","decade","december","decide","decline","decorate","decrease","deer","defense","define","defy","degree","delay","deliver","demand","demise","denial","dentist","deny","depart","depend","deposit","depth","deputy","derive","describe","desert","design","desk","despair","destroy","detail","detect","develop","device","devote","diagram","dial","diamond","diary","dice","diesel","diet","differ","digital","dignity","dilemma","dinner","dinosaur","direct","dirt","disagree","discover","disease","dish","dismiss","disorder","display","distance","divert","divide","divorce","dizzy","doctor","document","dog","doll","dolphin","domain","donate","donkey","donor","door","dose","double","dove","draft","dragon","drama","drastic","draw","dream","dress","drift","drill","drink","drip","drive","drop","drum","dry","duck","dumb","dune","during","dust","dutch","duty","dwarf","dynamic","eager","eagle","early","earn","earth","easily","east","easy","echo","ecology","economy","edge","edit","educate","effort","egg","eight","either","elbow","elder","electric","elegant","element","elephant","elevator","elite","else","embark","embody","embrace","emerge","emotion","employ","empower","empty","enable","enact","end","endless","endorse","enemy","energy","enforce","engage","engine","enhance","enjoy","enlist","enough","enrich","enroll","ensure","enter","entire","entry","envelope","episode","equal","equip","era","erase","erode","erosion","error","erupt","escape","essay","essence","estate","eternal","ethics","evidence","evil","evoke","evolve","exact","example","excess","exchange","excite","exclude","excuse","execute","exercise","exhaust","exhibit","exile","exist","exit","exotic","expand","expect","expire","explain","expose","express","extend","extra","eye","eyebrow","fabric","face","faculty","fade","faint","faith","fall","false","fame","family","famous","fan","fancy","fantasy","farm","fashion","fat","fatal","father","fatigue","fault","favorite","feature","february","federal","fee","feed","feel","female","fence","festival","fetch","fever","few","fiber","fiction","field","figure","file","film","filter","final","find","fine","finger","finish","fire","firm","first","fiscal","fish","fit","fitness","fix","flag","flame","flash","flat","flavor","flee","flight","flip","float","flock","floor","flower","fluid","flush","fly","foam","focus","fog","foil","fold","follow","food","foot","force","forest","forget","fork","fortune","forum","forward","fossil","foster","found","fox","fragile","frame","frequent","fresh","friend","fringe","frog","front","frost","frown","frozen","fruit","fuel","fun","funny","furnace","fury","future","gadget","gain","galaxy","gallery","game","gap","garage","garbage","garden","garlic","garment","gas","gasp","gate","gather","gauge","gaze","general","genius","genre","gentle","genuine","gesture","ghost","giant","gift","giggle","ginger","giraffe","girl","give","glad","glance","glare","glass","glide","glimpse","globe","gloom","glory","glove","glow","glue","goat","goddess","gold","good","goose","gorilla","gospel","gossip","govern","gown","grab","grace","grain","grant","grape","grass","gravity","great","green","grid","grief","grit","grocery","group","grow","grunt","guard","guess","guide","guilt","guitar","gun","gym","habit","hair","half","hammer","hamster","hand","happy","harbor","hard","harsh","harvest","hat","have","hawk","hazard","head","health","heart","heavy","hedgehog","height","hello","helmet","help","hen","hero","hidden","high","hill","hint","hip","hire","history","hobby","hockey","hold","hole","holiday","hollow","home","honey","hood","hope","horn","horror","horse","hospital","host","hotel","hour","hover","hub","huge","human","humble","humor","hundred","hungry","hunt","hurdle","hurry","hurt","husband","hybrid","ice","icon","idea","identify","idle","ignore","ill","illegal","illness","image","imitate","immense","immune","impact","impose","improve","impulse","inch","include","income","increase","index","indicate","indoor","industry","infant","inflict","inform","inhale","inherit","initial","inject","injury","inmate","inner","innocent","input","inquiry","insane","insect","inside","inspire","install","intact","interest","into","invest","invite","involve","iron","island","isolate","issue","item","ivory","jacket","jaguar","jar","jazz","jealous","jeans","jelly","jewel","job","join","joke","journey","joy","judge","juice","jump","jungle","junior","junk","just","kangaroo","keen","keep","ketchup","key","kick","kid","kidney","kind","kingdom","kiss","kit","kitchen","kite","kitten","kiwi","knee","knife","knock","know","lab","label","labor","ladder","lady","lake","lamp","language","laptop","large","later","latin","laugh","laundry","lava","law","lawn","lawsuit","layer","lazy","leader","leaf","learn","leave","lecture","left","leg","legal","legend","leisure","lemon","lend","length","lens","leopard","lesson","letter","level","liar","liberty","library","license","life","lift","light","like","limb","limit","link","lion","liquid","list","little","live","lizard","load","loan","lobster","local","lock","logic","lonely","long","loop","lottery","loud","lounge","love","loyal","lucky","luggage","lumber","lunar","lunch","luxury","lyrics","machine","mad","magic","magnet","maid","mail","main","major","make","mammal","man","manage","mandate","mango","mansion","manual","maple","marble","march","margin","marine","market","marriage","mask","mass","master","match","material","math","matrix","matter","maximum","maze","meadow","mean","measure","meat","mechanic","medal","media","melody","melt","member","memory","mention","menu","mercy","merge","merit","merry","mesh","message","metal","method","middle","midnight","milk","million","mimic","mind","minimum","minor","minute","miracle","mirror","misery","miss","mistake","mix","mixed","mixture","mobile","model","modify","mom","moment","monitor","monkey","monster","month","moon","moral","more","morning","mosquito","mother","motion","motor","mountain","mouse","move","movie","much","muffin","mule","multiply","muscle","museum","mushroom","music","must","mutual","myself","mystery","myth","naive","name","napkin","narrow","nasty","nation","nature","near","neck","need","negative","neglect","neither","nephew","nerve","nest","net","network","neutral","never","news","next","nice","night","noble","noise","nominee","noodle","normal","north","nose","notable","note","nothing","notice","novel","now","nuclear","number","nurse","nut","oak","obey","object","oblige","obscure","observe","obtain","obvious","occur","ocean","october","odor","off","offer","office","often","oil","okay","old","olive","olympic","omit","once","one","onion","online","only","open","opera","opinion","oppose","option","orange","orbit","orchard","order","ordinary","organ","orient","original","orphan","ostrich","other","outdoor","outer","output","outside","oval","oven","over","own","owner","oxygen","oyster","ozone","pact","paddle","page","pair","palace","palm","panda","panel","panic","panther","paper","parade","parent","park","parrot","party","pass","patch","path","patient","patrol","pattern","pause","pave","payment","peace","peanut","pear","peasant","pelican","pen","penalty","pencil","people","pepper","perfect","permit","person","pet","phone","photo","phrase","physical","piano","picnic","picture","piece","pig","pigeon","pill","pilot","pink","pioneer","pipe","pistol","pitch","pizza","place","planet","plastic","plate","play","please","pledge","pluck","plug","plunge","poem","poet","point","polar","pole","police","pond","pony","pool","popular","portion","position","possible","post","potato","pottery","poverty","powder","power","practice","praise","predict","prefer","prepare","present","pretty","prevent","price","pride","primary","print","priority","prison","private","prize","problem","process","produce","profit","program","project","promote","proof","property","prosper","protect","proud","provide","public","pudding","pull","pulp","pulse","pumpkin","punch","pupil","puppy","purchase","purity","purpose","purse","push","put","puzzle","pyramid","quality","quantum","quarter","question","quick","quit","quiz","quote","rabbit","raccoon","race","rack","radar","radio","rail","rain","raise","rally","ramp","ranch","random","range","rapid","rare","rate","rather","raven","raw","razor","ready","real","reason","rebel","rebuild","recall","receive","recipe","record","recycle","reduce","reflect","reform","refuse","region","regret","regular","reject","relax","release","relief","rely","remain","remember","remind","remove","render","renew","rent","reopen","repair","repeat","replace","report","require","rescue","resemble","resist","resource","response","result","retire","retreat","return","reunion","reveal","review","reward","rhythm","rib","ribbon","rice","rich","ride","ridge","rifle","right","rigid","ring","riot","ripple","risk","ritual","rival","river","road","roast","robot","robust","rocket","romance","roof","rookie","room","rose","rotate","rough","round","route","royal","rubber","rude","rug","rule","run","runway","rural","sad","saddle","sadness","safe","sail","salad","salmon","salon","salt","salute","same","sample","sand","satisfy","satoshi","sauce","sausage","save","say","scale","scan","scare","scatter","scene","scheme","school","science","scissors","scorpion","scout","scrap","screen","script","scrub","sea","search","season","seat","second","secret","section","security","seed","seek","segment","select","sell","seminar","senior","sense","sentence","series","service","session","settle","setup","seven","shadow","shaft","shallow","share","shed","shell","sheriff","shield","shift","shine","ship","shiver","shock","shoe","shoot","shop","short","shoulder","shove","shrimp","shrug","shuffle","shy","sibling","sick","side","siege","sight","sign","silent","silk","silly","silver","similar","simple","since","sing","siren","sister","situate","six","size","skate","sketch","ski","skill","skin","skirt","skull","slab","slam","sleep","slender","slice","slide","slight","slim","slogan","slot","slow","slush","small","smart","smile","smoke","smooth","snack","snake","snap","sniff","snow","soap","soccer","social","sock","soda","soft","solar","soldier","solid","solution","solve","someone","song","soon","sorry","sort","soul","sound","soup","source","south","space","spare","spatial","spawn","speak","special","speed","spell","spend","sphere","spice","spider","spike","spin","spirit","split","spoil","sponsor","spoon","sport","spot","spray","spread","spring","spy","square","squeeze","squirrel","stable","stadium","staff","stage","stairs","stamp","stand","start","state","stay","steak","steel","stem","step","stereo","stick","still","sting","stock","stomach","stone","stool","story","stove","strategy","street","strike","strong","struggle","student","stuff","stumble","style","subject","submit","subway","success","such","sudden","suffer","sugar","suggest","suit","summer","sun","sunny","sunset","super","supply","supreme","sure","surface","surge","surprise","surround","survey","suspect","sustain","swallow","swamp","swap","swarm","swear","sweet","swift","swim","swing","switch","sword","symbol","symptom","syrup","system","table","tackle","tag","tail","talent","talk","tank","tape","target","task","taste","tattoo","taxi","teach","team","tell","ten","tenant","tennis","tent","term","test","text","thank","that","theme","then","theory","there","they","thing","this","thought","three","thrive","throw","thumb","thunder","ticket","tide","tiger","tilt","timber","time","tiny","tip","tired","tissue","title","toast","tobacco","today","toddler","toe","together","toilet","token","tomato","tomorrow","tone","tongue","tonight","tool","tooth","top","topic","topple","torch","tornado","tortoise","toss","total","tourist","toward","tower","town","toy","track","trade","traffic","tragic","train","transfer","trap","trash","travel","tray","treat","tree","trend","trial","tribe","trick","trigger","trim","trip","trophy","trouble","truck","true","truly","trumpet","trust","truth","try","tube","tuition","tumble","tuna","tunnel","turkey","turn","turtle","twelve","twenty","twice","twin","twist","two","type","typical","ugly","umbrella","unable","unaware","uncle","uncover","under","undo","unfair","unfold","unhappy","uniform","unique","unit","universe","unknown","unlock","until","unusual","unveil","update","upgrade","uphold","upon","upper","upset","urban","urge","usage","use","used","useful","useless","usual","utility","vacant","vacuum","vague","valid","valley","valve","van","vanish","vapor","various","vast","vault","vehicle","velvet","vendor","venture","venue","verb","verify","version","very","vessel","veteran","viable","vibrant","vicious","victory","video","view","village","vintage","violin","virtual","virus","visa","visit","visual","vital","vivid","vocal","voice","void","volcano","volume","vote","voyage","wage","wagon","wait","walk","wall","walnut","want","warfare","warm","warrior","wash","wasp","waste","water","wave","way","wealth","weapon","wear","weasel","weather","web","wedding","weekend","weird","welcome","west","wet","whale","what","wheat","wheel","when","where","whip","whisper","wide","width","wife","wild","will","win","window","wine","wing","wink","winner","winter","wire","wisdom","wise","wish","witness","wolf","woman","wonder","wood","wool","word","work","world","worry","worth","wrap","wreck","wrestle","wrist","write","wrong","yard","year","yellow","you","young","youth","zebra","zero","zone","zoo"];

let currentMnemonic = '';

function generateMnemonic() {
    const length = parseInt(document.getElementById('mnemonicLength').value);

    // Calculate entropy bits
    const entropyBits = (length * 11) - (length / 3);
    const entropyBytes = entropyBits / 8;

    // Generate random bytes
    const randomBytes = new Uint8Array(entropyBytes);
    crypto.getRandomValues(randomBytes);

    // Calculate checksum
    const hash = CryptoJS.SHA256(CryptoJS.lib.WordArray.create(randomBytes));
    const hashBytes = hexToBytes(hash.toString());
    const checksumBits = entropyBits / 32;

    // Convert to binary
    let entropyBinary = bytesToBinary(randomBytes);
    let checksumBinary = bytesToBinary(hashBytes).substring(0, checksumBits);
    let allBits = entropyBinary + checksumBinary;

    // Convert to words
    const words = [];
    for (let i = 0; i < allBits.length; i += 11) {
        const index = parseInt(allBits.substring(i, i + 11), 2);
        words.push(BIP39_WORDLIST[index]);
    }

    const mnemonic = words.join(' ');
    currentMnemonic = mnemonic;

    displayMnemonic(mnemonic);

    // Auto-fill validation input
    document.getElementById('mnemonicInput').value = mnemonic;

    // Show success message
    showNotification('Mnemonic generated successfully!', 'success');
}

function displayMnemonic(mnemonic) {
    const words = mnemonic.split(' ');
    let html = '';

    words.forEach((word, index) => {
        html += '<span class="mnemonic-word">' + (index + 1) + '. ' + word + '</span>';
    });

    document.getElementById('mnemonicDisplay').innerHTML = html;
}

function validateAndDerive() {
    const mnemonic = document.getElementById('mnemonicInput').value.trim().toLowerCase();
    const passphrase = document.getElementById('passphraseInput').value;

    if (!mnemonic) {
        alert('Please enter a mnemonic phrase');
        return;
    }

    // Validate mnemonic
    const words = mnemonic.split(' ').filter(w => w);
    const wordCount = words.length;

    // Check valid word count
    if (![12, 15, 18, 21, 24].includes(wordCount)) {
        showNotification('Invalid word count! Must be 12, 15, 18, 21, or 24 words.', 'error');
        document.getElementById('resultsContainer').style.display = 'none';
        return;
    }

    // Check all words are in wordlist
    for (let word of words) {
        if (!BIP39_WORDLIST.includes(word)) {
            showNotification('Invalid word: ' + word + '. Not in BIP39 wordlist.', 'error');
            document.getElementById('resultsContainer').style.display = 'none';
            return;
        }
    }

    // Convert words to binary
    let allBits = '';
    for (let word of words) {
        const index = BIP39_WORDLIST.indexOf(word);
        allBits += index.toString(2).padStart(11, '0');
    }

    // Extract entropy and checksum
    const entropyBits = (wordCount * 11) - (wordCount / 3);
    const checksumBits = wordCount / 3;
    const entropyBinary = allBits.substring(0, entropyBits);
    const checksumBinary = allBits.substring(entropyBits);

    // Convert entropy to hex
    const entropyBytes = binaryToBytes(entropyBinary);
    const entropy = bytesToHex(entropyBytes);

    // Verify checksum
    const hash = CryptoJS.SHA256(CryptoJS.lib.WordArray.create(entropyBytes));
    const hashBytes = hexToBytes(hash.toString());
    const calculatedChecksum = bytesToBinary(hashBytes).substring(0, checksumBits);

    if (checksumBinary !== calculatedChecksum) {
        showNotification('Invalid checksum! Mnemonic is corrupted or incorrect.', 'error');
        document.getElementById('resultsContainer').style.display = 'none';
        return;
    }

    // Derive seed using PBKDF2
    const mnemonicNorm = mnemonic.normalize('NFKD');
    const passphraseNorm = ('mnemonic' + passphrase).normalize('NFKD');
    const seed = CryptoJS.PBKDF2(mnemonicNorm, passphraseNorm, {
        keySize: 512 / 32,
        iterations: 2048,
        hasher: CryptoJS.algo.SHA512
    });
    const seedHex = seed.toString();

    // Display results
    displayDetails(mnemonic, entropy, seedHex, wordCount, entropyBits, passphrase);

    document.getElementById('resultsContainer').style.display = 'block';
    showNotification('Mnemonic validated successfully!', 'success');
}

// Helper functions
function bytesToBinary(bytes) {
    let binary = '';
    for (let i = 0; i < bytes.length; i++) {
        binary += bytes[i].toString(2).padStart(8, '0');
    }
    return binary;
}

function binaryToBytes(binary) {
    const bytes = [];
    for (let i = 0; i < binary.length; i += 8) {
        bytes.push(parseInt(binary.substring(i, i + 8), 2));
    }
    return new Uint8Array(bytes);
}

function bytesToHex(bytes) {
    let hex = '';
    for (let i = 0; i < bytes.length; i++) {
        hex += bytes[i].toString(16).padStart(2, '0');
    }
    return hex;
}

function hexToBytes(hex) {
    const bytes = [];
    for (let i = 0; i < hex.length; i += 2) {
        bytes.push(parseInt(hex.substring(i, i + 2), 16));
    }
    return new Uint8Array(bytes);
}

function displayDetails(mnemonic, entropy, seed, wordCount, entropyBits, passphrase) {
    // Mnemonic details
    let detailsHtml = '';

    detailsHtml += '<div class="info-item">';
    detailsHtml += '<div class="info-label"><i class="fas fa-check-circle text-success"></i> Status</div>';
    detailsHtml += '<div class="info-value" style="color: #28a745; font-weight: 600;">Valid BIP39 Mnemonic</div>';
    detailsHtml += '</div>';

    detailsHtml += '<div class="info-item">';
    detailsHtml += '<div class="info-label"><i class="fas fa-list-ol"></i> Word Count</div>';
    detailsHtml += '<div class="info-value">' + wordCount + ' words</div>';
    detailsHtml += '</div>';

    detailsHtml += '<div class="info-item">';
    detailsHtml += '<div class="info-label"><i class="fas fa-dice"></i> Entropy</div>';
    detailsHtml += '<div class="info-value">' + entropyBits + ' bits</div>';
    detailsHtml += '</div>';

    detailsHtml += '<div class="info-item">';
    detailsHtml += '<div class="info-label"><i class="fas fa-hashtag"></i> Entropy (Hex)</div>';
    detailsHtml += '<div class="info-value">' + entropy + '</div>';
    detailsHtml += '</div>';

    detailsHtml += '<div class="info-item">';
    detailsHtml += '<div class="info-label"><i class="fas fa-binary"></i> Entropy (Binary)</div>';
    detailsHtml += '<div class="info-value" style="font-size: 0.75rem;">' + hexToBinary(entropy) + '</div>';
    detailsHtml += '</div>';

    if (passphrase) {
        detailsHtml += '<div class="info-item">';
        detailsHtml += '<div class="info-label"><i class="fas fa-lock"></i> Passphrase</div>';
        detailsHtml += '<div class="info-value">Protected with passphrase</div>';
        detailsHtml += '</div>';
    }

    document.getElementById('mnemonicDetails').innerHTML = detailsHtml;

    // Seed details
    let seedHtml = '';

    seedHtml += '<div class="info-item">';
    seedHtml += '<div class="info-label"><i class="fas fa-seedling"></i> Seed (Hex) - 512 bits</div>';
    seedHtml += '<div class="info-value" id="derivedSeed">' + seed + '</div>';
    seedHtml += '</div>';

    seedHtml += '<div class="alert alert-info" style="margin-top: 1rem; margin-bottom: 0;">';
    seedHtml += '<i class="fas fa-info-circle"></i> <strong>Note:</strong> This seed can be used with BIP32/BIP44 derivation to generate HD wallet keys for Bitcoin, Ethereum, and other cryptocurrencies.';
    seedHtml += '</div>';

    document.getElementById('seedDetails').innerHTML = seedHtml;
}

function hexToBinary(hex) {
    let binary = '';
    for (let i = 0; i < hex.length; i++) {
        const bin = parseInt(hex[i], 16).toString(2).padStart(4, '0');
        binary += bin;
        if ((i + 1) % 8 === 0) binary += ' ';
    }
    return binary.trim();
}

function copyMnemonic() {
    const text = currentMnemonic || document.getElementById('mnemonicInput').value;
    if (!text) {
        alert('No mnemonic to copy');
        return;
    }
    copyToClipboard(text);
    showNotification('Mnemonic copied to clipboard!', 'success');
}

function copySeed() {
    const seedElement = document.getElementById('derivedSeed');
    if (!seedElement) {
        alert('No seed to copy');
        return;
    }
    copyToClipboard(seedElement.textContent);
    showNotification('Seed copied to clipboard!', 'success');
}

function copyToClipboard(text) {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);
}

function showNotification(message, type) {
    const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
    const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';

    const notification = document.createElement('div');
    notification.className = 'alert ' + alertClass;
    notification.style.position = 'fixed';
    notification.style.top = '20px';
    notification.style.right = '20px';
    notification.style.zIndex = '9999';
    notification.style.minWidth = '300px';
    notification.innerHTML = '<i class="fas ' + icon + '"></i> ' + message;

    document.body.appendChild(notification);

    setTimeout(function() {
        notification.style.transition = 'opacity 0.5s';
        notification.style.opacity = '0';
        setTimeout(function() {
            document.body.removeChild(notification);
        }, 500);
    }, 3000);
}
</script>
</div>
<%@ include file="body-close.jsp"%>

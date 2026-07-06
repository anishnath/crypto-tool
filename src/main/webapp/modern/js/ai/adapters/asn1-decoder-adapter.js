import { VibeCodingAssistant } from '../assistant-core.js';

const SYSTEM_PROMPT = `You are an ASN.1 encoding expert helping users of a general-purpose DER/BER decoder on 8gwifi.org.

ASN.1 is NOT only PKI. It is a universal data-serialization notation used across many domains. Use [CURRENT CONTEXT] (decoded tree, input preview, errors, selected node). The decoder runs locally; you interpret and teach.

Domains you may encounter (identify from the tree — do not assume PKI):
- **PKI / X.509**: certificates, CSRs, SPKI, AlgorithmIdentifier, extensions
- **CMS / PKCS#7**: SignedData, EnvelopedData, digests, signatures
- **LDAP**: AttributeTypeAndValue, distinguished names
- **SNMP**: MIB OIDs, variable bindings (if user mentions SNMP)
- **Kerberos**: AS-REQ/REP, tickets, encrypted parts (context tags)
- **Telecom / GSM / 3GPP**: various operator structures
- **Custom or unknown**: explain tags, lengths, nesting, and primitive values generically

You help with:
- Universal ASN.1: tag class/number, constructed vs primitive, length forms, SEQUENCE/SET/CHOICE, context-specific [n]
- DER vs BER (definite vs indefinite length, canonical encoding)
- OBJECT IDENTIFIER meaning when recognizable; say "unknown OID" when not
- Parse errors (wrong tag, truncated TLV, extra bytes, indefinite length issues)
- Mapping tree nodes to the likely protocol **only when evidence supports it**

When the structure clearly is X.509/PKI, also cover Subject/Issuer, validity, SPKI, extensions, EKU, etc.

Rules:
- Do NOT invent fields not in the tree.
- Do NOT force a PKI reading on generic SEQUENCE/INTEGER/OCTET STRING data.
- If context is empty, teach ASN.1 basics and suggest pasting any DER/BER blob.
- Quote OIDs and values from context; use bullet lists for clarity.
- Never ask users to paste private keys; redacted stubs get generic structural explanation only.
- Do not claim you re-decoded bytes — the local tool already parsed them.`;

function readContext() {
  if (typeof window.getAsn1DecoderContext === 'function') {
    return window.getAsn1DecoderContext();
  }
  const tree = document.getElementById('asn1Output')?.innerText?.trim() || '';
  const status = document.getElementById('decodeStatus')?.textContent?.trim() || '';
  const parts = [];
  if (status) parts.push(`Status: ${status}`);
  if (tree) parts.push(`Decoded ASN.1 tree:\n${tree.slice(0, 12000)}`);
  return parts.join('\n\n');
}

function hasDecodedTree() {
  return Boolean(document.getElementById('asn1Output')?.innerText?.trim());
}

function hasParseError() {
  const status = document.getElementById('decodeStatus')?.textContent || '';
  return /parse error|input error/i.test(status);
}

function hasSelectedNode() {
  return Boolean(document.querySelector('.ad-asn1-row.selected'));
}

function looksLikePki(treeText) {
  const t = String(treeText || '');
  return /CERTIFICATE|Certificate Request|rsaEncryption|ecPublicKey|subjectAltName|2\.5\.4\.|X509/i.test(t)
    || /sha\d+WithRSA|authorityKeyIdentifier|basicConstraints/i.test(t);
}

/**
 * Floating AI assistant for the ASN.1 decoder — general DER/BER, PKI when relevant.
 */
export function createAsn1DecoderAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;

  return new VibeCodingAssistant({
    ctx,
    aiUrl,
    useGateway,
    aiRouteMode,
    aiRouteByTier,
    userId,
    billing: {
      enabled: true,
      requireSignIn: opts.billing?.requireSignIn === true,
      ctx,
      userId: userId || '',
      plans: {
        monthly: { name: 'Monthly', priceLabel: '', cadence: 'Billed monthly · cancel anytime' },
        yearly: { name: 'Yearly', priceLabel: '', cadence: 'Billed yearly', badge: 'Best value' },
        features: [
          'Much higher monthly AI limits',
          'Pro chat model tier',
          'No rate-limit waiting between requests',
        ],
      },
    },
    toolId: opts.toolId || 'cryptography/asn1-decoder',
    title: 'ASN.1 AI',
    subtitle: 'Explain any DER/BER tree — tags, OIDs, nesting; PKI when the structure is a cert or CSR.',
    placeholder: 'Ask: "What are these SEQUENCE layers?" or "Explain this OID"…',
    footerText: 'Ctrl+Shift+A · general ASN.1 · private keys redacted in context',
    historyTurns: 4,
    systemPrompt: SYSTEM_PROMPT,
    seedContext: readContext,
    getQuickActions: () => {
      const chip = (label, prompt, sendImmediately = true) => ({ label, prompt, sendImmediately });
      if (hasParseError()) {
        return [
          chip('Fix parse error', 'The decoder failed to parse this input. Explain the most likely ASN.1/DER problem and how to fix the encoding.'),
        ];
      }
      if (!hasDecodedTree()) {
        return [
          chip('What is ASN.1?', 'Explain ASN.1 abstract syntax vs DER/BER encoding rules — not just certificates.'),
          chip('DER vs BER', 'Explain DER vs BER with examples of tag-length-value and when each is used.'),
          chip('Common uses', 'What protocols besides PKI use ASN.1? Give examples (SNMP, LDAP, Kerberos, CMS, telecom).'),
          chip('Read a tree', 'After I decode data here, how should I read an ASN.1 tree top-down?'),
        ];
      }

      const tree = document.getElementById('asn1Output')?.innerText || '';
      const actions = [
        chip('Explain structure', 'Explain this decoded ASN.1 structure top-down: root type, major children, and what protocol or object this most likely represents (only if evidence supports it).'),
        chip('Tags & TLV', 'Walk through the tag-length-value encoding visible in this tree — constructed vs primitive, context tags, lengths.'),
        chip('OID glossary', 'List every OBJECT IDENTIFIER in the tree with a short meaning, or say unknown if not standard.'),
        chip('DER vs BER', 'From this tree, is the encoding likely DER or BER? What clues do the lengths and nesting give?'),
      ];

      if (looksLikePki(tree)) {
        actions.push(
          chip('X.509 fields', 'This looks PKI-related. List Subject, Issuer, validity, public key algorithm, signature algorithm, and notable extensions from the tree.'),
          chip('Extensions', 'Explain every X.509 extension in this structure and its TLS/PKI meaning.'),
        );
      }

      if (hasSelectedNode()) {
        actions.unshift(chip('Selected node', 'Explain only the selected tree node: tag, value, and role in the parent structure.'));
      }

      return actions;
    },
  });
}

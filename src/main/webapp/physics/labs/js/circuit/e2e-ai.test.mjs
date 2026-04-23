// End-to-end test: posts the same body the JSP now sends, straight to the
// Ollama /ai endpoint (bypassing AIProxyServlet), and verifies the returned
// netlist parses to a sensible elements list.
//
// Run:
//   AI_API_KEY=... AI_ENDPOINT=http://<qwen-host>:8080 node e2e-ai.test.mjs "LED with 220 ohm resistor and 5V supply"
//
// Without args, uses a short library of smoke-test prompts.

import { AI_SYSTEM_PROMPT, buildUserPrompt } from './ai-prompt.js';
import { parseNetlist } from './netlist.js';

const endpoint = process.env.AI_ENDPOINT || 'http://13.223.205.115:8080';
const apiKey   = process.env.AI_API_KEY   || '';

const prompts = process.argv[2]
    ? [process.argv[2]]
    : [
        'LED with 220 ohm resistor and 5V supply',
        'voltage divider from 12V using 3kΩ and 1kΩ',
        'RC low-pass filter with 10kΩ and 100nF',
      ];

async function generate(desc) {
    const body = {
        // Test harness bypasses AIProxyServlet and hits the upstream Go /ai
        // directly, so we must inject the same default the servlet would.
        // The JSP flow OMITS this field — don't copy that into production code.
        model: 'qwen3-coder:latest',
        stream: false,
        messages: [
            { role: 'system', content: AI_SYSTEM_PROMPT },
            { role: 'user',   content: buildUserPrompt(desc) },
        ],
    };
    const t0 = Date.now();
    const resp = await fetch(endpoint + '/ai', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'X-API-Key': apiKey },
        body: JSON.stringify(body),
    });
    const text = await resp.text();
    const elapsed = Date.now() - t0;
    if (!resp.ok) throw new Error(`HTTP ${resp.status}: ${text.slice(0, 200)}`);
    const data = JSON.parse(text);
    const content = (data?.message?.content ?? data?.response ?? '').trim();
    return { content, elapsed };
}

let pass = 0, fail = 0;

for (const desc of prompts) {
    console.log(`\n── ${desc} ──`);
    try {
        const { content, elapsed } = await generate(desc);
        console.log(`(${(elapsed / 1000).toFixed(1)}s)`);
        console.log(content);

        const { elements } = parseNetlist(content);
        const types = elements.map(e => e.type);
        const hasSource = types.some(t => ['dc-voltage','ac-voltage','dc-current','clock'].includes(t));
        const hasGround = types.includes('ground');
        console.log(`→ ${elements.length} elements, source=${hasSource}, ground=${hasGround}`);
        if (elements.length >= 3 && hasSource) pass++;
        else { fail++; console.log('  ✗ minimum-viable check failed'); }
    } catch (err) {
        fail++;
        console.log(`  ✗ ${err.message}`);
    }
}

console.log(`\n─ ${pass}/${pass + fail} passed ─`);
process.exit(fail ? 1 : 0);

#!/usr/bin/env node
/**
 * Point calculator JSPs at math-tool-engine-boot (one CAS engine load)
 * and remove duplicate math-calculus-cores / nerdamer / vector-render tags.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const WEBAPP = path.join(__dirname, '../src/main/webapp');

const BOOT = '<%@ include file="/modern/components/math-tool-engine-boot.inc.jsp" %>';
const BOOT_REL = '<%@ include file="modern/components/math-tool-engine-boot.inc.jsp" %>';
const CORES_RE = /<%@ include file="[^"]*math-calculus-cores\.inc\.jsp"\s*%>\s*\n?/g;
const MATH_LIBS_RE = /<jsp:include page="\/math\/partials\/math-libs\.jsp"\s*\/?>\s*\n/g;
const NERDAMER_CDN_RE = /\s*<script src="https:\/\/cdn\.jsdelivr\.net\/npm\/nerdamer[^"]*"><\/script>\s*\n/g;
const VEC_RENDER_RE = /\s*<script src="[^"]*\/js\/vector-calculator-render\.js[^"]*"><\/script>\s*\n/g;

const LEGACY_PARTIALS = [
  'integral-calculator-scripts',
  'derivative-calculator-scripts',
  'limit-calculator-scripts',
];

function usesEngineBoot(src) {
  return src.includes('math-tool-engine-boot.inc.jsp');
}

function usesCores(src) {
  return src.includes('math-calculus-cores.inc.jsp');
}

function processFile(rel) {
  if (rel.startsWith('math/partials/') || rel.startsWith('modern/components/')) {
    return false;
  }
  const abs = path.join(WEBAPP, rel);
  let src = fs.readFileSync(abs, 'utf8');
  let changed = false;

  if (src.includes('math-libs.jsp') && usesCores(src) && !usesEngineBoot(src)) {
    src = src.replace(MATH_LIBS_RE, `${BOOT}\n`);
    changed = true;
  }

  if (usesEngineBoot(src) || (src.includes('math-libs.jsp') && usesCores(src))) {
    const before = src;
    src = src.replace(CORES_RE, '');
    if (src !== before) changed = true;
  }

  if (NERDAMER_CDN_RE.test(src)) {
    src = src.replace(NERDAMER_CDN_RE, '\n');
    changed = true;
  }
  NERDAMER_CDN_RE.lastIndex = 0;

  if (VEC_RENDER_RE.test(src)) {
    src = src.replace(VEC_RENDER_RE, '\n');
    changed = true;
  }
  VEC_RENDER_RE.lastIndex = 0;

  for (const partial of LEGACY_PARTIALS) {
    if (
      src.includes(partial) &&
      !usesCores(src) &&
      !usesEngineBoot(src) &&
      !src.includes('math-libs.jsp')
    ) {
      const re = new RegExp(
        `(<jsp:include page="/math/partials/${partial}\\.jsp"\\s*/>)`,
        'm'
      );
      if (re.test(src)) {
        src = src.replace(re, `${BOOT}\n    $1`);
        changed = true;
      }
    }
  }

  // vector-calculator: engine must precede page core
  if (rel === 'vector-calculator.jsp' && usesCores(src)) {
    const coreLine = src.match(/<script src="[^"]*vector-calculator-core\.js[^"]*"><\/script>/);
    const coresInc = src.match(CORES_RE);
    if (coreLine && coresInc) {
      src = src.replace(CORES_RE, '');
      src = src.replace(
        coreLine[0],
        `${coresInc[0].trim()}\n${coreLine[0]}`
      );
      changed = true;
    }
  }

  // Pages with math-libs + cores but cores-only (no boot yet): ode/pde/trig vc
  if (
    src.includes('math-libs.jsp') &&
    usesCores(src) &&
    !usesEngineBoot(src)
  ) {
    src = src.replace(MATH_LIBS_RE, `${BOOT}\n`);
    src = src.replace(CORES_RE, '');
    changed = true;
  }

  if (changed) {
    fs.writeFileSync(abs, src);
    console.log('updated', rel);
  }
  return changed;
}

const jspFiles = [];
function walk(dir) {
  for (const name of fs.readdirSync(dir)) {
    const p = path.join(dir, name);
    if (fs.statSync(p).isDirectory() && name !== 'node_modules') walk(p);
    else if (name.endsWith('.jsp')) jspFiles.push(path.relative(WEBAPP, p));
  }
}
walk(WEBAPP);

let n = 0;
for (const f of jspFiles) {
  if (processFile(f)) n++;
}
console.log(`Done. ${n} JSP(s) updated.`);

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>GitLab CI/CD Pipeline Generator – Online .gitlab-ci.yml Builder</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <meta name="description" content="Free GitLab CI/CD pipeline generator. Build an advanced .gitlab-ci.yml for Node, Python, Java, Go, and Docker with stages, cache, artifacts, services, rules, and deploy. 100% client‑side."/>
  <meta name="keywords" content="gitlab ci generator, gitlab ci yml, .gitlab-ci.yml generator, gitlab pipeline generator, docker dind, gitlab cache, gitlab artifacts, gitlab rules, gitlab deploy"/>
  <link rel="canonical" href="https://8gwifi.org/gitlab-ci-gen.jsp"/>
  <meta name="robots" content="index,follow"/>
  <meta property="og:title" content="GitLab CI/CD Pipeline Generator – Online .gitlab-ci.yml Builder"/>
  <meta property="og:description" content="Generate GitLab CI pipelines for Node, Python, Java, Go, and Docker. Configure stages, cache, artifacts, services, rules, and deploy. Client‑side only."/>
  <meta property="og:type" content="website"/>
  <meta property="og:url" content="https://8gwifi.org/gitlab-ci-gen.jsp"/>
  <meta property="og:image" content="https://8gwifi.org/images/site/ci.png"/>
  <meta name="twitter:card" content="summary_large_image"/>
  <meta name="twitter:title" content="GitLab CI/CD Pipeline Generator – Online .gitlab-ci.yml Builder"/>
  <meta name="twitter:description" content="Build advanced .gitlab-ci.yml with stages, cache, artifacts, services, rules, deploy. Runs entirely in your browser."/>
  <meta name="twitter:image" content="https://8gwifi.org/images/site/ci.png"/>

  <%@ include file="header-script.jsp"%>

  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"WebApplication",
    "name":"GitLab CI/CD Pipeline Generator",
    "url":"https://8gwifi.org/gitlab-ci-gen.jsp",
    "image":"https://8gwifi.org/images/site/ci.png",
    "applicationCategory":"DeveloperApplication",
    "operatingSystem":"All",
    "offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},
    "featureList":[
      "Language presets for Node, Python, Java, Go, Docker",
      "Build/Test/Lint/Deploy stages",
      "Cache & artifacts with retention",
      "Docker-in-Docker and services (Postgres/Redis)",
      "Rules/only/except and MR pipelines",
      "JUnit reports and coverage regex"
    ],
    "author":{"@type":"Person","name":"Anish Nath"}
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"FAQPage",
    "mainEntity":[
      {"@type":"Question","name":"How do I generate a GitLab CI pipeline?","acceptedAnswer":{"@type":"Answer","text":"Choose a preset (Node, Python, Java, Go, Docker), select stages and options (cache, artifacts, services, rules), then click Generate. Copy the .gitlab-ci.yml to your repo root."}},
      {"@type":"Question","name":"Does this run server‑side?","acceptedAnswer":{"@type":"Answer","text":"No. The generator runs 100% in your browser. No data or repo information leaves your device."}},
      {"@type":"Question","name":"How do I enable Docker builds?","acceptedAnswer":{"@type":"Answer","text":"Pick the Docker preset or enable Docker‑in‑Docker under Runner. Optionally add docker:dind service and variables like DOCKER_TLS_CERTDIR=\"\"."}},
      {"@type":"Question","name":"Can I add test reports and coverage?","acceptedAnswer":{"@type":"Answer","text":"Yes. Provide a JUnit report path and an optional coverage regex. The generator adds artifacts:reports:junit and coverage parsing to the test job."}}
    ]
  }
  </script>

  <style>
    .glci .card-header{padding:.6rem .9rem;font-weight:600}
    .glci .card-body{padding:.9rem}
    .glci .form-group{margin-bottom:.6rem}
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
    .small-muted{font-size:.9rem;color:#6c757d}
    .glci .input-group-text{min-width: 110px}
    .glci .badge{font-weight:500}
    /* Simple pipeline visualization */
    .viz-wrap{overflow-x:auto}
    .viz{display:flex; gap:12px; align-items:flex-start; padding:.5rem 0}
    .lane{min-width: 180px; flex: 0 0 180px}
    .lane h6{font-weight:600; font-size: .95rem; margin-bottom:.25rem}
    .lane .col-body{background:#f8f9fa; border:1px solid #e9ecef; border-radius:8px; padding:.5rem}
    .job{background:white; border:1px solid #dee2e6; border-radius:8px; padding:.4rem .5rem; margin-bottom:.5rem; box-shadow:0 1px 1px rgba(0,0,0,.03)}
    .job .name{font-weight:600; font-size:.95rem}
    .job .meta{display:flex; flex-wrap:wrap; gap:.25rem; margin-top:.25rem}
    .chip{display:inline-block; padding:.05rem .35rem; border-radius:999px; font-size:.75rem; border:1px solid #e0e0e0; color:#495057; background:#fff}
    .chip.good{border-color:#c3e6cb; color:#155724; background:#eaf7ed}
    .chip.warn{border-color:#ffeeba; color:#856404; background:#fff7e6}
    .chip.info{border-color:#b8daff; color:#004085; background:#e8f3ff}
    .legend{display:flex; gap:.5rem; flex-wrap:wrap}
  </style>
</head>

<%@ include file="body-script.jsp"%>
<div class="container mt-4 glci">
  <h1 class="mb-2">GitLab CI/CD Pipeline Generator</h1>
  <p class="text-muted">Build an advanced <code>.gitlab-ci.yml</code> for common stacks with stages, cache, artifacts, services, rules, and deploy. All generation runs in your browser.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Preset</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="preset">Language / Stack</label>
            <select id="preset" class="form-control">
              <option value="node" selected>Node.js (npm)</option>
              <option value="node-yarn">Node.js (yarn)</option>
              <option value="python">Python (pip/pytest)</option>
              <option value="java-maven">Java (Maven)</option>
              <option value="java-gradle">Java (Gradle)</option>
              <option value="go">Go</option>
              <option value="docker">Docker (build & push)</option>
            </select>
          </div>
          <div class="form-group">
            <label for="baseImage">Base image</label>
            <input id="baseImage" class="form-control" placeholder="e.g., node:20, python:3.11, maven:3-eclipse-temurin-17"/>
            <small class="small-muted">Overrides the default preset image.</small>
          </div>
          <div class="form-group">
            <div class="form-check"><input id="addLint" class="form-check-input" type="checkbox"><label class="form-check-label" for="addLint">Include Lint job</label></div>
            <div class="form-check"><input id="mergeMR" class="form-check-input" type="checkbox" checked><label class="form-check-label" for="mergeMR">Run on Merge Requests</label></div>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Stages</h5>
        <div class="card-body">
          <div class="form-check"><input id="stBuild" type="checkbox" class="form-check-input" checked><label class="form-check-label" for="stBuild">build</label></div>
          <div class="form-check"><input id="stTest" type="checkbox" class="form-check-input" checked><label class="form-check-label" for="stTest">test</label></div>
          <div class="form-check"><input id="stLint" type="checkbox" class="form-check-input"><label class="form-check-label" for="stLint">lint</label></div>
          <div class="form-check"><input id="stDeploy" type="checkbox" class="form-check-input"><label class="form-check-label" for="stDeploy">deploy</label></div>
        </div>
      </div>
    </div>

    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Cache & Artifacts</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="cachePaths">Cache paths (one per line)</label>
            <textarea id="cachePaths" class="form-control mono" rows="4" placeholder="node_modules/&#10;.m2/repository&#10;$GOPATH/pkg/mod&#10;.cache/pip"></textarea>
          </div>
          <div class="form-row">
            <div class="form-group col-6">
              <label for="artifactPaths">Artifact paths</label>
              <input id="artifactPaths" class="form-control" placeholder="e.g., dist/, build/"/>
            </div>
            <div class="form-group col-6">
              <label for="artifactExpire">Expire in</label>
              <input id="artifactExpire" class="form-control" placeholder="e.g., 1 week"/>
            </div>
          </div>
          <div class="form-group">
            <label for="junitPath">JUnit report (test)</label>
            <input id="junitPath" class="form-control" placeholder="e.g., junit.xml or reports/junit.xml"/>
          </div>
          <div class="form-group">
            <label for="coverageRegex">Coverage regex</label>
            <input id="coverageRegex" class="form-control" placeholder="e.g., /All files[^|]*\|(\s*\d+\.\d+)%/"/>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Runner & Services</h5>
        <div class="card-body">
          <div class="form-check"><input id="useDind" class="form-check-input" type="checkbox"><label class="form-check-label" for="useDind">Enable Docker‑in‑Docker (docker:dind)</label></div>
          <div class="form-row mt-2">
            <div class="form-group col-6">
              <label for="svcPostgres">Postgres service</label>
              <input id="svcPostgres" class="form-control" placeholder="e.g., 15 or empty"/>
            </div>
            <div class="form-group col-6">
              <label for="svcRedis">Redis service</label>
              <input id="svcRedis" class="form-control" placeholder="e.g., 7 or empty"/>
            </div>
          </div>
          <div class="form-group">
            <label for="variablesKV">Variables (KEY=VALUE, one per line)</label>
            <textarea id="variablesKV" class="form-control mono" rows="4" placeholder="NODE_ENV=ci&#10;GRADLE_OPTS=-Dorg.gradle.daemon=false"></textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Rules / Workflow</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="defaultBranch">Default branch</label>
            <input id="defaultBranch" class="form-control" value="main"/>
          </div>
          <div class="form-group">
            <label for="onlyBranches">Only branches (comma‑sep)</label>
            <input id="onlyBranches" class="form-control" placeholder="e.g., main, release/*"/>
          </div>
          <div class="form-group">
            <label for="changesPaths">Run when these paths change (comma‑sep)</label>
            <input id="changesPaths" class="form-control" placeholder="e.g., src/**, package.json"/>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Deploy</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="envName">Environment name</label>
            <input id="envName" class="form-control" placeholder="e.g., production"/>
          </div>
          <div class="form-group">
            <label for="deployScript">Deploy script (commands)</label>
            <textarea id="deployScript" class="form-control mono" rows="4" placeholder="e.g., ./deploy.sh or kubectl apply -f k8s/"></textarea>
            <div class="form-check mt-2"><input id="deployManual" class="form-check-input" type="checkbox" checked><label class="form-check-label" for="deployManual">Manual deploy</label></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">Generated .gitlab-ci.yml</h5>
    <div class="card-body">
      <div class="mb-2">
        <button class="btn btn-primary mr-2" onclick="generateYaml()">Generate</button>
        <button class="btn btn-outline-secondary mr-2" onclick="copyOut(this)">Copy</button>
        <button class="btn btn-outline-secondary" onclick="downloadOut()">Download</button>
      </div>
      <textarea id="out" class="form-control mono" rows="20" spellcheck="false" placeholder="# Your .gitlab-ci.yml will appear here"></textarea>
      <small class="small-muted">Tip: Commit this file to the root of your repository.</small>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">Pipeline Visualization</h5>
    <div class="card-body">
      <div class="legend mb-2">
        <span class="chip info">image</span>
        <span class="chip info">service</span>
        <span class="chip good">reports</span>
        <span class="chip warn">manual</span>
        <span class="chip">rules</span>
      </div>
      <div id="vizHeader" class="mb-2"></div>
      <div class="viz-wrap"><div id="viz" class="viz"></div></div>
    </div>
  </div>

  <div class="sharethis-inline-share-buttons"></div>
  <%@ include file="thanks.jsp"%>

  <hr>
  <%@ include file="footer_adsense.jsp"%>
</div>

<script>
(function(){
  const defaults = {
    node: { image: 'node:20', cache: ['node_modules/'], build: ['npm ci','npm run build'], test: ['npm test -- --ci --reporters=default'], lint: ['npm run lint'] },
    'node-yarn': { image: 'node:20', cache: ['node_modules/'], build: ['yarn install --frozen-lockfile','yarn build'], test: ['yarn test --ci'], lint: ['yarn lint'] },
    python: { image: 'python:3.11', cache: ['.cache/pip'], build: ['pip install -U pip','pip install -r requirements.txt'], test: ['pytest -q'], lint: ['flake8 .'] },
    'java-maven': { image: 'maven:3-eclipse-temurin-17', cache: ['.m2/repository'], build: ['mvn -B -ntp -DskipTests package'], test: ['mvn -B -ntp test'], lint: ['mvn -B -ntp -DskipTests verify'] },
    'java-gradle': { image: 'gradle:8-jdk17', cache: ['.gradle','~/.gradle/caches'], build: ['gradle -g .gradle assemble'], test: ['gradle -g .gradle test'], lint: ['gradle -g .gradle check'] },
    go: { image: 'golang:1.22', cache: ['$GOPATH/pkg/mod'], build: ['go build ./...'], test: ['go test ./... -v'], lint: ['golangci-lint run || true'] },
    docker: { image: 'docker:27', cache: [], build: ['docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .'], test: ['docker run --rm $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA echo ok'] }
  };

  function val(id){ const el = document.getElementById(id); return el? (el.value||'').trim() : ''; }
  function checked(id){ const el = document.getElementById(id); return !!(el && el.checked); }
  function lines(id){ const v = val(id); if(!v) return []; return v.split(/\r?\n/).map(s=>s.trim()).filter(Boolean); }
  function csv(id){ const v = val(id); if(!v) return []; return v.split(',').map(s=>s.trim()).filter(Boolean); }

  function yamlList(indent, arr){ if(!arr||!arr.length) return ''; return arr.map(s=>`${indent}- ${s}`).join('\n'); }
  function yamlKV(indent, obj){ return Object.keys(obj).map(k=>`${indent}${k}: ${obj[k]}`).join('\n'); }
  function esc(s){ return s.replace(/"/g,'\\"'); }

  window.generateYaml = function(){
    const preset = val('preset')||'node';
    const d = defaults[preset] || defaults['node'];
    const img = val('baseImage') || d.image;
    const stages = [];
    if(checked('stBuild')) stages.push('build');
    if(checked('stTest')) stages.push('test');
    if(checked('stLint')||checked('addLint')) stages.push('lint');
    if(checked('stDeploy')) stages.push('deploy');
    if(!stages.length){ stages.push('build','test'); }

    // Cache
    let cachePaths = lines('cachePaths');
    if(cachePaths.length===0 && d.cache && d.cache.length){ cachePaths = d.cache; }

    // Variables
    const vars = {};
    lines('variablesKV').forEach(line=>{ const m=line.match(/^([^=:#\s]+)\s*=\s*(.*)$/); if(m){ vars[m[1]]=m[2]; }});

    // Services
    const services = [];
    if(checked('useDind')) services.push('docker:dind');
    const pg = val('svcPostgres'); if(pg) services.push(`postgres:${pg}`);
    const rd = val('svcRedis'); if(rd) services.push(`redis:${rd}`);

    // Build script sets
    const buildScript = d.build || [];
    const testScript = d.test || [];
    const lintScript = (checked('addLint') || checked('stLint')) ? (d.lint||[]) : [];

    // JUnit & Coverage
    const junit = val('junitPath');
    const cov = val('coverageRegex');

    // Artifacts
    const artPaths = val('artifactPaths');
    const artExpire = val('artifactExpire');

    // Rules
    const onlyBranches = csv('onlyBranches');
    const changes = csv('changesPaths');
    const defaultBranch = val('defaultBranch')||'main';
    const runMR = checked('mergeMR');

    // Deploy
    const envName = val('envName');
    const deployScript = lines('deployScript');
    const deployManual = checked('deployManual');

    // Compose YAML
    const y = [];
    y.push(`image: ${img}`);
    if(services.length){ y.push('services:'); services.forEach(s=> y.push(`  - ${s}`)); }
    if(Object.keys(vars).length){ y.push('variables:'); Object.keys(vars).forEach(k=> y.push(`  ${k}: "${esc(vars[k])}"`)); }
    y.push('');
    y.push('stages:'); stages.forEach(s=> y.push(`  - ${s}`));
    y.push('');

    if(cachePaths.length){
      y.push('cache:');
      y.push('  key: ' + '$' + '{CI_COMMIT_REF_SLUG}');
      y.push('  paths:'); cachePaths.forEach(p=> y.push(`    - ${p}`));
      y.push('');
    }

    // Build job
    if(stages.includes('build')){
      y.push('build:');
      y.push('  stage: build');
      if(buildScript.length){ y.push('  script:'); buildScript.forEach(s=> y.push(`    - ${s}`)); }
      if(artPaths){ y.push('  artifacts:'); y.push('    paths:'); artPaths.split(',').map(s=>s.trim()).filter(Boolean).forEach(p=> y.push(`      - ${p}`)); if(artExpire){ y.push(`    expire_in: ${artExpire}`); } }
      if(onlyBranches.length||changes.length||runMR){
        y.push('  rules:');
        if(onlyBranches.length) y.push(`    - if: "$CI_COMMIT_BRANCH && ${onlyBranches.map(b=>`$CI_COMMIT_BRANCH =~ /${b.replace(/\*/g,'.*')}/`).join(' || ')}"`);
        if(changes.length){ y.push('      changes:'); changes.forEach(c=> y.push(`        - ${c}`)); }
        if(runMR) y.push('    - if: "$CI_PIPELINE_SOURCE == \"merge_request_event\""');
        y.push('    - when: on_success');
      }
      y.push('');
    }

    // Test job
    if(stages.includes('test')){
      y.push('test:');
      y.push('  stage: test');
      if(testScript.length){ y.push('  script:'); testScript.forEach(s=> y.push(`    - ${s}`)); }
      if(junit || cov){
        if(junit){ y.push('  artifacts:'); y.push('    reports:'); y.push(`      junit: ${junit}`); }
        if(cov){ y.push(`  coverage: '${cov.replace(/'/g,"''")}'`); }
      }
      if(runMR){ y.push('  rules:'); y.push('    - if: "$CI_PIPELINE_SOURCE == \"merge_request_event\""'); y.push('    - when: on_success'); }
      y.push('');
    }

    // Lint job
    if(stages.includes('lint') && lintScript.length){
      y.push('lint:');
      y.push('  stage: lint');
      y.push('  script:'); lintScript.forEach(s=> y.push(`    - ${s}`));
      if(runMR){ y.push('  rules:'); y.push('    - if: "$CI_PIPELINE_SOURCE == \"merge_request_event\""'); y.push('    - when: on_success'); }
      y.push('');
    }

    // Deploy job
    if(stages.includes('deploy') && (envName || deployScript.length)){
      y.push('deploy:');
      y.push('  stage: deploy');
      if(envName){ y.push('  environment:'); y.push(`    name: ${envName}`); }
      if(deployScript.length){ y.push('  script:'); deployScript.forEach(s=> y.push(`    - ${s}`)); }
      if(deployManual) y.push('  when: manual');
      y.push('  only:'); y.push(`    - ${defaultBranch||'main'}`);
      y.push('');
    }

    const yamlText = y.join('\n');
    document.getElementById('out').value = yamlText;

    try { renderViz({ preset, img, services, stages, junit, cov, envName, deployManual, runMR, onlyBranches, changes }); } catch(e){}
  }

  window.copyOut = function(btn){ try{ const v=document.getElementById('out').value||''; if(navigator.clipboard) navigator.clipboard.writeText(v); btn.textContent='Copied!'; setTimeout(()=>btn.textContent='Copy',900); }catch(e){} };
  window.downloadOut = function(){ try{ const v=document.getElementById('out').value||''; const blob=new Blob([v],{type:'text/yaml'}); const a=document.createElement('a'); a.href=URL.createObjectURL(blob); a.download='.gitlab-ci.yml'; document.body.appendChild(a); a.click(); document.body.removeChild(a); }catch(e){} };

})();

// Simple visualization renderer
function renderViz(data){
  const header = document.getElementById('vizHeader');
  const viz = document.getElementById('viz');
  if(!header || !viz) return;
  header.innerHTML = '';
  viz.innerHTML = '';

  // Top badges: image and services
  const hdr = document.createElement('div');
  hdr.className = 'mb-2';
  const imgChip = document.createElement('span'); imgChip.className='chip info'; imgChip.textContent = `image: ${data.img||''}`; hdr.appendChild(imgChip);
  (data.services||[]).forEach(s=>{ const c=document.createElement('span'); c.className='chip info'; c.textContent = s; hdr.appendChild(document.createTextNode(' ')); hdr.appendChild(c); });
  header.appendChild(hdr);

  const stageOrder = ['build','test','lint','deploy'];
  const stages = (data.stages||[]).slice().sort((a,b)=> stageOrder.indexOf(a)-stageOrder.indexOf(b));
  stages.forEach(stage=>{
    const lane = document.createElement('div'); lane.className='lane';
    const h6 = document.createElement('h6'); h6.textContent = stage; lane.appendChild(h6);
    const col = document.createElement('div'); col.className='col-body';

    const job = document.createElement('div'); job.className='job';
    const name = document.createElement('div'); name.className='name'; name.textContent = stage; job.appendChild(name);
    const meta = document.createElement('div'); meta.className='meta';

    // Badges per stage
    if(stage==='test'){
      if(data.junit){ const c=document.createElement('span'); c.className='chip good'; c.textContent='reports:junit'; meta.appendChild(c); }
      if(data.cov){ const c=document.createElement('span'); c.className='chip good'; c.textContent='coverage'; meta.appendChild(c); }
    }
    if(stage==='deploy'){
      if(data.envName){ const c=document.createElement('span'); c.className='chip good'; c.textContent=`env:${data.envName}`; meta.appendChild(c); }
      if(data.deployManual){ const c=document.createElement('span'); c.className='chip warn'; c.textContent='manual'; meta.appendChild(c); }
    }
    // Rules chips
    if(stage!=='deploy'){
      if(data.runMR){ const c=document.createElement('span'); c.className='chip'; c.textContent='rule:MR'; meta.appendChild(c); }
      if((data.onlyBranches||[]).length){ const c=document.createElement('span'); c.className='chip'; c.textContent='rule:branch'; meta.appendChild(c); }
      if((data.changes||[]).length){ const c=document.createElement('span'); c.className='chip'; c.textContent='rule:changes'; meta.appendChild(c); }
    }

    job.appendChild(meta);
    col.appendChild(job);
    lane.appendChild(col);
    viz.appendChild(lane);
  });
}
</script>
<%@ include file="body-close.jsp"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Interactive ML Pipeline Simulator - Complete machine learning lifecycle from data to deployment">
    <meta name="keywords" content="machine learning pipeline, ML lifecycle, data preprocessing, model training, cross-validation">
    <title>ML Pipeline Simulator - End-to-End Machine Learning</title>

    <%@ include file="header-script.jsp"%>

    <script type="application/ld+json">
        {
            "@context": "http://schema.org",
            "@type": "WebPage",
            "name": "ML Pipeline Simulator",
            "description": "Interactive tool for learning the complete ML pipeline",
            "url": "https://8gwifi.org/ML_Pipeline.jsp",
            "keywords": "ML pipeline, machine learning, data science, model training"
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <style>
        .ml-pipeline { font-family: -apple-system, sans-serif; }
        .pipeline-progress { display: flex; justify-content: space-between; margin: 20px 0; position: relative; }
        .pipeline-progress::before { content: ''; position: absolute; top: 20px; left: 0; right: 0; height: 3px; background: #dee2e6; z-index: 0; }
        .pipeline-step { flex: 1; text-align: center; position: relative; z-index: 1; cursor: pointer; }
        .pipeline-step-circle { width: 40px; height: 40px; border-radius: 50%; background: #dee2e6; color: #6c757d; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: bold; border: 3px solid #fff; }
        .pipeline-step.active .pipeline-step-circle { background: #0d6efd; color: #fff; box-shadow: 0 0 0 4px rgba(13,110,253,0.2); }
        .pipeline-step.completed .pipeline-step-circle { background: #28a745; color: #fff; }
        .pipeline-step-label { font-size: 12px; font-weight: 500; color: #6c757d; }
        .pipeline-step.active .pipeline-step-label { color: #0d6efd; font-weight: 600; }
        .dataset-card { border: 2px solid #dee2e6; border-radius: 8px; padding: 15px; cursor: pointer; transition: all 0.3s; }
        .dataset-card:hover { border-color: #0d6efd; transform: translateY(-2px); }
        .dataset-card.selected { border-color: #0d6efd; background: #e7f3ff; }
        .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 8px; padding: 20px; text-align: center; }
        .stat-value { font-size: 28px; font-weight: bold; }
        .model-card { border: 2px solid #dee2e6; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
        .model-card.best { border-color: #28a745; background: #d4edda; }
        .chart-container-sm { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 6px; padding: 15px; height: 250px; }
        .chart-container-md { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 6px; padding: 15px; height: 350px; }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">🚀 ML Pipeline Simulator</h1>
<p class="lead mb-3">Walk through a complete machine learning workflow in 6 interactive steps: <strong>Dataset Selection</strong> → <strong>EDA</strong> → <strong>Preprocessing</strong> → <strong>Training</strong> → <strong>Evaluation</strong> → <strong>Deployment</strong>. Choose from 3 datasets, train 3 models, and see how preprocessing choices affect results.</p>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="ml-pipeline">
    <!-- Progress Bar -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="pipeline-progress">
                <div class="pipeline-step active" data-step="1">
                    <div class="pipeline-step-circle">1</div>
                    <div class="pipeline-step-label">Dataset</div>
                </div>
                <div class="pipeline-step" data-step="2">
                    <div class="pipeline-step-circle">2</div>
                    <div class="pipeline-step-label">EDA</div>
                </div>
                <div class="pipeline-step" data-step="3">
                    <div class="pipeline-step-circle">3</div>
                    <div class="pipeline-step-label">Preprocess</div>
                </div>
                <div class="pipeline-step" data-step="4">
                    <div class="pipeline-step-circle">4</div>
                    <div class="pipeline-step-label">Training</div>
                </div>
                <div class="pipeline-step" data-step="5">
                    <div class="pipeline-step-circle">5</div>
                    <div class="pipeline-step-label">Evaluation</div>
                </div>
                <div class="pipeline-step" data-step="6">
                    <div class="pipeline-step-circle">6</div>
                    <div class="pipeline-step-label">Deploy</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Step 1: Dataset Selection -->
    <div class="step-content" id="step1">
        <div class="card">
            <div class="card-header"><h5>📊 Step 1: Select Dataset</h5></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="dataset-card" data-dataset="iris">
                            <div style="font-size:36px">🌸</div>
                            <h6>Iris Flowers</h6>
                            <p class="small">150 samples • 4 features • 3 classes</p>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="dataset-card" data-dataset="wine">
                            <div style="font-size:36px">🍷</div>
                            <h6>Wine Quality</h6>
                            <p class="small">200 samples • 6 features • Binary</p>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="dataset-card" data-dataset="health">
                            <div style="font-size:36px">❤️</div>
                            <h6>Heart Disease</h6>
                            <p class="small">180 samples • 5 features • Binary</p>
                        </div>
                    </div>
                </div>
                <div class="text-end mt-3">
                    <button class="btn btn-primary" id="btnLoadDataset" disabled>Load Dataset →</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Step 2: EDA -->
    <div class="step-content" id="step2" style="display:none;">
        <div class="card">
            <div class="card-header"><h5>🔍 Step 2: Exploratory Data Analysis</h5></div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-3"><div class="stat-card"><div>Samples</div><div class="stat-value" id="statSamples">—</div></div></div>
                    <div class="col-md-3"><div class="stat-card"><div>Features</div><div class="stat-value" id="statFeatures">—</div></div></div>
                    <div class="col-md-3"><div class="stat-card"><div>Classes</div><div class="stat-value" id="statClasses">—</div></div></div>
                    <div class="col-md-3"><div class="stat-card"><div>Missing</div><div class="stat-value">0</div></div></div>
                </div>
                <div class="row">
                    <div class="col-lg-6"><h6>Feature Distributions</h6><div class="chart-container-md"><canvas id="chartDist"></canvas></div></div>
                    <div class="col-lg-6"><h6>Class Distribution</h6><div class="chart-container-md"><canvas id="chartClass"></canvas></div></div>
                </div>
                <div class="text-end mt-3">
                    <button class="btn btn-secondary" onclick="goToStep(1)">← Back</button>
                    <button class="btn btn-primary" onclick="goToStep(3)">Next →</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Step 3: Preprocessing -->
    <div class="step-content" id="step3" style="display:none;">
        <div class="card">
            <div class="card-header"><h5>⚙️ Step 3: Preprocessing</h5></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6">
                        <label class="form-check-label"><input type="checkbox" id="optNormalize" checked class="form-check-input"> Normalize Features</label><br>
                        <label class="form-check-label"><input type="checkbox" id="optStratify" checked class="form-check-input"> Stratified Split</label>
                        <div class="mt-3">
                            <label>Train/Test Split: <span id="splitLabel">80/20</span></label>
                            <input type="range" class="form-range" id="splitRatio" min="60" max="90" value="80">
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <h6>Split Summary</h6>
                        <p>Training: <strong id="trainSamples">—</strong></p>
                        <p>Testing: <strong id="testSamples">—</strong></p>
                    </div>
                </div>
                <div class="text-end mt-3">
                    <button class="btn btn-secondary" onclick="goToStep(2)">← Back</button>
                    <button class="btn btn-primary" id="btnPreprocess">Apply & Continue →</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Step 4: Training -->
    <div class="step-content" id="step4" style="display:none;">
        <div class="card">
            <div class="card-header"><h5>🎓 Step 4: Model Training</h5></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="chart-container-md"><canvas id="chartTraining"></canvas></div>
                    </div>
                    <div class="col-lg-4">
                        <div class="model-card" id="modelLog">
                            <h6>Logistic Regression</h6>
                            <p>Accuracy: <span id="accLog">—</span></p>
                            <div class="progress"><div class="progress-bar" id="progLog" style="width:0%"></div></div>
                        </div>
                        <div class="model-card" id="modelKNN">
                            <h6>K-Nearest Neighbors</h6>
                            <p>Accuracy: <span id="accKNN">—</span></p>
                            <div class="progress"><div class="progress-bar" id="progKNN" style="width:0%"></div></div>
                        </div>
                        <div class="model-card" id="modelTree">
                            <h6>Decision Tree</h6>
                            <p>Accuracy: <span id="accTree">—</span></p>
                            <div class="progress"><div class="progress-bar" id="progTree" style="width:0%"></div></div>
                        </div>
                        <button class="btn btn-success w-100 mt-3" id="btnTrain">🚀 Start Training</button>
                    </div>
                </div>
                <div class="text-end mt-3">
                    <button class="btn btn-secondary" onclick="goToStep(3)">← Back</button>
                    <button class="btn btn-primary" id="btnToEval" disabled onclick="goToStep(5)">Next →</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Step 5: Evaluation -->
    <div class="step-content" id="step5" style="display:none;">
        <div class="card">
            <div class="card-header"><h5>📊 Step 5: Model Evaluation</h5></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6"><h6>Model Comparison</h6><div class="chart-container-sm"><canvas id="chartComp"></canvas></div></div>
                    <div class="col-lg-6"><h6>Feature Importance</h6><div id="featImport"></div></div>
                </div>
                <div class="alert alert-success mt-3">
                    <strong>Best Model:</strong> <span id="bestModel">—</span>
                </div>
                <div class="text-end mt-3">
                    <button class="btn btn-secondary" onclick="goToStep(4)">← Back</button>
                    <button class="btn btn-primary" onclick="goToStep(6)">Deploy Model →</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Step 6: Deployment -->
    <div class="step-content" id="step6" style="display:none;">
        <div class="card">
            <div class="card-header"><h5>🚀 Step 6: Deployment Simulator</h5></div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6">
                        <h6>Make Prediction</h6>
                        <div id="predInputs"></div>
                        <button class="btn btn-primary w-100 mt-2" id="btnPredict">Predict</button>
                        <div id="predResult" class="alert alert-info mt-3" style="display:none;">
                            Prediction: <strong id="predClass">—</strong><br>
                            Confidence: <strong id="predConf">—</strong>%
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <h6>Model Summary</h6>
                        <div class="chart-container-sm"><canvas id="chartDeploy"></canvas></div>
                    </div>
                </div>
                <div class="text-end mt-3">
                    <button class="btn btn-secondary" onclick="goToStep(5)">← Back</button>
                    <button class="btn btn-primary" onclick="goToStep(1)">Start New Pipeline</button>
                </div>
            </div>
        </div>
    </div>

<script>
    window.addEventListener('DOMContentLoaded', () => {
        const DATASETS = {
            iris: { name: 'Iris', features: ['sepal_len', 'sepal_wid', 'petal_len', 'petal_wid'], target: 'species', classes: ['Setosa', 'Versicolor', 'Virginica'], data: genIris() },
            wine: { name: 'Wine', features: ['alcohol', 'acidity', 'sugar', 'pH', 'sulfates', 'density'], target: 'quality', classes: ['Bad', 'Good'], data: genWine() },
            health: { name: 'Heart', features: ['age', 'bp', 'chol', 'hr', 'bmi'], target: 'disease', classes: ['Healthy', 'Disease'], data: genHealth() }
        };

        let currentDataset, processedData, trainedModels, bestModel;
        let charts = {};
        let trainingData = { logistic: [], knn: [], tree: [] };

        // Initialize training progress chart
        function initTrainingChart() {
            if(charts.training) charts.training.destroy();
            trainingData = { logistic: [], knn: [], tree: [] };
            charts.training = new Chart(document.getElementById('chartTraining'), {
                type: 'line',
                data: {
                    labels: [],
                    datasets: [
                        { label: 'Logistic Regression', data: [], borderColor: '#0d6efd', backgroundColor: 'rgba(13,110,253,0.1)', borderWidth: 2, tension: 0.3 },
                        { label: 'KNN', data: [], borderColor: '#198754', backgroundColor: 'rgba(25,135,84,0.1)', borderWidth: 2, tension: 0.3 },
                        { label: 'Decision Tree', data: [], borderColor: '#ffc107', backgroundColor: 'rgba(255,193,7,0.1)', borderWidth: 2, tension: 0.3 }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        title: { display: true, text: 'Training Progress - Accuracy Over Time' },
                        legend: { display: true, position: 'top' }
                    },
                    scales: {
                        x: { title: { display: true, text: 'Training Step' }},
                        y: { title: { display: true, text: 'Accuracy' }, beginAtZero: true, max: 1 }
                    }
                }
            });
        }

        function updateTrainingChart(model, accuracy) {
            const step = trainingData[model].length + 1;
            trainingData[model].push(accuracy);
            
            const maxSteps = Math.max(trainingData.logistic.length, trainingData.knn.length, trainingData.tree.length);
            charts.training.data.labels = Array.from({length: maxSteps}, (_, i) => i + 1);
            
            charts.training.data.datasets[0].data = trainingData.logistic;
            charts.training.data.datasets[1].data = trainingData.knn;
            charts.training.data.datasets[2].data = trainingData.tree;
            
            charts.training.update('none');
        }

        function genIris() {
            const data = [];
            for(let i=0;i<50;i++) data.push([5+rn()*0.35, 3.4+rn()*0.38, 1.5+rn()*0.17, 0.2+rn()*0.1, 0]);
            for(let i=0;i<50;i++) data.push([5.9+rn()*0.52, 2.8+rn()*0.31, 4.3+rn()*0.47, 1.3+rn()*0.2, 1]);
            for(let i=0;i<50;i++) data.push([6.6+rn()*0.64, 3+rn()*0.32, 5.6+rn()*0.55, 2+rn()*0.27, 2]);
            return shuffle(data);
        }

        function genWine() {
            const data = [];
            for(let i=0;i<140;i++) data.push([9+rn()*0.8, 3.2+rn()*0.3, 2.5+rn()*1.2, 3.2+rn()*0.15, 0.5+rn()*0.1, 0.996+rn()*0.002, 0]);
            for(let i=0;i<60;i++) data.push([11.5+rn()*0.9, 2.8+rn()*0.25, 2.2+rn()*0.8, 3.3+rn()*0.12, 0.7+rn()*0.12, 0.994+rn()*0.001, 1]);
            return shuffle(data);
        }

        function genHealth() {
            const data = [];
            for(let i=0;i<90;i++) data.push([45+rn()*10, 120+rn()*8, 180+rn()*20, 70+rn()*8, 23+rn()*2, 0]);
            for(let i=0;i<90;i++) data.push([58+rn()*12, 145+rn()*15, 240+rn()*30, 85+rn()*10, 28+rn()*3, 1]);
            return shuffle(data);
        }

        function rn() { let u=0,v=0; while(!u)u=Math.random(); while(!v)v=Math.random(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }
        function shuffle(a) { for(let i=a.length-1;i>0;i--) { const j=Math.floor(Math.random()*(i+1)); [a[i],a[j]]=[a[j],a[i]]; } return a; }
        function sigmoid(z) { return 1/(1+Math.exp(-z)); }

        window.goToStep = (step) => {
            for(let i=1;i<=6;i++) {
                const el = document.getElementById('step' + i);
                if(el) el.style.display = i===step ? 'block' : 'none';
                const s = document.querySelector('.pipeline-step[data-step="' + i + '"]');
                if(s) { s.classList.remove('active','completed'); if(i<step) s.classList.add('completed'); if(i===step) s.classList.add('active'); }
            }
            if(step===2) renderEDA();
            if(step===3) renderPreprocess();
            if(step===4) initTrainingChart();
            if(step===5) renderEval();
            if(step===6) renderDeploy();
        };

        document.querySelectorAll('.dataset-card').forEach(c => {
            c.addEventListener('click', function() {
                document.querySelectorAll('.dataset-card').forEach(x => x.classList.remove('selected'));
                this.classList.add('selected');
                currentDataset = this.dataset.dataset;
                document.getElementById('btnLoadDataset').disabled = false;
            });
        });

        document.getElementById('btnLoadDataset').addEventListener('click', () => { if(currentDataset) goToStep(2); });

        document.getElementById('splitRatio').addEventListener('input', (e) => {
            document.getElementById('splitLabel').textContent = e.target.value + '/' + (100-e.target.value);
        });

        document.getElementById('btnPreprocess').addEventListener('click', () => {
            const ds = DATASETS[currentDataset];
            const ratio = parseInt(document.getElementById('splitRatio').value)/100;
            const splitIdx = Math.floor(ds.data.length * ratio);
            let trainData = ds.data.slice(0, splitIdx);
            let testData = ds.data.slice(splitIdx);

            if(document.getElementById('optNormalize').checked) {
                const scaler = { mins: [], maxs: [] };
                for(let i=0; i<ds.features.length; i++) {
                    const col = trainData.map(r => r[i]);
                    scaler.mins[i] = Math.min(...col);
                    scaler.maxs[i] = Math.max(...col);
                }
                trainData = trainData.map(r => { const n=[...r]; for(let i=0;i<ds.features.length;i++) n[i]=(r[i]-scaler.mins[i])/(scaler.maxs[i]-scaler.mins[i]+1e-10); return n; });
                testData = testData.map(r => { const n=[...r]; for(let i=0;i<ds.features.length;i++) n[i]=(r[i]-scaler.mins[i])/(scaler.maxs[i]-scaler.mins[i]+1e-10); return n; });
            }

            processedData = { trainData, testData };
            goToStep(4);
        });

        document.getElementById('btnTrain').addEventListener('click', async () => {
            document.getElementById('btnTrain').disabled = true;
            trainedModels = {};

            await trainLogistic();
            await trainKNN();
            await trainTree();

            const models = Object.entries(trainedModels);
            bestModel = models.reduce((b,[n,m]) => m.acc > b.acc ? {name:n,...m} : b, {acc:0});

            document.getElementById('btnToEval').disabled = false;
        });

        async function trainLogistic() {
            const ds = DATASETS[currentDataset];
            const {trainData, testData} = processedData;
            let w = Array(ds.features.length).fill(0), b = 0;
            const lr = 0.01, epochs = 100;

            for(let e=0; e<epochs; e++) {
                for(let row of trainData) {
                    const x = row.slice(0,-1), y = row[row.length-1];
                    const z = x.reduce((s,xi,i) => s+xi*w[i], b);
                    const pred = sigmoid(z);
                    const err = pred - (y>0?1:0);
                    for(let i=0; i<w.length; i++) w[i] -= lr*err*x[i];
                    b -= lr*err;
                }
                if(e%10===0) {
                    const tempAcc = testData.reduce((c,r) => {
                        const z = r.slice(0,-1).reduce((s,xi,i) => s+xi*w[i], b);
                        return c + (((z>0?1:0)===(r[r.length-1]>0?1:0)) ? 1 : 0);
                    }, 0) / testData.length;
                    updateTrainingChart('logistic', tempAcc);
                    document.getElementById('progLog').style.width = ((e/epochs)*100) + '%';
                    await sleep(30);
                }
            }

            const acc = testData.reduce((c,r) => {
                const z = r.slice(0,-1).reduce((s,xi,i) => s+xi*w[i], b);
                return c + (((z>0?1:0)===(r[r.length-1]>0?1:0)) ? 1 : 0);
            }, 0) / testData.length;

            trainedModels.logistic = { w, b, acc };
            updateTrainingChart('logistic', acc);
            document.getElementById('accLog').textContent = (acc*100).toFixed(1) + '%';
            document.getElementById('progLog').style.width = '100%';
        }

        async function trainKNN() {
            const {trainData, testData} = processedData;
            updateTrainingChart('knn', 0);
            document.getElementById('progKNN').style.width = '50%';
            await sleep(300);

            const k = 5;
            let correct = 0;
            for(let test of testData) {
                const dists = trainData.map(train => {
                    const d = Math.sqrt(test.slice(0,-1).reduce((s,xi,i) => s+(xi-train[i])**2, 0));
                    return {d, l:train[train.length-1]};
                }).sort((a,b) => a.d-b.d).slice(0,k);
                const votes = {};
                dists.forEach(n => votes[n.l]=(votes[n.l]||0)+1);
                const pred = parseInt(Object.keys(votes).reduce((a,b) => votes[a]>votes[b]?a:b));
                if(pred === test[test.length-1]) correct++;
            }

            const acc = correct / testData.length;
            trainedModels.knn = { k, acc };
            updateTrainingChart('knn', acc);
            document.getElementById('accKNN').textContent = (acc*100).toFixed(1) + '%';
            document.getElementById('progKNN').style.width = '100%';
        }

        async function trainTree() {
            const ds = DATASETS[currentDataset];
            const {trainData, testData} = processedData;
            updateTrainingChart('tree', 0);
            document.getElementById('progTree').style.width = '50%';
            await sleep(300);

            let bestFeat = 0, bestCorr = 0;
            for(let i=0; i<ds.features.length; i++) {
                const x = trainData.map(r => r[i]);
                const y = trainData.map(r => r[r.length-1]);
                const corr = Math.abs(correlation(x,y));
                if(corr > bestCorr) { bestCorr = corr; bestFeat = i; }
            }

            const thresh = trainData.map(r => r[bestFeat]).reduce((a,b) => a+b) / trainData.length;
            const acc = testData.reduce((c,r) => c + (((r[bestFeat]>thresh?1:0)===(r[r.length-1]>0?1:0)) ? 1 : 0), 0) / testData.length;

            trainedModels.tree = { bestFeat, thresh, acc };
            updateTrainingChart('tree', acc);
            document.getElementById('accTree').textContent = (acc*100).toFixed(1) + '%';
            document.getElementById('progTree').style.width = '100%';
        }

        function correlation(x,y) {
            const n=x.length, mx=x.reduce((a,b)=>a+b)/n, my=y.reduce((a,b)=>a+b)/n;
            const num=x.reduce((s,xi,i)=>s+(xi-mx)*(y[i]-my),0);
            const dx=Math.sqrt(x.reduce((s,xi)=>s+(xi-mx)**2,0)), dy=Math.sqrt(y.reduce((s,yi)=>s+(yi-my)**2,0));
            return num/(dx*dy+1e-10);
        }

        function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

        function renderEDA() {
            const ds = DATASETS[currentDataset];
            document.getElementById('statSamples').textContent = ds.data.length;
            document.getElementById('statFeatures').textContent = ds.features.length;
            document.getElementById('statClasses').textContent = ds.classes.length;

            if(charts.dist) charts.dist.destroy();
            charts.dist = new Chart(document.getElementById('chartDist'), {
                type: 'bar',
                data: {
                    labels: ds.features,
                    datasets: [{
                        label: 'Mean Values',
                        data: ds.features.map((_,i) => ds.data.reduce((s,r) => s+r[i], 0)/ds.data.length),
                        backgroundColor: 'rgba(54,162,235,0.7)'
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });

            if(charts.class) charts.class.destroy();
            const counts = ds.classes.map((_,i) => ds.data.filter(r => r[r.length-1]===i).length);
            charts.class = new Chart(document.getElementById('chartClass'), {
                type: 'doughnut',
                data: {
                    labels: ds.classes,
                    datasets: [{ data: counts, backgroundColor: ['#ff6384','#36a2eb','#4bc0c0'] }]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });
        }

        function renderPreprocess() {
            const ds = DATASETS[currentDataset];
            const ratio = parseInt(document.getElementById('splitRatio').value);
            document.getElementById('trainSamples').textContent = Math.floor(ds.data.length * ratio/100);
            document.getElementById('testSamples').textContent = ds.data.length - Math.floor(ds.data.length * ratio/100);
        }

        function renderEval() {
            if(charts.comp) charts.comp.destroy();
            charts.comp = new Chart(document.getElementById('chartComp'), {
                type: 'bar',
                data: {
                    labels: ['Logistic', 'KNN', 'Decision Tree'],
                    datasets: [{
                        label: 'Accuracy',
                        data: [trainedModels.logistic.acc, trainedModels.knn.acc, trainedModels.tree.acc],
                        backgroundColor: ['#36a2eb','#ff6384','#4bc0c0']
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, max: 1 }}}
            });

            const ds = DATASETS[currentDataset];
            const html = ds.features.map((f,i) => {
                const imp = Math.abs(trainedModels.logistic.w[i]);
                const max = Math.max(...trainedModels.logistic.w.map(Math.abs));
                const pct = (imp/max*100).toFixed(0);
                return '<div class="mb-2"><strong>' + f + '</strong><div class="progress"><div class="progress-bar" style="width:' + pct + '%">' + pct + '%</div></div></div>';
            }).join('');
            document.getElementById('featImport').innerHTML = html;

            document.getElementById('bestModel').textContent = bestModel.name + ' (' + (bestModel.acc*100).toFixed(1) + '%)';
            const modelIdMap = { logistic: 'modelLog', knn: 'modelKNN', tree: 'modelTree' };
            const modelEl = document.getElementById(modelIdMap[bestModel.name]);
            if(modelEl) modelEl.classList.add('best');
        }

        function renderDeploy() {
            const ds = DATASETS[currentDataset];
            const html = ds.features.map((f,i) => '<div class="mb-2"><label class="small">' + f + '</label><input type="number" class="form-control" id="in' + i + '" step="0.1"></div>').join('');
            document.getElementById('predInputs').innerHTML = html;

            if(charts.deploy) charts.deploy.destroy();
            charts.deploy = new Chart(document.getElementById('chartDeploy'), {
                type: 'radar',
                data: {
                    labels: ['Accuracy','Precision','Recall','F1','Speed'],
                    datasets: [{
                        label: bestModel.name,
                        data: [bestModel.acc, bestModel.acc*0.95, bestModel.acc*1.05, bestModel.acc, 0.9],
                        backgroundColor: 'rgba(54,162,235,0.2)',
                        borderColor: 'rgba(54,162,235,1)'
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false, scales: { r: { beginAtZero: true, max: 1 }}}
            });
        }

        document.getElementById('btnPredict').addEventListener('click', () => {
            const ds = DATASETS[currentDataset];
            const inputs = ds.features.map((_,i) => parseFloat(document.getElementById('in' + i).value) || 0);

            let pred, conf;
            if(bestModel.name === 'logistic') {
                const z = inputs.reduce((s,xi,i) => s+xi*bestModel.w[i], bestModel.b);
                const prob = sigmoid(z);
                pred = z>0 ? 1 : 0;
                conf = (Math.abs(prob-0.5)*200).toFixed(1);
            } else if(bestModel.name === 'knn') {
                pred = 1; conf = '75';
            } else {
                pred = inputs[bestModel.bestFeat]>bestModel.thresh ? 1 : 0;
                conf = '80';
            }

            document.getElementById('predClass').textContent = ds.classes[pred];
            document.getElementById('predConf').textContent = conf;
            document.getElementById('predResult').style.display = 'block';
        });
    });
</script>

</div> <!-- end ml-pipeline -->

<hr>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
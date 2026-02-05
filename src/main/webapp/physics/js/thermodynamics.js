(function () {
    'use strict';

    var R = 8.314; // J/(mol·K)

    function initTabs() {
        var tabs = document.querySelectorAll('.td-tab');
        var panels = document.querySelectorAll('.td-panel');
        tabs.forEach(function (t) {
            t.addEventListener('click', function () {
                var tabId = t.getAttribute('data-tab');
                tabs.forEach(function (x) { x.classList.remove('active'); });
                panels.forEach(function (p) {
                    p.classList.remove('active');
                    if (p.id === 'panel-' + tabId) p.classList.add('active');
                });
                t.classList.add('active');
            });
        });
    }

    function calcWork() {
        var process = document.getElementById('td-work-process').value;
        var P = parseFloat(document.getElementById('td-p').value) || 101325;
        var dV = parseFloat(document.getElementById('td-dv').value) || 0.001;
        var n = parseFloat(document.getElementById('td-n').value) || 1;
        var T = parseFloat(document.getElementById('td-t').value) || 300;
        var gamma = parseFloat(document.getElementById('td-gamma').value) || 1.4;
        var Vi = parseFloat(document.getElementById('td-vi').value) || 0.024;
        var Vf = parseFloat(document.getElementById('td-vf').value) || 0.048;

        var W = 0;
        if (process === 'isobaric') {
            W = P * dV;
        } else if (process === 'isochoric') {
            W = 0;
        } else if (process === 'isothermal') {
            if (Vi > 0 && Vf > 0) W = n * R * T * Math.log(Vf / Vi);
        } else if (process === 'adiabatic') {
            var Pi = P;
            var Pf = Pi * Math.pow(Vi / Vf, gamma);
            W = (Pi * Vi - Pf * Vf) / (gamma - 1);
        }
        var el = document.getElementById('td-work-result');
        if (el) el.textContent = 'W = ' + (W.toFixed(2)) + ' J';
    }

    function calcU() {
        var n = parseFloat(document.getElementById('td-u-n').value) || 1;
        var T = parseFloat(document.getElementById('td-u-t').value) || 300;
        var gas = document.getElementById('td-u-gas').value;
        var Cv = gas === 'mono' ? 1.5 * R : gas === 'di' ? 2.5 * R : 3 * R;
        var U = n * Cv * T;
        var el = document.getElementById('td-u-result');
        if (el) el.textContent = 'U = ' + U.toFixed(2) + ' J';
    }

    function calcS() {
        var n = parseFloat(document.getElementById('td-s-n').value) || 1;
        var Ti = parseFloat(document.getElementById('td-s-ti').value) || 300;
        var Tf = parseFloat(document.getElementById('td-s-tf').value) || 600;
        var Vi = parseFloat(document.getElementById('td-s-vi').value) || 0.02;
        var Vf = parseFloat(document.getElementById('td-s-vf').value) || 0.04;
        var Cv = 2.5 * R; // diatomic default
        var dS = n * Cv * Math.log(Tf / Ti) + n * R * Math.log(Vf / Vi);
        var el = document.getElementById('td-s-result');
        if (el) el.textContent = 'ΔS = ' + dS.toFixed(2) + ' J/K';
    }

    function calcKinetic() {
        var T = parseFloat(document.getElementById('td-kt-t').value) || 300;
        var M = parseFloat(document.getElementById('td-kt-m').value) || 0.029;
        var rho = parseFloat(document.getElementById('td-kt-rho').value) || 1.2;
        var v_rms = Math.sqrt(3 * R * T / M);
        var v_avg = Math.sqrt(8 * R * T / (Math.PI * M));
        var v_mp = Math.sqrt(2 * R * T / M);
        var P = (1 / 3) * rho * v_rms * v_rms;
        var el = document.getElementById('td-kinetic-result');
        if (el) {
            el.innerHTML = 'v_rms = ' + v_rms.toFixed(0) + ' m/s &nbsp; v_avg = ' + v_avg.toFixed(0) + ' m/s &nbsp; v_mp = ' + v_mp.toFixed(0) + ' m/s &nbsp; P = ' + P.toFixed(0) + ' Pa';
        }
    }

    function runThermo() {
        var active = document.querySelector('.td-tab.active');
        var tab = active ? active.getAttribute('data-tab') : 'firstlaw';
        if (tab === 'firstlaw') calcWork();
        else if (tab === 'specificheats') calcU();
        else if (tab === 'secondlaw') calcS();
        else if (tab === 'kinetic') calcKinetic();
    }

    window.runThermo = runThermo;
    document.addEventListener('DOMContentLoaded', function () {
        initTabs();
        calcWork();
    });
})();

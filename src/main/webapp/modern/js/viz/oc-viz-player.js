/**
 * Playback controller for viz step snapshots.
 */
(function (global) {
    'use strict';

    var SPEEDS = [
        { label: '0.25×', ms: 1200 },
        { label: '0.5×', ms: 600 },
        { label: '1×', ms: 300 },
        { label: '2×', ms: 150 },
        { label: '4×', ms: 75 }
    ];

    function createPlayer(opts) {
        var steps = opts.steps || [];
        var index = 0;
        var playing = false;
        var timer = null;
        var speedIdx = 2;
        var onStep = opts.onStep || function () {};
        var onPlayingChange = opts.onPlayingChange || function () {};

        function clamp(i) {
            if (i < 0) return 0;
            if (i >= steps.length) return Math.max(0, steps.length - 1);
            return i;
        }

        function emit() {
            onStep(index, steps[index], steps.length);
        }

        function clearTimer() {
            if (timer) {
                clearInterval(timer);
                timer = null;
            }
        }

        function setPlaying(p) {
            playing = p;
            onPlayingChange(playing);
        }

        function tick() {
            if (index >= steps.length - 1) {
                pause();
                return;
            }
            goTo(index + 1);
        }

        function play() {
            if (!steps.length) return;
            if (index >= steps.length - 1) {
                goTo(0);
            }
            clearTimer();
            setPlaying(true);
            timer = setInterval(tick, SPEEDS[speedIdx].ms);
            emit();
        }

        function pause() {
            clearTimer();
            setPlaying(false);
        }

        function togglePlay() {
            if (playing) pause();
            else play();
        }

        function goTo(i) {
            index = clamp(i);
            emit();
            if (playing && index >= steps.length - 1) {
                pause();
            }
        }

        function stepForward() {
            pause();
            goTo(index + 1);
        }

        function stepBack() {
            pause();
            goTo(index - 1);
        }

        function setSpeed(idx) {
            speedIdx = Math.max(0, Math.min(SPEEDS.length - 1, idx));
            if (playing) {
                clearTimer();
                timer = setInterval(tick, SPEEDS[speedIdx].ms);
            }
        }

        function setSteps(newSteps) {
            pause();
            steps = newSteps || [];
            index = 0;
            emit();
        }

        function destroy() {
            pause();
        }

        return {
            play: play,
            pause: pause,
            togglePlay: togglePlay,
            stepForward: stepForward,
            stepBack: stepBack,
            goTo: goTo,
            setSpeed: setSpeed,
            setSteps: setSteps,
            destroy: destroy,
            getIndex: function () { return index; },
            getCount: function () { return steps.length; },
            isPlaying: function () { return playing; },
            getSpeedMs: function () { return SPEEDS[speedIdx].ms; },
            getSpeedIndex: function () { return speedIdx; },
            SPEEDS: SPEEDS
        };
    }

    global.OcViz = global.OcViz || {};
    global.OcViz.createPlayer = createPlayer;
    global.OcViz.PLAYBACK_SPEEDS = SPEEDS;
}(typeof window !== 'undefined' ? window : this));

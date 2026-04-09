/* NN-SVG Utility Functions
   Adapted from NN-SVG by Alexander LeNail (MIT License) */

'use strict';

var NNUtil = (function() {

    function nWise(n, array) {
        var iterators = Array(n).fill().map(function() { return array[Symbol.iterator](); });
        iterators.forEach(function(it, index) { Array(index).fill().forEach(function() { it.next(); }); });
        return Array(array.length - n + 1).fill().map(function() {
            return iterators.map(function(it) { return it.next().value; });
        });
    }

    function pairWise(array) { return nWise(2, array); }

    function sum(arr) { return arr.reduce(function(a, b) { return a + b; }, 0); }

    function range(n) { return Array.from({length: n}, function(_, i) { return i; }); }

    function rand(min, max) { return Math.random() * (max - min) + min; }

    function flatten(array) {
        return array.reduce(function(flat, toFlatten) {
            return flat.concat(Array.isArray(toFlatten) ? flatten(toFlatten) : toFlatten);
        }, []);
    }

    function last(arr) { return arr[arr.length - 1]; }

    return {
        nWise: nWise,
        pairWise: pairWise,
        sum: sum,
        range: range,
        rand: rand,
        flatten: flatten,
        last: last
    };

})();

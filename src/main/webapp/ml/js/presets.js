/* NN Architecture Presets — One-click famous architectures */

'use strict';

var NNPresets = (function() {

    var fcnn = {
        'Simple Classifier': { layers: [4, 8, 3], spacing: [20, 20, 20] },
        'Deep MLP': { layers: [16, 32, 16, 8, 1], spacing: [15, 12, 15, 20, 20] },
        'Autoencoder': { layers: [12, 8, 4, 8, 12], spacing: [18, 18, 18, 18, 18] },
        'XOR Network': { layers: [2, 4, 1], spacing: [30, 30, 30] },
        'MNIST Classifier': { layers: [28, 16, 16, 10], spacing: [8, 15, 15, 20] },
        'Wide & Shallow': { layers: [8, 32, 8], spacing: [15, 8, 15] },
        'Funnel': { layers: [20, 15, 10, 5, 1], spacing: [12, 14, 16, 20, 20] },
        'Diamond': { layers: [4, 8, 16, 8, 4], spacing: [18, 14, 10, 14, 18] }
    };

    var lenet = {
        'LeNet-5': {
            conv: [
                { numberOfSquares: 1, squareHeight: 32, squareWidth: 32, filterHeight: 5, filterWidth: 5, op: 'Convolution' },
                { numberOfSquares: 6, squareHeight: 28, squareWidth: 28, filterHeight: 2, filterWidth: 2, op: 'Max-Pool' },
                { numberOfSquares: 6, squareHeight: 14, squareWidth: 14, filterHeight: 5, filterWidth: 5, op: 'Convolution' },
                { numberOfSquares: 16, squareHeight: 10, squareWidth: 10, filterHeight: 2, filterWidth: 2, op: 'Max-Pool' },
                { numberOfSquares: 16, squareHeight: 5, squareWidth: 5, filterHeight: 5, filterWidth: 5, op: 'Convolution' }
            ],
            fc: [120, 84, 10]
        },
        'Simple CNN': {
            conv: [
                { numberOfSquares: 1, squareHeight: 28, squareWidth: 28, filterHeight: 3, filterWidth: 3, op: 'Convolution' },
                { numberOfSquares: 8, squareHeight: 14, squareWidth: 14, filterHeight: 3, filterWidth: 3, op: 'Max-Pool' },
                { numberOfSquares: 16, squareHeight: 7, squareWidth: 7, filterHeight: 3, filterWidth: 3, op: 'Convolution' }
            ],
            fc: [64, 10]
        },
        'Deep CNN': {
            conv: [
                { numberOfSquares: 1, squareHeight: 32, squareWidth: 32, filterHeight: 3, filterWidth: 3, op: 'Convolution' },
                { numberOfSquares: 32, squareHeight: 30, squareWidth: 30, filterHeight: 3, filterWidth: 3, op: 'Convolution' },
                { numberOfSquares: 32, squareHeight: 15, squareWidth: 15, filterHeight: 2, filterWidth: 2, op: 'Max-Pool' },
                { numberOfSquares: 64, squareHeight: 13, squareWidth: 13, filterHeight: 3, filterWidth: 3, op: 'Convolution' },
                { numberOfSquares: 64, squareHeight: 6, squareWidth: 6, filterHeight: 2, filterWidth: 2, op: 'Max-Pool' }
            ],
            fc: [256, 128, 10]
        }
    };

    var alexnet = {
        'AlexNet': {
            conv: [
                { height: 227, width: 227, depth: 3, filterHeight: 11, filterWidth: 11 },
                { height: 55, width: 55, depth: 96, filterHeight: 5, filterWidth: 5 },
                { height: 27, width: 27, depth: 256, filterHeight: 3, filterWidth: 3 },
                { height: 13, width: 13, depth: 384, filterHeight: 3, filterWidth: 3 },
                { height: 13, width: 13, depth: 256, filterHeight: 3, filterWidth: 3 }
            ],
            fc: [4096, 4096, 1000]
        },
        'VGG-16': {
            conv: [
                { height: 224, width: 224, depth: 3, filterHeight: 3, filterWidth: 3 },
                { height: 224, width: 224, depth: 64, filterHeight: 3, filterWidth: 3 },
                { height: 112, width: 112, depth: 128, filterHeight: 3, filterWidth: 3 },
                { height: 56, width: 56, depth: 256, filterHeight: 3, filterWidth: 3 },
                { height: 28, width: 28, depth: 512, filterHeight: 3, filterWidth: 3 },
                { height: 14, width: 14, depth: 512, filterHeight: 3, filterWidth: 3 }
            ],
            fc: [4096, 4096, 1000]
        },
        'Small ConvNet': {
            conv: [
                { height: 32, width: 32, depth: 3, filterHeight: 5, filterWidth: 5 },
                { height: 28, width: 28, depth: 16, filterHeight: 3, filterWidth: 3 },
                { height: 14, width: 14, depth: 32, filterHeight: 3, filterWidth: 3 }
            ],
            fc: [128, 10]
        }
    };

    return {
        fcnn: fcnn,
        lenet: lenet,
        alexnet: alexnet
    };

})();

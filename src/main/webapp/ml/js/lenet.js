/* LeNet/CNN-2D Visualization — D3.js v7 port
   Adapted from NN-SVG by Alexander LeNail (MIT License) */

'use strict';

function LeNet(container) {

    var el = container || document.getElementById('nn-graph-container');
    var w = el.clientWidth || 800;
    var h = el.clientHeight || 600;

    var svg = d3.select(el).append('svg').attr('xmlns', 'http://www.w3.org/2000/svg');
    var g = svg.append('g');
    svg.style('cursor', 'move');

    var color1 = '#e0e0e0';
    var color2 = '#a0a0a0';
    var borderWidth = 1.0;
    var borderColor = 'black';
    var rectOpacity = 0.8;
    var betweenSquares = 8;
    var betweenLayers = [];
    var betweenLayersDefault = 12;

    var architecture = [];
    var architecture2 = [];
    var lenet = {};
    var layer_offsets = [];
    var largest_layer_width = 0;
    var showLabels = true;

    var sqrtLength = false;
    var lengthScale = 100;

    var lengthFn = function(length) { return sqrtLength ? (Math.sqrt(length) * lengthScale / 10) : (length * lengthScale / 100); };

    var textFn = function(layer) {
        return (typeof layer === 'object' ? layer.numberOfSquares + '@' + layer.squareHeight + 'x' + layer.squareWidth : '1x' + layer);
    };

    var rect, conv, link, poly, line, text, info;

    // ── Methods ──

    function redraw(opts) {
        opts = opts || {};
        architecture = opts.architecture_ !== undefined ? opts.architecture_ : architecture;
        architecture2 = opts.architecture2_ !== undefined ? opts.architecture2_ : architecture2;
        sqrtLength = opts.sqrtLength_ !== undefined ? opts.sqrtLength_ : sqrtLength;
        lengthScale = opts.lengthScale_ !== undefined ? opts.lengthScale_ : lengthScale;

        lenet.rects = architecture.map(function(layer, layer_index) {
            return NNUtil.range(layer.numberOfSquares).map(function(rect_index) {
                return {id: layer_index + '_' + rect_index, layer: layer_index, rect_index: rect_index, width: layer.squareWidth, height: layer.squareHeight};
            });
        });
        lenet.rects = NNUtil.flatten(lenet.rects);

        lenet.convs = architecture.map(function(layer, layer_index) {
            return Object.assign({id: 'conv_' + layer_index, layer: layer_index}, layer);
        });
        lenet.convs.pop();
        lenet.convs = lenet.convs.map(function(c) {
            return Object.assign({x_rel: NNUtil.rand(0.1, 0.9), y_rel: NNUtil.rand(0.1, 0.9)}, c);
        });

        lenet.conv_links = lenet.convs.map(function(c) {
            return [Object.assign({id: 'link_' + c.layer + '_0', i: 0}, c), Object.assign({id: 'link_' + c.layer + '_1', i: 1}, c)];
        });
        lenet.conv_links = NNUtil.flatten(lenet.conv_links);

        lenet.fc_layers = architecture2.map(function(size, fc_layer_index) {
            return {id: 'fc_' + fc_layer_index, layer: fc_layer_index + architecture.length, size: lengthFn(size)};
        });
        lenet.fc_links = lenet.fc_layers.map(function(fc) {
            return [Object.assign({id: 'link_' + fc.layer + '_0', i: 0, prevSize: 10}, fc), Object.assign({id: 'link_' + fc.layer + '_1', i: 1, prevSize: 10}, fc)];
        });
        lenet.fc_links = NNUtil.flatten(lenet.fc_links);

        if (lenet.rects.length > 0 && lenet.fc_layers.length > 0) {
            lenet.fc_links[0].prevSize = 0;
            lenet.fc_links[1].prevSize = NNUtil.last(lenet.rects).width;
        }

        var label = architecture.map(function(layer, layer_index) {
            return {id: 'data_' + layer_index + '_label', layer: layer_index, text: textFn(layer)};
        }).concat(architecture2.map(function(layer, layer_index) {
            return {id: 'data_' + (layer_index + architecture.length) + '_label', layer: layer_index + architecture.length, text: textFn(layer)};
        }));

        g.selectAll('*').remove();

        rect = g.selectAll('.rect')
            .data(lenet.rects).enter()
            .append('rect').attr('class', 'rect').attr('id', function(d) { return d.id; })
            .attr('width', function(d) { return d.width; }).attr('height', function(d) { return d.height; });

        conv = g.selectAll('.conv')
            .data(lenet.convs).enter()
            .append('rect').attr('class', 'conv').attr('id', function(d) { return d.id; })
            .attr('width', function(d) { return d.filterWidth; }).attr('height', function(d) { return d.filterHeight; })
            .style('fill-opacity', 0);

        link = g.selectAll('.link')
            .data(lenet.conv_links).enter()
            .append('line').attr('class', 'link').attr('id', function(d) { return d.id; });

        poly = g.selectAll('.poly')
            .data(lenet.fc_layers).enter()
            .append('polygon').attr('class', 'poly').attr('id', function(d) { return d.id; });

        line = g.selectAll('.line')
            .data(lenet.fc_links).enter()
            .append('line').attr('class', 'line').attr('id', function(d) { return d.id; });

        text = g.selectAll('.text')
            .data(architecture).enter()
            .append('text')
            .text(function(d) { return showLabels ? d.op : ''; })
            .attr('class', 'text').attr('dy', '.35em')
            .style('font-size', '16px').attr('font-family', 'sans-serif');

        info = g.selectAll('.info')
            .data(label).enter()
            .append('text')
            .text(function(d) { return showLabels ? d.text : ''; })
            .attr('class', 'info').attr('dy', '-0.3em')
            .style('font-size', '16px').attr('font-family', 'sans-serif');

        style();
    }

    function redistribute(opts) {
        opts = opts || {};
        betweenLayers = opts.betweenLayers_ !== undefined ? opts.betweenLayers_ : betweenLayers;
        betweenSquares = opts.betweenSquares_ !== undefined ? opts.betweenSquares_ : betweenSquares;

        var layer_widths = architecture.map(function(layer) {
            return (layer.numberOfSquares - 1) * betweenSquares + layer.squareWidth;
        });
        layer_widths = layer_widths.concat(lenet.fc_layers.map(function(layer) { return layer.size; })).concat([0]);

        largest_layer_width = Math.max.apply(null, layer_widths);

        var layer_x_offsets = layer_widths.reduce(function(offsets, lw, i) {
            return offsets.concat([NNUtil.last(offsets) + lw + (betweenLayers[i] || betweenLayersDefault)]);
        }, [0]).concat([0]);
        var layer_y_offsets = layer_widths.map(function(lw) { return (largest_layer_width - lw) / 2; }).concat([0]);

        var screen_center_x = w / 2 - architecture.length * largest_layer_width / 2;
        var screen_center_y = h / 2 - largest_layer_width / 2;

        var x = function(layer, node_index) { return layer_x_offsets[layer] + (node_index * betweenSquares) + screen_center_x; };
        var y = function(layer, node_index) { return layer_y_offsets[layer] + (node_index * betweenSquares) + screen_center_y; };

        rect.attr('x', function(d) { return x(d.layer, d.rect_index); })
            .attr('y', function(d) { return y(d.layer, d.rect_index); });

        var xc = function(d) { return layer_x_offsets[d.layer] + ((d.numberOfSquares - 1) * betweenSquares) + (d.x_rel * (d.squareWidth - d.filterWidth)) + screen_center_x; };
        var yc = function(d) { return layer_y_offsets[d.layer] + ((d.numberOfSquares - 1) * betweenSquares) + (d.y_rel * (d.squareHeight - d.filterHeight)) + screen_center_y; };

        conv.attr('x', function(d) { return xc(d); })
            .attr('y', function(d) { return yc(d); });

        link.attr('x1', function(d) { return xc(d) + d.filterWidth; })
            .attr('y1', function(d) { return yc(d) + (d.i ? 0 : d.filterHeight); })
            .attr('x2', function(d) { return layer_x_offsets[d.layer + 1] + ((architecture[d.layer + 1].numberOfSquares - 1) * betweenSquares) + architecture[d.layer + 1].squareWidth * d.x_rel + screen_center_x; })
            .attr('y2', function(d) { return layer_y_offsets[d.layer + 1] + ((architecture[d.layer + 1].numberOfSquares - 1) * betweenSquares) + architecture[d.layer + 1].squareHeight * d.y_rel + screen_center_y; });

        poly.attr('points', function(d) {
            var lxo = layer_x_offsets[d.layer] + screen_center_x;
            var lyo = layer_y_offsets[d.layer] + screen_center_y;
            return lxo + ',' + lyo +
                ' ' + (lxo + 10) + ',' + lyo +
                ' ' + (lxo + d.size + 10) + ',' + (lyo + d.size) +
                ' ' + (lxo + d.size) + ',' + (lyo + d.size);
        });

        line.attr('x1', function(d) { return layer_x_offsets[d.layer - 1] + (d.i ? 0 : layer_widths[d.layer - 1]) + d.prevSize + screen_center_x; })
            .attr('y1', function(d) { return layer_y_offsets[d.layer - 1] + (d.i ? 0 : layer_widths[d.layer - 1]) + screen_center_y; })
            .attr('x2', function(d) { return layer_x_offsets[d.layer] + (d.i ? 0 : d.size) + screen_center_x; })
            .attr('y2', function(d) { return layer_y_offsets[d.layer] + (d.i ? 0 : d.size) + screen_center_y; })
            .style('opacity', function(d) { return +(d.layer > 0); });

        text.attr('x', function(d, i) { return (layer_x_offsets[i] + layer_widths[i] + layer_x_offsets[i + 1] + layer_widths[i + 1] / 2) / 2 + screen_center_x - 15; })
            .attr('y', function() { return layer_y_offsets[0] + screen_center_y + largest_layer_width; })
            .style('opacity', function(d, i) { return +(i + 1 < architecture.length || architecture2.length > 0); });

        info.attr('x', function(d) { return layer_x_offsets[d.layer] + screen_center_x; })
            .attr('y', function(d) { return layer_y_offsets[d.layer] + screen_center_y - 15; });
    }

    function style(opts) {
        opts = opts || {};
        color1 = opts.color1_ !== undefined ? opts.color1_ : color1;
        color2 = opts.color2_ !== undefined ? opts.color2_ : color2;
        borderWidth = opts.borderWidth_ !== undefined ? opts.borderWidth_ : borderWidth;
        rectOpacity = opts.rectOpacity_ !== undefined ? opts.rectOpacity_ : rectOpacity;
        showLabels = opts.showLabels_ !== undefined ? opts.showLabels_ : showLabels;

        rect.style('fill', function(d) { return d.rect_index % 2 ? color1 : color2; });
        poly.style('fill', color1);

        rect.style('stroke', borderColor);
        conv.style('stroke', borderColor);
        link.style('stroke', borderColor);
        poly.style('stroke', borderColor);
        line.style('stroke', borderColor);

        rect.style('stroke-width', borderWidth);
        conv.style('stroke-width', borderWidth);
        link.style('stroke-width', borderWidth / 2);
        poly.style('stroke-width', borderWidth);
        line.style('stroke-width', borderWidth / 2);

        rect.style('opacity', rectOpacity);
        conv.style('stroke-opacity', rectOpacity);
        link.style('stroke-opacity', rectOpacity);
        poly.style('opacity', rectOpacity);
        line.style('stroke-opacity', rectOpacity);

        text.text(function(d) { return showLabels ? d.op : ''; });
        info.text(function(d) { return showLabels ? d.text : ''; });
    }

    // ── Zoom & Resize ──

    svg.call(d3.zoom()
        .scaleExtent([1 / 2, 8])
        .on('zoom', function(event) { g.attr('transform', event.transform); }));

    function resize() {
        w = el.clientWidth || 800;
        h = el.clientHeight || 600;
        svg.attr('width', w).attr('height', h);
    }

    var ro = new ResizeObserver(function() { resize(); redistribute(); });
    ro.observe(el);

    resize();

    function destroy() {
        ro.disconnect();
        svg.remove();
    }

    return {
        redraw: redraw,
        redistribute: redistribute,
        style: style,
        resize: resize,
        destroy: destroy,
        g: function() { return g; },
        svg: function() { return svg; }
    };
}

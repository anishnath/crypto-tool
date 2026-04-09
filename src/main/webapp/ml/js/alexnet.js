/* AlexNet/CNN-3D Visualization — Three.js modern port
   Adapted from NN-SVG by Alexander LeNail (MIT License) */

'use strict';

function AlexNet(container) {

    var el = container || document.getElementById('nn-graph-container');
    var w = el.clientWidth || 800;
    var h = el.clientHeight || 600;

    var color1 = '#eeeeee';
    var color2 = '#99ddff';
    var color3 = '#ffbbbb';

    var rectOpacity = 0.4;
    var filterOpacity = 0.4;
    var imageOpacity = 0.5;
    var imageFlip = false;
    var fontScale = 1;

    var line_material = new THREE.LineBasicMaterial({color: 0x000000});
    var image_material = new THREE.MeshBasicMaterial({side: THREE.DoubleSide, transparent: true, opacity: imageOpacity, depthWrite: false});
    var box_material = new THREE.MeshBasicMaterial({color: color1, side: THREE.DoubleSide, transparent: true, opacity: rectOpacity, depthWrite: false});
    var conv_material = new THREE.MeshBasicMaterial({color: color2, side: THREE.DoubleSide, transparent: true, opacity: filterOpacity, depthWrite: false});
    var pyra_material = new THREE.MeshBasicMaterial({color: color3, side: THREE.DoubleSide, transparent: true, opacity: filterOpacity, depthWrite: false});

    var architecture = [];
    var architecture2 = [];
    var inputImage = null;
    var betweenLayers = 20;

    var logDepth = true;
    var depthScale = 10;
    var logWidth = true;
    var widthScale = 10;
    var logConvSize = false;
    var convScale = 1;

    var showDims = false;
    var showConvDims = false;

    var depthFn = function(depth) { return logDepth ? (Math.log(depth) * depthScale) : (depth * depthScale); };
    var widthFn = function(width) { return logWidth ? (Math.log(width) * widthScale) : (width * widthScale); };
    var convFn = function(conv) { return logConvSize ? (Math.log(conv) * convScale) : (conv * convScale); };

    function wf(layer) { return widthFn(layer.width); }
    function hf(layer) { return widthFn(layer.height); }

    var layers = new THREE.Group();
    var convs = new THREE.Group();
    var pyramids = new THREE.Group();
    var sprites = new THREE.Group();

    var scene = new THREE.Scene();
    scene.background = new THREE.Color(0xffffff);

    var camera = new THREE.OrthographicCamera(w / -2, w / 2, h / 2, h / -2, -10000000, 10000000);
    camera.position.set(-219, 92, 84);

    var renderer;
    var rendererType = 'webgl';
    var controls;
    var animId;

    // ── Pyramid geometry helper (replaces deprecated THREE.Geometry) ──

    function createPyramidGeometry(baseVerts, summit) {
        // baseVerts: array of 4 THREE.Vector3, summit: THREE.Vector3
        var positions = new Float32Array([
            baseVerts[0].x, baseVerts[0].y, baseVerts[0].z,
            baseVerts[1].x, baseVerts[1].y, baseVerts[1].z,
            baseVerts[2].x, baseVerts[2].y, baseVerts[2].z,
            baseVerts[3].x, baseVerts[3].y, baseVerts[3].z,
            summit.x, summit.y, summit.z
        ]);
        var indices = [
            0, 1, 2,  0, 2, 3,   // base
            1, 0, 4,  2, 1, 4,   // sides
            3, 2, 4,  0, 3, 4
        ];
        var geom = new THREE.BufferGeometry();
        geom.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
        geom.setIndex(indices);
        geom.computeVertexNormals();
        return geom;
    }

    // ── Text sprite helper ──

    function makeTextSprite(message, copy_pos, sub_pos) {
        var canvas = document.createElement('canvas');
        var context = canvas.getContext('2d');
        var fontsize = 120;
        context.font = fontsize + 'px Helvetica';
        context.fillStyle = 'rgba(0, 0, 0, 1.0)';
        context.fillText(message, 0, fontsize);

        var texture = new THREE.CanvasTexture(canvas);
        texture.minFilter = THREE.LinearFilter;
        var spriteMaterial = new THREE.SpriteMaterial({map: texture});
        var sprite = new THREE.Sprite(spriteMaterial);
        sprite.scale.set(10 * fontScale, 5 * fontScale, 1.0);
        sprite.center.set(0, 1);
        sprite.position.copy(copy_pos).sub(sub_pos);
        sprites.add(sprite);
    }

    // ── Methods ──

    function restartRenderer(opts) {
        opts = opts || {};
        rendererType = opts.rendererType_ !== undefined ? opts.rendererType_ : rendererType;

        clearThree(scene);

        if (animId) { cancelAnimationFrame(animId); animId = null; }

        renderer = new THREE.WebGLRenderer({alpha: true});

        renderer.setPixelRatio(window.devicePixelRatio || 1);
        renderer.setSize(w, h);

        while (el.firstChild) { el.removeChild(el.firstChild); }
        el.appendChild(renderer.domElement);

        if (controls) { controls.dispose(); }
        controls = new THREE.OrbitControls(camera, renderer.domElement);

        animate();
    }

    function animate() {
        animId = requestAnimationFrame(animate);
        sprites.children.forEach(function(sprite) {
            sprite.quaternion.copy(camera.quaternion);
        });
        renderer.render(scene, camera);
    }

    restartRenderer();

    function redraw(opts) {
        opts = opts || {};
        architecture = opts.architecture_ !== undefined ? opts.architecture_ : architecture;
        architecture2 = opts.architecture2_ !== undefined ? opts.architecture2_ : architecture2;
        inputImage = opts.inputimage_ !== undefined ? opts.inputimage_ : inputImage;
        betweenLayers = opts.betweenLayers_ !== undefined ? opts.betweenLayers_ : betweenLayers;
        logDepth = opts.logDepth_ !== undefined ? opts.logDepth_ : logDepth;
        depthScale = opts.depthScale_ !== undefined ? opts.depthScale_ : depthScale;
        logWidth = opts.logWidth_ !== undefined ? opts.logWidth_ : logWidth;
        widthScale = opts.widthScale_ !== undefined ? opts.widthScale_ : widthScale;
        logConvSize = opts.logConvSize_ !== undefined ? opts.logConvSize_ : logConvSize;
        convScale = opts.convScale_ !== undefined ? opts.convScale_ : convScale;
        showDims = opts.showDims_ !== undefined ? opts.showDims_ : showDims;
        showConvDims = opts.showConvDims_ !== undefined ? opts.showConvDims_ : showConvDims;

        depthFn = function(depth) { return logDepth ? (Math.log(depth) * depthScale) : (depth * depthScale); };
        widthFn = function(width) { return logWidth ? (Math.log(width) * widthScale) : (width * widthScale); };
        convFn = function(conv) { return logConvSize ? (Math.log(conv) * convScale) : (conv * convScale); };

        clearThree(scene);

        // Reset groups to avoid geometry accumulation across redraws
        [layers, convs, pyramids, sprites].forEach(function(grp) {
            while (grp.children.length > 0) {
                var child = grp.children[0];
                if (child.geometry) child.geometry.dispose();
                grp.remove(child);
            }
        });

        var z_offset = -(NNUtil.sum(architecture.map(function(layer) { return depthFn(layer.depth); })) + (betweenLayers * (architecture.length - 1))) / 3;

        var layer_offsets = NNUtil.pairWise(architecture).reduce(function(offsets, pair) {
            return offsets.concat([NNUtil.last(offsets) + depthFn(pair[0].depth) / 2 + betweenLayers + depthFn(pair[1].depth) / 2]);
        }, [z_offset]);

        layer_offsets = layer_offsets.concat(architecture2.reduce(function(offsets) {
            return offsets.concat([NNUtil.last(offsets) + widthFn(2) + betweenLayers]);
        }, [NNUtil.last(layer_offsets) + depthFn(NNUtil.last(architecture).depth) / 2 + betweenLayers + widthFn(2)]));

        architecture.forEach(function(layer, index) {
            // Layer box
            var layer_geometry = new THREE.BoxGeometry(wf(layer), hf(layer), depthFn(layer.depth));
            var layer_object = new THREE.Mesh(layer_geometry, box_material);
            layer_object.position.set(0, 0, layer_offsets[index]);
            layers.add(layer_object);

            // Edges
            var layer_edges_geometry = new THREE.EdgesGeometry(layer_geometry);
            var layer_edges_object = new THREE.LineSegments(layer_edges_geometry, line_material);
            layer_edges_object.position.set(0, 0, layer_offsets[index]);
            layers.add(layer_edges_object);

            if (index < architecture.length - 1) {
                // Conv filter box
                var conv_geometry = new THREE.BoxGeometry(convFn(layer.filterWidth), convFn(layer.filterHeight), depthFn(layer.depth));
                var conv_object = new THREE.Mesh(conv_geometry, conv_material);
                conv_object.position.set(layer.rel_x * wf(layer), layer.rel_y * hf(layer), layer_offsets[index]);
                convs.add(conv_object);

                var conv_edges_geometry = new THREE.EdgesGeometry(conv_geometry);
                var conv_edges_object = new THREE.LineSegments(conv_edges_geometry, line_material);
                conv_edges_object.position.set(layer.rel_x * wf(layer), layer.rel_y * hf(layer), layer_offsets[index]);
                convs.add(conv_edges_object);

                // Pyramid (receptive field)
                var base_z = layer_offsets[index] + (depthFn(layer.depth) / 2);
                var summit_z = layer_offsets[index] + (depthFn(layer.depth) / 2) + betweenLayers;
                var next_layer_wh = widthFn(architecture[index + 1].width);

                var bv = [
                    new THREE.Vector3((layer.rel_x * wf(layer)) + (convFn(layer.filterWidth) / 2), (layer.rel_y * hf(layer)) + (convFn(layer.filterHeight) / 2), base_z),
                    new THREE.Vector3((layer.rel_x * wf(layer)) + (convFn(layer.filterWidth) / 2), (layer.rel_y * hf(layer)) - (convFn(layer.filterHeight) / 2), base_z),
                    new THREE.Vector3((layer.rel_x * wf(layer)) - (convFn(layer.filterWidth) / 2), (layer.rel_y * hf(layer)) - (convFn(layer.filterHeight) / 2), base_z),
                    new THREE.Vector3((layer.rel_x * wf(layer)) - (convFn(layer.filterWidth) / 2), (layer.rel_y * hf(layer)) + (convFn(layer.filterHeight) / 2), base_z)
                ];
                var summit = new THREE.Vector3(layer.rel_x * next_layer_wh, layer.rel_y * next_layer_wh, summit_z);

                var pyramid_geometry = createPyramidGeometry(bv, summit);
                var pyramid_object = new THREE.Mesh(pyramid_geometry, pyra_material);
                pyramids.add(pyramid_object);

                var pyramid_edges_geometry = new THREE.EdgesGeometry(pyramid_geometry);
                var pyramid_edges_object = new THREE.LineSegments(pyramid_edges_geometry, line_material);
                pyramids.add(pyramid_edges_object);

                if (showConvDims) {
                    makeTextSprite(layer.filterHeight.toString(), conv_object.position, new THREE.Vector3(convFn(layer.filterWidth) / 2, -3, depthFn(layer.depth) / 2 + 3));
                    makeTextSprite(layer.filterWidth.toString(), conv_object.position, new THREE.Vector3(-1, convFn(layer.filterHeight) / 2, depthFn(layer.depth) / 2 + 3));
                }
            }

            if (showDims) {
                makeTextSprite(layer.depth.toString(), layer_object.position, new THREE.Vector3(wf(layer) / 2 + 2, hf(layer) / 2 + 2, 0));
                makeTextSprite(layer.width.toString(), layer_object.position, new THREE.Vector3(wf(layer) / 2 + 3, 0, depthFn(layer.depth) / 2 + 3));
                makeTextSprite(layer.height.toString(), layer_object.position, new THREE.Vector3(0, -hf(layer) / 2 - 3, depthFn(layer.depth) / 2 + 3));
            }
        });

        architecture2.forEach(function(layer, index) {
            // Dense layer
            var layer_geometry = new THREE.BoxGeometry(widthFn(2), depthFn(layer), widthFn(2));
            var layer_object = new THREE.Mesh(layer_geometry, box_material);
            layer_object.position.set(0, 0, layer_offsets[architecture.length + index]);
            layers.add(layer_object);

            var layer_edges_geometry = new THREE.EdgesGeometry(layer_geometry);
            var layer_edges_object = new THREE.LineSegments(layer_edges_geometry, line_material);
            layer_edges_object.position.set(0, 0, layer_offsets[architecture.length + index]);
            layers.add(layer_edges_object);

            // Arrow
            var direction = new THREE.Vector3(0, 0, 1);
            var origin = new THREE.Vector3(0, 0, layer_offsets[architecture.length + index] - betweenLayers - widthFn(2) / 2 + 1);
            var length = betweenLayers - 2;
            var headLength = betweenLayers / 3;
            var headWidth = 5;
            var arrow = new THREE.ArrowHelper(direction, origin, length, 0x000000, headLength, headWidth);
            pyramids.add(arrow);

            if (showDims) {
                makeTextSprite(layer.toString(), layer_object.position, new THREE.Vector3(3, depthFn(layer) / 2 + 4, 3));
            }
        });

        scene.add(layers);
        scene.add(convs);
        scene.add(pyramids);
        scene.add(sprites);
    }

    function clearThree(obj) {
        while (obj.children.length > 0) {
            clearThree(obj.children[0]);
            obj.remove(obj.children[0]);
        }
        if (obj.geometry) { obj.geometry.dispose(); }
        if (obj.material) {
            if (Array.isArray(obj.material)) {
                obj.material.forEach(function(m) { if (m && m.dispose) m.dispose(); });
            } else if (obj.material.dispose) {
                obj.material.dispose();
            }
        }
        if (obj.texture) { obj.texture.dispose(); }
    }

    function style(opts) {
        opts = opts || {};
        color1 = opts.color1_ !== undefined ? opts.color1_ : color1;
        color2 = opts.color2_ !== undefined ? opts.color2_ : color2;
        color3 = opts.color3_ !== undefined ? opts.color3_ : color3;
        rectOpacity = opts.rectOpacity_ !== undefined ? opts.rectOpacity_ : rectOpacity;
        filterOpacity = opts.filterOpacity_ !== undefined ? opts.filterOpacity_ : filterOpacity;
        imageOpacity = opts.imageOpacity_ !== undefined ? opts.imageOpacity_ : imageOpacity;
        imageFlip = opts.imageFlip_ !== undefined ? opts.imageFlip_ : imageFlip;
        fontScale = opts.fontScale_ !== undefined ? opts.fontScale_ : fontScale;

        box_material.color = new THREE.Color(color1);
        conv_material.color = new THREE.Color(color2);
        pyra_material.color = new THREE.Color(color3);
        box_material.opacity = rectOpacity;
        image_material.opacity = imageOpacity;
        conv_material.opacity = filterOpacity;
        pyra_material.opacity = filterOpacity;
    }

    // ── Resize ──

    function onResize() {
        w = el.clientWidth || 800;
        h = el.clientHeight || 600;
        renderer.setSize(w, h);
        var camFactor = window.devicePixelRatio || 1;
        camera.left = -w / camFactor;
        camera.right = w / camFactor;
        camera.top = h / camFactor;
        camera.bottom = -h / camFactor;
        camera.updateProjectionMatrix();
    }

    var ro = new ResizeObserver(onResize);
    ro.observe(el);

    // ── Destroy ──

    function destroy() {
        if (animId) { cancelAnimationFrame(animId); animId = null; }
        if (controls) { controls.dispose(); }
        ro.disconnect();
        clearThree(scene);
        if (renderer && renderer.dispose) { renderer.dispose(); }
        while (el.firstChild) { el.removeChild(el.firstChild); }
    }

    return {
        redraw: redraw,
        restartRenderer: restartRenderer,
        style: style,
        destroy: destroy
    };
}

/**
 * Node.js test for Logisim .circ XML → 8gwifi JSON converter
 * Run: node test-logisim-import.mjs
 */
import { JSDOM } from 'jsdom';

// Inject browser globals for the module
const dom = new JSDOM('<!DOCTYPE html>');
global.window = dom.window;
global.document = dom.window.document;
global.DOMParser = dom.window.DOMParser;

// Load the module (it attaches to window.LogicSim)
import('./logisim-import.js');

// Wait for module to load
await new Promise(r => setTimeout(r, 100));

const parse = window.LogicSim.LogisimImport.parse;
let passed = 0;
let failed = 0;

function assert(condition, msg) {
    if (condition) {
        passed++;
        console.log('  PASS: ' + msg);
    } else {
        failed++;
        console.error('  FAIL: ' + msg);
    }
}

function test(name, fn) {
    console.log('\n' + name);
    try { fn(); } catch (e) { failed++; console.error('  ERROR: ' + e.message); }
}

// ── Test 1: Simple AND gate ──
test('Simple AND gate with 2 inputs and output', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="and_test">
        <comp lib="0" loc="(100,100)" name="Pin"><a name="label" val="A"/></comp>
        <comp lib="0" loc="(100,130)" name="Pin"><a name="label" val="B"/></comp>
        <comp lib="1" loc="(200,115)" name="AND Gate"/>
        <comp lib="0" loc="(260,115)" name="Pin"><a name="facing" val="west"/><a name="type" val="output"/><a name="label" val="Q"/></comp>
        <wire from="(120,100)" to="(150,100)"/>
        <wire from="(120,130)" to="(150,130)"/>
        <wire from="(150,100)" to="(150,105)"/>
        <wire from="(150,130)" to="(150,125)"/>
        <wire from="(200,115)" to="(240,115)"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(!result.error, 'No error');
    assert(result.components.length === 4, 'Has 4 components (2 inputs + AND + output), got ' + result.components.length);
    assert(result.components[0].type === 'INPUT', 'First is INPUT');
    assert(result.components[1].type === 'INPUT', 'Second is INPUT');
    assert(result.components[2].type === 'AND', 'Third is AND');
    assert(result.components[3].type === 'OUTPUT', 'Fourth is OUTPUT');
    assert(result.components[0].attrs.label === 'A', 'First label is A');
    assert(result.components[3].attrs.label === 'Q', 'Output label is Q');
    assert(result.wires.length > 0, 'Has wires, got ' + result.wires.length);
});

// ── Test 2: NOT gate ──
test('NOT gate', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="not_test">
        <comp lib="0" loc="(80,100)" name="Pin"><a name="label" val="IN"/></comp>
        <comp lib="1" loc="(160,100)" name="NOT Gate"/>
        <comp lib="0" loc="(220,100)" name="Pin"><a name="facing" val="west"/><a name="type" val="output"/><a name="label" val="OUT"/></comp>
        <wire from="(100,100)" to="(130,100)"/>
        <wire from="(160,100)" to="(200,100)"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 3, 'Has 3 components, got ' + result.components.length);
    assert(result.components[1].type === 'NOT', 'Middle is NOT');
});

// ── Test 3: OR gate with 4 inputs ──
test('4-input OR gate', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="or4_test">
        <comp lib="0" loc="(60,80)" name="Pin"><a name="label" val="A"/></comp>
        <comp lib="0" loc="(60,100)" name="Pin"><a name="label" val="B"/></comp>
        <comp lib="0" loc="(60,120)" name="Pin"><a name="label" val="C"/></comp>
        <comp lib="0" loc="(60,140)" name="Pin"><a name="label" val="D"/></comp>
        <comp lib="1" loc="(200,110)" name="OR Gate"><a name="inputs" val="4"/></comp>
        <comp lib="0" loc="(260,110)" name="Pin"><a name="facing" val="west"/><a name="type" val="output"/><a name="label" val="Y"/></comp>
        <wire from="(200,110)" to="(240,110)"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 6, 'Has 6 components, got ' + result.components.length);
    assert(result.components[4].type === 'OR', 'OR gate found');
    assert(result.components[4].attrs.inputs === 4, 'OR gate has inputs=4');
});

// ── Test 4: D Flip-Flop with clock ──
test('D Flip-Flop with clock', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="dff_test">
        <comp lib="0" loc="(100,100)" name="Pin"><a name="label" val="D"/></comp>
        <comp lib="0" loc="(100,120)" name="Clock"/>
        <comp lib="4" loc="(200,110)" name="D Flip-Flop"/>
        <comp lib="5" loc="(280,100)" name="LED"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 4, 'Has 4 components, got ' + result.components.length);
    assert(result.components[0].type === 'INPUT', 'First is INPUT');
    assert(result.components[1].type === 'CLOCK', 'Second is CLOCK');
    assert(result.components[2].type === 'D_FF', 'Third is D_FF');
    assert(result.components[3].type === 'LED', 'Fourth is LED');
    assert(result.components[1].attrs.period === 500, 'Clock has period');
});

// ── Test 5: Counter and 7-segment display ──
test('Counter with 7-segment display', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="counter_test">
        <comp lib="0" loc="(80,100)" name="Clock"/>
        <comp lib="4" loc="(200,100)" name="Counter"/>
        <comp lib="5" loc="(320,80)" name="7-Segment Display"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 3, 'Has 3 components, got ' + result.components.length);
    assert(result.components[0].type === 'CLOCK', 'Clock');
    assert(result.components[1].type === 'COUNTER', 'Counter');
    assert(result.components[2].type === 'SEVEN_SEG', '7-seg display');
});

// ── Test 6: Tunnels ──
test('Tunnel connections', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="tunnel_test">
        <comp lib="0" loc="(100,100)" name="Pin"><a name="label" val="IN"/></comp>
        <comp lib="0" loc="(160,100)" name="Tunnel"><a name="label" val="bus1"/></comp>
        <comp lib="0" loc="(300,100)" name="Tunnel"><a name="facing" val="west"/><a name="label" val="bus1"/></comp>
        <comp lib="0" loc="(360,100)" name="Pin"><a name="facing" val="west"/><a name="type" val="output"/><a name="label" val="OUT"/></comp>
        <wire from="(120,100)" to="(160,100)"/>
        <wire from="(300,100)" to="(340,100)"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 4, 'Has 4 components, got ' + result.components.length);
    var tunnelTypes = result.components.filter(function(c) { return c.type === 'TUNNEL_SRC' || c.type === 'TUNNEL_TGT'; });
    assert(tunnelTypes.length === 2, 'Has 2 tunnel components, got ' + tunnelTypes.length);
    assert(result.stats.tunnelGroups === 1, 'Has 1 tunnel group, got ' + result.stats.tunnelGroups);

    // Tunnel direction: first tunnel (east-facing, receives from input pin) → SRC
    // Second tunnel (west-facing, feeds output pin) → TGT
    var srcTunnels = result.components.filter(function(c) { return c.type === 'TUNNEL_SRC'; });
    var tgtTunnels = result.components.filter(function(c) { return c.type === 'TUNNEL_TGT'; });
    assert(srcTunnels.length >= 1, 'Has at least 1 SRC tunnel, got ' + srcTunnels.length);
    assert(tgtTunnels.length >= 1, 'Has at least 1 TGT tunnel, got ' + tgtTunnels.length);

    // Tunnel name attribute set correctly
    tunnelTypes.forEach(function(t) {
        assert(t.attrs.name === 'bus1', 'Tunnel name attr is bus1, got ' + t.attrs.name);
    });
});

// ── Test 7: Constants and buttons ──
test('Ground, buttons, and constants', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="io_test">
        <comp lib="0" loc="(100,100)" name="Ground"/>
        <comp lib="5" loc="(100,150)" name="Button"/>
        <comp lib="0" loc="(200,100)" name="Constant"><a name="value" val="1"/></comp>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 3, 'Has 3 components, got ' + result.components.length);
    assert(result.components[0].type === 'CONSTANT', 'Ground → CONSTANT');
    assert(result.components[0].attrs.value === 0, 'Ground value is 0');
    assert(result.components[1].type === 'BUTTON', 'Button');
    assert(result.components[2].type === 'CONSTANT', 'Constant');
});

// ── Test 8: Facing directions ──
test('Components with different facing', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="facing_test">
        <comp lib="0" loc="(100,200)" name="Clock"><a name="facing" val="north"/></comp>
        <comp lib="0" loc="(200,100)" name="Pin"><a name="facing" val="south"/><a name="label" val="X"/></comp>
        <comp lib="1" loc="(300,150)" name="AND Gate"><a name="facing" val="south"/></comp>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 3, 'Has 3 components, got ' + result.components.length);
    assert(result.components[0].type === 'CLOCK', 'Clock with north facing');
    assert(result.components[2].type === 'AND', 'AND with south facing');
});

// ── Test 9: Arithmetic components ──
test('Adder and register', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="arith_test">
        <comp lib="3" loc="(200,100)" name="Adder"><a name="width" val="4"/></comp>
        <comp lib="4" loc="(300,100)" name="Register"><a name="width" val="4"/></comp>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 2, 'Has 2 components, got ' + result.components.length);
    assert(result.components[0].type === 'ADDER', 'Adder');
    assert(result.components[1].type === 'REGISTER', 'Register');
});

// ── Test 10: Skips unsupported types, keeps supported ──
test('Skips Text and BCD decoder, keeps Pin, Splitter, Pull Resistor', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="skip_test">
        <comp lib="0" loc="(100,100)" name="Pin"><a name="label" val="A"/></comp>
        <comp lib="0" loc="(200,100)" name="Splitter"><a name="fanout" val="4"/></comp>
        <comp lib="8" loc="(300,300)" name="Text"><a name="text" val="Hello"/></comp>
        <comp lib="9" loc="(400,100)" name="BCD_to_7_Segment_decoder"/>
        <comp lib="0" loc="(150,200)" name="Pull Resistor"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 3, 'INPUT + SPLITTER + CONSTANT kept, got ' + result.components.length);
    var types = result.components.map(function(c) { return c.type; });
    assert(types.indexOf('INPUT') !== -1, 'Has INPUT');
    assert(types.indexOf('SPLITTER') !== -1, 'Has SPLITTER');
    assert(types.indexOf('CONSTANT') !== -1, 'Has CONSTANT (Pull Resistor)');
    assert(result.stats.totalLogisimComponents === 5, 'Total Logisim comps was 5');
});

// ── Test 11: The big sequential adder circuit ──
test('Sequential BCD Adder (full circuit from user)', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<project source="4.0.0" version="1.0">
  <lib desc="#Wiring" name="0"><tool name="Pin"><a name="appearance" val="classic"/></tool></lib>
  <lib desc="#Gates" name="1"/><lib desc="#Plexers" name="2"/><lib desc="#Arithmetic" name="3"/>
  <lib desc="#Memory" name="4"/><lib desc="#I/O" name="5"/><lib desc="#TTL" name="6"/>
  <lib desc="#TCL" name="7"/><lib desc="#Base" name="8"/><lib desc="#BFH-Praktika" name="9"/>
  <circuit name="main">
    <comp lib="0" loc="(120,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n6"/></comp>
    <comp lib="0" loc="(150,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n5"/></comp>
    <comp lib="0" loc="(180,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n4"/></comp>
    <comp lib="0" loc="(210,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n3"/></comp>
    <comp lib="0" loc="(240,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n2"/></comp>
    <comp lib="0" loc="(270,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n1"/></comp>
    <comp lib="0" loc="(30,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n9"/></comp>
    <comp lib="0" loc="(300,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n0"/></comp>
    <comp lib="0" loc="(60,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n8"/></comp>
    <comp lib="0" loc="(90,40)" name="Tunnel"><a name="facing" val="south"/><a name="label" val="n7"/></comp>
    <comp lib="1" loc="(390,70)" name="OR Gate"><a name="inputs" val="5"/></comp>
    <comp lib="1" loc="(390,130)" name="OR Gate"><a name="inputs" val="4"/></comp>
    <comp lib="1" loc="(390,190)" name="OR Gate"><a name="inputs" val="4"/></comp>
    <comp lib="1" loc="(390,250)" name="OR Gate"/>
    <comp lib="3" loc="(970,260)" name="Adder"><a name="width" val="4"/></comp>
    <comp lib="3" loc="(1060,260)" name="Adder"><a name="width" val="4"/></comp>
    <comp lib="4" loc="(750,20)" name="Register"><a name="width" val="4"/></comp>
    <comp lib="4" loc="(750,140)" name="Register"><a name="width" val="4"/></comp>
    <comp lib="4" loc="(420,350)" name="T Flip-Flop"/>
    <comp lib="0" loc="(740,90)" name="Clock"><a name="facing" val="north"/></comp>
    <comp lib="0" loc="(740,210)" name="Clock"><a name="facing" val="north"/></comp>
    <comp lib="5" loc="(130,500)" name="Button"/>
    <comp lib="5" loc="(130,550)" name="Button"/>
    <comp lib="5" loc="(130,600)" name="Button"/>
    <comp lib="5" loc="(200,500)" name="Button"/>
    <comp lib="5" loc="(200,550)" name="Button"/>
    <comp lib="5" loc="(200,600)" name="Button"/>
    <comp lib="5" loc="(200,650)" name="Button"/>
    <comp lib="5" loc="(270,500)" name="Button"/>
    <comp lib="5" loc="(270,550)" name="Button"/>
    <comp lib="5" loc="(270,600)" name="Button"/>
    <comp lib="5" loc="(410,640)" name="Button"/>
    <comp lib="5" loc="(410,700)" name="Button"/>
    <comp lib="1" loc="(680,380)" name="AND Gate"/>
    <comp lib="1" loc="(680,440)" name="AND Gate"/>
    <comp lib="1" loc="(1160,210)" name="OR Gate"><a name="facing" val="north"/></comp>
    <comp lib="1" loc="(1160,400)" name="AND Gate"><a name="facing" val="north"/></comp>
    <comp lib="1" loc="(1190,320)" name="OR Gate"><a name="facing" val="north"/></comp>
    <comp lib="1" loc="(1220,400)" name="AND Gate"><a name="facing" val="north"/></comp>
    <comp lib="0" loc="(1030,430)" name="Ground"/>
    <comp lib="2" loc="(640,60)" name="Demultiplexer"><a name="width" val="4"/></comp>
    <comp lib="0" loc="(390,430)" name="Tunnel"><a name="facing" val="north"/><a name="label" val="SUM"/></comp>
    <comp lib="0" loc="(430,640)" name="Tunnel"><a name="label" val="SUM"/></comp>
    <comp lib="0" loc="(430,700)" name="Tunnel"><a name="label" val="CE"/></comp>
    <comp lib="0" loc="(780,110)" name="Tunnel"><a name="facing" val="north"/><a name="label" val="CE"/></comp>
    <comp lib="0" loc="(780,250)" name="Tunnel"><a name="facing" val="north"/><a name="label" val="CE"/></comp>
    <comp lib="0" loc="(150,500)" name="Tunnel"><a name="label" val="n7"/></comp>
    <comp lib="0" loc="(150,550)" name="Tunnel"><a name="label" val="n4"/></comp>
    <comp lib="0" loc="(150,600)" name="Tunnel"><a name="label" val="n1"/></comp>
    <comp lib="0" loc="(220,500)" name="Tunnel"><a name="label" val="n8"/></comp>
    <comp lib="0" loc="(220,550)" name="Tunnel"><a name="label" val="n5"/></comp>
    <comp lib="0" loc="(220,600)" name="Tunnel"><a name="label" val="n2"/></comp>
    <comp lib="0" loc="(220,650)" name="Tunnel"><a name="label" val="n0"/></comp>
    <comp lib="0" loc="(290,500)" name="Tunnel"><a name="label" val="n9"/></comp>
    <comp lib="0" loc="(290,550)" name="Tunnel"><a name="label" val="n6"/></comp>
    <comp lib="0" loc="(290,600)" name="Tunnel"><a name="label" val="n3"/></comp>
    <wire from="(1010,270)" to="(1010,380)"/>
    <wire from="(1010,270)" to="(1020,270)"/>
    <wire from="(1010,380)" to="(1020,380)"/>
    <wire from="(1010,90)" to="(1010,110)"/>
    <wire from="(1020,10)" to="(1020,30)"/>
    <wire from="(1030,400)" to="(1030,420)"/>
    <wire from="(1030,420)" to="(1030,430)"/>
    <wire from="(1030,420)" to="(1060,420)"/>
    <wire from="(1040,400)" to="(1040,410)"/>
    <wire from="(1040,410)" to="(1040,430)"/>
    <wire from="(1040,410)" to="(1050,410)"/>
    <wire from="(1040,430)" to="(1100,430)"/>
    <wire from="(1050,110)" to="(1050,120)"/>
    <wire from="(1050,120)" to="(1080,120)"/>
    <wire from="(1050,400)" to="(1050,410)"/>
    <wire from="(1060,260)" to="(1080,260)"/>
    <wire from="(1060,400)" to="(1060,420)"/>
    <wire from="(1080,120)" to="(1080,260)"/>
    <wire from="(1100,160)" to="(1100,430)"/>
    <wire from="(1100,160)" to="(1160,160)"/>
    <wire from="(1130,480)" to="(1200,480)"/>
    <wire from="(1130,490)" to="(1140,490)"/>
    <wire from="(1130,500)" to="(1180,500)"/>
    <wire from="(1140,260)" to="(1140,300)"/>
    <wire from="(1140,450)" to="(1140,490)"/>
    <wire from="(1160,160)" to="(1160,210)"/>
    <wire from="(1160,380)" to="(1160,400)"/>
    <wire from="(1160,380)" to="(1170,380)"/>
    <wire from="(1170,370)" to="(1170,380)"/>
    <wire from="(1180,260)" to="(1180,290)"/>
    <wire from="(1180,290)" to="(1190,290)"/>
    <wire from="(1180,450)" to="(1180,500)"/>
    <wire from="(1180,500)" to="(1240,500)"/>
    <wire from="(1190,290)" to="(1190,320)"/>
    <wire from="(120,140)" to="(120,200)"/>
    <wire from="(120,140)" to="(340,140)"/>
    <wire from="(120,200)" to="(340,200)"/>
    <wire from="(120,40)" to="(120,140)"/>
    <wire from="(1200,450)" to="(1200,480)"/>
    <wire from="(1210,370)" to="(1210,380)"/>
    <wire from="(1210,380)" to="(1220,380)"/>
    <wire from="(1220,380)" to="(1220,400)"/>
    <wire from="(1240,450)" to="(1240,500)"/>
    <wire from="(130,500)" to="(140,500)"/>
    <wire from="(130,550)" to="(140,550)"/>
    <wire from="(130,600)" to="(140,600)"/>
    <wire from="(140,500)" to="(150,500)"/>
    <wire from="(140,550)" to="(150,550)"/>
    <wire from="(140,600)" to="(150,600)"/>
    <wire from="(150,180)" to="(340,180)"/>
    <wire from="(150,40)" to="(150,70)"/>
    <wire from="(150,70)" to="(150,180)"/>
    <wire from="(150,70)" to="(340,70)"/>
    <wire from="(180,170)" to="(340,170)"/>
    <wire from="(180,40)" to="(180,170)"/>
    <wire from="(200,500)" to="(210,500)"/>
    <wire from="(200,550)" to="(210,550)"/>
    <wire from="(200,600)" to="(210,600)"/>
    <wire from="(200,650)" to="(210,650)"/>
    <wire from="(210,120)" to="(340,120)"/>
    <wire from="(210,40)" to="(210,60)"/>
    <wire from="(210,500)" to="(220,500)"/>
    <wire from="(210,550)" to="(220,550)"/>
    <wire from="(210,60)" to="(210,120)"/>
    <wire from="(210,60)" to="(340,60)"/>
    <wire from="(210,600)" to="(220,600)"/>
    <wire from="(210,650)" to="(220,650)"/>
    <wire from="(240,110)" to="(340,110)"/>
    <wire from="(240,40)" to="(240,110)"/>
    <wire from="(270,40)" to="(270,50)"/>
    <wire from="(270,50)" to="(340,50)"/>
    <wire from="(270,500)" to="(280,500)"/>
    <wire from="(270,550)" to="(280,550)"/>
    <wire from="(270,600)" to="(280,600)"/>
    <wire from="(280,500)" to="(290,500)"/>
    <wire from="(280,550)" to="(290,550)"/>
    <wire from="(280,600)" to="(290,600)"/>
    <wire from="(30,270)" to="(340,270)"/>
    <wire from="(30,40)" to="(30,90)"/>
    <wire from="(30,90)" to="(30,270)"/>
    <wire from="(30,90)" to="(340,90)"/>
    <wire from="(300,160)" to="(430,160)"/>
    <wire from="(300,40)" to="(300,160)"/>
    <wire from="(390,130)" to="(400,130)"/>
    <wire from="(390,190)" to="(410,190)"/>
    <wire from="(390,250)" to="(420,250)"/>
    <wire from="(390,360)" to="(390,400)"/>
    <wire from="(390,360)" to="(410,360)"/>
    <wire from="(390,400)" to="(390,430)"/>
    <wire from="(390,400)" to="(410,400)"/>
    <wire from="(390,70)" to="(460,70)"/>
    <wire from="(400,80)" to="(400,130)"/>
    <wire from="(400,80)" to="(470,80)"/>
    <wire from="(410,640)" to="(420,640)"/>
    <wire from="(410,700)" to="(420,700)"/>
    <wire from="(410,90)" to="(410,190)"/>
    <wire from="(410,90)" to="(480,90)"/>
    <wire from="(420,100)" to="(420,250)"/>
    <wire from="(420,100)" to="(490,100)"/>
    <wire from="(420,640)" to="(430,640)"/>
    <wire from="(420,700)" to="(430,700)"/>
    <wire from="(430,110)" to="(430,160)"/>
    <wire from="(430,110)" to="(500,110)"/>
    <wire from="(460,70)" to="(460,160)"/>
    <wire from="(460,70)" to="(510,70)"/>
    <wire from="(470,360)" to="(530,360)"/>
    <wire from="(470,400)" to="(630,400)"/>
    <wire from="(470,80)" to="(470,160)"/>
    <wire from="(470,80)" to="(510,80)"/>
    <wire from="(480,210)" to="(480,350)"/>
    <wire from="(480,350)" to="(560,350)"/>
    <wire from="(480,90)" to="(480,160)"/>
    <wire from="(480,90)" to="(510,90)"/>
    <wire from="(490,100)" to="(490,160)"/>
    <wire from="(490,100)" to="(510,100)"/>
    <wire from="(500,110)" to="(500,160)"/>
    <wire from="(530,310)" to="(530,360)"/>
    <wire from="(530,310)" to="(660,310)"/>
    <wire from="(530,360)" to="(530,460)"/>
    <wire from="(530,460)" to="(630,460)"/>
    <wire from="(530,60)" to="(640,60)"/>
    <wire from="(560,350)" to="(560,360)"/>
    <wire from="(560,360)" to="(560,420)"/>
    <wire from="(560,360)" to="(630,360)"/>
    <wire from="(560,420)" to="(630,420)"/>
    <wire from="(60,230)" to="(340,230)"/>
    <wire from="(60,40)" to="(60,230)"/>
    <wire from="(660,80)" to="(660,310)"/>
    <wire from="(670,50)" to="(750,50)"/>
    <wire from="(670,70)" to="(690,70)"/>
    <wire from="(680,380)" to="(700,380)"/>
    <wire from="(680,440)" to="(720,440)"/>
    <wire from="(690,170)" to="(750,170)"/>
    <wire from="(690,70)" to="(690,170)"/>
    <wire from="(700,70)" to="(700,380)"/>
    <wire from="(700,70)" to="(750,70)"/>
    <wire from="(720,190)" to="(720,440)"/>
    <wire from="(720,190)" to="(750,190)"/>
    <wire from="(740,210)" to="(750,210)"/>
    <wire from="(740,90)" to="(750,90)"/>
    <wire from="(780,230)" to="(780,250)"/>
    <wire from="(810,170)" to="(910,170)"/>
    <wire from="(810,50)" to="(820,50)"/>
    <wire from="(820,120)" to="(850,120)"/>
    <wire from="(820,50)" to="(820,120)"/>
    <wire from="(850,110)" to="(850,120)"/>
    <wire from="(850,120)" to="(850,270)"/>
    <wire from="(850,270)" to="(930,270)"/>
    <wire from="(90,150)" to="(340,150)"/>
    <wire from="(90,150)" to="(90,210)"/>
    <wire from="(90,210)" to="(340,210)"/>
    <wire from="(90,40)" to="(90,80)"/>
    <wire from="(90,80)" to="(340,80)"/>
    <wire from="(90,80)" to="(90,150)"/>
    <wire from="(910,110)" to="(910,170)"/>
    <wire from="(910,170)" to="(910,250)"/>
    <wire from="(910,250)" to="(930,250)"/>
    <wire from="(950,280)" to="(950,300)"/>
    <wire from="(950,300)" to="(1140,300)"/>
    <wire from="(970,260)" to="(990,260)"/>
    <wire from="(980,10)" to="(1020,10)"/>
    <wire from="(980,10)" to="(980,110)"/>
    <wire from="(980,110)" to="(1010,110)"/>
    <wire from="(980,110)" to="(980,160)"/>
    <wire from="(980,160)" to="(1100,160)"/>
    <wire from="(990,250)" to="(1020,250)"/>
    <wire from="(990,250)" to="(990,260)"/>
    <wire from="(990,260)" to="(990,510)"/>
    <wire from="(990,510)" to="(1110,510)"/>
  </circuit>
</project>`;

    var result = parse(xml);
    assert(!result.error, 'No parse error');
    assert(result.components.length > 30, 'Has 30+ components, got ' + result.components.length);
    assert(result.stats.tunnelGroups > 5, 'Has multiple tunnel groups, got ' + result.stats.tunnelGroups);

    // Check specific types exist
    var types = result.components.map(function(c) { return c.type; });
    assert(types.indexOf('OR') !== -1, 'Has OR gates');
    assert(types.indexOf('AND') !== -1, 'Has AND gates');
    assert(types.indexOf('ADDER') !== -1, 'Has ADDER');
    assert(types.indexOf('REGISTER') !== -1, 'Has REGISTER');
    assert(types.indexOf('T_FF') !== -1, 'Has T_FF');
    assert(types.indexOf('CLOCK') !== -1, 'Has CLOCK');
    assert(types.indexOf('BUTTON') !== -1, 'Has BUTTON');
    assert(types.indexOf('DEMUX') !== -1, 'Has DEMUX');
    assert(types.indexOf('CONSTANT') !== -1, 'Has CONSTANT (Ground)');
    assert(types.indexOf('TUNNEL_SRC') !== -1 || types.indexOf('TUNNEL_TGT') !== -1, 'Has tunnels');

    console.log('  Stats:', JSON.stringify(result.stats));
});

// ── Test 12: TTL IC mapping ──
test('TTL 7400 and 7474 mapping', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="ttl_test">
        <comp lib="6" loc="(100,100)" name="7400"/>
        <comp lib="6" loc="(200,100)" name="7474"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 2, 'Has 2 TTL components, got ' + result.components.length);
    assert(result.components[0].type === 'TTL_7400', '7400 → TTL_7400');
    assert(result.components[1].type === 'TTL_7474', '7474 → TTL_7474');
});

// ── Test 13: Modern appearance flip-flop ──
test('Modern appearance D Flip-Flop', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="modern_ff_test">
        <comp lib="4" loc="(200,100)" name="D Flip-Flop"><a name="appearance" val="logisim_evolution"/></comp>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 1, 'Has 1 component');
    assert(result.components[0].type === 'D_FF', 'Type is D_FF');
});

// ── Test 14: Splitter creates real component ──
test('Splitter creates SPLITTER component with correct fanout', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="splitter_test">
        <comp lib="0" loc="(100,100)" name="Splitter"><a name="fanout" val="4"/></comp>
        <comp lib="0" loc="(80,100)" name="Pin"><a name="label" val="BUS"/></comp>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 2, 'PIN + SPLITTER, got ' + result.components.length);
    var splitter = result.components.find(function(c) { return c.type === 'SPLITTER'; });
    assert(splitter, 'Has SPLITTER component');
    assert(splitter.attrs.fanout === 4, 'Fanout is 4, got ' + (splitter && splitter.attrs.fanout));
    assert(result.components[1].type === 'INPUT' || result.components[0].type === 'INPUT', 'Has INPUT');
});

// ── Test 15: Multiple circuits (subcircuits) ──
test('Multiple circuits parsed', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <main name="main"/>
      <circuit name="main">
        <comp lib="0" loc="(100,100)" name="Pin"><a name="label" val="A"/></comp>
        <comp lib="1" loc="(200,100)" name="AND Gate"/>
      </circuit>
      <circuit name="sub">
        <comp lib="0" loc="(100,100)" name="Pin"><a name="label" val="X"/></comp>
        <comp lib="1" loc="(200,100)" name="OR Gate"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.stats.circuits === 2, 'Found 2 circuits, got ' + result.stats.circuits);
    assert(result.components.length === 4, 'Has 4 total components, got ' + result.components.length);
    assert(result.name === 'main', 'Name is main');
    var types = result.components.map(function(c) { return c.type; });
    assert(types.indexOf('AND') !== -1, 'Has AND from main');
    assert(types.indexOf('OR') !== -1, 'Has OR from sub');
});

// ── Test 16: Pull Resistor → CONSTANT ──
test('Pull Resistor maps to CONSTANT with value 1', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="pull_test">
        <comp lib="0" loc="(100,100)" name="Pull Resistor"/>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 1, 'Has 1 component');
    assert(result.components[0].type === 'CONSTANT', 'Pull → CONSTANT');
    assert(result.components[0].attrs.value === 1, 'Value is 1 (pull-up)');
});

// ── Test 17: Warnings for unsupported components ──
test('Warnings generated for unsupported components', function() {
    var xml = `<?xml version="1.0" encoding="UTF-8"?>
    <project source="4.0.0" version="1.0">
      <circuit name="warn_test">
        <comp lib="3" loc="(100,100)" name="Multiplier"/>
        <comp lib="4" loc="(200,100)" name="RAM"/>
        <comp lib="8" loc="(300,100)" name="Text"><a name="text" val="Hello"/></comp>
      </circuit>
    </project>`;

    var result = parse(xml);
    assert(result.components.length === 0, 'No components (all skipped)');
    assert(result.warnings.length >= 2, 'Has warnings, got ' + result.warnings.length);
});

// ── Summary ──
console.log('\n════════════════════════');
console.log('Results: ' + passed + ' passed, ' + failed + ' failed');
console.log('════════════════════════');
process.exit(failed > 0 ? 1 : 0);

/**
 * Preset Arduino Sketches — complete starter projects.
 *
 * Each preset has:
 *   - id: unique key
 *   - title: display name
 *   - description: one-line explanation of what the project does
 *   - category: for grouping in dropdown
 *   - board: (optional) FQBN — defaults to 'arduino:avr:uno'
 *   - code: main sketch.ino source code
 *   - files: (optional) extra files [{name, content}] for multi-file projects
 *   - components: (optional) array of { type, pin, x, y, attrs } for canvas
 *   - diagram: (optional) Wokwi-compatible diagram.json object { parts, connections }
 *
 * Component types match COMPONENT_TYPES keys in component-panel.js.
 * When diagram is provided, it takes priority over components[] for canvas layout.
 */

export const PRESETS = [
  // ── Basics ──
  {
    id: 'blink',
    title: 'Blink',
    category: 'Basics',
    description: 'The classic first Arduino project — blink the built-in LED on pin 13.',
    components: [],
    diagram: {
      parts: [
        { type: 'wokwi-arduino-uno', id: 'board', top: 0, left: 0 },
      ],
      connections: [],
    },
    code: `// Blink — the "Hello World" of Arduino
// The built-in LED on pin 13 turns on and off every second.

void setup() {
  pinMode(13, OUTPUT);  // Pin 13 has an LED on most Arduino boards
}

void loop() {
  digitalWrite(13, HIGH);  // Turn LED on
  delay(1000);             // Wait 1 second
  digitalWrite(13, LOW);   // Turn LED off
  delay(1000);             // Wait 1 second
}`,
  },
  {
    id: 'blink-serial',
    title: 'Blink + Serial',
    category: 'Basics',
    description: 'Blink LED and print status to the Serial Monitor.',
    components: [],
    diagram: {
      parts: [
        { type: 'wokwi-arduino-uno', id: 'board', top: 0, left: 0 },
      ],
      connections: [],
    },
    code: `// Blink + Serial Monitor
// Watch the LED blink AND see messages in the Serial Monitor (bottom right).

void setup() {
  Serial.begin(115200);   // Start serial communication
  pinMode(13, OUTPUT);
}

void loop() {
  Serial.println("LED ON");
  digitalWrite(13, HIGH);
  delay(500);
  Serial.println("LED OFF");
  digitalWrite(13, LOW);
  delay(500);
}`,
  },
  {
    id: 'fade',
    title: 'Fade (PWM)',
    category: 'Basics',
    components: [
      { type: 'led', pin: 9, x: 340, y: 20, attrs: { color: 'red' } },
    ],
    code: `int led = 9;
int brightness = 0;
int fadeAmount = 5;

void setup() {
  pinMode(led, OUTPUT);
}

void loop() {
  analogWrite(led, brightness);
  brightness += fadeAmount;
  if (brightness <= 0 || brightness >= 255) {
    fadeAmount = -fadeAmount;
  }
  delay(30);
}`,
  },

  // ── Digital Input ──
  {
    id: 'button',
    title: 'Button',
    category: 'Input',
    components: [
      { type: 'pushbutton', pin: 2, x: 340, y: 100, attrs: { color: 'red' } },
    ],
    code: `const int buttonPin = 2;
const int ledPin = 13;

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
  int state = digitalRead(buttonPin);
  digitalWrite(ledPin, state == LOW ? HIGH : LOW);
  if (state == LOW) {
    Serial.println("Button pressed!");
  }
  delay(50);
}`,
  },
  {
    id: 'debounce',
    title: 'Debounce',
    category: 'Input',
    components: [
      { type: 'pushbutton', pin: 2, x: 340, y: 100, attrs: { color: 'blue' } },
    ],
    code: `const int buttonPin = 2;
const int ledPin = 13;

int ledState = LOW;
int lastButtonState = HIGH;
unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;

void setup() {
  Serial.begin(115200);
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, ledState);
}

void loop() {
  int reading = digitalRead(buttonPin);
  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading == LOW && lastButtonState == HIGH) {
      ledState = !ledState;
      digitalWrite(ledPin, ledState);
      Serial.print("LED toggled: ");
      Serial.println(ledState ? "ON" : "OFF");
    }
    lastButtonState = reading;
  }
}`,
  },

  // ── Analog ──
  {
    id: 'analog-read',
    title: 'Analog Read',
    category: 'Analog',
    components: [
      { type: 'potentiometer', pin: 'A0', x: 340, y: 20 },
    ],
    code: `void setup() {
  Serial.begin(115200);
}

void loop() {
  int val = analogRead(A0);
  Serial.print("Sensor: ");
  Serial.println(val);
  delay(200);
}`,
  },
  {
    id: 'analog-bar',
    title: 'Analog Bar Graph',
    category: 'Analog',
    components: [
      { type: 'potentiometer', pin: 'A0', x: 340, y: 20 },
      { type: 'led', pin: 2, x: 340, y: 120, attrs: { color: 'red' } },
      { type: 'led', pin: 3, x: 380, y: 120, attrs: { color: 'red' } },
      { type: 'led', pin: 4, x: 420, y: 120, attrs: { color: 'yellow' } },
      { type: 'led', pin: 5, x: 460, y: 120, attrs: { color: 'yellow' } },
      { type: 'led', pin: 6, x: 500, y: 120, attrs: { color: 'green' } },
      { type: 'led', pin: 7, x: 540, y: 120, attrs: { color: 'green' } },
      { type: 'led', pin: 8, x: 580, y: 120, attrs: { color: 'green' } },
      { type: 'led', pin: 9, x: 620, y: 120, attrs: { color: 'green' } },
      { type: 'led', pin: 10, x: 660, y: 120, attrs: { color: 'green' } },
      { type: 'led', pin: 11, x: 700, y: 120, attrs: { color: 'green' } },
    ],
    code: `const int analogPin = A0;
const int ledPins[] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
const int numLeds = 10;

void setup() {
  Serial.begin(115200);
  for (int i = 0; i < numLeds; i++) {
    pinMode(ledPins[i], OUTPUT);
  }
}

void loop() {
  int val = analogRead(analogPin);
  int ledsOn = map(val, 0, 1023, 0, numLeds);
  Serial.print("Value: ");
  Serial.print(val);
  Serial.print(" LEDs: ");
  Serial.println(ledsOn);
  for (int i = 0; i < numLeds; i++) {
    digitalWrite(ledPins[i], i < ledsOn ? HIGH : LOW);
  }
  delay(50);
}`,
  },

  // ── Serial ──
  {
    id: 'serial-echo',
    title: 'Serial Echo',
    category: 'Serial',
    components: [],
    code: `void setup() {
  Serial.begin(115200);
  Serial.println("Type something and press Enter:");
}

void loop() {
  if (Serial.available() > 0) {
    String input = Serial.readStringUntil('\\n');
    Serial.print("Echo: ");
    Serial.println(input);
  }
}`,
  },
  {
    id: 'serial-temp',
    title: 'Temperature Logger',
    category: 'Serial',
    components: [
      { type: 'potentiometer', pin: 'A0', x: 340, y: 20 },
    ],
    code: `void setup() {
  Serial.begin(115200);
  Serial.println("Time(s),Temp(C)");
}

void loop() {
  int raw = analogRead(A0);
  // TMP36: 10mV/°C, 500mV offset at 0°C
  float voltage = raw * (5.0 / 1023.0);
  float tempC = (voltage - 0.5) * 100.0;
  Serial.print(millis() / 1000.0, 1);
  Serial.print(",");
  Serial.println(tempC, 1);
  delay(1000);
}`,
  },

  // ── Servo ──
  {
    id: 'servo-sweep',
    title: 'Servo Sweep',
    category: 'Servo',
    components: [
      { type: 'servo', pin: 9, x: 340, y: 20 },
    ],
    code: `#include <Servo.h>

Servo myservo;
int pos = 0;

void setup() {
  Serial.begin(115200);
  myservo.attach(9);
}

void loop() {
  for (pos = 0; pos <= 180; pos += 1) {
    myservo.write(pos);
    delay(15);
  }
  Serial.println("Sweep forward done");
  for (pos = 180; pos >= 0; pos -= 1) {
    myservo.write(pos);
    delay(15);
  }
  Serial.println("Sweep reverse done");
}`,
  },
  {
    id: 'servo-pot',
    title: 'Servo + Potentiometer',
    category: 'Servo',
    components: [
      { type: 'servo', pin: 9, x: 340, y: 20 },
      { type: 'potentiometer', pin: 'A0', x: 340, y: 120 },
    ],
    code: `#include <Servo.h>

Servo myservo;

void setup() {
  Serial.begin(115200);
  myservo.attach(9);
}

void loop() {
  int val = analogRead(A0);
  int angle = map(val, 0, 1023, 0, 180);
  myservo.write(angle);
  Serial.print("Pot: ");
  Serial.print(val);
  Serial.print(" Angle: ");
  Serial.println(angle);
  delay(50);
}`,
  },

  // ── Tone / Buzzer ──
  {
    id: 'tone-melody',
    title: 'Tone Melody',
    category: 'Buzzer',
    components: [
      { type: 'buzzer', pin: 3, x: 340, y: 20 },
    ],
    code: `// Simple melody on pin 3
int melody[] = {262, 294, 330, 349, 392, 440, 494, 523};
int noteDuration = 250;

void setup() {
  Serial.begin(115200);
  Serial.println("Playing scale...");
}

void loop() {
  for (int i = 0; i < 8; i++) {
    tone(3, melody[i], noteDuration);
    delay(noteDuration * 1.3);
    noTone(3);
  }
  delay(1000);
}`,
  },

  // ── RGB ──
  {
    id: 'rgb-cycle',
    title: 'RGB LED Color Cycle',
    category: 'RGB',
    components: [
      { type: 'led', pin: 9, x: 340, y: 20, attrs: { color: 'red' } },
      { type: 'led', pin: 10, x: 380, y: 20, attrs: { color: 'green' } },
      { type: 'led', pin: 11, x: 420, y: 20, attrs: { color: 'blue' } },
    ],
    code: `const int redPin = 9;
const int greenPin = 10;
const int bluePin = 11;

void setup() {
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void setColor(int r, int g, int b) {
  analogWrite(redPin, r);
  analogWrite(greenPin, g);
  analogWrite(bluePin, b);
}

void loop() {
  setColor(255, 0, 0);   delay(500);  // Red
  setColor(0, 255, 0);   delay(500);  // Green
  setColor(0, 0, 255);   delay(500);  // Blue
  setColor(255, 255, 0);  delay(500); // Yellow
  setColor(0, 255, 255);  delay(500); // Cyan
  setColor(255, 0, 255);  delay(500); // Magenta
  setColor(255, 255, 255); delay(500);// White
}`,
  },

  // ── Traffic Light ──
  {
    id: 'traffic-light',
    title: 'Traffic Light',
    category: 'Projects',
    description: 'Simulate a traffic light with 3 LEDs cycling through Green → Yellow → Red.',
    components: [
      { type: 'led', pin: 4, x: 340, y: 20, attrs: { color: 'red' } },
      { type: 'led', pin: 3, x: 340, y: 80, attrs: { color: 'yellow' } },
      { type: 'led', pin: 2, x: 340, y: 140, attrs: { color: 'green' } },
    ],
    diagram: {
      parts: [
        { type: 'wokwi-arduino-uno', id: 'board', top: 0, left: 0 },
        { type: 'wokwi-led', id: 'red', top: 20, left: 340, attrs: { color: 'red', label: 'RED' } },
        { type: 'wokwi-led', id: 'yellow', top: 80, left: 340, attrs: { color: 'yellow', label: 'YEL' } },
        { type: 'wokwi-led', id: 'green', top: 140, left: 340, attrs: { color: 'green', label: 'GRN' } },
      ],
      connections: [
        ['board:4', 'red:A', 'red', []],
        ['board:3', 'yellow:A', 'orange', []],
        ['board:2', 'green:A', 'green', []],
        ['board:GND.1', 'red:C', 'black', []],
        ['board:GND.1', 'yellow:C', 'black', []],
        ['board:GND.1', 'green:C', 'black', []],
      ],
    },
    code: `// Traffic Light — 3 LEDs cycle through Green → Yellow → Red
// Red = pin 4, Yellow = pin 3, Green = pin 2

const int redPin = 4;
const int yellowPin = 3;
const int greenPin = 2;

void setup() {
  Serial.begin(115200);
  pinMode(redPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
}

void loop() {
  // Green phase
  digitalWrite(greenPin, HIGH);
  Serial.println("GREEN - Go");
  delay(3000);
  digitalWrite(greenPin, LOW);

  // Yellow phase
  digitalWrite(yellowPin, HIGH);
  Serial.println("YELLOW - Caution");
  delay(1000);
  digitalWrite(yellowPin, LOW);

  // Red phase
  digitalWrite(redPin, HIGH);
  Serial.println("RED - Stop");
  delay(3000);
  digitalWrite(redPin, LOW);
}`,
  },
  {
    id: 'knight-rider',
    title: 'Knight Rider',
    category: 'Projects',
    components: [
      { type: 'led', pin: 2, x: 340, y: 20, attrs: { color: 'red' } },
      { type: 'led', pin: 3, x: 380, y: 20, attrs: { color: 'red' } },
      { type: 'led', pin: 4, x: 420, y: 20, attrs: { color: 'red' } },
      { type: 'led', pin: 5, x: 460, y: 20, attrs: { color: 'red' } },
      { type: 'led', pin: 6, x: 500, y: 20, attrs: { color: 'red' } },
      { type: 'led', pin: 7, x: 540, y: 20, attrs: { color: 'red' } },
      { type: 'led', pin: 8, x: 580, y: 20, attrs: { color: 'red' } },
      { type: 'led', pin: 9, x: 620, y: 20, attrs: { color: 'red' } },
    ],
    code: `const int leds[] = {2, 3, 4, 5, 6, 7, 8, 9};
const int numLeds = 8;

void setup() {
  for (int i = 0; i < numLeds; i++) {
    pinMode(leds[i], OUTPUT);
  }
}

void loop() {
  for (int i = 0; i < numLeds; i++) {
    digitalWrite(leds[i], HIGH);
    delay(80);
    digitalWrite(leds[i], LOW);
  }
  for (int i = numLeds - 2; i > 0; i--) {
    digitalWrite(leds[i], HIGH);
    delay(80);
    digitalWrite(leds[i], LOW);
  }
}`,
  },
  // ── Raspberry Pi Pico ──
  {
    id: 'pico-blink',
    title: 'Pico Blink',
    category: 'Pico',
    board: 'rp2040:rp2040:rpipico',
    components: [
      { type: 'led', pin: 25, x: 340, y: 20, attrs: { color: 'green' } },
    ],
    code: `void setup() {
  pinMode(25, OUTPUT); // LED_BUILTIN on Pico = GPIO25
}

void loop() {
  digitalWrite(25, HIGH);
  delay(500);
  digitalWrite(25, LOW);
  delay(500);
}`,
  },
  {
    id: 'pico-serial',
    title: 'Pico Serial',
    category: 'Pico',
    board: 'rp2040:rp2040:rpipico',
    components: [
      { type: 'led', pin: 25, x: 340, y: 20, attrs: { color: 'green' } },
    ],
    code: `void setup() {
  Serial.begin(115200);
  pinMode(25, OUTPUT);
}

void loop() {
  Serial.println("Hello from Pico!");
  digitalWrite(25, HIGH);
  delay(500);
  Serial.println("LED OFF");
  digitalWrite(25, LOW);
  delay(500);
}`,
  },
  {
    id: 'pico-analog',
    title: 'Pico Analog Read',
    category: 'Pico',
    board: 'rp2040:rp2040:rpipico',
    components: [
      { type: 'potentiometer', pin: 'A0', x: 340, y: 20 },
    ],
    code: `// Pico: A0 = GPIO26, 12-bit ADC (0-4095), 3.3V reference
void setup() {
  Serial.begin(115200);
  analogReadResolution(12); // 12-bit on RP2040
}

void loop() {
  int val = analogRead(A0);
  float voltage = val * 3.3 / 4095.0;
  Serial.print("ADC: ");
  Serial.print(val);
  Serial.print(" Voltage: ");
  Serial.print(voltage, 2);
  Serial.println("V");
  delay(200);
}`,
  },
  {
    id: 'pico-pwm',
    title: 'Pico PWM Fade',
    category: 'Pico',
    board: 'rp2040:rp2040:rpipico',
    components: [
      { type: 'led', pin: 25, x: 340, y: 20, attrs: { color: 'green' } },
    ],
    code: `// Pico: any GPIO can do PWM
int brightness = 0;
int fadeAmount = 5;

void setup() {
  pinMode(25, OUTPUT);
}

void loop() {
  analogWrite(25, brightness);
  brightness += fadeAmount;
  if (brightness <= 0 || brightness >= 255) {
    fadeAmount = -fadeAmount;
  }
  delay(30);
}`,
  },
  {
    id: 'pico-button',
    title: 'Pico Button',
    category: 'Pico',
    board: 'rp2040:rp2040:rpipico',
    components: [
      { type: 'led', pin: 25, x: 340, y: 20, attrs: { color: 'green' } },
      { type: 'pushbutton', pin: 15, x: 340, y: 100, attrs: { color: 'red' } },
    ],
    code: `const int buttonPin = 15;
const int ledPin = 25; // LED_BUILTIN

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
  int state = digitalRead(buttonPin);
  digitalWrite(ledPin, state == LOW ? HIGH : LOW);
  if (state == LOW) {
    Serial.println("Button pressed!");
  }
  delay(50);
}`,
  },
  // ── ESP32-C3 ──
  {
    id: 'esp32c3-blink',
    title: 'ESP32-C3 Blink',
    category: 'ESP32-C3',
    board: 'esp32:esp32:esp32c3',
    components: [
      { type: 'led', pin: 8, x: 340, y: 20, attrs: { color: 'green' } },
    ],
    code: `void setup() {
  Serial.begin(115200);
  pinMode(8, OUTPUT); // LED_BUILTIN on ESP32-C3 = GPIO8
}

void loop() {
  Serial.println("LED ON");
  digitalWrite(8, HIGH);
  delay(500);
  Serial.println("LED OFF");
  digitalWrite(8, LOW);
  delay(500);
}`,
  },
  {
    id: 'esp32c3-serial',
    title: 'ESP32-C3 Serial',
    category: 'ESP32-C3',
    board: 'esp32:esp32:esp32c3',
    components: [
      { type: 'led', pin: 8, x: 340, y: 20, attrs: { color: 'green' } },
    ],
    code: `void setup() {
  Serial.begin(115200);
  pinMode(8, OUTPUT);
}

void loop() {
  Serial.println("Hello from ESP32-C3!");
  digitalWrite(8, HIGH);
  delay(500);
  Serial.println("LED OFF");
  digitalWrite(8, LOW);
  delay(500);
}`,
  },
  {
    id: 'esp32c3-analog',
    title: 'ESP32-C3 Analog Read',
    category: 'ESP32-C3',
    board: 'esp32:esp32:esp32c3',
    components: [
      { type: 'potentiometer', pin: 'A0', x: 340, y: 20 },
    ],
    code: `// ESP32-C3: A0 = GPIO0, 12-bit ADC (0-4095), 3.3V reference
void setup() {
  Serial.begin(115200);
  analogReadResolution(12); // 12-bit on ESP32-C3
}

void loop() {
  int val = analogRead(A0);
  float voltage = val * 3.3 / 4095.0;
  Serial.print("ADC: ");
  Serial.print(val);
  Serial.print(" Voltage: ");
  Serial.print(voltage, 2);
  Serial.println("V");
  delay(200);
}`,
  },
  {
    id: 'esp32c3-pwm',
    title: 'ESP32-C3 PWM Fade',
    category: 'ESP32-C3',
    board: 'esp32:esp32:esp32c3',
    components: [
      { type: 'led', pin: 8, x: 340, y: 20, attrs: { color: 'green' } },
    ],
    code: `// ESP32-C3: PWM via LEDC peripheral (any GPIO)
int brightness = 0;
int fadeAmount = 5;

void setup() {
  pinMode(8, OUTPUT);
}

void loop() {
  analogWrite(8, brightness);
  brightness += fadeAmount;
  if (brightness <= 0 || brightness >= 255) {
    fadeAmount = -fadeAmount;
  }
  delay(30);
}`,
  },
  // ── ESP32 (Xtensa) ──
  {
    id: 'esp32-blink',
    title: 'ESP32 Blink',
    category: 'ESP32',
    board: 'esp32:esp32:esp32',
    components: [
      { type: 'led', pin: 2, x: 340, y: 20, attrs: { color: 'blue' } },
    ],
    code: `void setup() {
  Serial.begin(115200);
  pinMode(2, OUTPUT); // LED_BUILTIN on ESP32 DevKit = GPIO2
}

void loop() {
  Serial.println("LED ON");
  digitalWrite(2, HIGH);
  delay(500);
  Serial.println("LED OFF");
  digitalWrite(2, LOW);
  delay(500);
}`,
  },
  {
    id: 'esp32-serial',
    title: 'ESP32 Serial',
    category: 'ESP32',
    board: 'esp32:esp32:esp32',
    components: [],
    code: `void setup() {
  Serial.begin(115200);
  pinMode(2, OUTPUT);
}

void loop() {
  Serial.println("Hello from ESP32!");
  digitalWrite(2, HIGH);
  delay(500);
  Serial.println("LED OFF");
  digitalWrite(2, LOW);
  delay(500);
}`,
  },
  {
    id: 'esp32-analog',
    title: 'ESP32 Analog Read',
    category: 'ESP32',
    board: 'esp32:esp32:esp32',
    components: [
      { type: 'potentiometer', pin: 'A0', x: 340, y: 20 },
    ],
    code: `// ESP32: A0 = GPIO36 (VP), 12-bit ADC (0-4095), 3.3V reference
void setup() {
  Serial.begin(115200);
  analogReadResolution(12);
}

void loop() {
  int val = analogRead(A0);
  float voltage = val * 3.3 / 4095.0;
  Serial.print("ADC: ");
  Serial.print(val);
  Serial.print(" Voltage: ");
  Serial.print(voltage, 2);
  Serial.println("V");
  delay(200);
}`,
  },
  {
    id: 'esp32-button',
    title: 'ESP32 Button',
    category: 'ESP32',
    board: 'esp32:esp32:esp32',
    components: [
      { type: 'led', pin: 2, x: 340, y: 20, attrs: { color: 'blue' } },
      { type: 'pushbutton', pin: 4, x: 340, y: 100, attrs: { color: 'red' } },
    ],
    code: `const int buttonPin = 4;
const int ledPin = 2; // LED_BUILTIN

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
  int state = digitalRead(buttonPin);
  digitalWrite(ledPin, state == LOW ? HIGH : LOW);
  if (state == LOW) {
    Serial.println("Button pressed!");
  }
  delay(50);
}`,
  },
  {
    id: 'esp32c3-button',
    title: 'ESP32-C3 Button',
    category: 'ESP32-C3',
    board: 'esp32:esp32:esp32c3',
    components: [
      { type: 'led', pin: 8, x: 340, y: 20, attrs: { color: 'green' } },
      { type: 'pushbutton', pin: 9, x: 340, y: 100, attrs: { color: 'red' } },
    ],
    code: `const int buttonPin = 9;
const int ledPin = 8; // LED_BUILTIN

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
  int state = digitalRead(buttonPin);
  digitalWrite(ledPin, state == LOW ? HIGH : LOW);
  if (state == LOW) {
    Serial.println("Button pressed!");
  }
  delay(50);
}`,
  },
  // ── ESP32-S3 ──
  {
    id: 'esp32s3-blink',
    title: 'ESP32-S3 Blink',
    category: 'ESP32-S3',
    board: 'esp32:esp32:esp32s3',
    components: [],
    code: `void setup() {
  Serial.begin(115200);
  pinMode(48, OUTPUT); // RGB LED on ESP32-S3 = GPIO48
}

void loop() {
  Serial.println("LED ON");
  digitalWrite(48, HIGH);
  delay(500);
  Serial.println("LED OFF");
  digitalWrite(48, LOW);
  delay(500);
}`,
  },
  {
    id: 'esp32s3-serial',
    title: 'ESP32-S3 Serial',
    category: 'ESP32-S3',
    board: 'esp32:esp32:esp32s3',
    components: [],
    code: `void setup() {
  Serial.begin(115200);
}

void loop() {
  Serial.println("Hello from ESP32-S3!");
  delay(1000);
}`,
  },
  {
    id: 'esp32s3-analog',
    title: 'ESP32-S3 Analog Read',
    category: 'ESP32-S3',
    board: 'esp32:esp32:esp32s3',
    components: [
      { type: 'potentiometer', pin: 'A0', x: 340, y: 20 },
    ],
    code: `// ESP32-S3: A0 = GPIO1, 12-bit ADC (0-4095), 3.3V reference
void setup() {
  Serial.begin(115200);
  analogReadResolution(12);
}

void loop() {
  int val = analogRead(A0);
  float voltage = val * 3.3 / 4095.0;
  Serial.print("ADC: ");
  Serial.print(val);
  Serial.print(" Voltage: ");
  Serial.print(voltage, 2);
  Serial.println("V");
  delay(200);
}`,
  },
];

/** Get presets grouped by category for dropdown */
export function getPresetsByCategory() {
  const groups = {};
  for (const p of PRESETS) {
    if (!groups[p.category]) groups[p.category] = [];
    groups[p.category].push(p);
  }
  return groups;
}

/** Find preset by id */
export function getPreset(id) {
  return PRESETS.find(p => p.id === id) || null;
}

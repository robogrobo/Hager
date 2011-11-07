/* ---------------------------------------------------------
this script reads the impulses sent out by the hager ec352
some rough options to interact with the script

author: dominik grob
----------------------------------------------------------*/

const int ledPin = 9;
const int sensorPin = 0;

long impuls = 0;
int sensorVal = 0;
int threshold = 200;
int sensorDelay = 200;

boolean ledOff = 1;
long prevMillis = 0;
boolean debug = 0;

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(sensorPin, INPUT);

  Serial.begin(9600);
  Serial.println("Serial ready");
}

void loop() {
  sensorVal = analogRead(sensorPin);
  unsigned long curMillis = millis();

  // blinking led and incrementing impuls
  if(sensorVal > threshold && ledOff && (curMillis - prevMillis > sensorDelay)) {
    impuls += 1;
    prevMillis = curMillis;

    digitalWrite(ledPin, HIGH);
    ledOff = false;

    if(debug) {
      Serial.println(impuls, DEC);
    }
  } else if(sensorVal < threshold) {
    digitalWrite(ledPin, LOW);
    ledOff = true;
  }

  // script commands
  if(Serial.available() > 0) {
    char command = Serial.read();
    switch(command) {
    case 'S': // send total impuls count and reset
      Serial.print("echo ");
      Serial.print(impuls);
      Serial.println(" | nc barbados 4919");
      impuls = 0;
      break;
    case 'R': // reset impuls count
      impuls = 0;
      break;
    case 'D': // debug mode
      debug = !debug;
      break;
    case 'H': // help
      Serial.print("This is the hager ec352 impuls counter help.\nBasic commandos:\n");
      Serial.print("S  send impuls count to server\n");
      Serial.print("R  reset impuls count\n");
      Serial.println("D  toggle debug mode\n");
      break;
    default:
      return;
    }
  }
}

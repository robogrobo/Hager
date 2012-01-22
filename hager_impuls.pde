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

  Serial.begin(9600);     // /dev/tts/1
  //Serial.begin(115200); // /dev/tts/0
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
      Serial.print(impuls, DEC);
      Serial.print("\n");
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
      Serial.println(impuls);
      impuls = 0;

      digitalWrite(ledPin, HIGH);
      delay(1000);
      digitalWrite(ledPin, LOW);

      break;
    default:
      return;
    }
  }
}

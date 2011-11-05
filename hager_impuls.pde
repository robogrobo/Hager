/* ---------------------------------------------------------
this script reads the impulses sent out by the hager ec352
some rough options to interact with the script

author: dominik grob
----------------------------------------------------------*/

const int ledPin = 9;
const int sensorPin = 0;

unsigned int impuls = 0;
int sensorVal = 0;
int threshold = 200;
int sensorDelay = 200;

byte ledOff = 1;
long prevMillis = 0;
byte debug = 0;

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
    ledOff = 0;
    
    if(debug) {
      Serial.println(impuls, DEC);
    }
  } else if(sensorVal < threshold) {
    digitalWrite(ledPin, LOW);
    ledOff = 1;
  }
  
  // script commands
  if(Serial.available() > 0) {
    char command = Serial.read();
    switch(command) {
      case 'T':  // send total impuls count
        Serial.print("echo ");
        Serial.print(impuls);
        Serial.println(" | nc barbados 4919");
        break;
      case 'R':  // reset impuls count
        impuls = 0;
        break;
      case 'D':  // debug mode
        debug = (debug == 0) ? 1 : 0;
        break;
      default:
        return;
    }
  }
}
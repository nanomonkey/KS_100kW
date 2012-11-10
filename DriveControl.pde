void InitDriveReset() {
  last_drive_reset = millis();
}


void DoDriveReset() {
  if (millis() - last_drive_reset > 30000) {
    resetRelays();
    if (millis() - last_drive_reset > 30010) {
      setRelays();
      last_drive_reset = millis();
    }
  }
}

//Individual Relay Control
void relayOn(int driveNum){
  bitSet(shiftRegister, driveNum);
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, shiftRegister);
  digitalWrite(latchPin, HIGH);
}

void relayOff(int driveNum){
  bitClear(shiftRegister, driveNum);
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, shiftRegister);
  digitalWrite(latchPin, HIGH);
}

void resetRelays() {
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, 0);
  digitalWrite(latchPin, HIGH);
}

void setRelays() {
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, shiftRegister);
  digitalWrite(latchPin, HIGH);
}


//Rotary Valve Control
void rotaryValveForward(){
  relayOff(ROTARY_DIRECTION_PIN);
  relayOn(ROTARY_PIN);
}

//Removed to use reverse relay for air solenoid control
//void rotaryValveReverse(){
//  relayOn(ROTARY_DIRECTION_PIN);
//  relayOn(ROTARY_PIN);
//}

void rotaryValveStop(){
  relayOff(ROTARY_PIN);
  relayOff(ROTARY_DIRECTION_PIN);
}


//Main Auger Control
void augerForward(){
  relayOff(MAIN_AUGER_DIRECTION_PIN);
  relayOn(MAIN_AUGER_PIN);
}

void augerReverse(){
  relayOn(MAIN_AUGER_DIRECTION_PIN);
  relayOn(MAIN_AUGER_PIN);
}

void augerStop(){
  relayOff(MAIN_AUGER_PIN);
  relayOff(MAIN_AUGER_DIRECTION_PIN);
}


//Conveyer Control
void conveyorForward(){
  relayOff(CONVEYER_DIRECTION_PIN);
  relayOn(CONVEYER_PIN);
}


void conveyorReverse(){
  relayOn(CONVEYER_DIRECTION_PIN);
  relayOn(CONVEYER_PIN);
}

void conveyorStop(){
  relayOff(CONVEYER_PIN);
  relayOff(CONVEYER_DIRECTION_PIN);
}

//Hopper Agitator Air Solenoid
void hopperAgitatorOn(){
  relayOn(HOPPER_AGITATOR_SOLENOID_PIN);
}

void hopperAgitatorOff(){
  relayOff(HOPPER_AGITATOR_SOLENOID_PIN);
}

//Ash Grate Control
void ashGrateForward(){
  relayOff(ASH_GRATE_DIRECTION_PIN);
  relayOn(ASH_GRATE_PIN);
}

void ashGrateReverse(){
  relayOn(ASH_GRATE_DIRECTION_PIN);
  relayOn(ASH_GRATE_PIN);
}

void ashGrateStop(){
  relayOff(ASH_GRATE_PIN);
  relayOff(ASH_GRATE_DIRECTION_PIN);
}

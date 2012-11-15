void DoControlInputs() {
  checkBootState();
  FuelSwitch();
  ReadPot1();
  ReadPot2();
//  int control_input = analogRead(ANA_ENGINE_SWITCH);
//  if (abs(control_input-10)<20) { //"engine off"
//    if (control_state != CONTROL_OFF) {
//      control_state_entered = millis();
//    }
//    control_state = CONTROL_OFF;
//  }
//  if (abs(control_input-1023)<20) { //"engine off"
//    if (control_state != CONTROL_OFF) {
//      control_state_entered = millis();
//    }
//    control_state = CONTROL_OFF;
//  }
//  if (abs(control_input-683)<20) { //"engine on" and starter button pressed
//    if (control_state != CONTROL_START) {
//      control_state_entered = millis();
//    }
//    control_state = CONTROL_START;
//  }
//  if (abs(control_input-515)<20) { //"engine on"
//    if (control_state != CONTROL_ON) {
//      control_state_entered = millis();
//    }
//    control_state = CONTROL_ON;
//  }
}

//State of the Boot, move to ControlInputs??  if above 850 detect is on
void checkBootState(){
  if (analogRead(ANA_BOOT_LOWER) > 850) {
    lower_boot_detect = true;
  } else {
    lower_boot_detect = false;
  }
  if (analogRead(ANA_BOOT_UPPER) > 850) {
    upper_boot_detect = true;
  } else {
    upper_boot_detect = false;
  }
  
  if (lower_boot_detect && upper_boot_detect){
    boot_state = FULL;
  }
  else if (lower_boot_detect && !upper_boot_detect){
    boot_state = MID;
  }
  else if (upper_boot_detect && !lower_boot_detect){  //Unlikely event, should set Alarm if in this state too long
    boot_state = UNKNOWN;
  } else {
    boot_state = EMPTY;
  }
}

//move to ControlInputs?
void FuelSwitch() {
  FuelSwitchValue = analogRead(ANA_FUEL_SWITCH); // switch voltage, 1024 if on, 0 if off
  if (FuelSwitchValue > 600) {
    FuelSwitchLevel = SWITCH_ON;
    fuel_demand = true;
  } else {
    FuelSwitchLevel = SWITCH_OFF;
    fuel_demand = false;
  } 
}

void ReadPot1(){
  //pot_period = (100 * analogRead(ANA_POT1));  
  pot_period = map(analogRead(ANA_POT1), 0, 1023, 1000, 300000);  //Grate Shake Period  1 sec to 5 min interval range
}

void ReadPot2(){
  air_butterfly_position = map(analogRead(ANA_POT2), 0, 1023, throttle_valve_closed, throttle_valve_open);     // read value of potentiometer (between 0 and 1023) scale it to use it with the servo between throttle_valve_open, throttle_valve_closed
}

// Servo
void InitServos() {
  #ifdef SERVO_MIXTURE != ABSENT
    Servo_Mixture.attach(SERVO_MIXTURE); //the def links to the equivalent Arduino pin
  #endif
  #ifdef SERVO_CALIB != ABSENT
    Servo_Calib.attach(SERVO_CALIB);
  #endif
  #ifdef SERVO_THROTTLE !=
    Servo_Throttle.attach(SERVO_THROTTLE);
  #endif
}


void LoadServo() {
  servo_min = EEPROM.read(22);
  if (servo_min != 255) {  //if EEPROM in default value, then default to 133
    throttle_valve_closed = int(servo_min);
  }
  servo_max = EEPROM.read(23);
  if (servo_max != 255) { //if EEPROM in default value, then default to 68
    throttle_valve_open = int(servo_max);
  } 
}

void WriteServo(){
  if (servo_min != throttle_valve_closed) {
    EEPROM.write(22,throttle_valve_closed);
    servo_min = throttle_valve_closed;
    Serial.println("#Writing Servo Min position setting to EEPROM");
  }
  if (servo_max != throttle_valve_open){
    EEPROM.write(23,throttle_valve_open);
    servo_max = throttle_valve_open;
    Serial.println("#Writing Servo Max position setting to EEPROM");
  }
}


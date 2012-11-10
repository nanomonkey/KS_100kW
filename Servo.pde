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



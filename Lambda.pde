// FUEL_PID
void InitFUEL_PID() {
  LoadFUEL_PID();
  LoadPressurePID();
  if (PID_Control == 0){
  FUEL_PID_state = FUEL_POT_CONTROL; 
  } else {
    FUEL_PID_state = FUEL_P_COMB;
  }
}

void DoFUEL_PID() {
    FUEL_PID_input = GetFUEL_PID();
    pressure_input = GetPressure_Input();
    switch(FUEL_PID_state) {
      case FUEL_POT_CONTROL:
        Servo_Mixture.write(air_butterfly_position);
        break;
      case FUEL_P_COMB:
        FUEL_PID.Compute();
        SetPremixServoAngle(FUEL_PID_output);
        pressure_PID.Compute();
        Servo_Mixture.write(pressure_output);
        break;
     }
}

void TransitionFUEL_PID(int new_state) {
  //Exit
  switch (FUEL_PID_state) {
     case FUEL_POT_CONTROL:
       break;
     case FUEL_P_COMB:
       break;
   }
  Serial.print("# FUEL_PID switching from ");
  Serial.print(FUEL_PID_state_name);
  
  //Enter
  FUEL_PID_state=new_state;
  FUEL_PID_state_entered = millis();
  switch (new_state) {
    case FUEL_POT_CONTROL:
      FUEL_PID_state_name = "Butterfly Valve controlled by direct potentiometer control, user directed.";
      break;
    case FUEL_P_COMB:
      FUEL_PID_state_name = "Dual Fuel, CANbus and Combustion Pressure Setpoints";
      FUEL_PID_setpoint = FUEL_PID_setpoint_mode[0];
      //FUEL_PID_output = ??;
      FUEL_PID.SetMode(AUTO);
      FUEL_PID.SetSampleTime(20);
      FUEL_PID.SetInputLimits(0.0,10.0);  //0-10 G/hr
      FUEL_PID.SetOutputLimits(premix_valve_min,premix_valve_max);
      
      pressure_PID.SetMode(AUTO);
      pressure_PID.SetInputLimits(-7000.00, 7000.0);
      pressure_PID.SetOutputLimits(throttle_valve_closed,throttle_valve_open);
      pressure_PID.SetTunings(pressure_P[0], pressure_I[0], pressure_D[0]);
      break;
  }
  Serial.print(" to ");  
  Serial.println(FUEL_PID_state_name);
}
    
double GetFUEL_PID() {
  getFuel(); //0-10 G/hr
  return fuel_input;
}

double GetPressure_Input() {
  return double(Press[P_COMB]);
}

void SetPremixServoAngle(double percent) {
 Servo_Mixture.write(premix_valve_closed + percent*(premix_valve_open-premix_valve_closed));
}

void WriteFUEL_PID() {
  WriteFUEL_PID(FUEL_PID_setpoint);
}

void WriteFUEL_PID(double setpoint) {
  int val,p,i;
  p = constrain(FUEL_PID.GetP_Param()*100,0,255);
  i = constrain(FUEL_PID.GetI_Param()*10,0,255);
  FUEL_PID_setpoint_mode[0] = setpoint;
  val = constrain(128+(setpoint-1.0)*100,0,255);
  EEPROM.write(12,128); //check point
  EEPROM.write(13, val);
  EEPROM.write(14, p);
  EEPROM.write(15, i);
  Serial.println("#Writing FUEL_PID setttings to EEPROM");
}

void LoadFUEL_PID() {
  byte check;
  double val,p,i;
  check = EEPROM.read(12); 
  val = 1.0+(EEPROM.read(13)-128)*0.01;
  p = EEPROM.read(14)*0.01;
  i = EEPROM.read(15)*0.1;
  if (check == 128 && val >= 0.5 && val <= 1.5) { //check to see if FUEL_PID has been set
    Serial.println("#Loading FUEL_PID from EEPROM");
    FUEL_PID_setpoint = val;
    FUEL_PID.SetTunings(p,i,0);
  } else {
    Serial.println("#Saving default FUEL_PID setpoint to EEPROM");
    val = FUEL_PID_setpoint_mode[0];
    WriteFUEL_PID(val);
  }
  FUEL_PID_setpoint = val;
  FUEL_PID_setpoint_mode[0] = val;
}


//PressurePID 
void WritePressurePID() {
  WritePressurePID(pressure_setpoint);
}

void WritePressurePID(double setpoint) {
  int p,i;
  p = constrain(pressure_PID.GetP_Param()*50,0,255);
  i = constrain(pressure_PID.GetI_Param()*5,0,255);
  //pressure_setpoint_mode[0] = setpoint;
  //val = constrain(setpoint,0,255);
  EEPROM.write(112,128); //check point
  //EEPROM.write(113, val);
  EEPROM.write(114, p);
  EEPROM.write(115, i);
  Serial.println("#Writing pressure_pid settings to EEPROM");
}

void LoadPressurePID() {
  byte check;
  double p,i;
  check = EEPROM.read(112); 
  //val = EEPROM.read(113);
  p = EEPROM.read(114)*.02;
  i = EEPROM.read(115)*.2;
  if (check == 128) { //check to see if FUEL_PID has been set
    Serial.println("#Loading pressure_PID values from EEPROM");
    //pressure_setpoint = val;
    pressure_PID.SetTunings(p,i,0);
  } else {
    Serial.println("#Saving default pressure_PID values to EEPROM");
    //val = pressure_setpoint_mode[0];
    WritePressurePID(pressure_setpoint);
  }
  //pressure_setpoint = val;
  //pressure_setpoint_mode[0] = val;
}

// SerialIn
void DoSerialIn() {
  //int incomingByte = 0;
   int relayNum;
   PID &v_PID = lambda_PID;
   double p,i,d;
    double p_d =0.02;
    double i_d = 0.02;
    double d_d = 0.02;
  // Serial input
  if (Serial.available() > 0) {
    p=v_PID.GetP_Param();
    i=v_PID.GetI_Param();
    d=v_PID.GetD_Param();
    serial_last_input = Serial.read();
    switch (serial_last_input) {
    case 'p':
      PrintLambdaUpdate(p,i,d,p+p_d,i,d);
      p=p+p_d;
      v_PID.SetTunings(p,i,d);
      break;
    case 'P':
      PrintLambdaUpdate(p,i,d,p-p_d,i,d);
      p=p-p_d;
      v_PID.SetTunings(p,i,d);
      break;
    case 'i':
      PrintLambdaUpdate(p,i,d,p,i+i_d,d);
      i=i+i_d;
      v_PID.SetTunings(p,i,d);
      break;
    case 'I':
      PrintLambdaUpdate(p,i,d,p,i-i_d,d);
      i=i-i_d;
      v_PID.SetTunings(p,i,d);
      break;
    case 'd':
      PrintLambdaUpdate(p,i,d,p,i,d+d_d);
      d=d+d_d;
      v_PID.SetTunings(p,i,d);
      break;
    case 'D':
      PrintLambdaUpdate(p,i,d,p,i,d-d_d);
      d=d-d_d;
      v_PID.SetTunings(p,i,d);
      break;
    case 'c':
      CalibratePressureSensors();
      LoadPressureSensorCalibration();
      break;
    case 's':
      Servo_Calib.write(Servo_Calib.read()+10);
      Serial.print("#Servo1 (degrees) now:");
      Serial.println(Servo_Calib.read());
      break;
    case 'S':
      Servo_Calib.write(Servo_Calib.read()-10);
      Serial.print("#Servo1 (degrees) now:");
      Serial.println(Servo_Calib.read());
      break;
    case 'l':
      lambda_setpoint += 0.01;
      Serial.print("#Lambda Setpoint now:");
      Serial.println(lambda_setpoint);
      WriteLambda();
      break;
    case 'L':
      lambda_setpoint -= 0.01;
      Serial.print("#Lambda Setpoint now:");
      Serial.println(lambda_setpoint);
      WriteLambda();
      break;
    case 't':
      loopPeriod1 = min(loopPeriod1+100,loopPeriod2);
      Serial.print("#Sample Period now:");
      Serial.println(loopPeriod1);
      break;
    case 'T':
      loopPeriod1 = max(loopPeriod1-100,loopPeriod0);
      Serial.print("#Sample Period now:");
      Serial.println(loopPeriod1);
      break;
    case 'g':  
      grate_val = GRATE_SHAKE_CROSS; //set grate val to shake for grate_on_interval
      Serial.println("#Grate Shaken");
      break;
    case 'G':  
      switch (grateMode) {
      case GRATE_SHAKE_OFF:
        grateMode = GRATE_SHAKE_ON;
        Serial.println("#Grate Mode: On");
        break;
      case GRATE_SHAKE_ON:
        grateMode = GRATE_SHAKE_PRATIO;
        Serial.println("#Grate Mode: Pressure Ratio");
        break;
      case GRATE_SHAKE_PRATIO:
        grateMode = GRATE_SHAKE_OFF;
        Serial.println("#Grate Mode: Off");
        break;
      }
      break;  
    case 'm':
      grate_max_interval += 5;
      grate_min_interval = grate_max_interval*0.5;
      Serial.print("#Grate Max Interval now:");
      Serial.println(grate_max_interval);
      Serial.print("#Grate Min Interval now:");
      Serial.println(grate_min_interval);
      break;
    case 'M':
      grate_max_interval -= 5;
      grate_min_interval = grate_max_interval*0.5;
      Serial.print("#Grate Max Interval now:");
      Serial.println(grate_max_interval);
      Serial.print("#Grate Min Interval now:");
      Serial.println(grate_min_interval);
      break;   
    case 'e':
      TransitionEngine(ENGINE_GOV_TUNING);
      break; 
    case 'R': //R0; turns Relay 0 on.
      relayNum = SerialReadInt();
      if (relayNum >= 0 and relayNum < 8){
        relayOn(relayNum);
        Serial.print("#Setting relay "); Serial.print(relayNum); Serial.println(" on");
      }
      break;
    case 'r': //r0; turns Relay 0 off.
      relayNum = SerialReadInt();
      if (relayNum >= 0 and relayNum < 8){
        relayOn(relayNum);
        Serial.print("#Setting relay "); Serial.print(relayNum); Serial.println(" off");
      }
      break;
    case 'C':
//      logCANbus();
      break;
    case '$':  //Send Canbus PGN request, then read CANbus signal
      long pgn;
      pgn = SerialReadLong();
      if (pgn > 0){
        Serial.print("# Sending PGN: "); Serial.print(pgn); Serial.print(", HEX("); Serial.println(pgn, HEX);
        SendRS232(pgn);
      }
      ReadRS232();
      break;
    }
  }
}

int SerialReadInt(){
  byte incomingByte;
  int integerValue = 0;  
  while(1) {            
    incomingByte = Serial.read();
    if (incomingByte == '\n') break;   // exit the while(1), we're done receiving
    if (incomingByte == ';') break;
    if (incomingByte == -1) continue;  // if no characters are in the buffer read() returns -1
    integerValue *= 10;  // shift left 1 decimal place
    // convert ASCII to integer, add, and shift left 1 decimal place
    integerValue = ((incomingByte - 48) + integerValue);
  }
  return integerValue;
}
    
long SerialReadLong(){
  byte incomingByte;
  long longValue = 0;  
  while(1) {            
    incomingByte = Serial.read();
    if (incomingByte == '\n') break;   // exit the while(1), we're done receiving
    if (incomingByte == ';') break;
    if (incomingByte == -1) continue;  // if no characters are in the buffer read() returns -1
    longValue *= 10;  // shift left 1 decimal place
    // convert ASCII to integer, add, and shift left 1 decimal place
    longValue = ((incomingByte - 48) + longValue);
  }
  return longValue;
}
    

void PrintLambdaUpdate(double P, double I, double D, double nP, double nI, double nD) {
  Serial.print("#Updating PID from [");
  Serial.print(P);
  Serial.print(",");
  Serial.print(I);
  Serial.print(",");
  Serial.print(D);
  Serial.print("] to [");
  Serial.print(nP);
  Serial.print(",");
  Serial.print(nI);
  Serial.print(",");
  Serial.print(nD);
  Serial.println("]");
}








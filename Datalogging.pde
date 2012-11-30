// Datalogging
void LogTime(boolean header = false) {
  if (header) {
    PrintColumn("Time");
  } else {
   PrintColumn(millis()/100.0); 
  }
}

void LogPID(boolean header = false) {
  if (header) {
    PrintColumn("Lambda_In");
    PrintColumn("Lambda_Out");
    PrintColumn("Lambda_Setpoint");
    PrintColumn("Lambda_P");
    PrintColumn("Lambda_I");
    PrintColumn("Lambda_D");
  } 
  else {
    PrintColumn(lambda_input);
    PrintColumn(lambda_output);
    PrintColumn(lambda_setpoint);
    PrintColumn(lambda_PID.GetP_Param());
    PrintColumn(lambda_PID.GetI_Param());
    PrintColumn(lambda_PID.GetD_Param());
  }
}

void LogAnalogInputs(boolean header = false) {
  if (header) {
    PrintColumn("ANA0");
    PrintColumn("ANA1");
    PrintColumn("ANA2");
    PrintColumn("ANA3");
    PrintColumn("ANA4");
    PrintColumn("ANA5");
    PrintColumn("ANA6");
    PrintColumn("ANA7");
  } 
  else {
    PrintColumnInt(analogRead(ANA0));
    PrintColumnInt(analogRead(ANA1));
    PrintColumnInt(analogRead(ANA2));
    PrintColumnInt(analogRead(ANA3));
    PrintColumnInt(analogRead(ANA4));
    PrintColumnInt(analogRead(ANA5));
    PrintColumnInt(analogRead(ANA6));
    PrintColumnInt(analogRead(ANA7));
  }
}

void LogGrate(boolean header = false) {
  if (header) {
    PrintColumn("GrateShakeNum");
    PrintColumn("Grate Period");
    PrintColumn("P_ratio_reactor");
    PrintColumn("P_ratio_state_reactor");
  } 
  else {
    PrintColumnInt(shake_num);
    PrintColumnInt(next_shake/1000);
    PrintColumn(pRatioReactor);
    PrintColumn(pRatioReactorLevel[pRatioReactorLevelName]);
  }
}

void LogFilter(boolean header = false) {
  if (header) {
    PrintColumn("P_ratio_filter");
    PrintColumn("P_ratio_filter_state");
  } 
  else {
    PrintColumn(pRatioFilter);
    //TODO: Move to enum
    if (pRatioFilterHigh) {
      PrintColumn("Bad");
    } 
    else {
      PrintColumn("Good");
    }
  }
}

void LogPressures(boolean header = false) {
  if (header) {
    //TODO: Handle half/full fill
#if P_REACTOR != ABSENT
    PrintColumn("P_REACTOR");
#endif
#if P_FILTER != ABSENT
    PrintColumn("P_FILTER");
#endif
#if P_COMB != ABSENT
    PrintColumn("P_COMB");
#endif
#if P_GAS_OUT != ABSENT
    PrintColumn("P_GAS_OUT");
#endif
#if P_BGRATE != ABSENT
    PrintColumn("P_BGRATE");
#endif
  } 
  else {
#if P_REACTOR != ABSENT
    PrintColumnInt(Press[P_REACTOR]);
#endif
#if P_FILTER != ABSENT
    PrintColumnInt(Press[P_FILTER]);
#endif
#if P_COMB != ABSENT
    PrintColumnInt(Press[P_COMB]);
#endif
#if P_GAS_OUT != ABSENT
    PrintColumn(Press[P_GAS_OUT]);
#endif
#if P_BGRATE != ABSENT
    PrintColumn(Press[P_BGRATE]);
#endif
  }
}

void LogTemps(boolean header = false) {
  if (header) {
#if T_REST1 != ABSENT
    PrintColumn("T_REST1");
#endif
#if T_RED1 != ABSENT
    PrintColumn("T_RED1");
#endif
#if T_RED2 != ABSENT
    PrintColumn("T_RED2");
#endif
#if T_RED3 != ABSENT
    PrintColumn("T_RED3");
#endif
#if T_FLARE != ABSENT
    PrintColumn("T_FLARE");
#endif
#if T_AUGER_GAS_OUT != ABSENT
    PrintColumn("T_AUGER_GAS_OUT");
#endif
#if T_AUGER_FUEL_IN != ABSENT
    PrintColumn("T_AUGER_FUEL_IN");
#endif
#if T_RED4 != ABSENT
    PrintColumn("T_RED4");
#endif
#if T_RED5 != ABSENT
    PrintColumn("T_RED5");
#endif
#if T_BGRATE != ABSENT
    PrintColumn("T_BGRATE");
#endif
#if T_GAS_OUT != ABSENT
    PrintColumn("T_GAS_OUT");
#endif
#if T_TAUGER != ABSENT
    PrintColumn("T_TAUGER");
#endif
  } 
  else {
#if T_REST1 != ABSENT
    PrintColumn(Temp_Data[T_REST1]);
#endif
#if T_RED1 != ABSENT
    PrintColumn(Temp_Data[T_RED1]);
#endif
#if T_RED2 != ABSENT
    PrintColumn(Temp_Data[T_RED2]);
#endif
#if T_RED3 != ABSENT
    PrintColumn(Temp_Data[T_RED3]);
#endif
#if T_FLARE != ABSENT
    PrintColumn(Temp_Data[T_FLARE]);
#endif
#if T_AUGER_GAS_OUT != ABSENT
    PrintColumn(Temp_Data[T_AUGER_GAS_OUT]);
#endif
#if T_AUGER_FUEL_IN != ABSENT
    PrintColumn(Temp_Data[T_AUGER_FUEL_IN]);
#endif
#if T_RED4 != ABSENT
    PrintColumn(Temp_Data[T_RED4]);
#endif
#if T_RED5 != ABSENT
    PrintColumn(Temp_Data[T_RED5]);
#endif
#if T_BGRATE != ABSENT
    PrintColumn(Temp_Data[T_BGRATE]);
#endif
#if T_GAS_OUT != ABSENT
    PrintColumn(Temp_Data[T_GAS_OUT]);
#endif
#if T_TAUGER != ABSENT
    PrintColumn(Temp_Data[T_TAUGER]);
#endif
  }
} 

void LogAuger(boolean header = false) {
  if (header) {
#if ANA_AUGER_CURRENT != ABSENT
    PrintColumn("AugerCurrent");
    PrintColumn("AugerLevel");
#endif
#if ANA_FUEL_SWITCH != ABSENT
    PrintColumn("FuelSwitchLevel");
#endif
  } 
  else {
#if ANA_AUGER_CURRENT != ABSENT
    PrintColumnInt(AugerCurrentValue);
    PrintColumn(AugerCurrentLevel[AugerCurrentLevelName]);
#endif
#if ANA_FUEL_SWITCH != ABSENT
    PrintColumn(FuelSwitchLevel[FuelSwitchLevelName]);
#endif
  }
}

void LogGovernor(boolean header=false) {
  if (header) {
    PrintColumn("ThrottlePercent");
    PrintColumn("ThrottleAngle");
    PrintColumn("Gov_P");
    PrintColumn("Gov_I");
    PrintColumn("Gov_D");
  } 
  else {
    PrintColumnInt(governor_output);
    PrintColumnInt(Servo_Throttle.read());
    PrintColumnInt(governor_PID.GetP_Param());
    PrintColumnInt(governor_PID.GetI_Param());
    PrintColumnInt(governor_PID.GetD_Param());
  }
}

void LogEngine(boolean header=false) {
  if (header) {
    PrintColumn("Engine");
  } 
  else {
    if (engine_state == ENGINE_OFF) {
      PrintColumn("Off");
    }
    if (engine_state == ENGINE_ON) {
      PrintColumn("On");
    }
    if (engine_state == ENGINE_STARTING) {
      PrintColumn("Starting");
    }
  }
}

void LogBatteryVoltage(boolean header=false) {
  if (header) {
    PrintColumn("battery_voltage");
  } 
  else {
    PrintColumn(battery_voltage);
  }
}

void LogReactor(boolean header=false) {
  if (header) {
    PrintColumn("P_reactorLevel");
    PrintColumn("T_rest1Level");
    PrintColumn("T_red1Level");
  } 
  else {
    PrintColumn(P_reactorLevel[P_reactorLevelName]);
    PrintColumn(T_rest1Level[TempLevelName]);
    PrintColumn(T_red1Level[TempLevelName]);
  }
}

void LogFuelFeed(boolean header = false){
  if (header) {
    PrintColumn("Auger");
    PrintColumn("Rotary Valve");
    PrintColumn("Conveyor");
    PrintColumn("Boot");
    PrintColumn("Grate");
  }
  else {
    //Auger
    if(auger_state == AUGER_STOPPED){
      PrintColumn("On");
    }
    else { 
      PrintColumn("Off");
    }
    //Rotary Valve
    switch (rotaryvalve_state) {
    case ROTARYVALVE_OFF:
      PrintColumn("Off");
      break;
    case ROTARYVALVE_ON:
      PrintColumn("On");
      break;
    case ROTARYVALVE_STARTING:
      PrintColumn("Starting");
      break;
    case ROTARYVALVE_STOPPING:
      PrintColumn("Stopping");
      break;
    case ROTARYVALVE_OVERCURRENT:
      PrintColumn("Overcurrent");
      break;
    case ROTARYVALVE_REVERSING:
      PrintColumn("Reversing");
      break;
    }
    //Conveyor 
    if(conveyor_state == CONVEYOR_OFF){
      PrintColumn("Off");
    }
    else {
      PrintColumn("On");
    }
    //Boot 
    switch(boot_state){
    case EMPTY:
      PrintColumn("Empty");
      break;
    case MID:
      PrintColumn("Mid");
      break;
    case FULL:  
      PrintColumn("Full");
      break;
    case UNKNOWN:
      PrintColumn("Unknown");
      break;
    } 
    //Grate
    if (grate_state == GRATE_ON){
      PrintColumn("On");
    }  
    else {
      PrintColumn("Off");
    }
  }
}

void PrintColumn(String str) {
  data_buffer += str;
  data_buffer += ", ";
//  Serial.print(str);
//  Serial.print(", ");  
}

void PrintColumn(float str) {
  dtostrf(str, 5, 3, float_buf);
  data_buffer += float_buf;
  data_buffer += ", ";
//  Serial.print(str);
//  Serial.print(", ");  
}

void PrintColumnInt(int str) {
  data_buffer += str;
  data_buffer += ", ";
//  Serial.print(str);
//  Serial.print(", ");
}

void DoDatalogging() {
  data_buffer="";
  boolean header = false;
  Serial.begin(57600); //reset serial?
  if (lineCount == 0) {
    header = true;
  }
  LogTime(header);
  LogTemps(header);
  LogPressures(header);
  LogAnalogInputs(header);
  LogGrate(header); 
  LogFilter(header); 
  LogReactor(header);
  LogEngine(header);  //update when we know more from Cummins
  LogFuelFeed(header);
  Serial.println(data_buffer);
//  if (sd_loaded){
//    DatalogSD(data_buffer, sd_data_file_name);
//  }
  lineCount++;
}




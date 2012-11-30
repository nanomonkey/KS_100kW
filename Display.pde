void DoDisplay() {
  boolean disp_alt; // Var for alternating value display
  char buf[20];
  char choice[5] = "    ";
  char menu1[] = "NEXT  ADV   +    -  ";
  if (millis() % 2000 > 1000) {
    disp_alt = false;
  } 
  else {
    disp_alt = true;
  }
  switch (display_state) {
  case DISPLAY_SPLASH:
    //Row 0
    Disp_RC(0,0);
    if (GCU_version == V2) {
      Disp_PutStr("   KS GCU V 2.0    ");
    } 
    else if (GCU_version == V3) {
      Disp_PutStr("    KS PCU V 3.0    ");
    }
    //Row 1
    Disp_RC(1,0);
    Disp_PutStr("www.allpowerlabs.org");
    //Row 2
    Disp_RC(2,0);
    sprintf(buf, "        %s        ", CODE_VERSION);
    Disp_PutStr(buf);
    //Row 3
    Disp_RC(3,0);
    Disp_PutStr("                    ");
    Disp_CursOff();
    //Transition out after delay
    if (millis()-display_state_entered>2000) {
      TransitionDisplay(DISPLAY_REACTOR);
    }
    break;
  case DISPLAY_REACTOR:
    Disp_CursOff();
    //Row 0
    Disp_RC(0, 0);
    if (millis()-transition_entered<2000) {
      transition_message.toCharArray(buf,21);
      Disp_PutStr(buf);
    } 
    else {
      if (disp_alt) {
        sprintf(buf, "Trest%4i  ", Temp_Data[T_REST1]);
      } 
      else {
        sprintf(buf, "Trest%s", T_rest1Level[TempLevelName]);
      }
      Disp_PutStr(buf);
      Disp_RC(0, 11);
      sprintf(buf, "Pcomb%4i", Press[P_COMB] / 25);
      Disp_PutStr(buf);
    }
    //Row 1
    Disp_RC(1, 0);
    if (disp_alt) {
      sprintf(buf, "Tred1%4i  ", Temp_Data[T_RED1]);
    } 
    else {
      sprintf(buf, "Tred1%s", T_red1Level[TempLevelName]);
    }
    Disp_PutStr(buf);
    Disp_RC(1, 11);
    sprintf(buf, "Preac%4i", Press[P_REACTOR] / 25);
    Disp_PutStr(buf);

    //Row 2
    Disp_RC(2,0);
    Disp_PutStr("CARBAFGI   ");  //Conveyor, Rotary Valve, Boot, Auger, Fuel Switch, Grate, Ignitor - Header
    
    Disp_RC(2, 11);
    if (true) {
      sprintf(buf, "Pfilt%4i", Press[P_FILTER] / 25);
    } 
    else {
      //TO DO: Implement filter warning
      if (pRatioFilterHigh) {
        sprintf(buf, "Pfilt Bad");
      } 
      else {
        sprintf(buf, "PfiltGood");
      }
    }
    Disp_PutStr(buf);

    //Row 3
    if (millis() % 4000 > 2000 & alarm != ALARM_NONE) {
      Disp_RC(3,0);
      Disp_PutStr(display_alarm[alarm]);
    } 
//    else {
//      Disp_RC(3,0);
//      if (AUGER_RUNNING) {
//        sprintf(buf, "Aug On%3i  ", auger_on_length);
//      } 
//      else {  
//        sprintf(buf, "AugOff%3i  ", auger_off_length);                                                                                                                                                                                                                                                                                                                                                                                                                           
//      }
//      Disp_PutStr(buf);
//      sprintf(buf, "         ");
//      //if (disp_alt) {
//      //  sprintf(buf, "Hz   %4i", int(CalculatePeriodHertz()));
//      //} else {
//      //  sprintf(buf, "Batt%5i", int(battery_voltage*10));
//      //  //sprintf(buf, "Pow %5i", int(CalculatePulsePower()));
//      //}
//      Disp_RC(3, 11);
//      Disp_PutStr(buf);
//    }
    else {
      Disp_RC(3,0);
      GetFuelFeedStates(); 
      display_string.toCharArray(buf, 11);
      Disp_PutStr(buf);
    }
    
    Disp_RC(3,11);
    if (P_reactorLevel != OFF) {
      //the value only means anything if the pressures are high enough, otherwise it is just noise
      sprintf(buf, "Pratio%3i", int(pRatioReactor*100)); //pressure ratio
      Disp_PutStr(buf);
    } 
    else {
      Disp_PutStr("Pratio --");
    }
    break;
    
  case DISPLAY_ENGINE:
    Disp_CursOff();
    Disp_RC(0,0);
//#if T_ENG_COOLANT != ABSENT
//    sprintf(buf, "Tcool%4i  ", Temp_Data[T_ENG_COOLANT]);
//#else
      sprintf(buf, "Tcool  NA  ");
//#endif
    Disp_PutStr(buf);
    Disp_RC(0,11); 
    Disp_PutStr("           ");
    //Row 1
    Disp_RC(1,0); 
    Disp_PutStr("                    ");
    //Row 2
    Disp_RC(2,0); 
    Disp_PutStr("                    ");
    //Row 3
    Disp_RC(3,0);
    Disp_PutStr("                    ");
    Disp_CursOff();
    break;
  case DISPLAY_TESTING:
    Disp_CursOff();
    item_count = 1;
    //Row 0
    Disp_RC(0,0);
    Disp_PutStr("Testing             "); 
    //Row 1			
    Disp_RC(1,0);
    sprintf(buf, "Test:%-15s", TestingStateName[testing_state]);
    Disp_PutStr(buf);
    //Row 2
    Disp_RC(2,0);
    switch (testing_state) {
    case TESTING_ANA_EO2:
      sprintf(buf, "Value: %4i         ", int(analogRead(ANA_EO2)));
      break;
    case TESTING_ANA_FO2:
      sprintf(buf, "Value: %4i         ", int(analogRead(ANA_FO2)));
      break;
    case TESTING_ANA_FUEL_SWITCH:
      sprintf(buf, "Value: %4i         ", int(analogRead(ANA_FUEL_SWITCH)));
      break;
    case TESTING_ANA_POT1:
      sprintf(buf, "Value: %4i         ", int(analogRead(ANA_POT1)));
      break;
    case TESTING_ANA_POT2:
      sprintf(buf, "Value: %4i         ", int(analogRead(ANA_POT2)));
      break;
    default:
      sprintf(buf,"                   ");
    }
    Disp_PutStr(buf);
    //Row 3
    switch (cur_item) {
    case 1: // Testing 
      if (key == 2) {
        GoToNextTestingState(); //first testing state
      }
      Disp_RC(3,0);
      Disp_PutStr("NEXT       TEST     ");
      break;
    default:
      Disp_RC(3,0);
      Disp_PutStr("NEXT                ");
    }
    break;
  case DISPLAY_LAMBDA:
    double P,I;
    item_count = 4;
    P=lambda_PID.GetP_Param();
    I=lambda_PID.GetI_Param();
    Disp_RC(0,0);
    sprintf(buf, "LamSet%3i  ", int(ceil(lambda_setpoint*100.0)));
    Disp_PutStr(buf);
    Disp_RC(0,11);
    sprintf(buf, "Lambda%3i", int(lambda_input*100.0));
    Disp_PutStr(buf);
    //Row 1
    Disp_RC(1,0);
    sprintf(buf, "P     %3i  ", int(ceil(lambda_PID.GetP_Param()*100.0)));
    Disp_PutStr(buf);
    Disp_RC(1,11);
    sprintf(buf, "I     %3i", int(ceil(lambda_PID.GetI_Param()*100.0)));
    Disp_PutStr(buf);
    Disp_RC(2,0);
    Disp_PutStr("                    ");
    switch (cur_item) {
    case 1: // Lambda setpoint
      if (key == 2) {
        lambda_setpoint += 0.01;
        WriteLambda();
      }
      if (key == 3) {
        lambda_setpoint -= 0.01;
        WriteLambda();
      }          
      Disp_RC(0,0);
      Disp_CursOn();
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV   +    -  ");
      break;
    case 2: //Lambda reading
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV           ");
      Disp_RC(0,11);
      Disp_CursOn();
      break;
    case 3: //Lambda P
      if (key == 2) {
        P += 0.01;
        WriteLambda();
      }
      if (key == 3) {
        P -= 0.01;
        WriteLambda();
      }
      lambda_PID.SetTunings(P,I,0);
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV   +    -  ");
      Disp_RC(1,0);
      Disp_CursOn();
      break;
    case 4: //Lambda I
      if (key == 2) {
        I += 0.1;
        WriteLambda();
      }
      if (key == 3) {
        I -= 0.1;
        WriteLambda();
      }
      lambda_PID.SetTunings(P,I,0);
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV   +    -  ");
      Disp_RC(1,11);
      Disp_CursOn();
      break;
    }
    break;
    //Pressure PID:
  case DISPLAY_PRESSURE_PID:
    double pP,pI;
    item_count = 4;
    pP=pressure_PID.GetP_Param();
    pI=pressure_PID.GetI_Param();
    Disp_RC(0,0);
    sprintf(buf, "PcSet%4i  ", int(pressure_setpoint));
    Disp_PutStr(buf);
    Disp_RC(0,11);
    sprintf(buf, "Pcomb%4i", int(pressure_input));
    Disp_PutStr(buf);
    //Row 1
    Disp_RC(1,0);
    sprintf(buf, "P     %3i  ", int(ceil(pressure_PID.GetP_Param())));
    Disp_PutStr(buf);
    Disp_RC(1,11);
    sprintf(buf, "I     %3i", int(ceil(pressure_PID.GetI_Param())));
    Disp_PutStr(buf);
    Disp_RC(2,0);
    Disp_PutStr("                    ");
    switch (cur_item) {
    case 1: // Pressure_PID setpoint
      if (key == 2) {
        pressure_setpoint += 1;
        WritePressurePID();
      }
      if (key == 3) {
        pressure_setpoint -= 1;
        WritePressurePID();
      }          
      Disp_RC(0,0);
      Disp_CursOn();
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV   +    -  ");
      break;
    case 2: //Pcomb reading
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV           ");
      Disp_RC(0,11);
      Disp_CursOn();
      break;
    case 3: //Pressure_PID P
      if (key == 2) {
        pP += 1;
        WritePressurePID();
      }
      if (key == 3) {
        pP -= 1;
        WritePressurePID();
      }
      pressure_PID.SetTunings(pP,pI,0);
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV   +    -  ");
      Disp_RC(1,0);
      Disp_CursOn();
      break;
    case 4: //Pressure_PID I
      if (key == 2) {
        pI += 1;
        WritePressurePID();
      }
      if (key == 3) {
        pI -= 1;
        WritePressurePID();
      }
      pressure_PID.SetTunings(pP,pI,0);
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV   +    -  ");
      Disp_RC(1,11);
      Disp_CursOn();
      break;
    }
    break;
  case DISPLAY_GRATE:
    int vmin,vmax;
    item_count = 4;
    Disp_RC(0,0);
    sprintf(buf, "GraMin%3i  ", grate_min_interval);
    Disp_PutStr(buf);
    Disp_RC(0,11);
    sprintf(buf, "GraMax%3i", grate_max_interval);
    Disp_PutStr(buf);
    //Row 1
    Disp_RC(1,0);
    sprintf(buf, "GraLen%3i  ", grate_on_interval);
    Disp_PutStr(buf);
    Disp_RC(1,11);
    if (grate_state == GRATE_OFF) {
      Disp_PutStr("Grate Off");
    } 
    else {
      Disp_PutStr("Grate  On");
    }
    Disp_RC(2,0);
    Disp_PutStr("                    ");
    switch (cur_item) {
    case 1: // Grate Min Interval
      vmin = max(0,grate_on_interval);
      vmax = grate_max_interval;
      if (key == 2) {

        grate_min_interval += 3;
        grate_min_interval = constrain(grate_min_interval,vmin,vmax);
        CalculateGrate();
        WriteGrate();
      }
      if (key == 3) {
        grate_min_interval -= 3;
        grate_min_interval = constrain(grate_min_interval,vmin,vmax);
        CalculateGrate();
        WriteGrate();
      }
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV   +    -  ");
      Disp_RC(0,0);
      Disp_CursOn();
      break;
    case 2: //Grate Interval
      vmin = max(grate_on_interval,grate_min_interval);
      vmax = 255*3;
      if (key == 2) {
        grate_max_interval += 3;
        grate_max_interval = constrain(grate_max_interval,vmin,vmax);
        CalculateGrate();
        WriteGrate();
      }
      if (key == 3) {
        grate_max_interval -= 3;
        grate_max_interval = constrain(grate_max_interval,vmin,vmax);
        CalculateGrate();
        WriteGrate();
      }
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV   +    -  ");
      Disp_RC(0,11);
      Disp_CursOn();
      break;
    case 3: //Grate On Interval
      vmin = 0;
      vmax = min(grate_min_interval,255);
      if (key == 2) {
        grate_on_interval += 1;
        grate_on_interval = constrain(grate_on_interval,vmin,vmax);
        CalculateGrate();
        WriteGrate();
      }
      if (key == 3) {
        grate_on_interval -= 1;
        grate_on_interval = constrain(grate_on_interval,vmin,vmax);
        CalculateGrate();
        WriteGrate();
      }
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV   +    -  ");
      Disp_RC(1,0);
      Disp_CursOn();
      break;
    case 4: //Grate
      if (key == 2) {
        grate_state = GRATE_OFF;
      }
      grate_val = GRATE_SHAKE_CROSS;
      Disp_RC(3,0);
      Disp_PutStr("NEXT  ADV  OFF   ON ");
      Disp_RC(1,11);
      Disp_CursOn();
      break;  
    }

    break;
    case DISPLAY_SERVO:   //need to add constraints for min and max?
    item_count = 2;
    testing_state = TESTING_SERVO;  //necessary so that there isn't any conflicting servo writes
    Disp_RC(0,0);
    sprintf(buf, "ServoMin%3i", int(throttle_valve_closed));
    Disp_PutStr(buf);
    Disp_RC(0,11);
    sprintf(buf, " Max %3i", int(throttle_valve_open));
    Disp_PutStr(buf);
    //Row 1
    Disp_RC(1,0);
    Disp_PutStr(" Careful of Sides!  "); 
    Disp_RC(2,0);
    Disp_PutStr("                    ");
    switch (cur_item) {
    case 1: // Servo Min
      Servo_Mixture.write(throttle_valve_closed);
      if (key == 2) {
        if (throttle_valve_closed + 1 < throttle_valve_open){
          throttle_valve_closed += 1;
        }
      }
      if (key == 3) {
        throttle_valve_closed -= 1;
      }
      Disp_RC(3,0);
      Disp_PutStr(menu1);
      Disp_RC(0,0);
      Disp_CursOn();
      break;
    case 2: //Servo Max 
      Servo_Mixture.write(throttle_valve_open);
      if (key == 2) {
        throttle_valve_open += 1;
      }
      if (key == 3) {
        if (throttle_valve_open - 1 > throttle_valve_closed) {
          throttle_valve_open -= 1;
        }
      }
      Disp_RC(3,0);
      Disp_PutStr(menu1);
      Disp_RC(0,11);
      Disp_CursOn();
      break;
    }
    break;
  case DISPLAY_CONFIG:
    Disp_CursOff();
    item_count = sizeof(Config_Choices)/sizeof(Config_Choices[0]);
    if (config_changed == false){
      config_var = getConfig(cur_item);
    }
    if (config_var == 255){  //EEPROM default state, not a valid choice.  Loops choice back to zero.
      config_var = 0;
    }
    if (config_var == -1){  //keeps values from being negative
      config_var = 254;
    }
    Disp_RC(0,0);
    Disp_PutStr("   Configurations   ");
    Disp_RC(1,0);
    if (Config_Choices[cur_item-1] == "+    -  "){
      sprintf(buf, "%s:%3i", Configuration[cur_item-1], config_var);
    } else if (Config_Choices[cur_item-1] == "+5   -5 "){
      sprintf(buf, "%s:%3i", Configuration[cur_item-1], 5*config_var);
    } else {
      if (config_var == 0){
      choice[0] = Config_Choices[cur_item-1][0];
      choice[1] = Config_Choices[cur_item-1][1];
      choice[2] = Config_Choices[cur_item-1][2];
      choice[3] = Config_Choices[cur_item-1][3];
      } else {
        choice[0] = Config_Choices[cur_item-1][4];
        choice[1] = Config_Choices[cur_item-1][5];
        choice[2] = Config_Choices[cur_item-1][6];
        choice[3] = Config_Choices[cur_item-1][7];
      }
      sprintf(buf, "%s:%s", Configuration[cur_item-1], choice);
    }
    Disp_PutStr(buf);
    Disp_RC(2,0);
    Disp_PutStr("ADV to save choice  ");
    Disp_RC(3,0);
    sprintf(buf, "NEXT  ADV   %s", Config_Choices[cur_item-1]);
    Disp_PutStr(buf);
    if (Config_Choices[cur_item-1] == "+    -  "){
      if (key == 2) {
        if (config_max[cur_item-1] >= config_var + 1){
          config_var += 1;
          config_changed = true;
        }
      }
      if (key == 3) {
        if (config_min[cur_item-1] <= config_var - 1){
          config_var -= 1;
          config_changed = true;
        }
      } 
    } else if (Config_Choices[cur_item-1] == "+5   -5 "){
      if (key == 2) {
        if (config_max[cur_item-1] >= config_var + 1){
          config_var += 1;
          config_changed = true;
        }
      }
      if (key == 3) {
        if (config_min[cur_item-1] <= config_var - 1){
          config_var -= 1;
          config_changed = true;
        }
      }
    } else {
      if (key == 2) {  
        config_var = 0;
        config_changed = true;
      }
      if (key == 3) {
        config_var = 1;
        config_changed = true;
      }
    }
    break;  
    //    case DISPLAY_TEMP2:
    //      break;
    //    case DISPLAY_FETS:
    //      break;
  }
  key = -1; //important, must clear key to read new input
}

void TransitionDisplay(int new_state) {
  //Enter
  display_state_entered = millis();
  switch (new_state) {
  case DISPLAY_SPLASH:
    break;
  case DISPLAY_REACTOR:
    break;
  case DISPLAY_ENGINE:
    break;
  case DISPLAY_LAMBDA:
    cur_item = 1;
    break;
  case DISPLAY_PRESSURE_PID:
    cur_item = 1;
    break;
  case DISPLAY_GRATE:
    cur_item = 1;
    break;
  case DISPLAY_TESTING:
    cur_item = 1;
    break;
  case DISPLAY_SERVO:
    cur_item = 1;
    break;
  case DISPLAY_CONFIG: 
    cur_item = 1;
    config_changed = false;
    break;
  }
  display_state=new_state;
}

void DoKeyInput() {
  int k;
  k =  Kpd_GetKeyAsync();
  if (key == -1) { //only update key if it has been cleared
    key = k;
  }
  if (key == 0) {
    switch (display_state) {
    case DISPLAY_SPLASH:
      TransitionDisplay(DISPLAY_REACTOR);
      break;
    case DISPLAY_REACTOR:
      TransitionDisplay(DISPLAY_LAMBDA);
      break;
    case DISPLAY_ENGINE:
      TransitionDisplay(DISPLAY_REACTOR);
      break;
    case DISPLAY_LAMBDA:
      TransitionDisplay(DISPLAY_PRESSURE_PID);
      break;
    case DISPLAY_PRESSURE_PID:
      TransitionDisplay(DISPLAY_GRATE);
      break;
    case DISPLAY_GRATE:
      if (engine_state == ENGINE_OFF) {
        TransitionDisplay(DISPLAY_TESTING);
      } 
      else {
        TransitionDisplay(DISPLAY_REACTOR);
      }
      break;
    case DISPLAY_TESTING:
      if (engine_state == ENGINE_OFF){
        TransitionDisplay(DISPLAY_SERVO);
      } else {
      TransitionDisplay(DISPLAY_REACTOR);
      TransitionTesting(TESTING_OFF);
      }
      break;
    case DISPLAY_SERVO:
      WriteServo();
      TransitionTesting(TESTING_OFF);
      TransitionDisplay(DISPLAY_CONFIG);  //assume that engine state is off because we are already in DISPLAY_SERVO
      break;
    case DISPLAY_CONFIG:
      TransitionDisplay(DISPLAY_REACTOR);
      break;
    }
    key = -1; //key caught
  }
  if (key == 1) {
    cur_item++;
    if (cur_item>item_count) {
      cur_item = 1;
    }
    key = -1; //key caught
  }
}

void DoHeartBeat() {
  if (millis() % 50 > 5) {
    bitSet(PORTJ, 7);
  } 
  else {
    bitClear(PORTJ, 7);
  }
  //PORTJ ^= 0x80;    // toggle the heartbeat LED
}

void TransitionMessage(String t_message) {
  transition_message = t_message;
  transition_entered = millis();
}


void GetFuelFeedStates(){  //CRBAGF    
  display_string = "";
    //Conveyor 
  switch (conveyor_state) {
    case CONVEYOR_OFF:
      display_string += "-";
      break;
    case CONVEYOR_ON:
      display_string += "+";
      break;
    case CONVEYOR_REVERSING:
      display_string += "R";
      break;
  }
  //Hopper Agitator
    switch (hopper_agitator_state) {
    case HOPPER_AGITATOR_OFF:
      display_string += "-";
      break;
    case HOPPER_AGITATOR_ON_PULSE:
      display_string += "+";
      break;
    case HOPPER_AGITATOR_ON_PAUSE:
      display_string += "P";
      break;
  }
    //Rotary Valve
  switch (rotaryvalve_state) {
  case ROTARYVALVE_OFF:
    display_string += "-";
    break;
  case ROTARYVALVE_ON:
    display_string += "+";
    break;
  case ROTARYVALVE_STARTING:
    display_string += "S";
    break;
  case ROTARYVALVE_STOPPING:
    display_string += "P";
    break;
  case ROTARYVALVE_OVERCURRENT:
    display_string += "!";
    break;
  case ROTARYVALVE_REVERSING:
    display_string += "<";
    break;
  }

  //Boot 
  switch(boot_state){
    case EMPTY:
      display_string += "E";
      break;
    case MID:
      display_string += "M";
      break;
    case FULL:  
      display_string += "F";
      break;
    case UNKNOWN:
      display_string += "U";
      break;
  } 
  //Auger
  switch(auger_state) {
    case AUGER_STOPPED:
      display_string += "-";
      break;
    case AUGER_ON:
      display_string += "+";
      break;
    case AUGER_REVERSING:
      display_string += "R";
      break;
    default:
      display_string += " ";
      break;
  }
  //Fuel Feed Switch
  if (fuel_demand){
    display_string += "E";
  } else {
    display_string += "F";
  }
  //Grate
  if (grate_state == GRATE_ON){
    display_string += "+";
  }  else {
    display_string += "-";
  }
  //Ignitor
  if (ignitor_on == true) {
    display_string += "+";
  } else {
    display_string += "-";
  }
  display_string += "   ";
}


void saveConfig(int item, int state){  //EEPROM:  0-499 for internal states, 500-999 for configurable states, 1000-4000 for data logging configurations.
  int old_state = EEPROM.read(499+item);
  if(state != old_state){
    EEPROM.write(499+item, state);
    delay(5); //ensure that value is not read until EERPROM has been fully written (~3.3ms)
  }
}

int getConfig(int item){
  int value;
  value = int(EEPROM.read(499+item));
  if (value == 255){  //values hasn't been saved yet to EEPROM, go with default value saved in defaults[]
    value = defaults[item-1];
    EEPROM.write(499+item, value);
  }
  config_changed = true;
  return value;
}

void update_config_var(int var_num){
  switch (var_num) {
    case 1:
      CANbus_speed = getConfig(1); 
      break;
    case 2:
      PR_LOW_boundary = getConfig(2)/100.0;
      //float pRatioReactorLevelBoundary[3][2] = {{PR_HIGH_boundary, 1.0}, {PR_LOW_boundary, 0.6 }, {0.0, PR_LOW_boundary} }; 
      //PR_HIGH = 0, PR_CORRECT = 1, PR_LOW = 2
      pRatioReactorLevelBoundary[PR_CORRECT][0] = PR_LOW_boundary;
      pRatioReactorLevelBoundary[PR_LOW][1] = PR_LOW_boundary;
      break;
    case 3:
      PR_HIGH_boundary = getConfig(3)/100.0;
      pRatioReactorLevelBoundary[PR_HIGH][0] = PR_HIGH_boundary;
      break;
    case 4:
      PID_Control = getConfig(4);
      break;
  }
}

void resetConfig() {  //sets EEPROM configs back to untouched state...
  int default_count = sizeof(defaults)/sizeof(int);
  for (int i=0; i < default_count; i++){
    EEPROM.write(500+i, defaults[i]);
  }
}

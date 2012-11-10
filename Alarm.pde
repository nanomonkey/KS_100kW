void DoAlarmUpdate() {
  //TODO: Move these into their respective object control functions, not alarm
  if (P_reactorLevel != OFF) {                 
    if (fuel_demand) {
      // fuel_demand on
      fuel_demand_on_length++;
      fuel_demand_off_length = 0;
    } else {
      // fuel_demand off
      fuel_demand_off_length++;
      fuel_demand_on_length = 0;
    }
  } else {
    fuel_demand_on_length = 0;
    fuel_demand_off_length = 0;
  }
  
  if ((pRatioReactorLevel == PR_LOW || pRatioReactorLevel == PR_HIGH) && (P_reactorLevel != OFF && P_reactorLevel != LITE)) {  //from DoGrate()
    pressureRatioAccumulator += 1;  //use
  } else {
    pressureRatioAccumulator -= 5;
  }
  
  pressureRatioAccumulator = max(0,pressureRatioAccumulator); //keep value above 0
  pressureRatioAccumulator = min(pressureRatioAccumulator, 65); //keep value below 100
  
  if (boot_state == EMPTY) {
    boot_empty_length++;
  } else {
    boot_empty_length = 0;
  }
  if (boot_state == UNKNOWN){
    boot_unknown_length++;
  } else {
    boot_unknown_length = 0;
  }
}


void DoAlarm() {
  alarm = ALARM_NONE;
  if (P_reactorLevel != OFF) { //alarm only if reactor is running
    if (fuel_demand_on_length >= fuel_demand_on_alarm_point) {
      alarm = ALARM_FUEL_DEMAND_ON_LONG;
      Serial.print("# ");
      Serial.println(display_alarm[alarm]);
    }
    if (fuel_demand_off_length >= fuel_demand_off_alarm_point) {
      alarm = ALARM_FUEL_DEMAND_OFF_LONG;
      Serial.print("# ");
      Serial.println(display_alarm[alarm]);
    }
    if (pressureRatioAccumulator > 60) {
      alarm = ALARM_BAD_REACTOR;
      Serial.print("# ");
      Serial.println(display_alarm[alarm]);
    }
    if (filter_pratio_accumulator > 100) {
      alarm = ALARM_BAD_FILTER;
      Serial.print("# ");
      Serial.println(display_alarm[alarm]);
    }
    if (boot_empty_length > 120) {
      alarm = ALARM_BOOT_EMPTY_LONG;
      Serial.print("# ");
      Serial.println(display_alarm[alarm]);
    }
    if (boot_unknown_length > 60) {
      alarm = ALARM_BOOT_UNKNOWN_STATE;
      Serial.print("# ");
      Serial.println(display_alarm[alarm]);
    }
//    #if T_LOW_FUEL != ABSENT
//    if (Temp_Data[T_LOW_FUEL] > 230) {
//      Serial.println("# Reactor fuel may be low");
//      alarm = ALARM_LOW_FUEL_REACTOR;
//    }
//    #endif
  }
  if (engine_state == ENGINE_ON) {
    if (T_rest1Level != HOT && T_rest1Level != EXCESSIVE) {
      alarm = ALARM_LOW_TREST;
      Serial.print("# ");
      Serial.println(display_alarm[alarm]);
    }
    if ((Temp_Data[T_RED1] == EXCESSIVE)) {
      alarm = ALARM_HIGH_RED1;
      Serial.print("# ");
      Serial.println(display_alarm[alarm]);
    }
//    #if ANA_OIL_PRESSURE != ABSENT
//    if (P_reactorLevel == OIL_P_LOW && millis()-engine_state_entered>10000) {
//      Serial.println("# Bad oil pressure");
//      alarm = ALARM_BAD_OIL_PRESSURE;
//    }
//    #endif
//     #if LAMBDA_SIGNAL_CHECK == TRUE
//    if (lambda_input < 0.52) {
//      Serial.println("# No O2 Sensor Signal");
//      alarm = ALARM_O2_NO_SIG;
//    }
//    #endif
  }

  if (alarm != ALARM_NONE) {
    digitalWrite(FET_ALARM, HIGH);
  } else { 
    digitalWrite(FET_ALARM,LOW);
  }
}

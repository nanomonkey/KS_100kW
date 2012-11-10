void DoFlare() {
  switch (flare_state) {
    case FLARE_OFF:
      break;
    case FLARE_USER_SET:
      if (P_reactorLevel != OFF && engine_state != ENGINE_ON) {
        ignitor_on = true;
        analogWrite(FET_FLARE_IGNITOR,255);
      } else {
        analogWrite(FET_FLARE_IGNITOR,0);
        ignitor_on = false;
//        if (T_rest1Level != COLD) {
//          if (millis() % 15000 > 5000) { //if reactor is hot but not under significant vacuum, still run ignitor infrequently to keep flare lit
//            analogWrite(FET_FLARE_IGNITOR,0);
//            ignitor_on = false;
//          } else {
//            analogWrite(FET_FLARE_IGNITOR,255);
//            ignitor_on = true;
//          }
//        } else {
//          analogWrite(FET_FLARE_IGNITOR,0);
//          ignitor_on = false;
//        }
         
      }
      break;
  }
//  #if FET_BLOWER != ABSENT
//  blower_dial = analogRead(ANA_BLOWER_DIAL);
//  analogWrite(FET_BLOWER,blower_dial/4);
//  #endif
}

void DoReactor() {
  //TODO:Refactor
  //Define reactor condition levels
  for(int i = 0; i < TEMP_LEVEL_COUNT; i++) {
    if (Temp_Data[T_REST1] > T_rest1LevelBoundary[i][0] && Temp_Data[T_REST1] < T_rest1LevelBoundary[i][1]) {
      T_rest1Level = (TempLevels) i;
    }
  }
  for(int i = 0; i < TEMP_LEVEL_COUNT; i++) {
    if (Temp_Data[T_RED1] > T_red1LevelBoundary[i][0] && Temp_Data[T_RED1] < T_red1LevelBoundary[i][1]) {
      T_red1Level = (TempLevels) i;
    }
  }
  for(int i = 0; i < P_REACTOR_LEVEL_COUNT; i++) {
    if (Press[P_REACTOR] > P_reactorLevelBoundary[i][0] && Press[P_REACTOR] < P_reactorLevelBoundary[i][1]) {
      P_reactorLevel = (P_reactorLevels) i;
    }
  }
//  switch (reactor_state) {
//    case REACTOR_OFF:
//      break;
//    case REACTOR_IGNITING:
//      break;
//    case REACTOR_WARMING:
//      break;
//    case REACTOR_COOLING:
//      break;
//    case REACTOR_WARM:
//      break;
//  }
}
  


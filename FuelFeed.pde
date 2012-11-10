void DoHopperAgitator() {
   switch(hopper_agitator_state) {
   case HOPPER_AGITATOR_OFF:
     if (conveyor_state == CONVEYOR_ON) {
       TransitionHopperAgitator(HOPPER_AGITATOR_ON_PULSE);
     }
     break;
   case HOPPER_AGITATOR_ON_PULSE:
     if (conveyor_state == CONVEYOR_OFF) {
       TransitionHopperAgitator(HOPPER_AGITATOR_OFF);
     }
     if (millis() - hopper_agitator_state_entered > hopper_agitator_period * hopper_agitator_duty) {
       TransitionHopperAgitator(HOPPER_AGITATOR_ON_PAUSE);
     }
     break;
   case HOPPER_AGITATOR_ON_PAUSE:
     if (conveyor_state == CONVEYOR_OFF) {
       TransitionHopperAgitator(HOPPER_AGITATOR_OFF);
     }
     if (millis() - hopper_agitator_state_entered > hopper_agitator_period * (1.0 - hopper_agitator_duty)) {
       TransitionHopperAgitator(HOPPER_AGITATOR_ON_PULSE);
     }
     break;
   }
   
}

void TransitionHopperAgitator(int newstate){
  hopper_agitator_state_entered = millis();
  switch (newstate){
    case HOPPER_AGITATOR_OFF:
      hopperAgitatorOff();
      Serial.println("#Hopper Agitator: Off");
      break;
    case HOPPER_AGITATOR_ON_PULSE:
      hopperAgitatorOn();
      Serial.println("#Hopper Agitator: On Pulse");
      break;
    case HOPPER_AGITATOR_ON_PAUSE:
      hopperAgitatorOff();
      Serial.println("#Hopper Agitator: On Pause");
      break;
  }
  hopper_agitator_state = newstate;
}
  
void DoAshOut() {
  //Serial.println(ashout_state);
  switch(ashout_state) {
    case ASHOUT_RUNNING:
      //Serial.println("Ash Out: Running");
      if (millis() - ashout_state_entered > 10000) {
        TransitionAshOut(ASHOUT_STOPPED);      
      }
      break;
    case ASHOUT_STOPPED:
      //Serial.println("Ash Out: Stopped");
      if (millis() - ashout_state_entered > 120000 && P_reactorLevel != OFF) {
        TransitionAshOut(ASHOUT_RUNNING);      
      }
      break;
  }
}

void TransitionAshOut(int newstate){
  ashout_state_entered = millis();
  switch (newstate){
    case ASHOUT_RUNNING:
      analogWrite(FET_ASHOUT,255);
      //Serial.print("# New Ash Out State: Running ");
      //Serial.print(ashout_state);
      //Serial.print("->");
      //Serial.println(newstate);
      break;
    case ASHOUT_STOPPED:
      analogWrite(FET_ASHOUT,0);
      //Serial.print("# New Ash Out State: Stopped");
      //Serial.print(ashout_state);
      //Serial.print("->");
      //Serial.println(newstate);
      break;
  }
  ashout_state = newstate;
}

void DoAshGrate() {
    switch(ashgrate_state) {
    case ASHGRATE_RUNNING:
      if (millis() - ashgrate_state_entered > 2000) {
        TransitionAshGrate(ASHGRATE_REVERSING);      
      }
      break;
    case ASHGRATE_REVERSING:
      if (millis() - ashgrate_state_entered > 500) {
        TransitionAshGrate(ASHGRATE_REVERSING);      
      }
      break;
    case ASHGRATE_STOPPED:
      if (millis() - ashgrate_state_entered > 120000 && P_reactorLevel != OFF) {
        TransitionAshGrate(ASHGRATE_RUNNING);      
      }
      break;
  }
}

void TransitionAshGrate(int newstate){
  ashgrate_state_entered = millis();
  switch (newstate){
    case ASHGRATE_RUNNING:
      ashGrateReverse();
      break;
    case ASHGRATE_STOPPED:
      ashGrateStop();
      break;
  }
  ashgrate_state = newstate;
}

void DoAuger(){
  switch(auger_state){
    case AUGER_STOPPED:
      if (fuel_demand == true) {
        if (boot_state == FULL | boot_state == MID) {
          TransitionAuger(AUGER_REVERSING); //move into reversing first to clear jams
        } else {
          //fuel demand but no fuel in boot:
          //raise alarm after some period
        }
      }
      if (boot_state == UNKNOWN & ( millis() - auger_state_entered > 10000)) {
        TransitionAuger(AUGER_REVERSING); //move into reversing first to clear jams
      }
      break;
    case AUGER_RUNNING:
      if (fuel_demand == false) {
        TransitionAuger(AUGER_STOPPED);
      }
      if (boot_state == EMPTY) {
        TransitionAuger(AUGER_STOPPED);
      }
      if (boot_state == UNKNOWN & (millis() - auger_state_entered > 2000)) {
        TransitionAuger(AUGER_STOPPED);
      }
      if (millis() - auger_state_entered > 5000) {
        TransitionAuger(AUGER_REVERSING); // periodic jam clearing
      }
      break;
    case AUGER_REVERSING:
      if (millis() - auger_state_entered > 1000) {
        TransitionAuger(AUGER_RUNNING); //do jam clearing, then transition to correct rotation
      }
      break;
    }
}

//Add starting and stopping states - rotary valve should start before auger turning on.
void TransitionAuger(int newstate){
  auger_state_entered = millis();
  switch (newstate){
    case AUGER_REVERSING:
      augerReverse();
      break;
    case AUGER_RUNNING:
      augerForward();
      break;
    case AUGER_STOPPED:
      augerStop();
      break;
  }
  auger_state = newstate;
}

void DoRotaryValve() {
  switch (rotaryvalve_state) {
    case ROTARYVALVE_OFF:
      //if (auger_state == AUGER_RUNNING){
        if (boot_state == EMPTY | boot_state == MID){
          TransitionRotaryValve(ROTARYVALVE_STARTING);
        }
      //}
       if (boot_state == UNKNOWN & (millis() - rotaryvalve_state_entered > 10000)) {
         TransitionRotaryValve(ROTARYVALVE_ON);
       }
      break;
    case ROTARYVALVE_STARTING:
      if (millis() >= rotaryvalve_state_entered + rotary_valve_starting_pause){
        TransitionRotaryValve(ROTARYVALVE_ON);
      }
      if (boot_state == FULL) {
        TransitionRotaryValve(ROTARYVALVE_STOPPING);
      }
      break;
    case ROTARYVALVE_ON:
      if (boot_state == FULL){
        TransitionRotaryValve(ROTARYVALVE_STOPPING);
      }
      if (boot_state == UNKNOWN & (millis() - auger_state_entered > 2000)) {
        TransitionRotaryValve(ROTARYVALVE_STOPPING);
      }
      break;
    case ROTARYVALVE_STOPPING:
      if (millis() >= rotaryvalve_state_entered + rotary_valve_stopping_pause){
        TransitionRotaryValve(ROTARYVALVE_OFF);
      }
      if(boot_state == EMPTY | boot_state == MID) {
        TransitionRotaryValve(ROTARYVALVE_ON);
      }
      break;
    case ROTARYVALVE_OVERCURRENT:
      TransitionRotaryValve(ROTARYVALVE_REVERSING);
      break;
  }
}

void TransitionRotaryValve(int new_state) {
  rotaryvalve_state_entered = millis();
  switch (new_state) {
    case ROTARYVALVE_OFF:
      rotaryValveStop();
      break;
    case ROTARYVALVE_STARTING:
      rotaryValveForward();
      break;
    case ROTARYVALVE_ON:
      rotaryValveForward();
      break;
    case ROTARYVALVE_STOPPING:
      break;
    case ROTARYVALVE_OVERCURRENT:
      //rotaryValveForward();
      break;
  }
  rotaryvalve_state=new_state;
}

void DoConveyor(){
  switch (conveyor_state){
    case CONVEYOR_ON:
      if (rotaryvalve_state == ROTARYVALVE_STOPPING){
        TransitionConveyor(CONVEYOR_OFF);
      }
      if (millis()-conveyor_state_entered > 10000) {
        TransitionConveyor(CONVEYOR_REVERSING);
      }
      break;
    case CONVEYOR_REVERSING:
      if (rotaryvalve_state == ROTARYVALVE_STOPPING){
        TransitionConveyor(CONVEYOR_OFF);
      }
      if (millis()-conveyor_state_entered > 2000) {
        TransitionConveyor(CONVEYOR_ON);
      }
      break;
    case CONVEYOR_OFF:
      if (rotaryvalve_state == ROTARYVALVE_ON){
         TransitionConveyor(CONVEYOR_ON);
      }
      break;
  }
}

void TransitionConveyor(int new_state) {
  conveyor_state_entered = millis();
  switch (new_state){
    case CONVEYOR_ON:
      Serial.println("Conveyor: On");
      conveyorForward();
      break;
    case CONVEYOR_REVERSING:
      Serial.println("Conveyor: Reversing");
      conveyorStop();
      break;  
    case CONVEYOR_OFF:
      Serial.println("Conveyor: Off");
      conveyorStop();
      break;
  }
  conveyor_state = new_state;
}

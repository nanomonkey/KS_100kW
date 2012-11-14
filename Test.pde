void TransitionTesting(int new_state) {
  testing_state_entered = millis();
  Serial.print("#Switching to testing state:");
  Serial.println(TestingStateName[new_state]);
  switch (new_state) {
  case TESTING_OFF:
    break;
  case TESTING_FET0:
    analogWrite(FET0,255);
    analogWrite(FET1,0);
    analogWrite(FET2,0);
    analogWrite(FET3,0);
    analogWrite(FET4,0);
    analogWrite(FET5,0);
    analogWrite(FET6,0);
    analogWrite(FET7,0);
    break;
  case TESTING_FET1:
    analogWrite(FET0,0);
    analogWrite(FET1,255);
    analogWrite(FET2,0);
    analogWrite(FET3,0);
    analogWrite(FET4,0);
    analogWrite(FET5,0);
    analogWrite(FET6,0);
    analogWrite(FET7,0);
    break;
  case TESTING_FET2:
    analogWrite(FET0,0);
    analogWrite(FET1,0);
    analogWrite(FET2,255);
    analogWrite(FET3,0);
    analogWrite(FET4,0);
    analogWrite(FET5,0);
    analogWrite(FET6,0);
    analogWrite(FET7,0);
    break;
  case TESTING_FET3:
    analogWrite(FET0,0);
    analogWrite(FET1,0);
    analogWrite(FET2,0);
    analogWrite(FET3,255);
    analogWrite(FET4,0);
    analogWrite(FET5,0);
    analogWrite(FET6,0);
    analogWrite(FET7,0);
    break;
  case TESTING_FET4:
    analogWrite(FET0,0);
    analogWrite(FET1,0);
    analogWrite(FET2,0);
    analogWrite(FET3,0);
    analogWrite(FET4,255);
    analogWrite(FET5,0);
    analogWrite(FET6,0);
    analogWrite(FET7,0);
    break;	
  case TESTING_FET5:
    analogWrite(FET0,0);
    analogWrite(FET1,0);
    analogWrite(FET2,0);
    analogWrite(FET3,0);
    analogWrite(FET4,0);
    analogWrite(FET5,255);
    analogWrite(FET6,0);
    analogWrite(FET7,0);
    break;
  case TESTING_FET6:
    analogWrite(FET0,0);
    analogWrite(FET1,0);
    analogWrite(FET2,0);
    analogWrite(FET3,0);
    analogWrite(FET4,0);
    analogWrite(FET5,0);
    analogWrite(FET6,255);
    analogWrite(FET7,0);
    break;
  case TESTING_FET7:
    analogWrite(FET0,0);
    analogWrite(FET1,0);
    analogWrite(FET2,0);
    analogWrite(FET3,0);
    analogWrite(FET4,0);
    analogWrite(FET5,0);
    analogWrite(FET6,0);
    analogWrite(FET7,255);
    break;
  case TESTING_ANA_EO2:
    break;
  case TESTING_ANA_FO2:
    break;
  case TESTING_ANA_FUEL_SWITCH:
    break;
  case TESTING_ANA_POT1:
    break;
  case TESTING_ANA_POT2:
    break;
  }
  testing_state=new_state;
}

void GoToNextTestingState() {
  switch (testing_state) {
  case TESTING_OFF:
    TransitionTesting(TESTING_FET0);
    break;
  case TESTING_FET0:
    TransitionTesting(TESTING_FET1);
    break;
  case TESTING_FET1:
    TransitionTesting(TESTING_FET2);
    break;
  case TESTING_FET2:
    TransitionTesting(TESTING_FET3);
    break;
  case TESTING_FET3:
    TransitionTesting(TESTING_FET4);
    break;	
  case TESTING_FET4:
    TransitionTesting(TESTING_FET5);
    break;
  case TESTING_FET5:
    TransitionTesting(TESTING_FET6);
    break;
  case TESTING_FET6:
    TransitionTesting(TESTING_FET7);
    break;
  case TESTING_FET7:
    TransitionTesting(TESTING_ANA_EO2);
    break;
  case TESTING_ANA_EO2:
    TransitionTesting(TESTING_ANA_FO2);
    break;
  case TESTING_ANA_FO2:
    TransitionTesting(TESTING_ANA_FUEL_SWITCH);
    break;
  case TESTING_ANA_FUEL_SWITCH:
    TransitionTesting(TESTING_ANA_POT1);
    break;
  case TESTING_ANA_POT1:
    TransitionTesting(TESTING_ANA_POT2);
    break;
  case TESTING_ANA_POT2:
    TransitionTesting(TESTING_OFF);
    break;
  }
}








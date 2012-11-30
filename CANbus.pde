
//void InitCAN(){
//  if(Canbus.init(CANSPEED_250)){  //in kbps: CANSPEED_125 CANSPEED_250 CANSPEED_500
//  //if(Canbus.init(CANbus_speed)) {
//    Serial.println("CAN Init ok");
//    can_init = true;
//  } else {
//      Serial.println("Can't init CAN");
//      can_init = false;
//  }
//  Serial.print("CANSPEED 250: "); Serial.println(CANSPEED_250);
//  
//  if(mcp2515_init(CANSPEED_250)){
//    Serial.println("CAN Init ok");
//    can_init = true;
//  } else {
//      Serial.println("Can't init CAN");
//      can_init = false;
//  }
//}

//void logCANbus(){
//  if (!can_init) InitCAN();
//  
//  char buffer[512];
//  if(Canbus.ecu_req(ENGINE_RPM,buffer) == 1){         /* Request for engine RPM */
//    Serial.print("#Engine RPM: "); Serial.println(buffer);                         
//  } 
////  if(Canbus.ecu_req(VEHICLE_SPEED,buffer) == 1){
////    Serial.print("#Engine Speed: "); Serial.println(buffer);
////  }
//  if(Canbus.ecu_req(ENGINE_COOLANT_TEMP,buffer) == 1){
//    Serial.print("#Engine Cooland Temp: "); Serial.println(buffer);   
//  }
//  if(Canbus.ecu_req(THROTTLE,buffer) == 1){
//    Serial.print("#Throttle: "); Serial.println(buffer);
//  }  
//  if(Canbus.ecu_req(O2_VOLTAGE,buffer) == 1){
//    Serial.print("#O2 Voltage: "); Serial.println(buffer);
//  }   
//  if (Canbus.ecu_req(0xFEB3,buffer) == 1){   //Request for PGN 65203 - .05 L/hour trip fuel rate
//    Serial.print("#PGN 65203: "); Serial.println(buffer);
//  }
//  if (Canbus.ecu_req(0xF004,buffer) == 1){   
//    Serial.print("#PGN 61444: "); Serial.println(buffer);
//  }
//  if (Canbus.ecu_req(0xFEE9,buffer) == 1){   
//    Serial.print("#PGN 65257: "); Serial.println(buffer);
//  }
  
  /*
 Engine Speed is in PGN 61444(0xF004).  It is two bytes long with a resolution of .125 rpm/bit, bytes 4 and 5. Byte 3 of that PGN is the percent engine torque of the engine.
 PGN 65203(0xFEB3) has a parameter called trip fuel rate in .05 L/hour. It is the fifth and sixth bytes.  
 PGN 65257(0xFEE9) has two separate parameters total fuel consumption and trip fuel consumption both are .5L/ bit.  Trip fuel consumption is bytes 1-4 and Total Fuel Consumption is bytes 5-8.  
*/
//}

//void sendCANbus(&message, boolean J1939){
//  if (J1939){
//    mcp2515_send_message_J1939(&message);
//  } else {
//    mcp2515_send_message(&message);
//  }
//}


void InitRS232(){
  Serial.println("# Initializing RS232");
  Serial2.begin(38400);
}

void ReadRS232(){
  byte readbyte;
  char readStream[128] = "";
  int i = 0;
  Serial.print("# RS232: ");
  while (Serial2.available() > 0){
    readbyte = Serial2.read();
    readStream[i] = readbyte;
    i++;
    Serial.print(readbyte);
    if (i == 128) break;
    if (readbyte == '\n') break; 
    if (readbyte == -1) continue;
  }
  Serial.println();
  Serial.print("#readStream: "); Serial.println(readStream);
}

void SendRS232(long PGN){
  sprintf(hex_buf, "%3X", PGN);
  Serial.print("Sending: "); Serial.print(hex_buf); Serial.print(", "); Serial.println(PGN);
  Serial2.println(hex_buf);
}

void getFuel(){
  unsigned long logtime;
  SendRS232(65203);
  logtime = millis();
  while (millis() - logtime < 1000){
    ReadRS232();
  }
  SendRS232(65203);
}

 
  
  

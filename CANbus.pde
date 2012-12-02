

// CANbus via RS232 Serial2 Connection

void InitRS232(){
  Serial.println("# Initializing RS232");
  Serial2.begin(38400);
  Serial2.println("ATI");
}

int ReadRS232(){
  byte readbyte;
  char readStream[20] = ""; //Serial2's buffer is 128, although our incomming feed should be smaller.
  int returnvalue = 0;
  int i = 0;
  while (Serial2.available() > 0){
    readbyte = Serial2.read();
    if (i == 128) break;
    if (readbyte == '\n') break; 
    if (readbyte == '\0') break; 
    if (readbyte == -1) continue;
    if (readbyte == '>') continue; //removes > character, may want to extend this to set i=0, as this is the prompt and beginning of command string.
    if (i==0){
      Serial.print("# RS232: ");
    }
    readStream[i] = readbyte;
    readStream[i+1] = '\0';
    Serial.print(readbyte);
    i += 1;
  }
  Serial.println();
  if (i > 0){
    // Scub value from  readStream
    int returnbytes[] = {0,0,0,0,0,0,0,0};
    sscanf(readStream, "%x %x %x %x %x %x %x %x", &returnbytes[0], &returnbytes[1], &returnbytes[3], &returnbytes[4], &returnbytes[5], &returnbytes[6], &returnbytes[7]);  
    //combine the important bytes
    returnvalue = float(word(returnbytes[6],(returnbytes[7]))); //not sure how to combine these yet...probably need a seperate bit filter for each.
  }
  return returnvalue;
}



void SendPGN(long PGN){
  char hex[6] = "";
  char hex2[8];
  sprintf(hex, "%06X", PGN);
  hex2[0] = toupper(hex[4]);
  hex2[1] = toupper(hex[5]);
  hex2[2] = ' ';
  hex2[3] = toupper(hex[2]);
  hex2[4] = toupper(hex[3]);
  hex2[5] = ' ';
  hex2[6] = toupper(hex[0]);
  hex2[7] = toupper(hex[1]);
  hex2[8]='\0';
  Serial.print("Sending PGN: "); 
  Serial.print(PGN); 
  Serial.print(", "); 
  Serial.println(hex2);
  Serial2.println(hex2);
}

double getFuel(){
  double fuel_consumption = -1;
  Serial2.flush();  //clear out old responces??
  SendPGN(65203);
  while (fuel_consumption = -1) {
    fuel_consumption = ReadRS232();
  //obtain responce
  //convert to G/hr
  }
  return fuel_consumption;
}



//CANbus via internal MCP2515 chip


//void InitCAN(){
//  if(Canbus.init(CANSPEED_250)){  //in kbps: CANSPEED_125 CANSPEED_250 CANSPEED_500
//  //if(Canbus.init(CANbus_speed)) {
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



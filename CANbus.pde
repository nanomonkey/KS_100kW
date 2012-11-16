/*CANbus PINs
update defaults.h in CANbus library to these values:

#define	P_MOSI	J,1
#define	P_MISO	J,0
#define	P_SCK	J,2
#define	MCP2515_CS	H,2 
#define	MCP2515_INT	J,6

Unknown:
#define LED2_HIGH			B,0
#define LED2_LOW			B,0

see 
http://arduino.cc/forum/index.php/topic,8730.0.html# 
http://tucrrc.utulsa.edu/Publications/Arduino/arduino.html
for more info and perhaps a different library
*/



void InitCAN(){
  if(Canbus.init(CANSPEED_500)){  //in kbps: CANSPEED_125 CANSPEED_250 CANSPEED_500
    Serial.println("CAN Init ok");
    can_init = true;
  } else {
      Serial.println("Can't init CAN");
      can_init = false;
  } 
}

void logCANbus(){
  if (!can_init) InitCAN();
  
  char buffer[512];
  if(Canbus.ecu_req(ENGINE_RPM,buffer) == 1){         /* Request for engine RPM */
    Serial.print("#Engine RPM: "); Serial.println(buffer);                         
  } 
//  if(Canbus.ecu_req(VEHICLE_SPEED,buffer) == 1){
//    Serial.print("#Engine Speed: "); Serial.println(buffer);
//  }
  if(Canbus.ecu_req(ENGINE_COOLANT_TEMP,buffer) == 1){
    Serial.print("#Engine Cooland Temp: "); Serial.println(buffer);   
  }
  if(Canbus.ecu_req(THROTTLE,buffer) == 1){
    Serial.print("#Throttle: "); Serial.println(buffer);
  }  
  if(Canbus.ecu_req(O2_VOLTAGE,buffer) == 1){
    Serial.print("#O2 Voltage: "); Serial.println(buffer);
  }   
  if (Canbus.ecu_req(0xFEB3,buffer) == 1){   //Request for PGN 65203 - .05 L/hour trip fuel rate
    Serial.print("PGN 65203, .05 L/hour trip fuel rate: "); Serial.println(buffer);
  }
}

//void sendCANbus(&message, boolean J1939){
//  if (J1939){
//    mcp2515_send_message_J1939(&message);
//  } else {
//    mcp2515_send_message(&message);
//  }
//}

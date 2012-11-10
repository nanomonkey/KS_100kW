void InitSD() {
  pinMode(SS_PIN, OUTPUT); 
  pinMode(MOSI_PIN, OUTPUT); 
  pinMode(MISO_PIN, INPUT); 
  pinMode(SCK_PIN, OUTPUT); 
  Serial.print("#Initializing SD card...");
  if(!SD.begin(SS_PIN)){
    Serial.println("initialization failed. ");
      sd_loaded = false;
  } else {
      Serial.println("card initialized.");
      sd_loaded = true;
      int data_log_num = EEPROMReadInt(30); //reads from EEPROM bytes 30 and 31
      if (data_log_num == 32767){  //unsigned??  --> 65,535
        data_log_num = 1;
      } else { 
        data_log_num++;
      }
      sprintf(sd_data_file_name, "log%05i.csv", data_log_num); 
      Serial.print("#Writing data to ");
      Serial.println(sd_data_file_name);
      EEPROMWriteInt(30, data_log_num); 
  }
}

void DatalogSD(String dataString, char file_name[13]) {    //file_name should be 8.3 format names
  //SD.begin(SS_PIN);
  File dataFile = SD.open(file_name, FILE_WRITE);  //if file doesn't exist it will be created
  if (dataFile) {
    dataFile.println(dataString);
    dataFile.close();
    //Serial.println(dataString);
  }  
  else {
    Serial.print("# Error loading ");
    Serial.println(file_name);
  } 
}

String readSDline(char file_name[13], int line_num = 0){ //pass a filename in the root directory
  char c;
  String SD_line = "";
//  SD.begin(SS_PIN);
  int line_count = 0;
  File file = SD.open(file_name);
  while((c=file.read())>0 && line_count <= line_num){
    if (c == '/n'){
      line_count++;
    }
    if (line_count == line_num && c != '\n'){
      SD_line += c;
    }
  }
  file.close();
  return SD_line;
}

String readSDline(File file, int line_num = 0){ //pass an open file
  char c;
  String SD_line = "";
  int line_count = 0;
  while((c=file.read())>0 && line_count <= line_num){
    if (c == '/n'){
      line_count++;
    }
    if (line_count == line_num && c != '\n'){
      SD_line += c;
    }
  }
  return SD_line;
}

  
void testSD() {
  switch(sd_card.type()) {
    case SD_CARD_TYPE_SD1:
      Serial.println("SD1");
      break;
    case SD_CARD_TYPE_SD2:
      Serial.println("SD2");
      break;
    case SD_CARD_TYPE_SDHC:
      Serial.println("SDHC");
      break;
    default:
      Serial.println("Unknown");
    }
    if (!sd_volume.init(sd_card)) {
      Serial.println("Could not find FAT16/FAT32 partition.\nMake sure you've formatted the card");
      return;
    }
    uint32_t volumesize;
    Serial.print("\nVolume type is FAT");
    Serial.println(sd_volume.fatType(), DEC);
    Serial.println();
    
    volumesize = sd_volume.blocksPerCluster();    // clusters are collections of blocks
    volumesize *= sd_volume.clusterCount();       // we'll have a lot of clusters
    volumesize *= 512;                            // SD card blocks are always 512 bytes
    Serial.print("Volume size (bytes): ");
    Serial.println(volumesize);
    Serial.print("Volume size (Kbytes): ");
    volumesize /= 1024;
    Serial.println(volumesize);
    Serial.print("Volume size (Mbytes): ");
    volumesize /= 1024;
    Serial.println(volumesize);
    Serial.println("\nFiles found on the card (name, date and size in bytes): ");
    sd_root.openRoot(sd_volume);
    sd_root.ls(LS_R | LS_DATE | LS_SIZE);  // list all files in the card with date and size
  
  // print the type of card
  Serial.print("#Card type: ");
  switch(sd_card.type()) {
    case SD_CARD_TYPE_SD1:
      Serial.println("SD1");
      break;
    case SD_CARD_TYPE_SD2:
      Serial.println("SD2");
      break;
    case SD_CARD_TYPE_SDHC:
      Serial.println("SDHC");
      break;
    default:
      Serial.println("Unknown");
  }
  
  if (!sd_volume.init(sd_card)) {
    Serial.println("# Could not find FAT16/FAT32 partition.  Make sure you've formatted the card");
    return;
  }
}

void EEPROMWriteInt(int p_address, int p_value){  
  byte lowByte = ((p_value >> 0) & 0xFF);
  byte highByte = ((p_value >> 8) & 0xFF);
  
  EEPROM.write(p_address, lowByte);
  EEPROM.write(p_address + 1, highByte);
}

unsigned int EEPROMReadInt(int p_address){
  byte lowByte = EEPROM.read(p_address);
  byte highByte = EEPROM.read(p_address + 1);

  return ((lowByte << 0) & 0xFF) + ((highByte << 8) & 0xFF00);
}    
  
      
      

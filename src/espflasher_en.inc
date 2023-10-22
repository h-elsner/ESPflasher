resourcestring                                     {deutsch}

  capForm='GUI for Espressif ESPTOOL';
  capESPtool='Path to esptool';
  capPort='Interface to ESP module';
  capSettings='Settings';
  capFlasher='ESP Tool';
  capFlash='Flash-ID';
  hntFlash='Read info about flash memory.';
  capChip='Chip-ID';
  hntChip='Read chip-ID.';
  capWrite='&Write FW';
  hntWrite='Write firmware as bin file to ESP module.'+lineending+
           'Offset is usual null but can be set otherwise as hex (0x100000 = 1MB) or decimal.'+lineending+
           'A promt for file name will be presented.';
  capRead='&Read FW';
  hntRead='Read firmware as bin file from ESP module.'+lineending+
           'Offset is usual null and size is ALL but can be set otherwise as hex (0x100000 = 1MB) or decimal.'+lineending+
           'A promt for file name will be presented.';
  capImageInfo='Image info';
  hntImageInfo='Read info about the firmware file.'+lineending+
           'A promt for file name will be presented.';
  capErase='Erase all';
  hntErase='Erase the whole (0x0000 to ALL). Better to make a backup before.';
  capClose='&Close';
  hntClose='Close application.';
  titWrite='File name of firmware...';
  titRead='File name to save backup...';
  hntDefault='Set default values.';
  capWait='Wait!';
  hntTest='Check if esptool is installed and what version it has.';
  capDocu='Manual esptool';
  msgWarn='Do you really want to delete?';
  hntSize='Memory size to read or erase.';
  hntOffset='Start addess/offset to read, save or erase.';
  capRegion='Erase Region';
  hntRegion='Erase parts of flash memory'+lineending+
            'Start address and size have to be multiple of 0x1000 / 4096.'+lineending+
            'ALL means to the end of the flash memory.';
  errTool1='The Espressif esptool has to be installed.';
  errTool2='Path to esptool not found. Please install it - see download link.';


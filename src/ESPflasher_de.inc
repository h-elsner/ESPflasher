resourcestring                                     {deutsch}

  capForm='GUI für Espressif ESPTOOL';
  capESPtool='Pfad zum ESPtool';
  capPort='Schnittstelle zum ESP modul';
  capSettings='Einstellungen';
  capFlasher='ESP Tool';
  capFlash='Flash-ID';
  capDownload='Download esptool';
  hntFlash='Info über Flashspeicher auslesen.';
  capChip='Chip-ID';
  hntChip='Auslesen der Chip-ID.';
  capWrite='F&W schreiben';
  hntWrite='Firmware auf ESP schreiben. Offset normalerweise Null,'+lineending+
           'kann aber abweichend in hex (0x100000 = 1MB) oder dezimal angegeben werden.'+lineending+
           'Der Dateiname wird abgefragt.';
  capRead='FW &lesen';
  hntRead='Firmware auf ESP auslesen. Offset normalerweise Null und Größe automatisch (ALL).'+lineending+
           'Größe und Offset kann aber abweichend angegeben wwerden.'+lineending+
           'Der Dateiname wird abgefragt.';
  capImageInfo='Image Info';
  hntImageInfo='Info über das FW Image auslesen. Der Dateiname wird abgefragt.';
  capErase='Erase all';
  hntErase='Den ganzen Flashspeicher (0x0000 bis ALL) löschen. Besser vorher Firmware auslesen.';
  capClose='&Beenden';
  hntClose='Programm schließen.';
  titWrite='Dateiname der Firmware...';
  titRead='Dateiname für Speichern des Backups...';
  hntDefault='Standartwert setzen.';
  capWait='Warten!';
  hntTest='Prüfen, ob es das ESPtool installiert ist und welche Version es hat.';
  capDocu='Anleitung ESPtool';
  msgWarn='Willst du wirklich den Flashspeicher löschen?';
  hntSize='Speichergröße zum Lesen oder Löschen.';
  hntOffset='Startadresse/Offset zum Lesen, Speichern oder Löschen.';
  capRegion='Erase Region';
  hntRegion='Teile des Flashspeichers löschen.'+lineending+
           'Startadresse und Größe müssen Vielfache von 0x1000 bzw. 4096 sein.'+lineending+
           'ALL bei Größe bedeutet bis zum Ende des Flashspeichers.';
  errTool1='Das Espressif ESPtool muss installiert sein.';
  errTool2='Pfad zum Tool nicht gefunden. ESPtool bitte installieren, siehe Download-Link.';


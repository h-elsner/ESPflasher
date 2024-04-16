{********************************************************}
{                                                        }
{                    ESPflasher                          }
{                                                        }
{       Copyright (c) 2023    Helmut Elsner              }
{                                                        }
{       Compiler: FPC 3.2.2   /    Lazarus 2.2.4         }
{                                                        }
{ Pascal programmers tend to plan ahead, they think      }
{ before they type. We type a lot because of Pascal      }
{ verboseness, but usually our code is right from the    }
{ start. We end up typing less because we fix less bugs. }
{           [Jorge Aldo G. de F. Junior]                 }
{********************************************************}

(*
This source is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version.

This code is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

A copy of the GNU General Public License is available on the World Wide Web
at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
Boston, MA 02110-1335, USA.

================================================================================
Brief description:

GUI for some functions of esptool from Espressif  to make it easier to use.
https://github.com/espressif/esptool
https://docs.espressif.com/projects/esptool/en/latest/esp32/

Prcompiled Espressif ESPtool must be installed already (not the *.py tools).
https://github.com/espressif/esptool/releases

--------------------------------------------------------------------------------
History:

2023-07-25   Idea and form design
2023-07-26   First working version
2023-07-27   Update for Windows

==============================================================================*)

unit ESPflasher_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, EditBtn,
  StdCtrls, XMLPropStorage, ExtCtrls, Buttons, Process, Types, lclintf, synaser;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnALL: TButton;
    btnChip: TBitBtn;
    btnClose: TBitBtn;
    btnErase: TBitBtn;
    btnRegion: TBitBtn;
    btnFlash: TBitBtn;
    btnImageInfo: TBitBtn;
    btnNull: TButton;
    btnRead: TBitBtn;
    btnTest: TButton;
    btnUSB: TButton;
    btnWrite: TBitBtn;
    cbPort: TComboBox;
    dlgESPtool: TDirectoryEdit;
    edOffset: TLabeledEdit;
    edSize: TLabeledEdit;
    gbFlash: TGroupBox;
    gbInfo: TGroupBox;
    imgLazarus: TImage;
    ImageList1: TImageList;
    imgESP: TImage;
    Label1: TLabel;
    lblDocu: TLabel;
    lblDownload: TLabel;
    lblESP: TLabel;
    lblESPTool: TLabel;
    lblPort: TLabel;
    lblPortInfo: TLabel;
    lblWait: TLabel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    SaveDialog1: TSaveDialog;
    tsFlasher: TTabSheet;
    tsSettings: TTabSheet;
    XMLPropStorage1: TXMLPropStorage;
    procedure btnALLClick(Sender: TObject);
    procedure btnChipClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEraseClick(Sender: TObject);
    procedure btnFlashClick(Sender: TObject);
    procedure btnImageInfoClick(Sender: TObject);
    procedure btnNullClick(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
    procedure btnRegionClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnUSBClick(Sender: TObject);
    procedure btnWriteClick(Sender: TObject);
    procedure cbPortEditingDone(Sender: TObject);
    procedure dlgESPtoolClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgESPClick(Sender: TObject);
    procedure imgLazarusClick(Sender: TObject);
    procedure lblDocuClick(Sender: TObject);
    procedure lblDocuMouseEnter(Sender: TObject);
    procedure lblDocuMouseLeave(Sender: TObject);
    procedure lblDownloadClick(Sender: TObject);
    procedure lblDownloadMouseEnter(Sender: TObject);
    procedure lblDownloadMouseLeave(Sender: TObject);
    procedure Memo1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memo1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Memo1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure PageControl1Change(Sender: TObject);
  private

  public
    procedure chmod_x;
    procedure ExecuteIt(header: string; params: TStringList);
  end;

  { $I ESPflasher_de.inc}
  {$I ESPflasher_en.inc}

var
  Form1: TForm1;

const
  maxPorts=10;
  trenner='=====================================================';
  trenner1='------------------------------';
  tab2='  ';
  chid='Chip is ';
  conid='Connecting';
  link_download='https://github.com/espressif/esptool/releases';
  link_docu='https://docs.espressif.com/projects/esptool/en/latest/esp32/';
  link_laz='https://www.lazarus-ide.org/';

{$IFDEF WINDOWS}
  esptool='esptool.exe';
  default_port='COM6';
{$ELSE}                                                                         {LINUX}
  esptool='esptool';
  default_port='/dev/ttyUSB0';
{$ENDIF}

implementation

{$R *.lfm}

{ TForm1 }

procedure Merkliste(ml: TComboBox; maxAnzahl: integer);                         {DropDownListe füllen}
begin
  if (ml.Text<>'') and
     (ml.Items.IndexOf(ml.Text)<0) then                                         {noch nicht in Liste}
    ml.Items.Insert(0, ml.Text);
  if ml.Items.Count>MaxAnzahl then                                              {Anzahl in Liste begrenzen}
    ml.Items.Delete(MaxAnzahl);
end;

procedure LinkEnter(lbl: TLabel);
begin
  lbl.Font.Style:=lbl.Font.Style+[fsBold];
end;

procedure LinkLeave(lbl: TLabel);
begin
  lbl.Font.Style:=lbl.Font.Style-[fsBold];
end;

procedure LinkClick(lbl: TLabel; clr: TColor=clPurple);
begin
  if OpenURL(lbl.Hint) then
    lbl.Font.Color:=clr;
end;

procedure SetAsLink(lbl: TLabel; cap: string; link: string=''; clr: TColor=clNavy);
begin
  if link='' then
    lbl.Hint:=cap
  else
    lbl.Hint:=link;
  lbl.Caption:=cap;
  lbl.ParentColor:=false;
  lbl.ParentFont:=false;
  lbl.Font.Color:=clr;
  lbl.Font.Style:=[fsUnderline];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption:=capForm;
  tsFlasher.Caption:=capFlasher;
  tsSettings.Caption:=capSettings;
  lblESPtool.Caption:=capESPtool+tab2+tab2+errTool1;
  dlgESPtool.TextHint:=capESPtool;
  dlgESPtool.Hint:=capESPtool;
  SetAsLink(lblDocu, capDocu, link_docu);
  SetAsLink(lblDownload, capDownload, link_download);
  lblPort.Caption:=capPort;
  cbPort.Text:=default_port;
  lblPortInfo.Caption:=cbPort.Text;
  Merkliste(cbPort, maxPorts);
  Memo1.Lines.Clear;
  btnUSB.Hint:=hntDefault;
  btnALL.Hint:=hntDefault;
  btnNull.Hint:=hntDefault;
  btnFlash.Caption:=capFlash;
  btnFlash.Hint:=hntFlash;
  btnChip.Caption:=capChip;
  btnChip.Hint:=hntChip;
  btnWrite.Caption:=capWrite;
  btnWrite.Hint:=hntWrite;
  btnRead.Caption:=capRead;
  btnRead.Hint:=hntRead;
  btnImageInfo.Caption:=capImageInfo;
  btnImageInfo.Hint:=hntImageInfo;
  btnErase.Caption:=capErase;
  btnErase.Hint:=hntErase;
  btnClose.Caption:=capClose;
  btnClose.Hint:=hntClose;
  btnTest.Hint:=hntTest;
  btnRegion.Caption:=capRegion;
  btnRegion.Hint:=hntRegion;

  OpenDialog1.Title:=titWrite;
  SaveDialog1.Title:=titRead;
  edOffset.Hint:=hntOffset;
  edSize.Hint:=hntSize;
end;

procedure TForm1.imgESPClick(Sender: TObject);
begin
  LinkClick(lblDocu);
end;

procedure TForm1.imgLazarusClick(Sender: TObject);
begin
  OpenURL(link_laz);
end;

procedure TForm1.lblDocuClick(Sender: TObject);                                 {URL aufrufen}
begin
  linkClick(lblDocu);
end;

procedure TForm1.lblDocuMouseEnter(Sender: TObject);                            {Link animieren}
begin
  LinkEnter(lblDocu);
end;

procedure TForm1.lblDocuMouseLeave(Sender: TObject);
begin
  LinkLeave(lblDocu);
end;

procedure TForm1.lblDownloadClick(Sender: TObject);
begin
  LinkClick(lblDownload);
end;

procedure TForm1.lblDownloadMouseEnter(Sender: TObject);
begin
  LinkEnter(lblDownload);
end;

procedure TForm1.lblDownloadMouseLeave(Sender: TObject);
begin
  LinkLeave(lblDownload);
end;

procedure TForm1.Memo1MouseUp(Sender: TObject; Button: TMouseButton;            {Protokoll löschen}
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button=mbMiddle) and (ssCtrl in Shift) then
    Memo1.Lines.Clear;
end;

procedure TForm1.Memo1MouseWheelDown(Sender: TObject; Shift: TShiftState;       {Font size mit Mausrad ändern}
  MousePos: TPoint; var Handled: Boolean);
begin
  if ssCtrl in Shift then
    Memo1.Font.Size:=Memo1.Font.Size-1;
end;

procedure TForm1.Memo1MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if ssCtrl in Shift then
    Memo1.Font.Size:=Memo1.Font.Size+1;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

procedure TForm1.ExecuteIt(header: string; params: TStringList);                {ESPtool Kommando ausführen}
var
  cmd: TProcess;
  outlist: TStringList;
  i: integer;
  s: string;

begin
  lblPortInfo.Caption:=cbPort.Text;
  lblWait.Caption:=capWait;
  Application.ProcessMessages;
  outlist:=TStringList.Create;
  cmd:=TProcess.Create(nil);
  s:='';
  try
    cmd.Options:=cmd.Options+[poWaitOnExit, poUsePipes, poNoConsole];
    cmd.Executable:=IncludeTrailingPathDelimiter(dlgESPtool.Text)+esptool;
    cmd.Parameters.Assign(params);
    cmd.Execute;
    outlist.LoadFromStream(cmd.Output);

    for i:=2 to length(header) do
      s:=s+'-';
    if memo1.Lines.Count>2 then
       Memo1.Lines.Add(trenner);
    Memo1.Lines.Add('');
    Memo1.Lines.Add(header);
    Memo1.Lines.Add(s);
    Memo1.Lines.Add('');
    for i:=0 to outlist.Count-1 do begin
      if pos(chid, outlist[i])>0 then begin
        lblESP.Caption:=StringReplace(outlist[i], chid, '', [rfIgnoreCase]);
        Memo1.Lines.Add(trenner1);
      end;
      if pos('%)', outlist[i])<1 then
         Memo1.Lines.Add(outlist[i]);
    end;
    Memo1.Lines.Add('');
    Memo1.SelStart:=length(Memo1.Text);                                         {Memo nach unten scrollen}
  finally
    outlist.Free;
    cmd.Free;
    Screen.Cursor:=crDefault;
    lblWait.Caption:='';
  end;
end;

procedure TForm1.btnReadClick(Sender: TObject);
var
  params: TStringList;
  header: string;

begin
  SaveDialog1.FileName:='ESP_backup.bin';                                       {Dateiname vorschlagen}
  if SaveDialog1.Execute then begin
    Screen.Cursor:=crHourGlass;
    params:=TStringList.Create;
    try
      header:='read_flash';
      params.Add('-p');
      params.Add(cbPort.Text);
      params.Add('-b');
      params.Add('460800');
      params.Add(header);
      params.Add(edOffset.Text);
      params.Add(edSize.Text);
      params.Add(SaveDialog1.FileName);
      ExecuteIt(header+': '+ExtractFileName(SaveDialog1.FileName), params);
    finally
      params.Free;
    end;
  end;
end;

procedure TForm1.btnRegionClick(Sender: TObject);                               {esptool erase_region [-h] [--force] [--spi-connection SPI_CONNECTION] address size}
var
  params: TStringList;
  header: string;

begin
  header:='erase_region';
  if MessageDlg(header, msgWarn, mtConfirmation, [mbYes, mbNo], 0)=mrYes then begin
    params:=TStringList.Create;
    try
      params.Add(header);
      params.Add(edOffset.Text);
      params.Add(edSize.Text);
      ExecuteIt(header, params);
    finally
      params.Free;
    end;
  end;
end;

procedure TForm1.btnTestClick(Sender: TObject);                                 {Test ob ESPtool installiert ist}
var
  param: TStringList;
  header: string;
  cmd: TProcess;
  i: integer;

begin
  Memo1.Lines.Clear;
  if FileExists(IncludeTrailingPathDelimiter(dlgESPtool.Text)+esptool) then begin
    param:=TStringList.Create;
    try
      header:='version';
      param.Add(header);
      ExecuteIt(header+': ', param);

{$IFDEF LINUX}                                                                  {Ports for LINUX}
      cmd:=TProcess.Create(nil);
      cmd.Options:=cmd.Options+[poWaitOnExit, poUsePipes];
      cmd.Executable:='lsusb';
      cmd.Parameters.Clear;
      cmd.Execute;
      param.LoadFromStream(cmd.Output);
      Memo1.Lines.Add('lsusb');
      for i:=0 to param.Count-1 do
        Memo1.Lines.Add(param[i]);
      Memo1.Lines.Add('');
      cmd.Executable:='ls';
      cmd.Parameters.Clear;
      cmd.Parameters.Add('-l');
      cmd.Parameters.Add(cbPort.Text);
      cmd.Execute;
      param.LoadFromStream(cmd.Output);
      Memo1.Lines.Add('ls -l '+cbPort.Text);
      for i:=0 to param.Count-1 do
        Memo1.Lines.Add(param[i]);
      Memo1.Lines.Add('');
{$ENDIF}
{$IFDEF WINDOWS}                                                                {COM ports from Windows}
      cbPort.Items.CommaText:=GetSerialPortNames;
      Memo1.Lines.Add('Ports:');
      Memo1.Lines.Add('------');
      for i:= 0 to cbPort.Items.Count-1 do
        Memo1.Lines.Add(cbPort.Items[i]);
{$ENDIF}
      Memo1.Lines.Add('');
    finally
      param.Free;
{$IFDEF LINUX}                                                                  {Ports for LINUX}
      cmd.Free;
{$ENDIF}
    end;
  end else begin
    Memo1.Lines.Add(errTool1);
    Memo1.Lines.Add(errTool2);
  end;
end;

procedure TForm1.btnUSBClick(Sender: TObject);                                  {Defaults setzen}
begin
  cbPort.Text:=cbPort.Items[cbPort.Items.Count-1];
  Merkliste(cbPort, maxPorts);
end;

procedure TForm1.btnALLClick(Sender: TObject);
begin
  edSize.Text:='ALL';
end;

procedure TForm1.btnNullClick(Sender: TObject);
begin
  edOffset.Text:='0x0000';
end;

procedure TForm1.btnWriteClick(Sender: TObject);
var
  params: TStringList;
  header: string;

begin
  if OpenDialog1.Execute then begin
    Screen.Cursor:=crHourGlass;
    params:=TStringList.Create;
    Caption:=capForm+tab2+ExtractFileName(OpenDialog1.FileName);
    try
      header:='write_flash';
      params.Add('-p');
      params.Add(cbPort.Text);
      params.Add(header);
      params.Add(edOffset.Text);
      params.Add(OpenDialog1.FileName);
      ExecuteIt(header+': '+ExtractFileName(OpenDialog1.FileName), params);
    finally
      params.Free;
    end;
  end;
end;

procedure TForm1.cbPortEditingDone(Sender: TObject);
begin
  Merkliste(cbPort, maxPorts);
end;

procedure TForm1.chmod_x;
var
  cmd: TProcess;

begin
  {$IFDEF LINUX}                                                                {Make esptool it executable for LINUX}
    cmd:=TProcess.Create(nil);
    try
      cmd.Executable:='chmod';
      cmd.Parameters.Clear;
      cmd.Parameters.Add('+x');
      cmd.Parameters.Add(IncludeTrailingPathDelimiter(dlgESPtool.Text)+'esptool');
      cmd.Execute;                                                               {geht nicht mit wildcards, aber warum???}
    finally
      cmd.Free;
    end;
  {$ENDIF}
end;

procedure TForm1.dlgESPtoolClick(Sender: TObject);
begin
  chmod_x;
end;


procedure TForm1.FormActivate(Sender: TObject);
begin
  {$IFDEF WINDOWS}                                                              {COM ports from Windows}
    cbPort.Items.CommaText:=GetSerialPortNames;
  {$ENDIF}
  if FileExists(IncludeTrailingPathDelimiter(dlgESPtool.Text)+esptool) then begin
    lblWait.Caption:='';
    PageControl1.ActivePage:=tsFlasher;
  end else begin
    lblWait.Caption:='!';
    PageControl1.ActivePage:=tsSettings;
    Memo1.Lines.Add(errTool1);
    Memo1.Lines.Add(errTool2);
  end;
end;

procedure TForm1.btnChipClick(Sender: TObject);
var
  params: TStringList;
  header: string;

begin
  params:=TStringList.Create;
  try
    params.Add('-p');
    params.Add(cbPort.Text);
    header:='chip_id';
    params.Add(header);
    ExecuteIt(header, params);
  finally
    params.Free;
  end;
end;

procedure TForm1.btnFlashClick(Sender: TObject);
var
  params: TStringList;
  header: string;

begin
  params:=TStringList.Create;
  try
    params.Add('-p');
    params.Add(cbPort.Text);
    header:='flash_id';
    params.Add(header);
    ExecuteIt(header, params);
  finally
    params.Free;
  end;
end;

procedure TForm1.btnImageInfoClick(Sender: TObject);
var
  params: TStringList;
  header: string;

begin
  if OpenDialog1.Execute then begin
    params:=TStringList.Create;
    try
      header:='image_info';
      params.Add(header);
      params.Add(OpenDialog1.FileName);
      params.Add('-v');
      params.Add('2');
      ExecuteIt(header+': '+ExtractFileName(OpenDialog1.FileName), params);
    finally
      params.Free;
    end;
  end;
end;

procedure TForm1.btnEraseClick(Sender: TObject);
var
  params: TStringList;
  header: string;

begin
  header:='erase_flash';
  if MessageDlg(header, msgWarn, mtConfirmation, [mbYes, mbNo], 0)=mrYes then begin
    params:=TStringList.Create;
    try
      params.Add(header);
      ExecuteIt(header, params);
    finally
      params.Free;
    end;
  end;
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.


{*******************************************************}
{                                                       }
{                       Log4Pascal                      }
{        https://github.com/martinusso/log4pascal       }
{                                                       }
{             This software is open source,             }
{       licensed under the The MIT License (MIT).       }
{                                                       }
{*******************************************************}

unit Log4Pascal;

interface

type
  TLogger = class
  private
    FFileName: string;
    FIsInit: Boolean;
    FOutFile: TextFile;
    FQuietMode: Boolean;
    procedure Initialize();
    procedure Finalize();
    procedure Write(const Msg: string);
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    procedure SetQuietMode();
    procedure SetNoisyMode();
 
    procedure Warning(const MsgWarning: string);
    procedure Error(const MsgError: string);
    procedure Msg(const Msg: string);
    procedure Debug(const MsgDebug: string);
  end;
 
var
  Logger: TLogger;
 
implementation
 
uses
  SysUtils;
 
{ TLogger }
 
constructor TLogger.Create(const FileName: string);
begin
  FFileName := FileName;
  FIsInit := False;
  Self.SetNoisyMode();
end;
 
procedure TLogger.Debug(const MsgDebug: string);
begin
  if DebugHook <> 0 then
    Self.Write(MsgDebug);
end;

destructor TLogger.Destroy;
begin
  Self.Finalize();
  inherited;
end;
 
procedure TLogger.Error(const MsgError: string);
begin
  Self.Write('! ' + MsgError);
end;
 
procedure TLogger.Finalize;
begin
  if (FIsInit and (not FQuietMode)) then
    CloseFile(FOutFile);
  FIsInit := False;
end;
 
procedure TLogger.Initialize();
begin
  if FIsInit then CloseFile(FOutFile);
 
  if (not FQuietMode) then
  begin
    AssignFile(FOutFile, FFileName);
    if not FileExists(FFileName) then
      Rewrite(FOutFile)
    else
      Append(FOutFile);
  end;
 
  FIsInit := True;
end;
 
procedure TLogger.Msg(const Msg: string);
begin
  Self.Write(Msg);
end;
 
procedure TLogger.SetNoisyMode;
begin
  FQuietMode := False;
end;
 
procedure TLogger.SetQuietMode();
begin
  FQuietMode := True;
end;
 
procedure TLogger.Warning(const MsgWarning: string);
begin
  Self.Write('. ' + MsgWarning);
end;
 
procedure TLogger.Write(const Msg: string);
begin
  if FQuietMode then Exit;
 
  Self.Initialize();
  try
    if FIsInit then
      Writeln(FOutFile, Msg + Format(' [%s]', [DateTimeToStr(Now)]));
  finally
    Self.Finalize();
  end;
end;
 
initialization
  Logger := TLogger.Create('Log.txt');
 
finalization
  Logger.Free();
 
end.

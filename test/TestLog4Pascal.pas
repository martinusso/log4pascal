unit TestLog4Pascal;

interface

uses
  Classes,
  TestFramework, Log4Pascal;

type
  // Test methods for class TLogger

  TestTLogger = class(TTestCase)
  public
    procedure SetUp; override;
    procedure TearDown; override;

    function ReadFile: TStrings;
    function GetDateTime: string;
  published
    procedure TestTrace;
    procedure TestInfo;
    procedure TestWarning;
    procedure TestError;
    procedure TestFatal;

    procedure TestSetQuietMode;
    procedure TestTraceLogTurnedOnOff;
    procedure TestInfoLogTurnedOnOff;
    procedure TestWarningLogTurnedOnOff;
    procedure TestErrorLogTurnedOnOff;
    procedure TestFatalLogTurnedOnOff;

    procedure TestSetNoisyMode;

    procedure TestMultipleLines;

    procedure TestClear;

    procedure TestChangeFormatDateTime;
  end;

implementation

uses
  Windows, SysUtils;

const
  FORMAT_TRACE = 'TRACE %s [%s]';
  FORMAT_INFO  = 'INFO  %s [%s]';
  FORMAT_WARN  = 'WARN  %s [%s]';
  FORMAT_ERROR = 'ERROR %s [%s]';
  FORMAT_FATAL = 'FATAL %s [%s]';

function TestTLogger.GetDateTime: string;
begin
  Result := FormatDateTime(FORMAT_DATETIME_DEFAULT, Now);
end;

function TestTLogger.ReadFile: TStrings;
begin
  Result := TStringList.Create;
  Result.Clear;

  if not FileExists(Logger.FileName) then Exit;

  Result.LoadFromFile(Logger.FileName);
end;

procedure TestTLogger.SetUp;
begin
  SysUtils.DeleteFile(Logger.FileName);
end;

procedure TestTLogger.TearDown;
begin
  SysUtils.DeleteFile(Logger.FileName);
end;

procedure TestTLogger.TestSetQuietMode;
begin
  Logger.SetQuietMode;
  Logger.Info('any message');

  CheckEquals('', Self.ReadFile().Text);
end;

procedure TestTLogger.TestTrace;
var
  MsgTrace: string;
  MsgInLogFormat: string;
begin
  MsgTrace := 'Trace message test';
  Logger.Trace(MsgTrace);

  // Do not check the time
  MsgInLogFormat := Copy(Format(FORMAT_TRACE, [MsgTrace, Self.GetDateTime()]), 1, 35);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Text, 1, 35));
end;

procedure TestTLogger.TestTraceLogTurnedOnOff;
begin
  Logger.SetNoisyMode;
  Logger.Trace('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  Logger.Clear;
  Logger.DisableTraceLog;
  Logger.Trace('any message');
  CheckEquals('', Self.ReadFile().Text);

  Logger.EnableTraceLog();
  Logger.Trace('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled trace log');
end;

procedure TestTLogger.TestSetNoisyMode;
var
  Msg: string;
  MsgInLogFormat: string;
begin
  Logger.SetQuietMode;
  Logger.Info('any message');

  CheckEquals('', Self.ReadFile().Text);

  Msg := 'any noised message';
  Logger.SetNoisyMode;
  Logger.Info(Msg);

  // Do not check the time
  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [Msg, Self.GetDateTime()]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Text, 1, 31));
end;

procedure TestTLogger.TestWarning;
var
  MsgWarning: string;
  MsgWarningInLogFormat: string;
begin
  MsgWarning := 'Warning message test';
  Logger.Warning(MsgWarning);

  // Do not check the time
  MsgWarningInLogFormat:= Copy(Format(FORMAT_WARN, [MsgWarning, Self.GetDateTime()]), 1, 33);
  CheckEquals(MsgWarningInLogFormat, Copy(Self.ReadFile().Text, 1, 33));
end;

procedure TestTLogger.TestWarningLogTurnedOnOff;
begin
  Logger.SetNoisyMode;
  Logger.Warning('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  Logger.Clear;
  Logger.DisableWarningLog;
  Logger.Warning('any message');
  CheckEquals('', Self.ReadFile().Text, 'disabled warning log');

  Logger.EnableWarningLog;
  Logger.Warning('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled warning log');
end;

procedure TestTLogger.TestChangeFormatDateTime;
const
  MSG = 'any message';
begin
  Logger.Clear();
  Logger.Info(MSG);
  // INFO  any message [9999-99-99 99:99;99]
  // = 39 chars
  CheckEquals(39, Length(Trim(Self.ReadFile().Text)), 'check length');


  Logger.Clear();
  Logger.SetFormatDateTime('dd/mmm/yy');
  Logger.Info(MSG);
  // INFO  any message [99-aaa-99]
  // = 29 chars
  CheckEquals(29, Length(Trim(Self.ReadFile().Text)), 'check length');
end;

procedure TestTLogger.TestClear;
begin
  Logger.Error('Error message');
  Logger.Warning('Warning message');
  Logger.Info('Normal message');
  CheckNotEquals('', Self.ReadFile().Text);

  Logger.Clear();
  CheckEquals('', Self.ReadFile().Text);
end;

procedure TestTLogger.TestError;
var
  MsgError: string;
  MsgErrorInLogFormat: string;
begin
  MsgError := 'Error message test';
  Logger.Error(MsgError);

  // Do not check the time
  MsgErrorInLogFormat := Copy(Format(FORMAT_ERROR, [MsgError, Self.GetDateTime()]), 1, 33);
  CheckEquals(MsgErrorInLogFormat, Copy(Self.ReadFile().Text, 1, 33));
end;

procedure TestTLogger.TestErrorLogTurnedOnOff;
begin
  Logger.SetNoisyMode;
  Logger.Error('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  Logger.Clear;
  Logger.DisableErrorLog;
  Logger.Error('any message');
  CheckEquals('', Self.ReadFile().Text, 'disabled error log');

  Logger.EnableErrorLog;
  Logger.Error('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled error log');
end;

procedure TestTLogger.TestFatal;
var
  MsgError: string;
  MsgErrorInLogFormat: string;
begin
  MsgError := 'Fatal message test';
  Logger.Fatal(MsgError);

  // Do not check the time
  MsgErrorInLogFormat := Copy(Format(FORMAT_FATAL, [MsgError, Self.GetDateTime()]), 1, 35);
  CheckEquals(MsgErrorInLogFormat, Copy(Self.ReadFile().Text, 1, 35));
end;

procedure TestTLogger.TestFatalLogTurnedOnOff;
begin
  Logger.SetNoisyMode;
  Logger.Fatal('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  Logger.Clear;
  Logger.DisableFatalLog;
  Logger.Fatal('any message');
  CheckEquals('', Self.ReadFile().Text, 'disabled fatal log');

  Logger.EnableFatalLog;
  Logger.Fatal('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled fatal log');
end;

procedure TestTLogger.TestInfo;
var
  Msg: string;
  MsgInLogFormat: string;
begin
  Msg := 'Info message test';
  Logger.Info(Msg);

  // Do not check the time
  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [Msg, Self.GetDateTime()]), 1, 35);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Text, 1, 35));
end;

procedure TestTLogger.TestInfoLogTurnedOnOff;
begin
  Logger.SetNoisyMode;
  Logger.Info('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  Logger.Clear;
  Logger.DisableInfoLog;
  Logger.Info('any message');
  CheckEquals('', Self.ReadFile().Text);

  Logger.EnableInfoLog;
  Logger.Info('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled info log');
end;

procedure TestTLogger.TestMultipleLines;
var
  MsgLine1, MsgLine2, MsgLine3: string;
  MsgInLogFormat: string;
begin
  MsgLine1 := 'Line #1: Normal message test';
  Logger.Info(MsgLine1);

  MsgLine2 := 'Line #2: Normal message test';
  Logger.Info(MsgLine2);

  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [MsgLine1, Self.GetDateTime()]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Strings[0], 1, 31));

  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [MsgLine2, Self.GetDateTime()]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Strings[1], 1, 31));


  MsgLine3 := MsgLine2;
  Logger.Info(MsgLine3);

  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [MsgLine3, Self.GetDateTime()]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Strings[2], 1, 31));

end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTLogger.Suite);
end.

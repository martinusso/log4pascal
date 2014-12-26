unit TestLog4Pascal;

interface

uses
  Classes,
  TestFramework, Log4Pascal;

type
  // Test methods for class TLogger

  TestTLogger = class(TTestCase)
  strict private
    FLogger: TLogger;
  public
    procedure SetUp; override;
    procedure TearDown; override;

    function ReadFile: TStrings;
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
  end;

implementation

uses
  Windows, SysUtils;

const
  FILE_LOG = 'test_log.txt';
  FORMAT_TRACE = 'TRACE %s [%s]';
  FORMAT_INFO  = 'INFO  %s [%s]';
  FORMAT_WARN  = 'WARN  %s [%s]';
  FORMAT_ERROR = 'ERROR %s [%s]';
  FORMAT_FATAL = 'FATAL %s [%s]';

function TestTLogger.ReadFile: TStrings;
begin
  Result := TStringList.Create;
  Result.Clear;

  if not FileExists(FILE_LOG) then Exit;

  Result.LoadFromFile(FILE_LOG);
end;

procedure TestTLogger.SetUp;
begin
  FLogger := TLogger.Create(FILE_LOG);
  Windows.DeleteFile(FILE_LOG);
end;

procedure TestTLogger.TearDown;
begin
  FLogger.Free;
  FLogger := nil;

  Windows.DeleteFile(FILE_LOG);
end;

procedure TestTLogger.TestSetQuietMode;
begin
  FLogger.SetQuietMode;
  FLogger.Info('any message');

  CheckEquals('', Self.ReadFile().Text);
end;

procedure TestTLogger.TestTrace;
var
  MsgTrace: string;
  MsgInLogFormat: string;
begin
  MsgTrace := 'Trace message test';
  FLogger.Trace(MsgTrace);

  // Do not check the time
  MsgInLogFormat := Copy(Format(FORMAT_TRACE, [MsgTrace, DateTimeToStr(Now)]), 1, 35);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Text, 1, 35));
end;

procedure TestTLogger.TestTraceLogTurnedOnOff;
begin
  FLogger.SetNoisyMode;
  FLogger.Trace('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  FLogger.Clear;
  FLogger.DisableTraceLog;
  FLogger.Trace('any message');
  CheckEquals('', Self.ReadFile().Text);

  FLogger.EnableTraceLog();
  FLogger.Trace('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled trace log');
end;

procedure TestTLogger.TestSetNoisyMode;
var
  Msg: string;
  MsgInLogFormat: string;
begin
  FLogger.SetQuietMode;
  FLogger.Info('any message');

  CheckEquals('', Self.ReadFile().Text);

  Msg := 'any noised message';
  FLogger.SetNoisyMode;
  FLogger.Info(Msg);

  // Do not check the time
  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [Msg, DateTimeToStr(Now)]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Text, 1, 31));
end;

procedure TestTLogger.TestWarning;
var
  MsgWarning: string;
  MsgWarningInLogFormat: string;
begin
  MsgWarning := 'Warning message test';
  FLogger.Warning(MsgWarning);

  // Do not check the time
  MsgWarningInLogFormat:= Copy(Format(FORMAT_WARN, [MsgWarning, DateTimeToStr(Now)]), 1, 33);
  CheckEquals(MsgWarningInLogFormat, Copy(Self.ReadFile().Text, 1, 33));
end;

procedure TestTLogger.TestWarningLogTurnedOnOff;
begin
  FLogger.SetNoisyMode;
  FLogger.Warning('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  FLogger.Clear;
  FLogger.DisableWarningLog;
  FLogger.Warning('any message');
  CheckEquals('', Self.ReadFile().Text, 'disabled warning log');

  FLogger.EnableWarningLog;
  FLogger.Warning('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled warning log');
end;

procedure TestTLogger.TestClear;
begin
  FLogger.Error('Error message');
  FLogger.Warning('Warning message');
  FLogger.Info('Normal message');
  CheckNotEquals('', Self.ReadFile().Text);

  FLogger.Clear();
  CheckEquals('', Self.ReadFile().Text);
end;

procedure TestTLogger.TestError;
var
  MsgError: string;
  MsgErrorInLogFormat: string;
begin
  MsgError := 'Error message test';
  FLogger.Error(MsgError);

  // Do not check the time
  MsgErrorInLogFormat := Copy(Format(FORMAT_ERROR, [MsgError, DateTimeToStr(Now)]), 1, 33);
  CheckEquals(MsgErrorInLogFormat, Copy(Self.ReadFile().Text, 1, 33));
end;

procedure TestTLogger.TestErrorLogTurnedOnOff;
begin
  FLogger.SetNoisyMode;
  FLogger.Error('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  FLogger.Clear;
  FLogger.DisableErrorLog;
  FLogger.Error('any message');
  CheckEquals('', Self.ReadFile().Text, 'disabled error log');

  FLogger.EnableErrorLog;
  FLogger.Error('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled error log');
end;

procedure TestTLogger.TestFatal;
var
  MsgError: string;
  MsgErrorInLogFormat: string;
begin
  MsgError := 'Fatal message test';
  FLogger.Fatal(MsgError);

  // Do not check the time
  MsgErrorInLogFormat := Copy(Format(FORMAT_FATAL, [MsgError, DateTimeToStr(Now)]), 1, 35);
  CheckEquals(MsgErrorInLogFormat, Copy(Self.ReadFile().Text, 1, 35));
end;

procedure TestTLogger.TestFatalLogTurnedOnOff;
begin
  FLogger.SetNoisyMode;
  FLogger.Fatal('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  FLogger.Clear;
  FLogger.DisableFatalLog;
  FLogger.Fatal('any message');
  CheckEquals('', Self.ReadFile().Text, 'disabled fatal log');

  FLogger.EnableFatalLog;
  FLogger.Fatal('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled fatal log');
end;

procedure TestTLogger.TestInfo;
var
  Msg: string;
  MsgInLogFormat: string;
begin
  Msg := 'Info message test';
  FLogger.Info(Msg);

  // Do not check the time
  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [Msg, DateTimeToStr(Now)]), 1, 35);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Text, 1, 35));
end;

procedure TestTLogger.TestInfoLogTurnedOnOff;
begin
  FLogger.SetNoisyMode;
  FLogger.Info('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'noisy mode');

  FLogger.Clear;
  FLogger.DisableInfoLog;
  FLogger.Info('any message');
  CheckEquals('', Self.ReadFile().Text);

  FLogger.EnableInfoLog;
  FLogger.Info('any message');
  CheckNotEquals('', Self.ReadFile().Text, 'enabled info log');
end;

procedure TestTLogger.TestMultipleLines;
var
  MsgLine1, MsgLine2, MsgLine3: string;
  MsgInLogFormat: string;
begin
  MsgLine1 := 'Line #1: Normal message test';
  FLogger.Info(MsgLine1);

  MsgLine2 := 'Line #2: Normal message test';
  FLogger.Info(MsgLine2);

  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [MsgLine1, DateTimeToStr(Now)]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Strings[0], 1, 31));

  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [MsgLine2, DateTimeToStr(Now)]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Strings[1], 1, 31));


  MsgLine3 := MsgLine2;
  FLogger.Info(MsgLine3);

  MsgInLogFormat:= Copy(Format(FORMAT_INFO, [MsgLine3, DateTimeToStr(Now)]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Strings[2], 1, 31));

end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTLogger.Suite);
end.

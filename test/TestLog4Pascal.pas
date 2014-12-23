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
    procedure TestError;
    procedure TestMsg;
    procedure TestWarning;
    procedure TestSetQuietMode;
    procedure TestSetNoisyMode;

    procedure TestMultipleLines;

    procedure TestDebug;
  end;

implementation

uses
  Windows, SysUtils;

const
  FILE_LOG = 'test_log.txt';
  FORMAT_ERROR = '! %s [%s]';
  FORMAT_NORMAL = '%s [%s]';
  FORMAT_WARNING = '. %s [%s]';

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
  FLogger.Msg('any message');

  CheckEquals('', Self.ReadFile().Text);
end;

procedure TestTLogger.TestSetNoisyMode;
var
  Msg: string;
  MsgInLogFormat: string;
begin
  FLogger.SetQuietMode;
  FLogger.Msg('any message');

  CheckEquals('', Self.ReadFile().Text);

  Msg := 'any noised message';
  FLogger.SetNoisyMode;
  FLogger.Msg(Msg);

  // Do not check the time
  MsgInLogFormat:= Copy(Format(FORMAT_NORMAL, [Msg, DateTimeToStr(Now)]), 1, 31);
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
  MsgWarningInLogFormat:= Copy(Format(FORMAT_WARNING, [MsgWarning, DateTimeToStr(Now)]), 1, 33);
  CheckEquals(MsgWarningInLogFormat, Copy(Self.ReadFile().Text, 1, 33));
end;

procedure TestTLogger.TestDebug;
begin
  FLogger.Debug('Debug');

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

procedure TestTLogger.TestMsg;
var
  Msg: string;
  MsgInLogFormat: string;
begin
  Msg := 'Normal message test';
  FLogger.Msg(Msg);

  // Do not check the time
  MsgInLogFormat:= Copy(Format(FORMAT_NORMAL, [Msg, DateTimeToStr(Now)]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Text, 1, 31));
end;

procedure TestTLogger.TestMultipleLines;
var
  MsgLine1, MsgLine2, MsgLine3: string;
  MsgInLogFormat: string;
begin
  MsgLine1 := 'Line #1: Normal message test';
  FLogger.Msg(MsgLine1);

  MsgLine2 := 'Line #2: Normal message test';
  FLogger.Msg(MsgLine2);

  MsgInLogFormat:= Copy(Format(FORMAT_NORMAL, [MsgLine1, DateTimeToStr(Now)]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Strings[0], 1, 31));

  MsgInLogFormat:= Copy(Format(FORMAT_NORMAL, [MsgLine2, DateTimeToStr(Now)]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Strings[1], 1, 31));


  MsgLine3 := MsgLine2;
  FLogger.Msg(MsgLine3);

  MsgInLogFormat:= Copy(Format(FORMAT_NORMAL, [MsgLine3, DateTimeToStr(Now)]), 1, 31);
  CheckEquals(MsgInLogFormat, Copy(Self.ReadFile().Strings[2], 1, 31));

end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTLogger.Suite);
end.

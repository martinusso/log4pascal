# Log4Pascal

Log4pascal is an Open Source project that aims to produce a simple logging unit for ObjectPascal (Delphi, FreePascal).

Log4Pascal is NOT based on the Log4J package from the Apache Software Foundation. Well, just the name.

## How to use

Just add the unit `Log4Pascal.pas` to project.
  - ``Project -> Add to Project`` and then locate and choose the file.

### Log file

The log file is defined in the unit Log4Pascal, so if you want to change, modify the following line:

```delphi
initialization
  Logger := TLogger.Create('Log.txt');
```

### Features

 - Disable Logging.
  - `SetQuietMode();`
 - Enable Logging. By default, logging is enabled.
  - `SetNoisyMode();`
 - Enable or disable specific logs
  - `EnableTraceLog();` `EnableDebugLog();` `EnableInfoLog();` `EnableWarningLog();` `EnableErrorLog();` `EnableFatalLog();`
  - `DisableTraceLog();` `DisableDebugLog();` `DisableInfoLog();` `DisableWarningLog();` `DisableErrorLog();` `DisableFatalLog();`
 - Clean up existing log file
  - `Clear();`

##### Logs

```delphi
Logger.Trace('Trace message log');
Logger.Debug('Message is logged only when in debug');
Logger.Info('Normal message log');
Logger.Warning('Warning message log');
Logger.Error('Error message log');
Logger.Fatal('Fatal message log');
```

###### Output

```txt
TRACE Trace message log [DATETIME HERE]
DEBUG Message is logged only when in debug [DATETIME HERE]
INFO  Normal message log [DATETIME HERE]
WARN  Warning message log [DATETIME HERE]
ERROR Error message log [DATETIME HERE]
FATAL Fatal message log [DATETIME HERE]
```

## Known bugs

### Free Pascal
Using Lazarus (Free Pascal) there were 1 errors compiling module:
`Identifier not found "DebugHook"`

So if you want to use the Log4Pascal in Free Pascal, you must delete (or replace) the following line found in Log4Pascal unit:
```Delphi
if DebugHook = 0 then Exit;
```

## License

This software is open source, licensed under the The MIT License (MIT). See [LICENSE](https://github.com/martinusso/log4pascal/blob/master/LICENSE) for details.

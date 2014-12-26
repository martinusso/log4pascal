# Log4Pascal

Log4pascal is an Open Source project that aims to produce a simple logging suite for ObjectPascal (Delphi, FreePascal).

Log4Pascal is NOT based on the Log4J package from the Apache Software Foundation. Well, just the name.

## How to use

Just add the unit "src/Log4Pascal.pas" to project.
  - ``Project -> Add to Project`` and then locate and choose the file.

### Log file

The log file is defined in the unit Log4Pascal, so if you want to change, modify the following line:

```delphi
initialization
  Logger := TLogger.Create('Log.txt');
```

### Features

##### SetQuietMode();
Disable Logging.

##### SetNoisyMode();
Enable Logging. By default, logging is enabled.

##### Enable or disable specific logs

###### Enable

`EnableTraceLog();` `EnableDebugLog();` `EnableInfoLog();` `EnableWarningLog();` `EnableErrorLog();` `EnableFatalLog();`

###### Disable

`DisableTraceLog();` `DisableDebugLog();` `DisableInfoLog();` `DisableWarningLog();` `DisableErrorLog();` `DisableFatalLog();`

##### Clear();
Clean up existing log files.

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

## License

This software is open source, licensed under the The MIT License (MIT). See [LICENSE](https://github.com/martinusso/log4pascal/blob/master/LICENSE) for details.

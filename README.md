# JMeter 3 boilerplate

Boilerplate with helper scripts for running JMeter tests. Tests are built with JMeter 3.1, which is also included in this repository.

## Requirements

- JMeter requires a fully compliant JVM 7 or 8. It is advised that you install latest minor version of those major versions. Java 9 is not tested completely for JMeter 3.1.
- JMeter is a 100% Java application and should run correctly on any system that has a compliant Java implementation.
- Windows environment is required for executing the custom-built PowerShell and bat-scripts to quickly start JMeter and run testscripts in a non-GUI mode.

For a detailed up-to-date overview of all requirements see the [JMeter getting started guide](http://jmeter.apache.org/usermanual/get-started.html).

## Getting started

- Clone this repository.
- Start the JMeter GUI interface by clicking on `start-jmeter.bat`.
- Open a testplan from the [`testscripts`](testscripts) directory.

## Running tests

Developing and debugging testscripts can best be done from the JMeter GUI interface. If you are running an actual load test it is highly recommended to use JMeter in its non-GUI mode, which consumes less resources.

Testscripts can be executed in non-GUI mode by using the `testrunner.ps1` PowerShell file in the root of this repository.

```
Syntax:
  .\testrunner.ps1 -testScript <string> [-users <int>] [-rampUpTime <int>] [-duration <int>] [-rampDownTime <int>]

Arguments:
  -testScript: name of the testscript file (required).
  -users: number of users the test will use (optional, default 1).
  -rampUpTime: number of seconds the test will take to get to specified number of users (optional, default 1).
  -duration: number of seconds the test will run (optional, default 10)
  -rampDownTime: number of seconds the test will take to decrease the number of users to 0 (optional, default 1).
```

Predefined settings for running testfiles can be stored in separate PowerShell files, resulting in easy access to the default arguments for the testrunner. See the `run-testscript-1.ps1` file in the root of this repository for an example to run the `testscripts\testscript-1.jmx` file.

### Storing results

Test results are stored in the `results` directory in the root of this repository. This directory is configured as a relative path in the listener configurations in the testplans. As non-GUI mode vs. GUI mode use different working directories, the relative referenced results path points to different locations. To provide a solution the `results` directory is symlinked from `apache-jmeter-3.1\bin\results`, resulting in identical storage of testresults from both GUI-mode as non-GUI mode.

When running tests with the `testrunner.ps1` file, results are, after the test is finished, moved into a separate directory in the `results` folder. The syntax for the directory names is `testScriptFileName_yyyyMMdd-HHmmss`.

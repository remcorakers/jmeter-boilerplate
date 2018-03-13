# Script to run JMeter testScripts in non-GUI mode
param (
  [Parameter(Mandatory=$true, Position=0, HelpMessage='Testscript is required')]
  [string]$testScript,

  [Parameter(Mandatory=$false, Position=1, HelpMessage='Users should be an integer')]
  [int]$users = 1,

  [Parameter(Mandatory=$false, Position=2, HelpMessage='RampUpTime should be an integer')]
  [int]$rampUpTime = 1,

  [Parameter(Mandatory=$false, Position=3, HelpMessage='Duration should be an integer')]
  [int]$duration = 10,

  [Parameter(Mandatory=$false, Position=4, HelpMessage='RampDownTime should be an integer')]
  [int]$rampDownTime = 1
)

$currentPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$resultsPath = $currentPath + "\results\"
$jmeter = $currentPath + "\apache-jmeter-3.1\bin\jmeter"

# Change current working directory
Push-Location -Path $currentPath

Write-Host "-- ABOUT TO START A NEW PERFORMANCE TEST RUN. --"
Write-Host "-- MAKE SURE THE SCRIPTS VARIABLES ARE APPROPRIATE FOR YOUR MACHINE. --"
Write-Host "-- MAKE SURE THE JMeterServerAgent IS RUNNING ON ALL THE SERVERS. --"
Read-Host -Prompt "Press Enter to start the test"

del ($resultsPath + "*.jtl") -Force
del ($resultsPath + "*.csv") -Force
del ($resultsPath + "*.png") -Force

$logPath = $resultsPath + "jmeter.log"
$resultsFilePath = $resultsPath + "results.jtl"

Write-Host "-- PERFORMANCE TEST IS RUNNING--"
Start-Process $jmeter -ArgumentList "-n -t `"$testScript`" -j `"$logPath`" -l `"$resultsFilePath`" -Jusers=$users -Jrampup=$rampUpTime -Jduration=$duration -Jrampdown=$rampDownTime" -PassThru -Wait

# Get the current date and time to create new directory for storing test results
$newDir = Get-Date -format "yyyyMMdd-HHmmss"
$testScriptFileName = [io.path]::GetFileNameWithoutExtension($testScript)
$newResultsPath = $resultsPath + $testScriptFileName + "_" + $newDir

# Copy test results to separate directory
mkdir $newResultsPath | Out-Null
Get-ChildItem $resultsPath* -Include *.log, *.jtl, *.csv, *.png | Move-Item -Destination $newResultsPath -Force

Write-Host "-- PERFORMANCE TEST IS DONE --"
Write-Host "-- RESULTS STORED AT $newResultsPath --"

Pop-Location

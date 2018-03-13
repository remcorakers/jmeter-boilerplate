$currentPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location -Path $currentPath

$script = $currentPath + "\testrunner.ps1"
powershell -Command "& `"$script`" -testScript `".\testscripts\testscript-1.jmx`" -users 10  -rampUpTime 5 -duration 30 -rampDownTime 5"

Pop-Location

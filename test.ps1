$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.path)
Start-Process $env:windir\System32\WindowsPowerShell\v1.0\powershell.exe -verb runas -ArgumentList "-NoProfile -ExecutionPolicy -Command 'CD `"$scriptPath`";Pester'"
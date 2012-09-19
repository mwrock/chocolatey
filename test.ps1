$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.path)
$identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object System.Security.Principal.WindowsPrincipal( $identity )
$isAdmin = $principal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
$pesterDir = (dir $env:ChocolateyInstall/lib/Pester*)[-1]

if(-not $isAdmin){
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName="$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe"
    $psi.Verb="runas"
    $psi.Arguments="-NoProfile -ExecutionPolicy unrestricted -Command `". { CD '$scriptPath';. '$pesterDir\tools\bin\pester.bat'; if($lastExitCode -eq 0){exit} } `""
    $s = [System.Diagnostics.Process]::Start($psi)
    $s.WaitForExit()
    $exitCode = $s.ExitCode
    exit $exitCode
} else {
    . "$pesterDir\tools\bin\pester.bat"
}
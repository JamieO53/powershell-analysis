$projectFolder = Split-Path -Path $MyInvocation.MyCommand.Path
$cmd = "PowerShell -Command { Invoke-Pester $projectFolder\Tests\ }"
Write-Host $cmd
iex $cmd

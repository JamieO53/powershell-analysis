$projectFolder = Split-Path -Path $MyInvocation.MyCommand.Path
pushd $projectFolder\Tests\
$cmd = "PowerShell -Command { Invoke-Pester $projectFolder\Tests\ }"
Write-Host $cmd
iex $cmd
popd

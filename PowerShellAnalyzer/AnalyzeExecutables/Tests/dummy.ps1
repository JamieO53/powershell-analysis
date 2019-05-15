using module ..\bin\Debug\AnalyzeExecutables\AnalyzeExecutables.psm1
[string]$loc = Get-Location
$ex = [Executables]::new((Resolve-Path -Path "$loc\..\bin\Debug\AnalyzeExecutables\AnalyzeExecutables.psm1"))
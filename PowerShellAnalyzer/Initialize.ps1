$SolutionFolder = Split-Path -Path $MyInvocation.MyCommand.Path
$env:PSModulePath = "$SolutionFolder\AnalyzeExecutables\bin\Debug\AnalyzeExecutables;$env:PSModulePath"
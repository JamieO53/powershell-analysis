$projectFolder = Split-Path -Path $MyInvocation.MyCommand.Path
$tempModulPath = "$projectFolder\bin;$env:PSModulePath"
$saveModultPath = $env:PSModulePath
$env:PSModulePath = $tempModulPath
try {
Invoke-Pester "$projectFolder\Tests"
} finally {
	$env:PSModulePath = $saveModultPath
}


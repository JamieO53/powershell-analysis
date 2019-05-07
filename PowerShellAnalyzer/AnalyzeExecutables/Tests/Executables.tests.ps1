if (Get-Module AnalyzeExecutables -All) {
	Remove-Module AnalyzeExecutables
}
Import-Module "$PSScriptRoot\..\bin\Debug\AnalyzeExecutables\AnalyzeExecutables.psm1"

Describe "Executables" {
	Context "Exists" {
		$scriptPath = "$testDrive\script.ps1"
		'function dummy {}' | sc -Path $scriptPath -Encoding UTF8
		It "Creatable" {
			New-Executables $scriptPath | should not Be $null
		}
	}
	Context "Executables content" {
				$scriptPath = "$testDrive\script.ps1"
		'function dummy {}' | sc -Path $scriptPath -Encoding UTF8
		$ex = New-Executables $scriptPath
		It "Script is executable" {
			$ex.ex.ContainsKey('script.ps1') | should Be $true
		}
		It "Dummy function is executable" {
			$ex.ex.ContainsKey('dummy') | should Be $true
		}
	}
}
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
		It "No other executables" {
			$ex.ex.Count | should Be 2
		}
		It "Script name" {
			$ex.ScriptName | should Be 'script.ps1'
		}
		It "Dummy function container" {
			$ex.ex['dummy'].ContainedBy | should Be $ex.ex['script.ps1']
		}
		It "Dummy function contains nothing" {
			$ex.ex['dummy'].Contains | should Be $null
		}
		It "Script containes dummy function" {
			$ex.ex['script.ps1'].Contains.ContainsKey('dummy') | should Be $true
		}
		It "Script not contained by anything" {
			$ex.ex["script.ps1"].ContainedBy | should Be $null
		}
	}
}
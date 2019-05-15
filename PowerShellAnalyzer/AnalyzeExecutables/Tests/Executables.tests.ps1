using module ..\bin\Debug\AnalyzeExecutables\AnalyzeExecutables.psm1

Describe "Executables" {
	Context "Exists" {
		$scriptPath = "$testDrive\script.ps1"
		'function dummy {}' | sc -Path $scriptPath -Encoding UTF8
		It "Creatable" {
			[Executables]::new($scriptPath) | should not Be $null
		}
	}
	Context "Executables content" {
		$scriptPath = "$testDrive\script.ps1"
		'function dummy {}' | sc -Path $scriptPath -Encoding UTF8
		$ex = [Executables]::new($scriptPath)
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
	Context "Executables Class content" {
		$scriptPath = "$testDrive\script.ps1"
@'
class dummy {
	[string]$field = "field"
	dummy ([string]$param) {$this.field = $param}
	[void]Echo() {Write-Host $this.field}
}
'@ | sc -Path $scriptPath -Encoding UTF8
		$ex = [Executables]::new($scriptPath)
		It "Script is executable" {
			$ex.ex.ContainsKey('script.ps1') | should Be $true
		}
		It "Dummy class is executable" {
			$ex.ex.ContainsKey('dummy') | should Be $true
		}
		It "Dummy class container" {
			$ex.ex['dummy'].ContainedBy | should Be $ex.ex['script.ps1']
		}
		It "Dummy class contains constructor" {
			$ex.ex['dummy'].Contains.ContainsKey('dummy') -and $ex.ex['dummy'].Contains['dummy'].Ast.IsConstructor | should Be $true
		}
		It "Dummy class contains Echo member" {
			$ex.ex['dummy'].Contains.ContainsKey('Echo') | should Be $true
		}
		It "Script containes dummy class" {
			$ex.ex['script.ps1'].Contains.ContainsKey('dummy') | should Be $true
		}
		It "Script not contained by anything" {
			$ex.ex["script.ps1"].ContainedBy | should Be $null
		}
	}
}
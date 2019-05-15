using module ..\bin\Debug\AnalyzeExecutables\AnalyzeExecutables.psm1

Describe "Executable" {
	Context "Exists" {
		[System.Management.Automation.Language.Token[]]$tokens=$null
		[System.Management.Automation.Language.ParseError[]]$errors=$null
		[System.Management.Automation.Language.ScriptBlockAst]$script=$null
		$script = [System.Management.Automation.Language.Parser]::ParseInput('function dummy {}',  [ref]$tokens, [ref]$errors)
		It "Creatable" {
			[Executable]::new('script', $script, $null) | should not Be $null
		}
	}
	Context "Executable props" {
		[System.Management.Automation.Language.Token[]]$tokens=$null
		[System.Management.Automation.Language.ParseError[]]$errors=$null
		[System.Management.Automation.Language.ScriptBlockAst]$script=$null
		$script = [System.Management.Automation.Language.Parser]::ParseInput('function dummy {}',  [ref]$tokens, [ref]$errors)
		[System.Management.Automation.Language.FunctionDefinitionAst]$function = $null
		$function = $script.EndBlock.Statements[0]
		$fnEx = [Executable]::new('dummy', $function, $null)
		It "Function name" { 
			$fnEx.Name | should Be 'dummy' 
		}
		It "Function AST" {
			$fnEx.Ast| should Be $function 
		}
		It "Function type name" {
			$fnEx.TypeName | should Be 'FunctionDefinitionAst'
		}
		It "Function references" {
			$fnEx.References.Count | should Be 0
		}
		It "Function referenced by" {
			$fnEx.ReferencedBy.Count | should Be 0
		}
		It "Function text" {
			$fnEx.Text() | should Be 'function dummy {}'
		}
	}
}
class Executable {
	[string]$Name
	[System.Management.Automation.Language.Ast]$Ast
	[string]$TypeName
	[System.Collections.Generic.List[Executable]]$References
	[System.Collections.Generic.List[Executable]]$ReferencedBy
	[Executable]$ContainedBy
	[System.Collections.Generic.Dictionary[string,Executable]]$Contains
 	Executable($name,$ast,$container) {
		$this.Name = $name
		$this.Ast = $ast
		$this.TypeName = $ast.GetType().Name
		$this.References = [System.Collections.Generic.List[Executable]]::new()
		$this.ReferencedBy = [System.Collections.Generic.List[Executable]]::new()
		$this.ContainedBy = $container
		if ($this.TypeName -eq 'ScriptBlockAst') {
			$this.Contains = [System.Collections.Generic.Dictionary[string,Executable]]::new()
		}
		if ($container) {
			$container.Contains[$name] = $this
		}
	}
	[void]AddReference([Executable]$reference) {
		if(-not ($this.References.Contains($reference))) {
			$this.References.Add($reference)
		}
		if(-not ($Reference.referencedBy.Contains($this))) {
			$Reference.referencedBy.Add($this)
		}
	}
}

function New-Executable {
	param(
		[string]$name,
		[System.Management.Automation.Language.Ast]$ast,
		[Executable]$container
	)
	[Executable]::New($name,$ast,$container)
}

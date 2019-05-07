class Executable {
	[string]$Name
	[System.Management.Automation.Language.Ast]$Ast
	[string]$TypeName
	[System.Collections.Generic.List[Executable]]$References
	[System.Collections.Generic.List[Executable]]$ReferencedBy
 	Executable($name,$ast) {
		$this.Name = $name
		$this.Ast = $ast
		$this.TypeName = $ast.GetType().Name
		$this.References = [System.Collections.Generic.List[Executable]]::new()
		$this.ReferencedBy = [System.Collections.Generic.List[Executable]]::new()
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

function New-Executable ($name,$ast) {
	[Executable]::New($name,$ast)
}

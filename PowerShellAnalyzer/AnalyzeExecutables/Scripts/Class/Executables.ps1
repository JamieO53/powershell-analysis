class Executables {
	[string]$ScriptName
    [System.Collections.Generic.Dictionary[string,Executable]]$ex
    Executables([string]$Path) {
		$this.ex = [System.Collections.Generic.Dictionary[string,Executable]]::new()
        $this.ScriptName = [System.IO.Path]::GetFileName($path)
		[System.Management.Automation.Language.Token[]]$tokens=$null
		[System.Management.Automation.Language.ParseError[]]$errors=$null
        [System.Management.Automation.Language.ScriptBlockAst]$script=$null
        $script=[System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors)
        if ($errors.Count -gt 0) {
            $errors |
                foreach {
                    Write-Error $_.Message
                }
            return
        }
		$container = $this.AddExecutable($this.ScriptName, $script, $null)
        # Todo: Only look at the script statements
        # Todo: Include TypeDefinitionAst as well - Classes (Check TypeAttributes)
        # Todo: Use Contains / ContainedBy for member functions (FunctionMemberAst)
        #$fns = $script.FindAll({ param($ast) ($ast.GetType().Name -eq 'FunctionDefinitionAst')}, $false)
        $fns = $script.EndBlock.Statements |
            where { $type = $_.GetType().Name; (@('FunctionDefinitionAst', 'TypeDefinitionAst') -contains $type)}
        $fns |
            foreach {
		        if (-not $this.Contains($_.Name)) {
                    $x = $this.AddExecutable($_.Name, $_, $container)
		        } else { Write-Host "$($_.Name) already exists" }
            }
        $this.ex.Values |
            foreach {
                $this.FindExecutableReferences($_)
            }
	}
    [Executable]AddExecutable($name, [System.Management.Automation.Language.Ast]$ast, [Executable]$container) {
		[Executable]$executable = [Executable]::New($name,$ast,$container)
        $this.ex.Add($name,$executable)
        if ($executable.TypeName -eq 'TypeDefinitionAst') {
            [System.Management.Automation.Language.TypeDefinitionAst]$cast = $ast -as [System.Management.Automation.Language.TypeDefinitionAst]
            $mbrfns = $cast.Members |
                where { $_.GetType().Name -eq 'FunctionMemberAst'}
            $mbrfns |
                foreach {
                    [Executable]$method = [Executable]::new($_.Name,$_,$executable)
                }
        }
		return $executable
	}
	[void]FindExecutableReferences ([Executable]$executable) {
        switch -Exact -CaseSensitive ($executable.TypeName) {
            'FunctionDefinitionAst' {
                [System.Management.Automation.Language.FunctionDefinitionAst]$fd = $executable.ast
                $this.FindStatementsReferences($executable, $fd.Body.EndBlock.Statements)
                Break
            }
            'ScriptBlockAst' {
                [System.Management.Automation.Language.ScriptBlockAst]$sb = $executable.ast
                $this.FindStatementsReferences($executable, $sb.EndBlock.Statements)
                Break
            }
            'StatementBlockAst' {
                [System.Management.Automation.Language.StatementBlockAst]$smb = $executable.ast
                $this.FindStatementsReferences($executable, $smb.Statements)
                Break
            }
            default {
            }
        }
    }
    [void]FindStatementsReferences([Executable]$executable, [System.Collections.ObjectModel.ReadOnlyCollection[System.Management.Automation.Language.StatementAst]]$statements){
        $statements |
	        where {($_ -ne $null) -and (@('FunctionDefinitionAst', 'TypeDefinitionAst') -notcontains $_.GetType().Name)} |
	        foreach {
		        $this.FindStatementReferences($executable, $_)
	        }
    }
    [void]FindStatementReferences ([Executable]$executable, [System.Management.Automation.Language.StatementAst]$statement) {
	    $commands = $statement.FindAll({ param($ast) ($ast.GetType().Name -eq 'CommandAst')}, $true)
        foreach($command in $commands) {
            $this.FindCommandReferences($executable, $command)
        }
    }
    [void]FindCommandReferences ([Executable]$executable, [System.Management.Automation.Language.CommandBaseAst]$command) {
	    [System.Management.Automation.Language.CommandAst]$c = $command
	    if ($c.CommandElements.count -gt 0) {
		    $action = $c.CommandElements[0]
            $actionType = $action.GetType().Name
		    if (@('ExpandableStringExpressionAst', 'StringConstantExpressionAst') -contains $actionType) {
                $a = $action
			    if ($this.Contains($a.Value)) {
				    $ref = $this.GetExecutable($a.Value)
				    if ($executable -ne $null)
				    {
					    $executable.AddReference($ref)
				    }
			    }
		    }
	    }
    }
    [bool]Contains([object]$key)
    {
        return $this.ex.ContainsKey($key);
    }

    [void]Add([object]$key, [object]$value)
    {
        $this.ex.Add($key, $value);
    }

    [void]Clear()
    {
        $this.ex.Clear();
    }

    [System.Collections.IDictionaryEnumerator]GetEnumerator()
    {
        return $this.ex.GetEnumerator();
    }

    [void]Remove([object]$key)
    {
        $this.ex.Remove($key);
    }

    [object]GetExecutable([object]$key)
    {
        return $this.ex[$key];
    }

    [int]Count()
    {
        return $this.ex.Count;
    }
}

function New-Executables ($path) {
	[Executables]::new($Path)
}
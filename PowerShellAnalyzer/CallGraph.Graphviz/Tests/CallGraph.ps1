param(
	[Parameter(Mandatory = $true)][string]$Path,
	[Parameter(Mandatory = $true)][string[]]$GraphHeads,
	[string[]]$ExternalReferences,
	[string[]]$BlockedReferences,
	[string]$Label
)

function Out-ExternalHead ([string]$node) {
	'{{ node [shape=octagon]; "{0}" }}' -f $node
}
function Out-ExternalNode ([string]$head, [string]$node) {
	'"{0}" -> {{ node [shape=octagon]; "{1}" }}' -f $head, $node
}
function Out-Node ([string]$head, [string]$node) {
	'"{0}" -> "{1}";' -f $head, $node
}
function References ([string]$head){
	$function = $functions.GetExecutable($head)
	$function.references |
		where { $blocked -notcontains $_.Name } |
		foreach {
			if ($externals -notcontains $head) {
				if ( $externals -contains $_.Name) {
					Out-ExternalNode -head $head -node $_.Name
				}
				else {
					Out-Node -head $head -node $_.Name
				}
				if ($_.Name -ne $head) {
					References -head $_.Name
				}
			}
		}
}

$scriptFile=$Path
$scriptName=[System.IO.Path]::GetFileName($Path)

$heads = $GraphHeads
$blocked = @('Log')
$externals = if( $ExternalReferences ) { $ExternalReferences } else { @() }

$functions = .\New-Executables.ps1 -Path $scriptFile

@"
strict digraph `"$scriptName`" {
compound=true;
rankdir=LR;
pencolor=white;
node [shape=box fontsize=12];
"@
$heads |
	foreach {
		$head = $_
		"subgraph `"cluster$head`" {"
		if ( $externals -contains $head) {
			Out-ExternalHead -node $head
		}
		else {
			References -head $head
		}
		'}'
		$functions.GetExecutable($head).referencedBy |
			where { $_.Name -eq $scriptName } |
			foreach {
				Out-Node -head $_.Name -node $head
			}
	}
@"
fontsize=16
label=`"$Label`";
}
"@

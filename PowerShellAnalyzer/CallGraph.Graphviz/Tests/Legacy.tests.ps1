Describe "Legacy" {
	Context "Main" {
		$folder = Get-Location
		@('LegacyScript.ps1','$null'),@('Main','Part2'),@('Part2','$null') | % {
			$root = $_[0]
			$external = $_[1]
			$path = "$folder\LegacyScript.ps1"
			$output = "$testDrive\LegacyOutput-$root.txt"
			iex "powershell -command { .\CallGraph.ps1 -Path $path -GraphHeads @('$root') -ExternalReferences $external -BlockedReferences @('Log') -Label '$root Test' | Out-File $output -Encoding utf8 }"
			$expected = gc "$folder\LegacyOutput-$root.txt" | Out-String
			$actual = gc $output | Out-String
			It "$root routine graph" {
				$actual | should be $expected
			}
		}
	}
}
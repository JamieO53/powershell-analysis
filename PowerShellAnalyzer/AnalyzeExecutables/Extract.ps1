using module .\AnalyzeExecutables.psm1
$ex.ex.Keys | sort | % { $name = $_; $Name; $fn = $ex.ex[$name]; $text = $fn.Text(); $text | sc "$name.ps1" }
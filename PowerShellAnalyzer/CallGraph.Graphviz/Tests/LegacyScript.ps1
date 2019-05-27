function Body () { Log Part1; Part1; Log Part2; Part2 }
function Log ($message) {}
function Main () { Log 'Setup'; Setup 'Something'; Log Body; Body; Log Teardown; Teardown Something }
function Part1 () {}
function Part2 () { Part2A; Part2B; }
function Part2A () { Log 'Part2A' }
function Part2B () { Part2B1; Part2B2 }
function Part2B1 () { Log 'Part2B1' }
function Part2B2 () { Log 'Part2B2' }
function Setup ($param) { Log "Setup $param" }
function Teardown ($param) { Log "Teardown $param" }

Main
Import-Module .\writeOutput.ps1

$test = .\isModuleInstalled.ps1 BurnToast 

if ($test) {
    writeOutput -f "yellow" -b "green" "It is installed."
}
else {
    writeOutput -f black -b Red "Needs to be installed."
}
# A function to determine whether a 
# module is installed or not. It will 
# return only boolean values. 

function isModuleInstalled {
    
    <#
    .PARAMETER moduleName
    Your desired module name.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string] $moduleName
    )

    # Get the list of available modules.
    $InstalledModules = Get-Module -ListAvailable

    # Use Where-Object to filter the modules by name
    $module = $InstalledModules | Where-Object { $_.Name -eq $moduleName }

    # Use If-Else statement to return a boolean value
    if ($module) {
        return $true
    }
    else {
        return $false
    }
}

# If this file is called from the command line then
# get the module name. The syntax will be the same.
$ModuleName = $args[0]

# Call the isModuleInstalled function 
$module = isModuleInstalled $ModuleName

# Use an if-else statement to display a message based on the result
if ($module) {
    return $true
}
else {
    return $false
}
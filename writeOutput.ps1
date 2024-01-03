# A function to make colored output easily 

# The available colors are 
# 1. Black
# 2. Blue
# 3. Cyan
# 4. DarkBlue
# 5. DarkCyan
# 6. DarkGray
# 7. DarkGreen
# 8. DarkMagenta
# 9. DarkRed
# 10. DarkYellow
# 11. Gray
# 12. Green
# 13. Magenta
# 14. Red
# 15. White
# 16. Yellow



function writeOutput {
    
    <#
    .PARAMETER foregroundColor
    This means the foreground color of the output text.

    .PARAMETER backgroundColor
    This means the background color of the output text.

    .PARAMETER text
    This means the text that you want to show output.
    #>

    # The "Default" the default parameter set for the function.
    # The "Default" the default parameter set for the function.
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param (
        [Parameter(ParameterSetName = "Custom")]
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue",
            "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta",
            "DarkRed", "DarkYellow", "Gray", "Green",
            "Magenta", "Red", "White", "Yellow")]
        [string]
        $foregroundColor,

    
        [Parameter(ParameterSetName = "Custom")]
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue",
            "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta",
            "DarkRed", "DarkYellow", "Gray", "Green",
            "Magenta", "Red", "White", "Yellow")]
        [string]
        $backgroundColor,

        [Parameter(ValueFromRemainingArguments)]
        [string]
        $text
    )

    switch ($PSCmdlet.ParameterSetName) {
        Custom { 
            Write-Host -BackgroundColor $backgroundColor -ForegroundColor $foregroundColor $text;
        }
        Default {
            Write-Host -BackgroundColor White -ForegroundColor Black $text;
        }
    }
}

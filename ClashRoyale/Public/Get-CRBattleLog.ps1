function Get-CRBattleLog {
    param (
        # The player's battle tag including the "#" symbol, such as #A1B2C3D4
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullorEmpty()]
        $BattleTag,
        # Boolean selection to return only the most recent battle
        [switch]$Recent,
        # The API token used to authorization to the Clash Royale API
        # Default location: $env:crtoken
        [ValidateNotNullorEmpty()]
        $Token = $env:crtoken
    )

    # Encode the "#" symbol as "%23" to make the URI compatible with HTTPS
    $BattleTag = $BattleTag.Replace("#", "%23")

    # URI
    $URI = "https://api.clashroyale.com/v1/players/$BattleTag/battlelog"

    # Send the Request
    $Request = Invoke-WebRequest `
        -Uri $URI `
        -Authentication:Bearer `
        -Token:$(ConvertTo-SecureString -AsPlainText -String $Token)

    # Parse the content from the request into a PowerShell custom object
    $Result = ConvertFrom-Json $Request.Content

    # Return data
    if ($Recent) {
        Return $Result[0]
    } else {
        Return $Result
    }
}
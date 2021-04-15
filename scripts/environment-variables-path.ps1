function global:Get-EnvPaths {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Machine', 'User')]
        [System.String]
        $Storage
    )
    $currentPathValue = [Environment]::GetEnvironmentVariable("PATH", $Storage);    
    return $currentPathValue -split ";"
}

function global:Add-EnvPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Machine', 'User')]
        [System.String]
        $Storage,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
    )
    BEGIN {
        $currentPathValue = [Environment]::GetEnvironmentVariable("PATH", $Storage);
        if($currentPathValue.Contains($Path)){
            throw "The path $Path already exist in the path enivronment variable for $Storage"
        }
        $currentSet = $currentPathValue -split ";"
    }
    PROCESS{
        $newPathValue = $($currentSet + $Path) -join ";"
        [Environment]::SetEnvironmentVariable("PATH", $newPathValue,  $Storage);
    }
}


function global:Remove-EnvPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Machine', 'User')]
        [System.String]
        $Storage,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
    )
    BEGIN {
        $currentPathValue = [Environment]::GetEnvironmentVariable("PATH", $Storage);
        if(-not $currentPathValue.Contains($Path)){
            throw "The path $Path is already missing in the path enivronment variable for $Storage"
        }
        $currentSet = $currentPathValue -split ";"
    }
    PROCESS{
        $newPathValue = $($currentSet | where {$_ -ne $Path}) -join ";"
        [Environment]::SetEnvironmentVariable("PATH", $newPathValue,  $Storage);
    }
}
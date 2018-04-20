$ModulePath = (Get-Module -ListAvailable TervisYumPowerShell).ModuleBase
. $ModulePath\YumPackageGroupDefinitions.ps1

function Get-TervisYumPackageGroup {
    param (
        $Name
    )
    $TervisPackageGroups | where Name -EQ $Name
}

function Get-TervisYumPackageInstallDefinitionFromPackageGroup{
    param (
        [Parameter(Mandatory,ValueFromPipeline)]$Name
    )
    process{
        $PackageGroup = Get-TervisYumPackageGroup -Name $Name

        if ($PackageGroup.PackageGroupToImport) {
            $PackageGroup.PackageGroupToImport | Get-TervisYumPackageInstallDefinitionFromPackageGroup
        }
        $PackageGroup.PackageInstallDefinition
    }
}
function New-YumPackageInstallDefinition {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]$Name
    )
    process {
        [PSCustomObject]@{
            Name = $Name
        }
    }
}

function New-YUMPackageInstallCommand {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]$PackageInstallDefinition
    )
    begin { $PackageInstallDefinitions = @() }
    process {
        $PackageInstallDefinitions += $PackageInstallDefinition
    }
    end {
        $YumArguements = (
            $PackageInstallDefinitions |
            ForEach-Object { "$($_.Name)" }
        ) -join " "

        "yes | yum -y install $YumArguements"
    }
}

function Install-YumTervisPackageGroup {
    param (
        [Parameter(Mandatory)]$TervisPackageGroupName,
        [Parameter(Mandatory,ParameterSetName="SSHSession")]$SSHSession
    )
    process {
        $PackageGroupDefinition = Get-TervisYumPackageInstallDefinitionFromPackageGroup -Name $TervisPackageGroupName
        $PackageGroupDefinitionsToInstall = $PackageGroupDefinition | Sort-Object -Unique -Property Name
        $Command = $PackageGroupDefinitionsToInstall | New-YUMPackageInstallCommand
        Invoke-SSHCommand -Command $Command -SSHSession $SSHSession
    }
}

function Invoke-YumUpdate {
    "yum update -y"
}
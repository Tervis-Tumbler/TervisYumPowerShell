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

function Get-TervisYumPackageGroupInstallDefinitionFromPackageGroup{
    param (
        [Parameter(Mandatory,ValueFromPipeline)]$Name
    )
    process{
        $PackageGroup = Get-TervisYumPackageGroup -Name $Name

        if ($PackageGroup.PackageGroupToImport) {
            $PackageGroup.PackageGroupToImport | Get-TervisYumPackageGroupInstallDefinitionFromPackageGroup
        }
        $PackageGroup.GroupPackageInstallDefinition
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
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]$TervisPackageGroupName,
        [Parameter(ValueFromPipelineByPropertyName,Mandatory,ParameterSetName="SSHSession")]$SSHSession
    )
    process {
        $PackageGroupDefinition = Get-TervisYumPackageInstallDefinitionFromPackageGroup -Name $TervisPackageGroupName
        $GroupPackageGroupDefinition = Get-TervisYumPackageGroupInstallDefinitionFromPackageGroup -Name $TervisPackageGroupName
        $PackageGroupDefinitionsToInstall = $PackageGroupDefinition | Sort-Object -Unique -Property Name
        $GroupPackageGroupDefinitionsToInstall = $GroupPackageGroupDefinition | Sort-Object -Unique -Property Name
        $PackageGroupInstallCommand = $PackageGroupDefinitionsToInstall | New-YUMPackageInstallCommand
        $GroupPackageGroupInstallCommand = $GroupPackageGroupDefinitionsToInstall | New-YUMPackageInstallCommand
        Invoke-SSHCommand -Command $PackageGroupInstallCommand -SSHSession $SSHSession -TimeOut 600
        Invoke-SSHCommand -Command $GroupPackageGroupInstallCommand -SSHSession $SSHSession -TimeOut 600
    }
}

function Invoke-YumUpdate {
    "yum update -y"
}
$TervisPackageGroups = [PSCustomObject][Ordered] @{
    Name = "SFTP"
    PackageInstallDefinition = @"
puppet
realmd
sssd
oddjob
oddjob-mkhomedir
adcli
samba-common
policycoreutils-python
"@ -split "`r`n" | New-YumPackageInstallDefinition
},
[PSCustomObject][Ordered] @{
    Name = "FreshDeskSFTP"
    PackageInstallDefinition = @"
realmd
sssd
oddjob
oddjob-mkhomedir
adcli
samba-common
policycoreutils-python
"@ -split "`r`n" | New-YumPackageInstallDefinition
},
[PSCustomObject][Ordered] @{
    Name = "Windows Domain Join"
    PackageInstallDefinition = @"
krb5-workstation
realmd
sssd
samba-common-tools
adcli
"@ -split "`r`n" | New-YumPackageInstallDefinition
},
[PSCustomObject][Ordered] @{
    Name = "ZeroTierBridge"
    PackageInstallDefinition = @"
"@ -split "`r`n" | New-YumPackageInstallDefinition
    PackageGroupToImport = "Windows Domain Join"
},
[PSCustomObject][Ordered] @{
    Name = "OracleODBEE"
    PackageInstallDefinition = @"
krb5-workstation
realmd
sssd
adcli
oddjob
oddjob-mkhomedir
policycoreutils-python
"@ -split "`r`n" | New-YumPackageInstallDefinition
}

function Get-TervisYumPackageGroup {
    param (
        $Name
    )
    $TervisPackageGroups | where Name -EQ $Name
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
        $TervisPackageGroup = Get-TervisYumPackageGroup -Name $TervisPackageGroupName
        $Command = $TervisPackageGroup.PackageInstallDefinition | New-YUMPackageInstallCommand
        Invoke-SSHCommand -Command $Command -SSHSession $SSHSession
    }
}

function Invoke-YumUpdate {
    "yum update -y"
}
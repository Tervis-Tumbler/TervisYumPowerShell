$TervisPackageGroups = [PSCustomObject][Ordered] @{
    Name = "SFTP"
    PackageInstallDefinition = @"
"@ -split "`r`n" | New-YumPackageInstallDefinition
PackageGroupToImport = "Windows Domain Join","NTP"
},
[PSCustomObject][Ordered] @{
    Name = "FreshDeskSFTP"
    PackageInstallDefinition = @"
"@ -split "`r`n" | New-YumPackageInstallDefinition
PackageGroupToImport = "Windows Domain Join","NTP"
},
[PSCustomObject][Ordered] @{
    Name = "Windows Domain Join"
    PackageInstallDefinition = @"
krb5-workstation
realmd
sssd
samba-common-tools
oddjob
oddjob-mkhomedir
adcli
policycoreutils-python
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
mailx
"@ -split "`r`n" | New-YumPackageInstallDefinition
PackageGroupToImport = "OraclePackages","Windows Domain Join","OracleCore","NTP"
},
[PSCustomObject][Ordered] @{
    Name = "OraclePackages"
    PackageInstallDefinition = @"
binutils
compat-libcap1.i686
compat-libstdc++-33.i686
compat-libstdc++-33
gcc
gcc-c++
glibc.i686
glibc
glibc-devel.i686
glibc-devel
libaio.i686
libaio
libaio-devel.i686
libaio-devel
libgcc.i686
libgcc
libstdc++.i686
libstdc++
libstdc++.i686
libstdc++
libXi.i686
libXi
libXtst.i686
libXtst
make
"@ -split "`r`n" | New-YumPackageInstallDefinition
},
[PSCustomObject][Ordered] @{
    Name = "OracleCore"
    PackageInstallDefinition = @"
sysstat
ksh
SSMTP
"@ -split "`r`n" | New-YumPackageInstallDefinition
},
[PSCustomObject][Ordered] @{
    Name = "NTP"
    PackageInstallDefinition = @"
ntpdate
ntp
ntpd
"@ -split "`r`n" | New-YumPackageInstallDefinition
}



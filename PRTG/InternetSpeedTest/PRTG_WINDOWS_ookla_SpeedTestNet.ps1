<#
    .SYNOPSIS
    PRTG Advanced Sensor - Internet Speed Check
  
    .DESCRIPTION
    This Advanced Sensor will monitor and report Internet speed using Ookla, SpeedTest.net.
        
    .EXAMPLE
    PRTG_WINDOWS_ookla_SpeedTestNet.ps1
    .Notes
    NAME:  PRTG_WINDOWS_ookla_SpeedTestNet.ps1
    AUTHOR: Jaroslav Mráz
    LASTEDIT: 10/03/2022
    VERSION: 1.0
    KEYWORDS: PRTG, Windows, Internet Speed Test
   
    .Link
    https://jaroslavmraz.sk/
    .Link
    https://www.linkedin.com/in/jaroslavmraz
 
 #Requires PS -Version 5.0
 #Requires speedtest.net CLI -   https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-win64.zip
 #
 #  Download speedtest.net CLI
 #  Unzip it to folder InstallDir\EXEXML\ookla-speedtest-1.1.1-win64 or change in script
 #  Download PRTG_WINDOWS_ookla_SpeedTestNet.ps1 and copy to InstallDir\EXEXML\
 #  Go to PRTG and create EXE/ScriptAdvanced sensor
 #
 #  Done Happy Monitoring
 #
 # TIP: Set your custom limits to check if your SLA guaranteed line is as it shoud be.
 #>

  #PRTG Internet Speed Test

# INSTALATION LOCATION - Uncoment your location or change to your own.

#cd "${Env:ProgramFiles}\PRTG Network Monitor\Custom Sensors\EXEXML\ookla-speedtest-1.1.1-win64" 
cd "${Env:ProgramFiles(x86)}\PRTG Network Monitor\Custom Sensors\EXEXML\ookla-speedtest-1.1.1-win64"

#Run test and accept conditions and GDPR
$RESULT=(.\speedtest.exe --accept-license --accept-gdpr -p no --output-header json)




#PARSE RESULTS
$DOWNLOAD=([regex]::Match($RESULT,"(Download):\s+([0-9]*(\.[0-9]{0,2})?)").captures.groups[2].value)
$UPLOAD=([regex]::Match($RESULT,"(Upload):\s+([0-9]*(\.[0-9]{0,2})?)").captures.groups[2].value)

#RENTURT Results to PRTG in Required Format 

Write-Host "<prtg>"
Write-Host "<result>" 
"<channel>Internet Download Speed</channel>" 
"<float>1</float>"    
"<value>"+ $DOWNLOAD +"</value>" 
"</result>"
Write-Host "<result>" 
"<channel>Internet Upload Speed</channel>" 
"<float>1</float>"    
"<value>"+ $UPLOAD +"</value>" 
"</result>"
Write-Host "</prtg>" 

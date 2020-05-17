ECHO OFF
REM *****************************************************************************************************
REM ** Microsoft Windows To Go Sample BatchFile provisioning script.
REM **
REM ** This script is designed to be used from an elevated command prompt on a computer that is running either Windows 8 or Windows 7 with the Windows 8 ADK
REM ** The script will provision 1 USB drive for Windows To Go (WTG)
REM ** 
REM ** User must supply the ID for the USB device to become a WTG drive.
REM ** User must supply the path to the install image.
REM ** User must have DISM.exe version 6.2.9200.16384 and dependencies from the win8 ADK
REM **
REM *****************************************************************************************************

if "%1" equ "" goto help
if %1 LSS 1 goto InvalidDrive
if "%2" equ "" goto help

REM Create SanPolicy unattend file.
echo ^<?xml version="1.0" encoding="utf-8" standalone="yes"?^>                     > San_Policy.xml
echo ^<unattend xmlns="urn:schemas-microsoft-com:unattend"^>                       >> San_Policy.xml
echo   ^<settings pass="offlineServicing"^>                                        >> San_Policy.xml
echo     ^<component                                                               >> San_Policy.xml
echo         xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"         >> San_Policy.xml
echo         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"                 >> San_Policy.xml
echo         language="neutral"                                                    >> San_Policy.xml
echo         name="Microsoft-Windows-PartitionManager"                             >> San_Policy.xml
echo         processorArchitecture="amd64"                                         >> San_Policy.xml
echo         publicKeyToken="31bf3856ad364e35"                                     >> San_Policy.xml
echo         versionScope="nonSxS"                                                 >> San_Policy.xml
echo         ^>                                                                    >> San_Policy.xml
echo       ^<SanPolicy^>4^</SanPolicy^>                                            >> San_Policy.xml
echo     ^</component^>                                                            >> San_Policy.xml
echo     ^<component                                                               >> San_Policy.xml
echo         xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"         >> San_Policy.xml
echo         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"                 >> San_Policy.xml
echo         language="neutral"                                                    >> San_Policy.xml
echo         name="Microsoft-Windows-PartitionManager"                             >> San_Policy.xml
echo         processorArchitecture="x86"                                           >> San_Policy.xml
echo         publicKeyToken="31bf3856ad364e35"                                     >> San_Policy.xml
echo         versionScope="nonSxS"                                                 >> San_Policy.xml
echo         ^>                                                                    >> San_Policy.xml
echo       ^<SanPolicy^>4^</SanPolicy^>                                            >> San_Policy.xml
echo     ^</component^>                                                            >> San_Policy.xml
echo   ^</settings^>                                                               >> San_Policy.xml
echo ^</unattend^>                                                                 >> San_Policy.xml

REM Create a generic OOBE unattend file.
echo ^<?xml version="1.0" encoding="utf-8"?^>                                                                                                                                                                                                                                                         > unattend.xml
echo ^<unattend xmlns="urn:schemas-microsoft-com:unattend"^>                                                                                                                                                                                                                                          >> unattend.xml
echo     ^<settings pass="oobeSystem"^>                                                                                                                                                                                                                                                               >> unattend.xml
echo         ^<component name="Microsoft-Windows-Shell-Setup" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" processorArchitecture="AMD64" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>          >> unattend.xml
echo             ^<OOBE^>                                                                                                                                                                                                                                                                             >> unattend.xml
echo                 ^<HideEULAPage^>true^</HideEULAPage^>                                                                                                                                                                                                                                            >> unattend.xml
echo                 ^<ProtectYourPC^>1^</ProtectYourPC^>                                                                                                                                                                                                                                             >> unattend.xml
echo                 ^<NetworkLocation^>Work^</NetworkLocation^>                                                                                                                                                                                                                                      >> unattend.xml
echo             ^</OOBE^>                                                                                                                                                                                                                                                                            >> unattend.xml
echo         ^</component^>                                                                                                                                                                                                                                                                           >> unattend.xml
echo         ^<component name="Microsoft-Windows-International-Core" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" processorArchitecture="AMD64"^>                                                                                                                       >> unattend.xml
echo           ^<InputLocale^>en-US^</InputLocale^>                                                                                                                                                                                                                                                   >> unattend.xml
echo           ^<SystemLocale^>en-US^</SystemLocale^>                                                                                                                                                                                                                                                 >> unattend.xml
echo           ^<UILanguage^>en-US^</UILanguage^>                                                                                                                                                                                                                                                     >> unattend.xml
echo           ^<UserLocale^>en-US^</UserLocale^>                                                                                                                                                                                                                                                     >> unattend.xml
echo         ^</component^>                                                                                                                                                                                                                                                                           >> unattend.xml
echo         ^<component name="Microsoft-Windows-WinRE-RecoveryAgent" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>  >> unattend.xml
echo             ^<UninstallWindowsRE^>true^</UninstallWindowsRE^>                                                                                                                                                                                                                                    >> unattend.xml
echo         ^</component^>                                                                                                                                                                                                                                                                           >> unattend.xml
echo         ^<component name="Microsoft-Windows-Shell-Setup" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" processorArchitecture="X86" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>            >> unattend.xml
echo             ^<OOBE^>                                                                                                                                                                                                                                                                             >> unattend.xml
echo                 ^<HideEULAPage^>true^</HideEULAPage^>                                                                                                                                                                                                                                            >> unattend.xml
echo                 ^<ProtectYourPC^>1^</ProtectYourPC^>                                                                                                                                                                                                                                             >> unattend.xml
echo                 ^<NetworkLocation^>Work^</NetworkLocation^>                                                                                                                                                                                                                                      >> unattend.xml
echo             ^</OOBE^>                                                                                                                                                                                                                                                                            >> unattend.xml
echo         ^</component^>                                                                                                                                                                                                                                                                           >> unattend.xml
echo         ^<component name="Microsoft-Windows-International-Core" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" processorArchitecture="x86"^>                                                                                                                         >> unattend.xml
echo           ^<InputLocale^>en-US^</InputLocale^>                                                                                                                                                                                                                                                   >> unattend.xml
echo           ^<SystemLocale^>en-US^</SystemLocale^>                                                                                                                                                                                                                                                 >> unattend.xml
echo           ^<UILanguage^>en-US^</UILanguage^>                                                                                                                                                                                                                                                     >> unattend.xml
echo           ^<UserLocale^>en-US^</UserLocale^>                                                                                                                                                                                                                                                     >> unattend.xml
echo         ^</component^>                                                                                                                                                                                                                                                                           >> unattend.xml
echo         ^<component name="Microsoft-Windows-WinRE-RecoveryAgent" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>    >> unattend.xml
echo             ^<UninstallWindowsRE^>true^</UninstallWindowsRE^>                                                                                                                                                                                                                                    >> unattend.xml
echo         ^</component^>                                                                                                                                                                                                                                                                           >> unattend.xml
echo     ^</settings^>                                                                                                                                                                                                                                                                                >> unattend.xml
echo ^</unattend^>                                                                                                                                                                                                                                                                                    >> unattend.xml


REM Create DiskPart Commands for cleaning and creating a WTG MBR
REM formatted device.  This will create 2 partitions for BIOS & UEFI
REM roaming and set the NoDefaultDriveLetter attribute.
echo select disk %1                             > cmds.txt
echo clean                                      >> cmds.txt
echo create partition primary size=350          >> cmds.txt
echo active                                     >> cmds.txt
echo format FS=FAT32 quick LABEL="WTG-SYSTEM"   >> cmds.txt
echo assign letter=S                            >> cmds.txt
echo create partition primary                   >> cmds.txt
echo format FS=NTFS quick LABEL="WTG-WINDOWS"   >> cmds.txt
echo assign letter=W                            >> cmds.txt
echo attributes volume set NODEFAULTDRIVELETTER >> cmds.txt

diskpart /s cmds.txt
del cmds.txt

REM Apply the image from the command line.
dism /apply-image /index:1 /applydir:w:\ /imagefile:%2

REM Change the boot sector from Windows 7 to Windows 8
w:\windows\system32\bootsect.exe /nt60 S:

REM We're running bcdboot from the newly applied image so we know that the correct boot files for the architecture and operating system are used.
w:\windows\system32\bcdboot.exe W:\windows /F ALL /s S:

REM Apply SAN policy and configure the default unattend file.
dism /image:w:\ /apply-unattend:San_Policy.xml
copy  unattend.xml w:\windows\System32\sysprep\unattend.xml

del San_Policy.xml
del unattend.xml

goto end

:InvalidDrive
ECHO ERROR: do not specify the boot drive (ID 0), this would erase the current drive.

:help
ECHO Usage WTG_WIN7_Provision.cmd ^<USB DiskId^> ^<PathToWim^>
ECHO
ECHO Example: WTG_WIN7_Provision.cmd 1 .\9200_x86fre_ent.wim
:end
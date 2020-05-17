:::v1.2 Update for Win10
@echo off
setLocal EnableDELAYedeXpansion
cls
IF [%1] NEQ [] GOTO FullyAutomated
:PartAutomated
	ECHO.
	ECHO.
	ECHO 	Use the commands below to create the drive
	ECHO.
	ECHO.
	ECHO  LIST DISK
	ECHO  SELECT DISK 'Q'
	ECHO  CLEAN
	ECHO  CREATE PART PRI
	ECHO  FORMAT FS=NTFS QUICK
	ECHO  ACTIVE
	ECHO  ASSIGN
	ECHO  EXIT
DISKPART
    IF %~d0==C: (
      SET /P L="Enter the newly created drive letter, just the drive letter:"
      SET DestDrive=!L!:
      ECHO Your drive letter is: !L!
    ) ELSE (
      SET D=%~d0
    )
LABEL %DestDrive% Win2Go
IMAGEX.EXE /APPLY INSTALL.WIM 1 %DestDrive%
BCDBOOT.EXE %DestDrive%\WINDOWS /S %DestDrive% /F ALL
COPY unattend.xml %DestDrive%\Windows\System32\sysprep\
COPY san_policy.xml %DestDrive%\
Dism.exe /Image:%DestDrive%\ /Apply-Unattend:%DestDrive%\san_policy.xml
GOTO :eof
:FullyAutomated
setlocal
DISKPART /S %1
SET DestDrive=Q:
LABEL %DestDrive% Win2Go
DISM /apply-image /imagefile:INSTALL.WIM /index:1 /ApplyDir:%DestDrive%\
BCDBOOT.EXE %DestDrive%\WINDOWS /S %DestDrive% /F ALL
COPY unattend.xml %DestDrive%\Windows\System32\sysprep\
COPY san_policy.xml %DestDrive%\
DISM /Image:%DestDrive%\ /Apply-Unattend:%DestDrive%\san_policy.xml
GOTO :eof

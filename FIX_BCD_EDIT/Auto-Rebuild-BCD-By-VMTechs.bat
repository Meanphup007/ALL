@echo OFF
Title  == Rebuid BCD in Both MBR AND GPT Systems By ValiumMediaTechs YouTube Channel and vmtechs.net ==
color 1e
echo       ./////////////////////////////////////////////////////////////////////////////////////////////////////
echo      .////          ValiumMedia Techs YouTube Channel                    .////
echo     .////                      Copyrighted script!                                       .////
echo    .////       Modification or reuse in YouTube or another             .////
echo   .////      website without prior permission is not allowed.         .////
echo  .////                                                                                        .////
echo .////////////////////////////////////////////////////////////////////////////////////////////////



@if not exist X:\Windows\System32 echo ERROR: This script is built to run in Windows Reovery Environment [WinRE] or Windows Preinstillation Environment [WinPE].
@if not exist X:\Windows\System32 goto END


@rem *********************** Detecting Windoows OS Partition *********************
@echo Finding the letter of Windows OS  partition.
@for %%a in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%a:\Windows\System32\config\BCD-Template" set OSDRIVE=%%a
if defined OSDRIVE (
@echo The Windows OS is on Partition: %OSDRIVE%
BCDBOOT %OSDRIVE%:\WINDOWS
GOTO GPT.OR.MBR
) else (
goto LocateSystemHive
)

:LocateSystemHive
@for %%b in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%b:\Windows\System32\config\system" set OSDRIVE=%%b
if defined OSDRIVE (
@echo The Windows OS is on Partition: %OSDRIVE%
BCDBOOT %OSDRIVE%:\WINDOWS
GOTO CopyTheBCD
) else (
goto LocateCMD
)

:LocateCMD
@for %%C in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%C:\Windows\System32\CMD.EXE" set OSDRIVE=%%C
if defined OSDRIVE (
@echo The Windows OS is on Partition: %OSDRIVE%
ECHO The System [and maybe other Registry files] is/are not avaialble in the Config folder. 
echo Your system won't boot if the Config or some of its contents are missing even if the BCD has been built successfully.
goto CopyTheBCD
) else (
goto NoOSDrive
)


:CopyTheBCDQuestion
color 0c
ECHO Wrong Answer! Please Answer Y(Yes) or N(No):
:CopyTheBCD
@echo ********************* Missing BCD-Template File *****************************
ECHO the BCD-Template File is missing! This file is required to rebuild the Boot Configuration data "BCD".
@echo Do you want to copy the BCD-Template file from the Vmtechs folder? (Y or N):
@SET /P CopyBCD=(Y or N):
@if %CopyBCD%.==yes. set CopyBCD=Y
@if %CopyBCD%.==no. set CopyBCD=N
@if %CopyBCD%.==y. set CopyBCD=Y
@if %CopyBCD%.==n. set CopyBCD=N
@if %CopyBCD%.==Y. GOTO DoCopyBCD
@if %CopyBCD%.==N. GOTO End
@if %CopyBCD%.==%CopyBCD%. GOTO CopyTheBCDQuestion


:DoCopyBCD
XCOPY "%~dp0BCD-Template" "%OSDRIVE%:\Windows\System32\Config\" /I /K /H /Y
BCDBOOT %OSDRIVE%:\WINDOWS

@echo ********************* Locating WIM Drive ************************************
@echo Searching for the WIM Drive.
for %%w in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%w:\SOURCES\INSTALL.WIM" set WIMDRIVE=%%w
if defined WIMDRIVE (
@echo The WIM is on: %WIMDRIVE% 
goto GPT.OR.MBR
) else ( 
)


for %%w in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%w:\SOURCES\INSTALL.ESD" set WIMDRIVE=%%w
if defined WIMDRIVE (
@echo The WIM "ESD" Drive is on: %WIMDRIVE% 
) else ( 
Windows Installation Media is Unavailable! 
)


:GPT.OR.MBR
@echo  ***************************** GPT OR MBR *************************************
@echo Checking to see if the PC is booted in BIOS or UEFI mode
wpeutil UpdateBootInfo
for /f "tokens=2* delims=	 " %%M in ('reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType') DO SET Firmware=%%N
@if x%Firmware%==x goto GeneralMethod
@if %Firmware%==0x1 set Temp.scheme= MBR 
@if %Firmware%==0x2 set Temp.scheme= GPT
echo your Disk scheme is %Temp.scheme%
@if %Firmware%==0x1 GOTO MBR 
@if %Firmware%==0x2 GOTO GPT 

:GeneMethodQuestion
color 0c
ECHO Wrong Answer! Please Answer Y(Yes) or N(No):
:GeneralMethod
ECHO ERROR: Can't figure out which firmware we're on.
@echo Do you want to rebuild the BCD using general method? (Y or N):
@SET /P GeneralMethod=(Y or N):
@if %GeneralMethod%.==yes. set GeneralMethod=Y
@if %GeneralMethod%.==no. set GeneralMethod=n
@if %GeneralMethod%.==y. set GeneralMethod=Y
@if %GeneralMethod%.==n. set GeneralMethod=n
@if %GeneralMethod%.==Y. GOTO GeneralRebuild
@if %GeneralMethod%.==N. GOTO End
@if %GeneralMethod%.==%GeneralMethod%. GOTO GeneMethodQuestion



:MBR
@echo  ******************************MBR************************************
:LocatingSystemPart
color 1e
@echo Locating the Letter of System Partition:
@for %%s in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%s:\Boot\BCD.LOG" set SYSDRIVE=%%s
if defined SYSDRIVE (
@echo BCD Files are on Partition: %SYSDRIVE%
goto AutoVerifySys
) else (
GOTO NoSysDrive
)


:NoSysDrive
color 1e
@echo System Partition is unavailable or cannot be dedected because you haven't assign a letter to all Partitions!
 @echo Unavailablity of System Partition may indicate that you have cloned your old disk to this disk, you have remved the System Partition manually or your system partition created on another disk which is not connected or not working now.
goto Nexx
:CreateSysPartQuestion
color 0c
ECHO Wrong Answer! Please Answer Y(Yes) or N(No):
:Nexx
 @echo If you are sure you have assigned a letter to all partitions, do you Want to Create a New System partition Automatically? (Y or N):
@SET /P CREATESYSPART=(Y or N):
@if %CREATESYSPART%.==yes. set CREATESYSPART=Y
@if %CREATESYSPART%.==no. set CREATESYSPART=N
@if %CREATESYSPART%.==y. set CREATESYSPART=Y
@if %CREATESYSPART%.==n. set CREATESYSPART=N
@if %CREATESYSPART%.==Y. GOTO CREATE-MBR-SYS-BY-VMTechs
@if %CREATESYSPART%.==N. GOTO GeneralRebuild
@if %CREATESYSPART%.==%CREATESYSPART%. GOTO CreateSysPartQuestion



:AutoVerifySys
if not %SYSDRIVE%==%OSDRIVE% GOTO NEXT4
if not %SYSDRIVE%==%WIMDRIVE% GOTO NEXT4
echo Both Windows and Boot files are located on the same partition, which is = ( %OSDRIVE% )
goto GeneralRebuild

:NEX4Question
color 0c
ECHO Wrong Answer! Please Answer Y(Yes) or N(No):

:NEXT4
@echo The BCD is on Partition: ( %SYSDRIVE% )
@echo Does ( %SYSDRIVE% ) is your SYSTEM partition? Please Carefully answer 
@echo to Confirm that the ( %SYSDRIVE% ) is not Your Windows or USB Drive Partition. 
@echo Answrying Yes or Pressing Enter from Keyboard will Remove ( %SYSDRIVE% ) partition and everything inside it. (Y or N):
@SET /P SYSTEMEXIST=(Y or N):
@if %SYSTEMEXIST%.==yes. set SYSTEMEXIST=Y
@if %SYSTEMEXIST%.==no. set SYSTEMEXIST=N
@if %SYSTEMEXIST%.==y. set SYSTEMEXIST=Y
@if %SYSTEMEXIST%.==n. set SYSTEMEXIST=N
@if %SYSTEMEXIST%.==Y. GOTO RemovingSystemPart
@if %SYSTEMEXIST%.==N. GOTO END
@if %SYSTEMEXIST%.==%SYSTEMEXIST%. GOTO NEX4Question
@echo  ******************************MBR************************************
:RemovingSystemPart
color 1e
echo Remvoing old file
DEL %OSDRIVE%:\DEL.txt
rem Saved in "%~dp0:\WriteText.bat"
echo SEL VOL %SYSDRIVE%>>%OSDRIVE%:\DEL.txt
echo DEL VOL OVERRIDE>>%OSDRIVE%:\DEL.txt
echo create partition PRIMARY size=100>>%OSDRIVE%:\DEL.txt
echo format quick fs=NTFS label=System OVERRIDE>>%OSDRIVE%:\DEL.txt
echo ASSIGN LETTER=V>>%OSDRIVE%:\DEL.txt
echo ACTIVE>>%OSDRIVE%:\DEL.txt
echo Exit>>%OSDRIVE%:\DEL.txt
GOTO CreateSystemPartByValiumMediaTech
@echo  *******************************MBR***********************************
:CreateSystemPartByValiumMediaTech
color 1e
echo Creating System Partition ...
DISKPART /S "%OSDRIVE%:\DEL.txt"
echo.
goto DoRebuildBCD


@echo  *********************************MBR*********************************
:CREATE-MBR-SYS-BY-VMTechs
color 1a
echo Creating New System partition
pause
DEL %OSDRIVE%:\VMTechs.txt
rem Saved in "%~dp0:\WriteText.bat"
echo SEL VOL %OSDRIVE%>>%OSDRIVE%:\VMTechs.txt
echo SHRINK DESIRED=100>>%OSDRIVE%:\VMTechs.txt
echo create partition PRIMARY size=100>>%OSDRIVE%:\VMTechs.txt
echo format quick fs=NTFS label=System>>%OSDRIVE%:\VMTechs.txt
echo ASSIGN LETTER=V>>%OSDRIVE%:\VMTechs.txt
echo ACTIVE>>%OSDRIVE%:\VMTechs.txt
echo Exit>>%OSDRIVE%:\VMTechs.txt
Title Create System Partition by ValiumMediaTech
echo Create EFI partition ...
DISKPART /S "%OSDRIVE%:\VMTechs.txt"
echo.
goto DoRebuildBCD



@echo  ********************************GPT**********************************
:GPT
color 1a
@echo Find the Drive Letter of EFI Partition.
@for %%L in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%L:\EFI\Microsoft\Boot\BCD.log" set EFIDRIVE=%%L
if defined EFIDRIVE (
@echo EFI Partition is: %EFIDRIVE%
goto AutoVerifyEFI
) else (
GOTO NoEFIDrive
)

:NoEFIDrive
echo Mount EFI using MOUNTVOL tool
MOUNTVOL M: /S
@for %%L in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%L:\EFI\Microsoft\Boot\BCD.log" set EFIDRIVE=%%L
if defined EFIDRIVE (
@echo EFI Partition is on: %EFIDRIVE%
GOTO AutoVerifyEFI
) else (
GOTO CREATEEFI
)



:AutoVerifyEFI
echo EFI Validation
if %EFIDRIVE%==%OSDRIVE% GOTO END
if %EFIDRIVE%==%WIMDRIVE% GOTO END
GOTO RemovingEFIPart

:CreatEFIQuestion
color 0c
ECHO Wrong Answer! Please Answer Y(Yes) or N(No):
GOTO CreateEFIQ
:CREATEEFI
color 1a
@echo The EFI partition can't be detect.
 @echo  Unavailablity of System Partition may indicate that you have cloned your old disk to this diisk, you have remved the EFI Partition manually or your system partition created on another disk which is not connected or not working now.
:CreateEFI
 @echo If that was true, Do you want to create a  new EFI partition? (Y or N):
@SET /P CREATEEFI=(Y or N):
@if %CREATEEFI%.==yes. set CREATEEFI=Y
@if %CREATEEFI%.==no. set CREATEEFI=Y
@if %CREATEEFI%.==y. set CREATEEFI=Y
@if %CREATEEFI%.==n. set CREATEEFI=Y
@if %CREATEEFI%.==Y. GOTO CREATEVMTechsGPT
@if %CREATEEFI%.==N. GOTO EFIGENERAL
@if %CREATEEFI%.==%CREATEEFI%. GOTO CreatEFIQuestion
@echo  ******************************GPT************************************


:EFIGENQUEST
color 0c
ECHO Wrong Answer! Please Answer Y(Yes) or N(No):
:EFIGENERAL
@echo Do you want to rebuild the BCD using general methods without creating or deleting the EFI Partition? (Y or N):
@SET /P EFIGENERAL=(Y or N):
@if %EFIGENERAL%.==yes. set EFIGENERAL=Y
@if %EFIGENERAL%.==no. set EFIGENERAL=Y
@if %EFIGENERAL%.==y. set EFIGENERAL=Y
@if %EFIGENERAL%.==n. set EFIGENERAL=Y
@if %EFIGENERAL%.==Y. GOTO GeneralRebuild.GPT
@if %EFIGENERAL%.==N. GOTO END
@if %EFIGENERAL%.==%EFIGENERAL%. GOTO EFIGENQUEST
@echo  ******************************GPT************************************



:RemovingEFIPart
color 1a
echo Formatting EFI Partition
DEL %OSDRIVE%:\DEL.txt
rem Saved in "%~dp0:\WriteText.bat"
echo SEL VOL %EFIDRIVE%>>%OSDRIVE%:\DEL.txt
echo DEL VOL OVERRIDE>>%OSDRIVE%:\DEL.txt
echo create partition EFI size=100>>%OSDRIVE%:\DEL.txt
echo format quick fs=FAT32 label=EFI>>%OSDRIVE%:\DEL.txt
echo ASSIGN LETTER=V>>%OSDRIVE%:\DEL.txt
echo Exit>>%OSDRIVE%:\DEL.txt
echo Create EFI partition ...
DISKPART /S "%OSDRIVE%:\DEL.txt"
goto DoRebuildBCD.GPT

@echo  *******************************GPT***********************************
:CREATEVMTechsGPT
color 1a
echo Creating New EFI partition
DEL %OSDRIVE%:\VMTechs.txt
rem Saved in "%~dp0:\WriteText.bat"
echo SEL VOL %OSDRIVE%>>%OSDRIVE%:\VMTechs.txt
echo SHRINK DESIRED=100>>%OSDRIVE%:\VMTechs.txt
echo create partition EFI size=100>>%OSDRIVE%:\VMTechs.txt
echo format quick fs=FAT32 label=EFI>>%OSDRIVE%:\VMTechs.txt
echo ASSIGN LETTER=V>>%OSDRIVE%:\VMTechs.txt
echo Exit>>%OSDRIVE%:\VMTechs.txt
Title Create EFI Partition by ValiumMediaTech
echo Create EFI partition ... 
DISKPART /S "%OSDRIVE%:\VMTechs.txt"
echo.
GOTO DoRebuildBCD.GPT


:DoRebuildBCD
echo Rebuild the BCD file by ValiumMediaTech
BOOTREC /FIXMBR
BOOTSECT /NT60 SYS /FORCE
BOOTREC /FIXBOOT
BOOTREC /REBUILDBCD
BCDBOOT "%OSDRIVE%:\Windows"
if not %errorlevel%==0 GOTO SPECIFYSYS
GOTO EnableRecovery

:SPECIFYSYS
BCDBOOT "%OSDRIVE%:\Windows" /s %EFIDRIVE%:
GOTO EnableRecovery




:DoRebuildBCD.GPT
echo Rebuild the BCD file by ValiumMediaTech
BOOTREC /FIXMBR
BOOTSECT /NT60 SYS /FORCE
BOOTREC /FIXBOOT
BOOTREC /REBUILDBCD
BCDBOOT "%OSDRIVE%:\Windows"


GOTO EnableRecovery



:GeneralRebuild
color 1a
@echo  ***************************** General BCD Rebuild *************************************
ECHO Simple BCD rebuild by ValiumMediaTech
ATTRIB -H -S -R %SYSDRIVE%:\Boot\BCD
REN %SYSDRIVE%:\Boot\BCD BCD.OLD
BOOTREC /FIXMBR
BOOTSECT /NT60 SYS /FORCE
BOOTREC /FIXBOOT
BOOTREC /REBUILDBCD
BCDBOOT "%OSDRIVE%:\Windows"
If %errorlevel%==0 GOTO EnableRecovery


:GeneralRebuild.GPT
color 1a
@echo  ***************************** General BCD Rebuild *************************************
ATTRIB -H -S -R %EFIDRIVE%:\EFI\MICROSOFT\Boot\BCD
REN %EFIDRIVE%:\EFI\MICROSOFT\Boot\BCD BCD.OLD
ECHO Simple BCD rebuild by ValiumMediaTech
BOOTREC /FIXMBR
BOOTSECT /NT60 SYS /FORCE
BOOTREC /FIXBOOT
BOOTREC /REBUILDBCD
BCDBOOT "%OSDRIVE%:\Windows"
if not %errorlevel%==0 GOTO SPECIFYEFI
GOTO EnableRecovery

:SPECIFYEFI
BCDBOOT "%OSDRIVE%:\Windows" /s %EFIDRIVE%:



:EnableRecovery
@echo ***************** Enable Recovery Environment **********************************
CD /D "%OSDRIVE%:\Windows\System32
for /F "tokens=2" %%j in ('bcdedit /V /enum ^| findstr /i /v "Winre" ^| findstr /I"winload" /C:"identifier"') do set MyGUID=%%j
REAGENTC /ENABLE /OSGUID %MyGUID%
If %errorlevel%==0 GOTO End




@echo Finding a drive letter of Recovery partition.

@for %%Y in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%Y:\RECOVERY\WINDOWSRE\winre.wim" set WinREDrive=%%Y
if defined WinREDrive (
@echo The Recovery files are on Partition: %WinREDrive%
GOTO VerifyRecovery
) else (
GOTO NoRecoveryDrive
)


:VerifyRecovery
if not %WinREDrive%==%OSDRIVE% GOTO FormatRecovery
GOTO DoEnableRecoveryOnOSDrive



:formatWinREQUEST
color 0c
ECHO Wrong Answer! Please Answer Y(Yes) or N(No):
:FormatRecovery
echo Your Recovery files are on %WinREDrive% partition.
echo Do you want to Format it and rebuild the Recovery again? (Y or N):
echo if your answer is N/No, I will try to Enable the Recovery without formatting. But if the enabling failed. you have to run me aagain and answer Y or Yes to allow formatting and rebuilding the Recovery.
@SET /P FormatWinRE=(Y or N):
@if %FormatWinRE%.==yes. set FormatWinRE=Y
@if %FormatWinRE%.==no. set FormatWinRE=N
@if %FormatWinRE%.==y. set FormatWinRE=Y
@if %FormatWinRE%.==n. set FormatWinRE=N
@if %FormatWinRE%.==Y. GOTO FormatRecovery
@if %FormatWinRE%.==N. GOTO DoEnableRecovery
@if %FormatWinRE%.==%FormatWinRE%. GOTO formatWinREQUEST


:doFormatRecovery
echo formatting the Recovery Partition
xcopy %WinREDrive%:\RECOVERY\WINDOWSRE\ %OSDRIVE%:\VMTechs\RECOVERY\ /K /I /H /Y

xcopy %WinREDrive%:\RECOVERY\WINDOWSRE\winre.wim %OSDRIVE%:\windows\system32\RECOVERY\ /K /I /H /Y
DEL %OSDRIVE%:\DEL.txt
rem Saved in "%~dp0:\WriteText.bat"
echo SEL VOL %WinREDrive%>>%OSDRIVE%:\DEL.txt
echo format quick fs=NTFS label=Recovery OVERRIDE>>%OSDRIVE%:\DEL.txt
echo Exit>>%OSDRIVE%:\DEL.txt
DISKPART /S "%OSDRIVE%:\DEL.txt"
GOTO DoEnableRecovery

set id=de94bba4-06d1-4d40-a16a-bfd50179d6ac
GPT ATTRIBUTES=0X8000000000000001


:NoRecoveryDrive
@echo Search for WinRE.wim
@for %%T in (%OSDRIVE%) do @if exist "%OSDRIVE%:\windows\system32\RECOVERY\winre.wim" set WinREFile=%%T
if defined WinREFile (
GOTO DoEnableRecovery
) else (
GOTO NoWinREFile
)


:ExtractWinREQUEST
color 0c
ECHO Wrong Answer! Please Answer Y(Yes) or N(No):
:NoWinREFile
echo WinRE.wim file is not available. Make sure you have assigned a free letter to all volumes.
echo If you have assigned a letter to all volumes, Do you want to extract it from Windows Installation Media? (Y or N):
@SET /P ExtractWinRE=(Y or N):
@if %ExtractWinRE%.==yes. set ExtractWinRE=Y
@if %ExtractWinRE%.==no. set ExtractWinRE=N
@if %ExtractWinRE%.==y. set ExtractWinRE=Y
@if %ExtractWinRE%.==n. set ExtractWinRE=N
@if %ExtractWinRE%.==Y. GOTO ExtractingWinRE
@if %ExtractWinRE%.==N. GOTO DoEnableRecovery
@if %ExtractWinRE%.==%ExtractWinRE%. GOTO ExtractWinREQUEST


:ExtractingWinRE
for %%H in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%H:\SOURCES\INSTALL.WIM" set WIMDRIV=%%H
if defined WIMDRIV (
echo WIM Drive is=%WIMDRIV%
GOTO DoExtractingWinRE
) else (
goto IsEsd
)

:IsEsd
for %%H in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do @if exist "%%H:\SOURCES\INSTALL.WIM" set WIMDRIV=%%H
if defined WIMDRIV (
echo WIM Drive is=%WIMDRIV%
GOTO DoExtractingWinRE.ESD
) else (
echo Windows Installation Media "WIM" is unavailable or cannot be detect.
echo Connect a WIM like USB or DVD and try again.
GOTO End
)


:DoExtractingWinRE
If exist %~dp07-zip goto doooo
if exist "%OSDRIVE%:\Program Files\7-Zip\7z.exe" goto doooo2
if exist "%OSDRIVE%:\Program Files (x86)\7-Zip\7z.exe" goto doooo3
echo the 7-Zip folder is missing or not contain the required files to extract the WinRE image!
echo please add the 7-Zip folder with its contents into the folder or parth from which you have run this script and then try again.
goto End

:doooo
echo ****************** Extracting registry Files from WIM to "%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY *******************
CD /D %~dp07-zip
7z e %WIMDRIV%:\sources\install.wim -O%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\ 6\Windows\System32\Recovery\WinRE.wim
goto DoEnableRecovery


:doooo2
echo ****************** Extracting registry Files from WIM to "%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY *******************
CD /D "%OSDRIVE%:\Program Files\7-Zip\"
7z e %WIMDRIV%:\sources\install.wim -O%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\ 6\Windows\System32\Recovery\WinRE.wim
goto DoEnableRecovery



:doooo3
echo ****************** Extracting registry Files from WIM to "%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY *******************
CD /D "C:\Program Files (x86)\7-Zip\"
7z e %WIMDRIV%:\sources\install.wim -O%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\ 6\Windows\System32\Recovery\WinRE.wim
goto DoEnableRecovery



:DoExtractingWinRE.ESD
If exist %~dp07-zip goto dooooo
if exist "%OSDRIVE%:\Program Files\7-Zip\7z.exe" goto dooooo2
if exist "%OSDRIVE%:\Program Files (x86)\7-Zip\7z.exe" goto dooooo3
echo the 7-Zip folder is missing or not contain the required files to extract the WinRE image!
echo please add the 7-Zip folder with its contents into the folder or parth from which you have run this script and then try again.
goto End


:dooooo
echo ****************** Extracting registry Files from WIM to "%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY *******************
CD /D %~dp07-zip
7z e %WIMDRIV%:\sources\install.ESD -O%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\ 6\Windows\System32\Recovery\WinRE.wim
goto DoEnableRecovery

:dooooo2
echo ****************** Extracting registry Files from WIM to "%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY *******************
CD /D "%OSDRIVE%:\Program Files\7-Zip\"
7z e %WIMDRIV%:\sources\install.ESD -O%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\ 6\Windows\System32\Recovery\WinRE.wim
goto DoEnableRecovery

:dooooo3
echo ****************** Extracting registry Files from WIM to "%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY *******************
CD /D "C:\Program Files (x86)\7-Zip\"
7z e %WIMDRIV%:\sources\install.ESD -O%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\ 6\Windows\System32\Recovery\WinRE.wim






:DoEnableRecovery
ECHO Enabling Recovery Environment on "%WinREDrive%" partition...
attrib -h -s -r %WinREDrive%:\Recovery\WindowsRE\reagent.xml
REN %WinREDrive%:\Recovery\WindowsRE\reagent.xml REAGENT.XML.old
for %%E in (%OSDRIVE%) do @if exist "%OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\REAGENT.XML.old" set REAGENTOld=%%E
if defined REAGENTOld (
Ren %OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\REAGENT.XML.NEW
GOTO DoEnableRecovery2
)
ELSE (
Ren %OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\REAGENT.XML.old
)
:DoEnableRecovery2
CD /D "%OSDRIVE%:\Windows\System32
Ren %OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\REAGENT.XML.old /F /Q
for /F "tokens=2" %%K in ('bcdedit /V /enum ^| findstr /i /v "Winre" ^| findstr /I"winload" /C:"identifier"') do set MyGUID=%%K
echo my OSGUID IS= %MyGUID%
REAGENTC /ENABLE /OSGUID %MyGUID%
GOTO End

:DoEnableRecoveryOnOSDrive
ECHO Enabling Recovery Environment on "%OSDRIVE%" partition...
Ren %OSDRIVE%:\RECOVERY\WINDOWSRE\REAGENT.XML.old
REN %OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\REAGENT.XML REAGENT.XML.old
xcopy %OSDRIVE%:\Recovery\WindowsRE\Winre.wim %OSDRIVE%:\Windows\System32\recovery\ /K /H /Y
attrib -h -s -r %OSDRIVE%:\Recovery\WindowsRE\reagent.xml
del %OSDRIVE%:\Recovery\WindowsRE\reagent.xml /q /f
CD /D "%OSDRIVE%:\Windows\System32
attrib -h -s -r %OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\REAGENT.XML
DEL %OSDRIVE%:\WINDOWS\SYSTEM32\RECOVERY\REAGENT.XML /F /Q
for /F "tokens=2" %%K in ('bcdedit /V /enum ^| findstr /i /v "Winre" ^| findstr /I"winload" /C:"identifier"') do set MyGUID=%%K
echo my OSGUID IS= %MyGUID%
REAGENTC /ENABLE /OSGUID %MyGUID%
GOTO End



:NoOSDrive
color 04
@echo Windows partition can't be found!
echo This may happen if system files were deleted or if the windows partition has no an assigned letter.

:END
color 0a
ECHO This is the End!
Pause
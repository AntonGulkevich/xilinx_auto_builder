@echo off
goto start
------------------------------------------------------------------------------------------------------------------------------------
Deployment batch file
last changes 28.11.2015 Gulkevich_A
Error levels:
	1 - Config file is unavailable
	2 - xsct.bat file is unavailable
	3 - ELF FILE is not exist or unavalible
	4 - BOOTLOADER is not exist or unavalible
	5 - HDFFILE is not exist or unavalible
	6 - boot.bin is not exist or unavalible
	7 - something bad happened
	8 - impossible is nothing
------------------------------------------------------------------------------------------------------------------------------------
:start
set ERROREXIT=0
chcp 866 >NUL
set VARBAT=%~dp0\var.bat
:: check config file----------------------------------------------------------------------------------------------------------------
if not exist "%VARBAT%" (
    echo FAIL: Config file is unavailable
	set ERROREXIT=1
	goto deleteExit
)

call "%VARBAT%"
:: check xsct.bat file--------------------------------------------------------------------------------------------------------------
if not exist "%XSCTDEST%" (
    echo FAIL: xsct.bat file is unavailable
	set ERROREXIT=2
	goto deleteExit
)
::set local parameters--------------------------------------------------------------------------------------------------------------
set "TCLFILE=xcomp.tcl"
set "MAKEFILE=makeFile.tcl"
set "HWPNAME=ubs_design_wrapper_hw_platform_0"
set "ELFFILE=%WORKSPACE%\%PROJECTNAME%\Debug\%PROJECTNAME%.elf"
set "TEMPDIR=%WORKSPACE%\tempDir"
::clear previous workspace----------------------------------------------------------------------------------------------------------
echo clearing previous workspace
FOR /D %%p IN ("%WORKSPACE%\*.*") DO rmdir "%%p" /s /q
::clear previous build and temp folders---------------------------------------------------------------------------------------------
echo clearing temp files
FOR /D %%p IN ("%TEMPDIR%\*.*") DO rmdir "%%p" /s /q
::create tcl file-------------------------------------------------------------------------------------------------------------------
chcp 1251 >NUL
echo sdk set_workspace %WORKSPACE%\\ > "%TCLFILE%"
echo sdk create_hw_project -name %HWPNAME% -hwspec %HDFFILE% >> "%TCLFILE%"
echo sdk create_bsp_project -name %PROJECTNAME%_bsp -hwproject %HWPNAME% -proc ps7_cortexa9_0 -os standalone >> "%TCLFILE%"
echo sdk create_app_project -name %PROJECTNAME% -hwproject %HWPNAME% -bsp %PROJECTNAME%_bsp -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} >> "%TCLFILE%"
echo exit >> "%TCLFILE%"
chcp 866 >NUL
timeout /t 1 /nobreak > NUL
::execute tcl file------------------------------------------------------------------------------------------------------------------
echo executing tcl file "%TCLFILE%"
call "%XSCTDEST%" "%TCLFILE%"
if not errorlevel 0 (
	echo Fail: error in xsct while creating project.
	set ERROREXIT=7
	goto deleteExit
)
::copy source files-----------------------------------------------------------------------------------------------------------------
xcopy /s/e/y/h "%CRCFILES%" "%WORKSPACE%\%PROJECTNAME%"
::build elf file--------------------------------------------------------------------------------------------------------------------
echo sdk set_workspace %WORKSPACE%\\ > makeFile.tcl
echo sdk build_project  >> makeFile.tcl
echo exit >> makeFile.tcl
timeout /t 1 /nobreak > NUL
call "%XSCTDEST%" makeFile.tcl
if not errorlevel 0 (
	echo Fail: error in xsct while building project.
	set ERROREXIT=7
	goto deleteExit
)
::check file existance--------------------------------------------------------------------------------------------------------------
:checkExist
if not exist "%ELFFILE%" (
	echo Fail: %ELFFILE% is not exist
	set ERROREXIT=3
	goto deleteExit
)
:checkExist1
if not exist "%BOOTLOADER%" (
	echo Fail: %BOOTLOADER% is not exist
	set ERROREXIT=4
	goto deleteExit
)
:checkExist2
if not exist "%HDFFILE%" (
	echo Fail: %HDFFILE% is not exist
	set ERROREXIT=5
	goto deleteExit
)
::check is file unlocked------------------------------------------------------------------------------------------------------------
:unlocked
if exist "%ELFFILE%" (
	goto isUnloked
	timeout /t 1 /nobreak > NUL
	echo Warning:%ELFFILE% is locked
	goto unlocked
)
:isUnloked
rename "%ELFFILE%" "%ELFFILE%"
if not errorlevel 0 goto isUnloked
echo "%ELFFILE%" is ready to process
::creating biff file----------------------------------------------------------------------------------------------------------------
echo creating boot.bin
echo the_ROM_image: > output.bif
echo { >> output.bif
echo [bootloader]%BOOTLOADER% >> output.bif
echo %WORKSPACE%\%HWPNAME%\ubs_design_wrapper.bit >> output.bif
echo %ELFFILE% >> output.bif
echo } >> output.bif
timeout /t 1 /nobreak > NUL
::boot gen -------------------------------------------------------------------------------------------------------------------------
call "%BOOTGENFILE%" -image output.bif -o i "%WORKSPACE%\boot.bin" -w
if not errorlevel 0 (
	echo Fail: error in "%BOOTGENFILE%" while building boot.bin.
	set ERROREXIT=7
	goto deleteExit
)
if not exist "%WORKSPACE%\boot.bin" (
	echo Fail: "%WORKSPACE%\boot.bin" is not exist
	set ERROREXIT=6
	goto deleteExit
)
echo %WORKSPACE%\boot.bin created successfully
::adding crc to boot.bin------------------------------------------------------------------------------------------------------------
call calcRCR32.exe %WORKSPACE%\boot.bin 
::creating disk structure-----------------------------------------------------------------------------------------------------------
::disk
::	bin
::		TUKN.00114-05_JTAG.exe
::			burn.bat
::			BOOT.bin
::		TUKN.00114-05_USB.exe
::			fw-c.exe
::			burn.bat
::			BOOT.bin
::	doc
::		Инструкция по загрузке .docx
::		Лист утверждения ПO.docx
::		Лист утверждения ПO.docx
::		Спецификация.docx
::		Текст программ.docx
::		ТЗ тестовое Разбор и вывод данных записанных с приемника цифрового сигнала.docx
::		ТЗ убс ПЛИС.docx
::	pcfw
::		CyUSB.dll
::		DeviceManager.dll
::		FTDDeviceManager.dll
::		imit_BPUTester.dll
::		MahApps.Metro.dll
::		MMTimer.dll
::		OxyPlot.dll
::		OxyPlot.Wpf.dll
::		OxyPlot.Xps.dll
::		SCC_468173_007.dll
::		SccChannelControl.dll
::		SCContracts.dll
::		SCDeviceInterface.dll
::		SCDeviceManager.dll
::		SCStreams.dll
::		SCVirtualChannelDevice.dll
::		System.Windows.Interactivity.dll
::		UBSApp.dll
::		UBSLib.dll
::		UBSManager.exe
::		СomposeContracts.dll
::	src
::		pld.exe
::		soft.exe
::			ucu_fw
::			ucu_fw_bsp
::	info.txt
::creating structure----------------------------------------------------------------------------------------------------------------
mkdir "%WORKSPACE%\disk"
mkdir "%WORKSPACE%\disk\bin"
mkdir "%WORKSPACE%\disk\doc"
mkdir "%WORKSPACE%\disk\pcwf"
mkdir "%WORKSPACE%\disk\src"
mkdir "%TEMPDIR%"
mkdir "%TEMPDIR%\burnubs"
::make rar.exe files--------------------------------------------------------------------------------------------------------------- 
::if exist "%Programfiles%\winrar\winrar.exe" (
::	set "WINRARDIST=%Programfiles%\winrar\winrar.exe"
::	goto packWinRar
::)
::set "WINRARDIST=%Programfiles% (x86)\winrar\winrar.exe"
::if not exist "%WINRARDIST%"(
::    echo FAIL: please install winrar in %WINRARDIST% 
::	goto deleteExit
::)
set "WINRARDIST=C:\Program Files\WinRAR\winrar.exe"
::packWinRar
::creating autorun.txt--------------------------------------------------------------------------------------------------------------
set "AUTORUNTXT=autorun.txt""
chcp 866 >NUL
set autorunText=Будет проведено программирование блока УБС\nпрограммым обеспечением ТЮКН.00114-05. Продолжить?,Программное обеспечение ТЮКН.00114-05
chcp 1251 >NUL
echo TempMode=%autorunText% > "%TEMPDIR%\%AUTORUNTXT%"
echo Setup=burn.bat >> "%TEMPDIR%\%AUTORUNTXT%"
chcp 866 >NUL
::create files.list zunq------------------------------------------------------------------------------------------------------------
echo "%WORKSPACE%\boot.bin" > "%TEMPDIR%\fileszynq.list"
echo "%TEMPDIR%\burn.bat" >> "%TEMPDIR%\fileszynq.list"
::create files.list zunq------------------------------------------------------------------------------------------------------------
echo "%WORKSPACE%\boot.bin" > "%TEMPDIR%\filesusb.list"
echo "%TEMPDIR%\burnubs\burn.bat" >> "%TEMPDIR%\filesusb.list"
echo "%FWCLOADER%" >> "%TEMPDIR%\filesusb.list"
::create burn.bat zynq--------------------------------------------------------------------------------------------------------------
echo set path=c:\Xilinx\SDK\2015.1\bin;%%PATH%% > "%TEMPDIR%\burn.bat"
echo zynq_flash -f BOOT.bin -offset 0x000000 -flash_type qspi_single -cable type xilinx_tcf url TCP:127.0.0.1:3121 >> "%TEMPDIR%\burn.bat"
echo pause >> "%TEMPDIR%\burn.bat"
::create burn.bat ubsl--------------------------------------------------------------------------------------------------------------
echo fw-l-c.exe BOOT.bin > "%TEMPDIR%\burnubs\burn.bat"
echo pause >> "%TEMPDIR%\burnubs\burn.bat"
::----------------------------------------------------------------------------------------------------------------------------------
echo Creating self extr. archive "%WORKSPACE%\disk\bin\TUKN.00114-05_JTAG.exe"...
call "%WINRARDIST%" a -sfx -ep -z"%TEMPDIR%\autorun.txt" -m5 "%WORKSPACE%\disk\bin\TUKN.00114-05_JTAG.exe" @"%TEMPDIR%\fileszynq.list"
if not errorlevel 0 (
	echo Fail: error in "%WINRARDIST%" while creating self extr. archive "%WORKSPACE%\disk\bin\TUKN.00114-05_JTAG.exe"
	set ERROREXIT=7
	goto deleteExit
)
echo Created self extr. archive "%WORKSPACE%\disk\bin\TUKN.00114-05_JTAG.exe"
::----------------------------------------------------------------------------------------------------------------------------------
echo Creating self extr. archive "%WORKSPACE%\disk\bin\TUKN.00114-05_USB.exe"...
call "%WINRARDIST%" a -sfx -ep -z"%TEMPDIR%\autorun.txt" -m5 "%WORKSPACE%\disk\bin\TUKN.00114-05_USB.exe" @"%TEMPDIR%\filesusb.list"
if not errorlevel 0 (
	echo Fail: error in "%WINRARDIST%" while creating self extr. archive "%WORKSPACE%\disk\bin\TUKN.00114-05_USB.exe"
	set ERROREXIT=7
	goto deleteExit
)
echo Created self extr. archive "%WORKSPACE%\disk\bin\TUKN.00114-05_USB.exe"
::----------------------------------------------------------------------------------------------------------------------------------
echo Creating self extr. archive "%WORKSPACE%\disk\src\soft.exe"...
call "%WINRARDIST%" a -sfx -ep1 -m5 "%WORKSPACE%\disk\src\soft.exe" "%WORKSPACE%\%PROJECTNAME%" "%WORKSPACE%\%PROJECTNAME%_bsp"
if not errorlevel 0 (
	echo Fail: error in "%WINRARDIST%" while creating self extr. archive "%WORKSPACE%\disk\src\soft.exe"
	set ERROREXIT=7
	goto deleteExit
)
echo Created self extr. archive "%WORKSPACE%\disk\src\soft.exe"
::----------------------------------------------------------------------------------------------------------------------------------
echo Creating self extr. archive "%WORKSPACE%\disk\src\pld.exe"...
call "%WINRARDIST%" a -sfx -ep1 -m5 "%WORKSPACE%\disk\src\pld.exe" "%PLDDEST%"
if not errorlevel 0 (
	echo Fail: error in "%WINRARDIST%" while creating self extr. archive "%WORKSPACE%\disk\src\pld.exe"
	set ERROREXIT=7
	goto deleteExit
)
echo Created self extr. archive "%WORKSPACE%\disk\src\pld.exe"
::copy files------------------------------------------------------------------------------------------------------------------------
xcopy /s/e/y/h "%DOCDEST%" "%WORKSPACE%\disk\doc" 
xcopy /s/e/y/h "%PCFWDEST%" "%WORKSPACE%\disk\pcwf"
xcopy /s/e/y/h "%INFOTXTFILEDEST%" "%WORKSPACE%\disk"
::----------------------------------------------------------------------------------------------------------------------------------
for %%A in (*.log) do del %%A
for %%A in (*.tcl) do del %%A
for %%A in (*.bif) do del %%A
rd /s /q .Xil
rd /s /q "%TEMPDIR%"
exit /b 0
::----------------------------------------------------------------------------------------------------------------------------------
:deleteExit
for %%A in (*.log) do del %%A
for %%A in (*.tcl) do del %%A
for %%A in (*.bif) do del %%A
rd /s /q .Xil
rd /s /q "%TEMPDIR%"
exit /b %ERROREXIT%

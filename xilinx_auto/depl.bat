@echo off
goto start
————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
Deployment batch file
last changes 19.11.2015
————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
::D:\ubs\Dev\lib\win32DLib\win32DLib\ucu_fw
::D:\x-ws\ubs_work.sdk\ubs_design_wrapper.hdf
::D:\Xilinx\SDK\2015.1\bin\xsct.bat
:start
set VARBAT=var.bat
:: check config file----------------------------------------------------------------------------------------------------------------
if not exist %VARBAT% (
    echo FAIL: Config file is unavailable
	pause
    exit /b 1
)
call %VARBAT%
:: check xsct.bat file--------------------------------------------------------------------------------------------------------------
if not exist %XSCTDEST% (
    echo FAIL: xsct.bat file is unavailable
	pause
    exit /b 1
)
::set local parameters--------------------------------------------------------------------------------------------------------------
set "TCLFILE=xcomp.tcl"
set "MAKEFILE=makeFile.tcl"
set "HWPNAME=ubs_design_wrapper_hw_platform_0"
set "ELFFILE=%WORKSPACE%%PROJECTNAME%\Debug\%PROJECTNAME%.elf"
::clear previous workspace----------------------------------------------------------------------------------------------------------
echo clear previous workspace
FOR /D %%p IN (%WORKSPACE%*.*) DO rmdir "%%p" /s /q
::create tcl file-------------------------------------------------------------------------------------------------------------------
echo sdk set_workspace %WORKSPACE% > %TCLFILE%
echo sdk create_hw_project -name %HWPNAME% -hwspec %HDFFILE% >> %TCLFILE%
echo sdk create_bsp_project -name %PROJECTNAME%_bsp -hwproject %HWPNAME% -proc ps7_cortexa9_0 -os standalone >> %TCLFILE%
echo sdk create_app_project -name %PROJECTNAME% -hwproject %HWPNAME% -bsp %PROJECTNAME%_bsp -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application}  >> %TCLFILE%
echo exit >> %TCLFILE%
timeout /t 1 /nobreak > NUL
::execute tcl file------------------------------------------------------------------------------------------------------------------
echo executing tcl file %TCLFILE%
call %XSCTDEST% %TCLFILE%
::copy source files-----------------------------------------------------------------------------------------------------------------
xcopy /s/e/y/h %CRCFILES% %WORKSPACE%\%PROJECTNAME%
::build elf file--------------------------------------------------------------------------------------------------------------------
echo sdk set_workspace %WORKSPACE% > makeFile.tcl
echo sdk build_project  >> makeFile.tcl
echo exit >> makeFile.tcl
timeout /t 1 /nobreak > NUL
call %XSCTDEST% makeFile.tcl
::check file existance--------------------------------------------------------------------------------------------------------------
echo %ELFFILE%
:checkExist
if not exist %ELFFILE% (
	timeout /t 1 /nobreak > NUL
	echo file is not exist
	goto checkExist
)
::check is file unlocked------------------------------------------------------------------------------------------------------------
:unlocked
if exist %ELFFILE% (
	goto isUnloked
	timeout /t 1 /nobreak > NUL
	echo file is locked
	goto unlocked
)
:isUnloked
rename %ELFFILE% %ELFFILE%
if not errorlevel 0 goto isUnloked
echo %ELFFILE% is ready to process
::creating biff file----------------------------------------------------------------------------------------------------------------
echo creating boot.bin

echo the_ROM_image: > output.bif
echo { >> output.bif
echo [bootloader]%BOOTLOADER% >> output.bif
echo %WORKSPACE%%HWPNAME%\ubs_design_wrapper.bit >> output.bif
echo %ELFFILE% >> output.bif
echo } >> output.bif

timeout /t 1 /nobreak > NUL
::boot gen -------------------------------------------------------------------------------------------------------------------------
call %BOOTGENFILE% -image output.bif -o i %WORKSPACE%boot.bin -w
:checkBootFile
if not exist %WORKSPACE%boot.bin (
	timeout /t 1 /nobreak > NUL
	goto checkBootFile
)
echo %WORKSPACE%boot.bin created successfully
::creating file structure-----------------------------------------------------------------------------------------------------------
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
mkdir %WORKSPACE%disk
mkdir %WORKSPACE%disk\bin
mkdir %WORKSPACE%disk\doc
mkdir %WORKSPACE%disk\pcwf
mkdir %WORKSPACE%disk\src
::create temp dir-------------------------------------------------------------------------------------------------------------------
set "TEMPDIR=%WORKSPACE%tempDir"
mkdir %TEMPDIR%
::make rar.exe files--------------------------------------------------------------------------------------------------------------- 
if exist "%Programfiles%\winrar\winrar.exe"
	set WINRARDIST=%Programfiles%\winrar\winrar.exe
	goto packWinRar
)
set WINRARDIST=%Programfiles% (x86)\winrar\winrar.exe
:packWinRar
if not exist %WINRARDIST%(
    echo FAIL: pls install winrar in %WINRARDIST%
	pause
    exit /b 1
)
::creating autorun.txt--------------------------------------------------------------------------------------------------------------
set AUTORUNTXT=autorun.txt
echo TempMode=Будет проведено программирование блока УБС\nпрограммым обеспечением ТЮКН.00114-05. Продолжить?,Программное обеспечение ТЮКН.00114-05 > %AUTORUNTXT%
echo Setup=burn.bat >> %AUTORUNTXT%
::----------------------------------------------------------------------------------------------------------------------------------


%WINRARDIST% a -sfx -zautorun.txt -m5 TUKN.00114-05_JTAG.exe @files.lst
::copy files-----------------------------------------------------------------------------------------------------------------------
xcopy /s/e/y/h %WORKSPACE%disk\bin %BINDESCT%
xcopy /s/e/y/h %WORKSPACE%disk\doc %BINDESCT%
xcopy /s/e/y/h %WORKSPACE%disk\pcwf %BINDESCT%
xcopy /s/e/y/h %WORKSPACE%disk\src %BINDESCT%
xcopy /s/e/y/h %WORKSPACE%disk %INFOTXTFILEDEST%
::----------------------------------------------------------------------------------------------------------------------------------
::create folders
::copy files













pause
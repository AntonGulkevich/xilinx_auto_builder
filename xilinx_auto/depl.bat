@echo off
goto start
————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
Deployment batch file
last changes 18.11.2015
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
::clear previous workspace----------------------------------------------------------------------------------------------------------
echo clear previous workspace
FOR /D %%p IN (%WORKSPACE%*.*) DO rmdir "%%p" /s /q
::create tcl file-------------------------------------------------------------------------------------------------------------------
echo sdk set_workspace %WORKSPACE% > %TCLFILE%
echo sdk create_hw_project -name %HWPNAME% -hwspec %HDFFILE% >> %TCLFILE%
echo sdk create_bsp_project -name %PROJECTNAME%_bsp -hwproject %HWPNAME% -proc ps7_cortexa9_0 -os standalone >> %TCLFILE%
echo sdk create_app_project -name %PROJECTNAME% -hwproject %HWPNAME% -bsp %PROJECTNAME%_bsp -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application}  >> %TCLFILE%
echo exit >> %TCLFILE%
::create tcl file-------------------------------------------------------------------------------------------------------------------

timeout /t 1 /nobreak > NUL

::execute tcl file------------------------------------------------------------------------------------------------------------------
echo execute tcl file %TCLFILE%
call %XSCTDEST% %TCLFILE%
::copy source files-----------------------------------------------------------------------------------------------------------------
xcopy /s/e/y/h "D:\ubs\Dev\lib\win32DLib\win32DLib\ucu_fw" "D:\ws\ucu_fw"
::build elf file--------------------------------------------------------------------------------------------------------------------
echo sdk set_workspace %WORKSPACE% > makeFile.tcl
echo sdk build_project  >> makeFile.tcl
echo exit >> makeFile.tcl
timeout /t 1 /nobreak > NUL
call %XSCTDEST% makeFile.tcl
::check file existance--------------------------------------------------------------------------------------------------------------
set "ELFFILE=%WORKSPACE%%PROJECTNAME%\Debug\%PROJECTNAME%.elf"
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

::placeholder to use *.elf file-----------------------------------------------------------------------------------------------------

echo %ELFFILE% is ready
pause
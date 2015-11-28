@echo off
goto start2
——————————————————————————————————————
Configuration file with local variables
last changes 23.11.2015 Gulkevich_A
——————————————————————————————————————
:start2
::workspace directory need for xilinx sdk 
::Warning 1: i am begging u to create and to set the workspace directory with no spaces
::in other case rewrite all paths in depl.bat with quters.
::despite this, it may not work even with this changes
::Warning 2: all paths with double slashes must be with double
set "WORKSPACE=ws"
::name of main project
set "PROJECTNAME=ucu_fw"
::destination of xilinx command line tool bat file xsct.bat
set "XSCTDEST=C:\Xilinx\SDK\2015.1\bin\xsct.bat"
::desination of hardware platform file *.hdf
set "HDFFILE=..\\..\\PLD\\ubs_ver2\\ubs_work_proj\\ubs_work.sdk\\ubs_design_wrapper.hdf"
::destination of loader.elf file
set "BOOTLOADER=..\bios\loader.elf"
::name of bit file needed for boot.bin compilation
set "UBSDESIGNWRAPPER=ubs_design_wrapper.bit"
::destination od xilinx bootgen.bat file
set "BOOTGENFILE=C:\Xilinx\SDK\2015.1\bin\bootgen.bat"
::destination of source files
set "CRCFILES=..\..\Soft\ucu_workspace\ucu_fw"
::destination of console firmware loader-------------------------------------------------
set "FWCLOADER=B:\build\Dev\scripts\xLxAbuilder\fw-l-c.exe"
::---------------------------------------------------------------------------------------
::destination of documents
::	doc
::		Инструкция по загрузке .docx
::		Лист утверждения ПO.docx
::		Лист утверждения ПO.docx
::		Спецификация.docx
::		Текст программ.docx
::		ТЗ тестовое Разбор и вывод данных записанных с приемника цифрового сигнала.docx
::		ТЗ убс ПЛИС.docx
set "DOCDEST=..\..\Documents"
::---------------------------------------------------------------------------------------
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
set "PCFWDEST=..\..\..\Archive\pcfw"
::---------------------------------------------------------------------------------------
set "INFOTXTFILEDEST="
::---------------------------------------------------------------------------------------
set "PLDDEST=..\..\PLD"
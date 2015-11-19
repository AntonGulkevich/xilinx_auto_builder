@echo off
goto start2
——————————————————————————————————————
Configuration file with local variables
last changes 18.11.2015
——————————————————————————————————————
:start2
::workspace directory need for xilinx sdk 
set "WORKSPACE=D:\ws\"
::name of main project
set "PROJECTNAME=ucu_fw"
::destination of xilinx command line tool bat file xsct.bat
set "XSCTDEST=D:\Xilinx\SDK\2015.1\bin\xsct.bat"
::desination of hardware platform file *.hdf
set "HDFFILE=D:\\x-ws\\ubs_work.sdk\\ubs_design_wrapper.hdf"
::destination of loader.elf file
set "BOOTLOADER=D:\scripts\loader.elf"
::name of bit file needed for boot.bin compilation
set "UBSDESIGNWRAPPER=ubs_design_wrapper.bit"
::destination od xilinx bootgen.bat file
set "BOOTGENFILE=D:\Xilinx\SDK\2015.1\bin\bootgen.bat"
::destination of source files
set "CRCFILES=D:\ubs\Dev\lib\win32DLib\win32DLib\ucu_fw"
::	bin
::		TUKN.00114-05_JTAG.exe
::			burn.bat
::			BOOT.bin
::		TUKN.00114-05_USB.exe
::			fw-c.exe
::			burn.bat
::			BOOT.bin
set "BINDESCT="
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
set "DOCDEST="
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
set "PCFWDEST="
::---------------------------------------------------------------------------------------
::	src
::		pld.exe
::		soft.exe
::			ucu_fw
::			ucu_fw_bsp
set "CRCDEST="
::---------------------------------------------------------------------------------------
set "INFOTXTFILEDEST="
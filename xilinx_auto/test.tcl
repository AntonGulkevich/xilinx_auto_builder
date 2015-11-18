#!/usr/bin/tclsh
sdk set_workspace /tmp/test1
sdk create_hw_project -name hw_0 -hwspec system.hdf 

sdk create_bsp_project -name bsp_0 -hwproject hw_0 -proc microblaze_0 -os standalone
sdk create_app_project -name helloworld -hwproject hw_0 -proc microblaze_0 -os standalone -lang C -app {Hello World} -bsp bsp_0
sdk build_project -type bsp bsp_0
sdk build_project -type app helloworld
sdk clean_project -type bsp bsp_0
sdk clean_project -type all
sdk build_project -type all
exit 

echo sdk build_project -type bsp %PROJECTNAME%_bsp >> %TCLFILE%
echo sdk build_project -type app %PROJECTNAME% >> %TCLFILE%
echo sdk clean_project -type bsp %PROJECTNAME%_bsp >> %TCLFILE%
echo sdk clean_project -type all >> %TCLFILE%
echo sdk build_project -type all >> %TCLFILE%
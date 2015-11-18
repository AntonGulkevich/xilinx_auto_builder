sdk set_workspace D:\ws\ 
sdk create_hw_project -name ubs_design_wrapper_hw_platform_0 -hwspec D:\\x-ws\\ubs_work.sdk\\ubs_design_wrapper.hdf 
sdk create_bsp_project -name ucu_fw_bsp -hwproject ubs_design_wrapper_hw_platform_0 -proc ps7_cortexa9_0 -os standalone 
sdk create_app_project -name ucu_fw -hwproject ubs_design_wrapper_hw_platform_0 -bsp ucu_fw_bsp -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application}  
exit 

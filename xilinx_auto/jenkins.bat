call %_TFS_UTILS%\tf eula /accept
set "WSDEST=gulltestws"
call %_TFS_UTILS%\tf workspace -delete %WSDEST%;office\swbuilder -noprompt -server:http://tfs:8080/tfs/Љ®­вга-Ќ€€ђ‘ /login:office\swbuilder,ZaQ1@wSx 
call %_TFS_UTILS%\tf workspace -new %WSDEST%;office\swbuilder -noprompt -server:http://tfs:8080/tfs/Љ®­вга-Ќ€€ђ‘ /login:office\swbuilder,ZaQ1@wSx 
call %_TFS_UTILS%\tf workspaces -noprompt -server:http://tfs:8080/tfs/Љ®­вга-Ќ€€ђ‘ /login:office\swbuilder,ZaQ1@wSx 
call %_TFS_UTILS%\tf workfold -map "$/A813-0409/TUKN00601/%TFS_BRANCH%" %CD% -workspace:%WSDEST% -server:http://tfs:8080/tfs/Љ®­вга-Ќ€€ђ‘ /login:office\swbuilder,ZaQ1@wSx 
call %_TFS_UTILS%\tf workspaces -noprompt -server:http://tfs:8080/tfs/Љ®­вга-Ќ€€ђ‘ /login:office\swbuilder,ZaQ1@wSx 
call %_TFS_UTILS%\tf get %CD% -recursive -version:T -noprompt /login:office\swbuilder,ZaQ1@wSx 

call scripts\path_%QUARTUS_VER%
call scripts\autobuilding scripts\path_%QUARTUS_PROGRAMMER_VER%
echo off
del systeminfo*.lst >nul 2>&1
setlocal enableextensions
setlocal enabledelayedexpansion
echo ======== EQUIPAMENTO ========
wmic csproduct get name|sfk filter -line=2 +tofile Modelo-Desktop_Antigo.var
set /p Modelo-Desktop_Antigo=<Modelo-Desktop_Antigo.var
echo Modelo......: %Modelo-Desktop_Antigo%
echo.
wmic csproduct get vendor|sfk filter -line=2 +tofile Fabricante-Desktop_Antigo.var
set /p Fabricante-Desktop_Antigo=<Fabricante-Desktop_Antigo.var
echo Fabricante..: %Fabricante-Desktop_Antigo%
echo.

echo ========== DESKTOP ==========
set /p Patrimonio-Desktop_Antigo="Digite o patrimonio...: "
echo !Patrimonio-Desktop_Antigo!>Patrimonio-Desktop_Antigo.var
echo Patrimonio..: !Patrimonio-Desktop_Antigo!
echo.

wmic BIOS GET SERIALNUMBER|sfk filter -line=2 -rep "_ __" +tofile Serial-Desktop_Antigo.var
set /p SerialDesktopAntigo=<Serial-Desktop_Antigo.var
echo Serial......: %SerialDesktopAntigo%
echo.

echo ========== MONITOR ==========
echo DIGITE
setlocal enabledelayedexpansion
:Leitura
set /p PatrimonioMonitor="Patrimonio..: "
set /a x=0
set TamPat=6
goto :TamanhoPat
:OKPATMON

echo %PatrimonioMonitor%>Patrimonio-Monitor_Antigo.var
echo.
set /p SerialMonitor="Serial......: "
echo %SerialMonitor%>Serial-Monitor_Antigo.var
echo.

echo ========== MONITOR 2 ==========
echo DIGITE
setlocal enabledelayedexpansion
:Leitura2
set /p PatrimonioMonitor2="Patrimonio..: "
set /a x=0
set TamPat=6
goto :TamanhoPat2
:OKPATMON2

echo %PatrimonioMonitor2%>Patrimonio-Monitor_Antigo2.var
echo.
set /p SerialMonitor2="Serial......: "
echo %SerialMonitor2%>Serial-Monitor_Antigo.var
echo.

echo ========== HOSTNAME ==========
echo %computername% > Hostname-Desktop-Antigo.var
echo Desktop.....: %computername% 
echo.

echo ==========    IP    ==========
sfk ip -first +tofile IP_Desktop_Antigo.var
set /p IP=<IP_Desktop_Antigo.var
echo IP..........: %IP%
echo.

echo ==========    MAC   ==========
getmac|sfk filter -line=4 +filt -sep " " -format "$col1" +tofile MAC_Desktop_Antigo.var
set /p MAC=<MAC_Desktop_Antigo.var
echo MAC.........: %MAC%
echo.

echo ====== COMPARTILHAMENTO ======
net share|findstr -v "^$ -- ^C\$ ^Comando ^Nome ^ADMIN\$ IPC\$"|sfk filter -no-empty-lines -replace "_     _ _" -rep "_Æ_ã_" -rep "_‡_ç_" -rep "_Ç_Ã_" -rep "_€_Ç_" +tofile Share-Desktop_Antigo.var
type Share-Desktop_Antigo.var
echo.

echo ========= IMPRESSORA =========
del Printer_Antigo.var >nul 2>&1
wmic PRINTER where (Name like "%%BELO%%" or Name like "%%BHE%%") GET Name, PortName|sfk filter -no-empty-lines -skipfirst=1 +tofile Printer_Antigo.var
type Printer_Antigo.var
echo.

echo ======== PROCESSADOR =========
wmic cpu get name|sfk filter -line=2 -rep "_(*)__" -rep "_@__" -rep "_CPU  __" +tofile Processador_Desktop_Antigo.var
set /p CPU=<Processador_Desktop_Antigo.var
echo CPU.........: %CPU%
echo.

echo ========== MEMORIA ===========
wmic memorychip get capacity|sfk filter -no-empty-lines +count  +calc "#text-1" +tofile Count.tmp
set /p CNT=<Count.tmp
wmic memorychip get capacity|sfk filter -no-empty-lines -line=2 +calc "#text/1024/1024/1024*%CNT%" -dig=0 +filt -format "$col1 GB" +tofile Memoria-Desktop_Antigo.var
set /p Memoria=<Memoria-Desktop_Antigo.var
echo Total.......: %Memoria%
echo.
wmic MEMORYCHIP get capacity|sfk filter -no-empty-lines +count  +calc "#text-1" +tofile Pentes.tmp
set /p NumPentes=<Pentes.tmp
echo %NumPentes% >Pentes-Desktop_Antigo.var
echo Pente(s)....: %NumPentes%
del Count.tmp >nul 2>&1
del Pentes.tmp >nul 2>&1
echo.

echo =========== DISCOS =========== 
echo ##### FAVOR DESCONECTAR HD EXTERNO #####
echo.
PAUSE
echo.
wmic diskdrive where ( InterfaceType="IDE" OR InterfaceType="SCSI" ) get InterfaceType|findstr /i "IDE SCSI" |sfk filter -no-empty-lines +count +tofile Num-Discos_Desktop_Antigo.var
set /P NUMDISK=<Num-Discos_Desktop_Antigo.var
echo Total.......: %NUMDISK%
echo.
del disk1.tmp >nul 2>&1
del disk2.tmp >nul 2>&1
wmic diskdrive where ( InterfaceType="IDE" OR InterfaceType="SCSI" ) get size|sfk filter -line=2 +calc "#text/1024/1024/1024" -dig=0 +tofile Disk1.tmp >nul 2>&1
wmic diskdrive where ( InterfaceType="IDE" OR InterfaceType="SCSI" ) get size|sfk filter -line=3 +calc "#text/1024/1024/1024" -dig=0 +tofile Disk2.tmp >nul 2>&1
set /p disk1=<Disk1.tmp
for /f %%i in ("Disk2.tmp") do set size=%%~zi
if !size! gtr 0 (
	set /p disk2=<Disk2.tmp
)
echo %disk1% %disk2%|sfk filter -rep "_  _ _" >Tamanho-Discos_Desktop_Antigo.var
set /p TAM=<Tamanho-Discos_Desktop_Antigo.var
echo Tamanho(s)..: %TAM% GB
echo.
del Disk?.tmp >nul 2>&1

echo ======== INFO SISTEMA ========
set /p Patrimonio=<Patrimonio-Desktop_Antigo.var
systeminfo /FO LIST>SystemInfo-%Patrimonio%.lst
echo. 

rem ############################################################
set /p Setor=<Setor.var 
echo Patrimonio; %Patrimonio-Desktop_Antigo%>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt
echo Modelo; %Modelo-Desktop_Antigo%>>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt
echo Serial; %SerialDesktopAntigo%>>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt
echo Fabricante; %Fabricante-Desktop_Antigo%>>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt
set /P ProcessadorDesktop=<Processador_Desktop_Antigo.var
echo Processador; %ProcessadorDesktop%>>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt
set /p MemoriaTotal=<Memoria-Desktop_Antigo.var
echo MemoriaTotal; %MemoriaTotal% >>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt 
set /p NumPentes=<Pentes-Desktop_Antigo.var
echo Qnt Pentes Memoria; %NumPentes%>>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt
set /p Discos=<Num-Discos_Desktop_Antigo.var
timeout /t 1 >nul
echo NumeroDiscos; %Discos% >>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt
set tmdisk1=""
set tmdisk2=""
sfk filter -line=1 Tamanho-Discos_Desktop_Antigo.var>tam1.tmp
sfk filter -line=2 Tamanho-Discos_Desktop_Antigo.var >tam2.tmp
set /p tmdsk1=<tam1.tmp
set /p tmdsk2=<tam2.tmp
echo Tamanho Discos; %tmdsk1%%tmdsk2%GB>>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt
wmic os get Caption,CSDVersion|sfk filter -line=2 +tofile SO-Desktop_Antigo.var
set /p SO=<SO-Desktop_Antigo.var
echo SistemaOperacional; %SO%>>LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt
copy LAUDO_Desktop-%Patrimonio-Desktop_Antigo%.txt LAUDO_Desktop.txt >nul 2>&1
del tam?.tmp>nul 2>&1

rem ############################################################
set /p Setor=<Setor.var
echo Patrimonio; %Patrimonio-Desktop_Antigo%>RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt
echo Serial; %SerialDesktopAntigo%>>RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt
set /p IP=<IP_Desktop_Antigo.var
echo IP; %IP%>>RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt
echo PatMONITOR; %PatrimonioMonitor%>>RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt
echo SerialMONITOR; %SerialMonitor%>>RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt
echo PatMONITOR2; %PatrimonioMonitor2%>>RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt
echo SerialMONITOR2; %SerialMonitor2%>>RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt
type Share-Desktop_Antigo.var>>RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt
type Printer_Antigo.var>>RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt
copy RAT_Desktop-%Patrimonio-Desktop_Antigo%.txt RAT_Desktop.txt >nul 2>&1

echo LAUDO > LAUDO-RAT.txt
type LAUDO_Desktop.txt >> LAUDO-RAT.txt
echo. >> LAUDO-RAT.txt
echo --------------------------------------------------------------- >> LAUDO-RAT.txt
echo RAT >> LAUDO-RAT.txt
type RAT_Desktop.txt >> LAUDO-RAT.txt

chcp 850 >nul
echo.>Script03.ok
pause
EXIT /B


:Verifica
if not "%1" == "%2" (
	echo Tamanho de %2 Digitos
	goto :Leitura
) else goto :OKPATMON

:Verifica2
if not "%1" == "%2" (
	echo Tamanho de %2 Digitos
	goto :Leitura2
) else goto :OKPATMON2


:TamanhoPat
if /I "!PatrimonioMonitor!" == "S/P" goto :OKPATMON
if not "!PatrimonioMonitor:~%x%,1!" == "" set /a x+=1 & goto TamanhoPat
call :Verifica %x% %TamPat%

:TamanhoPat2
if /I "!PatrimonioMonitor2!" == "S/P" goto :OKPATMON2
if not "!PatrimonioMonitor2:~%x%,1!" == "" set /a x+=1 & goto TamanhoPat2
call :Verifica2 %x% %TamPat%
setlocal enableextensions
setlocal enabledelayedexpansion
@echo off
chcp 65001
cls              
echo ########## Modelo ##############>LAUDO_RAT.txt
wmic csproduct get version|sfk filter -line=2 +tofile Modelo-Desktop_Antigo.var
set /p Modelo-Desktop_Antigo=<Modelo-Desktop_Antigo.var
echo Modelo; !Modelo-Desktop_Antigo!>>LAUDO_RAT.txt
echo.>>LAUDO_RAT.txt

echo ########## Fabricante ##########>>LAUDO_RAT.txt
wmic csproduct get vendor|sfk filter -line=2 +tofile Fabricante-Desktop_Antigo.var
set /p Fabricante-Desktop_Antigo=<Fabricante-Desktop_Antigo.var
echo Fabricante; !Fabricante-Desktop_Antigo!>>LAUDO_RAT.txt
echo.>>LAUDO_RAT.txt

echo ##########OS##########>>LAUDO_RAT.txt
WMIC os get Caption|sfk filter -line=2 +tofile OS.var
set /p OS=<OS.var
echo SISTEMA OPERACIONAL; !OS!>>LAUDO_RAT.txt
echo.>>LAUDO_RAT.txt

echo ########## Serial ##############>>LAUDO_RAT.txt
wmic BIOS GET SERIALNUMBER|sfk filter -line=2 -rep "_ __" +tofile Serial-Desktop_Antigo.var
set /p SerialDesktopAntigo=<Serial-Desktop_Antigo.var
echo SERIAL; !SerialDesktopAntigo!>>LAUDO_RAT.txt
echo.>>LAUDO_RAT.txt

echo ########## IP ##################>>LAUDO_RAT.txt
sfk ip -first +tofile IP_Desktop_Antigo.var
set /p IP=<IP_Desktop_Antigo.var
echo IP; !IP!>>LAUDO_RAT.txt
echo.>>LAUDO_RAT.txt

echo ##########MAC#################>>LAUDO_RAT.txt
getmac|sfk filter -line=4 +filt -sep " " -format "$col1" +tofile MAC_Desktop_Antigo.var
set /p MAC=<MAC_Desktop_Antigo.var
echo MAC; !MAC!>>LAUDO_RAT.txt
echo.>>LAUDO_RAT.txt

echo ########## Processador #########>>LAUDO_RAT.txt
wmic cpu get name|sfk filter -line=2 -rep "_(*)__" -rep "_@__" -rep "_CPU  __" +tofile Processador_Desktop_Antigo.var
set /p CPU=<Processador_Desktop_Antigo.var
echo PROCESSADOR; !CPU!>>LAUDO_RAT.txt
echo.>>LAUDO_RAT.txt

echo ########## Memoria #############>>LAUDO_RAT.txt
wmic memorychip get capacity|sfk filter -no-empty-lines +count  +calc "#text-1" +tofile Count.tmp
set /p CNT=<Count.tmp
wmic memorychip get capacity|sfk filter -no-empty-lines -line=2 +calc "#text/1024/1024/1024*%CNT%" -dig=0 +filt -format "$col1 GB" +tofile Memoria-Desktop_Antigo.var
set /p Memoria=<Memoria-Desktop_Antigo.var
echo Quantidade Memoria; !Memoria!>>LAUDO_RAT.txt
wmic MEMORYCHIP get capacity|sfk filter -no-empty-lines +count  +calc "#text-1" +tofile Pentes.tmp
set /p NumPentes=<Pentes.tmp
echo Num de Pentes; !NumPentes!>>LAUDO_RAT.txt
del Count.tmp >nul 2>&1
del Pentes.tmp >nul 2>&1
echo.>>LAUDO_RAT.txt

echo ########## DISCOS ##########>>LAUDO_RAT.txt
echo ====== FAVOR DESCONECTAR HD EXTERNO ======
echo.
PAUSE
echo.
wmic diskdrive where ( InterfaceType="IDE" OR InterfaceType="SCSI" ) get InterfaceType|findstr /i "IDE SCSI" |sfk filter -no-empty-lines +count +tofile Num-Discos_Desktop_Antigo.var
set /P NUMDISK=<Num-Discos_Desktop_Antigo.var
echo Num de Unidades de disco; !NUMDISK!>>LAUDO_RAT.txt
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
echo Tamanho(s) do disco; %TAM% GB>>LAUDO_RAT.txt
echo.
del Disk?.tmp >nul 2>&1

echo.>>LAUDO_RAT.txt
echo ##########Deletando VAr#######
del Tamanho-Discos_Desktop_Antigo.var
del Num-Discos_Desktop_Antigo.var
del Modelo-Desktop_Antigo.var
del Fabricante-Desktop_Antigo.var
del Serial-Desktop_Antigo.var
del IP_Desktop_Antigo.var
del MAC_Desktop_Antigo.var
del Processador_Desktop_Antigo.var
del Memoria-Desktop_Antigo.var
del OS.var
echo.
echo ╔═╗╔═╗╦  ╔═╗╔╦╗╔═╗╔╗╔╔╦╗╔═╗  ╦╔╗╔╔═╗╔═╗╦═╗╔╦╗╔═╗╔═╗╔═╗╔═╗╔═╗
echo ║  ║ ║║  ║╣  ║ ╠═╣║║║ ║║║ ║  ║║║║╠╣ ║ ║╠╦╝║║║╠═╣║  ║ ║║╣ ╚═╗
echo ╚═╝╚═╝╩═╝╚═╝ ╩ ╩ ╩╝╚╝═╩╝╚═╝  ╩╝╚╝╚  ╚═╝╩╚═╩ ╩╩ ╩╚═╝╚═╝╚═╝╚═╝
echo.
echo  ┬┌─┐┌─┐┌─┐  ┬  ┬┬┌┬┐┌─┐┬─┐  ┬─┐┌─┐┌─┐┬ ┬┌─┐
echo  ││ │├─┤│ │  └┐┌┘│ │ │ │├┬┘  ├┬┘│ ││  ├─┤├─┤
echo └┘└─┘┴ ┴└─┘   └┘ ┴ ┴ └─┘┴└─  ┴└─└─┘└─┘┴ ┴┴ ┴
pause
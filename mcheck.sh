#!/bin/sh
# shellcheck disable=1003,1091,2006,2016,2034,2039
# vim: set ts=2 sw=2 sts=2 et:
echo  ""
echo "Aspectos do SO"
echo  ""
echo "1. Qual a versão do SO? É Debian, Ubuntu, CentOS, BSD?"
echo  ""
cat /etc/issue 2>/dev/null
cat /etc/os-release 2>/dev/null
cat /etc/lsb-release 2>/dev/null
cat /etc/lredhat-release 2>/dev/null		
echo  ""
echo "2. Qual a versão do kernel?"
echo  ""
uname -a 2>/dev/null
echo  ""
echo "3. Quais os processos que estão executando com permissão de root?"
echo  ""
ps -aux | grep root 2>/dev/null
echo  ""
echo "4. Quais servicos de rede estão rodando no SO?"
echo  ""
netstat -tunap 2>/dev/null
ss -tunap 2>/dev/null
echo  ""
echo "5. Enumerar tarefas agendadas "
echo  ""
ls -lahR /var/spool/cron 2>/dev/null
cat /etc/cron* 2>/dev/null
atq 2>/dev/null
cat /etc/at.allow 2>/dev/null
cat /etc/at.deny 2>/dev/null
cat /etc/anacron 2>/dev/null
echo  ""
echo "Aspectos do usuário "
echo  ""
echo "1. Qual o ID do usuário e de quais grupos ele faz parte?"
echo  ""
id
echo  ""
echo "2 Em quais diretórios tenho permissão de escrita? "
echo  ""
find / -type d -writable 2>/dev/null
echo  ""
echo "2.1 Em quais arquivos em /etc tenho permissão de escrita? "
echo  ""
find /etc/ -maxdepth 1 -perm /002 2>/dev/null
echo  ""
echo "3. Posso utilizar o sudo para alguma atividade privilegiada? "
echo "Será solicidata a senha sua senha, se não souber pressione enter nas três vezes solicitadas"
echo  ""
sudo -l 2>/dev/null
echo  ""
echo "4. Tenho algum histórico de comandos anteriores? Talvez alguma senha nesse histórico?"
echo  ""
cat ~/.bash_history 2>/dev/null
cat ~/.mysql_history 2>/dev/null
echo  ""
echo "5. O usuário é utilizado para executar algum servico de rede? "
MYSQL_RELEVANT_NAMES="mysql"
APACHE_RELEVANT_NAMES="sites-enabled 000-default"
PHP_RELEVANT_NAMES="sess_* config.php database.php db.php storage.php"
WORDPRESS_RELEVANT_NAMES="wp-config.php"
DRUPAL_RELEVANT_NAMES="settings.php"
SSH_RELEVANT_NAMES="id_dsa* id_rsa* known_hosts authorized_hosts authorized_keys .pem *.cer *.crt *.csr *.der *.pfx *.p12 agent config vault-ssh-helper.hcl .vault-token"
echo  ""
prep_to_find() {
echo "$1" | sed 's/ /" -o -name "/g' | sed 's/^/\\( -name "/g' | sed 's/$/" \\)/g'
}

echo_not_found (){
  printf $DG"$1 Not Found\n"$NC
}
echo_no (){
  printf $DG"No\n"$NC
}
print_ps (){
  (ls -d /proc/*/ 2>/dev/null | while read f; do 
    CMDLINE=`cat $f/cmdline 2>/dev/null | grep -av "seds,"`; #Delete my own sed processess
    if [ "$CMDLINE" ]; 
      then USER2=ls -ld $f | awk '{print $3}'; PID=`echo $f | cut -d "/" -f3`; 
      printf "  %-13s  %-8s  %s\n" "$USER2" "$PID" "$CMDLINE"; 
    fi; 
  done) 2>/dev/null | sort -r
}

FIND_SSH_RELEVANT_NAMES=$(prep_to_find "$SSH_RELEVANT_NAMES")
FIND_MYSQL_RELEVANT_NAMES=$(prep_to_find "$MYSQL_RELEVANT_NAMES")
FIND_APACHE_RELEVANT_NAMES=$(prep_to_find "$APACHE_RELEVANT_NAMES")
FIND_PHP_RELEVANT_NAMES=$(prep_to_find "$PHP_RELEVANT_NAMES")
FIND_WORDPRESS_RELEVANT_NAMES=$(prep_to_find "$WORDPRESS_RELEVANT_NAMES")
FIND_DRUPAL_RELEVANT_NAMES=$(prep_to_find "$DRUPAL_RELEVANT_NAMES")

# Directories
FIND_DIR_VAR=$(eval find /var -type d $FIND_MYSQL_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_DIR_VAR" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

FIND_DIR_ETC=$(eval find /etc -type d $FIND_MYSQL_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_DIR_ETC" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

FIND_DIR_HOME=$(eval find /home -type d $FIND_MYSQL_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_DIR_HOME" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

FIND_DIR_TMP=$(eval find /tmp -type d $FIND_MYSQL_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_DIR_TMP" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

 FIND_DIR_USR=$(eval find /usr -type d $FIND_MYSQL_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_DIR_USR" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

 FIND_DIR_OPT=$(eval find /opt -type d $FIND_MYSQL_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_DIR_OPT" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

FIND_VAR=$(eval find /var/ $FIND_APACHE_RELEVANT_NAMES -o $FIND_PHP_RELEVANT_NAMES -o $FIND_WORDPRESS_RELEVANT_NAMES -o $FIND_DRUPAL_RELEVANT_NAMES -o $FIND_SSH_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_VAR" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

FIND_ETC=$(eval find /etc/ $FIND_APACHE_RELEVANT_NAMES -o $FIND_PHP_RELEVANT_NAMES -o $FIND_WORDPRESS_RELEVANT_NAMES -o $FIND_DRUPAL_RELEVANT_NAMES -o $FIND_SSH_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_ETC" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

FIND_HOME=$(eval find /home/ $FIND_APACHE_RELEVANT_NAMES -o $FIND_PHP_RELEVANT_NAMES -o $FIND_WORDPRESS_RELEVANT_NAMES -o $FIND_DRUPAL_RELEVANT_NAMES -o $FIND_SSH_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_HOME" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

FIND_TMP=$(eval find /tmp/ $FIND_APACHE_RELEVANT_NAMES -o $FIND_PHP_RELEVANT_NAMES -o $FIND_WORDPRESS_RELEVANT_NAMES -o $FIND_DRUPAL_RELEVANT_NAMES -o $FIND_SSH_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_TMP" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi
 
FIND_MNT=$(eval find /mnt/ $FIND_APACHE_RELEVANT_NAMES -o $FIND_PHP_RELEVANT_NAMES -o $FIND_WORDPRESS_RELEVANT_NAMES -o $FIND_DRUPAL_RELEVANT_NAMES -o $FIND_SSH_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_MNT" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi

 FIND_USR=$(eval find /usr/ $FIND_APACHE_RELEVANT_NAMES -o $FIND_PHP_RELEVANT_NAMES -o $FIND_WORDPRESS_RELEVANT_NAMES -o $FIND_DRUPAL_RELEVANT_NAMES -o $FIND_SSH_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_USR" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi
 
 FIND_OPT=$(eval find /opt/ $FIND_APACHE_RELEVANT_NAMES -o $FIND_PHP_RELEVANT_NAMES -o $FIND_WORDPRESS_RELEVANT_NAMES -o $FIND_DRUPAL_RELEVANT_NAMES -o $FIND_SSH_RELEVANT_NAMES 2>/dev/null | sort)
if [ "$FIND_OPT" ]; then printf $RED". "$NC; else printf $GREEN". "$NC; fi


printf $Y"[+] "$GREEN"MySQL version\n"$NC
mysql --version 2>/dev/null || echo_not_found "mysql"
echo ""

#-- SI) Mysql connection root/root
printf $Y"[+] "$GREEN"MySQL connection using default root/root ........... "$NC
mysqlconnect=`mysqladmin -uroot -proot version 2>/dev/null`
if [ "$mysqlconnect" ]; then
echo "Yes" | sed -E "s,.*,${C}[1;31m&${C}[0m,"
mysql -u root --password=root -e "SELECT User,Host,authentication_string FROM mysql.user;" 2>/dev/null | sed -E "s,.*,${C}[1;31m&${C}[0m,"
else echo_no
fi

#-- SI) Mysql connection root/toor
printf $Y"[+] "$GREEN"MySQL connection using root/toor ................... "$NC
mysqlconnect=`mysqladmin -uroot -ptoor version 2>/dev/null`
if [ "$mysqlconnect" ]; then
echo "Yes" | sed -E "s,.*,${C}[1;31m&${C}[0m,"
mysql -u root --password=toor -e "SELECT User,Host,authentication_string FROM mysql.user;" 2>/dev/null | sed -E "s,.*,${C}[1;31m&${C}[0m,"
else echo_no
fi

#-- SI) Mysql connection root/NOPASS
mysqlconnectnopass=`mysqladmin -uroot version 2>/dev/null`
printf $Y"[+] "$GREEN"MySQL connection using root/NOPASS ................. "$NC
if [ "$mysqlconnectnopass" ]; then
echo "Yes" | sed -E "s,.*,${C}[1;31m&${C}[0m,"
mysql -u root -e "SELECT User,Host,authentication_string FROM mysql.user;" 2>/dev/null | sed -E "s,.*,${C}[1;31m&${C}[0m,"
else echo_no
fi


sh_usrs=`cat /etc/passwd 2>/dev/null | grep -v "^root:" | grep -i "sh$" | cut -d ":" -f 1 | tr '\n' '|' | sed 's/|bin|/|bin[\\\s:]|^bin$|/' | sed 's/|sys|/|sys[\\\s:]|^sys$|/' | sed 's/|daemon|/|daemon[\\\s:]|^daemon$|/'`"ImPoSSssSiBlEee" #Modified bin, sys and daemon so they are not colored everywhere
nosh_usrs=`cat /etc/passwd 2>/dev/null | grep -i -v "sh$" | sort | cut -d ":" -f 1 | tr '\n' '|' | sed 's/|bin|/|bin[\\\s:]|^bin$|/'`"ImPoSSssSiBlEee"
knw_usrs='daemon\W|^daemon$|message\+|syslog|www|www-data|mail|noboby|Debian\-\+|rtkit|systemd\+'
USER=`whoami`


#-- SI) Mysql credentials
printf $Y"[+] "$GREEN"Searching mysql credentials and exec\n"$NC
mysqldirs=$(echo "$FIND_DIR_ETC $FIND_DIR_USR $FIND_DIR_VAR" | grep -E '^/etc/.*mysql|/usr/var/lib/.*mysql|/var/lib/.*mysql' | grep -v "mysql/mysql")
if [ "$mysqldirs" ]; then
printf "$mysqldirs\n" | while read d; do 
for f in `find $d -name debian.cnf 2>/dev/null`; do
if [ -r $f ]; then 
echo "We can read the mysql debian.cnf. You can use this username/password to log in MySQL" | sed -E "s,.*,${C}[1;31m&${C}[0m,"
cat "$f"
fi
done
for f in `find $d -name user.MYD 2>/dev/null`; do
if [ -r "$f" ]; then 
echo "We can read the Mysql Hashes from $f" | sed -E "s,.*,${C}[1;31m&${C}[0m,"
grep -oaE "[-_\.\*a-Z0-9]{3,}" $f | grep -v "mysql_native_password" 
fi
done
for f in `grep -lr "user\s*=" $d 2>/dev/null | grep -v "debian.cnf"`; do
if [ -r "$f" ]; then
u=`cat "$f" | grep -v "#" | grep "user" | grep "=" 2>/dev/null`
echo "From '$f' Mysql user: $u" | sed -E "s,$sh_usrs,${C}[1;96m&${C}[0m," | sed -E "s,$nosh_usrs,${C}[1;34m&${C}[0m," | sed -E "s,$knw_usrs,${C}[1;32m&${C}[0m," | sed "s,$USER,${C}[1;95m&${C}[0m," | sed "s,root,${C}[1;31m&${C}[0m,"
fi
done
for f in `find $d -name my.cnf 2>/dev/null`; do
if [ -r "$f" ]; then 
echo "Found readable $f"
cat "$f" | grep -v "^#" | grep -Ev "\W+\#|^#" 2>/dev/null | grep -v "^$" | sed "s,password.*,${C}[1;31m&${C}[0m,"
fi
done
mysqlexec=`whereis lib_mysqludf_sys.so 2>/dev/null | grep "lib_mysqludf_sys\.so"`
if [ "$mysqlexec" ]; then 
echo "Found $mysqlexec"
echo "If you can login in MySQL you can execute commands doing: SELECT sys_eval('id');" | sed -E "s,.*,${C}[1;31m&${C}[0m,"
fi
done
else echo_not_found
fi
echo ""

#-- SI) Apache info
printf $Y"[+] "$GREEN"Apache server info\n"$NC
apachever=`apache2 -v 2>/dev/null; httpd -v 2>/dev/null`
if [ "$apachever" ]; then
echo "Version: $apachever"
sitesenabled=$(echo "FIND_VAR $FIND_ETC $FIND_HOME $FIND_TMP $FIND_USR $FIND_OPT" | grep "sites-enabled")
printf "$sitesenabled\n" | while read d; do for f in "$d/*"; do grep "AuthType\|AuthName\|AuthUserFile\|ServerName\|ServerAlias" $f 2>/dev/null | grep -v "#" | sed "s,Auth|ServerName|ServerAlias,${C}[1;31m&${C}[0m,"; done; done
if [ !"$sitesenabled" ]; then
default00=$(echo "$FIND_VAR $FIND_ETC $FIND_HOME $FIND_TMP $FIND_USR $FIND_OPT" | grep "000-default")
printf "$default00\n" | while read f; do grep "AuthType\|AuthName\|AuthUserFile\|ServerName\|ServerAlias" "$f" 2>/dev/null | grep -v "#" | sed -E "s,Auth|ServerName|ServerAlias,${C}[1;31m&${C}[0m,"; done
fi
echo "PHP exec extensions"
grep -R -B1 "httpd-php" /etc/apache2 2>/dev/null
else echo_not_found
fi
echo ""

#-- SI) PHP cookies files
phpsess1=`ls /var/lib/php/sessions 2>/dev/null`
phpsess2=$(echo "$FIND_TMP $FIND_VAR" | grep -E '/tmp/.sess_.|/var/tmp/.sess_.')
printf $Y"[+] "$GREEN"Searching PHPCookies\n"$NC
if [ "$phpsess1" ] || [ "$phpsess2" ]; then
if [ "$phpsess1" ]; then ls /var/lib/php/sessions 2>/dev/null; fi
if [ "$phpsess2" ]; then $(echo "$FIND_TMP $FIND_VAR" | grep -E '/tmp/.sess_.|/var/tmp/.sess_.'); fi
else echo_not_found
fi
echo ""

#-- SI) Wordpress user, password, databname and host
printf $Y"[+] "$GREEN"Searching Wordpress wp-config.php files\n"$NC
wp=$(echo "$FIND_VAR $FIND_ETC $FIND_HOME $FIND_TMP $FIND_USR $FIND_OPT" | grep -E 'wp-config\.php$')
if [ "$wp" ]; then
echo "wp-config.php files found:\n$wp"
prtinf "$wp\n" | while read f; do grep "PASSWORD\|USER\|NAME\|HOST" "$f" 2>/dev/null | sed -E "s,.*,${C}[1;31m&${C}[0m,"; done
else echo_not_found "wp-config.php"
fi
echo ""


#-- SI) Drupal user, password, databname and host
printf $Y"[+] "$GREEN"Searching Drupal settings.php files\n"$NC
drup=$(echo "$FIND_VAR $FIND_ETC $FIND_HOME $FIND_TMP $FIND_USR $FIND_OPT" | grep -E 'settings\.php$')
if [ "`echo $drup | grep '/default/settings.php'`" ]; then #Check path /default/settings.php
echo "settings.php files found:\n$drup"
printf "$drup\n" | while read f; do grep "drupal_hash_salt\|'database'\|'username'\|'password'\|'host'\|'port'\|'driver'\|'prefix'" $f 2>/dev/null | sed -E "s,.*,${C}[1;31m&${C}[0m,"; done
else echo_not_found "/default/settings.php"
fi
echo ""

echo "6. No home do usuário existe alguma chave SSH? "

#-- SI) ssh files
printf $Y"[+] "$GREEN"Searching ssl/ssh files\n"$NC
ssh=$(echo "$FIND_VAR $FIND_ETC $FIND_HOME $FIND_MNT $FIND_USR $FIND_OPT" | egrep -E 'id_dsa.|id_rsa.|known_hosts|authorized_hosts|authorized_keys')
certsb4=$(echo "$FIND_VAR $FIND_ETC $FIND_HOME $FIND_MNT $FIND_USR $FIND_OPT" | grep -E '.\.pem|.\.cer|.\.crt' | grep -E -v '^/usr/share/.' | grep -E -v '^/etc/ssl/.' | grep -E -v '^/usr/local/lib/.' | grep -E -v '^/usr/lib.*')
if [ "$certsb4" ]; then certsb4_grep=`grep -L "\"\|'\|(" $certsb4 2>/dev/null`; fi
certsbin=$(echo "$FIND_VAR $FIND_ETC $FIND_HOME $FIND_MNT $FIND_USR $FIND_OPT" | grep -E '.\.csr|.\.der' | grep -E -v '^/usr/share/.' | grep -E -v '^/etc/ssl/.' | grep -E -v '^/usr/local/lib/.' | grep -E -v '^/usr/lib/.')
clientcert=$(echo "$FIND_VAR $FIND_ETC $FIND_HOME $FIND_MNT $FIND_USR $FIND_OPT" | grep -E '.\.pfx|.\.p12' | grep -E -v '^/usr/share/.' | grep -E -v '^/etc/ssl/.' | grep -E -v '^/usr/local/lib/.' | grep -E -v '^/usr/lib/.')
sshagents=$(echo "$FIND_TMP" | grep -E 'agent.*')
homesshconfig=$(echo "$FIND_HOME" | grep -E 'config' | grep "ssh")
sshconfig="`ls /etc/ssh/ssh_config 2>/dev/null`"
hostsdenied="`ls /etc/hosts.denied 2>/dev/null`"
hostsallow="`ls /etc/hosts.allow 2>/dev/null`"

printf "$ssh\n"
printf "$certsb4\n"
printf "$certsbin\n"
printf "$clientcert\n"
printf "$sshagents\n"
printf "$homesshconfig\n"
printf "$sshconfig\n"
printf "$hostsdenied\n"
printf "$hostsallow\n"

echo "7. Quais arquivos com SETGID que tenho acesso? "
echo  ""
find / -perm /2000 2>/dev/null
echo  ""

echo "8. Quais arquivos com SETUID que tenho acesso? "
echo  ""
find / -perm /4000 2>/dev/null
echo  ""

echo "9. Existe algum binário no sistema com capabilities habilitado?"
echo  ""
/sbin/getcap -r / 2>/dev/null
echo  ""

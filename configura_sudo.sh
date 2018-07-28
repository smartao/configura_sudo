#!/bin/bash

# Usuarios que serao criados configurados
user[1]=users1
#user[2]=user2

# Grupo de administracao configurado no sudoers
grupo=administrator

echo -e "\n#------- Script deve ser executa como root ------#"
echo -e "#-- Especifico para distribuicao Debian/Ubuntu --# "
echo -e "\n# 1 - Instalado Sudo"
apt-get install sudo -y > /dev/null 2>&1
dpkg -l sudo | grep -i sudo | tr -s ' ' 

echo -e "\n# 2 - Configurando sudoes "
grep -i ADMIN_CMDS /etc/sudoers
if [ $? -eq 1 ];then
	echo "# Cmnd alias specification" >> /etc/sudoers
	echo "Cmnd_Alias ADMIN_CMDS = /usr/bin/passwd, /usr/sbin/passwd, /usr/sbin/useradd, /usr/sbin/userdel, /usr/sbin/usermod, /usr/sbin/visudo" >> /etc/sudoers
	echo "%$grupo ALL= ALL, !ADMIN_CMDS" >> /etc/sudoers
	grep -i ADMIN_CMDS /etc/sudoers
fi

echo -e "\n# 3 - Criando grupo $grupo"
grep -i $grupo /etc/group
if [ $? -eq 1 ];then
	addgroup $grupo
	grep -i $grupo /etc/group
fi

echo -e "\n# 4 - Criando usuários e adicionando grupo"
for ((i=1; i<=${#user[@]}; i++))
do
	grep -i ${user[$i]} /etc/passwd
	if [ $? -eq 1 ];then
		echo -e "\n# 4.$i - Criando usuarios ${user[$i]}\n "
		adduser ${user[$i]}	
		grep -i ${user[$i]} /etc/passwd
	fi
	echo -e "\n# 4.$i.$i - Adicionando ao grupo $grupo" 
	addgroup ${user[$i]} $grupo
done
echo ""

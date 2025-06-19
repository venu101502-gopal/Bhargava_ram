
##### adding .ssh Keys to sgsg user


adduser --disabled-password --gecos "" sgsg
mkdir -p /home/sgsg/.ssh
touch /home/sgsg/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/sgsg/sgsg.txt >> /home/sgsg/.ssh/authorized_keys
chown -R sgsg /home/sgsg/.ssh
chmod 700 /home/sgsg/.ssh
chmod 600 /home/sgsg/.ssh/authorized_keys

##### adding .ssh Keys to yugikr user

adduser --disabled-password --gecos "" yugikr
mkdir -p /home/yugikr/.ssh
touch /home/yugikr/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/yugikr/yugikr.txt >> /home/yugikr/.ssh/authorized_keys
chown -R yugikr:yugikr /home/yugikr/.ssh
chmod 700 /home/yugikr/.ssh
chmod 600 /home/yugikr/.ssh/authorized_keys


##### adding .ssh Keys to ssftprod095 user

adduser --disabled-password --gecos "" ssftprod095
mkdir -p /home/ssftprod095/.ssh
touch /home/ssftprod095/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/ssftprod095/ssftprod095.txt >> /home/ssftprod095/.ssh/authorized_keys
chown -R ssftprod095:ssftprod095 /home/ssftprod095/.ssh
chmod 700 /home/ssftprod095/.ssh
chmod 600 /home/ssftprod095/.ssh/authorized_keys



##### adding .ssh Keys to ssftprod096 user


adduser --disabled-password --gecos "" ssftprod096
mkdir -p /home/ssftprod096/.ssh
touch /home/ssftprod096/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/ssftprod096/ssftprod096.txt >> /home/ssftprod096/.ssh/authorized_keys
chown -R ssftprod096:ssftprod096 /home/ssftprod096/.ssh
chmod 700 /home/ssftprod096/.ssh
chmod 600 /home/ssftprod096/.ssh/authorized_keys


##### adding .ssh Keys to ssftprod097 user

adduser --disabled-password --gecos "" ssftprod097
mkdir -p /home/ssftprod097/.ssh
touch /home/ssftprod097/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/ssftprod097/ssftprod097.txt >> /home/ssftprod097/.ssh/authorized_keys
chown -R ssftprod097:ssftprod097 /home/ssftprod097/.ssh
chmod 700 /home/ssftprod097/.ssh
chmod 600 /home/ssftprod097/.ssh/authorized_keys


##### adding .ssh Keys to ssftprod098 user

adduser --disabled-password --gecos "" ssftprod098
mkdir -p /home/ssftprod098/.ssh
touch /home/ssftprod098/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/ssftprod098/ssftprod098.txt >> /home/ssftprod098/.ssh/authorized_keys
chown -R ssftprod098:ssftprod098 /home/ssftprod098/.ssh
chmod 700 /home/ssftprod098/.ssh


##### adding .ssh Keys to ssftprod099 user

adduser --disabled-password --gecos "" ssftprod099
mkdir -p /home/ssftprod099/.ssh
touch /home/ssftprod099/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/ssftprod099/ssftprod099.txt >> /home/ssftprod099/.ssh/authorized_keys
chown -R ssftprod099:ssftprod099 /home/ssftprod099/.ssh
chmod 700 /home/ssftprod099/.ssh
chmod 600 /home/ssftprod099/.ssh/authorized_keys

##### adding .ssh Keys to kvramreddy user

adduser --disabled-password --gecos "" kvrreddy
mkdir -p /home/kvrreddy/.ssh
touch /home/kvrreddy/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/kvrreddy/kvrreddy.txt >> /home/kvrreddy/.ssh/authorized_keys
chown -R kvrreddy:kvrreddy /home/kvrreddy/.ssh
chmod 700 /home/kvrreddy/.ssh
chmod 600 /home/kvrreddy/.ssh/authorized_keys


##### adding .ssh Keys to sutiansi user

adduser --disabled-password --gecos "" sutiansi
mkdir -p /home/sutiansi/.ssh
touch /home/sutiansi/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/sutiansi/sutiansi.txt >> /home/sutiansi/.ssh/authorized_keys
chown -R sutiansi.sutiansi /home/sutiansi/.ssh
chmod 700 /home/sutiansi/.ssh
chmod 600 /home/sutiansi/.ssh/authorized_keys

########### adding .ssh Keys to sutidevops user

adduser --disabled-password --gecos "" sutidevops
mkdir -p /home/sutidevops/.ssh
touch /home/sutidevops/.ssh/authorized_keys
cat /opt/UserCreationScript_2023_Ubuntu/sutidevops/sutidevops.txt >> /home/sutidevops/.ssh/authorized_keys
chown -R sutidevops.sutidevops /home/sutidevops/.ssh
chmod 700 /home/sutidevops/.ssh
chmod 600 /home/sutidevops/.ssh/authorized_keys

############# Adding Users to Wheel group #########

#usermod  -aG wheel sgsg
#usermod  -aG wheel yugikr
#usermod -aG wheel ssftprod095
#usermod -aG wheel ssftprod096
#usermod -aG wheel ssftprod097
#usermod -aG wheel ssftprod098
#usermod -aG wheel ssftprod099
#usermod -aG wheel sutiansi
################## Adding Users to /etc/sudoers file #############


cat /opt/UserCreationScript_2023_Ubuntu/visudo_edit.txt >> /etc/sudoers


####################################################################

#####Mail Notification#######################

touch /etc/ssh/sshrc

cat /opt/UserCreationScript_2023_Ubuntu/mailnotify.txt >> /etc/ssh/sshrc

read -p "Enter Site name : " sitename

sed -i "s|AWS_SutiTravel|$sitename|" /etc/ssh/sshrc

##################### END #############################################

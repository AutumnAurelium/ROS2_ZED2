useradd user
usermod --shell /bin/bash user
mkdir /home/user
chown -R user /home/user
echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

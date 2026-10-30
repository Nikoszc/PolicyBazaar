useradd -m -d /home/User -s /bin/bash User
 
Then, copy the contents of the user’s public key into
mkdir /home/User/.ssh
vim /home/User/.ssh/authorized_keys

# ensure the directory is owned by the new user
chown -R User:User /home/User/.ssh
 
# Make sure only the new user has permissions
chmod 700 /home/User/.ssh
chmod 600 /home/User/.ssh/authorized_keys

#Add user to sudo group
usermod -aG sudo User

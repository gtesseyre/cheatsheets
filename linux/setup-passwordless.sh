ssh root@$1 mkdir -p .ssh
ssh root@$1 chmod 700 .ssh
cat ~/root/.ssh/id_rsa.pub | ssh root@$1 'cat >> .ssh/authorized_keys'
echo "Password Less access setup for" $1
exit

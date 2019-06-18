#Install kubernets on Ubuntu 16.04

#Docker install
#sudo apt install docker.io
#Docker upgrade
#sudo apt-get install docker.io=18.06.1-0ubuntu1.2~16.04.1

#Kubernetes install
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt install kubeadm -y
sudo swapoff -a

#Init kubeadm --> Docker version could be to low in case of no upgrade of base image
sudo kubeadm init --ignore-preflight-errors=SystemVerification

#run below as user
runuser wirkend

sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Deploy pod weave network
sudo kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(sudo kubectl version | base64 | tr -d '\n')"

#Allow pod scheduling on master node (non-production)
sudo kubectl taint nodes --all node-role.kubernetes.io/master-

#FileShare
sudo mkdir /mnt/adevtestlabaks193
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/adevtestlabaks193.cred" ]; then
    sudo bash -c 'echo "username=adevtestlabaks193" >> /etc/smbcredentials/adevtestlabaks193.cred'
    sudo bash -c 'echo "password=W8iUebsZtBp3mgcKd62rJIDG3SmnCKlMyRZS7nxe+4YXWJU2D2DDyCxXOyBWoh7xBqLan6WxqY7yQY6d5OmrVQ==" >> /etc/smbcredentials/adevtestlabaks193.cred'
fi
sudo chmod 600 /etc/smbcredentials/adevtestlabaks193.cred

sudo bash -c 'echo "//adevtestlabaks193.file.core.windows.net/templates /mnt/adevtestlabaks193 cifs nofail,vers=3.0,credentials=/etc/smbcredentials/adevtestlabaks193.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
sudo mount -t cifs //adevtestlabaks193.file.core.windows.net/templates /mnt/adevtestlabaks193 -o vers=3.0,credentials=/etc/smbcredentials/adevtestlabaks193.cred,dir_mode=0777,file_mode=0777,serverino

#Create namespace first
sudo kubectl apply -f /mnt/adevtestlabaks193/ns.yml

sudo kubectl apply -f /mnt/adevtestlabaks193




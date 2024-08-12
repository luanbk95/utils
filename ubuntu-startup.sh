#!/bin/bash

read -p "Enter system admin username: " username
# Read Password
echo -n "Password: "
read -s password
echo
read -p "Enter git user: " git_user
read -p "Enter git email: " git_email

git_user=${git_user:-Luan Phan}
git_email=${git_email:-ptluan@tma.com.vn}

if [ -z $username ] || [ -z $password ]; then
  echo "No username or password"
  exit 1
else
  read -p "Continue to setup for user $username (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
fi

# Run as root
echo "$password" | sudo -S apt-get update

mkdir -p /home/${username}/Downloads/
cd /home/${username}/Downloads/

## Essential tools
sudo apt install wget curl net-tools vim openssh-server openssh-client git sshpass -yy
git config --global user.name "$git_user"
git config --global user.email "$git_email"

## Zsh
# https://onet.com.vn/how-to-install-zsh-shell-on-ubuntu-18-04-lts/
sudo apt install zsh powerline fonts-powerline zsh-theme-powerlevel9k zsh-syntax-highlighting -yy
[ -e ~/.oh-my-zsh ] && rm -rf ~/.oh-my-zsh
export RUNZSH="no"; sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# auto suggestion
grep "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ~/.zshrc \
  || echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

# syntax highlight
grep "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ~/.zshrc \
  || echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# powerlevel9k
grep "source /usr/share/powerlevel9k/powerlevel9k.zsh-theme" ~/.zshrc \
  || echo "source /usr/share/powerlevel9k/powerlevel9k.zsh-theme" >> ~/.zshrc

# set zsh default
#sudo usermod -s /usr/bin/zsh $username

## Install docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Rootless docker
grep -q -E "^docker:" /etc/group || sudo groupadd docker
sudo usermod -aG docker $username
#newgrp docker

## Kubernetes
echo \
  "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

sudo apt-get update -y

sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold docker-ce kubelet kubeadm kubectl

# ## Ibus-bamboo (vietnamese)
# sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo
# sudo apt-get update -y
# sudo apt-get install ibus ibus-bamboo --install-recommends -y
# ibus restart
# env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"

# ## Google Chrome
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo apt install ./google-chrome-stable_current_amd64.deb -y

# ## Skype
# wget https://go.skype.com/skypeforlinux-64.deb
# sudo apt install ./skypeforlinux-64.deb -y

# ## VScode
# sudo snap install --classic code -y

mkdir -p /home/${username}/workspace


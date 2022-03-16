#/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.8 -y
python3.8 --version
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
python --version
sudo apt install python3-pip -y
sudo apt install python-pip -y
pip install --upgrade pip

sudo apt install python3-apt -y
sudo apt install python-apt-common -y
sudo apt install awscli -y
sudo apt install unzip -y

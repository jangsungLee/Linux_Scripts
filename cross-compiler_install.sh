#! /bin/bash

PATH_NAME=$(pwd)

echo -e "\033[33m"find the directory"\033[0m"
echo ""
echo ""

echo -e "\033[34m"Searching Case 1"\033[0m" # root directory
MOVE_PATH_NAME=/Smart4412Linux/Development/Toolchain
ls $MOVE_PATH_NAME> /dev/null
if [  $? == 0  ]
then
  echo -e "\033[32m"It will be moved to the directory which has the files."\033[0m"
  sleep 2s
  cd $MOVE_PATH_NAME
else
  echo ""
  echo ""
  echo ""
  echo ""

  echo -e "\033[34m"Searching Case 2"\033[0m"
  MOVE_PATH_NAME=Toolchain
  ls $MOVE_PATH_NAME> /dev/null
  if [  $? == 0  ]
  then
    echo -e "\033[32m"It will be moved to the directory which has the files."\033[0m"
    sleep 2s
    cd $MOVE_PATH_NAME
  else
    echo -e "\033[31m"Please Move To the directory which have the files -->Toolchain"\033[0m"
    echo -e "\033[31m"The directory 'Toolchain' has contents: arm-2010q1.tgz, gnueabi.tgz"\033[0m"
  fi
fi

if [  $? == 0  ]
then
  echo ""
  echo -e "\033[34m"install target: arm-2010q1"\033[0m"
  echo ""
  sleep 2s
  ls arm-2010q1.tgz> /dev/null
  if [  $? == 0  ]
  then
    sudo tar zxvf arm-2010q1.tgz
  else
    echo -e "\033[31m"No such a file: 'arm-2010q1.tgz'"\033[0m"
  fi
sleep 2s # waits 1 seconds.
  echo ""
  echo -e "\033[34m"install target: gnueabi"\033[0m"
  echo ""
  sleep 2s
  ls gnueabi.tgz> /dev/null
  if [  $? == 0  ]
  then
    sudo cp gnueabi.tgz /opt
    cd /opt
    sudo tar zxvf gnueabi.tgz

    sudo apt install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

    sudo export PATH=$PATH:/opt/gnueabi/opt/ext-toolchain/bin

    
    echo -e "\033[33m"find bashrc"\033[0m"
    echo -e "\033[34m"Searching Case 1"\033[0m"
    ls /etc/bashrc> /dev/null
    if [  $? == 0  ]
    then
      sudo echo "" >> /etc/bashrc
      sudo echo "#Add alias command" >> /etc/bashrc
      sudo echo "alias arm-gcc='arm-linux-gnueabihf-gcc'" >> /etc/bashrc
      sudo echo "alias arm-g++='arm-linux-gnueabihf-g++'" >> /etc/bashrc
      sudo echo "alias arm-ld='arm-linux-gnueabihf-ld'" >> /etc/bashrc
      sudo source /etc/bashrc
      echo -e "\033[32m"the alias is saved on '/etc/bashrc'"\033[0m"
      echo -e "\033[32m"finished making 'arm-gcc' alias."\033[0m"
      echo -e "\033[32m"if the alias is not active, then please reboot the system"\033[0m"
    else
      echo ""
      echo ""
      echo -e "\033[34m"Searching Case 2"\033[0m"
      ls /etc/bash.bashrc> /dev/null
      if [  $? == 0  ]
      then
        sudo echo "" >> /etc/bash.bashrc
        sudo echo "#Add alias command" >> /etc/bash.bashrc
        sudo echo "alias arm-gcc='arm-linux-gnueabihf-gcc'" >> /etc/bash.bashrc
        sudo echo "alias arm-g++='arm-linux-gnueabihf-g++'" >> /etc/bash.bashrc
        sudo echo "alias arm-ld='arm-linux-gnueabihf-ld'" >> /etc/bash.bashrc
        sudo source /etc/bash.bashrc
        echo -e "\033[32m"the alias is saved on '/etc/bash.bashrc'"\033[0m"
        echo -e "\033[32m"finished making 'arm-gcc' alias."\033[0m"
        echo -e "\033[32m"if the alias is not active, then please reboot the system"\033[0m"
      else
        echo -e "\033[31m"Can't make alias 'arm-gcc''"\033[0m"
      fi
    fi
  else
    echo -e "\033[31m"No such a file: 'gnueabi.tgz'"\033[0m"
  fi
fi

cd $PATH_NAME

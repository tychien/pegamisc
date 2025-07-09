# pegamisc
 miscellaneous in PEGA including working journal
 
### Jun 25th 2025
    1. successfuly install MOOS-IvP & ROS2 jazzy on ubuntu 24.04 LTS
    1. ROS2 install with the following instruction: 
```
sudo apt install terminator
```

```
sudo apt update && sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update
sudo apt install curl # just in case
```
``` bash
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu noble main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
```

``` 
sudo apt update
```

```
sudo apt install ros-jazzy-desktop ros-dev-tools
echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
source ~/.bashrc
```
```
sudo apt install python3-argcomplete
```

test the ROS2 
```
ros2 run demo_nodes_cpp talker
```
in another terminal: 
```
source .bashrc
ros2 run demo_nodes_py listener
```

### Jun 26th 2025

install VRX environment success with the following processes. Official one's doesn't work. 

so use the following steps.

```
sudo apt update
sudo apt install ros-jazzy-ros-gz
```

then 

```
source /opt/ros/jazzy/setup.bash
```

```
sudo apt install python3-sdformat14 ros-jazzy-xacro
```

```
mkdir -p ~/vrx_ws/src
cd ~/vrx_ws/src
git clone https://github.com/osrf/vrx.git
source /opt/ros/jazzy/setup.bash
cd ~/vrx_ws
colcon build --merge-install
. install/setup.bash
```
Great! Let's install Gazebo
```
sudo apt-get update
sudo apt-get install curl lsb-release gnupg
sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get update
sudo apt-get install gz-harmonic
sudo apt install python3-sdformat14 ros-jazzy-xacro
```


test run!!
```
ros2 launch vrx_gz competition.launch.py world:=sydney_regatta
```





since i have failed to install the package so cleaning the previos directory. 

```
cd ~/vrx_ws # Or wherever your VRX workspace is located
rm -rf build install log
```

then build again 

```
colcon build --merge-install
```


sudo openconnect sslvpn.pegatroncorp.com --user='pega\tim_chien' --protocol=gp



## 7/3

mediatek 700/720 
https://mediatek.gitlab.io/aiot/doc/aiot-dev-guide/master/qsg/qsg_genio_700_intro.html
MakeFIle sharescript
csi / dsi - camera / display
td100 docker to build on td100 

docker export through adb uart  wifi rj45 tftb

ros - hunble docker support


buildroot / compiler yocto      



## 7/7 

Integration ASR to Android App
Interger whisper / Llama

Grizzly_kiosk - drinks machine 


Reycom - RC4 

Reycom - IQ9 - Linux  


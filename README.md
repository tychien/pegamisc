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

since i failed to install the package so cleaning the previos directory. 

```
cd ~/vrx_ws # Or wherever your VRX workspace is located
rm -rf build install log
```

then build again 

```
colcon build --merge-install
```



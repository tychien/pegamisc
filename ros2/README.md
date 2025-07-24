# ROS2

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



## JUL 24th

Run turtle sim:

Raspi: Pass the command to the turtle

Laptop: Receive the command from Raspi and monitor the turtle

1. Check the two machines are in the same network

1. check firewall `sudo ufw disable`

1. Set `export ROS_DOMAIN_ID=0` on both machines

1. Check `unset ROS_LOCALHOST_ONLY` on both 

1. make sure using the same protocol `export RMW_IMPLEMENTATION=rmw_fastrtps_cpp # or rmw_cyclonedds_cpp`

1. On Raspi, check it share the same network host between docker container and local. `
docker run -it --rm --network host --name ros2_turtlesim_on_pi ros2_ceres_arm64:latest bash`

1. On PC: 
```
source /opt/ros/humble/setup.bash 
export ROS_DOMAIN_ID=0             
ros2 run turtlesim turtlesim_node
```
1. On Raspi 
```
source /opt/ros/humble/setup.bash # 或你的 ROS 2 安裝路徑
export ROS_DOMAIN_ID=0             # 與 Raspberry PC
ros2 node list #check if it can find the ros node
```

if it finds the node, then

```
ros2 run turtlesim turtle_teleop_key  #then we can take command to pc turtle.
```

[turtlesim runs on separate machines]('[Screencast from 2025-07-24 15-23-34.mp4'](https://github.com/tychien/pegamisc/blob/main/ros2/Screencast%20from%202025-07-24%2015-23-34.mp4)')

<video controls width="1920">
    <source src="'Screencast from 2025-07-24 15-23-34.mp4'" type="video/mp4">
    抱歉，您的瀏覽器不支援此影片。
</video>

video:

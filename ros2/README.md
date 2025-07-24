# ROS2

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

![turtlesim runs on separate machines]('Screencast from 2025-07-24 15-23-34.mp4')


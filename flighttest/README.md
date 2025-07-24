# flytest

## 7/14 fly 
```
# in mavenv
mavproxy.py --master=/dev/ttyACM0 --baudrate 57600
```




## 7/16

### Install ROS2 to Raspi
``` install dependencies. 
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y curl gnupg lsb-release
```

Set apt repo.
```
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu noble main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update
```
install 
```  
sudo apt install -y ros-jazzy-desktop-full
```

add path to .bashrc
``` 
echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
source ~/.bashrc
```
make sure we have colcon to build ros 
``` 
sudo apt install -y python3-colcon-common-extensions
```
install MAVROS
```
sudo apt install -y ros-jazzy-mavros ros-jazzy-mavros-msgs
sudo /opt/ros/jazzy/lib/mavros/install_geographiclib_datasets.sh
```

8. 配置 MAVROS 和無人機通信 (關鍵步驟)

為了讓 MAVROS 與你的無人機通信，你需要做以下準備：

    無人機固件： 確保你的無人機運行的是支持 MAVLink 協議的固件，例如 PX4 或 ArduPilot。

    連接方式：

        USB (推薦開發階段)： 直接用 USB 線連接飛控到 Raspberry Pi。它通常會出現在 /dev/ttyACM0 或 /dev/ttyUSB0 等埠。

        數傳電台 (Telemetry Radio)： 使用數傳電台連接到 Raspberry Pi 的 USB 埠。

        串口 (Serial Port)： 如果 Raspberry Pi 上有可用的 UART 串口，也可以直接連接。

    MAVROS 啟動：
    你需要啟動 MAVROS 節點。這是一個基本範例 (假設你的無人機連接在 /dev/ttyACM0，波特率為 57600)：

```Bash
ros2 launch mavros mavros_node.launch fcu_url:=/dev/ttyACM0:57600
```
你可能需要根據你的實際連接埠和波特率來修改 fcu_url。

權限： 確保你的用戶擁有訪問串口的權限。你的用戶必須是 dialout 組的成員。
```Bash

    sudo usermod -a -G dialout $USER
```
    重要：執行完這一步後，你需要登出並重新登入，或重啟 Raspberry Pi 才能讓更改生效。

9. 測試基本 ROS 2 功能

在兩個不同的終端機中，測試 ROS 2 基本功能：

終端機 1: (發布者)
```Bash

ros2 run rclpy_tutorials talker
```
終端機 2: (訂閱者)

```Bash

ros2 run rclpy_tutorials listener
```
如果你能看到訊息互傳，表示 ROS 2 環境基本正常。

10. 無人機控制流程 (使用 MAVROS)

一旦 MAVROS 成功連接到你的無人機，你就可以通過發布 ROS 2 訊息來控制它。

基本控制步驟：

    啟動 MAVROS 節點：
```    Bash

ros2 launch mavros mavros_node.launch fcu_url:=/dev/ttyACM0:57600
```
確認 MAVROS 節點正常運行並連接到飛控。你可以檢查 MAVROS 的日誌，通常會顯示 FCU: Connected。

設置飛控模式為 OFFBOARD：
這是關鍵一步。在自動模式下，你才能通過 ROS 訊息控制無人機。你可以使用 MAVROS 提供的服務：
```Bash

ros2 service call /mavros/set_mode mavros_msgs/srv/SetMode "{custom_mode: 'OFFBOARD'}"
```
發送目標位置訊息 (Setpoints)：
在進入 OFFBOARD 模式之前，你需要持續發送目標位置或速度訊息，即使無人機還沒有起飛。這是為了防止飛控在沒有收到指令時自動切換回安全模式。你需要編寫一個 ROS 節點來以 10-20Hz 的頻率持續發送這些指令。
```Bash

# 這只是一個 ROS 命令列的範例，用於單次發送。
# 實際應用中，你需要一個程式碼來重複發送。
ros2 topic pub /mavros/setpoint_position/local geometry_msgs/msg/PoseStamped "{header: {stamp: {sec: 0, nanosec: 0}, frame_id: 'map'}, pose: {position: {x: 0.0, y: 0.0, z: 0.0}, orientation: {x: 0.0, y: 0.0, z: 0.0, w: 1.0}}}" -r 10
```
ARM (解鎖電機)：
```Bash

ros2 service call /mavros/cmd/arming mavros_msgs/srv/CommandBool "{value: true}"
```
TAKE_OFF (起飛到 3 米)：
當無人機 ARM 成功並處於 OFFBOARD 模式後，你就可以將目標 Z 軸位置設定為 3 米。
```Bash

# 再次強調，你需要一個 ROS 節點來持續發送
# 在你的 ROS 節點中，持續將 Z 軸目標設置為 3.0
ros2 topic pub /mavros/setpoint_position/local geometry_msgs/msg/PoseStamped "{header: {stamp: {sec: 0, nanosec: 0}, frame_id: 'map'}, pose: {position: {x: 0.0, y: 0.0, z: 3.0}, orientation: {x: 0.0, y: 0.0, z: 0.0, w: 1.0}}}" -r 10
```
無人機應該會緩慢上升到 3 米高度並嘗試保持。

LANDING (降落)：
要降落，可以將目標 Z 軸高度逐漸設為 0，或者直接使用 MAVROS 的降落服務。
```Bash

    ros2 service call /mavros/cmd/land mavros_msgs/srv/CommandTOL "{min_pitch: 0.0, yaw: 0.0, latitude: 0.0, longitude: 0.0, altitude: 0.0}"
```
    或者在你的 ROS 節點中，持續將 Z 軸目標設為 0，無人機將緩慢降落。

重要提示：

    安全第一： 在實際飛行前，請務必在安全、空曠的環境下進行測試，並確保你熟悉無人機的安全操作規範。強烈建議先在模擬器 (如 Gazebo 搭配 PX4 SITL) 中測試你的 ROS 節點和邏輯，以確保你的控制指令是正確的。

    編寫 ROS 節點： 為了實現連續的控制，你需要用 Python 或 C++ 編寫一個 ROS 節點，這個節點會：

        創建 MAVROS 服務的客戶端 (用於 set_mode, arming, land)。

        創建 MAVROS 位置設定點主題的發布者 (用於 setpoint_position/local)。

        實現一個循環，持續發布位置設定點，並在正確的時機調用服務來切換模式、解鎖電機和降落。

    詳細文檔： 建議參考 MAVROS 的官方文檔和 PX4/ArduPilot 的開發者指南，了解更詳細的 MAVLink 訊息、MAVROS 主題和服務。

ros2 launch mavros apm.launch fcu_url:=/dev/ttyACM0:115200

ros2 service call /mavros/cmd/arming mavros_msgs/srv/CommandBool "{value: true}"






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


Genio720 - MT8391  NFF 
700 - 8390 - 

1. U3P0 = usb 3.0 port 0
1. 8 first dwg lock down Sep. first coming Nov. Jan. 
1. CAN BUS -> DB9   voltage hi low gnd
1. ADB port 看console 用uart

SACG - MTK 的代理商 品佳


tool chain compiler
 OPENGL, OPENCV OPENCL

## 7/14 fly 
```
# in mavenv
mavproxy.py --master=/dev/ttyACM0 --baudrate 57600
```


## 7/15 Docker Buildx


Dockerfile:~/pegamisc/Dockerfile 
docker buildx build --platform linux/arm64 -t ros2-raspi-dev:latest --load .

## Docker build on x86 simulate arm64 (raspberry pi) 

我們的主要目標是在 x86 電腦上，透過 Docker Buildx 和 QEMU 模擬器，為 ARM64 (例如 Raspberry Pi) 架構建置一個包含 ROS 2 Humble 和相關依賴庫的 Docker 映像檔。

以下是我們嘗試的步驟和結果：

    初始問題：

        在 apt install 步驟中，QEMU 模擬器會因為 libc-bin 套件的配置而發生 Segmentation fault (段錯誤) 並導致建置失敗。這表示 QEMU 在模擬 ARM64 環境執行 libc-bin 的後安裝腳本時，遇到了底層的不穩定性。

    第一次嘗試的解決方案 (拆分 apt install 指令)：

        嘗試： 我們將原始 Dockerfile 中一個大型的 apt install 指令拆分成兩個較小的 apt install 指令。

        目的： 希望透過減少單一步驟中安裝的套件數量，來減輕 QEMU 模擬器的負擔，從而提高其穩定性，避免 libc-bin 觸發的崩潰。

        結果： 失敗。 即使拆分了指令，問題仍然在第一個 apt install 區塊中，當 libc-bin 進行配置時，QEMU 模擬器再次出現 Segmentation fault。

    第二次嘗試的解決方案 (超細粒度拆分 apt install 指令)：

        嘗試： 鑑於第一次拆分無效，我們將第一個 apt install 指令進一步細化，拆分成三個更小的 apt install 步驟。

        目的： 這是對拆分策略的極限嘗試，希望能找到一個足夠小的安裝批次，避開觸發 QEMU 崩潰的特定點。

        結果： 失敗。 即使進行了超細粒度的拆分，QEMU 模擬器在處理 libc-bin 的後安裝腳本時，仍然無法避免 Segmentation fault。錯誤依舊發生在第一個 RUN apt install 區塊。

總結失敗原因：

所有嘗試都指向同一個根本原因：QEMU 模擬器在 x86 主機上模擬 ARM64 環境，特別是在處理 libc-bin 這個非常底層且關鍵的系統套件的後安裝腳本時，存在固有的不穩定性或兼容性問題。 這種崩潰通常是 QEMU 本身在模擬特定 ARM64 指令或記憶體操作時的缺陷所導致，而非 Dockerfile 編寫的問題。

因此，我們得出結論，在 x86 上透過 QEMU 進行這種複雜的交叉編譯，對於 libc-bin 這種核心套件而言，穩定性可能無法保證。這也是為什麼我們最終建議直接在目標 ARM664 硬體 (Raspberry Pi) 上進行原生建置，以避免模擬器帶來的問題。

Ref. Error Code
```
141.3 Setting up cmake (3.22.1-1ubuntu1.22.04.2) ...
141.3 Setting up g++-11 (11.4.0-1ubuntu1~22.04) ...
141.4 Setting up dpkg-dev (1.21.1ubuntu2.3) ...
141.4 Setting up liberror-perl (0.17029-1) ...
141.4 Setting up git (1:2.34.1-1ubuntu1.15) ...
141.6 Setting up g++ (4:11.2.0-1ubuntu1) ...
141.9 update-alternatives: using /usr/bin/g++ to provide /usr/bin/c++ (c++) in auto mode
141.9 update-alternatives: warning: skip creation of /usr/share/man/man1/c++.1.gz because associated file /usr/share/man/man1/g++.1.gz (of link group c++) doesn't exist
141.9 Setting up build-essential (12.9ubuntu3) ...
141.9 Processing triggers for libc-bin (2.35-0ubuntu3.10) ...
142.0 qemu: uncaught target signal 11 (Segmentation fault) - core dumped
142.0 Segmentation fault
142.0 qemu: uncaught target signal 11 (Segmentation fault) - core dumped
142.0 Segmentation fault
142.0 dpkg: error processing package libc-bin (--configure):
142.0  installed libc-bin package post-installation script subprocess returned error exit status 139
142.0 Errors were encountered while processing:
142.0  libc-bin
142.1 E: Sub-process /usr/bin/dpkg returned an error code (1)
------

 2 warnings found (use docker --debug to expand):
 - LegacyKeyValueFormat: "ENV key=value" should be used instead of legacy "ENV key value" format (line 6)
 - LegacyKeyValueFormat: "ENV key=value" should be used instead of legacy "ENV key value" format (line 7)
Dockerfile:12
--------------------
  11 |     # 安裝第一批核心工具
  12 | >>> RUN apt update && apt install -y --no-install-recommends \
  13 | >>>     build-essential cmake git wget curl \
  14 | >>>     && rm -rf /var/lib/apt/lists/*
  15 |     
--------------------
ERROR: failed to build: failed to solve: process "/bin/sh -c apt update && apt install -y --no-install-recommends     build-essential cmake git wget curl     && rm -rf /var/lib/apt/lists/*" did not complete successfully: exit code: 100
```
### 解決方法
```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes -c yes
```
[ref](https://github.com/docker/buildx/issues/1169#issuecomment-2014772508 "libc-bin Issue")


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
 

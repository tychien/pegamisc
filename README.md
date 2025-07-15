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

 

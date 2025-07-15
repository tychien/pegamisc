# 使用 Ubuntu 22.04 (Jammy) ARM64 作為基礎映像檔
FROM ubuntu:22.04

# 設定環境變數
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# --- 超細粒度拆分 apt install 以提高 QEMU 穩定性 ---

# 安裝第一批核心工具
RUN apt update && apt install -y --no-install-recommends \
    build-essential cmake git wget curl \
    && rm -rf /var/lib/apt/lists/*

# 安裝第二批 Python 相關工具和語言環境
RUN apt update && apt install -y --no-install-recommends \
    python3-pip locales \
    && rm -rf /var/lib/apt/lists/*

# 安裝第三批函式庫依賴
RUN apt update && apt install -y --no-install-recommends \
    libgoogle-glog-dev libgflags-dev libatlas-base-dev \
    libeigen3-dev libsuitesparse-dev libopencv-dev ocl-icd-opencl-dev \
    && rm -rf /var/lib/apt/lists/*

# --- 結束超細粒度拆分 ---

# 加入 ROS 2 軟體來源，才能找到 rosdep、colcon 等工具
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt update && apt install -y \
    python3-rosdep \
    python3-colcon-common-extensions \
    python3-vcstool

# 安裝 ROS 2 Humble
RUN apt install -y ros-humble-desktop-full

# 設定 ROS 環境
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# 建立 ROS 工作空間
WORKDIR /ros_ws/src

# 下載所有程式庫的原始碼
# Ceres Solver 會在它自己的 third_party 資料夾尋找 Abseil 和 Googletest
# 因此我們將 Abseil 和 Googletest 下載到 ceres-solver/third_party/ 下
# 這樣可以避免 Ceres 退回使用系統版本
RUN git clone https://github.com/ceres-solver/ceres-solver.git && \
    git clone https://github.com/RainerKuemmerle/g2o.git && \
    git clone https://github.com/borglab/gtsam.git && \
    git clone https://github.com/mavlink/mavros.git && \
    git clone https://github.com/mavlink/mavlink.git --recursive && \
    git clone https://github.com/abseil/abseil-cpp.git ceres-solver/third_party/abseil-cpp && \
    git clone https://github.com/google/googletest.git ceres-solver/third_party/googletest

# 編譯 Ceres Solver
RUN mkdir ceres-solver/build && \
    cd ceres-solver/build && \
    cmake \
        -Dabsl_VERSION=20240125 \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
        -G "Unix Makefiles" \
        .. && \
    make -j$(nproc) && \
    make install

# 編譯 g2o
RUN mkdir g2o/build && \
    cd g2o/build && \
    cmake .. && \
    make -j$(nproc) && \
    make install

# 編譯 GTSAM
RUN mkdir gtsam/build && \
    cd gtsam/build && \
    cmake .. && \
    make -j$(nproc) && \
    make install

# 回到 ROS 工作空間根目錄
WORKDIR /ros_ws

# 使用 bash 執行 rosdep 和 colcon build
RUN ["/bin/bash", "-c", "source /opt/ros/humble/setup.bash && rosdep init && rosdep update && rosdep install --from-paths src --ignore-src -y --rosdistro humble && colcon build --symlink-install"]

# 清理以縮小映像檔大小
RUN apt autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 啟動容器時自動進入 ROS 環境
CMD ["/bin/bash", "-c", "source /ros_ws/install/setup.bash && /bin/bash"]

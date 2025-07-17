# Use Ubuntu 22.04 (Jammy) ARM64 as the base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation and locale
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install core tools in batches for robustness
# First batch: essential build tools
RUN apt update && apt install -y --no-install-recommends \
    build-essential cmake git wget curl \
    && rm -rf /var/lib/apt/lists/*

# Second batch: Python tools and locale settings
RUN apt update && apt install -y --no-install-recommends \
    python3-pip locales \
    && rm -rf /var/lib/apt/lists/*

# Third batch: core library dependencies for mapping and optimization
RUN apt update && apt install -y --no-install-recommends \
    libgoogle-glog-dev libgflags-dev libatlas-base-dev \
    libeigen3-dev libsuitesparse-dev libopencv-dev ocl-icd-opencl-dev \
    && rm -rf /var/lib/apt/lists/*

# Add ROS 2 software sources and install ROS 2 build tools
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt update && apt install -y \
    python3-rosdep \
    python3-colcon-common-extensions \
    python3-vcstool

# Install ROS 2 Humble Desktop Full
RUN apt install -y ros-humble-desktop-full

# Set up ROS environment for the root user
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Create ROS workspace
WORKDIR /ros_ws/src

# Download all source libraries
RUN git clone https://github.com/ceres-solver/ceres-solver.git && \
    git clone https://github.com/RainerKuemmerle/g2o.git && \
    git clone https://github.com/borglab/gtsam.git && \
    git clone https://github.com/mavlink/mavros.git && \
    git clone https://github.com/mavlink/mavlink.git --recursive

# --- BEGIN: Ceres-Solver 編譯步驟已被註解掉 ---
# # We will not compile ceres-solver due to persistent build errors on this platform.
# # It is not a dependency for MAVROS.
# RUN git clone https://github.com/abseil/abseil-cpp.git ceres-solver/third_party/abseil-cpp && \
#     git clone https://github.com/google/googletest.git ceres-solver/third_party/googletest
# RUN mkdir ceres-solver/build && \
#     cd ceres-solver/build && \
#     cmake \
#         -DCMAKE_BUILD_TYPE=Release \
#         -DBUILD_EXAMPLES=OFF \
#         -DBUILD_TESTING=OFF \
#         -DCERES_USE_SYSTEM_ABSL=OFF \
#         -DCERES_USE_SYSTEM_GOOGLETEST=OFF \
#         -Dabsl_VERSION=20240125 \
#         -G "Unix Makefiles" \
#         .. && \
#     make -j4 && \
#     make install
# --- END: Ceres-Solver 編譯步驟已被註解掉 ---

# Compile g2o
RUN mkdir g2o/build && \
    cd g2o/build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -G "Unix Makefiles" \
        .. && \
    make -j4 && \
    make install

# Compile GTSAM
RUN mkdir gtsam/build && \
    cd gtsam/build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -G "Unix Makefiles" \
        .. && \
    make -j4 && \
    make install

# Return to the ROS workspace root
WORKDIR /ros_ws

# Use bash to execute rosdep and colcon build
RUN ["/bin/bash", "-c", "source /opt/ros/humble/setup.bash && rosdep init && rosdep update && rosdep install --from-paths src --ignore-src -y --rosdistro humble && colcon build --symlink-install --cmake-args -DCMAKE_CXX_FLAGS='-Wno-deprecated-declarations'"]

# Clean up to reduce image size
RUN apt autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Auto-enter ROS environment when container starts
CMD ["/bin/bash", "-c", "source /ros_ws/install/setup.bash && /bin/bash"]

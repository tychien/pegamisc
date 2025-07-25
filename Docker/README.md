# Docker BUild

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


docker image: 
```
docker pull tychien/arm64_ubuntu22.04_ros2_ceres_g2o_gtsam_ardupilot:latest
```

[How to embed a Docker image into Yocto’s root filesystem ] (https://blog.savoirfairelinux.com/en-ca/2020/how-to-embed-a-docker-image-into-yoctos-root-filesystem/)


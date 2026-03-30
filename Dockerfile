FROM osrf/ros:humble-desktop

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# ----------------------------
# Base tools
# ----------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    python3-pip \
    python3-rosdep \
    python3-vcstool \
    locales \
    curl \
    wget \
    gnupg2 \
    lsb-release \
    mesa-utils \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------
# Colcon
# ----------------------------
RUN pip3 install -U colcon-common-extensions

# ----------------------------
# Locale
# ----------------------------
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ----------------------------
# rosdep
# ----------------------------
RUN rosdep init || true && rosdep update

# ----------------------------
# Gazebo Classic (gazebo11)
# ----------------------------
# Ensure ROS 2 apt sources are configured
RUN apt-get update && apt-get install -y curl gnupg2 lsb-release \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add - \
    && echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list \
    && apt-get update

# Install specific Gazebo packages for ROS 2 Humble
RUN apt-get install -y \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-plugins \
    ros-humble-gazebo-dev

RUN apt-get update && apt-get install -y \
    ros-humble-gazebo-ros \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------
# Fix GUI runtime
# ----------------------------
RUN mkdir -p /tmp/runtime-root && chmod 700 /tmp/runtime-root

# ----------------------------
# Source ROS automatically
# ----------------------------
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "if [ -f /home/ros2_ws/install/setup.bash ]; then source /home/ros2_ws/install/setup.bash; fi" >> ~/.bashrc

WORKDIR /home/ros2_ws

CMD ["bash"]
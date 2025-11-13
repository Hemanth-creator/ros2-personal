# Start from official ROS 2 Jazzy desktop image
FROM osrf/ros:jazzy-desktop

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# Install dev tools and ROS 2 essentials
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
    lsb-release \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Install development tools using pip
RUN pip3 install --break-system-packages -U colcon-common-extensions

# Setup locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Initialize rosdep
RUN rosdep init || true && rosdep update

# Install Gazebo Harmonic (gz‑sim) + ROS_GZ vendor packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      lsb-release \
      gnupg2 \
    && curl -fsSL https://packages.osrfoundation.org/gazebo.gpg \
         --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] \
         https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" \
         > /etc/apt/sources.list.d/gazebo-stable.list \
    && apt-get update && apt-get install -y --no-install-recommends \
      gz-harmonic \
      ros-jazzy-ros-gz \
    && rm -rf /var/lib/apt/lists/*

# Set runtime directory for GUI apps (prevents Qt warning)
RUN mkdir -p /tmp/runtime-root && chmod 700 /tmp/runtime-root
ENV XDG_RUNTIME_DIR=/tmp/runtime-root

# Source ROS 2 setup on container start
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

CMD ["bash"]

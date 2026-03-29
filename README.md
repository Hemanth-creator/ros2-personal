# ROS 2 Humble + Gazebo Classic Docker Environment

This repository provides a Docker-based development environment for **ROS 2 Humble** with **Gazebo Classic (gazebo11)** and optional GPU acceleration.

---

# 🚀 Features

* ROS 2 Humble (desktop)
* Gazebo Classic (gazebo11)
* GPU acceleration support:

  * NVIDIA (full acceleration)
  * Intel/AMD (via `/dev/dri`)
* Preconfigured development tools
* Colcon build system
* X11 GUI support (Gazebo, RViz)

---

# 📦 Requirements

## General

* Docker
* Docker Compose
* Linux (recommended)

## Optional (for GPU)

### NVIDIA GPU

* NVIDIA drivers installed
* `nvidia-container-toolkit`

Install:

```bash
sudo apt update
sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

### Intel / AMD GPU

No additional setup required (uses `/dev/dri`).

---

# 🖥️ Enable GUI (Required)

Allow Docker to access your display:

```bash
xhost +local:docker
```

---

# 🏗️ Build the Container

```bash
docker compose build
```

---

# ▶️ Run the Container

## With GPU (recommended)

```bash
docker compose up -d
```

If NVIDIA GPU is not detected:

```bash
docker compose run --gpus all ros2
```

---

## Without GPU (CPU only)

```bash
docker compose run -e NVIDIA_VISIBLE_DEVICES=none ros2
```

---

# 📂 Workspace

Your ROS 2 workspace is mounted automatically:

```
./src -> /home/ros2_ws/src
```

---

# 🧪 Test Setup

## Inside the container

### Test ROS

```bash
ros2 --help
```

### Test Gazebo

```bash
gazebo
```

### Test ROS + Gazebo

```bash
ros2 launch gazebo_ros gazebo.launch.py
```

---

# 🎮 Verify GPU Usage

## NVIDIA

```bash
nvidia-smi
```

## All GPUs

```bash
glxinfo | grep "OpenGL renderer"
```

### Expected Output

* ✅ NVIDIA / Intel / AMD GPU name → GPU working
* ❌ `llvmpipe` → CPU rendering (GPU not used)

---

# ⚠️ Troubleshooting

## GUI not showing

* Run `xhost +local:docker`
* Check DISPLAY variable

## GPU not detected (NVIDIA)

* Ensure toolkit installed
* Restart Docker
* Try:

```bash
docker compose run --gpus all ros2
```

## Slow Gazebo / RViz

* GPU likely not being used
* Check with `glxinfo`

---

# 📌 Notes

* This setup uses **Gazebo Classic (gazebo11)** for maximum compatibility with ROS 2 Humble.
* Avoid mixing with newer Gazebo (Ignition / gz-sim) in this environment.

---

# 🛠️ Useful Commands

## Enter running container

```bash
docker exec -it ros2_dev_humble bash
```
## Seting alias for entering the cotainer (Recomended)
```bash
nano ~/.bashrc
alias dev_humble='docker exec -it ros2_dev_humble bash'
source ~/.bashrc
```
## enter the container 
```bash
dev_humble
```


## Stop container

```bash
docker compose down
```

---

# ✅ Summary

| Feature        | Status |
| -------------- | ------ |
| ROS 2 Humble   | ✅      |
| Gazebo Classic | ✅      |
| NVIDIA GPU     | ✅      |
| Intel/AMD GPU  | ✅      |
| GUI Apps       | ✅      |

---

# 🚀 Next Steps

You can now:

* Add your ROS 2 packages to `src/`
* Build with `colcon build`
* Launch simulations in Gazebo

---

Happy coding! 🎯

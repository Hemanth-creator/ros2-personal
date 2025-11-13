# setup
- docker compose build
- docker compose up -d
- docker exec -it ros2_dev_personal bash
    - Now you’re inside the container’s /home/ros2_ws.
- cd /home/ros2_ws
- colcon build
- source install/setup.bash

you can run your nodes
- ros2 run <package_name> <node_name>


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






=================================================
run this to move the accerman robot in gz_ros2_control_demos
root@hemanth-ThinkPad-E14-Gen-6:/home/ros2_ws# ros2 topic pub -r 20 /ackermann_steering_controller/reference geometry_msgs/msg/TwistStamped "header:
  stamp: {sec: 0, nanosec: 0}
  frame_id: 'base_link'
twist:
  linear:
    x: 1.0
    y: 0.0
    z: 0.0
  angular:
    x: 0.0
    y: 0.0
    z: 0.3"

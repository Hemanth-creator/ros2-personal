#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist, TwistStamped

class TwistBridge(Node):
    def __init__(self):
        super().__init__('twist_bridge')
        self.sub = self.create_subscription(Twist, '/cmd_vel', self.twist_callback, 10)
        self.pub = self.create_publisher(TwistStamped, '/ackermann_steering_controller/reference', 10)

    def twist_callback(self, msg):
        ts = TwistStamped()
        ts.header.stamp = self.get_clock().now().to_msg()
        ts.header.frame_id = 'base_link'
        # Only fill the fields controller uses
        ts.twist.linear.x = msg.linear.x      # forward/backward
        ts.twist.angular.z = msg.angular.z    # steering
        # Set other fields to zero explicitly
        ts.twist.linear.y = 0.0
        ts.twist.linear.z = 0.0
        ts.twist.angular.x = 0.0
        ts.twist.angular.y = 0.0
        self.pub.publish(ts)

def main(args=None):
    rclpy.init(args=args)
    node = TwistBridge()
    rclpy.spin(node)
    rclpy.shutdown()

if __name__ == '__main__':
    main()

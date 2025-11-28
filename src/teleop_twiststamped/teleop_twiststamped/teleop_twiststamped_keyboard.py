#!/usr/bin/env python3

import sys
import termios
import tty
import time
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import TwistStamped
import select

instructions = """
Timed Keyboard Teleop (0.5s update)

Movement:
    w : forward
    s : backward
    a : steer left
    d : steer right
    x : stop

Speed control:
    + : increase linear speed
    - : decrease linear speed
    ] : increase steering speed
    [ : decrease steering speed

CTRL-C to quit
"""

class TimedTeleop(Node):

    def __init__(self):
        super().__init__('timed_teleop_twiststamped')

        self.pub = self.create_publisher(
            TwistStamped,
            '/ackermann_steering_controller/reference',
            10
        )

        self.speed = 1.0
        self.turn = 0.3

        print(instructions)
        self.print_speeds()

    def print_speeds(self):
        print(f"Linear speed: {self.speed:.2f} | Steering speed: {self.turn:.2f}")

    def get_key(self, timeout=0.5):
        """Waits for key input for up to 'timeout' seconds"""
        settings = termios.tcgetattr(sys.stdin)
        tty.setcbreak(sys.stdin.fileno())
        key = None
        try:
            rlist, _, _ = select.select([sys.stdin], [], [], timeout)
            if rlist:
                key = sys.stdin.read(1)
        finally:
            termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
        return key

    def publish_cmd(self, linear, angular):
        msg = TwistStamped()
        msg.header.stamp = self.get_clock().now().to_msg()
        msg.header.frame_id = 'base_link'
        msg.twist.linear.x = linear
        msg.twist.angular.z = angular
        self.pub.publish(msg)

    def run(self):
        try:
            while True:
                key = self.get_key(timeout=0.5)  # wait for 0.5 s

                linear = 0.0
                angular = 0.0

                if key is not None:

                    # Movement keys
                    if key == 'w':
                        linear = self.speed
                    elif key == 's':
                        linear = -self.speed
                    if key == 'a':
                        angular = self.turn if linear >= 0 else -self.turn
                        if linear == 0.0:
                            linear = self.speed  # default forward if only A pressed
                    elif key == 'd':
                        angular = -self.turn if linear >= 0 else self.turn
                        if linear == 0.0:
                            linear = self.speed

                    # Stop
                    elif key == 'x':
                        linear = 0.0
                        angular = 0.0

                    # Speed adjustments
                    elif key == '+':
                        self.speed += 0.1
                        self.print_speeds()
                    elif key == '-':
                        self.speed = max(0.0, self.speed - 0.1)
                        self.print_speeds()
                    elif key == ']':
                        self.turn += 0.05
                        self.print_speeds()
                    elif key == '[':
                        self.turn = max(0.0, self.turn - 0.05)
                        self.print_speeds()

                    # Exit
                    elif key == '\x03':  # CTRL-C
                        break

                self.publish_cmd(linear, angular)

        finally:
            self.publish_cmd(0.0, 0.0)


def main(args=None):
    rclpy.init(args=args)
    node = TimedTeleop()
    node.run()
    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()

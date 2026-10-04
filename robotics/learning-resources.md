# 机器人学习资源

记录日期：2026年10月4日

## 1 ANYbotics elevation_mapping

https://github.com/ANYbotics/elevation_mapping

作用：融合传感器点云、机器人位姿与位姿不确定性，生成机器人周围的局部高程地图，并估计高度方差。

地图形式：2.5D 高程地图，在二维网格中记录高度信息；不是完整三维体素地图，也不是路径规划器。

与 rover 导航的关系：高程地图可作为后续地形可通行性评估和路径规划的输入。

阅读时注意：截至记录时，README 声明项目不再积极维护，安装说明使用 ROS1 的 catkin 和 roslaunch，不能直接按原命令用于 ROS2 Jazzy。

## 2 ROS2 Jazzy 官方教程

https://docs.ros.org/en/jazzy/Tutorials.html

作用：循序渐进学习 ROS2 的官方教程目录，包含入门、命令行工具、客户端编程、中级、高级与演示内容。

适用版本：ROS2 Jazzy，与目前使用的 ROS2 版本对应。

学习方向：先理解节点、话题、服务、动作和参数，再学习编写 Python 或 C++ 节点，以及 Launch 和 TF2 等内容。

## 两者的关系

ROS2 教程用于学习基础工具与开发方式；elevation_mapping 是地形建图的具体项目，可用于研究高程地图与不确定性表示。

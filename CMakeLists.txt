cmake_minimum_required(VERSION 2.8.3)
project(parameter_manager)

find_package(catkin REQUIRED)
catkin_package()

install(
  PROGRAMS
  install.sh
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

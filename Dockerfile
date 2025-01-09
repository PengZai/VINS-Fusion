FROM ros:noetic-ros-base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y ros-noetic-image-geometry ros-noetic-pcl-ros \
    ros-noetic-cv-bridge git cmake build-essential unzip pkg-config autoconf \
    libboost-all-dev \
    libjpeg-dev libpng-dev libtiff-dev \
    # Use libvtk5-dev, libgtk2.0-dev in ubuntu 16.04 \
    libvtk7-dev libgtk-3-dev \
    libatlas-base-dev gfortran \
    libparmetis-dev \
    python3-wstool python3-catkin-tools \
    # libtbb recommended for speed: \
    libtbb-dev \
    wget cmake libgoogle-glog-dev libgflags-dev \
    libatlas-base-dev libeigen3-dev libsuitesparse-dev
    
# install ceres 2.1


# Build catkin workspace
RUN apt-get install -y ros-noetic-image-pipeline ros-noetic-geometry ros-noetic-rviz 


RUN mkdir /root/softwares && cd ~/softwares && \
    wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz && \
    tar zxf ceres-solver-2.1.0.tar.gz && \
    mkdir ceres-bin && cd ceres-bin &&\
    cmake ../ceres-solver-2.1.0 && make -j4 &&\
    make install

RUN echo 'source /opt/ros/noetic/setup.bash' >> /root/.bashrc
RUN . /opt/ros/noetic/setup.sh


RUN mkdir -p /root/catkin_ws/src

RUN cd /root/catkin_ws/src && \
    git clone https://github.com/guisoares9/VINS-Fusion.git && \
    cd .. && \
    catkin config --extend /opt/ros/$ROS_DISTRO --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
    catkin build

RUN echo 'source /root/catkin_ws/devel/setup.bash' >> /root/.bashrc


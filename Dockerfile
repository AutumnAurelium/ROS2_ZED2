# syntax=docker/dockerfile:1
FROM nvcr.io/nvidia/l4t-base:r32.6.1

ENV OPENBLAS_CORETYPE ARMV8
RUN echo "export OPENBLAS_CORETYPE=ARMV8" >> /etc/profile

# this is dumb but seems to be the only way to do this
ADD generated/l4t_release_info /etc/nv_tegra_release

# setup aptitutde
RUN apt update

# install apt prereqs
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install -y sudo python3-pip python3-opencv

# ZED2 installer likes being an unprivileged user, so we must create a dummy user.
ADD scripts/setup_dummy.sh /root/setup_dummy.sh
RUN cd /root/ && bash setup_dummy.sh

# install ROS2 before ZED2 because ROS2 takes 45 minutes to build
RUN apt install -y lsb-release

ADD scripts/installROS2.sh /root/installROS2.sh
#RUN cd /root && wget https://raw.githubusercontent.com/jetsonhacks/installROS2/master/installROS2.sh
RUN chmod +x /root/installROS2.sh
RUN pip3 install --upgrade pip
RUN pip3 install numpy==1.19.4
RUN cd /root && OPENBLAS_CORETYPE=ARMV8 ./installROS2.sh

# install Python API prerequisites (ZED2 would handle this itself, but this way we can do caching)
RUN su user -c "pip3 install --upgrade cython"

# download the ZED2 installer
RUN cd /home/user/ && \
wget -q https://download.stereolabs.com/zedsdk/3.6/jp46/jetsons --no-check-certificate && \
chmod +x jetsons && \
chown user jetsons

RUN apt update

# install ZED2 SDK
RUN su user -c "cd && ./jetsons -- silent"

# this is terrible, but ZED2 won't install as root
RUN cp -r /home/user/.local /root/

# add ZED2 test script to user directory
ADD scripts/camera_test.py /root/camera_test.py

# install ROS2
RUN apt install -y lsb-release


# install ZED2 colcon packages.
ADD scripts/installColconPkgs.sh /root/installColconPkgs.sh
RUN chmod +x /root/installColconPkgs.sh
RUN cd /root/ && ./installColconPkgs.sh
sudo docker run -it --rm --net=host --runtime nvidia -e DISPLAY=$DISPLAY --privileged --volume="$HOME/.Xauthority:/root/.Xauthority:rw" --volume /dev/bus/usb:/dev/bus/usb ros2_zed2:latest

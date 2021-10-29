[ ! -d "sysinfo" ] && echo "You are missing the sysinfo directory. Run ./mksysinfo.sh" && exit 1
sudo docker build -t ros2_zed2:latest .

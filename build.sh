[ ! -d "generated" ] && echo "You are missing the system-generated file directory. Run ./mksysinfo.sh" && exit 1
sudo docker build -t ros2_zed2:latest .

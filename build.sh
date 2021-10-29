[ ! -d "payload" ] && echo "MISSING PAYLOAD DIRECTORY: Run ./mkpayload.sh" && exit 1
sudo docker build -t ros2_zed2:latest .

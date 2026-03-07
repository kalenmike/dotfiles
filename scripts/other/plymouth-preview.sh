sudo DISPLAY=$DISPLAY plymouthd --debug --tty=/dev/tty1 --mode=boot
sudo plymouth --show-splash
sleep 5
sudo plymouth quit

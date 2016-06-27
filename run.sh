#!/bin/bash
prepare_docker_device_parameters() {
  # enumerate video devices for webcam support
  VIDEO_DEVICES=
  for device in /dev/video*
  do
    if [ -c $device ]; then
      VIDEO_DEVICES="${VIDEO_DEVICES} --device $device:$device"
    fi
  done
}
prepare_docker_device_parameters
xhost +local:$USER
uid=$(id -u $USER)
gid=$(id -g $USER)
tz=$(date +%Z)
docker run -it \
  -e DISPLAY=$DISPLAY \
  -e XAUTHORITY=/.Xauthority \
  -e USER_UID=$uid \
  -e USER_GID=$gid \
  -e USER=$USER \
  -e TZ=$tz \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v $XAUTHORITY:/.Xauthority \
  -v `pwd`:/home/$USER \
  -v /run/user/$uid/pulse:/run/pulse \
  --device /dev/dri \
  ${VIDEO_DEVICES} \
  --cpuset-cpus 0 \
  --memory 512mb \
  --cap-add=SYS_ADMIN \
  --rm \
  runjak/docker-skype:latest

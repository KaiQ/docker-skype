#!/bin/bash
create_user() {
  # ensure home directory is owned by browser
  # and that profile files exist
  if [[ -d /home/${USER} ]]; then
    chown ${USER_UID}:${USER_GID} /home/${USER}
    # copy user files from /etc/skel
    cp /etc/skel/.bashrc /home/$USER
    cp /etc/skel/.bash_logout /home/${USER}
    cp /etc/skel/.profile /home/${USER}
    chown ${USER_UID}:${USER_GID} \
      /home/${USER}/.bashrc \
      /home/${USER}/.profile \
      /home/${USER}/.bash_logout
  fi
  # create group with USER_GID
  if ! getent group ${USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${USER} 2> /dev/null
  fi

  # create user with USER_UID
  if ! getent passwd ${USER} >/dev/null; then
    adduser --uid ${USER_UID} --gid ${USER_GID} ${USER}
    usermod -a -G video ${USER}
    usermod -a -G audio ${USER}
  fi
}

grant_access_to_video_devices() {
  for device in /dev/video*
  do
    if [[ -c $device ]]; then
      VIDEO_GID=$(stat -c %g $device)
      break
    fi
  done
}

create_user
grant_access_to_video_devices
cd /home/${USER}
exec su $USER -c 'PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" skype'

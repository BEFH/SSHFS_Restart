#!/usr/bin/env bash

############################
# Restart SSHFS connection #
############################

# Assumes you start SSHFS with "sshfs [remote] [local]

process="$(pgrep -lf sshfs)"
p_count=$(printf "$process\n" | wc -l | sed 's/[[:space:]]//g')

if [ "$#" -eq 0 ]; then
  if [ "$p_count" -ne 1 ]; then
    echo "Error: There is more than one sshfs process:"
    printf "$process\nPlease choose one and run SSHFS_restart [mountpoint]\n"
    exit 1
  else
    pid="$(printf "$process" | cut -d' ' -f1)"
    command="$(printf "$process" | cut -d' ' -f2-4)"
    mp="$(printf "$process" | cut -d' ' -f4))"
  fi
else
  mp="${1/#\~/$HOME}"
  pid="$(printf "$process" | \
    awk -v m="$mp" '$4 == m {print $1}')"
  command="$(printf "$process" | \
    awk -v m="$mp" '$4 == m {print $2" "$3" "$4}')"
fi

kill -9 $pid
sudo umount -f "$mp"
eval "$command"
exit 1

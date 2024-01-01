#!/usr/bin/env bash


function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

nitrogen --restore
run dunst
run picom
run /usr/libexec/xfce-polkit
run polybar example -r
xset s off
xset -dpms
xbacklight -set 85
xsetroot -cursor_name left_ptr

#!/bin/bash
export DISPLAY=:99.0
cd ${HOME}
openbox &
lxpanel &
pcmanfm --desktop &
wait
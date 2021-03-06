#!/bin/bash
###############################################################################
# \file
#
# $Id:$
#
# Copyright (C) Brno University of Technology
#
# This file is part of software developed by dcgm-robotics@FIT group.
# 
# Author: Tomas Hodan (xhodan04@stud.fit.vutbr.cz)
# Supervised by: Michal Spanel (spanel@fit.vutbr.cz)
# Date: 19/12/2011 (version 3.0)
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with this file.  If not, see <http://www.gnu.org/licenses/>.
#

# Description:
# Bag files playback publishing the simulated time (corresponding to time in
# a given bag file) to the /clock topic.
#
# The playback is going in the loop and it is paused at the beginning paused
# (to run/pause press SPACE key).
#
# It is convenient to skip a few seconds at the beginning, since there are
# usually some data missing (e.g. there are no messages on cam3d/* topics
# used in COB) => START_TIME = something like 6.0
#
# How to run:
# . play_bag.sh -p PATH-TO-BAG-FILE [-t START-TIME]
#-------------------------------------------------------------------------------

# Default starting time
START_TIME=6
BAG_PATH=""

# Process script's arguments
OPT=-
for i in $@; do  
    if [ $OPT = - ]; then
        if [ $i = -p ]; then
            OPT=$i
        elif [ $i = -t ]; then
            OPT=$i
        fi
    else
        if [ $OPT = -p ]; then
            BAG_PATH=$i
        elif [ $OPT = -t ]; then
            START_TIME=$i
        fi
        OPT=-
    fi  
done

if [ -z "$BAG_PATH" ]; then
    echo "Usage: . play_bag.sh -p PATH-TO-BAG-FILE [-t START-TIME]"
else
    # Setting the parameter /use_sim_time to true indicates that time from /clock
    # topic should be used instead of the wall-clock time (the current time).
    # (This should be done before launching any ROS nodes)
    rosparam set /use_sim_time true

    # The option --clock causes that the simulated time (based on timestamps from
    # the given bag file) is published to the /clock topic.
    rosbag play $BAG_PATH --pause --loop --clock --start=$START_TIME
fi


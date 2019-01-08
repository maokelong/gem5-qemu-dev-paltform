#!/bin/bash
source config.sh

# check if downloaded
DEST_DIR=${CONFIG_SPEC/.*/}
if [ ! -d $CONFIG_DIR_SPEC/$DEST_DIR ]; then
  echo -e "${COLOR_RED} Please download spec before build! ${COLOR_NORMAL}"
  exit -1
fi

# check dependencies
sudo apt install gfortran

# switch working dir
cd $CONFIG_DIR_SPEC/$DEST_DIR

# install spec
SPEC_VERSION=$(cat version.txt)
if [[ $SPEC_VERSION != "1.2" ]]; then
  patch -p1 < $CONFIG_DIR_PATCHES_10
fi
bash install.sh

# compile all benches
if [[ $SPEC_VERSION == "1.2" ]]; then
  cp config/Example-linux64-amd64-gcc43+.cfg config/config.cfg
  patch -p1 < $CONFIG_DIR_PATCHES_12
else
  cp config/Example-linux64-amd64-gcc43.cfg config/config.cfg
fi
source shrc
runspec --config=config.cfg --action=build --tune=base \
        400.perlbench \
        401.bzip2 \
        403.gcc \
        410.bwaves \
        416.gamess \
        429.mcf \
        433.milc \
        434.zeusmp \
        435.gromacs \
        436.cactusADM \
        437.leslie3d \
        444.namd \
        445.gobmk \
        447.dealII \
        450.soplex \
        453.povray \
        454.calculix \
        456.hmmer \
        458.sjeng \
        459.GemsFDTD \
        462.libquantum \
        464.h264ref \
        465.tonto \
        470.lbm \
        471.omnetpp \
        473.astar \
        481.wrf \
        482.sphinx3 \
        483.xalancbmk \
        998.specrand \
        999.specrand

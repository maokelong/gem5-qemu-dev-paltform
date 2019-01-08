#!/bin/bash
set -e
source config.sh

# detect the archive
if [ ! -f $CONFIG_DIR_SPEC/$CONFIG_SPEC ]; then
  echo -e "${COLOR_RED} Failed to detect ${CONFIG_DIR_SPEC}/${CONFIG_SPEC}. Note that we can't provide the cpu2006 tar archive because of licensing restrictions! ${COLOR_NORMAL}"
  exit -1
fi

cd $CONFIG_DIR_SPEC

# extract the archive
DEST_DIR=${CONFIG_SPEC/.*/}
if [ ! -f $CONFIG_DIR_SPEC/$DEST_DIR/install.sh ]; then
  if [[ $CONFIG_SPEC == *.tar.gz ]]; then
    tar -xvzf $CONFIG_SPEC -C
  elif [[ $CONFIG_SPEC == *.iso ]]; then
    mkdir -p ${DEST_DIR}_read_only
    sudo mount -o loop -t iso9660 $CONFIG_SPEC ${DEST_DIR}_read_only || :
    cp -r ${DEST_DIR}_read_only $DEST_DIR
    chmod -R a+w $DEST_DIR
    sudo umount ${DEST_DIR}_read_only
    rm -rf ${DEST_DIR}_read_only
  else
    echo -e "${COLOR_RED}SPEC: Unsupported archive format.${COLOR_NORMAL}"
    exit -1
  fi
fi

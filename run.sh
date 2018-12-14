#!/bin/bash
set -e

# options
to_build=false
to_clean=false
to_run_qemu=false
to_run_gem5=false

# get arguments
while getopts "bchr:" OPT; do
  case $OPT in
    b)
      to_build=true
      ;;
    c)
      to_clean=true
      ;;
    r)
      if [ "$OPTARG" = "qemu" ]; then 
        to_run_qemu=true
      elif [ "$OPTARG" = "gem5" ]; then
        to_run_gem5=true
      fi
      ;;
    h)
      # TODO ADD HELP INFO HERE
      ;;
  esac
done

# -b
if $to_build; then
  (cd scripts && bash download_kernel.sh)
  (cd scripts && bash download_os.sh)
  (cd scripts && bash download_qemu.sh)
  (cd scripts && bash download_gem5.sh)
  (cd scripts && bash build_kernel.sh)
  (cd scripts && bash build_disk.sh)
  (cd scripts && bash build_gem5.sh)
fi

# -r qemu
if $to_run_qemu; then
  (cd scripts && bash run_qemu.sh)
fi

# -r gem5
if $to_run_gem5; then
  (cd scripts && bash run_gem5_fs.sh)
fi

# -c
if $to_clean; then
  read -p "${RED}You gonna destroy all the files and directories within current folder, except \"run.sh\" and \"readme.md\". Are you sure to continue? [N/y] ${NORMAL}" -n 1 -r
  echo # to start a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    find . \
      -not -wholename "./run.sh" \
      -not -wholename "./scripts/*.sh" \
      -not -wholename "./scripts" \
      -not -wholename "./readme.md" \
      -delete
  fi
fi
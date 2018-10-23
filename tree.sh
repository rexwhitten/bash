#!/usr/bin/env bash
#
# This script produces a complete tree structure for the directory
# in which it is running.


line="  "
DIRCOLOR="\033[1;34m" # blue
FILECOLOR="\033[0;32m" # green
RST="\033[0;m" # original
rst() { 
  echo -en "$RST"
  echo 
}
rdir() {
  echo -en "$DIRCOLOR$1/"
}
dirStru()
{
  incl='  '
  dname="$1"
  cd "$dname" >/dev/null
  if [ "$?" -eq 0 ]; then
    for k in `ls`; do
      if [[ -d "$k" ]]; then
        echo -en "  $line$(rdir $k)"
        rst
        line=$incl$line
        dirStru "$k"
        cd ..
        #remove smallest prefix pattern(.....)
        line=${line#  }
      elif [[ -f "$k" ]]; then
        echo -en "  $line$FILECOLOR$k"
        rst
      fi
    done
  fi
}

# main
#Tree sub-directory structure under $1 directory"
if [ $# -ne 1 ]; then
  echo "Usage:$(basename $0) <directory-name>"
  exit 1
fi

basedir=`pwd`
rootls=`ls $1`
rootdir=$(basename $1)
echo -en "$(rdir $rootdir)"
rst
for i in $rootls; do
  reldir="$rootdir/$i"
  if [[ -d "$reldir" ]]; then
    echo -en "  $(rdir $i)"
    rst
    dirStru "$reldir"
  elif [[ -f "$reldir" ]]; then
    echo -en "  $FILECOLOR$i"
    rst
  fi
  cd $basedir
done
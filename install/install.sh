#!/bin/sh
#
# Free Pascal installation script for Linux.
# Copyright 1996-2002 Michael Van Canneyt and Peter Vreman
#
# Don't edit this file. 
# Everything can be set when the script is run.
#

# Release Version
VERSION=1.9.2

# some useful functions
# ask displays 1st parameter, and ask new value for variable, whose name is
# in the second parameter.
ask ()
{
askvar=$2
eval old=\$$askvar
eval echo -n \""$1 [$old] : "\" 
read $askvar
eval test -z \"\$$askvar\" && eval $askvar=\'$old\'
}
# yesno gives 1 on no, 0 on yes $1 gives text to display.
yesno ()
{
  while true; do
  echo -n "$1 (Y/n) ? "
  read ans
  case X$ans in
   X|Xy|XY) return 0;;
   Xn|XN) return 1;;
  esac
  done
}

# Untar files ($3,optional) from  file ($1) to the given directory ($2)
unztar ()
{
 tar -xzf $HERE/$1 --directory $2 $3
}

# Untar tar.gz file ($2) from file ($1) and untar result to the given directory ($3)
unztarfromtar ()
{
 tar -xOf $HERE/$1 $2 | tar --directory $3 -xzf -
}

# Make all the necessary directories to get $1
makedirhierarch ()
{
  OLDDIR=`pwd`
  case $1 in
    /*) cd /;;
  esac
  OLDIFS=$IFS;IFS=/;eval set $1; IFS=$OLDIFS
  for i
  do
    test -d $i || mkdir $i || break
    cd $i ||break
  done
  cd $OLDDIR
}

# check to see if something is in the path
checkpath ()
{
 ARG=$1
 OLDIFS=$IFS; IFS=":";eval set $PATH;IFS=$OLDIFS
 for i
 do
   if [ $i = $ARG ]; then
     return 0
   fi
 done 
 return 1
}

# --------------------------------------------------------------------------
# welcome message.
#

clear
echo "This shell script will attempt to install the Free Pascal Compiler"
echo "version $VERSION with the items you select"
echo 

# Here we start the thing.
HERE=`pwd`

# Install in /usr/local or /usr ?
if checkpath /usr/local/bin; then
    PREFIX=/usr/local
else
    PREFIX=/usr
fi
ask "Install prefix (/usr or /usr/local) " PREFIX
makedirhierarch $PREFIX

# Set some defaults.
LIBDIR=$PREFIX/lib/fpc/$VERSION
SRCDIR=$PREFIX/src/fpc-$VERSION
EXECDIR=$PREFIX/bin
OSNAME=`uname -s | tr A-Z a-z`

BSDHIER=0
case $OSNAME in 
*bsd)
  BSDHIER=1;;
esac


if [ "${BSDHIER}" = "1" ]; then
DOCDIR=$PREFIX/share/doc/fpc-$VERSION
else
DOCDIR=$PREFIX/doc/fpc-$VERSION
fi

echo $DOCDIR

DEMODIR=$DOCDIR/examples

# Install compiler/RTL. Mandatory.
echo Unpacking ...
# tar xf binary.tar
echo Installing compiler and RTL ...
unztarfromtar binary.tar base${OSNAME}.tar.gz $PREFIX
rm -f $EXECDIR/ppc386
ln -sf $LIBDIR/ppc386 $EXECDIR/ppc386
echo Installing utilities...
unztarfromtar binary.tar util${OSNAME}.tar.gz $PREFIX
if yesno "Install FCL"; then
    unztarfromtar binary.tar unitsfcl${OSNAME}.tar.gz $PREFIX
fi
if yesno "Install packages"; then
  packages=`tar -tvf binary.tar "units*" | awk '{ print $6 }'`
  for f in $packages 
  do
    if [ $f != unitsfcl${OSNAME}.tar.gz ]; then
      basename $f .tar.gz |\
      sed -e s/units// -e s/${OSNAME}// |\
      xargs echo Installing 
      unztarfromtar binary.tar $f $PREFIX
    fi
  done
fi
rm -f *${OSNAME}.tar.gz
echo Done.
echo

# Install the sources. Optional.
if yesno "Install sources"; then
  echo Unpacking ...
  # tar xf sources.tar
  echo Installing sources in $SRCDIR ...
  unztarfromtar sources.tar  basesrc.tar.gz $PREFIX
  if yesno "Install compiler source"; then
    unztarfromtar sources.tar compilersrc.tar.gz $PREFIX
  fi    
  if yesno "Install RTL source"; then
    unztarfromtar sources.tar rtlsrc.tar.gz $PREFIX
  fi    
  if yesno "Install FCL source"; then
    unztarfromtar sources.tar fclsrc.tar.gz $PREFIX
  fi    
  if yesno "Install IDE source"; then
    unztarfromtar sources.tar idesrc.tar.gz $PREFIX
  fi    
  if yesno "Install installer source"; then
    unztarfromtar sources.tar installersrc.tar.gz $PREFIX
  fi    
  if yesno "Install Packages source"; then
    packages=`tar -tvf sources.tar "units*" | awk '{ print $6 }'`
    for f in $packages
    do
      basename $f .tar.gz |\
      sed -e s/units// -e s/src// |\
      xargs echo Installing sources for 
      unztarfromtar sources.tar $f $PREFIX
    done
  fi    
  # rm -f *src.tar.gz
  echo Done.
fi
echo

# Install the documentation. Optional.
if yesno "Install documentation"; then
  echo Installing documentation in $DOCDIR ...
  unztar docs.tar.gz $PREFIX
  echo Done.
fi
echo

# Install the demos. Optional.
if yesno "Install demos"; then
  ask "Install demos in" DEMODIR
  echo Installing demos in $DEMODIR ...
  makedirhierarch $DEMODIR
  unztar demo.tar.gz $DEMODIR
  echo Done.
fi
echo

# Install /etc/fpc.cfg, this is done using the samplecfg script
$LIBDIR/samplecfg $LIBDIR

# The End
echo
echo End of installation. 
echo
echo Refer to the documentation for more information.
echo

#!/bin/bash

PROGNAME=${0##*/}

usage()
{
  cat << EO
Actualiza fenix brand logos & images para todos os locais apropriados
EO

  cat <<EO | column -s\& -t

  -h          & show this output
  -l          & actualiza brand da loja
EO
}

# default logos & compositions
f1=qa # fenix.3red
f2=qd # logo-dark.2reds
f3=qc # fenix.5cor
f4=qe # fat-logo-dark.2reds

l1=ca # logo-light-red-byfenixdecorare
l2=cb # logo-light-bw-byfenixdecorare
l3=cc # logo-dark-black-tagline

i1=ea # cesto-compras

# operation dirs & output dirs for apps (loja e comunidade)
w="/home/hernani/Documents"
b="$w/fenix-brand/base"
m="$w/fenix-brand/svg"
o="$w/fenix-brand/png"
v="$w/fenix-brand/jpg"
c="$w/fenix-brand/comp"
t="$w/fenix-brand/tmp"
f="$w/fenix-brand/fotos"
g="$w/fenix-brand/fonts"
i="spree/frontend"
j="spree/backend"
h="$w/as3w/fenix/fdbr"
y="$w/as3w/fenix/$i/app/assets/stylesheets/$i"
s="$w/as3w/fenix/$j/app/assets/stylesheets/$j"
z="$h/app/assets"
x="$h/vendor/assets"
n="$z/stylesheets/$i"

SOPTS="h"
LOPTS=""

ARGS=$(getopt -a -o $SOPTS --name $PROGNAME -- "$@")

eval set -- "$ARGS"

while true; do
    case $1 in
    -h)   usage ; exit 0;;
    --)  shift  ; break;;
    *)   shift  ; break;;
    esac
    shift
done

# loja.fenix
if [ ! -d $z/images/logo    ];then mkdir $z/images/logo   ;fi
if [ ! -d $x/images/noimage ];then mkdir $x/images/noimage;fi

# frontend tem svg logo
cp $v/logo-loja-casadosquadros.jpg       $z/images/logo
cp $v/logo-loja-casadosquadros-admin.jpg $z/images/logo
cp $m/logo-loja-casadosquadros.svgz      $z/images/logo
cp $o/product.png                        $x/images/noimage
cp $o/large.png                          $x/images/noimage
cp $o/small.png                          $x/images/noimage
cp $o/mini.png                           $x/images/noimage
cp $o/favicon.ico                        $z/images
cp $o/$f2-????.png                       $z/images
cp $o/$f4-????.png                       $z/images
cp $o/apple-touch-icon.png               $z/images
cp $o/icon_128.gif                       $z/images

# Imagens sem asset controle
cp $o/logo-loja-casadosquadros.png       $h/public
cp $o/$f2-0120.png                       $h/public

# frontend skeleon scss
#l="1,/^ *$"
#sed -n "$l/p" $y/screen.css.scss                        > $x/stylesheets/$i/screen.css.scss
#echo -e "@import 'spree/frontend/variables_override';" >> $x/stylesheets/$i/screen.css.scss
#sed    "$l/d" $y/screen.css.scss                       >> $x/stylesheets/$i/screen.css.scss
#$w/fenix-brand/preppng.sh -d                           >> $x/stylesheets/$i/screen.css.scss
#$w/fenix-brand/preppng.sh -q > $x/stylesheets/$i/_variables_override.scss

# frontend bootstrap scss
$w/fenix-brand/preppng.sh -e > $n/bootstrap_frontend.css.scss

# backend scss
if [ ! -d $x/stylesheets/$j/globals ];then mkdir $x/stylesheets/$j/globals;fi
cp $s/spree_admin.scss          $x/stylesheets/$j
$w/fenix-brand/preppng.sh -n  > $x/stylesheets/$j/globals/_variables_override.scss
$w/fenix-brand/preppng.sh -a >> $x/stylesheets/$j/spree_admin.scss

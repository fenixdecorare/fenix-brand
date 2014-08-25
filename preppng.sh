#!/bin/bash

PROGNAME=${0##*/}

currentsvgcolors()
{
# Color schema baseado no estudo feito em http://colorschemedesigner.com
# representa as cores actuais nos svg obtidas com -f
# [IMPORTANTE] Altere manualmente after -[ce]? para mudar svgs
# [IMPORTANTE] All svg's have to be passed throught:
#              inkscape -l new.svg old.svg (inkscape svg format)
#              the inkscape svg format is necessary for this script
#              the fill:<color> format is used in this script
#              optionaly you can save as plain svg (inkscape gui)

# Numero total de cores no palette fenix (USADO EM TODO SCRIPT)
j=0 
j=`expr $j + 1`;vco[$j]="#333333";dco[$j]="cinza"                                   #c1
j=`expr $j + 1`;vco[$j]="#f7f7f7";dco[$j]="white"                                   #c2
j=`expr $j + 1`;vco[$j]="#dc0000";dco[$j]="660000:h+0.000s+0.000l+0.231"            #c3
j=`expr $j + 1`;vco[$j]="#a10000";dco[$j]="660000:h+0.000s+0.000l+0.116"            #c4
j=`expr $j + 1`;vco[$j]="#660000";dco[$j]="brand-primary"                           #c5
j=`expr $j + 1`;vco[$j]="#006666";dco[$j]="660000:h+0.500s+0.000l+0.000"            #c6
j=`expr $j + 1`;vco[$j]="#999900";dco[$j]="660000:h+0.167s+0.000l+0.100:brand-info" #c7
j=`expr $j + 1`;vco[$j]="#660033";dco[$j]="660000:h+0.917s+0.000l+0.000"            #c8
j=`expr $j + 1`;vco[$j]="#330066";dco[$j]="660000:h+0.750s+0.000l+0.000"            #c9

j=`expr $j + 1`;vco[$j]="#cc9966";dco[$j]="brand-warning"                           #c10
j=`expr $j + 1`;vco[$j]="#006633";dco[$j]="brand-success"                           #c11
j=`expr $j + 1`;vco[$j]="#e45353";dco[$j]="brand-danger"                            #c12

j=`expr $j + 1`;vco[$j]="#cccccc";dco[$j]="333333:h+0.000s+0.000l+0.600:cinza-logo" #c13

}

setschema()
{
r1="Color::RGB.from_html";r2="puts Color::HSL.from_fraction";rb="ruby -r color -e "
h=".to_hsl.h";s=".to_hsl.s";l=".to_hsl.l"

u="c=$r1('${aco[1]}')"
n=`expr $n + 4`;aco[$n]=`$rb"$u;$r2(c$h+0.000,c$s+0.000,c$l+0.600).html"`

}

setschemafenixs()
{
r1="Color::RGB.from_html";r2="puts Color::HSL.from_fraction";rb="ruby -r color -e "
h=".to_hsl.h";s=".to_hsl.s";l=".to_hsl.l"

u="c=$r1('$c_fenix')"
n=`expr $n - 2`;aco[$n]=`$rb"$u;$r2(c$h+0.000,c$s+0.000,c$l+0.231).html"`
n=`expr $n + 1`;aco[$n]=`$rb"$u;$r2(c$h+0.000,c$s+0.000,c$l+0.116).html"`
n=`expr $n + 1`;aco[$n]="$c_fenix"
n=`expr $n + 1`;aco[$n]=`$rb"$u;$r2(c$h+0.500,c$s+0.000,c$l+0.000).html"`
n=`expr $n + 1`;aco[$n]=`$rb"$u;$r2(c$h+0.167,c$s+0.000,c$l+0.100).html"`
n=`expr $n + 1`;aco[$n]=`$rb"$u;$r2(c$h+0.917,c$s+0.000,c$l+0.000).html"`
n=`expr $n + 1`;aco[$n]=`$rb"$u;$r2(c$h+0.750,c$s+0.000,c$l+0.000).html"`
}

getschema()
{
#u="$u;(o.round(2) == s.round(2)) ? '' : l+'%+.3f' % ((o-s))"
r1="Color::RGB.from_html"
r2="puts Color::HSL.from_fraction"
u=""
u="$u;def fz(o,s,l)"
u="$u;l+'%+.3f' % (o-s)"
u="$u;end"
u="$u;co=$r1('$1');cs=$r1('$2')"
u="$u;puts co.html+':'+cs.html+':j=\`expr \$j + 1\`;vco[\$j]=\"'"
u="$u+co.html+'\";dco[\$j]=\"'+cs.html[1,6]+':'"
u="$u+fz(co.to_hsl.h,cs.to_hsl.h,'h')"
u="$u+fz(co.to_hsl.s,cs.to_hsl.s,'s')"
u="$u+fz(co.to_hsl.l,cs.to_hsl.l,'l')+'\"'"
u="$u;puts co.html+':'+cs.html+':n=\`expr \$n + 1\`;aco[\$n]=\`\$rb\"\$u;\$r2('"
u="$u+'c$'+fz(co.to_hsl.h,cs.to_hsl.h,'h')+','"
u="$u+'c$'+fz(co.to_hsl.s,cs.to_hsl.s,'s')+','"
u="$u+'c$'+fz(co.to_hsl.l,cs.to_hsl.l,'l')+').html\"\`'"
ruby -r color -e "$u"
}

showcoldest()
{
getschema "#`echo $1|cut -d":" -f1`" "#`echo $1|cut -d":" -f2`"
}

arraypalette()
{
a="";n=1;rm -f grep$$
while [ $n -le $j ]
do p=`echo ${vco[$n]}|cut -c2-`
   a=",\"$p\"$a"
   echo $p >> grep$$
   n=`expr $n + 1`
done
a=`echo $a|cut -c2-`
}

similarsvgcolor()
{

k=`fgrep -i fill:# $1|fgrep -ivf grep$$|sed -e 's%.*fill:#\(......\).*%,"\1"%g'|sort -u`
k=`echo $k|cut -c2-|sed -e 's% %%g'`

#u="$u;(o.round(2) == s.round(2)) ? '' : l+'%.0f' % ((o*100)-(s*100))"
#u="$u;(o.round(2) == s.round(2)) ? '' : l+'o%.0f' % (o)+l+'s%.0f' % (s)"
#u="$u;(o.round(2) == s.round(2)) ? '' : l+'s%.2f' % (s)+l+'o%.2f' % (o)"
#u="$u;(o.round(2) == s.round(2)) ? '' : l+'%+.3f' % ((o-s))"
w="Paleta::Color.new(:hex"
z="Color::RGB.from_html("
u=""
u="$u;a=[$a]"
u="$u;k=[$k]"
u="$u;def sc(c,v)"
u="$u;b=v.map { |t| { k: t, sm: $w,t).similarity($w,c)) } }"
u="$u;r=b.reject { |t| t[:sm] > $m }"
u="$u;r.sort { |a,b| a[:sm] <=> b[:sm] }[0]"
u="$u;end"
u="$u;def fz(o,s,l)"
u="$u;l+'%+.3f' % (o-s)"
u="$u;end"
u="$u;f=k.map { |m| r=sc(m,a); { o: m, s: r ? r[:k] : nil, sm: r ? r[:sm] : nil } }"
u="$u;s=f.reject { |m| m[:sm].nil? }"
u="$u;n=f.reject { |m| !m[:sm].nil? }"
u="$u;s.sort! { |a,b| a[:sm] <=> b[:sm] }"
u="$u;s.each  { |m| co=${z}m[:o]);cs=${z}m[:s])"
u="$u;puts m[:o]+':'+m[:s]+'|'"
u="$u+fz(co.to_hsl.h,cs.to_hsl.h,'h')"
u="$u+fz(co.to_hsl.s,cs.to_hsl.s,'s')"
u="$u+fz(co.to_hsl.l,cs.to_hsl.l,'l')"
u="$u+'sm%.2f' % m[:sm]"
u="$u }"
u="$u;n.each  { |m| puts m[:o]+':'+'nao' }"
q=`ruby -r paleta -r color -e "$u"`
rs=""
rn=""
for u in $q
do if [ -z "`echo $u|fgrep nao`" ];then rs="$rs $u";else rn="$rn $u";fi
done
}

simreport()
{
arraypalette

echo "Similatiry report in $b"
for f in `ls $b`
do similarsvgcolor $b/$f
   echo "$f `echo $rs|wc -w` similar, `echo $rn|wc -w` unmatched colors"
done

echo "Similatiry report in $c"
for f in `ls $c`
do similarsvgcolor $c/$f
   echo "$f `echo $rs|wc -w` similar, `echo $rn|wc -w` unmatched colors"
done

rm -f grep$$
}

optsvgs()
{
echo "Optimize svgs in $b"
for f in `ls $b`
do ts=`date "+%Y%m%d%H%M%S"`
   echo "Processar $f backup saved in $i/s$ts-$f"
   cp $b/$f $i/s$ts-$f
   inkscape -l $b/$f $i/s$ts-$f
done

echo "Optimize svgs in $c"
for f in `ls $c`
do ts=`date "+%Y%m%d%H%M%S"`
   echo "Processar $f backup saved in $i/s$ts-$f"
   cp $c/$f $i/s$ts-$f
   inkscape -l $c/$f $i/s$ts-$f
done
}

matchscript()
{
arraypalette;similarsvgcolor $1;rm -f grep$$
for u in $rs
do u1=`echo $u|cut -d"|" -f1`
   showcoldest $u1
done|sort -t : -k 3.1,3.2 -k 2,2 -k 1,1
}

matchedlist()
{
arraypalette;similarsvgcolor $1;rm -f grep$$
for u in $rs
do u1=`echo $u|cut -d":" -f1`
   u2=`echo $u|cut -d":" -f2`
   u3=`fgrep -i "fill:#$u1" $1|wc -l`
   u4=`echo $u2|cut -d"|" -f1`
   u5=`echo $u2|cut -d"|" -f2`
   echo "<h1 style=\"background-color:#$u1;color:#$u4\">$u1:$u4:$u5:`printf '%03d' $u3`</h1>"
done
}

unmatchedlist()
{
arraypalette;similarsvgcolor $1;rm -f grep$$
for u in $rn
do u1=`echo $u|cut -d":" -f1`
   echo "<h1 style=\"background-color:#$u1;\">$u1</h1>"
done
}

simchange()
{
arraypalette;similarsvgcolor $1;rm -f grep$$
n=0
for u in $rs
do u1=`echo $u|cut -d":" -f1`
   u2=`echo $u|cut -d":" -f2|cut -c1-6`
   echo "s%fill:#$u1%fill:#$u2%g" >>sed$$
   n=`expr $n + 1`
done
if [ $n -gt 0 ]
then echo "$n altercoes de cor"
     bn=`basename $1`
     sed -f sed$$ $1 >$i/z$$-$bn
     cp $1 $i/s`date "+%Y%m%d%H%M%S"`-$bn
     mv $i/z$$-$bn $1
else echo "$n similar colors"
fi
echo "`echo $rn|wc -w` unmatched colors"
rm -f sed$$
}

simback()
{
bn=`basename $1`
u=`ls $i/s[0-9][0-9]*-$bn|cut -d"/" -f2|cut -c2-|sort -nr|head -1`
if [ -n "$u" ]
then echo "Recuprar $i/s$u para $1"
     cp $i/s$u $1
     rm $i/s$u
else echo "Nao existe recuperacao para $1 em $i"
fi
}

valcor()
{
# valida pedidos de alteracao de cores
# $1=cor pedida
# $2=arquivo cor
# $3=descretivo cor
if [ "$1" != "$2" ];then
 ta=1 #cor foi alterada
 if [ `echo -n "$1"|wc -m` -ne 7 ];then
  echo "$3 invalida tamanho<>7 $1"
  exit 1
 else
  rt="puts Color::RGB.from_html('$1')"
  vh=`ruby -r color -e "$rt.html"`
  if [ `echo -n "$vh"|wc -m` -ne 7 -o $vh != $1 ];then
   echo "$3 invalida SET=$1 RGB=$vh"
   exit 1
  fi
 fi
fi
}

valpal()
{
# validar other colors aco[01-02,05,06-08]
n=0
n=`expr $n + 1`;valcor ${aco[$n]} ${vco[$n]} ${dco[$n]}
n=`expr $n + 1`;valcor ${aco[$n]} ${vco[$n]} ${dco[$n]}
n=`expr $n + 3`;valcor $c_fenix   ${vco[$n]} ${dco[$n]}

# Obter schema cores calculadas 
setschemafenixs
setschema
}

usage()
{
  cat << EO
Cria fenix brand logos & images
EO

  cat <<EO | column -s\& -t

  -h          & show this output
  -f          & show current fill   colors for all svgs
  -s          & show current stroke colors for all svgs
  -p          & show internal palette
  -r          & show similarity report
  -q          & show frontend-variables-skeleton.scss
  -e          & show frontend-variables-bootstrap.scss
  -d          & show frontend-fenix-skeleton.scss
  -n          & show backend.variables.scss
  -a          & show backend.fenix.scss
  -opt        & [IMPORTANTE] optimize svgs - deve ser feito antes novos svgs
  -o des:ori  & show color des values obtained from color ori
  -l limit    & set limit for similarity (default $m)
  -c svg      & change similar  colors
  -m svg      & show matched    color list (html   format)
  -t svg      & show matched    color list (script format)
  -u svg      & show unmatched  color list 
  -b svg      & go back to last change similarity colors
  -f1-3 svg   & change brand base svgs
  -l1-2 svg   & change brand compositions svgs
  -i1   svg   & change brand svg  for cesto compras
EO
}

showcolors()
{
# mostra cores actualmente nos svgs
echo
echo "Current colors in $b"
for f in `ls $b`
do ac=`grep -i "$1:#" $b/$f|sed -e "s%.*$1:#\(......\).*%\1%g"|sort -u`
   if [ -n "$ac" ];then echo $f $ac;fi
done
echo
echo "Current colors in $c"
for f in `ls $c`
do ac=`grep -i "$1:#" $c/$f|sed -e "s%.*$1:#\(......\).*%\1%g"|sort -u`
   if [ -n "$ac" ];then echo $f $ac;fi
done
}

showpalette()
{
valpal
n=1
while [ $n -le $j ]
do a="<h1 style=\"background-color:${vco[$n]};\">"
   echo "$a`printf '%03d' $n`-a${aco[$n]}:v${vco[$n]}:${dco[$n]}</h1>"
   if [ "${aco[$n]}" != "${vco[$n]}" ]
   then getschema "${vco[$n]}" "#`echo ${dco[$n]}|cut -d":" -f1`"
   fi
   n=`expr $n + 1`
done
}

frontend-variables-skeleton()
{
valpal

# Para calcular rgb decimais
#r5=`echo ${vco[5]}|cut -c2-3|tr '[:lower:]' '[:upper:]'`
#g5=`echo ${vco[5]}|cut -c4-5|tr '[:lower:]' '[:upper:]'`
#b5=`echo ${vco[5]}|cut -c6-7|tr '[:lower:]' '[:upper:]'`
#dr5=`echo "ibase=16; $r5"|bc`
#dg5=`echo "ibase=16; $g5"|bc`
#db5=`echo "ibase=16; $b5"|bc`

cat << EOF

\$c_green:                   ${vco[5]};
\$c_red:                     ${vco[12]};

\$layout_background_color:   lighten(\$c_green, 80);
\$title_text_color:          ${vco[7]};
\$body_text_color:           ${vco[1]};
\$link_text_color:           \$c_green;

\$product_background_color:  ${vco[2]};
\$product_title_text_color:  ${vco[6]};
\$product_body_text_color:   ${vco[1]};
\$product_link_text_color:   \$c_green;

\$border_color:              lighten(\$body_text_color, 60);
\$default_border:            1px solid \$border_color;
\$button_border_color:       \$link_text_color;
\$table_head_color:          lighten(\$body_text_color, 60);

EOF

}

frontend-variables-bootstrap()
{
valpal

cat << EOF

\$icon-font-path: "../../bootstrap/";

\$brand-primary:      ${vco[5]};
\$brand-success:      ${vco[5]};
\$brand-info:         ${vco[7]};
\$brand-warning:      ${vco[10]};
\$brand-danger:       ${vco[12]};
\$brand-red3:         ${vco[3]};

\$btn-default-bg:     ${vco[5]};
\$btn-default-color:  ${vco[1]};

\$btn-default-border: \$btn-default-bg;
\$btn-primary-border: \$brand-primary;
\$btn-success-border: \$brand-success;
\$btn-info-border:    \$brand-info;
\$btn-warning-border: \$brand-warning;
\$btn-danger-border:  \$brand-danger;

\$border-radius-base:  2px;
\$border-radius-large: 4px;
\$border-radius-small: 1px;

\$font-family-sans-serif: "Ubuntu", sans-serif;
\$font-family-serif:      "Ubuntu", serif;
\$font-family-monospace:  "Ubuntu Mono", monospace;

@import "bootstrap";

@mixin fenix-button-variant(\$cor) {
  &:hover,
  &:focus,
  &:active,
  &.active,
  .open > &.dropdown-toggle {
    background-color: \$cor;
    border-color: \$cor;
  }
  .badge {
    background-color: \$cor;
  }
}
.btn-default {
  @include fenix-button-variant(\$brand-red3);
}
.btn-primary {
  @include fenix-button-variant(\$brand-red3);
}
.btn-success {
  @include fenix-button-variant(\$brand-red3);
}

#spree-header {
  margin-bottom: \$line-height-computed;
}
#spree-footer {
  margin-top: \$line-height-computed;
}
.progress-steps {
  margin-top: \$line-height-computed;
}
EOF

}

frontend-fenix-skeleton()
{
valpal

cat << EOF

input[type="submit"], input[type="button"],
input[type= "reset"], button, a.button {
 border: none;
 padding: 6px 10px 6px;
 vertical-align:  center;

 -webkit-border-radius: 2px;
  -khtml-border-radius: 2px;
    -moz-border-radius: 2px;
     -ms-border-radius: 2px;
      -o-border-radius: 2px;
         border-radius: 2px;

 &:hover {
  background-color: ${vco[3]};
 }
}

a {
 &:hover {
  color: ${vco[3]};
 }
}

nav #main-nav-bar {
 li {
  &#link-to-cart {
   a {
    &:hover {
     color: ${vco[3]};
    }
   }
  }
 }
}
EOF

}

backend-variables()
{
valpal

cat << EOF

\$color-1:              ${vco[2]}; // c2-white
\$color-2:              ${vco[6]}; // c6
\$color-3:              ${vco[3]}; // c3-red3
\$color-4:              ${vco[5]}; // c5-base
\$color-5:              ${vco[4]}; // c4-red4
\$color-6:              ${vco[7]}; // c7-info

// Body base colors
\$color-body-bg:        \$color-1;
\$color-body-text:      ${vco[1]}; // c1-cinza
\$color-headers:        \$color-6;
\$color-link:           \$color-4;
\$color-link-hover:     \$color-3;
\$color-link-active:    \$color-4;
\$color-link-focus:     \$color-4;
\$color-link-visited:   \$color-3;
\$color-border:         very-light(\$color-4, 12);

// Basic flash colors
\$color-success:        ${vco[11]};
\$color-notice:         ${vco[10]};
\$color-error:          ${vco[12]};

// Table colors
\$color-tbl-odd:        \$color-1;
\$color-tbl-even:       very-light(\$color-4, 4);
\$color-tbl-thead:      very-light(\$color-4, 4);

// Button colors
\$color-btn-bg:         \$color-4;
\$color-btn-text:       \$color-1;
\$color-btn-hover-bg:   \$color-3;
\$color-btn-hover-text: \$color-1;

// Select2 select field colors
\$color-sel-bg:         \$color-4;
\$color-sel-text:       \$color-body-text;
\$color-sel-hover-bg:   \$color-3;
\$color-sel-hover-text: \$color-body-text;

// Text inputs colors
\$color-txt-brd:        lighten(\$color-body-text, 60);
\$color-txt-text:       \$color-body-text;
\$color-txt-hover-brd:  \$color-4;

EOF

}

backend-fenix()
{
valpal

cat << EOF

// Fenix some color changes
#admin-menu {
  background-color: \$color-4;
  li {
    a {
      color: \$color-1 !important;
      &:hover {
        background-color: \$color-3;
        &:after {
          border-top: 5px solid \$color-3;
        }
      }
    }
    .dropdown {
      background-color: \$color-3;
    }
    &.selected a {
      @extend a:hover;
    }
  }
}

#sub-menu {
  background-color: lighten(\$color-4, 10);
  li {
    a {
      color: \$color-1 !important;
    }
    &.selected a, a:hover {
      background-color: \$color-3;
      &:after {
        border-top: 5px solid \$color-3;
      }
    }
  }
}

EOF

}

proccolors()
{
# troca de cores nos svgs: proccolors ${aco[$n]} ${vco[$n]} ${dco[$n]}
if [ $1 != $2 -a -n "`echo $lb $lc|grep -i $2`" ];then 
 if [ -n "`echo $lb|grep -i $2`" -a -z "`echo $lb|grep -i $1`" ];then
  echo "processar $b/*.svg for $3=$2 CHANGED to $1"
  for f in `ls $b`
  do lf=`grep -i fill:# $b/$f|sed -e 's%.*fill:\(#......\).*%\1%g'|sort -u`
     if [ -n "`echo $lf|grep -i $2`" -a -z "`echo $lf|grep -i $1`" ];then
       echo "$b/$f    ALTERADO";fc=`expr $fc + 1`
       sed -e "s%fill:$2%fill:$1%g" $b/$f >$b/z$f;mv $b/$f $i;mv $b/z$f $b/$f
     else if [ -n "`echo $lf|grep -i $1`" ];then
            echo "$b/$f NAOALTERADO alredy has $1"
          fi
     fi
  done
 else if [ -n "`echo $lb|grep -i $1`" ];then
        echo "$b/*.svg nao processados for $3 alredy have $1"
      fi
 fi
 if [ -n "`echo $lc|grep -i $2`" -a -z "`echo $lc|grep -i $1`" ];then
  echo "processar $c/*.svg for $3=$2 CHANGED to $1"
  for f in `ls $c`
  do lf=`grep -i fill:# $c/$f|sed -e 's%.*fill:\(#......\).*%\1%g'|sort -u`
     if [ -n "`echo $lf|grep -i $2`" -a -z "`echo $lf|grep -i $1`" ];then
       echo "$c/$f    ALTERADO";fc=`expr $fc + 1`
       sed -e "s%fill:$2%fill:$1%g" $c/$f >$c/z$f;mv $c/$f $i;mv $c/z$f $c/$f
     else if [ -n "`echo $lf|grep -i $1`" ];then
            echo "$c/$f NAOALTERADO alredy has $1"
          fi
     fi
  done
 else if [ -n "`echo $lc|grep -i $1`" ];then
        echo "$c/*.svg nao processados for $3 alredy have $1"
      fi
 fi
fi
}

# default logos & compositions
f1=qa # fenix.3red
f2=qd # logo-dark.2reds
f3=qc # fenix.5cor

l1=ca # logo-light-red-byfenixdecorare
l2=cb # logo-light-bw-byfenixdecorare
l3=cc # logo-dark-black-tagline

i1=ea # cesto-compras

# operation dirs
b=base
i=svg
o=png
c=comp
t=tmp

# obter cores actuais nos svgs para processar alteracao
# aco[03-09] calculadas a partir de c_fenix
# aco[13]    calculadas a partir de vco[1] sinza
currentsvgcolors
c_fenix=${vco[5]}
aco[1]=${vco[1]}
aco[2]=${vco[2]}
aco[10]=${vco[10]}
aco[11]=${vco[11]}
aco[12]=${vco[12]}
# teste pedidos alteracao de cor
ta=0
as=adjust_saturation
ab=adjust_brightness
# valor max em que uma cor e considereda similar
m="0.1"

SOPTS="hfsprqednao:l:c:m:t:u:b:"
LOPT1="f1:,f2:,f3:"
LOPT2="l1:,l2:"
LOPT3="i1:"
LOPTS="opt,$LOPT1,$LOPT2,$LOPT3"

ARGS=$(getopt -a -o $SOPTS -l $LOPTS --name $PROGNAME -- "$@")

eval set -- "$ARGS"

while true; do
    case $1 in
    -h)   usage                       ; exit 0;;
    -f)   showcolors fill             ; exit 0;;
    -s)   showcolors stroke           ; exit 0;;
    -p)   showpalette                 ; exit 0;;
    -r)   simreport                   ; exit 0;;
    -q)   frontend-variables-skeleton ; exit 0;;
    -e)   frontend-variables-bootstrap; exit 0;;
    -d)   frontend-fenix-skeleton     ; exit 0;;
    -n)   backend-variables           ; exit 0;;
    -a)   backend-fenix               ; exit 0;;
    -o)   showcoldest $2              ; exit 0;;
    -l)   m=$2                        ; shift;;
    -c)   simchange $2                ; exit 0;;
    -m)   matchedlist $2              ; exit 0;;
    -t)   matchscript $2              ; exit 0;;
    -u)   unmatchedlist $2            ; exit 0;;
    -b)   simback $2                  ; exit 0;;
   --opt) optsvgs                     ; exit 0;;
    --f1) f1=$2; shift;;
    --f2) f2=$2; shift;;
    --f3) f3=$2; shift;;

    --l1) l1=$2; shift;;
    --l2) l2=$2; shift;;

    --i1) i1=$2; shift;;

    --)   shift; break;;
    *)    shift; break;;
    esac
    shift
done

# validar pelette cores
valpal

# valcor verificou validade e pedidos de alteracao de cores
# se houve pedido de alteraco de cores os svg sao processados
if [ $ta -eq 1 ]
then 

# listas globais nos svg base, comp
lb=`grep -i fill:# $b/*.svg|sed -e 's%.*fill:\(#......\).*%\1%g'|sort -u`
lc=`grep -i fill:# $c/*.svg|sed -e 's%.*fill:\(#......\).*%\1%g'|sort -u`

# processamento de cores novas nos svgs
fc=0
n=1
while [ $n -le $j ]
do proccolors ${aco[$n]} ${vco[$n]} ${dco[$n]};n=`expr $n + 1`
done

if [ $fc -gt 0 ]
then echo "[IMPORTANTE] Altere variaveis em currentsvgcolors com cores alteradas"
else echo "Foi pedida uma alteracao de schema de cores mas nenhuma alteracao foi necessaria"
fi
     
fi

echo "Basic color palette for fenix"
r1="puts Color::RGB.from_html('$c_fenix')"
echo "`ruby -r color -e \"$r1.css_hsl\"`;`ruby -r color -e \"$r1.css_rgb\"`"
# Diaspora pod needs apple-touch-icon.png,icon_128.gif,favicon.ico
rsvg-convert -h 16   -a -f png $b/$f2.svg -o $o/$f2-0016.png
rsvg-convert -h 32   -a -f png $b/$f2.svg -o $o/$f2-0032.png
rsvg-convert -h 48   -a -f png $b/$f2.svg -o $o/$f2-0048.png
rsvg-convert -h 64   -a -f png $b/$f2.svg -o $o/$f2-0064.png
rsvg-convert -h 75   -a -f png $b/$f2.svg -o $o/$f2-0075.png # facebook app
rsvg-convert -h 120  -a -f png $b/$f2.svg -o $o/$f2-0120.png # google OAuth
rsvg-convert -h 128  -a -f png $b/$f2.svg -o $o/$f2-0128.png
rsvg-convert -h 180  -a -f png $b/$f2.svg -o $o/$f2-0180.png # facebook profile needs this
rsvg-convert -h 256  -a -f png $b/$f2.svg -o $o/$f2-0256.png
rsvg-convert -h 256  -a -f png $b/$f2.svg -o $o/$f2-0256.png 
rsvg-convert -h 600  -a -f png $b/$f1.svg -o $o/$f1-0600.png # foto id da fenix decorare
rsvg-convert -h 1024 -a -f png $b/$f2.svg -o $o/$f2-1024.png 
convert -background ${aco[5]} $b/qb.svg -thumbnail 200x200 $o/apple-touch-icon.png
convert -background none -bordercolor none $b/$f2.svg -thumbnail 200x200 -border 50x50 $o/$f2-gpp.png
convert -background none -bordercolor none $b/$f1.svg -thumbnail 500x500 -border 50x50 $o/$f1-fid.png
convert -background none $b/$f2.svg -thumbnail 128x128 $o/icon_128.gif
convert $o/$f2-0016.png $o/$f2-0032.png $o/$f2-0048.png \
        $o/$f2-0064.png $o/$f2-0128.png $o/$f2-0256.png \
        $o/favicon.ico

# Logos redes sociais x32
rsvg-convert -h 24 -a -f png $c/sf.svg  -o $o/sf.png
rsvg-convert -h 24 -a -f png $c/sg.svg  -o $o/sg.png
rsvg-convert -h 24 -a -f png $c/sl.svg  -o $o/sl.png
rsvg-convert -h 24 -a -f png $c/st.svg  -o $o/st.png
rsvg-convert -h 24 -a -f png $c/sy.svg  -o $o/sy.png

# Composicoes loja used by spree 176x82  
rsvg-convert -h 82 -a      -f png $c/$l3.svg -o $o/logo-loja-casadosquadros.png
rsvg-convert -h 40 -a      -f png $c/$l3.svg -o $o/logo-loja-casadosquadros-admin.png
rsvg-convert               -f png $b/$i1.svg -o $o/cart.png
# Composicao google-api-logo  max120x60
#rsvg-convert -w 119 -a     -f png $c/$l3.svg -o $o/$l3-ga.png
# Composicoes loja used by spree noimage
clet=${aco[7]}
rsvg-convert -a     -h 240 -f png $b/$f1.svg -o $t/$f1-pr.png
./preplet.sh imagem la t240 h120 $clet
./preplet.sh "não existe" la t240 h120 $clet
convert $o/panão_existe.png $o/paimagem.png \
	-gravity center -append $t/pr.png
composite -dissolve 25% -gravity center \
        $t/$f1-pr.png  $t/pr.png $o/product.png 
composite -dissolve 25% -gravity center \
        $t/$f1-pr.png  $t/pr.png $o/large.png 
rsvg-convert -a     -h 100 -f png $b/$f1.svg -o $t/$f1-pr.png
./preplet.sh imagem la t100 h50 $clet
./preplet.sh "não existe" la t100 h50 $clet
convert $o/panão_existe.png $o/paimagem.png \
	-gravity center -append $t/pr.png
composite -dissolve 25% -gravity center \
        $t/$f1-pr.png  $t/pr.png $o/small.png 
rsvg-convert -a     -h 48  -f png $b/$f1.svg -o $t/$f1-pr.png
./preplet.sh imagem la t48 h24 $clet
./preplet.sh "não existe" la t48 h24 $clet
convert $o/panão_existe.png $o/paimagem.png \
	-gravity center -append $t/pr.png
composite -dissolve 25% -gravity center \
        $t/$f1-pr.png  $t/pr.png $o/mini.png 
rm $o/paimagem.png $o/panão_existe.png

# Composição access report x400
rsvg-convert -h 400 -a      -f png $c/$l2.svg -o $o/$l2-go.png
convert $o/$l2-go.png -background white -flatten $o/$l2-go.jpg
rm $o/$l2-go.png

exit

# Composição google+,paginas, min(480x270)
rsvg-convert -w 480 -h 270 -f png $c/$l1.svg -o $o/$l1-gpp.png


# Composição google Enterprise 143x59 
rsvg-convert                -f png $c/$l1.svg -o $o/$l1-ge.png

# Composicoes facebook 
#  capa-min720x 
#  banners f1=155x100 f2=800x150 opcionais f2=180x115 f4=394x150 
rsvg-convert -w 722 -a      -f png $c/$l1.svg -o $o/$l1-fb.png

# Composicao twitter capa-1252x626 fundo-1000
rsvg-convert -w 1252 -h 626 -f png $c/$l1.svg -o $o/$l1-tw.png
rsvg-convert -w 1000 -a     -f png $b/$t1.svg -o $o/$t1-tw.png

# Composicao flickr-api-logo 300x90 max600x300
convert -background none $c/$l2.svg -thumbnail 396x90 $o/$l2-fl.gif

# Composicao youtube channel 
#tv      2120x1192
#desktop 2120x350
#tablet  1536x350
#mobile  1280x350
rsvg-convert               -f png $c/$l3.svg -o $t/$l3-yt.png
convert $t/$l3-yt.png -background white -flatten $o/$l3-yt.jpg

# Composicao logo comunidade navbar tem x50 
# com estes -h da x46 em ambos png,svg
rsvg-convert -a -h 46  -f png $c/$l1.svg -o $o/cfpt-logo.png
rsvg-convert -a -h 37  -f svg $c/$l1.svg -o $t/cfpt-logo.svg
./css.rb $t/cfpt-logo.svg       > $i/cfpt-logo.svg

# Composicao blog x200
#rsvg-convert -h 200 -a     -f png $c/$l2.svg -o $t/$l2-bl.png
#convert $t/$l2-bl.png -background white -flatten $o/bg1.jpg

# Composicao botoes doar fenix 80x64, paypal 73x26 
rsvg-convert               -f png $c/$l4.svg -o $o/$l4-doar.png
rsvg-convert               -f png $c/$l5.svg -o $o/$l5-doar.png

pa=${1-fenix}     # palavra
ty=${2-la}        # tipo letra
fx=${3-x1}        # x=escala;w=with;t=with palavra
fy=${4-y1}        # y=escala;h=hight
co=${5-'#000000'} # cor  letra

if [ $co = "#000000" ]
then c=""
else c="-fuzz 100% -fill $co -opaque #000000"
fi

pa=`echo $pa|sed 's% %_%g'`

i=letras
o=png
t=tmp
q=`echo $ty|cut -c2`

# Obter total with da palavra
if [ `echo $fx|cut -c1` = t ]
then n=1
     w=0
     l=`echo $pa|wc -m`
     while [ $n -lt $l ]
     do p=`echo $pa|cut -c$n`
        if [ "`echo $p|od|head -1|cut -d" " -f2`" = "005303" ]
        then nn=`expr $n + 1`
             p=`echo $pa|cut -c$n-$nn`
             l=`expr 1 + $l`
             n=`expr 2 + $n`
        else n=`expr 1 + $n`
        fi
        f=`echo $p|od|head -1|cut -d" " -f2`
        s=`grep width $i/$ty$f.svg|sed 's%^.*width *= *"\([0-9][0-9]*\).*$%\1%'`
        w=`expr $w + $s`
     done
     s=`grep height $i/$ty$f.svg|sed 's%^.*height *= *"\([0-9][0-9]*\).*$%\1%'`
     cx=`echo $fx|cut -c2-`
     cy=`echo $fy|cut -c2-`
     fx="-x `echo "$cx/$w"|bc -l`"
     fy="-y `echo "$cy/$s"|bc -l`"
else fx="-`echo $fx|cut -c1` `echo $fx|cut -c2-`"
     fy="-`echo $fy|cut -c1` `echo $fy|cut -c2-`"
fi


n=1
g=""
l=`echo $pa|wc -m`
while [ $n -lt $l ]
do p=`echo $pa|cut -c$n`
   if [ "`echo $p|od|head -1|cut -d" " -f2`" = "005303" ]
   then nn=`expr $n + 1`
        p=`echo $pa|cut -c$n-$nn`
        l=`expr 1 + $l`
        n=`expr 2 + $n`
   else n=`expr 1 + $n`
   fi
   f=`echo $p|od|head -1|cut -d" " -f2`
   rsvg-convert $fx $fy -f png $i/$ty$f.svg -o $t/$ty$f.png
   g="$g $t/$ty$f.png"
done

convert $g $c -gravity south +append -thumbnail ${cx}x${cy} $o/p$q$pa.png

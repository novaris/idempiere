#!/bin/bash
file=navRed
width=56
height=56
mkdir tmp
rm ./tmp/*.png
for n in `seq 1 360` 
do
   convert $file.png -background none \
    -gravity center -compose Src \
    \( -clone 0 -rotate $n -clone 0 +swap -composite \) \
     ./tmp/$file-$n.png
done
rm ./tmp/*-0.png
rename 's/\-1.png$/\.png/' ./tmp/*.png

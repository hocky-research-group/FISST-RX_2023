#!/bin/bash
outdir=$1
nrep=$2
plumed_template=$3
replicate=1

label=$(basename $plumed_template | cut -f 1 -d '.')

dirlist=$(for i in `seq 1 $nrep`;do j=$(echo $i-1 | bc); lambda_dir=$outdir/lambda${j};echo $lambda_dir; done)

steps=$(cat $outdir/*progress*)

outputprefix=${label}_rep${replicate}
full_out_prefix=${outputprefix}.run.${steps}

echo $full_out_prefix $outdir

j=0
for i in $dirlist
do
	mv $i/${full_out_prefix}.observable.${j}.txt $i/${full_out_prefix}.observable.txt
	mv $i/${full_out_prefix}.restart.${j}.txt $i/${full_out_prefix}.restart.txt
	mv $i/${full_out_prefix}.colvar.${j}.txt $i/${full_out_prefix}.colvar.txt
j=$(($j+1))
done


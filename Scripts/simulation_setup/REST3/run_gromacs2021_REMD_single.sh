#!/bin/bash
scriptdir=$(cd $(dirname $0);pwd)

prefix=$1
outdir=$2
nrep=$3
plumed_template=$4
force=$5
time_in_ns=$6

if [ -z "$time_in_ns" ];then
echo "Usage: $0 tprfile outprefix time_in_ns plumedtemplate (gmxexe)"
exit
fi

set -x

source /scratch/work/hockygroup/software/gromacs-2019.6-plumedSept2020/bin/GMXRC.bash.modules
export NOMP=$SLURM_CPUS_PER_TASK
#export NMPI=$SLURM_NTASKS
gmxexe=gmx_mpi

#fi

module load python/intel/3.8.6
#dirlist=$(python $scriptdir/gen_directory_list.py $outdir/ $nrep)

dirlist=$(for i in `seq 1 $nrep`;do j=$(echo $i-1 | bc); lambda_dir=$outdir/lambda${j};echo $lambda_dir; done)

timestep=2 #fs
steps=$(echo $time_in_ns*1000000/$timestep |bc)

progressfile=${outdir}/${prefix}.progress.txt
echo $progressfile

# next line returns 0 even if file not found
prgtmp=$(cat $progressfile)
if [ -z "$prgtmp" ];then
    prevsteps=0
else
    prevsteps=$prgtmp
    extraflags="-noappend"
fi
#prevsteps=$(echo $(cat $progressfile)|bc) 
newsteps=$(($prevsteps+$steps))
outprefix_old=${prefix}.run.$prevsteps
outprefix_new=${prefix}.run.$newsteps

if [ "$prevsteps" -gt 0 ];then
    continuestring="-cpi $outprefix_old.cpt "
else
    continuestring=""
fi


for i in `seq 1 $nrep`;
do
	j=$(echo $i-1 | bc)
	lambda_dir=$outdir/lambda${j}
        cp $plumed_template $lambda_dir/pull_plumed.dat
done


plumedstring="-plumed pull_plumed.dat"

#echo $outprefix_old
#echo $outprefix_new
#echo $continuestring
#echo $extraflags

#mpirun -np $N_replicas 
#mpirun -np 10
#srun run-gromacs-plumed.bash \
srun $gmxexe mdrun -s $prefix.tpr -multidir $dirlist -ntomp $nrep -hrex -replex 2500 -reseed $RANDOM -nsteps $steps -deffnm ${outprefix_new} $continuestring $plumedstring $extraflags 
 
for i in `seq 1 $nep`;
do 
	j=$(echo $i-1 | bc)
	lambda_dir=$outdir/lambda${j}
	#mkdir $i/TEMP
	#cp $i/** $i/TEMP
	
	grofile=$(ls $lambda_dir/*.gro | grep -v bench |sort -n -k3 -t '.'| tail -n 1)
        finalnum=$(ls $lambda_dir/*.gro | grep -v bench |sort -n -k3 -t '.'| tail -n 1|awk -F '.' '{print $(3)}')

	if [ -e "$grofile" ];then
		echo $finalnum > $progressfile
	else 
		echo No new gro file!
	fi
done

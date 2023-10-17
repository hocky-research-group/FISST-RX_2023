#!/bin/bash

prefix=$1
outdir=$2
nrep=$3
plumed_template=$4
replicate=$5
time_in_ns=$6

#if [ -z "$data_dir" ];then
#    data_dir=data
#fi

if [ -z $replicate ];then
    echo " Usage: tprfile plumed_template time_in_ns min_force(pN) max_force(pN) replicate_number"
    exit
fi

#LOAD RELEVANT GROMACS MODULE#
#source /scratch/work/hockygroup/software/gromacs-2020.4-plumed2020/bin/GMXRC.bash.modules
#export NOMP=$SLURM_CPUS_PER_TASK
#export NMPI=$SLURM_NTASKS
gmxexe=gmx_mpi_cuda


# Dividing by 2 makes is round to an integer
ninterp=121
#ninterp=$(echo "($max_force - $min_force + 1)/2" | bc)
#if [ $ninterp -lt 31 ];then
#    ninterp=31
#fi

# Set number of steps, will override .mdp value
timestep=2 #fs
steps=$(echo $time_in_ns*1000000/$timestep | bc)

label=$(basename $plumed_template | cut -f 1 -d '.')


dirlist=$(for i in `seq 1 $nrep`;do j=$(echo $i-1 | bc); lambda_dir=$outdir/lambda${j};echo $lambda_dir; done)

DIR=${outdir}
#fmin${min_force}_fmax${max_force}

outputprefix=$DIR/${label}_rep${replicate}
full_label=$(basename $outputprefix)
#outdir=$(dirname $outputprefix)

progress_file=${outputprefix}.progress.txt
if [ -e "$progress_file" ];then
    prev_steps=$(cat $progress_file)
    final_steps=$(($steps+$prev_steps))
    read_restart_file=${full_label}_rep${replicate}.run.${prev_steps}.restart.txt
    continuestring="-cpi ${full_label}_rep${replicate}.run.${prev_steps}.cpt"
    input="IN_RESTART=$read_restart_file"
    extraoptions="-noappend"
else
    final_steps=$steps
    input=""
    continuestring=""
fi

#mkdir -p $outdir

full_out_prefix=${outputprefix}.run.${final_steps}

for i in `seq 1 $nrep`;
do
        j=$(echo $i-1 | bc)
        lambda_dir=$outdir/lambda${j}
	plumed_file=${lambda_dir}/${full_label}_rep${replicate}.run.${final_steps}.plumed.dat
	sed -e "s,_OUTPUT_,${full_label}_rep${replicate}.run.${final_steps},g" -e "s,_INPUT_,$input," $plumed_template > $plumed_file
done

plumedstring="-plumed ${full_label}_rep${replicate}.run.${final_steps}.plumed.dat"

srun $gmxexe mdrun -s $prefix.tpr -multidir $dirlist -ntomp $nrep -hrex -replex 100000000 -reseed $RANDOM -nsteps $steps -deffnm ${label}_rep${replicate}.run.${final_steps} $continuestring $plumedstring $extraoptions

for i in `seq 1 $nep`;
do
        j=$(echo $i-1 | bc)
        lambda_dir=$outdir/lambda${j}
        #mkdir $i/TEMP
        #cp $i/** $i/TEMP

        grofile=$(ls ${lambda_dir}/*run*.gro | grep -v bench |sort -n -k3 -t '.'| tail -n 1)
        finalnum=$(ls ${lambda_dir}/*run*.gro | grep -v bench |sort -n -k3 -t '.'| tail -n 1 | awk -F '.' '{print $(3)}')

        if [ -e "$grofile" ];then
                echo $finalnum > $progressfile
        else
                echo No new gro file!
        fi
done

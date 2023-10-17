#!/bin/bash

tprfile=$1
prefix=$2
plumed_template=$3
time_in_ns=$4
replicate=$5
outdir=$6

#if [ -z "$data_dir" ];then
#    data_dir=data
#fi

if [ -z $replicate ];then
    echo " Usage: tprfile plumed_template time_in_ns min_force(pN) max_force(pN) replicate_number"
    exit
fi

source /scratch/work/hockygroup/software/gromacs-2020.4-plumed2020/bin/GMXRC.bash.modules
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



DIR=${outdir}
#fmin${min_force}_fmax${max_force}

echo $DIR
if [ -e "$DIR" ]; then
        echo Yes!
else
        mkdir -p $DIR
fi

outputprefix=$DIR/${label}_rep${replicate}
full_label=$(basename $outputprefix)
#outdir=$(dirname $outputprefix)

progress_file=${outputprefix}.progress.txt
if [ -e "$progress_file" ];then
    prev_steps=$(cat $progress_file)
    final_steps=$(($steps+$prev_steps))
    read_restart_file=${outputprefix}.run.${prev_steps}.restart.txt
    continuestring="-cpi ${outputprefix}.run.${prev_steps}.cpt"
    input="IN_RESTART=$read_restart_file"
    extraoptions="-noappend"
else
    final_steps=$steps
    input=""
    continuestring=""
fi

#mkdir -p $outdir

# Convert force to kcal/mol, round to 3 digits

full_out_prefix=${outputprefix}.run.${final_steps}
plumed_file=${full_out_prefix}.plumed.dat
plumedstring="-plumed $plumed_file"

sed -e "s,_OUTPUT_,$full_out_prefix,g" \
    -e "s,_INPUT_,$input," \
    $plumed_template > $plumed_file

$gmxexe mdrun -s $tprfile $continuestring $extraoptions -deffnm ${full_out_prefix} -nsteps $steps $plumedstring 

ls $DIR/*${final_steps}*.gro*

if [ -e $DIR/*${final_steps}*.gro* ];
then
        echo YES
        echo $final_steps > $progress_file
else
        echo NO
fi

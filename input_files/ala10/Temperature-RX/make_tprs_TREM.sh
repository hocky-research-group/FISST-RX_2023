#!/bin/bash

scriptdir=$(cd $(dirname $0);pwd)

source /scratch/work/hockygroup/software/gromacs-2019.6-plumedSept2020/bin/GMXRC.bash.modules
export NOMP=$SLURM_CPUS_PER_TASK
export NMPI=$SLURM_NTASKS
gmxexe=gmx_mpi

prefix=$1
grofile=$2
topfile=$3
mdp_template=$4
outdir=$5
tmin=$6
nrep=$7
tmax=$8
indexfile=$9

if [ -z "$prefix" ];then
echo "Usage: $0 prefix grofile topfile mdp_template outdir tmin nrep tmax indexfile"
exit
fi

module load python/intel/3.8.6
templist=$(python ${scriptdir}/gen_temperature_list.py $tmin $nrep $tmax)

for i in $templist;
do
	mkdir -p ${outdir}/${i}K
	mdpfile=${outdir}/${i}K/md.mdp
	sed -e "s/XXX/$i/g" ${mdp_template} > $mdpfile
	if [ -z $indexfile ];
	then
		$gmxexe grompp -f $mdpfile -c $grofile -p $topfile -o $outdir/${i}K/${prefix}.tpr 
	else
		$gmxexe grompp -f $mdpfile -c $grofile -p $topfile -o $outdir/${i}K/${prefix}.tpr -n $indexfile
	fi
done

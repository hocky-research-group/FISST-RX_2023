#!/bin/bash
scriptdir=$(cd $(dirname $0);pwd)

prefix=$1
grofile=$2
tmin_solute=$3
tmax_solute=$4
force=$5
nrep=$6

if [ -z "$prefix" ];then
echo "Usage: prefix grofile tmin_solute tmax_solute force nrep"
exit
fi

source /scratch/work/hockygroup/software/gromacs-2019.6-plumedSept2020/bin/GMXRC.bash.modules
export NOMP=$SLURM_CPUS_PER_TASK
export NMPI=$SLURM_NTASKS
gmxexe=gmx_mpi

parentdir=$(pwd $prefix)

outdir=${parentdir}/solute_${tmin_solute}Kto${tmax_solute}K_X${nrep}/pull_${force}pN
mkdir -p $outdir

topfolder=${parentdir}/solute_${tmin_solute}Kto${tmax_solute}K_X${nrep}/topfolder
mkdir -p $topfolder

mdp_template=rest_AIB9.mdp

for i in `seq 1 $nrep`;
do
	j=$(echo $i-1 | bc)
	lambda_dir=${outdir}/lambda${j}
	mkdir -p $lambda_dir

	mdpfile=${lambda_dir}/rest.mdp
	cp $mdp_template $mdpfile

	topfile=$topfolder/topol${j}.top
	tprfile=${lambda_dir}/${prefix}.tpr
	
	$gmxexe grompp -f $mdpfile -c $grofile -p $topfile -o $tprfile -maxwarn 1 -n index.ndx
done

#!/bin/bash
#SBATCH --dependency=singleton
#SBATCH --time=84:00:00
#SBATCH --nodes=1
#SBATCH --mem=2GB
#SBATCH --tasks-per-node 1
#SBATCH --cpus-per-task 40
#SBATCH --export=ALL

tprfile=left.tpr
prefix=left
plumed_template=fmin-10_fmax20/left_fRange.template.plumed.dat
time_in_ns=20
min_force=-10
max_force=20
replicate=1
scriptdir=/home/ys3382/projects/hockygroup/ys3382/Scripts/simulation_setup/gromacs/FISST
outdir=fmin-10_fmax20

for i in `seq 1 40`;do 
	bash ${scriptdir}/run_gromacs_pulling.sh $tprfile $plumed_template $time_in_ns $min_force $max_force $replicate ${outdir}
done


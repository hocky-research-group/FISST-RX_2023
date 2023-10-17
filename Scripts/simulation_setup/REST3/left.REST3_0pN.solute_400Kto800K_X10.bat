#!/bin/bash
#SBATCH --dependency=singleton
#SBATCH --time=24:00:00
#SBATCH --nodes=10
#SBATCH --mem=20GB
#SBATCH --tasks-per-node 2
#SBATCH --cpus-per-task 16
#SBATCH --export=ALL

prefix=left
outdir=/home/ys3382/scratch/ys3382/AIB9/left_to_right/REST3/solute_400Kto800K_X10/pull_0pN
tmin=400
nrep=10
tmax=800
plumed_template=/home/ys3382/scratch/ys3382/AIB9/left_to_right/REST3/solute_400Kto800K_X10/pull_0pN/pull_plumed_0pN.dat
force=0
time_in_ns=20
scriptdir=/home/ys3382/Scripts/simulation_setup/gromacs/solute_tempering/REST3
replicate=1

#For production run
for i in `seq 1 10`;
do
bash run_gromacs2021_REMD_single.sh $prefix $outdir $nrep $plumed_template $force $time_in_ns
done


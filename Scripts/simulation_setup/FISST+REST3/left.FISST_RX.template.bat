#!/bin/bash
#SBATCH --dependency=singleton
#SBATCH --time=12:00:00
#SBATCH --nodes=10
#SBATCH --mem=20GB
#SBATCH --tasks-per-node 2
#SBATCH --cpus-per-task 16
#SBATCH --export=ALL

prefix=_PREFIX_
outdir=_OUTDIR_
nrep=_N_
plumed_template=_PLUMED_
replicate=1
time_in_ns=_TIME_

for i in `seq 1 5`;
do
bash run_gromacs_FISST_REST3_2023.sh $prefix $outdir $nrep $plumed_template $replicate $time_in_ns $scriptdir
bash Rename.sh $outdir $nrep $plumed_template
done


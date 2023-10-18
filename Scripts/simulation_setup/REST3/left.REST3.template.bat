#!/bin/bash
#SBATCH --dependency=singleton
#SBATCH --time=24:00:00
#SBATCH --nodes=10
#SBATCH --mem=20GB
#SBATCH --tasks-per-node 2
#SBATCH --cpus-per-task 16
#SBATCH --export=ALL

prefix=_PREFIX_
outdir=_OUTDIR_
tmin=_TMIN_
nrep=_N_
tmax=_TMAX_
plumed_template=_PLUMED_
force=_FORCE_
time_in_ns=_TIME_
replicate=1

#For production run
for i in `seq 1 10`;
do
bash run_gromacs2021_REMD_single.sh $prefix $outdir $nrep $plumed_template $force $time_in_ns
done


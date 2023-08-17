#!/bin/bash
#SBATCH -t 48:00:00
#SBATCH --nodes=1
#SBATCH --mem=4096
#SBATCH --tasks-per-node 1
#SBATCH --cpus-per-task 40
#SBATCH --dependency=singleton

tprfile=_TPR_
prefix=_PREF_
plumed_template=_PLUMED_
time_in_ns=20
replicate=1
scriptdir=_SCRIPT_
outdir=_OUTDIR_

for i in `seq 1 10`;do 
bash ${scriptdir}/run_gromacs_FISST_2023.sh $tprfile $prefix $plumed_template $time_in_ns $replicate $outdir
done


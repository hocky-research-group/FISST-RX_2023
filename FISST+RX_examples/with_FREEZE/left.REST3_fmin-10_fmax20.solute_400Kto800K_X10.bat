#!/bin/bash
#SBATCH --dependency=singleton
#SBATCH --time=12:00:00
#SBATCH --nodes=10
#SBATCH --mem=20GB
#SBATCH --tasks-per-node 2
#SBATCH --cpus-per-task 16
#SBATCH --export=ALL

prefix=left
outdir=solute_400Kto800K_X10/fmin-10_fmax20
nrep=10
plumed_template=solute_400Kto800K_X10/fmin-10_fmax20/left_fRange.template.plumed.dat
replicate=1
time_in_ns=20

# FIRST RUN WITHOUT ANY RX EXCHANGES #
bash run_gromacs_FISST_REST3_2023_NO_RX.sh $prefix $outdir $nrep $plumed_template $replicate $time_in_ns $scriptdir
bash Rename.sh $outdir $nrep $plumed_template

# THEN RUN WITH EXCHANGES AND SWITCH ON FREEZE IN FISST #
plumed_template=solute_400Kto800K_X10/fmin-10_fmax20/left_fRange.template.plumed.FREEZE.dat
for i in `seq 1 5`;
do
bash run_gromacs_FISST_REST3_2023.sh $prefix $outdir $nrep $plumed_template $replicate $time_in_ns $scriptdir
bash Rename.sh $outdir $nrep $plumed_template
done


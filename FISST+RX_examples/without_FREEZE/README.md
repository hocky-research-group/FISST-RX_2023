# THIS DIRECTORY CONTAINS THE FOLLOWING FILES

(1) "left.gro": readable protein structure file GROMACS format

(2) "index.ndx": atom index file generated in GROMACS

(3) "rest_AIB9.mdp": MD simulation parameters for REST3 GROMACS format

(4) "make_tprs_RX.sh": bash script to generate scaled tpr files GROMACS format

(5) "run_gromacs_FISST_REST3_2023.sh": bash script to execute GROMACS production run. "-replex" flag is set to 2500 steps

(6) "left.REST3_fmin-10_fmax20.solute_400Kto800K_X10.bat": slurm submission script

(7) "Rename.sh": bash script to rename output PLUMED files to read in for next production window

# IMPLEMENTING FISST+RX (no FREEZING)

STEP 1: generate scaled tpr files using "make_tprs_RX.sh" 

bash make_tprs_RX.sh left left.gro 400 800 0 10

this will create "solute_400Kto800K_X10/pull_0pN/lambda${i}" where 'i' a number from 0 to 9 indicating the replica and contains each scaled tpr  

STEP 2: Copy files in "solute_400Kto800K_X10/pull_0pN/" to "solute_400Kto800K_X10/fmin-10_fmax20"

STEP3: Execute "left.REST3_fmin-10_fmax20.solute_400Kto800K_X10.bat"


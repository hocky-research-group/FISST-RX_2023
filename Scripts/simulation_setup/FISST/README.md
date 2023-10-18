# CONTAINS 4 FILES

(1) "create_plumed_FISST.py": creates PLUMED input to implement FISST from protein structure file and staring/end of force range

Example:

python create_plumed_FISST.py left_test.pdb "" -10 10

(2) "left.fmin-10_fmax20_dend.bat": SLURM job submission script

(3) "left_test.pdb": protein structure file

(4) "run_gromacs_FISST_2023.sh": bash script to execute GROMACS production run with FISST

create_plumed_FISST.py  left.fmin-10_fmax20_dend.bat  left_test.pdb  README  run_gromacs_FISST_2023.sh

CONTAINS 7 FILES
(1) "left_test.pdb": protein structure file

(2) "left_test.trr": trajectory file containing xyz coordinates (binary)

(3) "calc_e2e.py": python script to compute end-to-end distance of peptide and outputs as text file(terminal Calphas)
Example:
python calc_e2e.py left_test.pdb left_test.trr left_test

(4) "calc_ramachadran.py": python script to backbone dihedral angles of peptide and outputs as text file(terminal Calphas)
Example:
python calc_e2e.py left_test.pdb left_test.trr left_test

(5) "calc_zeta.py": python script to calculate zeta' coordinate in chirality transitions
Example:
python calc_zeta.py left_test.pdb left_test.trr left_test

(6) "left_fRange_rep1.run.10000000.observable.txt": Sample FISST observable file generated from PLUMED

(7) "fisst_forceSlices.py": Extract observable weights from "observable" file output from FISST module in PLUMED
Example
python fisst_forceSlices.py left_fRange_rep1.run.10000000.observable.txt "0,5,10"

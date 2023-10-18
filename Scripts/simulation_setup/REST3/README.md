# CONTAINS 7 FILES 
## (Topology scaling script derived from the authors of Zhang et al (2023))
### https://github.com/mdlab-um/REST3_tutorial

(1) "gen_lambda_kappa.py": python script to compute "lambda" and "kappa" scaling factors from solute temperature range

(2) "gennewtop.sh": bash script to generate scaled topologies

(3) "left.linear_restraint.template.dat": Example PLUMED input file for linear RESTRAINT

(4) "left.REST3.template.bat": SLURM job submission script to run REST3 simulation

(5) "partial_tempering.sh": bash script with PLUMED code to perform scaling 

(6) "processed.top": Sample topology file with "hot" atoms selected

(7) "run_gromacs2021_REMD_single.sh": bash script to execute GROMACS production run







import numpy as np
import mdtraj as md
import sys

topfile=sys.argv[1]
xtcfile=sys.argv[2]
min_force=float(sys.argv[3])
max_force=float(sys.argv[4])

if xtcfile=="":
    #print("yes")
    traj=md.load(topfile)
else:
    #print("no")
    traj=md.load(xtcfile,top=topfile)

def convert_array_to_csl(array):
    csl = []
    for a in array:
        csl.append(str(a))
    return ",".join(csl)

protein = traj.top.select("protein and (not resname ACE NME)")
cas = traj.top.select("name 'CA'")

protein += 1
cas += 1

#The conversion factor is 69.4786 pN = 1 kcal/mol/Angstrom
pN_to_KCAL=0.014425
min_force *= pN_to_KCAL
max_force *= pN_to_KCAL

# These can be changed here itself #
PERIOD=1000
NINTERPOLATE=121
ARG="dend"
CENTER=0

#The conversion factor is 69.4786 pN = 1 kcal/mol/Angstrom
print("UNITS LENGTH=A TIME=fs ENERGY=kcal/mol")
print("")
print("dend: DISTANCE ATOMS=%s,%s" % (cas[0], cas[-1]))
print("rg: GYRATION TYPE=RADIUS ATOMS=%s-%s" % (protein[0], protein[-1]))
print("")
print("f: FISST MIN_FORCE=%s MAX_FORCE=%s PERIOD=%s NINTERPOLATE=%s ARG=%s OUT_RESTART=_OUTPUT_.restart.txt OUT_OBSERVABLE=_OUTPUT_.observable.txt OBSERVABLE_FREQ=%s CENTER=%s RESTART_FMT=%s _INPUT_" % (min_force, max_force, PERIOD, NINTERPOLATE, ARG, PERIOD, CENTER,'%e'))
print("")
print("PRINT ARG=* FILE=_OUTPUT_.colvar.txt STRIDE=%s" % (PERIOD))

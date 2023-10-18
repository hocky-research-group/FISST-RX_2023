import numpy as np
import mdtraj as md
import sys
import os
from scipy.integrate import simps
from glob import glob
import math
from math import *

if len(sys.argv) != 4:
    print("Usage:", sys.argv[0])
    print("       topfile")
    print("       coordfile")
    print("       outprefix")
    sys.exit()

topfile = sys.argv[1]
coordfile = sys.argv[2]
outprefix = sys.argv[3]

# Load the trajectory
if coordfile=="":
    traj = md.load(topfile)
else:
    traj = md.load(coordfile, top=topfile)


phi_indices, phi_angles = md.compute_phi(traj)
psi_indices, psi_angles = md.compute_psi(traj)

arr=phi_angles
columns_to_sum = [2, 3, 4, 5, 6]  # Indices of columns to sum
zeta=-1*arr[:,columns_to_sum].sum(axis=1) # THIS COMPUTES ZETA'
time=traj.time/1e3

outfile=outprefix+".zeta.txt"

np.savetxt(outfile,np.array([time,zeta]).T)

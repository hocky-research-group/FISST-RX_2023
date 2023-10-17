import numpy as np
import mdtraj as md
import sys
import pickle
import os

if len(sys.argv) != 4:
    print("Usage:", sys.argv[0])
    print("       topfile")
    print("       coordfile")
    print("       outprefix")
    sys.exit()

topfile=sys.argv[1]
coordfile=sys.argv[2]
outprefix=sys.argv[3]

traj=md.load(coordfile,top=topfile)

# Calculate phi (ϕ) and psi (ψ) dihedral angles
phi_indices, phi_angles = md.compute_phi(traj)
psi_indices, psi_angles = md.compute_psi(traj)

# Save phi and psi angles to a text file
data = np.column_stack((np.degrees(phi_angles), np.degrees(psi_angles)))
outfile=outprefix+".ramachadran.txt"
np.savetxt(outfile, data, header='# Phi (ϕ) Angle (degrees) Psi (ψ) Angle (degrees)', comments='')

outfile=outprefix+".ramachadran.txt"
print("Ramachandran data saved to '%s'" % outfile)

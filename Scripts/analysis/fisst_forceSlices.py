#!/usr/bin/env python3

import sys
import os
import numpy as np
import scipy
from scipy.stats import *
from scipy.integrate import simps

if len(sys.argv) != 3:
    print("Usage:", sys.argv[0])
    print("       fisst-observable-file")
    print("       forces (csl)")
    sys.exit()

fn_obs = sys.argv[1]
forces_csl = str(sys.argv[2])

kcal_to_pN = 69.4786

# Make more general to return only the observable weights for a given force, so that they can be used for any observable #
def split_forces(csl):
    return [float(i.strip()) for i in csl.split(',')]

def find_nearest(array, value):
    array = np.asarray(array)
    idx = (np.abs(array - value).argmin())
    return idx, array[idx]

def find_fisst_forces(all_fisst_forces, sf_forces):
    fisst_forces = {}
    for i,frc in enumerate(sf_forces):
        idx, fisst_force = find_nearest(all_fisst_forces, frc)
        fisst_forces[frc] = [(idx*2)+4, round(fisst_force, 2)]
    return fisst_forces

def return_obsv_weights(observable,forces):
    fisst_data = observable

    all_fisst_forces = []
    
    for i in range(4, fisst_data.shape[1], 2):
        all_fisst_forces.append(fisst_data[0,i]*kcal_to_pN)
        fisst_forces = find_fisst_forces(all_fisst_forces, forces)
    
    time=observable[:,0]
    all_obsv_weights=[time]
    print(fisst_forces)
    print("")
    for key,val in fisst_forces.items():
        print(key,val)
        print("-------------------------")
        weights = fisst_data[:, val[0]+1]
        all_obsv_weights.append(weights)
    
    all_obsv_weights=np.array(all_obsv_weights).T

    return all_obsv_weights


observable=np.loadtxt(fn_obs)
forces=split_forces(forces_csl)
all_obsv_weights=return_obsv_weights(observable,forces)
prefix=os.path.splitext(fn_obs)[0]
outfile=prefix+".obsv_weights_at_force"+".txt"
np.savetxt(outfile,(all_obsv_weights))        

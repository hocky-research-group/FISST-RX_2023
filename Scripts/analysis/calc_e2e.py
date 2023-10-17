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

def ba(bins):
    return (bins[1:]+bins[:-1])/2.0

def gen_histogram(data):
    xmin=np.floor(data.min())-1
    xmax=np.ceil(data.max())+1
    hist, bins = np.histogram(data,bins=100,density=True,range=(xmin,xmax))
    xbar = simps(ba(bins)*hist,ba(bins))
    var = simps(ba(bins)**2*hist,ba(bins))-xbar**2
    return xbar,var,hist, bins

def calc_cosine(r1,r2,r3,r4):
    v1=np.subtract(r2,r1)
    v2=np.subtract(r4,r3)
    cosine = (np.dot(v1,v2))/(np.linalg.norm(v1)*np.linalg.norm(v2))
    return cosine

def calc_Lp_from_traj(traj,sel):
    traj_xyz_time = traj.atom_slice(traj.top.select(sel)).xyz
    lp_per_frame = []
    n_frames = traj_xyz_time.shape[0]
    for i in range(n_frames):
        #print("========Frame %i===========" % i)
        traj_xyz = traj_xyz_time[i]
        L = []
        cosine = []
        for j in range(len(traj_xyz)-1):
            r1 = [0,0,0]
            r2 = traj_xyz[j]
            r3 = [0,0,0]
            r4 = traj_xyz[j+1]
            
            l = np.linalg.norm(r4-r2)
            L.append(l)
            
            cos = calc_cosine(r1,r2,r3,r4)
            cosine.append(cos)
        l_avg = gen_histogram(L)[0]
        cosine_avg = gen_histogram(cosine)[0]
        lp = -l_avg/np.log(cosine_avg)
        #print(lp)
        lp_per_frame.append(lp)
    return lp_per_frame

cas = traj.top.select("name 'CA'")
time=traj.time
e2e = md.compute_distances(traj,[[cas[0],cas[-1]]],periodic=False)

outfile=outprefix+".e2e.txt"
print(outfile)
print(np.mean(e2e))
np.savetxt(outfile,np.array((time,e2e.flatten())).T)

xbar,var,hist, bins = gen_histogram(e2e)
outfile=outprefix+".e2e_histogram.txt"
print(outfile)
np.savetxt(outfile,np.array((ba(bins),hist)).T)

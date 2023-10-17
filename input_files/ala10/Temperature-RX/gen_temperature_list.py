import numpy as np
import sys
from math import exp

def temp_generator(T_min,N_temp,T_max,power=1):
    templist=[]
    for i in range(0,N_temp):
        T_k=np.round( T_min + (T_max-T_min) * (1 - exp( float(i)/(N_temp-1) )**power)/(1- exp(power)),2)
        templist.append(T_k)
#        if T_k > T_max:
#            break
    return np.array(templist)

T_min = float(sys.argv[1])
T_max = float(sys.argv[3])
N_temp = int(sys.argv[2])


T=temp_generator(T_min,N_temp,T_max)
np.savetxt(sys.stdout,T,fmt="%s")
#print(T)
#print(len(T))
#import matplotlib.pyplot as plt
#plt.figure()
#plt.plot(T)
#plt.show()

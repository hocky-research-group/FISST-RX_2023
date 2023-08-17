import math

nrep = 8
tmin = 360
tmax = 500

lst = []
for i in range(nrep):
    t = tmin * math.exp(i * math.log(tmax / tmin) / (nrep - 1))
    lst.append(t)

for i in range(nrep):
    temp = lst[i]
    lambda_val = lst[0] / lst[i]
    kappa_val=1+0.005*i
    print(lambda_val,kappa_val)

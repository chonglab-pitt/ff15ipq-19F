import numpy
import matplotlib
import matplotlib.pyplot as plt

data = numpy.loadtxt("data.txt")
xs = data[:,0]
ys1 = data[:,1]
ys2 = data[:,2]

plt.scatter(xs,ys1,c='k',s=4, label="Original")
plt.scatter(xs,ys2,c='r',s=4, label="Fitted")
line = numpy.arange(-20,10)
plt.plot(line,line,'--',c='b',linewidth=3,alpha=0.6)
plt.ylabel('Model Energy',size=24)
plt.xlabel('Target Energy',size=24)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.grid(True)
plt.legend(prop={'size': 16}, markerscale=3, loc='lower right')
plt.tight_layout()
plt.savefig("AIB_iter01_fit.pdf")

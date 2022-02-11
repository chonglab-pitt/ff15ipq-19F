#!/usr/env/bin python

import numpy
import matplotlib.pyplot as plt

data = numpy.genfromtxt('rama.dat')
x = data[:,1]
y = data[:,2]

plt.scatter(x, y, c='r', s=2, marker='o')

plt.xlim(-180,180)
plt.xticks(numpy.arange(-180, 210, 30))
plt.yticks(numpy.arange(-180, 210, 30))
plt.ylim(-180,180)
plt.xlabel(r'$\phi$')
plt.ylabel(r'$\psi$')

plt.tight_layout()
plt.savefig("rama_plot_gen2.png", dpi=300, transparent=True)

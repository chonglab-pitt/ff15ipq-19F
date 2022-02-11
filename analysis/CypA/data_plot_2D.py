"""
Plot 2D timeseries data heatmaps such as secondary structure and per residue RMSD.
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

import matplotlib.cm as cm
from matplotlib.colors import Normalize
from matplotlib.colors import ListedColormap

from matplotlib.ticker import (MultipleLocator, AutoMinorLocator)

import matplotlib.patches
from numpy.lib import genfromtxt 


#plt.rcParams['figure.figsize']= (12,6)
plt.rcParams.update({'font.size': 14})
plt.rcParams["font.family"]="Sans-serif"
#plt.rcParams['font.sans-serif'] = 'Arial'
plt.rcParams['font.sans-serif'] = 'DejaVu Sans'
plt.rcParams['mathtext.default'] = 'regular'
plt.rcParams['axes.linewidth'] = 2.5
plt.rcParams['xtick.major.size'] = 6
plt.rcParams['xtick.major.width'] = 2.5
plt.rcParams['xtick.minor.size'] = 2
plt.rcParams['xtick.minor.width'] = 2
plt.rcParams['ytick.major.size'] = 6
plt.rcParams['ytick.major.width'] = 2.5


# TODO: maybe make methods to initialize variables for each plot type
# then have one plotting method and others for legends and such
class Per_Res_Plot:

    def __init__(self, file, timescale=10**6, data_interval=1, ax=None):
        """
        Parameters
        ----------
        file : str or list
            Path to the cpptraj data file.
        timescale : int
            Convert from frame to timescale. Default 1ps per frame to us scale.
        data_interval : int
            Optionally process data in larger intervals, default 1.
        """
        self.file = file
        self.timescale = timescale
        self.data_interval = data_interval

        # TODO: there has to be a best practise for this
        if ax is None:
            self.fig, self.ax = plt.subplots(figsize=(12,5))
        else:
            self.fig = plt.gca()
            self.ax = ax

    def add_patch(self, ax, recx, recy, facecolor, text, recwidth=0.04, recheight=0.05, recspace=0):
        ax = self.ax
        ax.add_patch(matplotlib.patches.Rectangle((recx, recy), 
                                                    recwidth, recheight, 
                                                    facecolor=facecolor,
                                                    edgecolor='black',
                                                    clip_on=False,
                                                    transform=ax.transAxes,
                                                    lw=2.25)
                        )
        ax.text(recx + recheight + recspace, recy + recheight / 2.8, text, ha='left', va='center',
                transform=ax.transAxes, fontsize=12)

    def process_per_res_data(self):
        """
        Process the cpptraj data that is in per-residue format, e.g. for DSSP and RMSD.
        Head of file is each residue, e.g. "1:MET", first column of file is the frame.

        Returns
        -------
        x : ndarray
            1D array of the timepoints.
        y : ndarray
            1D array of the residue string and numbers.
        z : ndarray
            2D array of the x by y data values.
        """
        if type(self.file) == list:
            header = np.genfromtxt(self.file[0], dtype=str, max_rows=1, comments=None)
            # build array from total frame counts and residue number
            frames = [len(np.genfromtxt(f, usecols=0)) for f in self.file]
            self.x = np.divide(np.arange(0, sum(frames), 1), self.timescale)
            data = np.zeros(shape=(sum(frames), len(header)))

            # fill out data array for each dataset in file list
            frame_index = 0
            for num, val in enumerate(frames):
                data[frame_index:val + frame_index, :] = np.genfromtxt(self.file[num])
                frame_index += val

        else:
            header = np.genfromtxt(self.file, dtype=str, max_rows=1, comments=None)
            data = np.genfromtxt(self.file)[::self.data_interval,:]
            self.x = np.divide(np.genfromtxt(self.file, usecols=0), self.timescale)

        # rotate so frame is x and res is y
        data = np.transpose(data)

        # timeseries frame data
        #self.x = np.genfromtxt(f, usecols=0)
        #self.x = np.divide(data[0,:], self.timescale)

        # split y into seperate res_name and res_num
        y = np.char.split(header[1:], sep=":")
        self.y_name = [i[0] for i in y]
        self.y_num = [int(i[1]) for i in y]

        # z is the data array without the frame column
        self.z = data[1:,:]

    def ss_cmap(self):
        """
        Custom cmap for the DSSP data.
        """
        # cmap = cm.tab10
        # norm = Normalize(vmin=0, vmax=10)     
        # self.ss_colors = ListedColormap(["white"] + [cmap(norm(c)) for c in range(0, 7)])

        # first color should be white for None
        self.ss_colors = ListedColormap(["white", "tab:brown", "tab:orange", "tab:red",
                                         "tab:blue", "tab:purple", "tab:green", "tab:olive"])
        self.ss_labels = {"None":0, "Parallel β Sheet":1, "Antiparallel β Sheet":2, 
                  "$3_{10}$ Helix":3, "α Helix":4, "π Helix":5, "Turn":6, "Bend":7}

    def ss_master(self, legend=False, labels=(False, False)):
        """
        Main public method for plotting DSSP data.

        Parameters
        ----------
        legend : bool
            Optionally plot the patch and text SSP legend.
        labels : tuple of bool
            Tuple of 2 boolean values for x and y labels respectively.
        """
        ax = self.ax
        
        self.ss_cmap()
        self.process_per_res_data()
        ax.pcolormesh(self.x, self.y_num, self.z, cmap=self.ss_colors, shading="auto")
        if type(self.file) == list:
            ax.xaxis.grid(color="k", linewidth=2.5)
            ax.yaxis.grid(color="k", linewidth=1)
        else:
            ax.grid(color="k", linewidth=1)

        if labels[0]:
            ax.set_xlabel("Time (µs)", fontweight="bold", labelpad=10) 
        if labels[1]:
            ax.set_ylabel("Residue", fontweight="bold", labelpad=12)

        if legend:
            norm = Normalize(vmin=0, vmax=7)
            ax.text(1.05, 0.85, "Secondary Structure", ha='left', va='center',
                    transform=ax.transAxes, fontweight="bold")
            for ss, val in self.ss_labels.items():
                self.add_patch(ax, 1.05, 0.75 - 0.08 * val, self.ss_colors(norm(val)), ss)
        # attempt to add thick vlines
        #ax.vlines(np.linspace(0, 5, len(self.x)), ymin=0, ymax=len(self.y_num), linewidths=0.5, color="k")

    def ss_legend(self):
        """
        Add a DSSP legend to its own axes object (located on the right).
        """
        ax = self.ax
        self.ss_cmap()
        norm = Normalize(vmin=0, vmax=7)
        ax.text(1.05, 0.875, "Secondary Structure", ha='left', va='center',
                transform=ax.transAxes, fontweight="bold")
        for ss, val in self.ss_labels.items():
            self.add_patch(ax, 1.075, 0.75 - 0.09 * val, self.ss_colors(norm(val)), ss)

    def rmsd_master(self, legend=False, labels=(False, False), vmax=5):
        """
        Main public method for plotting per residue RMSD data.

        Parameters
        ----------
        legend : bool
            Optionally plot the cbar.
        labels : tuple of bool
            Tuple of 2 boolean values for x and y labels respectively.
        vmax : int
            Max probability value (z-axis).
        """
        ax = self.ax
        
        self.process_per_res_data()
        self.plot = ax.pcolormesh(self.x, self.y_num, self.z, cmap="afmhot_r", 
                             shading="auto", vmin=0, vmax=vmax)
        if type(self.file) == list:
            ax.xaxis.grid(color="k", linewidth=2.5)
            ax.yaxis.grid(color="k", linewidth=1)
        else:
            ax.grid(color="k", linewidth=1)

        if labels[0]:
            ax.set_xlabel("Time (µs)", fontweight="bold", labelpad=10) 
        if labels[1]:
            ax.set_ylabel("Residue", fontweight="bold", labelpad=12)

        if legend:
            cbar = plt.colorbar(self.plot)
            cbar.set_label("RMSD ($\AA$)", weight="bold", labelpad=16)

    # TODO: make this sep legend ax object plotting method
    def rmsd_legend(self, vmax=5): 
        """
        Add rmsd cbar to its own axes object.
        """
        ax = self.ax # TODO: need to make this dynamic for ac inputs 
        
        cax, cbar_kwds = mpl.colorbar.make_axes(ax, location="right",
                              fraction=0.65, shrink=1.2, aspect=10, anchor=(0, 1.6))
        #cax = self.fig.add_axes([0.95, 0.1, 0.025, 0.4])

        cmap = cm.afmhot_r
        norm = Normalize(vmin=0, vmax=vmax)
        
        cbar = mpl.colorbar.ColorbarBase(cax, cmap=cmap, 
                                         norm=norm,
                                         orientation="vertical")
        #cbar.add_lines(range(0,vmax + 1), "k", linewidths=1)
        cbar.set_label("Backbone RMSD ($\AA$)", fontweight="bold", labelpad=16)

    def dihedral_legend(self, cbl): 
        """
        Add dihedral cbar to its own axes object.

        Parameters
        ----------
        cbl : str
            Colorbar label. Can be 'phi' or 'psi'.
        """
        ax = self.ax # TODO: need to make this dynamic for ac inputs 
        
        cax, cbar_kwds = mpl.colorbar.make_axes(ax, location="right",
                              fraction=0.65, shrink=1.2, aspect=10, anchor=(0, 1.6))
        #cax = self.fig.add_axes([0.95, 0.1, 0.025, 0.4])

        cmap = cm.hsv
        norm = Normalize(vmin=-180, vmax=180)
        
        cbar = mpl.colorbar.ColorbarBase(cax, cmap=cmap, 
                                         norm=norm,
                                         orientation="vertical")
        #cbar.add_lines(range(0,vmax + 1), "k", linewidths=1)
        cbar.set_label(f"$\{cbl}$", fontweight="bold", labelpad=10, 
                       ha="center", va="center", rotation=0)
        cbar.set_ticks(np.arange(-180,270,90))

    def dihedral_master(self, legend=False, labels=(False, False), cbl=None):
        """
        Main public method for plotting per residue dihedral data.

        Parameters
        ----------
        legend : bool
            Optionally plot the cbar.
        labels : tuple of bool
            Tuple of 2 boolean values for x and y labels respectively.
        cbl : str
            Colorbar label. Can be 'phi' or 'psi'.
        """
        ax = self.ax
        
        self.process_per_res_data()
        self.plot = ax.pcolormesh(self.x, self.y_num, self.z, cmap="hsv", 
                             shading="auto", vmin=-180, vmax=180)
        if type(self.file) == list:
            ax.xaxis.grid(color="k", linewidth=2.5)
            ax.yaxis.grid(color="k", linewidth=1)
        else:
            ax.grid(color="k", linewidth=1)

        if labels[0]:
            ax.set_xlabel("Time (µs)", fontweight="bold", labelpad=10) 
        if labels[1]:
            ax.set_ylabel("Residue", fontweight="bold", labelpad=12)

        if legend:
            cbar = plt.colorbar(self.plot)
            cbar.set_label(f"$\{cbl}$", weight="bold", labelpad=16.5, fontsize=17.5, 
                           rotation=0, ha="center", va="center")


def single_plot_test():
    #ss_data = "ipq/ired_test/NO_ION/ss_10ns.dat"
    #rms_data = "ipq/ired_test/NO_ION/rmsd_per_res_bb_10ns.dat"

    ss_data = "ipq/wt/v01/1us_noion/ss.dat"
    rms_data = "ipq/wt/v01/1us_noion/rmsd_3K0N_1-165_BB_perres.dat"
    phi_data = "ipq/wt/v01/1us_noion/dihedral_phi_1-165.dat"
    psi_data = "ipq/wt/v01/1us_noion/dihedral_psi_1-165.dat"

    # fig, ax = plt.subplots(ncols=2, figsize=(12, 4),
    #                        gridspec_kw={'width_ratios' : [20, 3]})
    fig, ax = plt.subplots(figsize=(6,4))
    # x says us but using ns for test
    # TODO: make subplot for legs
    #Per_Res_Plot([ss_data, ss_data], timescale=1000, ax=ax).ss_master(labels=(True, True), legend=True)
    Per_Res_Plot(ss_data, timescale=10000, ax=ax).ss_master(labels=(True, True), legend=True)
    #Per_Res_Plot(rms_data, timescale=10000, ax=ax).rmsd_master(legend=True, labels=(True, True))
    #Per_Res_Plot(phi_data, timescale=1000, ax=ax).dihedral_master(legend=True, labels=(True, True), cbl="phi")
    #Per_Res_Plot(psi_data, timescale=1000, ax=ax).dihedral_master(legend=True, labels=(True, True), cbl="psi")

    ax.set_xticks(np.arange(0,1.2,0.2))
    #ax.set_ylim(95,115)
    ax.set_ylim(140,160)
    #ax.set_xlim(0,0.2)
    #ax.set_xticks(np.arange(0,0.25,0.05))

    plt.tight_layout()
    plt.show()

def multi_cypa_plot(type, panel=None):
    """
    Parameters
    ----------
    type : str
        Can be 'dssp', 'rmsd', 'phi', or 'psi'.
    panel : str
        For a multi panel figure, add lettering to top left, e.g. 'A'.
    """
    systems = ["wt", "w4f", "w5f", "w6f", "w7f"]
    if type == "dssp":
        ratios = [20, 1]
        size = (9.79, 12.5)
    #elif type == "rmsd" or type == "rmsd-sc" or type == "phi" or type == "psi":
    else:
        ratios = [15, 5]
        size = (9.25, 12.5)
    fig, ax = plt.subplots(nrows=len(systems), ncols=2, sharex="col", figsize=size,
                           gridspec_kw={'width_ratios' : ratios})
    for num, sys in enumerate(systems):
        # plot legend and x label on the bottom axis
        if num == len(systems) - 1:
            if type == "dssp":
                Per_Res_Plot(f"ipq/{sys}/v00/1us_noion/ss.dat", timescale=10**4, ax=ax[num, 0]).ss_legend()
            elif type == "rmsd":
                Per_Res_Plot(f"ipq/{sys}/v00/1us_noion/rmsd_3K0N_1-165_BB_perres.dat", 
                             timescale=10**4, ax=ax[num, 1]).rmsd_legend()
            elif type == "rmsd-sc":
                Per_Res_Plot(f"ipq/{sys}/v00/1us_noion/rmsd_3K0N_1-165_SC_perres.dat", 
                             timescale=1000, ax=ax[num, 1]).rmsd_legend(vmax=10)
            elif type == "phi" or type == "psi":
                Per_Res_Plot(f"ipq/{sys}/v01/1us_noion/dihedral_phi_1-165.dat", 
                             timescale=10**4, ax=ax[num, 1]).dihedral_legend(cbl=type)
            labels = (True, True)
        else:
            labels = (False, True)
        
        if type == "dssp":
            Per_Res_Plot([f"ipq/{sys}/v0{i}/1us_noion/ss.dat" for i in range(0, 5)], 
                         timescale=10**4, ax=ax[num, 0]).ss_master(labels=labels)
            # Per_Res_Plot([f"ipq/{sys}/v00/1us_noion/ss.dat"], timescale=10**4, 
            #             ax=ax[num, 0]).ss_master(labels=labels)
        elif type == "rmsd":
            Per_Res_Plot([f"ipq/{sys}/v0{i}/1us_noion/rmsd_3K0N_1-165_BB_perres.dat" for i in range(0,5)], 
                         timescale=10**4, ax=ax[num, 0]).rmsd_master(labels=labels)
            # Per_Res_Plot(f"ipq/{sys}/v00/1us_noion/rmsd_3K0N_1-165_BB_perres.dat", 
            #              timescale=10**4, ax=ax[num, 0]).rmsd_master(labels=labels)
        elif type == "rmsd-sc":
            Per_Res_Plot([f"ipq/{sys}/v0{i}/1us_noion/rmsd_3K0N_1-165_SC_perres.dat" for i in range(0,5)], 
                         timescale=1000, ax=ax[num, 0]).rmsd_master(labels=labels, vmax=10)
        elif type == "phi" or type == "psi":
            Per_Res_Plot([f"ipq/{sys}/v0{i}/1us_noion/dihedral_{type}_1-165.dat" for i in range(0,5)], 
                         timescale=1000, ax=ax[num, 0]).dihedral_master(labels=labels)
            # Per_Res_Plot(f"ipq/{sys}/v00/1us_noion/rmsd_3K0N_1-165_BB_perres.dat", 
            #              timescale=10**4, ax=ax[num, 0]).rmsd_master(labels=labels)

        # set title and turn off the second column axes    
        ax[num, 0].set_title(sys.upper() + " CypA", fontweight="bold", fontsize=12)
        ax[num, 0].set_yticks(np.arange(0,180,20))
        #ax[num, 0].set_yticks(np.arange(140,180,20))
        #ax[num, 0].set_ylim(60,120) # TODO: ylim=None arg
        ax[num, 1].axis("off")

        # better fitting xticks: TODO: make this dynamic?
        ax[num, 0].set_xticks(np.arange(0,6,1))
        #ax[num, 0].set_xticks(np.arange(0,1.2,0.2))
        
    if panel is not None:
        plt.figtext(0, 1, panel, ha="center", va="center", fontsize=20, fontweight="bold")

    fig.tight_layout()
    fig.subplots_adjust(hspace=0.20)
    plt.show()
    #fig.savefig(f"figures/per_res_SC_{type}_full.png", dpi=300, bbox_inches='tight', transparent=True)

if __name__ == "__main__":
    #single_plot_test()
    # multi_cypa_plot("dssp", panel="(A)")
    # multi_cypa_plot("rmsd", panel="(B)")
    # multi_cypa_plot("phi", panel="(A)")
    # multi_cypa_plot("psi", panel="(B)")

    multi_cypa_plot("rmsd-sc")
"""
Plot simple 1D timeseries data and KDE.
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from matplotlib.colors import Normalize
from matplotlib.ticker import (MultipleLocator, AutoMinorLocator)
import matplotlib.patches 

import matplotlib.gridspec as gridspec
import scipy.stats

import pandas as pd

plt.rcParams['figure.figsize']= (10,6)
plt.rcParams.update({'font.size': 17})
plt.rcParams["font.family"]="Sans-serif"
#plt.rcParams['font.sans-serif'] = 'Arial'
plt.rcParams['font.sans-serif'] = 'DejaVu Sans'
plt.rcParams['mathtext.default'] = 'regular' # was 'rm'
plt.rcParams['axes.linewidth'] = 3
plt.rcParams['xtick.major.size'] = 9.5
plt.rcParams['xtick.major.width'] = 3
plt.rcParams['xtick.minor.size'] = 6
plt.rcParams['xtick.minor.width'] = 3
plt.rcParams['ytick.major.size'] = 6
plt.rcParams['ytick.major.width'] = 3
plt.rcParams['axes.labelsize'] = 20

def pre_processing(file=None, data=None, time_units=10**6, index=1):
    """
    Processes raw time series data to appropriate units of time.
    """
    if file:
        data = np.genfromtxt(file)
    # time units should mostly be in ps: convert to us
    time = np.divide(data[:,0], time_units)
    return np.vstack([time, data[:,index]])

def avg_and_stdev(data_list):
    """
    Returns the average and stdev of multiple timeseries datasets.
    """
    # only the y values, x axis is time.
    data = [i[1] for i in data_list]
    return np.average(data, axis=0), np.std(data, axis=0)


def line_plot(time, data, ylim=(0,5), ax=None, stdev=None, alpha=0.8, window=1, linewidth=1,
              label=None, leg_cols=5, color=None, ylabel=None, dist=(0,1.1,0.2)):
    """
    Parameters
    ----------
    time : array
        Timeseries values.
    data : array
        Dataset values.
    ylim : tuple
        2 item tuple to set custom y limits.
    stdev : array
        Used to generate errors for the line plot.
    window : int
        Size of optional window averaging.
    label : str
        Label the line plot.
    leg_cols : int
        Number of columns in the legend.
    dist : tuple
        Fed into np.arange(dist) for dist plot x-axis ticks.

    Returns
    -------

    """
    if ax is None:
        fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
    else:
        fig = plt.gca()

    if window != 1:
        time = time[window:-window:window]
        data = movingaverage(data, window)[window:-window:window]
        #print(data[window:-window])
        if stdev is not None:
            stdev = stdev[window:-window:window]

    # line plot
    ax[0].plot(time, data, linewidth=linewidth, alpha=alpha, label=label, color=color)
    #ax[0].axvline(2, color="k", lw=2, ls="--")
    ax[0].set_xlabel("Time ($\mu$s)", labelpad=12, fontweight="bold")
    #ax[0].set_ylabel(r"RMSD ($\AA$)", labelpad=10, fontweight="bold")
    #ax[0].set_ylabel(r"19F to C=O Distance ($\AA$)", labelpad=10, fontweight="bold")
    ax[0].set_ylabel(ylabel, labelpad=11, fontweight="bold")
    ax[0].set_ylim(ylim)
    #ax[0].set_xticks(np.arange(0, time[-1] + (time[-1] / 5), time[-1] / 5), minor=True)
    ax[0].grid(alpha=0.5)

    # secondary kde distribution plot
    grid = np.arange(ylim[0], ylim[1], .01, dtype=float)
    density = scipy.stats.gaussian_kde(data)(grid)
    ax[1].plot(density, grid, color=color)
    # TODO: maybe normalize density to 1 and then set xticks np.arange(0, 1, 0.2)
    ax[1].set_xticks(np.arange(dist[0], dist[1], dist[2]))
    #ax[1].set_xticks(np.arange(0, np.max(density) + 0.5, 0.5))
    ax[1].xaxis.set_ticklabels([])
    ax[1].set_xlabel("Distribution", labelpad=28, fontweight="bold")
    ax[1].grid(alpha=0.5)

    # optionally plot the stdev using fill_between
    if stdev is not None:
        ax[0].fill_between(time, np.add(data, stdev), np.subtract(data, stdev), alpha=0.275, color=color)
    if label:
        #ax[0].legend(loc=8, frameon=False, ncol=leg_cols, bbox_to_anchor=(0.5, -0.38))
        ax[0].legend(loc="right")

    #fig.tight_layout()
    #fig.savefig("figures/test.png", dpi=300, transparent=False)

def dist_plot(data, ylim=(0,5), ax=None, color=None, linewidth=3):
    """
    Plot just the distribution of R1 or R2 values.
    """
    if ax is None:
        fig, ax = plt.subplots()
    else:
        fig = plt.gca()
    # secondary kde distribution plot
    grid = np.arange(ylim[0], ylim[1], .01, dtype=float)
    density = scipy.stats.gaussian_kde(data)(grid)
    ax.plot(grid, density, color=color, linewidth=linewidth)
    # TODO: maybe normalize density to 1 and then set xticks np.arange(0, 1, 0.2)
    #ax.set_xticks(np.arange(0, 1.2, 0.2))
    #ax.set_xticks(np.arange(0, np.max(density) + 0.5, 0.5))
    ax.set_xlabel("Relaxation ($s^{-1}$)", labelpad=18, fontweight="bold")

    # Remove the non-bottom spines
    for kw in ("left", "right", "top"):
        ax.spines[kw].set_visible(False)
    ax.axes.yaxis.set_visible(False)

def add_patch(ax, recx, recy, facecolor, text, recwidth=0.04, recheight=0.06, recspace=0, fontsize=18):
    ax.add_patch(matplotlib.patches.Rectangle((recx, recy), 
                                                recwidth, recheight, 
                                                facecolor=facecolor,
                                                edgecolor='black',
                                                clip_on=False,
                                                transform=ax.transAxes,
                                                lw=2.25)
                    )
    ax.text(recx + recheight + recspace, recy + recheight / 2, text, ha='left', va='center',
            transform=ax.transAxes, fontsize=fontsize)

def movingaverage(data, windowsize):
    """
    Returns the window averaged 1D dataset.
    """
    return np.convolve(data, np.ones(windowsize, dtype=float) / windowsize, mode='same')

#######################################################################
################### RMSD w/stdev 1D Data Plots ########################
#######################################################################
def plot_avg_and_stdev():
    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)
    fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]}, figsize=(9,5.5))
    for num, sys in enumerate(["wt", "w4f", "w5f", "w6f", "w7f"]):
        if sys == "wt":
            color = "dimgrey"
        else:
            color = cmap(norm(num - 1))

        # all replicates of a res class
        res = [pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/rmsd_1-165_bb.dat", time_units=10**5) for i in range(0, 5)]
        avg, stdev = avg_and_stdev(res)
        print(f"{sys}: {np.mean(avg)} +/- {np.mean(stdev)}")
        line_plot(res[0][0], avg, stdev=stdev, ax=ax, ylim=(0,3), window=300,
                  color=color, ylabel="Backbone RMSD ($\AA$)", linewidth=2.75,
                  alpha=1, dist=(0,6,1))
        
        if sys == "w7f":
            add_patch(ax[1], -0.15, -0.435, color, f"{sys.upper()} CypA", fontsize=16, recwidth=0.155, recspace=0.155)
        else:
            # recx can be controlled as : left margin + spacing
            add_patch(ax[0], -0.15 + 0.295 * num, -0.435, color, f"{sys.upper()} CypA", fontsize=16)

    ax[1].set_xlim(0,5)
    fig.tight_layout()
    fig.savefig("figures/5us_agg_rms_bb_window300.pdf", dpi=600, transparent=True)
    #plt.show()
#plot_avg_and_stdev()

#######################################################################
################### 121 RMSD w/stdev 1D Data Plots ####################
#######################################################################
def plot_121_rmsd():
    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)
    fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})

    for num, sys in enumerate(["w4f", "w5f", "w6f", "w7f"]):
        color = cmap(norm(num))

        # all replicates of a res class
        res = [pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/rmsd_121_3k0n_ref.dat", time_units=10**5) for i in range(0, 5)]
        #res = [pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/rmsd_121_xtal_ref.dat", time_units=10**5) for i in range(0, 5)]
        avg, stdev = avg_and_stdev(res)
        line_plot(res[0][0], avg, stdev=stdev, ax=ax, ylim=(0,5), 
                  color=color, ylabel="TRP121 RMSD ($\AA$)", 
                  alpha=0.85, dist=(0,6,1))
        
        # recx can be controlled as : left margin + spacing
        add_patch(ax[0], 0.02 + 0.265 * num, -0.435, color, f"{sys.upper()} CypA", fontsize=16)

    #ax[1].set_xlim(0,5)
    fig.tight_layout()
    #fig.savefig("figures/5us_agg_rms_bb.png", dpi=300, transparent=True)
    plt.show()


#######################################################################
################### plots of phi and psi singles ######################
#######################################################################
def plot_phi_psi_singles(phi, psi, col_phi, col_psi, ax=None):
    """
    Enter the phi and psi residues of interest. TODO: list?
    Goal is to visualize phi_i and phi_i+1
    """
    if ax is None:
        fig, ax = plt.subplots()
    else:
        fig = plt.gca()

    # use WT V01 dataset
    phi_data = "ipq/wt/v01/1us_noion/dihedral_phi_1-165.dat"
    psi_data = "ipq/wt/v01/1us_noion/dihedral_psi_1-165.dat"

    # extract single residue dihedral data
    phi_data = pre_processing(phi_data, index=phi-1, time_units=1000)
    psi_data = pre_processing(psi_data, index=psi, time_units=1000)

    ax.scatter(phi_data[0], phi_data[1], label=f"$\phi$ {phi}", color=col_phi, s=10)
    ax.scatter(psi_data[0], psi_data[1], label=f"$\psi$ {psi}", color=col_psi, s=10)
    #ax.legend()
    ax.set_yticks(np.arange(-180, 270, 90))
    #ax.set_yticklabels(["", "-90", "0", "90", ""])
    ax.set_ylabel("Angle (°)", fontweight="bold", labelpad=12)

    add_patch(ax, 1.02, 0.60, col_phi, f"$\phi$ {phi}", recheight=0.1, recwidth=0.025, recspace=-0.06)
    add_patch(ax, 1.02, 0.40, col_psi, f"$\psi$ {psi}", recheight=0.1, recwidth=0.025, recspace=-0.06)

    #plt.xlim(0,0.5)

def plot_multi_phi_psi():

    cmap = cm.Dark2
    norm = Normalize(vmin=0, vmax=8)

    fig, ax = plt.subplots(nrows=3, sharex=True, figsize=(11,7))

    # turn coming off
    plot_phi_psi_singles(147, 146, cmap(norm(0)), cmap(norm(1)), ax=ax[0])

    # twist
    plot_phi_psi_singles(104, 103, cmap(norm(2)), cmap(norm(3)), ax=ax[1])
    plot_phi_psi_singles(108, 107, cmap(norm(4)), cmap(norm(5)), ax=ax[2])

    ax[2].set_xlabel("Time (µs)", fontweight="bold", labelpad=12)

    #fig.subplots_adjust(hspace=0.001)
    fig.tight_layout()
    plt.show()
    #fig.savefig("figures/key_phi_psi.pdf", dpi=900, transparent=True)

#plot_multi_phi_psi()

####################################################################
####################### Key SC 1D Data Plots #######################
####################################################################
def plot_individual_datasets(xform=True):
    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)

    #fig, ax = plt.subplots(ncols=2, nrows=5, sharex=True, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
    
    #for num, sys in enumerate(["wt", "w4f", "w5f", "w6f", "w7f"]):
    for num, sys in enumerate(["wt"]):

        if sys == "wt":
            color = "dimgrey"
        else:
            color = cmap(norm(num - 1))

        fig, ax = plt.subplots(ncols=2, sharey=True, figsize=(6.5, 4),
                               gridspec_kw={'width_ratios' : [20, 5]})

        for i in range(0, 5):
            # optionally have same or different colors
            color = cmap(norm(i))

            # main data processing and plotting step
            data = pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/rmsd_phe113_3k0n.dat", time_units=10**3)
            line_plot(data[0], data[1], ylim=(0,3.5), color=color, ylabel="Side Chain RMSD ($\AA$)", 
                      linewidth=2, alpha=1, dist=(0,6,1), ax=ax, window=1, label=f"V0{i}")
            ax[0].set_title(f"{sys.upper()} CypA", pad=12, fontweight="bold")
            #ax[0].set_legend()

            # add patch
            #add_patch(ax[0], -0.02 + 0.265 * i, -0.4, color, f"V0{i}", fontsize=14, recspace=-0.2)

        # if sys == "w7f":
        #     add_patch(ax[1], -0.15, -0.435, color, f"{sys.upper()} CypA", fontsize=16, recwidth=0.155, recspace=0.155)
        # else:
        #     # recx can be controlled as : left margin + spacing
        #     add_patch(ax[0], -0.05 + 0.265 * num, -0.435, color, f"{sys.upper()} CypA", fontsize=16)

        ax[1].set_xlim(0,3)
        if xform is False:
            ax[0].set_xticklabels([])
            ax[0].set_xlabel("")
            ax[1].set_xlabel("")
        ax[0].set_ylabel("F113 RMSD ($\AA$)", fontsize=17)
        fig.tight_layout()
        plt.show()
        #fig.savefig(f"figures/rms_key_sc_{sys}_v00-v04.png", dpi=300, bbox_inches='tight', transparent=True)

    #plt.show()
    #fig.savefig(f"figures/rms_bb_v00_all.png", dpi=300, transparent=True)
        
plot_individual_datasets()

####################################################################
################### Individual 1D Data Plots #######################
####################################################################
def plot_individual_datasets(xform=True):
    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)

    #fig, ax = plt.subplots(ncols=2, nrows=5, sharex=True, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
    
    for num, sys in enumerate(["wt", "w4f", "w5f", "w6f", "w7f"]):
    #for num, sys in enumerate(["wt"]):

        if sys == "wt":
            color = "dimgrey"
        else:
            color = cmap(norm(num - 1))

        fig, ax = plt.subplots(ncols=2, sharey=True, figsize=(6.5, 4),
                               gridspec_kw={'width_ratios' : [20, 5]})

        for i in range(0, 5):
            data = pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/rmsd_1-165_heavy.dat", time_units=10**5)
            line_plot(data[0], data[1], ylim=(0,4), color=color, ylabel="Backbone RMSD ($\AA$)", 
                      linewidth=2, alpha=1, dist=(0,6,1), ax=ax, window=200)
            ax[0].set_title(f"{sys.upper()} CypA", pad=12, fontweight="bold")

        # if sys == "w7f":
        #     add_patch(ax[1], -0.15, -0.435, color, f"{sys.upper()} CypA", fontsize=16, recwidth=0.155, recspace=0.155)
        # else:
        #     # recx can be controlled as : left margin + spacing
        #     add_patch(ax[0], -0.05 + 0.265 * num, -0.435, color, f"{sys.upper()} CypA", fontsize=16)

        ax[1].set_xlim(0,5)
        if xform is False:
            ax[0].set_xticklabels([])
            ax[0].set_xlabel("")
            ax[1].set_xlabel("")
        ax[0].set_ylabel("Backbone RMSD ($\AA$)", fontsize=17)
        fig.tight_layout()
        plt.show()
        #fig.savefig(f"figures/rms_bb_{sys}_singles.pdf", dpi=600, bbox_inches='tight', transparent=True)

    #plt.show()
    #fig.savefig(f"figures/rms_bb_v00_all.png", dpi=300, transparent=True)
        
#plot_individual_datasets()

########################################################################
################### 19F Dist 1D Comparison Plots #######################
########################################################################
def plot_19F_dist_comparisons(type="overall"):
    """
    Parameters
    ----------
    type : str
        Can be 'overall' (avg and stdev) or 'singles' (all individual datasets).
    """
    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)
    #print (cmap(norm(5))
    fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
    for num, sys in enumerate(["w4f", "w5f", "w6f", "w7f"]):
        ### overall avg and stdev
        if type == "overall":
            # fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
            # WT H-dist-BB plot at F position
            data_wt = [pre_processing(f"ipq/wt/v{i:02d}/1us_noion/dist_{num + 4}F_to_BB_CO.dat", time_units=10**5) for i in range(0, 5)]
            avg_wt, stdev_wt = avg_and_stdev(data_wt)
            line_plot(data_wt[0][0], avg_wt, stdev=stdev_wt, ax=ax, ylim=(3,10), color="dimgrey")
            # SYS plot
            data = [pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/dist_F_to_BB_CO.dat", time_units=10**5) for i in range(0, 5)]
            avg, stdev = avg_and_stdev(data)
            line_plot(data[0][0], avg, stdev=stdev, ax=ax, ylim=(3,10), color=cmap(norm(num)), 
                      ylabel="$^{19}$F - Backbone Distance ($\AA$)", dist=(0,6,1))
            #add_patch(ax[0], 0.25 + 0.2 * num, -0.435, cmap(norm(num)), sys.upper() + " CypA")
            if sys == "w7f":
                add_patch(ax[1], -0.15, -0.435, cmap(norm(num)), f"{sys.upper()} CypA", fontsize=16, recwidth=0.155, recspace=0.155)
            else:
            # recx can be controlled as : left margin + spacing
                add_patch(ax[0], 0.22 + 0.265 * num, -0.435, cmap(norm(num)), f"{sys.upper()} CypA", fontsize=16)

        ### individual datasets
        elif type == "singles":
            fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
            for i in range(0, 5):
                # WT H-dist-BB plot at F position
                data_wt = pre_processing(f"ipq/wt/v{i:02d}/1us_noion/dist_{num + 4}F_to_BB_CO.dat", time_units=10**5)
                line_plot(data_wt[0], data_wt[1], ax=ax, ylim=(2,10), color='black')
                # SYS plot
                data = pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/dist_F_to_BB_CO.dat", time_units=10**5)
                line_plot(data[0], data[1], ax=ax, ylim=(2,10), color='cornflowerblue', ylabel="$^{19}$F to C=O Distance ($\AA$)")
            fig.suptitle(sys)
            #plt.show()

        else:
            raise ValueError("Type arg must be 'overall' or 'singles'")

    ax[1].set_xlim(0,6)
    #add_patch(ax[0], 0.05, -0.435, "grey", "WT CypA")
    add_patch(ax[0], -0.05, -0.435, "grey", "WT CypA", fontsize=16)
    fig.tight_layout()
    #plt.show()
    fig.savefig(f"figures/dist_5us_all_avg_stdev.png", transparent=True, bbox_inches='tight', dpi=900)

#plot_19F_dist_comparisons(type="overall")

########################################################################
################### 19F Trp 121 Chi Comparison Plots ###################
########################################################################
def plot_19F_trp121_chi():
    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)
    #print (cmap(norm(5))
    fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
    for num, sys in enumerate(["wt", "w4f", "w5f", "w6f", "w7f"]):
        ### overall avg and stdev
        if sys == "wt":
            data_wt = [pre_processing(f"ipq/wt/v{i:02d}/1us_noion/dihedral_chi_trp121.dat", time_units=10**5) for i in range(0, 2)]
            avg_wt, stdev_wt = avg_and_stdev(data_wt)
            line_plot(data_wt[0][0], avg_wt, stdev=stdev_wt, ax=ax, ylim=(-180,180), color="dimgrey")
            add_patch(ax[0], 0.075, -0.435, "dimgrey", "WT")
        else:
            # SYS plot
            data = [pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/dihedral_chi_trp121.dat", time_units=10**5) for i in range(0, 2)]
            avg, stdev = avg_and_stdev(data)
            line_plot(data[0][0], avg, stdev=stdev, ax=ax, ylim=(-180,180), color=cmap(norm(num - 1)), 
                        ylabel="$\chi$ Dihedral Trp121 (°)", dist=(0,0.1,0.025))
            add_patch(ax[0], 0.25 + 0.2 * num, -0.435, cmap(norm(num - 1)), sys.upper())

    fig.tight_layout()
    plt.show()
    #fig.savefig(f"figures/chi_trp121_avg_stdev.png", dpi=300, transparent=True)

#plot_19F_trp121_chi()


########################################################################
################### 19F Relaxation Comparison Plots ####################
########################################################################

def plot_19F_r1_r2(R, type):
    """
    Parameters
    ----------
    R : str
        Can be 'R1' or 'R2'.
    type : str
        Can be 'overall' (avg and stdev) or 'singles' (all individual datasets).
        Or 'dist'.
    """
    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)

    fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
    exp_r1 = {"w4f":1.99, "w5f":1.19, "w6f":1.25, "w7f":1.20}
    exp_r2 = {"w4f":109.1, "w5f":64.8, "w6f":63.0, "w7f":109.6}

    if R == "R1":
        ylim = (0, 5)
        index = 1
        for num, r in enumerate(exp_r1.values()):
            ax[0].axhline(y=r, xmin=0, xmax=1, color=cmap(norm(num)), linestyle="--")
            ax[1].axhline(y=r, xmin=0, xmax=1, color=cmap(norm(num)), linestyle="--")
            
    elif R == "R2":
        ylim = (60, 140)
        index = 2
        for num, r in enumerate(exp_r2.values()):
            ax[0].axhline(y=r, xmin=0, xmax=1, color=cmap(norm(num)), linestyle="--")
            ax[1].axhline(y=r, xmin=0, xmax=1, color=cmap(norm(num)), linestyle="--")

    else:
        raise ValueError("'r' must be 'R1' or 'R2'.")

    for num, sys in enumerate(["w4f", "w5f", "w6f", "w7f"]):
        ### overall avg and stdev
        if type == "overall":
            # SYS plot
            data = [pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/19F_R1_R2_newddsum.dat", 
                    time_units=10**3, index=index) for i in range(0, 5)]
            avg, stdev = avg_and_stdev(data)
            line_plot(data[0][0], avg, stdev=stdev, ax=ax, ylim=ylim,
                      ylabel="R$_{2}$ $s^{-1}$", color=cmap(norm(num)), dist=(0, 0.6, 0.1))
            print(f"{sys} : {R}={np.mean(avg):.2f}±{np.mean(stdev):.2f}")
            add_patch(ax[0], 0.15 + 0.2 * num, -0.435, cmap(norm(num)), sys.upper())

        ### individual datasets
        elif type == "singles":
            fig, ax = plt.subplots(ncols=2, sharey=True, gridspec_kw={'width_ratios' : [20, 5]})
            for i in range(0, 5):
                # SYS plot
                data = pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/19F_R1_R2.dat", 
                                    time_units=10**3, index=index)
                line_plot(data[0], data[index], ax=ax, ylim=ylim, 
                        ylabel="Relaxation Rate $s^{-1}$" + f"({R})", 
                        color=cmap(norm(num))
                        )
            fig.suptitle(sys)
            #plt.show()

        else:
            raise ValueError("Type arg must be 'overall' or 'singles'")

    fig.tight_layout()
    #plt.show()
    #fig.savefig(f"figures/19F_{R}_5us_all_avg_stdev_newddsum.png", dpi=300, transparent=True)

#plot_19F_r1_r2('R1', 'overall')

def plot_19F_relax_dist_1plot():
    """
    Only plot the distrubution.
    """
    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)

    fig, ax = plt.subplots(figsize=(10,5), ncols=2)# gridspec_kw={'width_ratios' : [20, 5]})

    exp_r1 = {"w4f":1.99, "w5f":1.19, "w6f":1.25, "w7f":1.20}
    exp_r2 = {"w4f":109.1, "w5f":64.8, "w6f":63.0, "w7f":109.6}

    file = "19F_R1_R2_800ns.dat"
    #file = "19F_R1_R2_newddsum.dat"
    #file = "19F_R1_R2_new_csa_r1.dat"

    xpad = 6
    # TODO: maybe consolidate and make into a seperate function for r1 and r2?
    for num, sys in enumerate(["w4f", "w5f", "w6f", "w7f"]):
        # R1
        data = [pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/{file}", 
                time_units=10**3, index=1)[1] for i in range(0, 5)]
        data = np.reshape(data, -1)
        #print(f"{sys} : R1={np.mean(data):.2f}±{np.std(data):.2f}")
        dist_plot(data, ax=ax[0], color=cmap(norm(num)), ylim=(0, 5))
        ax[0].set_ylim(0, 2.635)
        ax[0].set_xlim(0, 5)
        ax[0].vlines(x=exp_r1[sys], ymin=0, ymax=2.25, color=cmap(norm(num)), linestyle="--", linewidth=2)
        ax[0].set_xlabel("R$_{1}$ ($s^{-1}$)", labelpad=xpad)
        ax[0].xaxis.set_minor_locator(MultipleLocator(0.5))
        ax[0].tick_params(axis="x", which="major", labelsize=18, pad=4.5)

        # R2
        data = [pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/{file}", 
                time_units=10**3, index=2)[1] for i in range(0, 5)]
        data = np.reshape(data, -1)
        print(f"{sys} : R2={np.mean(data):.2f}±{np.std(data):.2f}")
        dist_plot(data, ax=ax[1], color=cmap(norm(num)), ylim=(50,150))
        ax[1].set_ylim(0, 0.297)
        ax[1].set_xlim(50, 150)
        ax[1].vlines(x=exp_r2[sys], ymin=0, ymax=0.25, color=cmap(norm(num)), linestyle="--", linewidth=2)
        ax[1].set_xlabel("R$_{2}$ ($s^{-1}$)", labelpad=xpad)
        ax[1].xaxis.set_minor_locator(MultipleLocator(5))
        ax[1].tick_params(axis="x", which="major", labelsize=18, pad=4.5)

    recy = -0.45
    x_corr = 0.095
    pos1 = 0.3
    pos2 = 0.05
    # recx can be controlled as : left margin + spacing
    add_patch(ax[0], pos1 - x_corr, recy, cmap(norm(0)), "W4F CypA")
    add_patch(ax[0], pos1 + 0.5 - x_corr, recy, cmap(norm(1)), "W5F CypA")
    add_patch(ax[1], pos2 - x_corr, recy, cmap(norm(2)), "W6F CypA")
    add_patch(ax[1], pos2 + 0.5 - x_corr, recy, cmap(norm(3)), "W7F CypA")


    fig.tight_layout()
    #plt.show()
    fig.savefig("figures/r1_r2_subplots_800ns_updated.pdf", dpi=600, transparent=True)

#plot_19F_relax_dist_1plot()


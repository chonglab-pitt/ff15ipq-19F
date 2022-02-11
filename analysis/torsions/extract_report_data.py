#!/bin/env python
# get |E(qm) - E(mm)| data from mdgx report.m parameter fitting report

import numpy as np
import matplotlib.pyplot as plt


def load_report(report, res=None):
    """
    Read and process report.m data.
    """
    with open(str(report)) as f:
         lines = f.readlines()
    
    # isolate a single res class before converting to array
    if res:
        data = [line[:42] for line in lines 
                if line.startswith(" ") and line[42] == "%" and line[44:47] == str(res)] 
    else:
        # only keep rows with E(mm) and E(qm) data for all datasets
        data = [line[:42] for line in lines 
                if line.startswith(" ") and line[42] == "%"]

    # columns are: qm_target, mm_original, mm_fitted, error
    return np.loadtxt(data)

def energy_plot(data):
    qm_target = data[:,0]
    mm_original = data[:,1]
    mm_fitted = data[:,2]

    plt.scatter(qm_target, mm_original, c='k', s=4, label="Original")
    plt.scatter(qm_target, mm_fitted, c='r', s=4, label="Fitted")
    line = np.arange(-20, 50)
    plt.plot(line,line,'--',c='b',linewidth=3,alpha=0.5)
    plt.ylabel('Model Energy',size=24)
    plt.xlabel('Target Energy',size=24)
    plt.xticks(fontsize=20)
    plt.yticks(fontsize=20)
    plt.grid(True)
    plt.legend(prop={'size': 16}, markerscale=3, loc='lower right')
    plt.tight_layout()
    plt.show()
    #plt.savefig("AIB_iter01_fit.pdf")

def calc_abs_error(data):
    # |E(qm) - E(mm)| = |Error|
    return np.abs(np.subtract(data[:,0], data[:,2]))

def calc_rmse(data):
    # error is in column 3 of data array
    return np.sqrt(np.mean(np.square(calc_abs_error(data))))

def violin_plot(report, res_classes):
    import pandas as pd 
    import seaborn as sns

    plt.rcParams['figure.figsize']= (7.5,5.5)
    plt.rcParams.update({'font.size': 18})
    plt.rcParams["font.family"]="Sans-serif"
    #plt.rcParams["font.serif"]="Helvetica World"
    plt.rcParams['font.sans-serif'] = 'Dejavu Sans'
    plt.rcParams['mathtext.default'] = 'regular'
    plt.rcParams['axes.linewidth'] = 2.5

    # |E(qm) - E(mm)| = |Error|
    df = pd.DataFrame([calc_abs_error(load_report(report, res)) for res in res_classes]).transpose()
    dx = pd.DataFrame([calc_rmse(load_report(report, res)) for res in res_classes]).transpose()

    fig, ax = plt.subplots()
    ax.set_ylim(0,5)
   
    res_colors = ['#59C26E', '#59C26E', '#59C26E', '#59C26E', '#E84A52', '#E84A52', '#5FA2FA', '#5FA2FA']
    a = sns.violinplot(data=df, linestyle='-', linewidth=3, cut=0, inner="quartile", jitter=False, 
                       bw=0.5, figsize=(10,8), scale="width", width=0.8, ax=ax, palette=res_colors)

    sns.swarmplot(data=dx, color='w', size=15, ax=ax)
    ax.set_axisbelow(True)
    ax.yaxis.grid(alpha=0.5, linestyle='-')
    ax.tick_params(width=2.5, length=6)
    ax.tick_params(axis='x', bottom=False)

    plt.setp(a.collections, edgecolor="k")

    a.set_xticklabels(res_classes)
    a.set_xlabel('Residues', fontweight='bold', labelpad=12)
    a.set_ylabel(r'|U$_Q$$_M$-U$_M$$_M$|' + '\n' + '(kcal/mol)', fontweight='bold', labelpad=16)

    ### patch style: allows for border
    import matplotlib.patches 
    def add_patch(recx, recy, facecolor, text, recwidth=0.04, recheight=0.06, recspace=0):
        ax.add_patch(matplotlib.patches.Rectangle((recx, recy), 
                                                  recwidth, recheight, 
                                                  facecolor=facecolor,
                                                  edgecolor='black',
                                                  clip_on=False,
                                                  transform=ax.transAxes,
                                                  lw=2.25)
                     )
        ax.text(recx + recheight + recspace, recy + recheight / 2, text, ha='left', va='center',
                transform=ax.transAxes)
    recy = -0.34
    space = 0.0
    origin = 0.1
    rec_space = 0.3
    add_patch(origin, recy, '#59C26E', '$^{19}$F-Trp', recspace=space)
    add_patch(origin + rec_space, recy, '#E84A52', '$^{19}$F-Tyr', recspace=space)
    add_patch(origin + rec_space * 2, recy, '#5FA2FA', '$^{19}$F-Phe', recspace=space)

    for l in a.lines: 
        l.set_linestyle('-')
        l.set_linewidth(2.5)
        l.set_color('black')
        l.set_alpha(1)
        
    plt.tight_layout()
    #plt.show()
    plt.savefig('V01/violin_4sigtol_10cpl_V01.pdf', dpi=600, bbox_inches='tight', transparent=True)

#rep = load_report("V01/report_final.m", res="F4F")
#rep = load_report("V00/report_4sigtol.m", res="FTF")
#energy_plot(rep)

res_classes = ["W4F", "W5F", "W6F", "W7F", "Y3F", "YDF", "F4F", "FTF"]
violin_plot("V01/report_final.m", res_classes)

#for res in res_classes:
#    print(res, calc_rmse(load_report("V01/report_final.m", res)))


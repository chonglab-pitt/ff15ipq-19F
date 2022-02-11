from data_plot_1D import *


########################################################################
################### 19F Relaxation Comparison Plots ####################
########################################################################

def plot_19F_NE1_nb():

    cmap = cm.tab10
    norm = Normalize(vmin=0, vmax=10)

    fig, ax = plt.subplots()

    for num, sys in enumerate(["w4f", "w5f", "w6f", "w7f", "wt"]):
        # SYS plot
        data = [pre_processing(f"ipq/{sys}/v{i:02d}/1us_noion/energy_121_res.dat", 
                time_units=10**3, index=5)[1] for i in range(0, 5)]
        #avg, stdev = avg_and_stdev(data)
        #line_plot(data[0][0], avg, stdev=stdev, ax=ax, ylim=(4,7),#(-65,10),
        #            ylabel="Electrostatic Energy (kcal/mol)", color=cmap(norm(num)), dist=(0, 0.6, 0.1))
        data = np.reshape(data, -1)
        dist_plot(data, ax=ax, ylim=(0,100))
        
        #add_patch(ax, 0.15 + 0.2 * num, -0.435, cmap(norm(num)), sys.upper())

    #fig.tight_layout()
    plt.show()
    #fig.savefig(f"figures/19F_NE1_nb.png", dpi=300, transparent=True)

plot_19F_NE1_nb()
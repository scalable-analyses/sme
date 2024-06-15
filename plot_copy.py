import argparse
import pandas as pd
import matplotlib.pyplot as plt

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument( "filename",
                         help = "File containing the CSV data which is plotted." )
    args = parser.parse_args()

    with open(args.filename, "r") as f:
        lines = f.readlines()
        data = [line.split("  CSV_DATA: ")[1] for line in lines if "  CSV_DATA: " in line]
        data = [line.replace("\n", "") for line in data]

        df = pd.DataFrame( [line.split(",") for line in data],
                           columns=[ "instruction",
                                     "num_values",
                                     "offset",
                                     "repetitions",
                                     "mib_per_iter",
                                     "total_time",
                                     "gibs"] )
        
        df["offset"]       = pd.to_numeric(df["offset"])
        df["num_values"]   = pd.to_numeric(df["num_values"])
        df["repetitions"]  = pd.to_numeric(df["repetitions"])
        df["mib_per_iter"] = pd.to_numeric(df["mib_per_iter"])
        df["total_time"]   = pd.to_numeric(df["total_time"])
        df["gibs"]         = pd.to_numeric(df["gibs"])

        # remove values above 2000 GiB/s (ldr ZA for small #values where the loop did not run)
        df = df[df["gibs"] <= 2000]

        df["num_bytes"] = df["num_values"].astype(int) * 4 * 2

        for instr in df["instruction"].unique():
            df_instr = df[df["instruction"] == instr]

            fig, ax = plt.subplots()
            used_markers = ["o", "s", "D", "P", "X", "v", "^"]
            marker = 0
            for offset in df_instr["offset"].unique():
                if offset == 0:
                    label = "128"
                else:
                    label = offset
                ax.plot( df_instr[df_instr["offset"] == offset]["num_bytes"],
                        df_instr[df_instr["offset"] == offset]["gibs"],
                        marker = used_markers[marker],
                        label = label )
                marker += 1

                if( offset == "64" ): break

            ax.set_xlabel( "Number of bytes (input+output array)" )
            ax.set_ylabel( "GiB/s" )
            ax.set_title( instr + " Performance of Copy Kernel" )
            ax.legend( title="Alignment (bytes)" )
            ax.grid()
            ax.set_ylim( [0, 500] )
            ax.set_yticks( [ x for x in range(0, 500, 25)] )
            ax.set_xscale( "log", base = 2 )
            ax.set_xticks( [2**i for i in range(11, 33)] )

            ax.text( 0.99,
                     0.01,
                     "https://scalable.uni-jena.de/opt/sme",
                     verticalalignment = 'bottom',
                     horizontalalignment='right',
                     transform = ax.transAxes,
                     fontsize = 5 )

            fig.set_size_inches( 10, 5 )
            instr_filename = instr.lower()
            output_filename = args.filename.replace( ".log",
                                                     "_" + instr_filename +
                                                     ".svg" )
            fig.savefig( output_filename )
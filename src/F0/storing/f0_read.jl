using SFeat, DelimitedFiles, TextGrid
using Plots, CSV, DataFrames
default(dpi=300)


parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished\A003_A004"

# -------------- Reading f0 values from file for S1 and S2
f0_S1, f0_S2 = f0_read(parentFolder);


# plot averaged segments
S1_average = [ sum(i)/length(i) for i in f0_S1];


S2_average = [ sum(i)/length(i) for i in f0_S2];




plot(S1_average,
        background_color=RGB{Float64}(0.466,0.117,0.560),
        foreground_color=:white,
        seriescolor=RGB{Float64}(0.95,0.2,0.1),
        xguide="turns",
        yguide="WPM",
        label="S1 averaged WPM segments"
        )

scatter!(S1_average,background_color=RGB{Float64}(0.466,0.117,0.560),
            foreground_color=:white, label=false,seriescolor=RGB{Float64}(0.95,0.2,0.1)
)



plot!(S2_average,
        background_color=RGB{Float64}(0.466,0.117,0.560),
        foreground_color=:white,
        seriescolor=RGB{Float64}(0.1,0.6,0.9),
        xguide="turns",
        yguide="WPM",
        label="S2 averaged WPM segments")

scatter!(S2_average,background_color=RGB{Float64}(0.466,0.117,0.560),
            foreground_color=:white,
            label=false,seriescolor=RGB{Float64}(0.1,0.6,0.9))
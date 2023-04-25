using SFeat, TextGrid, Plots




parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished"
folders = readdir(parentFolder, join=true)

cnt = 0
for folder in folders
    cnt += 1
    TextGridFile = folder*folder[findlast("\\",folder)[1] : end]*".TextGrid"
    interval = extract(TextGridFile)

    S1 = interval[1]; S2 = interval[5];
    S1 = S1[map(x -> x[3] == "S1", interval[1])]; S2 = S2[map(x -> x[3] == "S2", interval[5])];

    f0_S1, f0_S2 = f0_read(folder);

    S1Data = [ sum(i)/length(i) for i in f0_S1]
    S2Data = [ sum(i)/length(i) for i in f0_S2]

    S1Time = [ i[1] + (i[2] - i[1]) / 2 for i in S1 ]
    S2Time = [ i[1] + (i[2] - i[1]) / 2 for i in S2 ]


    default(dpi=300, w=2, markersize=4, size=(1900,600),framestyle = :box)
    plot(S1Time, S1Data, seriescolor=RGB{Float64}(0.95,0.2,0.1),
    xguide="Turn's Time", yguide="f0", label="S1",
    shape = :circle, thickness_scaling = 2)
    plot!(S2Time, S2Data, seriescolor=RGB{Float64}(0.1,0.6,0.9),
     shape=:star4, label="S2"
    )

    image = raw"C:\Users\hemad\Desktop\Master\Experiments\APPENDIX\f0\Adults"*"\\$cnt.png"
    savefig(image)
end
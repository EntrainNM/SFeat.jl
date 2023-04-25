using SFeat, TextGrid, Plots




parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished"
folders = readdir(parentFolder, join=true)

cnt = 0
for folder in folders
    cnt += 1
    TextGridFile = folder*folder[findlast("\\",folder)[1] : end]*".TextGrid"
    interval = extract(TextGridFile)

    S1Words = wordSegments(interval, 1)

    S1WPM = Vector{Float64}(undef,length(S1Words)) # initalize 1D array to store averaged WPM for each S1 segment
    S1time = Vector{Float64}(undef,length(S1Words)) # initalize 1D array to store averaged time for each S1 segment
    for i in 1:length(S1WPM) # for each S1 segment
        S1WPM[i] = S1Words[i][4] / (S1Words[i][3] - S1Words[i][2]) * 60.0
        S1time[i] = S1Words[i][2] + (S1Words[i][3] - S1Words[i][2]) / 2.0
    end

    #------------------------------------------------ S2
    S2Words = wordSegments(interval, 2)

    S2WPM = Vector{Float64}(undef,length(S2Words)) # initalize 1D array to store averaged WPM for each S2 segment
    S2time = Vector{Float64}(undef,length(S2Words)) # initalize 1D array to store averaged time for each S2 segment
    for i in 1:length(S2WPM) # for each S2 segment
        S2WPM[i] = S2Words[i][4] / (S2Words[i][3] - S2Words[i][2]) * 60.0
        S2time[i] = S2Words[i][2] + (S2Words[i][3] - S2Words[i][2]) / 2.0
    end

    S1Data = S1WPM; S1Time = S1time; S2Data = S2WPM; S2Time = S2time


    default(dpi=300, w=2, markersize=4, size=(1900,600),framestyle = :box)
    plot(S1Time, S1Data, seriescolor=RGB{Float64}(0.95,0.2,0.1),
    xguide="Turn's Time", yguide="WPM", label="S1",
    shape = :circle, thickness_scaling = 2)
    plot!(S2Time, S2Data, seriescolor=RGB{Float64}(0.1,0.6,0.9),
     shape=:star4, label="S2"
    )

    image = raw"C:\Users\hemad\Desktop\Master\Experiments\APPENDIX\WPM\Adults"*"\\$cnt.png"
    savefig(image)

end


#  ----------------------------------- storing files
# using DataFrames, CSV
# # create directoty to store data in for WPM
# if !("WPM" in readdir(parentFolder))
#     mkdir(parentFolder*raw"\WPM")
# end

# # save plot to WPM directory
# image = parentFolder*raw"\WPM\WPM"*".png"
# savefig(image)

# # save data to CSV file
# csv_file = parentFolder*raw"\WPM\WPM_CVS_"

# S1CSV = DataFrame([S1Time, S1Data], [:S1Time, :S1])
# S2CSV = DataFrame([S2Time, S2Data], [:S2Time, :S2])
# # CSV.write(csv_file, [S1data S2data])
# CSV.write(csv_file*"S1.csv", S1CSV)
# CSV.write(csv_file*"S2.csv", S2CSV)


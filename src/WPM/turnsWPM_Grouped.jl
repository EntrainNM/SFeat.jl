
# plot WPM for each speaker along with a moving average (averag over 5-segemnt intervals)

using SFeat, TextGrid
using Plots, CSV, DataFrames
default(dpi=300)
# path to gropued directories
folders = readdir(raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CASD", join=true)

for folder in folders

    print("Working on ", folder)
    TextGridFile = folder*folder[findlast('\\', folder):end]*".TextGrid" # path .TextGrid file

    interval = extract(TextGridFile) # extract infromation from each TextGrid

    #----------------------- when is S1 speaking
    S1Words = wordSegments(interval, 1)

    S1WPM = Vector{Float64}(undef,length(S1Words)) # initalize 1D array to store averaged WPM for each S1 segment
    S1time = Vector{Float64}(undef,length(S1Words)) # initalize 1D array to store averaged time for each S1 segment
    # for each S1 segment, calaculate the average F0 (filtering 0.0 out) and store them on S1F0Averaged
    for i in 1:length(S1WPM) # for each S1 segment

        S1WPM[i] = S1Words[i][4] / (S1Words[i][3] - S1Words[i][2]) * 60.0

        S1time[i] = S1Words[i][2] + (S1Words[i][3] - S1Words[i][2]) / 2.0
    end

    S1Data = S1WPM[S1WPM.!=0.0]# filter out zeros
    S1Time = S1time[S1WPM.!=0.0]
    plot(S1Time, S1Data,
        background_color=RGB{Float64}(0.466,0.117,0.560),
        foreground_color=:white,
        seriescolor=RGB{Float64}(0.95,0.2,0.1),
        xguide="Seconds",
        yguide="WPM",
        label="S1 Turns WPM"
        )

    scatter!(S1Time, S1Data,background_color=RGB{Float64}(0.466,0.117,0.560),
            foreground_color=:white, label=false,seriescolor=RGB{Float64}(0.95,0.2,0.1)
            )



    #------------------------------------------------ S2
    S2Words = wordSegments(interval, 2)

    S2WPM = Vector{Float64}(undef,length(S2Words)) # initalize 1D array to store averaged WPM for each S2 segment
    S2time = Vector{Float64}(undef,length(S2Words)) # initalize 1D array to store averaged time for each S2 segment
    # for each S2 segment, calaculate the average F0 (filtering 0.0 out) and store them on S2F0Averaged
    for i in 1:length(S2WPM) # for each S2 segment

        S2WPM[i] = S2Words[i][4] / (S2Words[i][3] - S2Words[i][2]) * 60.0

        S2time[i] = S2Words[i][2] + (S2Words[i][3] - S2Words[i][2]) / 2.0

    end

    S2Data = S2WPM[S2WPM.!=0.0]# filter out zeros
    S2Time = S2time[S2WPM.!=0.0]
    plot!(S2Time, S2Data,
        seriescolor=RGB{Float64}(0.1,0.6,0.9),
        xguide="Seconds",
        yguide="WPM",
        label="S2 Turns WPM"
        )

    scatter!(S2Time, S2Data, seriescolor=RGB{Float64}(0.1,0.6,0.9),
            label=false
            )


    # create directoty to store data in for WPM
    if !("WPM" in readdir(folder))
        mkdir(folder*raw"\WPM")
    end

    # save plot to WPM directory
    image = folder*raw"\WPM\WPM"*".png"
    savefig(image)


    # save data to CSV file
    csv_file = folder*raw"\WPM\WPM_CVS_"

    # equalize array length
    shorterTime = []
    shorterData = []

    longerTime = []
    longerData = []

    if length(S1Time) > length(S2Time)
        longerTime = S1Time
        longerData = S1Data

        append!(shorterTime, S2Time)
        append!(shorterData, S2Data)

        for i in 1:(length(S1Time) - length(S2Time))
            append!(shorterTime, " ")
            append!(shorterData, " ")
        end

    else length(S1Time) < length(S2Time)
        longerTime = S2Time
        longerData = S2Data

        append!(shorterTime, S1Time)
        append!(shorterData, S1Data)

        for i in 1:(length(S2Time) - length(S1Time))
            append!(shorterTime, " ")
            append!(shorterData, " ")
        end

    end

    WPM_Data = DataFrame([longerTime, longerData, shorterTime, shorterData], [:S1Time, :S1WPM, :S2Time, :S2WPM])

    CSV.write(csv_file*"WPM_Data.csv", WPM_Data)

    println("Finished!")

end

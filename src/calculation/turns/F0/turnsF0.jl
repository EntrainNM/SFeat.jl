
using SFeat, TextGrid, Plots, CSV, DataFrames

"""
After extracting featurs using the feature() function, we plot the average F0 for each speaker turn for further analysis.

# first method to extract features
test = readdlm(featureFile, ' ')
t = map(x -> parse(Float64,x[begin:end-1]),test[:,2])
F0 = map(x -> parse(Float64,x[begin:end-1]),test[:,4])

# second method
features = readFeature(featureFile)
"""
parentFolder = raw"C:\Users\hemad\Desktop\Master\ExtractFeatures\Before_After_Finished\CASD001_MAW_thesis_session_1"

featureFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".features" # path .features file
features = readFeature(featureFile) # read features
t = features[:,1]
F0 = features[:,3]


#---- for each speaker chunk\interval\segment, get an array of F0 values during the interval
TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid" # path to TextGrid file
interval = extract(TextGridFile)
# ------------------ S1
S1 = interval[1]
S1Location = [("S1" in S1[i]) for i in 1:length(S1)] # filter segment annoated as "S1" only
S1 = S1[S1Location] # filtered S1 segments

S1F0Averaged = Vector{Float64}(undef,length(S1)) # initalize 1D array to store averaged F0 for each S1 segment
S1timeAveraged = Vector{Float64}(undef,length(S1)) # initalize 1D array to store averaged time for each S1 segment
# for each S1 segment, calaculate the average F0 (filtering 0.0 out) and store them on S1F0Averaged
for i in 1:length(S1) # for each S1 segment

    start = round(S1[i][1], digits=2) # round to nearest 0.01 (default time step)
    finish = round(S1[i][2], digits=2)

    # find start and finish location in terms of features vectors
    featureStart = indexin(start, t)[1]
    featureFinish = indexin(finish, t)[1]

    intrv = featureStart:featureFinish

    F0Filtered = F0[intrv][ F0[intrv] .!= 0.0 ]

    try
        S1F0Averaged[i] = sum(F0Filtered)/length(F0Filtered)
    catch
        S1F0Averaged[i] = 0.0
    end

    S1timeAveraged[i] = S1[i][1] + (S1[i][2] - S1[i][1]) / 2 # average time for each segment
end


#--- plotting S1 data
S1Time = S1timeAveraged[S1F0Averaged.!=0]
S1Data = S1F0Averaged[S1F0Averaged.!=0]
plot(S1Time, S1Data,
     background_color=RGB{Float64}(0.466,0.117,0.560),
     foreground_color=:white,
     seriescolor=RGB{Float64}(0.95,0.2,0.1),
     label="S1 average F0"
     )

scatter!(S1Time, S1Data,
         background_color=RGB{Float64}(0.466,0.117,0.560),
         foreground_color=:white, label=false,
         seriescolor=RGB{Float64}(0.95,0.2,0.1)
         )

# averaged line
# using Statistics
# average_interval = 4 # how many data points to average on the plot
#
# ave1 = Array{Float64}(undef, trunc(Int,length(S1Data)/ average_interval ))
# axe1 = Array{Float64}(undef, trunc(Int,length(S1Time)/ average_interval ))
# for i in 1:length(ave1)
#     ave1[i] = mean(S1Data[ average_interval *(i-1)+1 : average_interval *(i)])
#     axe1[i] = mean(S1Time[ average_interval *(i-1)+1 : average_interval *(i)])
# end
# plot!(axe1,ave1,label = false,lw=4,seriescolor=RGB{Float64}(0.95,0.2,0.1))


# --------------------------------------- S2
S2 = interval[5]
S2Location = [("S2" in S2[i]) for i in 1:length(S2)] # filter segment annoated as "S2" only
S2 = S2[S2Location] # filtered S2 segments

S2F0Averaged = Vector{Float64}(undef,length(S2)) # initalize 1D array to store averaged F0 for each S2 segment
S2timeAveraged = Vector{Float64}(undef,length(S2)) # initalize 1D array to store averaged time for each S1 segment
# for each S2 segment, calaculate the average F0 (filtering 0.0 out) and store them on S2F0Averaged
for i in 1:length(S2) # for each S2 segment

    start = round(S2[i][1], digits=2) # round to nearest 0.01 (default time step)
    finish = round(S2[i][2], digits=2)

    # find start and finish location in terms of features vectors
    featureStart = indexin(start, t)[1]
    featureFinish = indexin(finish, t)[1]

    intrv = featureStart:featureFinish

    F0Filtered = F0[intrv][ F0[intrv] .!= 0.0 ]

    try
        S2F0Averaged[i] = sum(F0Filtered)/length(F0Filtered)
    catch
        S2F0Averaged[i] = 0.0
    end

    S2timeAveraged[i] = S2[i][1] + (S2[i][2] - S2[i][1]) / 2 # average time for each segment
end


#--- plotting S2 data
S2Time = S2timeAveraged[S2F0Averaged.!=0]
S2Data = S2F0Averaged[S2F0Averaged.!=0]
plot!(S2Time, S2Data,
     seriescolor=RGB{Float64}(0.1,0.6,0.9),
     xguide="Seconds",
     yguide="F0",
     label="S2 average F0"
     )


scatter!(S2Time, S2Data,
         seriescolor=RGB{Float64}(0.1,0.6,0.9),
         label=false
         )

# averaged line
# using Statistics
# ave2 = Array{Float64}(undef, trunc(Int,length(S2Data)/ average_interval ))
# axe2 = Array{Float64}(undef, trunc(Int,length(S2Time)/ average_interval ))
# for i in 1:length(ave2)
#     ave2[i] = mean(S2Data[ average_interval *(i-1)+1 : average_interval *(i)])
#     axe2[i] = mean(S2Time[ average_interval *(i-1)+1 : average_interval *(i)])
# end
#
# plot!(axe2,ave2,label = false,lw=4,seriescolor=RGB{Float64}(0.1,0.6,0.9))







# create directoty to store data in for F0
if !("F0" in readdir(parentFolder))
    mkdir(parentFolder*raw"\F0")
end

# save plot to image
image = parentFolder*raw"\F0\F0.png"
savefig(image)

# save data to CSV file
csv_file = parentFolder*raw"\F0\F0_CSV_"

S1CSV = DataFrame([S1Time, S1Data], [:S1Time, :S1])
S2CSV = DataFrame([S2Time, S2Data], [:S2Time, :S2])
# CSV.write(csv_file, [S1data S2data])
CSV.write(csv_file*"S1.csv", S1CSV)
CSV.write(csv_file*"S2.csv", S2CSV)

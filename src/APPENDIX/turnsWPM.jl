using SFeat, TextGrid
using Plots; default(dpi=200)

# plot WPM for each speaker along with a moving average (averag over 5-segemnt intervals)

# path to transcribed TextGrid file
parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CASD\CASD009_061919"

TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid" # path to TextGrid file
interval = extract(TextGridFile)



#-------------- accociate speaker segments with words
# S1Words is a vector containing start and end stamps of S1' segments, number of words, and a vector containing end stamps of each word
# Note: if a word ends withing a S1 segment, that word is considered to be part of that particular S1 segment
# eventaully, I will use S1Words variable to find the number of words said by S1 in time segments (5s, 10s,...)

# when is S1 speaking
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


#---------------------------- plotting
# filter out zeros
S1Data = S1WPM#[S1WPM.!=0.0]
S1Time = S1time#[S1WPM.!=0.0]
S2Data = S2WPM#[S2WPM.!=0.0]
S2Time = S2time#[S2WPM.!=0.0]

# "S1 averaged WPM turns"
# "S2 averaged WPM turns"
default(dpi=300, w=2, markersize=4, size=(1900,600),framestyle = :box)
plot(S1Time, S1Data, seriescolor=RGB{Float64}(0.95,0.2,0.1),
xguide="Turn's Time", yguide="WPM", label="S1",
shape = :circle, thickness_scaling = 2)
plot!(S2Time, S2Data, seriescolor=RGB{Float64}(0.1,0.6,0.9),
 shape=:star4, label="S2"
)

cnt = "ttttttt"
image = raw"C:\Users\hemad\Desktop\Master\Experiments\APPENDIX\WPM"*"\\$cnt.png"
savefig(image)


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


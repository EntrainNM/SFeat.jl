
using SFeat, TextGrid, Plots

"""
After extracting featurs using the feature() function, we plot the average F0 for each speaker turn for further analysis.

# first method to extract features
test = readdlm(featureFile, ' ')
t = map(x -> parse(Float64,x[begin:end-1]),test[:,2])
F0 = map(x -> parse(Float64,x[begin:end-1]),test[:,4])

# second method
features = readFeature(featureFile)
"""
parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CNT\CNT004_06012018"

folder = readdir(parentFolder, join=true)
featureFiles = folder[ endswith.(folder, "TextGrid") ]

#---- for each speaker chunk\interval\segment, get an array of F0 values during the interval
TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid" # path to TextGrid file
interval = extract(TextGridFile)


# Extract S1&S2 segments
S1 = interval[1]; S2 = interval[5];
S1 = S1[map(x -> x[3] == "S1", interval[1])]; S2 = S2[map(x -> x[3] == "S2", interval[5])];

f0_S1, f0_S2 = f0_read(parentFolder);

S1Data = [ sum(i)/length(i) for i in f0_S1]
S2Data = [ sum(i)/length(i) for i in f0_S2]

S1Time = [ i[1] + (i[2] - i[1]) / 2 for i in S1 ]
S2Time = [ i[1] + (i[2] - i[1]) / 2 for i in S2 ]


default(dpi=300, w=2, markersize=3, legend=:outertop)
plot(S1Time, S1Data, background_color=RGB{Float64}(0.466,0.117,0.560),
        foreground_color=:white, seriescolor=RGB{Float64}(0.95,0.2,0.1),
        xguide="Turn's Time", yguide="f0", label="S1 averaged f0 turns",
        )
scatter!(S1Time, S1Data,background_color=RGB{Float64}(0.466,0.117,0.560),
            foreground_color=:white, label=false,
            seriescolor=RGB{Float64}(0.95,0.2,0.1),
            )
plot!(S2Time, S2Data,background_color=RGB{Float64}(0.466,0.117,0.560), foreground_color=:white,
        seriescolor=RGB{Float64}(0.1,0.6,0.9), label="S2 averaged f0 turns")
scatter!(S2Time, S2Data,background_color=RGB{Float64}(0.466,0.117,0.560),
            foreground_color=:white,label=false,
            seriescolor=RGB{Float64}(0.1,0.6,0.9)      
)



# combine S1 & S2 segments
turns = [[ S1Data S1Time fill("S1", (length(S1Time))) ]; [ S2Data S2Time fill("S2", (length(S2Time))) ]]# STORE ARRAY AS [F0 TIME SPEAKER]
turns  = [turns[i,:] for i in 1:length(turns[:,1])] # convert matrix into array of arrays
p = sortperm([i[2] for i in turns]) # sort turns according to start time
combined_F0 = turns[p] # S1 and S2 combined

#  discarded segments due to 0.0 f0
discard = sum([i[1] for i in combined_F0] .== 0)
deleteat!(combined_F0,[i[1] for i in combined_F0] .== 0)

# combine consecutive speakers
i=0
while (i <= length(combined_F0))
    global i+=1
    if (i <= length(combined_F0)-1) && (combined_F0[i][3] == combined_F0[i+1][3])
        # combine segments
        combined_F0[i][1] = (combined_F0[i][1]+combined_F0[i+1][1]) / 2
        combined_F0[i][2] = (combined_F0[i][2]+combined_F0[i+1][2]) / 2

        deleteat!(combined_F0,i+1)
        global i = 1 # go back to begining
        # println("--------------")
    end
end

combined_F0
"""
Looking at speaker 1 (S1) we calculcate ΔS2=(S2Next - S2Prev) (does S2 gain or lose F0
from the last S2 segments?)

We also set ΔS2S1=(S1 - S2Prev) (does S1 gain or lose F0 from the last S2 segment?)

★ if ΔS2 & ΔS2S1 have the same sign (+ or -) ==> S2's entrainment converging

★ if ΔS2 & ΔS2S1 have the different sign ==> S2's entrainment diverging
"""
# comparing previous turns - S2 based on S1
ΔS2 = []; ΔS2S1 = []
total_turns = 0

# assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
for i in 2:length(combined_F0)
    try
        if combined_F0[i][3] == "S1"# if S1 speaking
            S2Prev = round(combined_F0[i-1][1],digits=3)
            S1 = round(combined_F0[i][1],digits=3)
            S2Next = round(combined_F0[i+1][1],digits=3)

            append!(ΔS2, sign(S2Next - S2Prev))# ΔS2 tells if S2 increased or decresed WPM from last S2 segment
            append!(ΔS2S1, sign(S1 - S2Prev))# ΔS2S1 tells if S1 increased or decresed from previous S2

            println("Turn #$i: {1} ",combined_F0[i-1][3]," F0 = ",
            S2Prev," {2} ",combined_F0[i][3]," F0 = ", S1,
            " {3} ", combined_F0[i+1][3]," F0 = ", S2Next,
            " ==> ", sign(S2Next - S2Prev)*sign(S1 - S2Prev))

            total_turns += 1
        end
    catch
        println("Skip!")
        nothing
    end
end

# 139

results = ΔS2.*ΔS2S1
prob = sum(results[results.>0.0]) / length(results)*100.0

print(parentFolder[findlast("\\",parentFolder)[1]+1:end], " Results: \n")
println("S2 entrained to S1 ",prob,"% of the time || skipped turns: $discard\\$total_turns")



# #
# # create directoty to store data in for F0
# if !("F0" in readdir(parentFolder))
#     mkdir(parentFolder*raw"\F0")
# end
#
# # save plot to image
# image = parentFolder*raw"\F0\F0.png"
# savefig(image)
#
# # save data to CSV file
# using CSV, DataFrames
#
# csv_file = parentFolder*raw"\F0\F0_CSV_"
#
# S1CSV = DataFrame([S1Time, S1Data], [:S1Time, :S1])
# S2CSV = DataFrame([S2Time, S2Data], [:S2Time, :S2])
# # CSV.write(csv_file, [S1data S2data])
# CSV.write(csv_file*"S1.csv", S1CSV)
# CSV.write(csv_file*"S2.csv", S2CSV)
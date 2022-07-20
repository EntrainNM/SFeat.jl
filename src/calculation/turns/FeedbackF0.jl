
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
parentFolder = raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Children\CNT_NEW_Finished\CASD012_062519"

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

S2Time = S2timeAveraged[S2F0Averaged.!=0]
S2Data = S2F0Averaged[S2F0Averaged.!=0]




# combining S1 and S2 F0 values
# combined_F0 have the format [F0, Time, Speaker #]
combined_F0 = Array{Any}(undef,length(S1Time)+length(S2Time))


for i in 1:length(S1Time)
    combined_F0[i] = [S1Data[i], S1Time[i], "S1"]
end


for i in 1:length(S2Time)
    combined_F0[length(S1Time) + i] = [S2Data[i], S2Time[i], "S2"]
end

p = sortperm([i[2] for i in combined_F0])

combined_F0 = combined_F0[p]

# print consecutive speaker segments
# for i in 2:length(combined_F0)
#     if combined_F0[i][3] == combined_F0[i-1][3]
#         println(i)
#     end
# end

# combine consecutive speakers
i=0
while (i <= length(combined_F0))
    i+=1
    if (i <= length(combined_F0)-1) && (combined_F0[i][3] == combined_F0[i+1][3])
        # combine segments
        combined_F0[i][1] = (combined_F0[i][1]+combined_F0[i+1][1]) / 2
        combined_F0[i][2] = (combined_F0[i][2]+combined_F0[i+1][2]) / 2

        deleteat!(combined_F0,i+1)
        i = 1 # go back to begining
        # println("--------------")
    end
end


combined_F0
# println.( [ i for i in combined_F0 ] )[1]
# plot([i[2] for i in combined_F0], [i[1] for i in combined_F0])





"""
Looking at speaker 1 (S1) we calculcate ΔS2=(S2Next - S2Prev) (does S2 gain or lose F0
from the last S2 segments?)

We also set ΔS2S1=(S1 - S2Prev) (does S1 gain or lose F0 from the last S2 segment?)

★ if ΔS2 & ΔS2S1 have the same sign (+ or -) ==> S2's entrainment converging

★ if ΔS2 & ΔS2S1 have the different sign ==> S2's entrainment diverging
"""
# comparing previous turns - S2 based on S1
prevS1F0, prevS2F0 = 0.0, 0.0
prevS1F0
ΔS2 = []
ΔS2S1 = []

# assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
for i in 1:length(combined_F0)
    try

        if combined_F0[i][3] == "S1" # if S1 speaking
            S2Prev = round(combined_F0[i-1][1],digits=3)
            S1 = round(combined_F0[i][1],digits=3)
            S2Next = round(combined_F0[i+1][1],digits=3)

            # println("Current ",combined_F0[i][6]," F0 = ", S1," previous ",combined_F0[i-1][6]," F0 = ", S2Prev, " Next ", combined_F0[i+1][6]," F0 = ", S2Next)

            # ΔS2 tells if S2 increased or decresed F0 from last S2 segment
            append!(ΔS2, sign(S2Next - S2Prev))
            # ΔS2S1 tells if S1 increased or decresed from previous S2
            append!(ΔS2S1, sign(S1 - S2Prev))
            end
        catch
            # println("Skip!")
            nothing
        end
end

for i in 1:length(ΔS2)
    # println("ΔS2 = ", ΔS2[i], " ΔS2S1 = ", ΔS2S1[i], " Results: ", (ΔS2[i]*ΔS2S1[i]))
end

test = ΔS2.*ΔS2S1
prob = sum(test[test.>0.0]) / length(test)

print(file[findlast("\\",file)[1]+1:end], " Results: \n")
println("S2 entrained to S1 in terms of F0 ",100.0*prob,"% of the time")

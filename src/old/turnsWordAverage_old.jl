
# plot WPM for each speaker along with a moving average (averag over 5-segemnt intervals)

using SFeat, TextGrid, Plots
default(dpi=300)
# path to transcribed TextGrid file

file = raw"C:\Users\hemad\Desktop\Master\ExtractFeatures\testing\CASD001_MAW_thesis_session_1\CASD001_MAW_thesis_session_1.TextGrid"
interval = extract(file)


#-------------- accociate speaker segments with words
# S1Words is a vector containing start and end stamps of S1' segments, number of words, and a vector containing end stamps of each word
# Note: if a word ends withing a S1 segment, that word is considered to be part of that particular S1 segment
# eventaully, I will use S1Words variable to find the number of words said by S1 in time segments (5s, 10s,...)

# when is S1 speaking
S1Location = [("S1" in interval[1][i]) for i in 1:length(interval[1])]
timedWords = Vector{Vector{Any}}(undef,length(interval[1]))
# skip <0.2s chunks
minSegment = 0.2

for i in 1:length(S1Location)
    test = 0
    endStamp = []
    for n in 1:length(interval[10])
        #  (if word ends withing S1 ith segment)                                             & (segment is longer than 0.2 second)                  # word segment not empty
        if ((interval[1][i][1]<interval[10][n][2]) & (interval[10][n][2]<interval[1][i][2])) & ((interval[1][i][2]-interval[1][i][1]) > minSegment) & !isempty(interval[10][n][3])
            test += 1
            append!( endStamp, interval[10][n][2] )
        # else
        #     println(interval[10][i])
        end
    end
    # S1Location[i] ? println("S1 has ",test," words") : nothing
    timedWords[i] = [i,interval[1][i][1],interval[1][i][2],test,endStamp,1]
end
# [S1 location, start, end, # of words, [words end timestamps], speaker # (1 or 2)]
S1Words = timedWords[S1Location]




#------------------------------------------------ S2
S2Location = [("S2" in interval[5][i]) for i in 1:length(interval[5])]
timedWords = Vector{Vector{Any}}(undef,length(interval[5]))
for i in 1:length(S2Location)
    test = 0
    endStamp = []
    for n in 1:length(interval[11])
        # if word ends withing S2 ith segment
        if ((interval[5][i][1]<interval[11][n][2]) & (interval[11][n][2]<interval[5][i][2])) & ((interval[5][i][2]-interval[5][i][1]) > minSegment) & !isempty(interval[11][n][3])
            test += 1
            append!( endStamp, interval[11][n][2] )
        end
    end
    timedWords[i] = [i,interval[5][i][1],interval[5][i][2],test,endStamp,2]
end
# [S2 location, start, end, # of words, [words end timestamps], speaker # (1 or 2)]
S2Words = timedWords[S2Location]

#----------- words end stamps of S1: store the end time of each words S1 said
endStampsS1 = []
for i in 1:length(S1Words)
    for n in 1:length(S1Words[i][5])
        append!(endStampsS1,S1Words[i][5][n])
    end
end
endStampsS1

#--------------- experiment 1: extracting WPS for S1 (turn taking)
# for each turn (S1 segment) calaculate WPS for that segment

# collect S1 and S2 segments together and sort by "start segment"
turns = S1Words
append!(turns,S2Words)

# sort turns according to start time
p = sortperm([i[2] for i in turns])
temp = turns[p]
orderedTurns = temp

# remove turn if doesn't contain transcribed words
for i in length(temp):-1:1
    if temp[i][4]==0
        deleteat!(orderedTurns,i)
    end
end

orderedTurns[5]
orderedTurns[5][3]-orderedTurns[5][2]

plot1 = []
plot2 = []
plotAll = []

for i in 1:length(orderedTurns)
    # IntervalNumberofWords ÷ (endTime - startTime of interval in seconds) * 60seconds ÷ 1minute
    temp = orderedTurns[i][4]/(orderedTurns[i][3]-orderedTurns[i][2]) * 60
    append!(plotAll,temp)
    if orderedTurns[i][6] == 1
        append!(plot1,temp)
        append!(plot2,0)
    else
        append!(plot1,0)
        append!(plot2,temp)
    end
end

plot(collect(1:length(plot1))[plot1.!=0],plot1[plot1.!=0],background_color=RGB{Float64}(0.466,0.117,0.560),
     foreground_color=:white,
     seriescolor=RGB{Float64}(0.95,0.2,0.1),
     xguide="turns",
     yguide="WPM",
     label="S1 turns WPM"
     )
scatter!(collect(1:length(plot1))[plot1.!=0],plot1[plot1.!=0],background_color=RGB{Float64}(0.466,0.117,0.560),
        foreground_color=:white, label=false,
        seriescolor=RGB{Float64}(0.95,0.2,0.1))

#


# averaged line
using Statistics
temp1 = collect(1:length(plot1))[plot1.!=0]
temp2 = plot1[plot1.!=0]
average_interval = 2 # how many data points to average on the plot

ave1 = Array{Float64}(undef, trunc(Int,length(temp2)/ average_interval ))
axe1 = Array{Float64}(undef, trunc(Int,length(temp1)/ average_interval ))
for i in 1:length(ave1)
    ave1[i] = mean(temp2[ average_interval *(i-1)+1 : average_interval *(i)])
    axe1[i] = mean(temp1[ average_interval *(i-1)+1 : average_interval *(i)])
end
plot!(axe1,ave1,label = false,lw=4,seriescolor=RGB{Float64}(0.95,0.2,0.1))



plot!(collect(1:length(plot2))[plot2.!=0],
      plot2[plot2.!=0], label="S2 turns WPM",
      seriescolor=RGB{Float64}(0.1,0.6,0.9))
scatter!(collect(1:length(plot2))[plot2.!=0],
        plot2[plot2.!=0], label=false,
        seriescolor=RGB{Float64}(0.1,0.6,0.9))

# averaged line
using Statistics
temp1 = collect(1:length(plot2))[plot2.!=0]
temp2 = plot2[plot2.!=0]

ave2 = Array{Float64}(undef, trunc(Int,length(temp2)/ average_interval ))
axe2 = Array{Float64}(undef, trunc(Int,length(temp1)/ average_interval ))
for i in 1:length(ave2)
    ave2[i] = mean(temp2[ average_interval *(i-1)+1 : average_interval *(i)])
    axe2[i] = mean(temp1[ average_interval *(i-1)+1 : average_interval *(i)])
end

plot!(axe2,ave2,label = false,lw=4,seriescolor=RGB{Float64}(0.1,0.6,0.9))


# save plot as .png image
# savefig(file[begin:findlast('\\',file)]*"averagedWPM"*".png")


# save data to a CSV file
using CSV, DataFrames

WPM_CSV = DataFrame(rand(10,10), :auto)
CSV.write(file[begin:findlast('\\',file)]*"WPM"*".csv", WPM_CSV)

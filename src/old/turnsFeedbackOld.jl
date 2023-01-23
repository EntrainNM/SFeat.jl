
# plot WPM for each speaker along with a moving average (averag over 5-segemnt intervals)

using TextGrid, Plots
# path to transcribed TextGrid file

file = raw"C:\Users\hemad\Desktop\Master\calculation\WPM\CASD_CNT_Completed\CASD019_07182019_Transcribed.TextGrid"
interval = extract(file)


#-------------- accociate speaker segments with words
# S1Words is a vector containing start and end stamps of S1' segments, number of words, and a vector containing end stamps of each word
# Note: if a word ends withing a S1 segment, that word is considered to be part of that particular S1 segment
# eventaully, I will use S1Words variable to find the number of words said by S1 in time segments (5s, 10s,...)

# when is S1 speaking
S1Location = [("S1" in interval[1][i]) for i in 1:length(interval[1])]
timedWords = Vector{Vector{Any}}(undef,length(interval[1]))
# skip <1.0s segments
minSegment = 0.5
for i in 1:length(S1Location)
    test = 0
    endStamp = []
    for n in 1:length(interval[10])
        #  (if word ends withing S1 ith segment)                                             & (segment is longer than 1 second)
        if ((interval[1][i][1]<interval[10][n][2]) & (interval[10][n][2]<interval[1][i][2])) & ((interval[1][i][2]-interval[1][i][1]) > minSegment)
            test += 1
            append!( endStamp, interval[10][n][2] )
        # else
        #     println(interval[10][i])
        end
    end
    # S1Location[i] ? println("S1 has ",test," words") : nothing
    timedWords[i] = [i,interval[1][i][1],interval[1][i][2],test,endStamp,"S1"]
end
# [S1 location, start, end, # of words, [words end timestamps], speaker # (1 or 2)]
S1Words = timedWords[S1Location]
interval
S1Words[1]
#------------------------------------------------ S2
S2Location = [("S2" in interval[5][i]) for i in 1:length(interval[5])]
timedWords = Vector{Vector{Any}}(undef,length(interval[5]))
for i in 1:length(S2Location)
    test = 0
    endStamp = []
    for n in 1:length(interval[11])
        # if word ends withing S2 ith segment
        if ((interval[5][i][1]<interval[11][n][2]) & (interval[11][n][2]<interval[5][i][2])) & ((interval[5][i][2]-interval[5][i][1]) > minSegment)
            test += 1
            append!( endStamp, interval[11][n][2] )
        end
    end
    timedWords[i] = [i,interval[5][i][1],interval[5][i][2],test,endStamp,"S2"]
end
# [S2 location, start, end, # of words, [words end timestamps], speaker # (1 or 2)]
S2Words = timedWords[S2Location]


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
orderedTurns

# add WPM element for each speaker segment in orderedTurns array
for i in 1:length(orderedTurns)
    WPM = orderedTurns[i][4]/(orderedTurns[i][3]-orderedTurns[i][2]) * 60
    append!(orderedTurns[i],WPM)
end

# for i in 1:length(orderedTurns)
#     s = orderedTurns[i][6]
#     wpm = orderedTurns[i][7]
#     println("speaker $s WPM: $wpm")
# end

#----------------------------------
# combine consecutive speakers
i=0
while (i <= length(orderedTurns))
    i+=1
    if (i <= length(orderedTurns)-1) && (orderedTurns[i][6] == orderedTurns[i+1][6])
        s = orderedTurns[i][6]
        # println("speaker #$s: $i ")

        # combine segments
        orderedTurns[i][3] = orderedTurns[i+1][3]
        orderedTurns[i][4] += orderedTurns[i+1][4]
        append!(orderedTurns[i][5],orderedTurns[i+1][5])
        # println(orderedTurns[i][7]," = (",orderedTurns[i][7]," + ",orderedTurns[i+1][7],")/2")
        orderedTurns[i][7] = (orderedTurns[i][7] + orderedTurns[i+1][7])/2
        deleteat!(orderedTurns,i+1)
        i = 1
    end
end

# comparing previous turns
prevS1WPM, prevS2WPM = 0.0, 0.0
plus = 0
minus = 0
for i in 1:length(orderedTurns)-1
    # println(i," speaker#",orderedTurns[i][6]," WPM: ",orderedTurns[i][7])

    if orderedTurns[i][6] == "S1" # if S1 segment, update prevS1WPM
        # println("S#",orderedTurns[i][6]," new WPM = ",orderedTurns[i][7]," old WPM = ", prevS1WPM)
        prevS1WPM = orderedTurns[i][7]
        print("Current S",orderedTurns[i][6]," WPM = ",round(orderedTurns[i][7],digits=3)," previous S2 WPM = ", round(prevS2WPM,digits=3), " Next S", orderedTurns[i+1][6]," WPM = ", round(orderedTurns[i+1][7],digits=3))
        gain = (orderedTurns[i+1][7] - prevS2WPM)/orderedTurns[i+1][7]
        gain > 0.0 ? plus += 1 : minus -= 1
        println(" ---------------ΔS2 = ", round(gain,digits=3))
    else # if S2 segment, update prevS2WPM
        # println("S#",orderedTurns[i][6]," new WPM = ",orderedTurns[i][7]," old WPM = ", prevS2WPM)
        prevS2WPM = orderedTurns[i][7]
    end
end


# for i in 1:length(orderedTurns)
#     order = orderedTurns[i][6]
#     s = orderedTurns[i][6]
#     wpm = orderedTurns[i][7]
#     println("$order S$s WPM: $wpm")
# end


# orderedTurns[3]

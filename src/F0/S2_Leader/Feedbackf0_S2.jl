using SFeat, TextGrid
# path to transcribed TextGrid file
parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished\A037_A038"
TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid" # path to TextGrid file
interval = extract(TextGridFile)
S1Words = wordSegments(interval,1)
S2Words = wordSegments(interval,2)

# collect S1 and S2 segments together and sort by "start segment"
turns = S1Words
append!(turns,S2Words)

# sort turns according to start time
p = sortperm([i[2] for i in turns])
orderedTurns = turns[p] # S1 and S2 combined_F0
# add WPM element for each speaker segment in orderedTurns array
for i in 1:length(orderedTurns)
    WPM = orderedTurns[i][4]/(orderedTurns[i][3]-orderedTurns[i][2]) * 60
    append!(orderedTurns[i],WPM)
end

# combine consecutive speakers
i=0
while (i <= length(orderedTurns))
    i+=1
    if (i <= length(orderedTurns)-1) && (orderedTurns[i][6] == orderedTurns[i+1][6])
        s = orderedTurns[i][6]
        orderedTurns[i][3] = orderedTurns[i+1][3]
        orderedTurns[i][4] += orderedTurns[i+1][4]
        append!(orderedTurns[i][5],orderedTurns[i+1][5])
        orderedTurns[i][7] = (orderedTurns[i][7] + orderedTurns[i+1][7])/2
        deleteat!(orderedTurns,i+1)
        i = 1 # go back to begining
    end
end

"""
How S1 entrains to S2
"""
# comparing previous turns - S1 based on S2
prevS1WPM, prevS2WPM = 0.0, 0.0
ΔS1 = []; ΔS1S2 = []

# assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
for i in 2:length(orderedTurns)
    try

        if orderedTurns[i][6] == "S2" # if S2 segment
            if ((orderedTurns[i-1][7] != 0.0) & (orderedTurns[i][7] != 0.0) & (orderedTurns[i+1][7] != 0.0))
                S1Prev = round(orderedTurns[i-1][7],digits=3)
                S2 = round(orderedTurns[i][7],digits=3)
                S1Next = round(orderedTurns[i+1][7],digits=3)

                println("(1) ", orderedTurns[i-1][6]," WPM = ", S1Prev, " (2) ",
                orderedTurns[i][6]," WPM = ", S2, " (3) ", orderedTurns[i+1][6],
                " WPM = ", S1Next," ==> ", sign(S1Next - S1Prev)*sign(S2 - S1Prev))

                append!(ΔS1, sign(S1Next - S1Prev))# ΔS1 tells if S1 increased or decresed WPM from last S1 segment
                append!(ΔS1S2, sign(S2 - S1Prev))# ΔS1S2 tells if S2 increased or decresed from previous S1
        
            end
        end
        catch
            nothing
        end
end

# for i in 1:length(ΔS1)
#     println("ΔS1 = ", ΔS1[i], " ΔS1S2 = ", ΔS1S2[i], " Results: ", (ΔS1[i]*ΔS1S2[i]))
# end

results = ΔS1.*ΔS1S2
prob = round(digits=2, sum(results[results.>0.0]) / length(results) * 100 )

print(TextGridFile[findlast("\\",TextGridFile)[1]+1:end], " S1 entrained to S2 ", prob,"% of the time")
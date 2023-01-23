
# plot WPM for each speaker along with a moving average (averag over 5-segemnt intervals)

using SFeat, TextGrid
# path to transcribed TextGrid file
# CASD019_07182019_Transcribed 80 entrainment
parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished\A043_A044"

TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid" # path to TextGrid file
interval = extract(TextGridFile)

# when is S1 speaking, get words teir information
# [S1 location, start, end, # of words, [words end timestamps], speaker # (1 or 2)]
S1Words = wordSegments(interval,1)
S2Words = wordSegments(interval,2)


#--------------- experiment 1: extracting WPS for S1 (turn taking)
# for each turn (S1 segment) calaculate WPS for that segment

# collect S1 and S2 segments together and sort by "start segment"
turns = S1Words
append!(turns,S2Words)

# sort turns according to start time
p = sortperm([i[2] for i in turns])
orderedTurns = turns[p] # S1 and S2 combined

# remove turn if doesn't contain transcribed words
# for i in length(temp):-1:1
#     if temp[i][4]==0
#         deleteat!(orderedTurns,i)
#     end
# end
# orderedTurns

# add WPM element for each speaker segment in orderedTurns array
for i in 1:length(orderedTurns)
    WPM = orderedTurns[i][4]/(orderedTurns[i][3]-orderedTurns[i][2]) * 60
    append!(orderedTurns[i],WPM)
end

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
        i = 1 # go back to begining
    end
end



"""
Looking at speaker 1 (S1) we calculcate ΔS2=(S2Next - S2Prev) (does S2 gain or lose WPM
from the last S2 segments?)

We also set ΔS2S1=(S1 - S2Prev) (does S1 gain or lose WPM from the last S2 segment?)

★ if ΔS2 & ΔS2S1 have the same sign (+ or -) ==> S2's entrainment converging to S1

★ if ΔS2 & ΔS2S1 have the different sign ==> S2's entrainment diverging from S1
"""
# comparing previous turns - S2 based on S1
prevS1WPM, prevS2WPM = 0.0, 0.0
ΔS2 = []; ΔS2S1 = []
skipped = 0
# assuming there is no consecutive speakers (S1 alwasy followed by S2 segment) since consecutive speakers were removed eariler
for i in 2:length(orderedTurns)
    try
        if orderedTurns[i][6] == "S1" # if S1 segment
            if ((orderedTurns[i-1][7] != 0.0) & (orderedTurns[i][7] != 0.0) & (orderedTurns[i+1][7] != 0.0))
                S2Prev = round(orderedTurns[i-1][7],digits=3)
                S1 = round(orderedTurns[i][7],digits=3)
                S2Next = round(orderedTurns[i+1][7],digits=3)

                append!(ΔS2, sign(S2Next - S2Prev))# ΔS2 tells if S2 increased or decresed WPM from last S2 segment
                append!(ΔS2S1, sign(S1 - S2Prev))# ΔS2S1 tells if S1 increased or decresed from previous S2
                
                println("$i (1) ",orderedTurns[i-1][6]," WPM = ", S2Prev, " (2) ",
                orderedTurns[i][6]," WPM = ",S1, " (3) ", orderedTurns[i+1][6],
                " WPM = ", S2Next," ==> ", sign(S2Next - S2Prev)*sign(S1 - S2Prev))
            else
                skipped += 1
            end
        end
    catch
        nothing
    end
end



results = ΔS2.*ΔS2S1
prob = sum(results[results.>0.0]) / length(results)

print(parentFolder[findlast("\\",parentFolder)[1]+1:end], " Results: \n")
println("S2 entrained to S1 ",100.0*prob,"% of the time | $skipped")


# for i in 1:length(ΔS2)
#     println("ΔS2 = ", ΔS2[i], " ΔS2S1 = ", ΔS2S1[i], " Results: ", (ΔS2[i]*ΔS2S1[i]))
# end
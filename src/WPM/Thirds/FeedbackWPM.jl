
# plot WPM for each speaker along with a moving average (averag over 5-segemnt intervals)

using SFeat, TextGrid, Plots
# path to transcribed TextGrid file
# CASD019_07182019_Transcribed 80 entrainment
parentFolder = raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Children\CNT_NEW_Finished\CASD\CASD020_07172019"

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
temp = turns[p]
orderedTurns = temp # S1 and S2 combined

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

#----------------------------------
# combine consecutive speakers
orderedTurns

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
        # println("--------------")
    end
end

orderedTurns

# Divide conversation into three portion
duration = orderedTurns[end][3] - orderedTurns[1][2]
one = orderedTurns[ BitVector([ i[3]<duration/3 for i in orderedTurns]) ]

two = orderedTurns[ BitVector([ duration/3<i[3]<duration*2/3 for i in orderedTurns]) ]

three = orderedTurns[ BitVector([ i[3]>duration*2/3 for i in orderedTurns]) ]

"""
Looking at speaker 1 (S1) we calculcate ΔS2=(S2Next - S2Prev) (does S2 gain or lose WPM
from the last S2 segments?)

We also set ΔS2S1=(S1 - S2Prev) (does S1 gain or lose WPM from the last S2 segment?)

★ if ΔS2 & ΔS2S1 have the same sign (+ or -) ==> S2's entrainment converging to S1

★ if ΔS2 & ΔS2S1 have the different sign ==> S2's entrainment diverging from S1
"""
# comparing previous turns - S2 based on S1

ct = 1
for section in [one, two, three]
    prevS1WPM, prevS2WPM = 0.0, 0.0
    prevS1WPM
    ΔS2 = []
    ΔS2S1 = []

    print(ct, " ")
    ct = ct+1

    # assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
    for i in 1:length(section)
        try

            if section[i][6] == "S1" # if S1 segment
                S2Prev = round(section[i-1][7],digits=3)
                S1 = round(section[i][7],digits=3)
                S2Next = round(section[i+1][7],digits=3)

                # println("Previous ",section[i-1][6]," WPM = ", S2Prev, " Current ",section[i][6]," WPM = ", S1, " Next ", section[i+1][6]," WPM = ", S2Next)

                # ΔS2 tells if S2 increased or decresed WPM from last S2 segment
                append!(ΔS2, sign(S2Next - S2Prev))
                # ΔS2S1 tells if S1 increased or decresed from previous S2
                append!(ΔS2S1, sign(S1 - S2Prev))
                end
        catch
            # println("Skip!")
            nothing
        end
    end

    try
        test = ΔS2.*ΔS2S1
        prob = sum(test[test.>0.0]) / length(test)
        println("S2 entrained to S1 ",100.0*prob,"% of the time")
    catch
        print("Error")
    end

    # print(file[findlast("\\",file)[1]+1:end], " Results: \n")

end

println("\n")

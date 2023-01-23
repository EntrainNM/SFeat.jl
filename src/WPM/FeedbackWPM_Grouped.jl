using SFeat, TextGrid
# path to transcribed TextGrid file
# "C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CNT"
# "C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished"
parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CASD"
folders = readdir(parentFolder, join=true)

average = []
for folder in folders
    file = folder*folder[findlast("\\",folder)[1] : end]*".TextGrid"
    interval = extract(file)

    S1Words = wordSegments(interval,1); S2Words = wordSegments(interval,2);


    #--------------- experiment 1: extracting WPS for S1 (turn taking)
    # for each turn (S1 segment) calaculate WPS for that segment
    turns = S1Words
    append!(turns,S2Words)

    p = sortperm([i[2] for i in turns])
    orderedTurns = turns[p] # S1 and S2 combined

    # remove turn if doesn't contain transcribed words
    # for i in length(temp):-1:1
    #     if temp[i][4]==0
    #         deleteat!(orderedTurns,i)
    #     end
    # end

    # add WPM element for each speaker segment in orderedTurns array
    for i in 1:length(orderedTurns)
        WPM = orderedTurns[i][4]/(orderedTurns[i][3]-orderedTurns[i][2]) * 60
        append!(orderedTurns[i],WPM)
    end

    #  discarded segments due to 0.0 WPM
    # discard = sum([i[7] for i in orderedTurns] .== 0)
    # deleteat!(orderedTurns,[i[7] for i in orderedTurns] .== 0)

    # combine consecutive speakers
    i=0
    while (i <= length(orderedTurns))
        i+=1
        if (i <= length(orderedTurns)-1) && (orderedTurns[i][6] == orderedTurns[i+1][6])
            s = orderedTurns[i][6]
            # combine segments
            orderedTurns[i][3] = orderedTurns[i+1][3]
            orderedTurns[i][4] += orderedTurns[i+1][4]
            append!(orderedTurns[i][5],orderedTurns[i+1][5])
            orderedTurns[i][7] = (orderedTurns[i][7] + orderedTurns[i+1][7])/2
            deleteat!(orderedTurns,i+1)
            i = 1 # go back to begining
        end
    end

    # comparing previous turns - S2 based on S1
    prevS1WPM, prevS2WPM = 0.0, 0.0
    ΔS2 = []; ΔS2S1 = []
    total_turns = 0
    discard = 0
    # assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
    for i in 2:length(orderedTurns)
        try
            if orderedTurns[i][6] == "S1" # if S1 segment
                total_turns += 1
                if ((orderedTurns[i-1][7] != 0.0) & (orderedTurns[i][7] != 0.0) & (orderedTurns[i+1][7] != 0.0))
                    S2Prev = round(orderedTurns[i-1][7],digits=3)
                    S1 = round(orderedTurns[i][7],digits=3)
                    S2Next = round(orderedTurns[i+1][7],digits=3)

                    append!(ΔS2, sign(S2Next - S2Prev))# ΔS2 tells if S2 increased or decresed WPM from last S2 segment
                    append!(ΔS2S1, sign(S1 - S2Prev))# ΔS2S1 tells if S1 increased or decresed from previous S2
                else
                    discard += 1
                end                
            end
        catch
            nothing
        end
    end


    results = ΔS2.*ΔS2S1
    prob = round( digits=2, sum(results[results.>0.0]) / length(results) * 100)

    total_length = length(orderedTurns)

    println(file[findlast("\\",file)[1]+1:end], " S1 entrained to S2 ", prob,"% of the time || skipped turns: $discard\\$total_turns")

    append!(average, prob)
end

println("S2 entraied to S1: ", round(digits= 2,sum(average) / length(average)),"%")
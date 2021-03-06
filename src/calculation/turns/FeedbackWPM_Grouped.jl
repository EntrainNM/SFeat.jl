
# plot WPM for each speaker along with a moving average (averag over 5-segemnt intervals)

using SFeat, TextGrid, Plots
# path to transcribed TextGrid file
cd(raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Children\CNT_NEW_Finished")
folders = readdir(join=true)

# S2toS1 = []
# S1toS2 = []
for folder in folders
    file = folder*folder[findlast("\\",folder)[1] : end]*".TextGrid"

    interval = extract(file)

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
            # println("--------------")
        end
    end



    """
    Looking at speaker 1 (S1) we calculcate ??S2=(S2Next - S2Prev) (does S2 gain or lose WPM
    from the last S2 segments?)

    We also set ??S2S1=(S1 - S2Prev) (does S1 gain or lose WPM from the last S2 segment?)

    ??? if ??S2 & ??S2S1 have the same sign (+ or -) ==> S2's entrainment converging

    ??? if ??S2 & ??S2S1 have the different sign ==> S2's entrainment diverging
    """
    # comparing previous turns - S2 based on S1
    prevS1WPM, prevS2WPM = 0.0, 0.0
    prevS1WPM
    ??S2 = []
    ??S2S1 = []

    # assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
    for i in 2:length(orderedTurns)
        try

            if orderedTurns[i][6] == "S1" # if S1 segment
                S2Prev = round(orderedTurns[i-1][7],digits=3)
                S1 = round(orderedTurns[i][7],digits=3)
                S2Next = round(orderedTurns[i+1][7],digits=3)

                # println("Current ",orderedTurns[i][6]," WPM = ", S1," previous ",orderedTurns[i-1][6]," WPM = ", S2Prev, " Next ", orderedTurns[i+1][6]," WPM = ", S2Next)

                # ??S2 tells if S2 increased or decresed WPM from last S2 segment
                append!(??S2, sign(S2Next - S2Prev))
                # ??S2S1 tells if S1 increased or decresed from previous S2
                append!(??S2S1, sign(S1 - S2Prev))
                end
            catch
                # println("Skip!")
                nothing
            end
    end

    for i in 1:length(??S2)
        # println("??S2 = ", ??S2[i], " ??S2S1 = ", ??S2S1[i], " Results: ", (??S2[i]*??S2S1[i]))
    end

    test = ??S2.*??S2S1
    prob1 = sum(test[test.>0.0]) / length(test)

    print(file[findlast("\\",file)[1]+1:end], " Results: \n")
    println("S2 entrained to S1 ",100.0*prob1,"% of the time")





    # ------------------------------------------------ S1 based on S2
    """
    Smae thing but for S1 based on S2
    """
    # comparing previous turns - S1 based on S2
    prevS1WPM, prevS2WPM = 0.0, 0.0
    prevS1WPM
    ??S1 = []
    ??S1S2 = []

    # assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
    for i in 2:length(orderedTurns)
        try

            if orderedTurns[i][6] == "S2" # if S1 segment
                S1Prev = round(orderedTurns[i-1][7],digits=3)
                S2 = round(orderedTurns[i][7],digits=3)
                S1Next = round(orderedTurns[i+1][7],digits=3)

                # println("Current ",orderedTurns[i][6]," WPM = ", S2," previous ",orderedTurns[i-1][6]," WPM = ", S1Prev, " Next ", orderedTurns[i+1][6]," WPM = ", S1Next)

                # ??S2 tells if S2 increased or decresed WPM from last S2 segment
                append!(??S1, sign(S1Next - S1Prev))
                # ??S2S1 tells if S1 increased or decresed from previous S2
                append!(??S1S2, sign(S2 - S1Prev))
            end
            catch
                # println("Skip!")
                nothing
            end
    end

    for i in 1:length(??S1)
        # println("??S1 = ", ??S1[i], " ??S1S2 = ", ??S1S2[i], " Results: ", (??S1[i]*??S1S2[i]))
    end

    test = ??S1.*??S1S2
    prob2 = sum(test[test.>0.0]) / length(test)

    print("")
    print("S1 entrained to S2 ")

    println(100.0*prob2,"% of the time\n")

    # append!(S2toS1, [100.0*prob1])
    # append!(S1toS2, [100.0*prob2])
end


# sum(S2toS1[15:end]) / length(S2toS1[15:end])
# sum(S1toS2[15:end]) / length(S1toS2[15:end])

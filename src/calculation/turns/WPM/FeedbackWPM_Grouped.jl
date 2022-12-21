
# plot WPM for each speaker along with a moving average (averag over 5-segemnt intervals)

using SFeat, TextGrid, Plots
default(dpi=300)
# path to transcribed TextGrid file
cd(raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Adults\Adults_Finished")
folders = readdir(join=true)

average = []
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

    # comparing previous turns - S2 based on S1
    prevS1WPM, prevS2WPM = 0.0, 0.0
    prevS1WPM
    ΔS2 = []
    ΔS2S1 = []

    # assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
    for i in 2:length(orderedTurns)
        try

            if orderedTurns[i][6] == "S1" # if S1 segment
                S2Prev = round(orderedTurns[i-1][7],digits=3)
                S1 = round(orderedTurns[i][7],digits=3)
                S2Next = round(orderedTurns[i+1][7],digits=3)

                # println("Current ",orderedTurns[i][6]," WPM = ", S1," previous ",orderedTurns[i-1][6]," WPM = ", S2Prev, " Next ", orderedTurns[i+1][6]," WPM = ", S2Next)

                # println(orderedTurns[i][6] , S1, )
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

    # for i in 1:length(ΔS2)
        # println("ΔS2 = ", ΔS2[i], " ΔS2S1 = ", ΔS2S1[i], " Results: ", (ΔS2[i]*ΔS2S1[i]))
    # end

    test = ΔS2.*ΔS2S1
    prob = sum(test[test.>0.0]) / length(test)

    print(file[findlast("\\",file)[1]+1:end], " Results: \n")
    println("S2 entrained to S1 ",100.0*prob,"% of the time")

    append!(average, 100.0*prob)
end

# group = "Adults"
# plot(average,
#     background_color=RGB{Float64}(0.466,0.117,0.560),
#     foreground_color=:white,
#     seriescolor=RGB{Float64}(0.95,0.2,0.1),
#     w=3,
#      xguide="Audio #",
#      label="S2 entrainment to S1",
#      title=group,
#      ylims=[0,100]
#      )
#
# savefig(raw"C:\Users\hemad\Desktop\Master\Experiments\Exp2\Adults.png")

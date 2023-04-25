using SFeat, TextGrid
# path to transcribed TextGrid file
parentFolder = rawparentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CNT"
folders = readdir(parentFolder, join=true)

cn = 0
average = []
discard_all = []
turns_all = []
for folder in folders
    cn+=1
    file = folder*folder[findlast("\\",folder)[1] : end]*".TextGrid"
    interval = extract(file)

    S1Words = wordSegments(interval,1); S2Words = wordSegments(interval,2);

    turns = S1Words
    append!(turns,S2Words)

    p = sortperm([i[2] for i in turns])
    orderedTurns = turns[p] # S1 and S2 combined

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
    ΔS1 = []; ΔS1S2 = []
    total_turns = 0
    discard = 0
    # assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
    for i in 2:length(orderedTurns)
        try
            if orderedTurns[i][6] == "S2" # if S2 segment
                total_turns += 1
                if ((orderedTurns[i-1][7] != 0.0) & (orderedTurns[i][7] != 0.0) & (orderedTurns[i+1][7] != 0.0))
                    S1Prev = round(orderedTurns[i-1][7],digits=3)
                    S2 = round(orderedTurns[i][7],digits=3)
                    S1Next = round(orderedTurns[i+1][7],digits=3)
                    
                    # println("(1) ", orderedTurns[i-1][6]," WPM = ", S1Prev, " (2) ",
                    # orderedTurns[i][6]," WPM = ", S2, " (3) ", orderedTurns[i+1][6],
                    # " WPM = ", S1Next," ==> ", sign(S1Next - S1Prev)*sign(S2 - S1Prev))
                    
                    append!(ΔS1, sign(S1Next - S1Prev))# ΔS1 tells if S1 increased or decresed WPM from last S1 segment
                    append!(ΔS1S2, sign(S2 - S1Prev))# ΔS1S2 tells if S2 increased or decresed from previous S1
                else
                    discard += 1
                end
            end
            catch
                nothing
            end
    end


    results = ΔS1.*ΔS1S2
    prob = round( digits=2, sum(results[results.>0.0]) / length(results) * 100)

    # println(file[findlast("\\",file)[1]+1:end], " S1 entrained to S2 ", prob,"% of the time")
    println("$cn & $prob & $total_turns & $discard \\\\")

    append!(average, prob)
    append!(turns_all,total_turns)
    append!(discard_all,discard)
end

println("S1 entraied to S2: ", sum(average) / length(average),"%")

# group = "CASD"
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

# savefig(raw"C:\Users\hemad\Desktop\Master\Experiments\Exp2\CASD.png")

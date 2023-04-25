using SFeat, TextGrid
parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished"
folders = readdir(parentFolder, join=true)

cn = 0
average = []
discard_all = []
turns_all = []
for parentFolder in folders
    cn+=1
    TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid" # path to TextGrid file
    interval = extract(TextGridFile)
    
    # Extract S1&S2 segments
    S1 = interval[1]; S2 = interval[5];
    S1 = S1[map(x -> x[3] == "S1", interval[1])]; S2 = S2[map(x -> x[3] == "S2", interval[5])];
    
    f0_S1, f0_S2 = f0_read(parentFolder);
    
    S1F0Averaged = [ sum(i)/length(i) for i in f0_S1];
    S2F0Averaged = [ sum(i)/length(i) for i in f0_S2];
    S1timeAveraged = [ i[1] + (i[2] - i[1]) / 2 for i in S1 ]
    S2timeAveraged = [ i[1] + (i[2] - i[1]) / 2 for i in S2 ]
    
    
    S1Time = S1timeAveraged#[S1F0Averaged.!=0]
    S1Data = S1F0Averaged#[S1F0Averaged.!=0]
    S2Time = S2timeAveraged#[S2F0Averaged.!=0]
    S2Data = S2F0Averaged#[S2F0Averaged.!=0]
    
    # combine S1 & S2 segments
    turns = [[ S1Data S1Time fill("S1", (length(S1Time))) ]; [ S2Data S2Time fill("S2", (length(S2Time))) ]]# STORE ARRAY AS [F0 TIME SPEAKER]
    turns  = [turns[i,:] for i in 1:length(turns[:,1])] # convert matrix into array of arrays
    p = sortperm([i[2] for i in turns]) # sort turns according to start time
    combined_F0 = turns[p] # S1 and S2 combined

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
        end
    end

    # comparing previous turns - S2 based on S1
    ΔS1 = []; ΔS1S2 = []
    total_turns = 0
    discard = 0
    # assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
    for i in 2:length(combined_F0)
        try
            if combined_F0[i][3] == "S2" # if S1 segment
                total_turns += 1
                if ((combined_F0[i-1][1] != 0.0) & (combined_F0[i][1] != 0.0) & (combined_F0[i+1][1] != 0.0))
                    S1Prev = round(combined_F0[i-1][1],digits=3)
                    S2 = round(combined_F0[i][1],digits=3)
                    S1Next = round(combined_F0[i+1][1],digits=3)
    
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

    # println(parentFolder[findlast("\\",parentFolder)[1]+1:end], " S1 entrained to S2 ", prob,"% of the time || skipped turns: $discard\\$total_turns")
    # println("$cn & $prob & $total_turns & $discard \\\\")
    println(prob)

    append!(average, prob)
    append!(turns_all,total_turns)
    append!(discard_all,discard)
end

println("S1 entraied to S2: ", round(digits= 2,sum(average) / length(average)),"%")

println(sum(turns_all)," ",sum(discard_all)," ", round(digits=2,100*sum(discard_all)/sum(turns_all)), "%")
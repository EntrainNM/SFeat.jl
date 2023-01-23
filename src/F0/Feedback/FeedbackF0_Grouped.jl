
using SFeat, TextGrid


"""
After extracting featurs using the feature() function, we plot the average F0 for each speaker turn for further analysis.

# first method to extract features
test = readdlm(featureFile, ' ')
t = map(x -> parse(Float64,x[begin:end-1]),test[:,2])
F0 = map(x -> parse(Float64,x[begin:end-1]),test[:,4])

# second method
features = readFeature(featureFile)
"""

parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CASD"
folders = readdir(parentFolder, join=true)

average = []
for parentFolder in folders
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
    ΔS2 = []; ΔS2S1 = []
    total_turns = 0
    discard = 0

    # assuming there is no consecutive speakers (S1 alwasy followed by S2 segment)
    for i in 2:length(combined_F0)
        try
            if combined_F0[i][3] == "S1" # if S1 speaking
                total_turns += 1
                if ((combined_F0[i-1][1] != 0.0) & (combined_F0[i][1] != 0.0) & (combined_F0[i+1][1] != 0.0))
                    S2Prev = round(combined_F0[i-1][1],digits=3)
                    S1 = round(combined_F0[i][1],digits=3)
                    S2Next = round(combined_F0[i+1][1],digits=3)

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
    
    print(parentFolder[findlast("\\",parentFolder)[1]+1:end], " Results: ")


    println("S2 entrained to S1 ",prob,"% of the time || skipped turns: $discard\\$total_turns")

    append!(average, prob)
end


println("S2 entraied to S1: ", round(digits= 2,sum(average) / length(average)),"%")
using SFeat, TextGrid, Plots

original = extract(raw"C:\Users\hemad\Desktop\Master\HandCorrected\CASD019_07182019\CASD019_07182019.TextGrid")
corrected = extract(raw"C:\Users\hemad\Desktop\Master\HandCorrected\CASD019_07182019\CASD019_07182019_Transcribed_Completed.TextGrid")

# extract information
# Original
# S1
WordS1_original = wordSegments(original, 1)
WPM_S1_original = Vector{Float64}(undef,length(WordS1_original)) # initalize 1D array to store averaged WPM for each S1 segment
for i in 1:length(WPM_S1_original) # for each S1 segment
    WPM_S1_original[i] = WordS1_original[i][4] / (WordS1_original[i][3] - WordS1_original[i][2]) * 60.0
end
WPM_S1_original

# S2
WordS2_original = wordSegments(original, 2)
WPM_S2_original = Vector{Float64}(undef,length(WordS2_original)) # initalize 1D array to store averaged WPM for each S2 segment
for i in 1:length(WPM_S2_original) # for each S2 segment
    WPM_S2_original[i] = WordS2_original[i][4] / (WordS2_original[i][3] - WordS2_original[i][2]) * 60.0
end
WPM_S2_original


# Corrected
# S1
WordS1_corrected = wordSegments(corrected, 1)
WPM_S1_corrected = Vector{Float64}(undef,length(WordS1_corrected)) # initalize 1D array to store averaged WPM for each S1 segment
for i in 1:length(WPM_S1_corrected) # for each S1 segment
    WPM_S1_corrected[i] = WordS1_corrected[i][4] / (WordS1_corrected[i][3] - WordS1_corrected[i][2]) * 60.0
end
WPM_S1_corrected

# S2
WordS2_corrected = wordSegments(corrected, 2)
WPM_S2_corrected = Vector{Float64}(undef,length(WordS2_corrected)) # initalize 1D array to store averaged WPM for each S2 segment
for i in 1:length(WPM_S2_corrected) # for each S2 segment
    WPM_S2_corrected[i] = WordS2_corrected[i][4] / (WordS2_corrected[i][3] - WordS2_corrected[i][2]) * 60.0
end
WPM_S2_corrected


if 1==0
    plot(Time1, WPM1,
        background_color=RGB{Float64}(0.466,0.117,0.560),
        foreground_color=:white,
        seriescolor=RGB{Float64}(0.95,0.2,0.1),
        xguide="Seconds",
        yguide="WPM",
        label="Original Turns WPM"
        )

    scatter!(Time1, WPM1,
            background_color=RGB{Float64}(0.466,0.117,0.560),
            foreground_color=:white, label=false,
            seriescolor=RGB{Float64}(0.95,0.2,0.1)
            )
    plot!(Time2, WPM2,
            seriescolor=RGB{Float64}(0.1,0.6,0.9),
            xguide="Seconds",
            yguide="WPM",
            label="Corrected Turns WPM"
            )

    scatter!(Time2, WPM2,
            seriescolor=RGB{Float64}(0.1,0.6,0.9),
            label=false
            )
end



# 1) number of words:
# how many word segments contain text for each speaker in the original and corrected textGrid
# original
sum([i[3] != "" for i in original[10]]) # S1
sum([i[3] != "" for i in original[11]]) # S2
# corrected
sum([i[3] != "" for i in corrected[10]]) # S1
sum([i[3] != "" for i in corrected[11]]) # S2


# 2) how many speaker segments needed to be edited
# sum(WPM_S1 .== S1WPM2[1:end-1])
# [ (i,n) for (i, n) in zip(WPM_S1, S1WPM2[1:end-1])]
# S1
count = 0
for i in WPM_S1_original
    if (i in WPM_S1_corrected) & (i != 0.0)
        count+=1
        # println(i)
    end
end
count
length(WPM_S1_original)
# percentage of segments didn't change
(count)*100/length(WPM_S1_original)

# S2
count = 0
for i in WPM_S2_original
    if (i in WPM_S2_corrected) & (i != 0.0)
        count+=1
        println(i)
    end
end
count
length(WPM_S2_original)
# percentage of segments didn't change
(count)*100/length(WPM_S2_original)

# 3) average WPM
# original
sum(WPM_S1_original)/length(WPM_S1_original) # S1
sum(WPM_S2_original)/length(WPM_S2_original) # S2

# corrected
sum(WPM_S1_corrected)/length(WPM_S1_corrected) # S1
sum(WPM_S2_corrected)/length(WPM_S2_corrected) # S2



plot(WPM_S1_original)
plot!(WPM_S1_corrected)

plot(WPM_S2_original)
plot!(WPM_S2_corrected)


for i in 1:length(WPM_S2_original)
    if WPM_S2_original[i] == 0
        println(i)
    end
end

for i in 1:length(WPM_S2_corrected)
    if WPM_S2_corrected[i] == 0
        println(i)
    end
end

# why many S2 WPM becaume 0
# solution: take the average time of each word when determining if the word is within a segment






# 4) percent of change for edited sigmants
# S1
temp = [] # store identical WPM
for i in WPM_S1_original
    ( (i in WPM_S1_corrected) & (i != 0.0) ) ? append!(temp, i) : nothing
end
WPM_S1_original_diff = copy(WPM_S1_original); WPM_S1_corrected_diff = copy(WPM_S1_corrected)

#---- remove unchanged WPM values
# ORIGINAL
for i in 1:length(WPM_S1_original)
    val = WPM_S1_original[i]
    (val in temp) ? deleteat!(WPM_S1_original_diff, WPM_S1_original_diff .== val) : nothing
end
# EDITED
for i in 1:length(WPM_S1_corrected)
    val = WPM_S1_corrected[i]
    (val in temp) ? deleteat!(WPM_S1_corrected_diff, WPM_S1_corrected_diff .== val) : nothing
end
# remove 0.0 WPM values
deleteat!(WPM_S1_original_diff, WPM_S1_original_diff .== 0.0); deleteat!(WPM_S1_corrected_diff, WPM_S1_corrected_diff .== 0.0)
change = []
for i in 1:min(length(WPM_S1_corrected_diff), length(WPM_S1_original_diff))
    val = (WPM_S1_corrected_diff[i] > WPM_S1_original_diff[i]) ? (WPM_S1_original_diff[i]/WPM_S1_corrected_diff[i]) : (WPM_S1_corrected_diff[i]/WPM_S1_original_diff[i])
    append!(change, val)
end
S1_Difference = 1 - sum(change)/length(change)

# S2
temp = [] # store identical WPM
for i in WPM_S2_original
    ( (i in WPM_S2_corrected) & (i != 0.0) ) ? append!(temp, i) : nothing
end
WPM_S2_original_diff = copy(WPM_S2_original); WPM_S2_corrected_diff = copy(WPM_S2_corrected)

#---- remove unchanged WPM values
# ORIGINALF
for i in 1:length(WPM_S2_original)
    val = WPM_S2_original[i]
    (val in temp) ? deleteat!(WPM_S2_original_diff, WPM_S2_original_diff .== val) : nothing
end
# EDITED
for i in 1:length(WPM_S2_corrected)
    val = WPM_S2_corrected[i]
    (val in temp) ? deleteat!(WPM_S2_corrected_diff, WPM_S2_corrected_diff .== val) : nothing
end
# remove 0.0 WPM values
deleteat!(WPM_S2_original_diff, WPM_S2_original_diff .== 0.0); deleteat!(WPM_S2_corrected_diff, WPM_S2_corrected_diff .== 0.0)
change = []
for i in 1:min(length(WPM_S2_corrected_diff), length(WPM_S2_original_diff))
    val = (WPM_S2_corrected_diff[i] > WPM_S2_original_diff[i]) ? (WPM_S2_original_diff[i]/WPM_S2_corrected_diff[i]) : (WPM_S2_corrected_diff[i]/WPM_S2_original_diff[i])
    append!(change, val)
end
S2_Difference = 1 - sum(change)/length(change)

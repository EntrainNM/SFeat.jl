using SFeat, TextGrid, Plots


parentFolder = raw"C:\Users\hemad\Desktop\Master\Experiments\Exp1\data\CASD\CASD009_061919"

folders = readdir(parentFolder, join=true)
original = extract(folders[occursin.(raw"Transcribed", folders)][1]);
corrected = extract(folders[occursin.(raw"Corrected", folders)][1]);
name = parentFolder[findlast("\\",parentFolder)[1]+1:findall("_",parentFolder)[1][1]-1]

# extract information
Random_speaker = 2
# Original
WordS1_original = wordSegments(original, Random_speaker);
WPM_S1_original = Vector{Float64}(undef,length(WordS1_original)); # initalize 1D array to store averaged WPM for each S1 segment
time_S1_original = Vector{Float64}(undef,length(WordS1_original));
for i in 1:length(WPM_S1_original) # for each S1 segment
    WPM_S1_original[i] = WordS1_original[i][4] / (WordS1_original[i][3] - WordS1_original[i][2]) * 60.0
    time_S1_original[i] = WordS1_original[i][2] + (WordS1_original[i][3] - WordS1_original[i][2]) / 2.0
end
# Corrected
WordS1_corrected = wordSegments(corrected, Random_speaker);
# replace!.(WordS1_corrected[ [i[4] == 0.0 for i in WordS1_corrected] ], 0 => 1);
WPM_S1_corrected = Vector{Float64}(undef,length(WordS1_corrected)); # initalize 1D array to store averaged WPM for each S1 segment
time_S1_corrected = Vector{Float64}(undef,length(WordS1_corrected));
for i in 1:length(WPM_S1_corrected) # for each S1 segment
    WPM_S1_corrected[i] = WordS1_corrected[i][4] / (WordS1_corrected[i][3] - WordS1_corrected[i][2]) * 60.0
    time_S1_corrected[i] = WordS1_corrected[i][2] + (WordS1_corrected[i][3] - WordS1_corrected[i][2]) / 2.0
end


# 1) number of words:
# how many word segments contain text for each speaker in the original and corrected textGrid
original_words = sum([i[3] != "" for i in original[10]]) # words in original
corrected_words = sum([i[3] != "" for i in corrected[10]]) # words in corrected


# 2) mean WPM
original_mean = round(digits = 2, sum(WPM_S1_original) / length(WPM_S1_original))
corrected_mean = round(digits=2,sum(WPM_S1_corrected) / length(WPM_S1_corrected))


println("$original_words,$corrected_words,$original_mean,$corrected_mean")
# 3) Visualization
default(dpi=500, w=2, markersize=4, legend=:outertop, size=(1300,600),
        framestyle = :box
)
plot(time_S1_original, WPM_S1_original, seriescolor=RGB{Float64}(0.95,0.2,0.1),
        xguide="Turn's Time", yguide="Average WPM", label="Autormitc WPM turns",
        shape = :circle, thickness_scaling = 1.4
)
plot!(time_S1_corrected, WPM_S1_corrected, seriescolor=RGB{Float64}(0.1,0.6,0.9),
        label="corrected WPM turns", shape=:star4
)

# savefig(raw"C:\Users\hemad\Desktop\Master\Experiments\Exp1\\"*name*raw"_WPM.png")
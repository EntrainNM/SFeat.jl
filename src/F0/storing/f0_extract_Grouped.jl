using SFeat
using DelimitedFiles
using TextGrid
using WAV

Folder = readdir(raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished", join=true)

for parentFolder in Folder
    TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid"; # path to TextGrid file
    interval = extract(TextGridFile);

    # Extract S1&S2 segments
    S1 = interval[1]; S2 = interval[5];
    S1 = S1[map(x -> x[3] == "S1", interval[1])]; S2 = S2[map(x -> x[3] == "S2", interval[5])];

    # Extract speakers genders from gender.txt
    gender = parentFolder*"\\gender"*".txt"; f = open(gender, "r");
    gender = lowercase(read(f, String)); close(f);

    # use the correct praat script based on gender (male, female, child)
    S1_gender = gender[1]; S2_gender = gender[2];

    # return f0
    f0_S1 = f0(parentFolder, S1, S1_gender)
    f0_S2 = f0(parentFolder, S2, S2_gender)


    #-------------- Store f0 values as .txt
    # store f0 values using DelimitedFiles
    if !("f0" in readdir(parentFolder))
        mkdir(parentFolder*raw"\f0")
    end

    open(parentFolder*raw"\f0"*raw"\S1.txt", "w") do io
        writedlm(io, f0_S1, " ")
    end

    open(parentFolder*raw"\f0"*raw"\S2.txt", "w") do io
        writedlm(io, f0_S2, " ")
    end

end
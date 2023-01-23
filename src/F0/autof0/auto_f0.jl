
using SFeat, DelimitedFiles#, TextGrid

# parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CNT\CNT009_06252018" # boy ==> child
# parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CNT\CNT017_07032019" # teenage ==> adult
# parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished\A031_Sarah" # adult

function gender(parentFolder)
    f = open(parentFolder*"\\gender"*".txt", "r");
    gender = lowercase(read(f, String)); close(f);
    gender
end


folders = readdir(raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished", join=true)

results = Array{Any}(undef, length(folders),5)

for (index, parentFolder) in enumerate(folders)
    S1_f0 = autof0(parentFolder, 1);
    S2_f0 = autof0(parentFolder, 2);
    name = parentFolder[findlast("\\",parentFolder)[1]+1:end]

y
    g = gender(parentFolder)
    results[index,:] = [name g[1] S1_f0 g[2] S2_f0]

    # println("average f0 of $name = $S_f0 Hz")
end
results

open(raw"C:\Users\hemad\Desktop\Master\Experiments\Exp3\Adult_autof0.txt", "w") do io
    writedlm(io, results, " ")
end



for (index, parentFolder) in enumerate(folders)
    name = parentFolder[findlast("\\",parentFolder)[1]+1:end]
    g = gender(parentFolder)
    println("$name gender = $g")
end
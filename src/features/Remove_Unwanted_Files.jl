using SFeat

# file = raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Children\CNT_NEW_Finished\CNT"
#
# cd(file)
# folders = readdir(join=true)

# REMOVE .features FILES

for folder in folders
    all = readdir(folder, join=true)

    for file in all[endswith.(all, "features")]
        rm(file, force=true)
    end

end

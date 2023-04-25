using SFeat

# file = raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Children\CNT_NEW_Finished\CNT"
#
# cd(file)
# folders = readdir(join=true)

# REMOVE .features FILES

# for folder in folders
#     all = readdir(folder, join=true)

#     for file in all[endswith.(all, "features")]
#         rm(file, force=true)
#     end

# end


#------------------------- 1 - REMOVE THE "_Corrected" from file name
# cd(raw"Z:\Downloads\CASD")
# folders = readdir(join=true)

# for file in folders
#     name = file[findlast("\\",file)[1]+1 : end]
#     name = "_Corrected"

#     result = replace(file,name => "" )
#     println(result)

#     try
#         mv(file, result)
#     catch
#         nothing
#     end
# end


#------------------------- 2 - REMOVE ALL .TEXTGRID FILES FROM PARENT FOLDER

# parentFolder = readdir(raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CNT",join=true)

# for folder in parentFolder
#     try
#         rm(folder*folder[findlast("\\",folder)[1] : end]*".TextGrid")
#     catch
#         nothing
#     end
# end


#------------------------- 3 - COPY CORRECTED .TEXTGRID FILES TO PARENT FOLDER

# parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CASD"
# corrected = readdir(raw"C:\Users\hemad\Desktop\Master\HandCorrected\CASD",join=true)

# for file in corrected
#     name = file[findlast("\\",file)[1] : findlast(".",file)[1]-1]
#     dest = parentFolder*name*name*".TextGrid"
#     try
#         cp(file, dest, force = true)
#     catch
#         nothing
#     end
# end


# file = corrected[1]

# file[findlast("\\",file)[1]+1 : findlast(".",file)[1]-1]

# parentFolder*file[findlast("\\",file)[1] : findlast(".",file)[1]-1]*file[findlast("\\",file)[1] : findlast(".",file)[1]-1]*".TextGrid"


#-------------- DELETE "WPM" FOLDERS IN EACH FOLDER

# parentFolder = readdir(raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished", join=true)

# for folder in parentFolder
#     if isdir(folder*raw"\WPM")
#         rm(folder*raw"\WPM", force = true, recursive=true)
#     end
# end

# # #----------- REMOVE .FEATURES FILES
# parentFolder = readdir(raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished", join=true)

# for folder in parentFolder
#     for i in readdir(folder, join=true)
#         if contains(i, "features")
#             rm(i, force = true, recursive=true)
#         end
#     end
# end


# # #----------- REMOVE .gender FILES
# parentFolder = readdir(raw"C:\Users\hemad\Desktop\Master\Data\Children\CNT_NEW_Finished\CNT", join=true)

# for folder in parentFolder
#     for i in readdir(folder, join=true)
#         if contains(i, "gender.txt")
#             rm(i, force = true, recursive=true)
#         end
#     end
# end



# # # #-----------
# parentFolder = raw"C:\Users\hemad\Desktop\Master\Experiments\Exp1\data\Adults"
# All = readdir(parentFolder, join=true)

# for file in All
#     name = file[findlast("\\",file)[1] : findlast(".",file)[1]-1]
#     mkpath(parentFolder*name)
#     mv(file, parentFolder*name*name*".TextGrid")
# end

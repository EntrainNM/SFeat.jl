using SFeat, TextGrid

# path to wav files location
cd(raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Children\CNT_NEW_Finished")
folder = readdir(join=true)

for file in folder
    # println("Working on", file)
    # if length(readdir(file,join=true)) == 2
    #     wavFile = file*file[findlast("\\", file)[1] : end ]*".wav"
    #     feature(wavFile, savecopy = true)
    # end
    println(length(readdir(file,join=true)))
end

feature("")

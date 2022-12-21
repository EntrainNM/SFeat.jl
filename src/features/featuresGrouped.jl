using SFeat

file = raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Children\CNT_NEW_Finished\CASD"

cd(file)
folders = readdir(join=true)

for folder in folders
    # get gender
    gender = folder*"\\gender"*".txt"
    f = open(gender, "r")
    gender = read(f, String)
    close(f)


    wavFile = folder*folder[findlast("\\",folder)[1] : end]*".wav"

    if gender[1] == gender[2] # if both speakers are the same gender
        feature(wavFile, gender[1]; savecopy=true);
    else
        feature(wavFile, gender[1]; savecopy=true);
        feature(wavFile, gender[2]; savecopy=true);
    end

    println("\nFinished ", folder)
end

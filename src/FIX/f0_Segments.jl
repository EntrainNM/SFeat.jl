using DelimitedFiles, WAV
using SFeat

file = raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Extra_Data\fix_f0\CASD015_07022019"

cd(file)


x,fs = WAV.wavread(raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Extra_Data\fix_f0\CASD015_07022019\CASD015_07022019.wav")
x = x / maximum(abs.(x))

FS = trunc(Int, fs)
WAV.wavplay(x[trunc(Int,439.23*FS) : trunc(Int,439.67*FS),:], fs)




# save wav file with WAVE_FORMAT_PCM/16bits
WAV.wavwrite(x[trunc(Int,439.23*FS) : trunc(Int,439.67*FS),:], raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Extra_Data\fix_f0\CASD015_07022019\segment\Temp.wav",
             Fs=fs,
             compression=WAVE_FORMAT_PCM,
             nbits = 16) # this doesn't work with other files than test.wav in WavFiles)








using SFeat

file = raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Extra_Data\fix_f0\CASD015_07022019"

cd(file)


gender = file*"\\gender"*".txt"
f = open(gender, "r")
gender = read(f, String)
close(f)


wavFile = file*file[findlast("\\",file)[1] : end]*".wav"

println("\nWorking on ",wavFile)
if gender[1] == gender[2] # if both speakers are the same gender
    feature(wavFile, gender[1]; savecopy=true);
else
    feature(wavFile, gender[1]; savecopy=true);
    feature(wavFile, gender[2]; savecopy=true);
end

println("\nFinished ", wavFile)

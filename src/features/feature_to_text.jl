using DelimitedFiles, WAV
using SFeat, TextGrid

parentFolder = raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Extra_Data\fix_f0\CASD015_07022019"

TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid" # path to TextGrid file
interval = extract(TextGridFile);

# Extract S1 segments only
S1 = interval[1]
S1 = S1[map(x -> x[3] == "S1", interval[1])] 

# Extract S1 segments only
S1 = interval[1]
S1 = S1[map(x -> x[3] == "S1", interval[1])] 


x,fs = WAV.wavread(raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Extra_Data\fix_f0\CASD015_07022019\CASD015_07022019.wav")
x = x / maximum(abs.(x))

FS = trunc(Int, fs)
WAV.wavplay(x[trunc(Int,439.23*FS) : trunc(Int,439.67*FS),:], fs)

# save wav file with WAVE_FORMAT_PCM/16bits
WAV.wavwrite(x[trunc(Int,439.23*FS) : trunc(Int,439.67*FS),:], raw"C:\Users\hemad\Desktop\Master\Original_Data_Finished\Extra_Data\fix_f0\CASD015_07022019\segment\Temp.wav",
Fs=fs,compression=WAVE_FORMAT_PCM,nbits = 16)
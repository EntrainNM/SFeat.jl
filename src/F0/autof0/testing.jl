

using SFeat, DelimitedFiles, TextGrid, WAV, Plots

parentFolder = raw"C:\Users\hemad\Desktop\Master\Data\Adults\Adults_Finished\A034_A035"
TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid"; # path to TextGrid file
interval = extract(TextGridFile);

# default settings f0
MN = 75; MX = 500;

S = 1

if S==1
    S1 = interval[1];
    speaker = S1[map(x -> x[3] == "S1", interval[1])]
elseif S==2
    S2 = interval[5]
    speaker = S2[map(x -> x[3] == "S2", interval[5])]
end

wavefile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".wav";
x,fs = WAV.wavread(wavefile);
x = x / maximum(abs.(x));
fs = trunc(Int, fs);

praat_exe = raw"C:\Users\hemad\.julia\dev\SFeat\src\praatScript\Praat.exe";
praatScript = raw"C:\Users\hemad\.julia\dev\SFeat\src\praatScript\f0.praat";
features_path = raw"C:\Users\hemad\.julia\dev\SFeat\src\praatScript\temp.features";
temp_wav = raw"C:\Users\hemad\.julia\dev\SFeat\src\praatScript\temp.wav";
TIME_STEP = 0.01;


p = sortperm([ (i[2]-i[1]) for i in speaker])
average_five = []

for i in 10:-1:0
    order = speaker[p][end-i]
    WAV.wavwrite(x[trunc(Int,order[1]*fs) : trunc(Int,order[2]*fs),:], temp_wav,Fs=fs,
                compression=WAVE_FORMAT_PCM, nbits = 16
    )

    cmd = praat_exe * " --run " * praatScript * raw" temp.wav "  * raw"temp.features " * raw".\ " * string(TIME_STEP) * " $MN $MX";
    run(`cmd /k $cmd "&" exit`);

    S_f0 = [readdlm(features_path, ',')[:,2]]
    temp = round(digits=3, sum(S_f0[1]) / length(S_f0[1]))

    append!(average_five, temp)

end

sum(average_five) / length(average_five)

# plot(S_f0[1], title=length(S_f0[1]))


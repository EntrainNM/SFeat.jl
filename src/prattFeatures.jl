using DelimitedFiles, WAV, TextGrid

# Run the CMD from the command function which will create Temp.wav file and extract the raw string information as a Tuple of vectors.

# ffmpeg -y -i A005_A006.WAV -acodec pcm_s16le -f s16le -ac 1 -ar 16000 output.wav

# this should work:
# src\extraFiles\praatcon.exe src\extraFiles\AutoRhythmPitch.praat test.wav Temp.features .\ 0.01


"""
# f0 - given path to .textgrid file, speaker segment, and gender (f,c, or ,).
Return 
inputs:

\t- file: full path to .WAV filemode
\t- savecopy: when true, save a text file containing F0 and formants to the given .WAV file location
\t- TIME_STEP: default 0.01, the interval (resolution) to read date

"""
function f0(parentFolder, speaker, gender)
    # select f0 range based on gender
    if gender == 'f'
        min = 150; max = 350;
    elseif gender == 'c'
        min = 170; max = 450;
    elseif gender == 'm'
        min = 70; max = 250;
    elseif gender == "default"
        min = 70; max = 500;
    else
        error("gender must be specified (male=>m, female=>f, child=>c)");
    end

    # PATH to TextGrid file
    wavefile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".wav";
    x,fs = WAV.wavread(wavefile);
    x = x / maximum(abs.(x));
    fs = trunc(Int, fs);

    # PATH of Praat script
    praat_exe = raw"C:\Users\hemad\.julia\dev\SFeat\src\praatScript\Praat.exe";
    praatScript = raw"C:\Users\hemad\.julia\dev\SFeat\src\praatScript\f0.praat";
    features_path = raw"C:\Users\hemad\.julia\dev\SFeat\src\praatScript\temp.features";
    temp_wav = raw"C:\Users\hemad\.julia\dev\SFeat\src\praatScript\temp.wav";
    TIME_STEP = 0.01;
    
    f0 = [];
    for i in speaker
        WAV.wavwrite(x[trunc(Int,i[1]*fs) : trunc(Int,i[2]*fs),:], temp_wav,
             Fs=fs, compression=WAVE_FORMAT_PCM, nbits = 16);

        cmd = praat_exe * " --run " * praatScript * raw" temp.wav "  * raw"temp.features " * raw".\ " * string(TIME_STEP) * " $min $max";
        run(`cmd /k $cmd "&" exit`);
        features = []
        try
            features = [readdlm(features_path, ',')[:,2]]
        catch
            features = [0]
        end
        append!(f0, features);
    end
    return f0
end


"""
# f0_read - given path to .textgrid file.
Return the stored f0 list for S1 and S2 as tuble
"""
function f0_read(parentFolder)
    temp = readdlm(parentFolder*raw"\f0"*raw"\S1.txt", ' ', skipblanks=true)
    f0_S1 = [ temp[i,:][ temp[i,:] .!= ""] for i in 1:length(temp[:,1]) ]

    temp = readdlm(parentFolder*raw"\f0"*raw"\S2.txt", ' ', skipblanks=true)
    f0_S2 = [ temp[i,:][ temp[i,:] .!= ""] for i in 1:length(temp[:,1]) ]

    return (f0_S1, f0_S2)
end



"""
Given a .features file, convert string lines to readable data of Float type
"""
function readFeature(file)
    temp = DelimitedFiles.readdlm(file) # this contains strings, commas, and numbers
    for i in eachindex(temp)
           if(typeof(temp[i]) == SubString{String})
               temp[i] = parse(Float64,replace(temp[i], ","=>""))
           end
    end
    return temp
end



function autof0(parentFolder, S)
    name = parentFolder[findlast("\\",parentFolder)[1]+1:end]

    TextGridFile = parentFolder*parentFolder[findlast('\\', parentFolder):end]*".TextGrid"; # path to TextGrid file
    interval = extract(TextGridFile);
    # find longest segment for a certain speaker S
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

    i = speaker[findmax([ (i[2]-i[1]) for i in speaker])[2]]
    WAV.wavwrite(x[trunc(Int,i[1]*fs) : trunc(Int,i[2]*fs),:], temp_wav,Fs=fs,
                compression=WAVE_FORMAT_PCM, nbits = 16
    )

    # female settings
    MN = 75; MX = 500;
    cmd = praat_exe * " --run " * praatScript * raw" temp.wav "  * raw"temp.features " * raw".\ " * string(TIME_STEP) * " $MN $MX";
    run(`cmd /k $cmd "&" exit`);

    S_f0 = [readdlm(features_path, ',')[:,2]]

    round(digits=3, sum(S_f0[1]) / length(S_f0[1]))

end
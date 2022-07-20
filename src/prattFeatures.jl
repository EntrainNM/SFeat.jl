using DelimitedFiles, WAV

# Run the CMD from the command function which will create Temp.wav file and extract the raw string information as a Tuple of vectors.

# ffmpeg -y -i A005_A006.WAV -acodec pcm_s16le -f s16le -ac 1 -ar 16000 output.wav

# this should work:
# src\extraFiles\praatcon.exe src\extraFiles\AutoRhythmPitch.praat test.wav Temp.features .\ 0.01


"""
# feature - given wav file path, return Tuple containing F0 and formants

inputs:

\t- file: full path to .WAV filemode
\t- savecopy: when true, save a text file containing F0 and formants to the given .WAV file location
\t- TIME_STEP: default 0.01, the interval (resolution) to read date

"""
function feature(file; savecopy=false, TIME_STEP = 0.01)

    # read wav file
    x,fs = WAV.wavread(file)
    x = x / maximum(abs.(x))

    # save wav file with WAVE_FORMAT_PCM/16bits
    WAV.wavwrite(x, raw"C:\Users\hemad\.julia\dev\SFeat\src\extraFiles\Temp.wav",
                 Fs=fs,
                 compression=WAVE_FORMAT_PCM,
                 nbits = 16 # this doesn't work with other files than test.wav in WavFiles
                 )

    path_PraatExecutable = raw"C:\Users\hemad\.julia\dev\SFeat\src\extraFiles\praatcon.exe" # Path to .exe praat file
    path_PraatScript = raw"C:\Users\hemad\.julia\dev\SFeat\src\extraFiles\AutoRhythmPitch.praat" # praat script filemyF Path

    temp = raw" Temp.wav "
    features = raw"Temp.features "

    cmd = path_PraatExecutable * " " * path_PraatScript * temp  * features * raw".\ " * string(TIME_STEP)

    print("""Starting CMD "$cmd"\n""")
    # run command on CMD
    run(`cmd /k $cmd "&" exit`)

    # remove Temp.wav file
    # rm(raw"src\extraFiles\Temp.wav", force=true)

    # temporarily solution: use readdlm, remove commas, convert the strings to floats
    temp = readFeature(raw"C:\Users\hemad\.julia\dev\SFeat\src\extraFiles\Temp.features") # this contains strings, commas, and numbers

    if savecopy
        cp(raw"C:\Users\hemad\.julia\dev\SFeat\src\extraFiles\Temp.features",file[begin:findlast('.', file)]*"features")
    end

    # return audio file features (Pitch and Formants) tracks in as a Tuple of vectors
    track = (t=temp[:,1],voicing=temp[:,2],f0=temp[:,3],f1=temp[:,4],f2=temp[:,5],f3=temp[:,6],f4=temp[:,7],f5=temp[:,8],f6=temp[:,9],f7=temp[:,10],f8=temp[:,11],f9=temp[:,12],f10=temp[:,13],f11=temp[:,14],f12=temp[:,15],f13=temp[:,16],f14=temp[:,17],f15=temp[:,18],Formants=temp[:,4:end])
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

#
# # create a CMD command that twill extract information from a WAV file given as a full path string.
# function command(file; TIME_STEP = 0.01)
#     # read wav file
#     x,fs = WAV.wavread(file)
#     x = x / maximum(abs.(x))
#
#     # save wav file with WAVE_FORMAT_PCM/16bits
#     WAV.wavwrite(x, raw"C:\Users\hemad\.julia\dev\SFeat\src\extraFiles\Temp.wav",
#                  Fs=fs,
#                  compression=WAVE_FORMAT_PCM,
#                  nbits = 16 # this doesn't work with other files than test.wav in WavFiles
#                  )
#
#     path_PraatExecutable = raw"C:\Users\hemad\.julia\dev\SFeat\src\extraFiles\praatcon.exe" # Path to .exe praat file
#     path_PraatScript = raw"C:\Users\hemad\.julia\dev\SFeat\src\extraFiles\AutoRhythmPitch.praat" # praat script filemyF Path
#
#     temp = raw" Temp.wav "
#     features = raw"Temp.features "
#
#     cmd = path_PraatExecutable * " " * path_PraatScript * temp  * features * raw".\ " * string(TIME_STEP)
#
#     return cmd
# end

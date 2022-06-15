using DelimitedFiles, WAV

# Run the CMD from the command function which will create Temp.wav file and extract the raw string information as a Tuple of vectors.

function feature(command)

    print("""Starting CMD "$command"\n""")
    # run command on CMD
    run(`cmd /k $command "&" exit`)

    # remove Temp.wav file
    rm(raw"src\extraFiles\Temp.wav", force=true)

    # temporarily solution: use readdlm, remove commas, convert the strings to floats

    temp = DelimitedFiles.readdlm(raw"src\extraFiles\Temp.features") # this contains strings, commas, and numbers

    for i in eachindex(temp)
           if(typeof(temp[i]) == SubString{String})
               temp[i] = parse(Float64,replace(temp[i], ","=>""))
           end
    end

    track = (t=temp[:,1],voicing=temp[:,2],f0=temp[:,3],f1=temp[:,4],f2=temp[:,5],f3=temp[:,6],f4=temp[:,7],f5=temp[:,8],f6=temp[:,9],f7=temp[:,10],f8=temp[:,11],f9=temp[:,12],f10=temp[:,13],f11=temp[:,14],f12=temp[:,15],f13=temp[:,16],f14=temp[:,17],f15=temp[:,18],Formants=temp[:,4:end])

end

# create a CMD command that twill extract information from a WAV file given as a full path string.
function command(file; TIME_STEP = 0.01)
    # read wav file
    x,fs = WAV.wavread(file)
    x = x / maximum(x)

    # save wav file with WAVE_FORMAT_PCM/16bits
    WAV.wavwrite(x, raw"src\extraFiles\Temp.wav",
                 Fs=fs,
                 compression=WAVE_FORMAT_PCM,
                 nbits = 16 # this doesn't work with other files than test.wav in WavFiles
                 )

    # .exe praat file
    path_PraatExecutable = raw"src\extraFiles\praatcon.exe"
    # praat script filemyF
    path_PraatScript = raw"src\extraFiles\AutoRhythmPitch.praat"

    temp = raw" Temp.wav "
    features = raw"Temp.features "

    cmd = path_PraatExecutable * " " * path_PraatScript * temp  * features * raw".\ " * string(TIME_STEP)

    return cmd
end

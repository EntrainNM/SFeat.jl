using SFeat, WAV

# # ffmpeg -y -i test1.WAV -acodec pcm_s16le -f s16le -ac 1 -ar 16000 output.wav
# # ffmpeg -i test.WAV -c:a pcm_s16le -ar 16000 -ac 1 output.wav
# TIME_STEP = 0.01
# file = raw"C:\Users\hemad\.julia\dev\SFeat\src\wav\output.wav"
# x,fs = WAV.wavread(file)
# x = x / maximum(x)
#
# # save wav file with WAVE_FORMAT_PCM/16bits
# WAV.wavwrite(x, raw"src\extraFiles\Temp.wav",
#              Fs=fs,
#              compression=WAVE_FORMAT_PCM,
#              nbits = 16 # this doesn't work with other files than test.wav in WavFiles
#              )
#
#
# path_PraatExecutable = raw"src\extraFiles\praatcon.exe" # Path to .exe praat file
# path_PraatScript = raw"src\extraFiles\AutoRhythmPitch.praat" # praat script filemyF Path
# temp = raw" Temp.wav "
# features = raw"Temp.features "
# cmd = path_PraatExecutable * " " * path_PraatScript * temp  * features
#
# run(`cmd /k $cmd "&" exit`)
#
# using TextGrid
# rm(raw"src\extraFiles\Temp.wav", force=true)

# testing
using TextGrid
# file = raw"C:\Users\hemad\.julia\dev\SFeat\src\wav\output.wav"
cmd = command(file; TIME_STEP = 0.01)
features = feature(cmd)



# plot features
using Plots
int = 230:350
plot(features.t[int], features.f0[int],
    xlabel="time",ylabel="f0")

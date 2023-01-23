using SFeat, WAV

# # ffmpeg -y -i test1.WAV -acodec pcm_s16le -f s16le -ac 1 -ar 16000 output.wav
# # ffmpeg -i test.WAV -c:a pcm_s16le -ar 16000 -ac 1 output.wav
# file = raw"C:\Users\hemad\Desktop\Master\ExtractFeatures\testing\CASD001_MAW_thesis_session_1\CASD001_MAW_thesis_session_1.wav"
# TIME_STEP = 0.01
# features = feature(file)#,savecopy=true)


using Plots


default(dpi=300, w=0, markersize=1, legend=:outertop)
Data = [55.61, 60.33, 61.34]
Target = "f0"

bar(Data, xticks = ([1,2,3], ["Adults","CASD","CNT"])
    ,label=false, ylabel=Target,title=Target,
    xlabel="Control Group",
    background_color=RGB{Float64}(0.466,0.117,0.560),
    seriescolor=RGB{Float64}(0.1, .7, .9),
    guidefontsize=11,tickfontsize=11, bar_width=0.5,
    text=[("$i", :bottom, RGB{Float64}(0.1, .7, .9), 11) for i in Data]
)

# savefig(raw"C:\Users\hemad\Desktop\Master\Experiments\Exp3\Groups.png")
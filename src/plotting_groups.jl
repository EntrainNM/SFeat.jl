using SFeat, WAV

# # ffmpeg -y -i test1.WAV -acodec pcm_s16le -f s16le -ac 1 -ar 16000 output.wav
# # ffmpeg -i test.WAV -c:a pcm_s16le -ar 16000 -ac 1 output.wav
# file = raw"C:\Users\hemad\Desktop\Master\ExtractFeatures\testing\CASD001_MAW_thesis_session_1\CASD001_MAW_thesis_session_1.wav"
# TIME_STEP = 0.01
# features = feature(file)#,savecopy=true)


using Plots

# default(dpi=500, w=2, markersize=4, legend=:outertop, size=(1300,600))
default(dpi=500, w=0, markersize=1, legend=:outertop, framestyle = :box, grid=false)
Data = [55.59, 55.81, 58.86]
Target = ""

bar(Data, xticks = ([1,2,3], ["Adults","CNT","CASD"]),
    yticks=0:10:70,label=false, ylabel="f0",ylims=(0,65),
    title=Target,xlabel="Groups",
    seriescolor=RGB{Float64}(0.1, .2, .6),
    guidefontsize=12,tickfontsize=9, bar_width=0.5,
    text=[("$i", :bottom, RGB{Float64}(0.1, .2, .6), 11) for i in Data]
)

# savefig(raw"C:\Users\hemad\Desktop\Master\Experiments\Exp3\f0_Groups.png")

boxplot([[1,4,3,2,2,6], [1,7,1,5,9,6]])
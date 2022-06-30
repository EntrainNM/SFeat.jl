using TextGrid
file = raw"C:\Users\hemad\Desktop\Master\ExtractFeatures\Before_After_Finished\CASD001_MAW_thesis_session_1\CASD001_MAW_thesis_session_1_Transcribed.TextGrid"
interval = extract(file)

#-------------- accociate speaker segments with words
# S1Words is a vector containing start and end stamps of S1' segments, number of words, and a vector containing end stamps of each word
# Note: if a word ends withing a S1 segment, that word is considered to be part of that particular S1 segment
# eventaully, I will use S1Words variable to find the number of words said by S1 in time segments (5s, 10s,...)

# when is S1 speaking
S1Location = [("S1" in interval[1][i]) for i in 1:length(interval[1])]
timedWords = Vector{Vector{Any}}(undef,length(interval[1]))

# skip <1.0s segments
minSegment = 1.0
for i in 1:length(S1Location)
    test = 0
    endStamp = []
    for n in 1:length(interval[10])
        #  (if word ends withing S1 ith segment)                                             & (segment is longer than 1 second)
        if ((interval[1][i][1]<interval[10][n][2]) & (interval[10][n][2]<interval[1][i][2])) & ((interval[1][i][2]-interval[1][i][1]) > minSegment)
            test += 1
            append!( endStamp, interval[10][n][2] )
        end
    end
    # S1Location[i] ? println("S1 has ",test," words") : nothing
    timedWords[i] = [i,interval[1][i][1],interval[1][i][2],test,endStamp]
end
# [S1 location, start, end, # of words, [words end timestamps]]
S1Words = timedWords[S1Location]

#----------- words end stamps of S1: store the end time of each words S1 said
endStampsS1 = []
for i in 1:length(S1Words)
    for n in 1:length(S1Words[i][5])
        append!(endStampsS1,S1Words[i][5][n])
    end
end
endStampsS1

#--------------- experiment 1: extracting WPM for S1 in a 5s slide (no turn taking)
seconds = 5.0
slides = zeros(trunc(Int,(interval[10][end][2])/seconds)+1) # how many 5 seconds sound file contains
slideWords = Vector{Vector{Any}}(undef,length(slides))

plot1 = []
for i in 1:length(slides)
    test = 0
    for m in 1:length(endStampsS1)
        if ((seconds*(i-1)<endStampsS1[m]) & (endStampsS1[m]<seconds*i))
            test += 1
        end
    end
    # println("slide #",i," contains ",test," words")
    append!(plot1,test)
end
plot1
using Plots
plot(collect(1:length(plot1))[plot1.!=0],plot1[plot1.!=0],background_color=RGB{Float64}(0.466,0.117,0.560),
     foreground_color=:white,
     seriescolor=RGB{Float64}(0.95,0.9,0.1),
     xguide=string(seconds)*" s intervals",
     yguide="# of words said",
     label="S1"
     )

#------------------------------------------------ S2
S2Location = [("S2" in interval[5][i]) for i in 1:length(interval[5])]
timedWords = Vector{Vector{Any}}(undef,length(interval[5]))
for i in 1:length(S2Location)
    test = 0
    endStamp = []
    for n in 1:length(interval[11])
        # if word ends withing S2 ith segment
        if ((interval[5][i][1]<interval[11][n][2]) & (interval[11][n][2]<interval[5][i][2])) & ((interval[5][i][2]-interval[5][i][1]) > minSegment)
            test += 1
            append!( endStamp, interval[11][n][2] )
        end
    end
    timedWords[i] = [i,interval[5][i][1],interval[5][i][2],test,endStamp]
end
S2Words = timedWords[S2Location]


#----------- words end stamps of S2
# endStamps = Vector{Float64}(undef,length(interval[10]))
endStampsS2 = []
for i in 1:length(S2Words)
    for n in 1:length(S2Words[i][5])
        append!(endStampsS2,S2Words[i][5][n])
    end
end
endStampsS2

#--------------- Attepm 0: extracting WPM for S2
seconds = 5.0
slides = zeros(trunc(Int,(interval[11][end][2])/seconds)+1) # how many 5 seconds sound file contains
slideWords = Vector{Vector{Any}}(undef,length(slides))

plot2 = []
for i in 1:length(slides)
    temp = 0
    for m in 1:length(endStampsS2)
        if ((seconds*(i-1)<endStampsS2[m]) & (endStampsS2[m]<seconds*i))
            temp += 1
        end
    end
    # println("slide #",i," contains ",test," words")
    append!(plot2,temp)
end

plot!(collect(1:length(plot2))[plot2.!=0],
      plot2[plot2.!=0], label="S2",
      seriescolor=RGB{Float64}(0.1,0.6,0.9))

plot!(yticks=0:2:maximum(maximum.([plot1,plot2])))

# savefig(raw"C:\Users\hemad\Desktop\Master\Azure\Transcriptions\calculation\WPM\A026\WPM.png")

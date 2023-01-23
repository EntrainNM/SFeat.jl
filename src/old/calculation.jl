using TextGrid
# word per minute for S1 for each S1 interval
file = raw"C:\Users\hemad\Desktop\Master\GoogleSpeech\examples\E1\A032_Sarah_edited.TextGrid"
interval = extract(file)

for i in 1:length(interval[1])
    test = 0
    for n in 1:length(interval[10])
        if ((interval[1][i][1]<interval[10][n][1]) & (interval[10][n][1]<interval[1][i][2]))
            test += 1
        end
    end
    val = test/(interval[1][i][2]-interval[1][i][1])*60
    println("interval ",i," \"",interval[1][i][3],'"'," words: ",test," WPM: ",val)
end


#----------------- WPM for each speaker in 5s intervals
# for each speaker (i.e. S1, S2) count WPM the particular person achived
# over 5s intervals

len = length(interval[1])

S1 = fill(-1.0, (length(len), 2))

for (i,n) in zip(interval[1],(1:len))
    if i[3]== "S1"
        S1[n,:] = interval[1][n][1:2]
    end
end

interval[1][1][1:2]'

[S1[i,:] != [-1.0,-1.0] for i in 1:len]

filter!(x->[-1.0,-1.0],S1)
filter!(x->x≠[-1.0,-1.0],S1)


#-----------------word per minute in 5s intervals for both speakers
slides = zeros(trunc(Int,(interval[10][end][2])/5)+1)
for n in 1:length(interval[10])
    slides[trunc(Int,interval[10][n][2]/5)+1] += 1
end
plot(slides,background_color=RGB{Float64}(0.466,0.117,0.560),
     foreground_color=:white,
     seriescolor=RGB{Float64}(0.94,0.792,0.203),
     xguide="5 intervals",
     yguide="word per minutte",
     legend=false
     )



#----------testing
slides = zeros(trunc(Int,(interval[10][end][2])/5)+1)
for i in 1:length(interval[10])
    slides[trunc(Int, interval[10][i][2]/5+1)] += 1
end
using Plots

plot(slides,background_color=RGB{Float64}(0.466,0.117,0.560),
     foreground_color=:white,
     seriescolor=RGB{Float64}(0.94,0.792,0.203),
     xguide="5 intervals",
     yguide="word per minutte",
     legend=false
     )

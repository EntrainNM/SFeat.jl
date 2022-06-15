
#".\\src\\testing\\withWords.TextGrid"
#input = raw".\\src\\testing\\withWords.TextGrid"
input = raw"C:\Users\hemad\Desktop\Master\GoogleSpeech\Example1\file2\A032_Sarah_edited.TextGrid"
f = open(input, "r")
#CHECK FILE TYPE
occursin("ooTextFile", readline(f)) ? print("Successuflly opened ooTextFile\n") : print("File type NOT: \"ooTextFile\n")#line#1
#CHECK OBJECT CLASS
if !(readline(f) == "Object class = \"TextGrid\"")#line#2
    throw(UndefVarError(:NotTextGridFile))
end

readline(f)#SKIP BLANK LINE (line#3)
#READ START TIME
xmin = parse(Float64,readline(f)[8:end])#line#4
#READ END TIME
xmax = parse(Float64,readline(f)[8:end])#line#5

#READ TIERS INFO
tiers = occursin("tiers? <exists>", readline(f))#line#6
tierSize = parse(Int64,readline(f)[8:end])#line#7

#CREATE VECTOR VARIABLES
class = Array{String}(undef, 1, tierSize)
name = Array{String}(undef, 1, tierSize)
xmin = Array{Float64}(undef, 1, tierSize)
xmax = Array{Float64}(undef, 1, tierSize)
intervalSize = Array{Int64}(undef, 1, tierSize)
interval = Vector{Vector}(undef, tierSize)

readline(f)#SKIP "item[]" (line#8)

for i in 1:tierSize
    readline(f)#SKIP "item[i]" (line#9....)
    println("tier#",i)
    # class[i] = readline(f)[18:end-2]#println("class: " * readline(f)[18:end-2])
    # name[i] = readline(f)[17:end-2]#println("name: " * readline(f)[17:end-2])
    # xmin[i] = parse(Float64,readline(f)[15:end])#println("xmin: " * readline(f)[15:end])
    # xmax[i] = parse(Float64,readline(f)[15:end])#println("xmax: " * readline(f)[15:end])
    # intervalSize[i] = parse(Int64,readline(f)[26:end])#println("intervalSize: " * readline(f)[26:end])

    println("class: " * readline(f)[18:end-2])
    println("name: " * readline(f)[17:end-1])
    println("xmin: " * readline(f)[15:end])
    println("xmax: " * readline(f)[15:end])
    println("intervalSize: " * readline(f)[26:end])

    #intervalLines = Vector{Any}(undef,intervalSize[i])

    # for j in 1:intervalSize[i]
    #     #println(readline(f),readline(f),readline(f),readline(f),"\n")
    #     readline(f)#SKIP "intervals [j]:" (line#15)
    #     #println([readline(f)[19:end],readline(f)[19:end],readline(f)[21:end-2]])
    #     intervalLines[j] = [parse(Float64,readline(f)[19:end]),
    #                         parse(Float64,readline(f)[19:end]),
    #                         readline(f)[21:end-1]]
    #     #append!(interval,[readline(f)[19:end],readline(f)[19:end],readline(f)[21:end-2]])
    #     if(j == intervalSize[i])
    #         interval[i] = copy(intervalLines)
    #     end
    # end
end
close(f)


# for i in 1:length(interval[1])
#     test = 0
#     for n in 1:length(interval[7])
#         if ((interval[1][i][1]<interval[7][n][1]) & (interval[7][n][1]<interval[1][i][2]))
#             test += 1
#         end
#     end
#     val = test/(interval[1][i][2]-interval[1][i][1])*60
#     println("interval ",i," \"",interval[1][i][3],'"'," words: ",test," WPM: ",val)
# end









#
#
# function WPM(input)
#     f = open(input, "r")
#     #CHECK FILE TYPE
#     occursin("ooTextFile", readline(f)) ? print("Successuflly opened ooTextFile") : print("File type NOT: \"ooTextFile")#line#1
#     #CHECK OBJECT CLASS
#     if !(readline(f) == "Object class = \"TextGrid\"")#line#2
#         throw(UndefVarError(:NotTextGridFile))
#     end
#
#     readline(f)#SKIP BLANK LINE (line#3)
#     #READ START TIME
#     xmin = parse(Float64,readline(f)[8:end])#line#4
#     #READ END TIME
#     xmax = parse(Float64,readline(f)[8:end])#line#5
#
#     #READ TIERS INFO
#     tiers = occursin("tiers? <exists>", readline(f))#line#6
#     tierSize = parse(Int64,readline(f)[8:end])#line#7
#
#     #CREATE VECTOR VARIABLES
#     class = Array{String}(undef, 1, tierSize)
#     name = Array{String}(undef, 1, tierSize)
#     xmin = Array{Float64}(undef, 1, tierSize)
#     xmax = Array{Float64}(undef, 1, tierSize)
#     intervalSize = Array{Int64}(undef, 1, tierSize)
#     interval = Vector{Vector}(undef, tierSize)
#
#     readline(f)#SKIP "item[]" (line#8)
#
#     for i in 1:tierSize
#         readline(f)#SKIP "item[i]" (line#9....)
#         class[i] = readline(f)[18:end-2]#println("class: " * readline(f)[18:end-2])
#         name[i] = readline(f)[17:end-2]#println("name: " * readline(f)[17:end-2])
#         xmin[i] = parse(Float64,readline(f)[15:end])#println("xmin: " * readline(f)[15:end])
#         xmax[i] = parse(Float64,readline(f)[15:end])#println("xmax: " * readline(f)[15:end])
#         intervalSize[i] = parse(Int64,readline(f)[26:end])#println("intervalSize: " * readline(f)[26:end])
#
#         intervalLines = Vector{Any}(undef,intervalSize[i])
#         println("tier#",i)
#         for j in 1:intervalSize[i]
#             #println(readline(f),readline(f),readline(f),readline(f),"\n")
#             readline(f)#SKIP "intervals [j]:" (line#15)
#             #println([readline(f)[19:end],readline(f)[19:end],readline(f)[21:end-2]])
#             intervalLines[j] = [parse(Float64,readline(f)[19:end]),
#                                 parse(Float64,readline(f)[19:end]),
#                                 readline(f)[21:end-1]]
#             #append!(interval,[readline(f)[19:end],readline(f)[19:end],readline(f)[21:end-2]])
#             if(j == intervalSize[i])
#                 interval[i] = copy(intervalLines)
#             end
#         end
#     end
#     close(f)
# end
# input = raw"C:\Users\hemad\Desktop\Master\GoogleSpeech\Example1\file2\A032_Sarah_edited.TextGrid"
# WPM(input)
#
#
#
#
# #=
# for each data in item 1 (interval[1])
# find number of words in item 7
# =#
#
# for i in 1:length(interval[1])
#     test = 0
#     for n in 1:length(interval[7])
#         if ((interval[1][i][1]<interval[7][n][1]) & (interval[7][n][1]<interval[1][i][2]))
#             test += 1
#         end
#     end
#     val = test/(interval[1][i][2]-interval[1][i][1])*60
#     println("interval ",i," \"",interval[1][i][3],'"'," words: ",test," WPM: ",val)
# end

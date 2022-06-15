

using DelimitedFiles, TextGrid

TextGridFile = raw"C:\Users\hemad\Desktop\Master\calculation\syllables\CASD001_07112017_Transcribed.TextGrid"
speakerOrder = 2
item = 12

function insertSyllables(TextGridFile, speakerOrder, item)
    # save new TextGrid file in TextGridFile's location
    output = TextGridFile[begin:findlast(".", TextGridFile)[1]-1]*"S$speakerOrder"*"_copy.TextGrid"
    interval = extract(TextGridFile)

    speakerOrder == 1 ? wordSource = interval[10] : wordSource = interval[11]

    # set item info
    class = "IntervalTier"
    name = "Syl S"*string(speakerOrder)
    size1 = length(wordSource)
    xmin = round(wordSource[1][1], digits=3)
    xmax = round(wordSource[end][2], digits=3)

    open(output, "a") do file
        # add annotaiton information
        write(file, " "^4*"item ["*string(item)*"]:\n")
        write(file, " "^8*"class = \""*class*"\" \n")
        write(file, " "^8*"name = \""*name*"\" \n")
        write(file, " "^8*"xmin = "*string(xmin)*" \n")
        write(file, " "^8*"xmax = "*string(xmax)*" \n")
        write(file, " "^8*"intervals: size = "*string(size1)*" \n")
        count = 0
        for n in 1:length(wordSource) # each word segment
            # insert syllables count for each word
            count += 1

            write(file, " "^8*"intervals ["*string(count)*"]:\n") #interval[""]

            write(file, " "^12*"xmin = "*string(wordSource[n][1])*" \n") #xmin = ""

            write(file, " "^12*"xmax = "*string(wordSource[n][2])*" \n") #xmax = ""

            write(file, " "^12*"text = \""*string(sylCnt(wordSource[n][3]))*"\" \n") #text = ""
        end

    end
    return nothing
end

insertSyllables(TextGridFile, speakerOrder, item)
# sylCnt("accessibility")
# insertTranscription(TextGridFile, speakerOrder, item)

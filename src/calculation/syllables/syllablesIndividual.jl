

# Steps to insert syllalbes count into TextGrid file, TextGrid file must have S1 and S2 words transcribed in item 10, and 11 respectively
using TextGrid, DelimitedFiles

# 1 - insert syllalbes count for S1 and S2 into temporary TextGrid file, item # 12 and 13 respectively
TextGridFile = TextGridFile = raw"C:\Users\hemad\Desktop\Master\calculation\syllables\example2\CNT017_07032019_Transcribed.TextGrid"
for (speakerOrder,itemNum) in zip((1,2),(12,13))
    insertSyllables(TextGridFile, speakerOrder, itemNum)
end

# 2 - combied the 2 TextGrid items (item 12 and 13) into a new TextGrid file
dest = TextGridFile[1:findlast('_', TextGridFile)-1]*".TextGrid" # create new TextGrid file
# find TextGrid files to combine
S1syll = TextGridFile[1:findlast('.', TextGridFile)-1]*"S1_copy.TextGrid"
S2syll = TextGridFile[1:findlast('.', TextGridFile)-1]*"S2_copy.TextGrid"


# 3 - write everthing to the new TextGrid file
first = read(TextGridFile, String)
second = read(S1syll, String)
third = read(S2syll, String)
write(dest, first*second*third)


# 4 - replace "size = 11" with "size = 13"
temp = readlines(dest)
output = dest
temp[7] = "size = 13"
open(output, "w") do file
    for l in temp
        write(file, l*"\n")
    end
end

try
    rm(S1syll)
    rm(S2syll)
    println("Temporaray files were deleted successfully!")
catch
    println("Temporaray files already deleted!")
end

"""
sylCnt() - return the number of syllables of a word
"""

function sylCnt(word)
    syllableCount = 0
    vowels = "aeiouy"
    if word[1] in vowels
        syllableCount += 1
    end

    for i in 2:length(word)
        if occursin(word[i],vowels) && !(occursin(word[i - 1],vowels))
            syllableCount += 1
        end
    end

    if word[end]=='e'
        syllableCount -= 1
    end

    if (length(word)>2) && (word[end-1:end] == "le") && (occursin(word[end-2],vowels))
        syllableCount +=1
    end

    if syllableCount == 0
        syllableCount = 1
    end

    return syllableCount
end

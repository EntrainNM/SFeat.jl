# Extract pitch from file (first parameter) and write it out to a text file
# C:\Users\hemad\.julia\dev\SFeat\src\extraFiles\Praat.exe --run f0.praat.praat Temp.wav Temp.features .\ 0.01 200 500
# f0 RANGES:
# child: 100-450?
# female: 110-310?
# male: 70-260?

#DEFINE INPUT VARIABLES
form PitchExtractor
    sentence sound_file_name
    sentence pitch_file_name
    sentence Directory
    positive time_step
    comment ---------------- F0 Settings:
    positive f0_minimum
    positive f0_maximum
endform

#READ INPUT FILE
# echo Reading from 'Directory$''sound_file_name$'
Read from file... 'Directory$''sound_file_name$'
sound = selected("Sound")
tmin = Get start time
tmax = Get end time

#EXTRACT PITCH
# To Pitch (ac)... 0.01 f0_minimum 15 yes 0.03 0.45 0.01 0.35 0.14 f0_maximum
To Pitch (ac)... 0.01 f0_minimum 15 yes 0.03 0.45 0.01 0.35 0.14 f0_maximum

# To Pitch... 0.01 f0_minimum f0_maximum
Rename... pitch

filename$ = left$ (sound_file_name$,4)
# echo 'sound_file_name$'
f0_min$ = string$ (f0_minimum)
f0_max$ = string$ (f0_maximum)
# echo 'f0_min$'
# echo 'f0_max$'


select Sound 'filename$'


filedelete 'Directory$''pitch_file_name$'
for i to (tmax-tmin)/time_step

    time = tmin +i*time_step
	select Pitch pitch
	pitch = Get value at time... time Hertz Linear


    if pitch <> undefined
		# pitch = 0
        fileappend "'Directory$''pitch_file_name$'"  'time:3', 'pitch:3',  'newline$'
    endif
	# 	voic = 0;
	# else
	# 	voic = 1;
	# endif


	# fileappend "'Directory$''pitch_file_name$'"  'time:3', 'pitch:3',  'newline$'

endfor

# REMOVE SOUND FILE SEGMENT
filedelete 'Directory$''sound_file_name$'

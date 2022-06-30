# Extract pitch from file (first parameter) and write it out to a text file
# (second parameter).

#DEFINE INPUT VARIABLES
form PitchExtractor
    sentence sound_file_name
    sentence pitch_file_name
    sentence Directory
    positive time_step 0.01
endform

#READ INPUT FILE
echo Reading from 'Directory$''sound_file_name$'
Read from file... 'Directory$''sound_file_name$'
sound = selected("Sound")
tmin = Get start time
tmax = Get end time

#EXTRACT PITCH
#To Pitch... 0.01 75 600
#To Pitch (ac)... timeStep pitchFloorHz numCand veryAccurate silenceThresh voicingThresh octaveCost octaveJumpCost voicedUnvoicedCost pitchCeiling
To Pitch (ac)...   0.005       75         15        on           0.03           0.45        0.01         0.35            0.25              600
Rename... pitch
#Kill octave jumps
#pitch = selected ("Pitch")

filename$ = left$ (sound_file_name$,4)
echo 'filename$'

select Sound 'filename$'
# To Formant (robust)... 0.001 15 8000 0.025 50 1 100 0.01
To Formant (burg)... 0.001 5 5000 0.05 50
Rename... formant

filedelete 'Directory$''pitch_file_name$'
for i to (tmax-tmin)/time_step

    time = tmin +i*time_step
	select Pitch pitch
	pitch = Get value at time... time Hertz Linear
	select Formant formant

    formant1 = Get value at time... 1 time Hertz Linear
	formant2 = Get value at time... 2 time Hertz Linear
	formant3 = Get value at time... 3 time Hertz Linear
	formant4 = Get value at time... 4 time Hertz Linear
	formant5 = Get value at time... 5 time Hertz Linear
	formant6 = Get value at time... 6 time Hertz Linear
	formant7 = Get value at time... 7 time Hertz Linear
	formant8 = Get value at time... 8 time Hertz Linear
	formant9 = Get value at time... 9 time Hertz Linear
	formant10 = Get value at time... 10 time Hertz Linear
    formant11 = Get value at time... 11 time Hertz Linear
	formant12 = Get value at time... 12 time Hertz Linear
	formant13 = Get value at time... 13 time Hertz Linear
	formant14 = Get value at time... 14 time Hertz Linear
	formant15 = Get value at time... 15 time Hertz Linear

    if pitch = undefined
		pitch = 0
		voic = 0;
	else
		voic = 1;
	endif

    if formant1 = undefined
		formant1 = 0;
	endif

    if formant2 = undefined
		formant2 = 0;
	endif

    if formant3 = undefined
		formant3 = 0;
	endif

    if formant4 = undefined
		formant4 = 0;
	endif

    if formant5 = undefined
		formant5 = 0;
	endif

    if formant6 = undefined
		formant6 = 0;
	endif

    if formant7 = undefined
		formant7 = 0;
	endif

    if formant8 = undefined
		formant8 = 0;
	endif

    if formant9 = undefined
		formant9 = 0;
	endif

    if formant10 = undefined
		formant10 = 0;
	endif

    if formant11 = undefined
		formant11 = 0;
	endif

    if formant12 = undefined
		formant12 = 0;
	endif

    if formant13 = undefined
		formant13 = 0;
	endif

    if formant14 = undefined
		formant14 = 0;
	endif

    if formant15 = undefined
		formant15 = 0;
	endif


	fileappend "'Directory$''pitch_file_name$'"  'time:3', 'voic:1', 'pitch:3', 'formant1:3', 'formant2:3', 'formant3:3' 'formant4:3' 'formant5:3' 'formant6:3' 'formant7:3' 'formant8:3' 'formant9:3' 'formant10:3' 'formant11:3', 'formant12:3', 'formant13:3' 'formant14:3' 'formant15:3' 'newline$'

	#fileappend "'Directory$''pitch_file_name$'" 'time:3', 'voic:1', 'pitch:3'

endfor
